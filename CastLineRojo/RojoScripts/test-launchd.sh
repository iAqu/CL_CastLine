#!/usr/bin/env bash
# Real macOS integration test. Uses an isolated project and an OS-assigned port.
set -euo pipefail
[[ "$(uname -s)" == Darwin ]] || { echo 'Requires macOS launchd'; exit 1; }

script_dir="$(cd "$(dirname "$0")" && pwd)"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/rojo-manager-test.XXXXXX")/project with spaces"
project="ManagerCheck$$"
label="local.$(printf '%s' "$project" | tr '[:upper:]' '[:lower:]').rojo"
port="$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1]); s.close()')"
mkdir -p "$fixture/RojoScripts"
cp "$script_dir/rojo-manager.sh" "$fixture/RojoScripts/rojo-manager.sh"
printf 'PROJECTS=("%s|.|%s")\n' "$project" "$port" >"$fixture/RojoScripts/rojo-projects.conf"
printf '{"name":"ManagerCheck","tree":{"$className":"DataModel"}}\n' >"$fixture/default.project.json"
if [[ -f "$script_dir/../aftman.toml" ]]; then
  cp "$script_dir/../aftman.toml" "$fixture/aftman.toml"
fi

cleanup() {
  # Remove only this test's unique launchd job; preserve files on failure for inspection.
  launchctl remove "$label" >/dev/null 2>&1 || true
}
trap cleanup EXIT
cd "$fixture"

./RojoScripts/rojo-manager.sh start "$project"
first_pid="$(lsof -tiTCP:"$port" -sTCP:LISTEN | head -n 1)"
[[ -n "$first_pid" ]]
./RojoScripts/rojo-manager.sh status "$project" | grep -q 'RUNNING'
curl --noproxy '*' --max-time 3 -fsS "http://127.0.0.1:$port/api/rojo" >/dev/null

# A repeated start must preserve the current server and its connections.
./RojoScripts/rojo-manager.sh start "$project"
[[ "$(lsof -tiTCP:"$port" -sTCP:LISTEN | head -n 1)" == "$first_pid" ]]

# A failed server must restart without a command session holding it open.
launchctl kill SIGKILL "gui/$(id -u)/$label"
restarted=false
for ((i=0; i<40; i++)); do
  next_pid="$(lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null | head -n 1 || true)"
  if [[ -n "$next_pid" && "$next_pid" != "$first_pid" ]] && \
    curl --noproxy '*' --max-time 2 -fsS "http://127.0.0.1:$port/api/rojo" >/dev/null 2>&1; then
    restarted=true
    break
  fi
  sleep 0.5
done
[[ "$restarted" == true ]]
./RojoScripts/rojo-manager.sh status "$project" | grep -q 'RUNNING'

# Stopping must unload supervision, so it cannot respawn the server.
./RojoScripts/rojo-manager.sh stop "$project"
sleep 2
! lsof -tiTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1
! launchctl list "$label" >/dev/null 2>&1
./RojoScripts/rojo-manager.sh status "$project" | grep -q 'STOPPED'
echo "PASS: independent launch, repeat start, crash recovery, stop ($fixture)"
