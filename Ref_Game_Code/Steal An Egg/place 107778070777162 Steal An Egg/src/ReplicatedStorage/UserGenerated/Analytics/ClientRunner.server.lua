-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local elapsed = os.clock()
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("RunService")

local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local VoiceChatServiceHelper = require(ReplicatedStorage.UserGenerated.Roblox.VoiceChatServiceHelper)
local ThreadJoin = require(ReplicatedStorage.UserGenerated.Concurrency.ThreadJoin)
local ClientKit = require(ReplicatedStorage.UserGenerated.Analytics.ClientKit)
local UTF8Sub = require(ReplicatedStorage.UserGenerated.Strings.UTF8Sub)
local DeviceForm = require(ReplicatedStorage.UserGenerated.Roblox.DeviceForm)
local LocalPlayer = Players.LocalPlayer
local elapsed2

function SafeGet(p1, p2, p3) -- line: 44
    local function v1(_, _) -- line: 45
        -- upvalues: p1 (copy), p2 (copy)
        return p1[p2]
    end

    local ok, result = pcall(v1, p1, p2)

    if ok then
        return result
    end

    return p3
end

function IsUWP() -- line: 51
    local function v2() -- line: 52
        return tostring({
            1
        }):match("^table: 0x(00000000%x+)$") ~= nil
    end

    local ok, result = pcall(v2)

    return ok and result
end

function IsWindows() -- line: 60
    -- upvalues: GuiService (copy)
    return SafeGet(GuiService, "IsWindows", false)
end

function IsLoaded() -- line: 64
    -- upvalues: LocalPlayer (copy)
    if not game:IsLoaded() then
        return false
    end

    local Character = LocalPlayer.Character

    if not Character then
        return false
    end

    return Character.PrimaryPart and Character:FindFirstChild("Humanoid")
end

task.spawn(function() -- line: 78
    -- upvalues: elapsed2 (ref)
    while not IsLoaded() do
        task.wait()
    end

    elapsed2 = os.clock()
end)

function GetStartTime() -- line: 85
    -- upvalues: elapsed (copy)
    local __StartTime = _G.__StartTime

    if type(__StartTime) == "number" then
        return __StartTime
    end

    return elapsed
end

function GetLoadDurationAsync(p6) -- line: 93
    -- upvalues: elapsed2 (ref)
    local elapsed

    while true do
        elapsed = elapsed2

        if elapsed then
            break
        end

        if p6 then
            return nil
        end

        task.wait()
    end

    return (math.max(0, elapsed - GetStartTime()))
end

