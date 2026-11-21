# Restart Test（Studio 本地插件）

已从 Creator Store 下架（停止公开分发）：[Restart Test](https://create.roblox.com/store/asset/133862099314475/Restart-Test)，作者 `heixiaogu`，资源 ID `133862099314475`。线上发布记录见 `release.json`。

**当前为预览版**：部分 Studio 环境曾出现停止测试时挂起，原因尚未定位。有限轮次的启动和重启测试通过，不代表已完成稳定性验收；详见 `DIAGNOSIS.md`。

安装商店版前，先停止测试，备份并移走 `~/Documents/Roblox/Plugins/RestartTest.rbxmx`，然后重新打开 Studio，避免本地版和线上版重复运行。商店版本不需要运行下方本地安装脚本；本地安装脚本保留用于源码开发。

普通单人 Play 测试中点击 **Restart Test**：停止测试，确认回到 Edit 且原测试连接全部断开，等待默认 **1 秒**，然后从出生点重新开始 Play。Edit 中点击直接开始 Play。

**Restart Settings** 菜单可选择等待 1、2、3 秒，设置保存在本地。等待给 Rojo 留出同步余量，插件不会检测或保证 Rojo 已同步完成；使用前请先保存源码并确认 Rojo 显示 Connected。插件不启动、重连或更改 Rojo。

## 安装和更新

在本目录运行：

```sh
python3 build.py --install
```

生成本目录的 `RestartTest.rbxmx` 并安装到 `~/Documents/Roblox/Plugins/RestartTest.rbxmx`。可用 `--plugins-dir /absolute/path` 指定其他本地插件目录。覆盖旧版本前将其备份到插件目录下的 `RestartTest.backups/`，备份扩展名为 `.bak`，不会作为插件加载。

**每次更新文件后，已打开的 Studio 都必须重新加载插件，即使按钮已经显示。** 先停止测试，在 Explorer 的 `PluginDebugService` 下找到 `user_RestartTest.rbxmx`，使用右键 **Reload Plugin**。也可以保存工程后重新打开 Studio；不要将内存中的旧代码 Save 回插件文件。

编辑端仍运行旧文件、测试端从磁盘加载新文件时，Studio 会把两者视为不同的插件通信身份，握手不能互通。这个组合已实际复现；测试本身可能正常启动，但旧版协调器会报告 60 秒超时。新版会比对构建编号，直接提示停止测试并 Reload Plugin。

保持 Studio Settings → Studio → **Load User Plugins In Run Modes** 开启。按钮在 Plugins 工具栏和 Plugins → Restart Test 菜单中；也可以在 Studio 的 Customize Shortcuts 中为 `Restart Test` 动作自行绑定快捷键，插件不会占用默认按键。

在 `#CL_DEV` 的 **Customize Shortcuts** 中将 **Restart Onboarding Test** 绑定到 `F4`。单人试玩中按 `F4` 会重开 Play，载入带有一条开场鱼的全新隔离存档，并直接从放养引导开始。普通的 **Restart Test** 动作仍启动常规试玩。

## 边界

- 只支持普通单人 Play，不支持 Run/F8、Server & Clients 或 Team Test。不保留角色位置、背包临时状态等运行数据。
- 编辑端协调器通过 PluginConnectionService 与同一工程的客户端和服务端通信；只有服务端调用 EndTest，编辑端等待停止完成后调用 ExecutePlayModeAsync。重启指令不写入跨窗口共享设置。
- 重启期间的重复点击被忽略；原生 Stop 不会触发重启。未完成加载的测试、缺少插件连接或不支持的模式会输出 Warning 并取消。
- 停止或启动等待最多 60 秒；失败后不会重复停止或启动。等待时若用户已经手动启动新测试，保留新测试并取消插件的自动启动。
- 插件只在 Studio 中运行，不向游戏实例树插入脚本或 UI，不发布或保存工程。

卸载：停止测试、退出 Studio 后移除本地插件目录中的 `RestartTest.rbxmx`，再打开 Studio。恢复旧版本：将备份文件复制回该路径。

## 检查

```sh
selene init.server.luau Controller.luau Controller.test.luau
luau Controller.test.luau
python3 build.py
```

`build.py` 会验证 XML 解析后的两份 Source 与源码完全一致。生命周期测试覆盖：Edit 启动、停止确认及完整延时、设置延时、连续三次重启、重复点击、普通 Stop、停止超时、启动失败、新测试接管、插件卸载、不支持模式、缺失连接及独立窗口协调器。

构建文件还包含由两份源码生成的 `BuildId`。自动化验收可读取插件入口 Script 的 `Busy` 属性，并触发它的 `RequestRestart` BindableEvent；这个入口与工具栏按钮调用同一个函数，且保留消息发送需要的插件身份。入口位于 `PluginDebugService`，不放入游戏实例树，也不接受执行任意代码的参数。

实际 Studio 验收需按项目 `tools/README.md` 取得共享锁，测试结束 Stop 并确认 Edit 后释放。首次安装热加载未成功时，需重新打开 Studio 才能验证编辑端与测试端的完整交互。
