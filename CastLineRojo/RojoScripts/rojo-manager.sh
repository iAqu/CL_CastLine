#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_FILE="$SCRIPT_DIR/rojo-projects.conf"
RUNTIME_DIR="$ROOT_DIR/.rojo-runtime"
LOG_DIR="$RUNTIME_DIR/logs"
PID_DIR="$RUNTIME_DIR/pids"

mkdir -p "$LOG_DIR" "$PID_DIR"

if [[ ! -f "$CONF_FILE" ]]; then
  print_error "未找到配置文件: $CONF_FILE"
  print_warn "请先执行: cp \"$SCRIPT_DIR/rojo-projects.example.conf\" \"$CONF_FILE\""
  exit 1
fi

# shellcheck disable=SC1090
source "$CONF_FILE"

RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

print_error() {
  echo -e "${RED}$*${RESET}"
}

print_warn() {
  echo -e "${YELLOW}$*${RESET}"
}

usage() {
  cat <<'EOF'
用法:
  ./RojoScripts/rojo-manager.sh list
  ./RojoScripts/rojo-manager.sh start [ProjectName]
  ./RojoScripts/rojo-manager.sh stop [ProjectName]
  ./RojoScripts/rojo-manager.sh restart [ProjectName]
  ./RojoScripts/rojo-manager.sh status [ProjectName]
  ./RojoScripts/rojo-manager.sh status-all
  ./RojoScripts/rojo-manager.sh start-all
  ./RojoScripts/rojo-manager.sh stop-all

示例:
  ./RojoScripts/rojo-manager.sh start
  ./RojoScripts/rojo-manager.sh stop
  ./RojoScripts/rojo-manager.sh restart
EOF
}