function Build() -- line: 107
    -- upvalues: GuiService (copy), HttpService (copy), LocalizationService (copy), Stats (copy), TeleportService (copy), VoiceChatServiceHelper (copy), ThreadJoin (copy), UTF8Sub (copy), DeviceForm (copy), LocalPlayer (copy)
    local v4 = GetLoadDurationAsync(false)
    local v5 = os.time()
    local elapsed = os.clock()
    local ServerTimeNow = workspace:GetServerTimeNow()
    local v6 = elapsedTime()
    local GameSettings = UserSettings().GameSettings
    local GuiInset, GuiInset2 = GuiService:GetGuiInset()
    local v7

    local function v8() -- line: 126
        -- upvalues: v7 (ref), LocalPlayer (copy)
        local NetworkPing = LocalPlayer:GetNetworkPing()

        if NetworkPing > 0 then
            v7 = NetworkPing * 1000
        end
    end

    pcall(v8)

    local JoinData = LocalPlayer:GetJoinData()

    if JoinData.LaunchData ~= nil then
        local function v9() -- line: 134
            -- upvalues: JoinData (copy), HttpService (copy)
            JoinData.LaunchData = HttpService:JSONDecode(JoinData.LaunchData)
        end

        pcall(v9)
    end

    local t2

    if Stats.MemoryTrackingEnabled then
        t2 = {
            ContactsCount = Stats.ContactsCount,
            DataReceiveKbps = Stats.DataReceiveKbps,
            DataSendKbps = Stats.DataSendKbps,
            FrameTime = Stats.FrameTime,
            HeartbeatTime = Stats.HeartbeatTime,
            InstanceCount = Stats.InstanceCount,
            MovingPrimitivesCount = Stats.MovingPrimitivesCount,
            PhysicsReceiveKbps = Stats.PhysicsReceiveKbps,
            PhysicsSendKbps = Stats.PhysicsSendKbps,
            PhysicsStepTime = Stats.PhysicsStepTime,
            PrimitivesCount = Stats.PrimitivesCount,
            RenderCPUFrameTime = Stats.RenderCPUFrameTime,
            RenderGPUFrameTime = Stats.RenderGPUFrameTime,
            SceneDrawcallCount = Stats.SceneDrawcallCount,
            SceneTriangleCount = Stats.SceneTriangleCount,
            ShadowsDrawcallCount = Stats.ShadowsDrawcallCount,
            ShadowsTriangleCount = Stats.ShadowsTriangleCount,
            UI2DDrawcallCount = Stats.UI2DDrawcallCount,
            UI2DTriangleCount = Stats.UI2DTriangleCount,
            UI3DDrawcallCount = Stats.UI3DDrawcallCount,
            UI3DTriangleCount = Stats.UI3DTriangleCount
        }

        local t3 = {}

        for _, v10 in ipairs(Enum.DeveloperMemoryTag:GetEnumItems()) do
            local Name = v10.Name

            if Name == "PhysicsParts" then
                Name = "BaseParts"
            end

            t3[Name] = Stats:GetMemoryUsageMbForTag(v10)
        end

        t2.MemoryUsageMbForTag = t3
        t2.TotalMemoryUsageMb = Stats:GetTotalMemoryUsageMb()
    end

    local t4 = {
        System = {
            UWP = IsUWP(),
            Windows = IsWindows(),
            Time = v5,
            Clock = elapsed,
            ElapsedTime = v6,
            TimezoneOffset = os.date("%z"),
            Timezone = HttpService:UrlEncode((os.date("%Z"))),
            TimezoneDST = os.date("*t").isdst == true,
            HeapSize = gcinfo(),
            RobloxVersion = UTF8Sub(tostring(version()), 1, 20)
        },
        Game = {
            LoadingDuration = v4
        },
        LocalPlayer = {
            JoinData = JoinData,
            NetworkPing = v7
        },
        TeleportService = {
            TeleportData = TeleportService:GetLocalPlayerTeleportData()
        },
        Workspace = {
            ServerTimeNow = ServerTimeNow,
            RealPhysicsFPS = workspace:GetRealPhysicsFPS(),
            DistributedGameTime = workspace.DistributedGameTime,
            NumAwakeParts = workspace:GetNumAwakeParts(),
            PhysicsThrottling = workspace:GetPhysicsThrottling()
        },
        Stats = t2,
        UserInputService = {
            DeviceForm = DeviceForm.Get(),
            Platform = DeviceForm.GetPlatform()
        },
        GuiService = {
            IsTenFootInterface = GuiService:IsTenFootInterface(),
            TouchControlsEnabled = GuiService.TouchControlsEnabled,
            GuiInsetTopLeft = GuiInset,
            GuiInsetBotRight = GuiInset2,
            IsModalDialog = SafeGet(GuiService, "IsModalDialog", false),
            MenuIsOpen = GuiService.MenuIsOpen,
            PreferredTransparency = math.clamp(GuiService.PreferredTransparency, 0, 1),
            ReducedMotionEnabled = GuiService.ReducedMotionEnabled,
            CoreGuiNavigationEnabled = GuiService.CoreGuiNavigationEnabled,
            GuiNavigationEnabled = GuiService.GuiNavigationEnabled,
            AutoSelectGuiEnabled = GuiService.AutoSelectGuiEnabled
        },
        CurrentCamera = {
            ViewportSize = workspace.CurrentCamera.ViewportSize
        },
        LocalizationService = {
            RobloxLocaleId = LocalizationService.RobloxLocaleId:lower(),
            SystemLocaleId = UTF8Sub(LocalizationService.SystemLocaleId:lower(), 1, 1000)
        },
        VoiceChatService = {},
        UserSettings = {
            GameSettings = {
                ControlMode = GameSettings.ControlMode,
                VignetteEnabled = GameSettings.VignetteEnabled,
                ComputerCameraMovementMode = GameSettings.ComputerCameraMovementMode,
                ComputerMovementMode = GameSettings.ComputerMovementMode,
                GamepadCameraSensitivity = GameSettings.GamepadCameraSensitivity,
                MouseSensitivity = GameSettings.MouseSensitivity,
                RotationType = GameSettings.RotationType,
                SavedQualityLevel = GameSettings.SavedQualityLevel,
                TouchCameraMovementMode = GameSettings.TouchCameraMovementMode,
                TouchMovementMode = GameSettings.TouchMovementMode,
                InFullScreen = GameSettings:InFullScreen(),
                InStudioMode = GameSettings:InStudioMode()
            }
        }
    }
    local t7 = {}

    table.insert(t7, task.spawn(function() -- line: 262
        -- upvalues: t4 (copy), VoiceChatServiceHelper (copy), LocalPlayer (copy)
        t4.VoiceChatService.VoiceEnabled = VoiceChatServiceHelper.IsVoiceEnabledForUserIdAsync(LocalPlayer.UserId, false)
    end))

    for _, v12 in ipairs(t7) do
        ThreadJoin(v12)
    end

    return t4
end

local v13 = false

function Send() -- line: 278
    -- upvalues: ClientKit (copy), v13 (ref)
    if v13 then
        return true
    end

    v13 = true

    local function v14() -- line: 283
        -- upvalues: ClientKit (copy)
        local v15 = Build()

        ClientKit.AcceptRemote:FireServer(v15)
    end

    local v16 = pcall(v14)

    v13 = false

    return v16
end

local n1 = (-1e999)

GuiService.MenuOpened:Connect(function() -- line: 292
    -- upvalues: n1 (ref)
    local elapsed = os.clock()

    if elapsed - n1 > 15 then
        n1 = elapsed
        Send()
    end
end)
UserInputService.WindowFocusReleased:Connect(function() -- line: 300
    -- upvalues: n1 (ref)
    local elapsed = os.clock()

    if elapsed - n1 > 15 then
        n1 = elapsed
        Send()
    end
end)
task.spawn(function() -- line: 308
    while true do
        Send()
        task.wait(150 + 300 * math.random())
    end
end)
