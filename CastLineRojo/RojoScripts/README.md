# Rojo 管理

在 `CastLineRojo` 目录执行：

```sh
./RojoScripts/rojo-manager.sh start CastLine
./RojoScripts/rojo-manager.sh status CastLine
./RojoScripts/rojo-manager.sh stop CastLine
```

macOS 使用当前用户的 `launchd` 托管服务，独立于启动命令和 Codex 终端会话；异常退出后会自动重启。停止时会卸载服务，避免再次拉起。此方式持续到用户注销或系统重启，之后重新执行 `start`。

在 Codex 内，`start` / `stop` 需要允许沙箱外执行才能管理 `launchd`。日志在 `.rojo-runtime/logs/<项目名>.log`；`status` 根据实际监听端口和项目路径判断状态，不依赖旧 PID 文件。相同项目重复 `start` 会保留现有服务。

CastLine 在 Studio 中连接 `localhost:34874`。已有 Studio 连接时不需要再次启动。重启服务后需在 Studio 插件中重新连接。

macOS 集成验证（隔离的临时项目与端口，测试异常退出后的自动恢复）：

```sh
bash RojoScripts/test-launchd.sh
```
