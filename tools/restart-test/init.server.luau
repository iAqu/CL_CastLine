-- Local Studio plugin. No scripts or instances are inserted into the place.
local RunService = game:GetService("RunService")
local StudioTestService = game:GetService("StudioTestService")
local PluginConnectionService = game:GetService("PluginConnectionService")
local HttpService = game:GetService("HttpService")
local Controller = require(script.Controller)
local BUILD_ID = script.BuildId.Value
local isCastLineDev = game.PlaceId == 84106335829275

local EDIT = Enum.PluginConnectionTargetType.Edit
local TEST = Enum.PluginConnectionTargetType.Test
local isEditor = PluginConnectionService:CanHaveConnectionType(TEST)
local alive = true
local bindings = {}
local peers = {}
local editConnection
local coordinator
local localBusy = false
local stopped = false
local delaySeconds = 1
local DELAY_KEY = "RestartDelaySeconds"
script:SetAttribute("Busy", false)

local function warning(message)
	warn("[Restart Test] " .. tostring(message))
end

local function readDelay()
	local ok, value = pcall(function()
		return plugin:GetSetting(DELAY_KEY)
	end)
	if ok and (value == 1 or value == 2 or value == 3) then
		delaySeconds = value
	end
end
readDelay()

if not isEditor and RunService:IsServer() then
	-- File updates can leave the editor on an older local-plugin identity.
	-- Test args cross that boundary even when PluginConnection messages cannot.
	task.spawn(function()
		local deadline = os.clock() + 5
		repeat
			local args = StudioTestService:GetTestArgs()
			if typeof(args) == "table" and args.plugin == "RestartTest" then
				if args.buildId ~= BUILD_ID then
					warning("编辑端与测试端的插件版本不一致。请停止测试，在 PluginDebugService 下对 user_RestartTest.rbxmx 执行 Reload Plugin，再重试。")
				end
				return
			end
			task.wait(0.1)
		until not alive or os.clock() >= deadline
	end)
end

local toolbar = plugin:CreateToolbar("Restart Test")
local restartButton = toolbar:CreateButton(
	"RestartTest",
	"停止当前单人测试，回到 Edit 并等待同步后重新开始；Edit 下直接开始。",
	"rbxasset://studio_svg_textures/Lua/FileSync/Dark/Standard/Refresh.png",
	"Restart Test"
)
restartButton.ClickableWhenViewportHidden = true
local settingsButton = toolbar:CreateButton(
	"RestartTestSettings",
	"设置回到 Edit 后的等待时间（不是 Rojo 同步完成检测）。",
	"rbxasset://studio_svg_textures/Shared/Navigation/Dark/Standard/Settings.png",
	"Restart Settings"
)
settingsButton.ClickableWhenViewportHidden = true

local function track(binding)
	table.insert(bindings, binding)
	return binding
end

local function send(connection, message)
	if not connection or not connection.Connected then
		return false
	end
	local ok, err = pcall(function()
		connection:SendMessage(HttpService:JSONEncode(message))
	end)
	if not ok then
		warning(err)
	end
	return ok
end

local function livePeers()
	local result = {}
	for connection, peer in peers do
		if connection.Connected then
			table.insert(result, peer)
		end
	end
	return result
end

local function setBusy(value)
	localBusy = value
	script:SetAttribute("Busy", value)
	restartButton:SetActive(value)
	if isEditor then
		for connection in peers do
			send(connection, { op = "busy", value = value })
		end
	end
end

local function startPlay(serial, onboarding)
	-- ExecutePlayModeAsync yields for the entire session, not just its startup.
	task.spawn(function()
		local ok, err = pcall(function()
			StudioTestService:ExecutePlayModeAsync({
				plugin = "RestartTest",
				buildId = BUILD_ID,
				castLineOnboarding = if onboarding then true else nil,
			})
		end)
		if not ok and alive then
			coordinator:fail(serial, "启动失败：" .. tostring(err))
		end
	end)
end

if isEditor then
	coordinator = Controller.new({
		now = os.clock,
		wait = task.wait,
		spawn = task.spawn,
		isEdit = function()
			return StudioTestService.EditModeActive
		end,
		peers = livePeers,
		connected = function(connection)
			return connection.Connected
		end,
		delay = function()
			return delaySeconds
		end,
		stopServer = function(server, serial)
			if not send(server.connection, { op = "stop", serial = serial }) then
				error("服务端连接已断开，取消重启。", 0)
			end
		end,
		startPlay = startPlay,
		busyChanged = setBusy,
		warning = warning,
	})
end

local function handleMessage(connection, message)
	if not alive or typeof(message) ~= "string" then
		return
	end
	local ok, data = pcall(function()
		return HttpService:JSONDecode(message)
	end)
	if not ok or typeof(data) ~= "table" then
		return
	end
	if isEditor then
		local peer = peers[connection]
		if not peer then
			return
		end
		if data.op == "hello" then
			peer.role = data.role
			peer.supported = data.supported == true
			send(connection, { op = "busy", value = coordinator.busy })
			send(connection, { op = "delay", value = delaySeconds })
		elseif data.op == "restart" then
			coordinator:request(isCastLineDev and data.castLineOnboarding == true)
		elseif data.op == "failure" and peer.role == "server" then
			coordinator:fail(data.serial, "停止失败：" .. tostring(data.message))
		elseif data.op == "setDelay" and (data.value == 1 or data.value == 2 or data.value == 3) then
			delaySeconds = data.value
			plugin:SetSetting(DELAY_KEY, delaySeconds)
			for target in peers do
				send(target, { op = "delay", value = delaySeconds })
			end
		end
	else
		if connection ~= editConnection then
			return
		end
		if data.op == "busy" then
			setBusy(data.value == true)
		elseif data.op == "delay" then
			delaySeconds = data.value
		elseif data.op == "stop" and RunService:IsServer() and not stopped then
			stopped = true
			local success, err = pcall(function()
				StudioTestService:EndTest({ plugin = "RestartTest", serial = data.serial })
			end)
			if not success then
				stopped = false
				send(connection, { op = "failure", serial = data.serial, message = tostring(err) })
			end
		end
	end