resolve_path() {
  local raw="$1"
  local target
  if [[ "$raw" = /* ]]; then
    target="$raw"
  else
    target="$ROOT_DIR/$raw"
  fi
  (
    cd "$target" >/dev/null 2>&1 && pwd -P
  ) || echo "$target"
}

find_project_spec() {
  local project="$1"
  local line name
  for line in "${PROJECTS[@]:-}"; do
    IFS='|' read -r name _ <<<"$line"
    if [[ "$name" == "$project" ]]; then
      echo "$line"
      return 0
    fi
  done
  return 1
}

find_current_project() {
  local current line name raw_path port abs_path
  current="$ROOT_DIR"
  for line in "${PROJECTS[@]:-}"; do
    IFS='|' read -r name raw_path port <<<"$line"
    abs_path="$(resolve_path "$raw_path")"
    if [[ "$abs_path" == "$current" ]]; then
      echo "$name"
      return 0
    fi
  done
  return 1
}

resolve_target_project() {
  local project="${1:-}"
  if [[ -n "$project" ]]; then
    echo "$project"
    return 0
  fi

  if project="$(find_current_project)"; then
    echo "$project"
    return 0
  fi

  print_error "无法根据当前目录自动识别项目。"
  print_warn "请检查 RojoScripts/rojo-projects.conf 的路径是否包含当前仓库路径: $ROOT_DIR"
  print_warn "或显式传入项目名，例如: ./RojoScripts/rojo-manager.sh start DigToBuild"
  exit 1
}

require_project() {
  local project="$1"
  if ! find_project_spec "$project" >/dev/null; then
    print_error "未定义项目: $project"
    echo "可用项目:"
    list_projects
    exit 1
  fi
}

project_path() {
  local project="$1"
  local spec name raw_path port
  spec="$(find_project_spec "$project")"
  IFS='|' read -r name raw_path port <<<"$spec"
  resolve_path "$raw_path"
}

project_port() {
  local project="$1"
  local spec name path port
  spec="$(find_project_spec "$project")"
  IFS='|' read -r name path port <<<"$spec"
  echo "$port"
}

pid_file() {
  local project="$1"
  echo "$PID_DIR/${project}.pid"
}

log_file() {
  local project="$1"
  echo "$LOG_DIR/${project}.log"
}

port_pid() {
  local port="$1"
  lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null | head -n 1
}

is_port_listening() {
  local port="$1"
  if [[ -n "$(port_pid "$port")" ]]; then
    return 0
  fi
  return 1
}

wait_for_port_state() {
  local port="$1"
  local expect="$2" # up | down
  local retries="${3:-20}"
  local delay="${4:-0.2}"
  local i
  for ((i = 0; i < retries; i++)); do
    if [[ "$expect" == "up" ]] && is_port_listening "$port"; then
      return 0
    fi
    if [[ "$expect" == "down" ]] && ! is_port_listening "$port"; then
      return 0
    fi
    sleep "$delay"
  done
  return 1
}

is_running() {
  local project="$1"
  local file
  file="$(pid_file "$project")"
  if [[ ! -f "$file" ]]; then
    return 1
  fi
  local pid
  pid="$(<"$file")"
  if [[ -z "$pid" ]]; then
    return 1
  fi
  if kill -0 "$pid" >/dev/null 2>&1; then
    return 0
  fi
  rm -f "$file"
  return 1
}

list_projects() {
  for line in "${PROJECTS[@]:-}"; do
    local key raw_path port
    IFS='|' read -r key raw_path port <<<"$line"
    local path
    path="$(resolve_path "$raw_path")"
    echo "- $key  path=$path  port=$port"
  done | sort
}

start_one() {
  local project="$1"
  require_project "$project"

  if is_running "$project"; then
    local running_pid
    running_pid="$(<"$(pid_file "$project")")"
    echo "[$project] 已在运行 (pid=$running_pid)"
    return 0
  fi

  local path port log pidf
  path="$(project_path "$project")"
  port="$(project_port "$project")"
  log="$(log_file "$project")"
  pidf="$(pid_file "$project")"

  if [[ ! -d "$path" ]]; then
    print_error "[$project] 项目路径不存在: $path"
    return 1
  fi

  if is_port_listening "$port"; then
    local occupied_pid
    occupied_pid="$(port_pid "$port")"
    print_error "[$project] 启动前检查失败: 端口 $port 已被占用 (pid=${occupied_pid:-unknown})"
    return 1
  fi

  pushd "$path" >/dev/null
  nohup rojo serve --port "$port" >>"$log" 2>&1 </dev/null &
  local pid=$!
  popd >/dev/null
  disown "$pid" 2>/dev/null || true
  echo "$pid" >"$pidf"

  pid="$(<"$pidf")"
  if kill -0 "$pid" >/dev/null 2>&1 && wait_for_port_state "$port" up; then
    echo "[$project] 启动成功: pid=$pid port=$port"
    echo "[$project] 日志: $log"
  else
    rm -f "$pidf"
    print_error "[$project] 启动后检查失败: 进程或端口未就绪，请检查日志: $log"
    return 1
  fi
}

stop_one() {
  local project="$1"
  require_project "$project"

  if ! is_running "$project"; then
    print_warn "[$project] 未运行"
    return 0
  fi

  local file pid port
  file="$(pid_file "$project")"
  pid="$(<"$file")"
  port="$(project_port "$project")"

  kill "$pid" >/dev/null 2>&1 || true
  sleep 1

  if kill -0 "$pid" >/dev/null 2>&1; then
    kill -9 "$pid" >/dev/null 2>&1 || true
  fi

  if kill -0 "$pid" >/dev/null 2>&1; then
    print_error "[$project] 停止后检查失败: 进程仍在运行 (pid=$pid)"
    return 1
  fi

  if ! wait_for_port_state "$port" down; then
    local occupied_pid
    occupied_pid="$(port_pid "$port")"
    print_error "[$project] 停止后检查失败: 端口 $port 仍被占用 (pid=${occupied_pid:-unknown})"
    return 1
  fi

  rm -f "$file"
  echo "[$project] 已停止并通过检查"
}

status_one() {
  local project="$1"
  require_project "$project"
  local port path
  port="$(project_port "$project")"
  path="$(project_path "$project")"
  if is_running "$project"; then
    local pid
    pid="$(<"$(pid_file "$project")")"
    echo "[$project] RUNNING pid=$pid port=$port path=$path"
  else
    echo "[$project] STOPPED port=$port path=$path"
  fi
}

start_all() {
  local line key path port
  for line in "${PROJECTS[@]:-}"; do
    IFS='|' read -r key path port <<<"$line"
    start_one "$key"
  done
}

stop_all() {
  local line key path port
  for line in "${PROJECTS[@]:-}"; do
    IFS='|' read -r key path port <<<"$line"
    stop_one "$key"
  done
}

cmd="${1:-}"
arg="${2:-}"

case "$cmd" in
  list)
    list_projects
    ;;
  start)
    start_one "$(resolve_target_project "$arg")"
    ;;
  stop)
    stop_one "$(resolve_target_project "$arg")"
    ;;
  restart)
    arg="$(resolve_target_project "$arg")"
    stop_one "$arg"
    start_one "$arg"
    ;;
  status)
    if [[ -n "$arg" ]]; then
      status_one "$arg"
    else
      status_one "$(resolve_target_project)"
    fi
    ;;
  status-all)
    for line in "${PROJECTS[@]:-}"; do
      IFS='|' read -r key _ <<<"$line"
      status_one "$key"
    done | sort
    ;;
  start-all)
    start_all
    ;;
  stop-all)
    stop_all
    ;;
  *)
    usage
    exit 1
    ;;
esac
