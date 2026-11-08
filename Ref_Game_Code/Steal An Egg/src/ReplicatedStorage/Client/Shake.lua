-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local HapticService = game:GetService("HapticService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local PlatformController = require(ReplicatedStorage:WaitForChild("Client").PlatformController)
local Player = require(ReplicatedStorage.Shared.Player)
local v1 = Enum.RenderPriority.Camera.Value + 1
local t1 = {
    3.7, 41.2, 88.9
}
local Gamepad1 = Enum.UserInputType.Gamepad1
local t2 = {
    [Enum.VibrationMotor.Large] = 1,
    [Enum.VibrationMotor.Small] = 0.5
}
local t3 = {
    Fade = {
        1, 0.9952, 0.9808, 0.9569, 0.9239, 0.8819, 0.8315, 0.773,
        0.7071, 0.6344, 0.5556, 0.4714, 0.3827, 0.2903, 0.1951, 0.098,
        0
    },
    Pulse = {
        0, 0.1951, 0.3827, 0.5556, 0.7071, 0.8315, 0.9239, 0.9808,
        1, 0.9808, 0.9239, 0.8315, 0.7071, 0.5556, 0.3827, 0.1951,
        0
    }
}
local v2 = Random.new()
local v3
local t4 = {}

local function canShake() -- line: 71
    -- upvalues: GuiService (copy), Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil or CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        return false
    end

    return not GuiService.ReducedMotionEnabled
end

local function smoothstep(p1, p2, p3) -- line: 78
    local v5 = math.clamp((p3 - p1) / (p2 - p1), 0, 1)

    return v5 * v5 * (3 - v5 * 2)
end

local function anchorPosition(p4) -- line: 85
    -- upvalues: Player (copy)
    if typeof(p4) == "Vector3" then
        return p4
    end

    if p4:IsA("Player") then
        local v6 = Player.FindRootPart(p4)

        return if v6 ~= nil then v6.Position else nil
    end

    if p4:IsA("PVInstance") then
        return p4:GetPivot().Position
    end

    return if p4:IsA("Attachment") then p4.WorldPosition else nil
end

local function rangeGain(p5) -- line: 104
    -- upvalues: Player (copy), anchorPosition (copy)
    local v7 = Player.FindRootPart()
    local v8 = anchorPosition(p5.Center)

    if v7 == nil or v8 == nil then
        return 1
    end

    local Magnitude = (v8 - v7.Position).Magnitude

    if not (p5.Far < Magnitude) then
        if p5.Far <= p5.Near then
            return 1
        end

        local Near, Far = p5.Near, p5.Far
        local v10 = math.clamp((Magnitude - Near) / (Far - Near), 0, 1)
        local v11 = 1 - v10 * v10 * (3 - v10 * 2)

        if v11 > 0 then
            return v11
        end
    end

    return nil
end

local function envelopeAt(p6, p7) -- line: 121
    -- upvalues: t3 (copy)
    local v12 = t3[p7]
    local v13 = math.clamp(p6, 0, 1) * (#v12 - 1)
    local v14 = math.floor(v13) + 1
    local v17 = math.min(v14 + 1, #v12)

    return (math.lerp(v12[v14], v12[v17], v13 - (v14 - 1)))
end

local function sampleOffset(p8, p9) -- line: 129
    -- upvalues: t1 (copy)
    local v21 = p8.elapsed * 21 + p8.seed
    local v22 = table.create(#t1)

    for v23, v24 in t1 do
        v22[v23] = math.noise(v21, v24, p8.seed) * 2.2 * p9
    end

    return (Vector3.new(v22[1], v22[2], v22[3]))
end

local function rumblePad(p10) -- line: 139
    -- upvalues: HapticService (copy), PlatformController (copy), Gamepad1 (copy)
    return if p10.rumble and (PlatformController.IsConsole() or PlatformController.IsMobile()) and HapticService:IsVibrationSupported(Gamepad1) then Gamepad1 else nil
end

local function driveMotors(p11, p12) -- line: 149
    -- upvalues: HapticService (copy), t2 (copy)
    for v28, v29 in t2 do
        HapticService:SetMotor(p11, v28, p12 * v29)
    end
end

local function rumble(p13, p14) -- line: 155
    -- upvalues: HapticService (copy), PlatformController (copy), Gamepad1 (copy), t2 (copy)
    local Gamepad1_2 = if p13.rumble and (PlatformController.IsConsole() or PlatformController.IsMobile()) and HapticService:IsVibrationSupported(Gamepad1) then Gamepad1 else nil

    if Gamepad1_2 == nil then
        return
    end

    local v31 = math.sqrt((math.clamp(p13.reach, 0, 1))) * p14

    for v32, v33 in t2 do
        HapticService:SetMotor(Gamepad1_2, v32, v31 * v33)
    end
end

local function untouchedSinceLastWrite(p15, p16) -- line: 164
    local lastWritten = p15.lastWritten

    return lastWritten ~= nil and (p16.CFrame:FuzzyEq(lastWritten, 1E-04))
end

local function writeOffset(p17, p18, p19) -- line: 169
    local _CFrame = p18.CFrame
    local lastWritten = p17.lastWritten

    if lastWritten ~= nil and p18.CFrame:FuzzyEq(lastWritten, 1E-04) then
        _CFrame *= CFrame.new(-p17.appliedOffset)
    end

    local v34 = _CFrame * CFrame.new(p19)

    p18.CFrame = v34
    p17.lastWritten = v34
    p17.appliedOffset = p19
end

local function stopLive() -- line: 180
    -- upvalues: HapticService (copy), RunService (copy), Workspace (copy), PlatformController (copy), Gamepad1 (copy), t2 (copy), v3 (ref)
    local v35 = v3

    if v35 == nil then
        return
    end

    v3 = nil
    RunService:UnbindFromRenderStep("CameraShake.Offset")

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera then
        local lastWritten = v35.lastWritten

        if lastWritten ~= nil and CurrentCamera.CFrame:FuzzyEq(lastWritten, 1E-04) then
            CurrentCamera.CFrame *= CFrame.new(-v35.appliedOffset)
        end
    end

    local Gamepad1_2 = if v35.rumble and (PlatformController.IsConsole() or PlatformController.IsMobile()) and HapticService:IsVibrationSupported(Gamepad1) then Gamepad1 else nil

    if Gamepad1_2 ~= nil then
        for v36, v37 in t2 do
            HapticService:SetMotor(Gamepad1_2, v36, v37 * 0)
        end
    end
end

local function stepLive(p20) -- line: 198
    -- upvalues: HapticService (copy), Workspace (copy), PlatformController (copy), Gamepad1 (copy), t2 (copy), t3 (copy), v3 (ref), sampleOffset (copy), stopLive (copy)
    local v38 = v3
    local CurrentCamera = Workspace.CurrentCamera

    if v38 == nil or CurrentCamera == nil then
        stopLive()
    else
        v38.elapsed += p20

        if v38.elapsed >= v38.span then
            stopLive()
        else
            local v39 = v38.elapsed / v38.span
            local v40 = t3[v38.shape]
            local v41 = math.clamp(v39, 0, 1) * (#v40 - 1)
            local v42 = math.floor(v41) + 1
            local v45 = math.min(v42 + 1, #v40)
            local v49 = math.lerp(v40[v42], v40[v45], v41 - (v42 - 1))

            v38.sinceSample += p20

            local offset = v38.offset
            local v50

            if offset == nil or v38.hold <= 0 or v38.sinceSample >= v38.hold then
                v38.sinceSample = 0
                v50 = sampleOffset(v38, v49 * v38.reach)
                v38.offset = v50

                local Gamepad1_2 = if v38.rumble and (PlatformController.IsConsole() or PlatformController.IsMobile()) and HapticService:IsVibrationSupported(Gamepad1) then Gamepad1 else nil

                if Gamepad1_2 ~= nil then
                    local v52 = math.sqrt((math.clamp(v38.reach, 0, 1))) * v49

                    for v53, v54 in t2 do
                        HapticService:SetMotor(Gamepad1_2, v53, v52 * v54)
                    end
                end
            else
                v50 = offset
            end

            local _CFrame = CurrentCamera.CFrame
            local lastWritten = v38.lastWritten

            if lastWritten ~= nil and CurrentCamera.CFrame:FuzzyEq(lastWritten, 1E-04) then
                _CFrame *= CFrame.new(-v38.appliedOffset)
            end

            local v55 = _CFrame * CFrame.new(v50)

            CurrentCamera.CFrame = v55
            v38.lastWritten = v55
            v38.appliedOffset = v50
        end
    end
end

local function begin(p21) -- line: 224
    -- upvalues: RunService (copy), v1 (copy), v3 (ref), stepLive (copy)
    v3 = p21
    RunService:BindToRenderStep("CameraShake.Offset", v1, stepLive)
end

local function holdFor(p22) -- line: 230
    if p22 == nil or p22 <= 0 then
        return 0
    end

    return 1 / p22
end

function t4.Play(p23) -- line: 239
    -- upvalues: GuiService (copy), RunService (copy), Workspace (copy), v1 (copy), v2 (copy), v3 (ref), rangeGain (copy), stopLive (copy), stepLive (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil or CurrentCamera.CameraType == Enum.CameraType.Scriptable or GuiService.ReducedMotionEnabled then
        return
    end

    stopLive()
    p23 = p23 or {}

    local v57 = if p23.Range then rangeGain(p23.Range) else 1

    if v57 == nil then
        return
    end

    local t5 = {
        elapsed = 0,
        sinceSample = 0,
        offset = nil,
        appliedOffset = Vector3.new(0, 0, 0),
        lastWritten = nil,
        span = p23.Seconds or 1,
        reach = (p23.Magnitude or 1) * v57
    }
    local SamplesPerSecond = p23.SamplesPerSecond

    t5.hold = if SamplesPerSecond == nil or SamplesPerSecond <= 0 then 0 else 1 / SamplesPerSecond
    t5.shape = p23.Shape == "Pulse" and "Pulse" or "Fade"
    t5.rumble = p23.Rumble ~= false
    t5.seed = v2:NextNumber(0, 1000)
    v3 = t5
    RunService:BindToRenderStep("CameraShake.Offset", v1, stepLive)
end

function t4.Stop() -- line: 266
    -- upvalues: stopLive (copy)
    stopLive()
end

return table.freeze(t4)