end

local function attach(connection)
	if not alive or not connection.Connected or peers[connection] then
		return
	end
	if isEditor then
		if connection.Type ~= TEST then
			return
		end
	else
		if connection.Type ~= EDIT then
			return
		end
		editConnection = connection
	end
	peers[connection] = { connection = connection, role = "unknown", supported = false }
	local binding = connection:BindToMessage(function(message)
		handleMessage(connection, message)
	end)
	track(binding)
	track(connection:GetPropertyChangedSignal("Connected"):Connect(function()
		if not connection.Connected then
			binding:Disconnect()
			peers[connection] = nil
			if connection == editConnection then
				editConnection = nil
			end
		end
	end))
	if not isEditor then
		-- Detached multiplayer clients can leave their test; ordinary Play Solo cannot.
		local canLeave = not RunService:IsServer() and StudioTestService:CanLeaveTest()
		send(connection, {
			op = "hello",
			role = if RunService:IsServer() then "server" else "client",
			supported = not RunService:IsRunMode() and not canLeave,
		})
	end
end

-- Subscribe before enumerating, so a startup connection cannot slip through.
track(PluginConnectionService.Connected:Connect(attach))
for _, connection in PluginConnectionService:GetPluginConnectionsOfType(if isEditor then TEST else EDIT) do
	attach(connection)
end

local function requestRestart(onboarding)
	if localBusy then
		return
	end
	local castLineOnboarding = isCastLineDev and onboarding == true
	if isEditor then
		coordinator:request(castLineOnboarding)
	elseif not send(editConnection, { op = "restart", castLineOnboarding = castLineOnboarding }) then
		warning("编辑端插件未连接，请检查 Load User Plugins In Run Modes 并重新启动测试。")
	end
end
track(restartButton.Click:Connect(requestRestart))
-- Narrow automation entry point, owned by the plugin rather than the game.
-- Keeping the binding here preserves the plugin identity used by SendMessage.
local requestEvent = Instance.new("BindableEvent")
requestEvent.Name = "RequestRestart"
requestEvent.Parent = script
track(requestEvent.Event:Connect(requestRestart))
-- Also expose the same action to Studio's native shortcut customization.
local restartAction = plugin:CreatePluginAction("RestartTest.Restart", "Restart Test", "停止并重新开始单人测试", "", true)
track(restartAction.Triggered:Connect(requestRestart))
local onboardingAction
if isCastLineDev then
	onboardingAction = plugin:CreatePluginAction(
		"RestartTest.CastLineOnboarding",
		"Restart Onboarding Test",
		"用全新测试存档重开 CastLine 新手引导",
		"",
		true
	)
	track(onboardingAction.Triggered:Connect(function()
		requestRestart(true)
	end))
end

local menu = plugin:CreatePluginMenu("RestartTest.DelayMenu", "Restart Test 等待时间", "")
local delayActions = {}
local plainDelayActions = {}
local checkedDelayActions = {}
for _, seconds in { 1, 2, 3 } do
	-- PluginAction.Text cannot be assigned with Plugin security. Set labels at creation.
	local plain = menu:AddNewAction("delay" .. seconds, seconds .. " 秒", "")
	local checked = menu:AddNewAction("currentDelay" .. seconds, "✓ " .. seconds .. " 秒", "")
	plainDelayActions[seconds] = plain
	checkedDelayActions[seconds] = checked
	delayActions[plain] = seconds
	delayActions[checked] = seconds
end

local function populateDelayMenu()
	menu:Clear()
	for _, seconds in { 1, 2, 3 } do
		menu:AddAction(if delaySeconds == seconds then checkedDelayActions[seconds] else plainDelayActions[seconds])
	end
end

track(settingsButton.Click:Connect(function()
	settingsButton:SetActive(false)
	populateDelayMenu()
	local selected = menu:ShowAsync()
	local value = delayActions[selected]
	if not value then
		return
	end
	if isEditor then
		delaySeconds = value
		plugin:SetSetting(DELAY_KEY, value)
		for connection in peers do
			send(connection, { op = "delay", value = value })
		end
	elseif not send(editConnection, { op = "setDelay", value = value }) then
		warning("编辑端插件未连接，未保存等待时间。")
	end
end))

plugin.Unloading:Connect(function()
	alive = false
	if coordinator then
		coordinator:destroy()
	end
	for _, binding in bindings do
		binding:Disconnect()
	end
	menu:Destroy()
	for action in delayActions do
		action:Destroy()
	end
	toolbar:Destroy()
	restartAction:Destroy()
	if onboardingAction then
		onboardingAction:Destroy()
	end
end)
