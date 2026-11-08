-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local t1 = {
    Version = 11,
    RootId = table.freeze({
        PlayerGui = 0,
        Workspace = 1,
        Lighting = 2
    }),
    FirstInstanceId = 3,
    Op = table.freeze({
        Time = 0,
        Add = 1,
        Remove = 2,
        Reparent = 3,
        Rename = 4,
        Prop = 5,
        Viewport = 6,
        Pointer = 7,
        Selected = 8,
        SafeArea = 9,
        Defaults = 10,
        PropLerp = 11,
        SeqCopy = 12,
        SeqShift = 13,
        Camera = 14,
        CFramePos = 15,
        CFrameRot = 16,
        UDim2Part = 17,
        CFrameMotion = 18,
        Copy = 19,
        KeyDown = 20,
        KeyUp = 21,
        CameraFollow = 22,
        Keyframe = 23,
        ClockSync = 24,
        Emit = 25,
        PropMany = 26,
        DropTemplates = 27,
        TemplateNext = 28,
        Template = 29,
        CopyBase = 30,
        Start = 31,
        TimeDelta = 32,
        CFrameDelta = 33
    }),
    TemplateNext = table.freeze({
        Add = 1,
        Keep = 2
    }),
    ValueType = table.freeze({
        Bool = 1,
        Int32 = 2,
        Float32 = 3,
        Float64 = 4,
        String = 5,
        Enum = 6,
        UDim = 7,
        UDim2 = 8,
        Vector2 = 9,
        Vector3 = 10,
        Color3 = 11,
        Rect = 12,
        Font = 13,
        ColorSequence = 14,
        NumberSequence = 15,
        NumberRange = 16,
        Content = 17,
        CFrame = 18,
        Vector2int16 = 19,
        Int64 = 20,
        Ref = 21
    }),
    PointerKind = table.freeze({
        Mouse = 1,
        Touch = 2,
        VirtualCursor = 3
    }),
    PointerState = table.freeze({
        Move = 0,
        Down = 1,
        Up = 2
    }),
    StopReason = table.freeze({
        Dropped = "dropped",
        Capped = "capped",
        Closed = "closed"
    }),
    AssemblyRootProperty = "AssemblyRoot",
    SurfaceIdAttribute = "__UG_SurfaceId",
    SurfaceIdProperty = "SurfaceId",
    BakedTag = "UG_REPLAY_BAKED",
    BakedIdAttribute = "UG_REPLAY_BAKED_ID",
    BakedOriginAttribute = "UG_REPLAY_BAKED_ORIGIN",
    UnbakedTag = "UG_REPLAY_UNBAKED",
    UnbakedAttribute = "UG_REPLAY_UNBAKED",
    BakeIdProperty = "BakeId",
    PivotProperty = "Pivot",
    AudioSources = table.freeze({
        Sound = true,
        AudioPlayer = true,
        AudioTextToSpeech = true,
        AudioWindSynthesizer = true
    }),
    AudioEffects = table.freeze({
        AudioFader = true,
        AudioEqualizer = true,
        AudioFilter = true,
        AudioReverb = true,
        AudioEcho = true,
        AudioCompressor = true,
        AudioLimiter = true,
        AudioGate = true,
        AudioPitchShifter = true,
        AudioChorus = true,
        AudioFlanger = true,
        AudioTremolo = true,
        AudioDistortion = true,
        AudioChannelMixer = true,
        AudioChannelSplitter = true
    }),
    AudioClasses = table.freeze({
        Sound = true,
        SoundGroup = true,
        SoundService = true,
        AudioPlayer = true,
        AudioTextToSpeech = true,
        AudioWindSynthesizer = true,
        AudioEmitter = true,
        AudioListener = true,
        AudioDeviceOutput = true,
        Wire = true
    })
}
local t2 = {}

function t1.IsAudio(p1) -- line: 542
    -- upvalues: t1 (copy), t2 (copy)
    local ClassName = p1.ClassName
    local v1 = t2[ClassName]

    if v1 ~= nil then
        return v1
    end

    local v2 = t1.AudioClasses[ClassName] == true or t1.AudioEffects[ClassName] == true or p1:IsA("SoundEffect")

    t2[ClassName] = v2

    return v2
end

t1.EmissionScaleProperty = "EmissionScale"
t1.WorldCFrameProperty = "WorldCFrame"
t1.OnCameraProperty = "OnCamera"
t1.DistanceAttenuationProperty = "DistanceAttenuation"
t1.AngleAttenuationProperty = "AngleAttenuation"
t1.MasterVolumeProperty = "MasterVolume"

local t3 = {}

t1.PolledProperties = table.freeze(t3)
t1.MaxMessageBytes = 131072
t1.MaxStringBytes = 16384
t1.Remotes = table.freeze({
    Start = script:WaitForChild("Start"),
    Data = script:WaitForChild("Data"),
    Stop = script:WaitForChild("Stop"),
    Teleport = script:WaitForChild("Teleport"),
    Emit = script:WaitForChild("Emit")
})

local v3

function t1.RecordEmit(p2, p3) -- line: 605
    -- upvalues: v3 (ref)
    if typeof(p2) == "Instance" and p2:IsA("ParticleEmitter") then
        local v5 = math.floor(tonumber(p3) or 16)
        local v6 = v3

        if v6 and v5 > 0 then
            v6(p2, v5)
        end
    end
end

function t1.SetEmitSink(p4) -- line: 617
    -- upvalues: v3 (ref)
    v3 = p4
end

t1.DefaultCaptureInterval = 0.05
t1.LocalCaptureInterval = 0.016666666666666666
t1.MinCaptureInterval = 0.016666666666666666
t1.MaxCaptureInterval = 0.25
t1.CaptureIntervalAttribute = "UG_REPLAY_CAPTURE_INTERVAL"

local v7, v8

local function askCaptureRate(p5, p6) -- line: 641
    -- upvalues: t1 (copy)
    local ok, result = pcall(p5, p6)

    if ok then
        local v9 = tonumber(result)

        return if v9 and v9 == v9 then math.clamp(v9, t1.MinCaptureInterval, t1.MaxCaptureInterval) else nil
    end

    warn("[UGUIReplay] capture rate callback:", result)

    return nil
end

local function refreshCaptureRates(p7) -- line: 654
    -- upvalues: Players (copy), t1 (copy)
    for _, player in Players:GetPlayers() do
        local v10

        if p7 then
            local ok, result = pcall(p7, player)

            if ok then
                local v11 = tonumber(result)

                if v11 and v11 == v11 then
                    v10 = math.clamp(v11, t1.MinCaptureInterval, t1.MaxCaptureInterval)
                end
            else
                warn("[UGUIReplay] capture rate callback:", result)
            end
        end

        if player:GetAttribute(t1.CaptureIntervalAttribute) ~= v10 then
            player:SetAttribute(t1.CaptureIntervalAttribute, v10)
        end
    end
end

function t1.SetCaptureRateCallback(p8) -- line: 682
    -- upvalues: RunService (copy), v7 (ref), v8 (ref), refreshCaptureRates (copy)
    if p8 ~= nil and type(p8) ~= "function" then
        return
    end

    v7 = p8

    if RunService:IsServer() then
        if v8 then
            task.cancel(v8)
            v8 = nil
        end

        refreshCaptureRates(p8)

        if p8 then
            v8 = task.spawn(function() -- line: 696
                -- upvalues: p8 (copy), refreshCaptureRates (copy)
                while true do
                    task.wait(0.25)
                    refreshCaptureRates(p8)
                end
            end)
        end
    end
end

function t1.CaptureIntervalOf(p9) -- line: 706
    -- upvalues: Players (copy), RunService (copy), t1 (copy), v7 (ref)
    local v12 = v7

    if v12 and not RunService:IsServer() then
        local ok, result = pcall(v12, p9)
        local v13

        if ok then
            local v14 = tonumber(result)

            if v14 and v14 == v14 then
                v13 = math.clamp(v14, t1.MinCaptureInterval, t1.MaxCaptureInterval)
            end
        else
            warn("[UGUIReplay] capture rate callback:", result)
        end

        if v13 then
            return v13
        end
    end

    local Attribute = p9:GetAttribute(t1.CaptureIntervalAttribute)

    if type(Attribute) ~= "number" or Attribute ~= Attribute then
        if p9 == Players.LocalPlayer then
            return t1.LocalCaptureInterval
        end

        return t1.DefaultCaptureInterval
    end

    return (math.clamp(Attribute, t1.MinCaptureInterval, t1.MaxCaptureInterval))
end

return table.freeze(t1)
