-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local AssetIds = require(ReplicatedStorage.Shared.Utils.AssetIds)
local GameFlags = require(ReplicatedStorage.Shared.Flags.GameFlags)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Spread = require(ReplicatedStorage.Shared.Utils.Spread)
local v1 = RunService:IsClient()
local v2 = if v1 then require(ReplicatedStorage.Shared.Preferences) else nil
local _ = {
    Gameplay = "Gameplay",
    Music = "Music",
    MusicInner = "GameMusic"
}
local t1 = {
    Failure = 1,
    Notice = 0.55,
    Prompt = 0.75
}
local t2 = {
    Ambient = Enum.RollOffMode.Linear,
    OneShot = Enum.RollOffMode.LinearSquare
}
local t3 = {
    Style = Enum.EasingStyle.Sine,
    Direction = Enum.EasingDirection.InOut
}
local t4 = {
    {
        Option = "Looped",
        Property = "Looped"
    },
    {
        Option = "MaxDistance",
        Property = "RollOffMaxDistance"
    },
    {
        Option = "PlaybackSpeed",
        Property = "PlaybackSpeed",
        Sampled = true
    },
    {
        Option = "TimePosition",
        Property = "TimePosition"
    },
    {
        Option = "Volume",
        Property = "Volume",
        Sampled = true
    }
}
local t5 = {
    Frame = nil,
    HalfExtent = 0
}
local t6 = {}
local v3 = Random.new()
local v4
local self = setmetatable({}, {
    __mode = "k"
})
local pickAsset
local t9 = {
    number = function(p1) -- number | line: 104
        assert(p1 > 0, "asset ids are positive numbers")

        return p1
    end,
    string = function(p2) -- string | line: 108
        -- upvalues: AssetIds (copy)
        return AssetIds.Parse(p2) or error(("\"%*\" does not name an asset"):format(p2), 2)
    end,
    table = function(p3) -- table | line: 111
        -- upvalues: v3 (copy), pickAsset (ref)
        assert(#p3 > 0, "a sound list needs at least one entry")

        return pickAsset(p3[v3:NextInteger(1, #p3)])
    end
}

function pickAsset(p4) -- line: 118
    -- upvalues: t9 (copy)
    local v8 = t9[typeof(p4)]

    if v8 == nil then
        error(("cannot turn a %* into a sound id"):format((typeof(p4))), 2)
    end

    return v8(p4)
end

local function assetUri(p5) -- line: 126
    -- upvalues: pickAsset (ref)
    return (("rbxassetid://%*"):format((pickAsset(p5))))
end

local function resolveGroup(p6, p7) -- line: 130
    -- upvalues: SoundService (copy)
    local v9 = if typeof(p6) == "Instance" then p6 else SoundService:FindFirstChild(p6 or p7)

    if v9 == nil or not v9:IsA("SoundGroup") then
        error(("SoundService has no SoundGroup named %*"):format((tostring(p6 or p7))), 2)
    end

    if v9.Name == "Music" then
        local GameMusic = v9:FindFirstChild("GameMusic")

        if GameMusic and GameMusic:IsA("SoundGroup") then
            return GameMusic
        end
    end

    return v9
end

local function nearField(p8) -- line: 146
    return (math.clamp(p8 * 0.005, 0.01, 1))
end

local function rolloffFor(p9) -- line: 150
    -- upvalues: t2 (copy)
    if p9 then
        return t2.Ambient
    end

    return t2.OneShot
end

local function authorSound(p10, p11, p12) -- line: 156
    -- upvalues: Spread (copy), t2 (copy), v3 (copy), pickAsset (ref), resolveGroup (copy)
    local v12 = p12.Looped == true
    local v13 = p12.MaxDistance or 200

    p10.Looped = v12
    p10.PlaybackSpeed = Spread.Sample(p12.PlaybackSpeed, 1, v3)
    p10.RollOffMaxDistance = v13
    p10.RollOffMinDistance = math.clamp(v13 * 0.005, 0.01, 1)

    if v12 then
        p10.RollOffMode = t2.Ambient
    else
        p10.RollOffMode = t2.OneShot
    end

    p10.SoundGroup = resolveGroup(p12.SoundGroup, "Gameplay")
    p10.SoundId = ("rbxassetid://%*"):format((pickAsset(p11)))
    p10.TimePosition = p12.TimePosition or 0
    p10.Volume = Spread.Sample(p12.Volume, 1, v3)

    return p10
end

local function retouchSound(p13, p14) -- line: 171
    -- upvalues: Spread (copy), t4 (copy), v3 (copy), resolveGroup (copy)
    for _, v15 in t4 do
        local v16 = p14[v15.Option]

        if v16 ~= nil then
            local Property = v15.Property

            if v15.Sampled then
                v16 = Spread.Sample(v16, 1, v3)
            end

            p13[Property] = v16
        end
    end

    if p14.SoundGroup ~= nil then
        p13.SoundGroup = resolveGroup(p14.SoundGroup, "Gameplay")
    end

    return p13
end

local function attachEffects(p15, p16) -- line: 186
    for _, v17 in p16 or {} do
        v17:Clone().Parent = p15
    end
end

local function optionsFromCatalog(p17) -- line: 192
    return {
        Deferred = p17.SkipPlay,
        Looped = p17.Looped,
        MaxDistance = p17.MaxDistance,
        PlaybackSpeed = p17.Speed,
        Recipient = p17.Player,
        SoundGroup = p17.SoundGroup,
        TimePosition = p17.TimePos,
        Volume = p17.Volume
    }
end

local function placementOfPart(p18) -- line: 207
    return {
        Frame = p18.CFrame,
        HalfExtent = p18.Size.Magnitude / 2
    }
end

local t10 = {
    CFrame = function(p19) -- CFrame | line: 212
        return {
            HalfExtent = 0,
            Frame = p19
        }
    end,
    Vector3 = function(p20) -- Vector3 | line: 215
        return {
            HalfExtent = 0,
            Frame = CFrame.new(p20)
        }
    end
}
local t15 = {
    {
        Class = "Attachment",
        Resolve = function(p21) -- Resolve | line: 223
            return {
                HalfExtent = 0,
                Frame = p21.WorldCFrame
            }
        end
    },
    {
        Class = "BasePart",
        Resolve = function(p22) -- Resolve | line: 229
            return {
                Frame = p22.CFrame,
                HalfExtent = p22.Size.Magnitude / 2
            }
        end
    },
    {
        Class = "Workspace",
        Resolve = function() -- Resolve | line: 235
            -- upvalues: t5 (copy)
            return t5
        end
    },
    {
        Class = "Model",
        Resolve = function(p23) -- Resolve | line: 241
            -- upvalues: t5 (copy)
            local PrimaryPart = p23.PrimaryPart

            if PrimaryPart then
                return {
                    Frame = PrimaryPart.CFrame,
                    HalfExtent = PrimaryPart.Size.Magnitude / 2
                }
            end

            return t5
        end
    },
    {
        Class = "PVInstance",
        Resolve = function(p24) -- Resolve | line: 248
            return {
                HalfExtent = 0,
                Frame = p24:GetPivot()
            }
        end
    }
}

local function needsPrimaryPart(p25) -- line: 254
    if typeof(p25) ~= "Instance" then
        return false
    end

    return p25:IsA("Model") and not p25:IsA("Workspace")
end

local function placementOf(p26) -- line: 262
    -- upvalues: t5 (copy), t10 (copy), t15 (copy)
    local v18 = t10[typeof(p26)]

    if v18 ~= nil then
        return v18(p26)
    end

    for _, v19 in t15 do
        if p26:IsA(v19.Class) then
            return v19.Resolve(p26)
        end
    end

    return t5
end

local function earshotSlack(p27, p28) -- line: 276
    -- upvalues: self (copy)
    if typeof(p27) == "Instance" then
        local v20 = self[p27]

        if v20 ~= nil and p28 - v20 < 4 then
            return 2
        end
    end

    return 1.5
end

local function inEarshot(p29, p30, p31) -- line: 285
    -- upvalues: Workspace (copy), self (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local Frame = p30.Frame

    if CurrentCamera == nil or Frame == nil then
        return true
    end

    local elapsed = os.clock()
    local v21 = (CurrentCamera:GetRenderCFrame().Position - Frame.Position).Magnitude - p30.HalfExtent
    local v22 = 1.5

    if typeof(p29) == "Instance" then
        local v23 = self[p29]

        v22 = if v23 == nil then 1.5 elseif elapsed - v23 < 4 then 2 else 1.5
    end

    local v24 = v21 <= p31 * v22

    if v24 and typeof(p29) == "Instance" then
        self[p29] = elapsed
    end

    return v24
end

local function shelf() -- line: 301
    -- upvalues: SoundService (copy), v4 (ref)
    local v25 = v4

    if v25 and v25.Parent ~= nil then
        return v25
    end

    local Folder = Instance.new("Folder")

    Folder.Name = "MusicTracks"
    Folder.Parent = SoundService
    v4 = Folder

    return Folder
end

local function stageFor(p32, p33) -- line: 315
    -- upvalues: Workspace (copy)
    if typeof(p32) == "Instance" then
        if typeof(p32) ~= "Instance" or not p32:IsA("Model") or p32:IsA("Workspace") then
            return p32, nil
        end

        return assert(p32.PrimaryPart), nil
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "SoundStage"
    Attachment.Parent = Workspace.Terrain
    Attachment.WorldCFrame = p33

    return Attachment, Attachment
end

local function launch(p34, p35) -- line: 330
    local function retire() -- line: 331
        -- upvalues: p35 (copy)
        p35:Destroy()
    end

    p34.Ended:Once(retire)
    p34.Stopped:Once(retire)
    p34:Play()

    return p34
end

local function sfxMuted() -- line: 342
    -- upvalues: GameFlags (copy), v2 (copy)
    if not GameFlags.SoundEffects:Get() then
        return true
    end

    return v2 ~= nil and not v2.IsOn("SFX")
end

local function dispatch(p36, p37, p38) -- line: 350
    -- upvalues: Remotes (copy)
    local Recipient = p38.Recipient
    local v26 = table.clone(p38)

    v26.Recipient = nil

    local t16 = {
        Source = p36,
        Emitter = p37,
        Options = v26
    }
    local EmitSound = Remotes.SoundBus.EmitSound

    if Recipient ~= nil then
        if typeof(Recipient) == "Instance" then
            EmitSound:FireClient(Recipient, t16)
        else
            for _, v27 in Recipient do
                EmitSound:FireClient(v27, t16)
            end
        end
    else
        EmitSound:FireAllClients(t16)
    end
end

function t6.Play(p39, p40, p41) -- line: 369
    -- upvalues: Workspace (copy), GameFlags (copy), v1 (copy), authorSound (copy), retouchSound (copy), attachEffects (copy), placementOf (copy), inEarshot (copy), v2 (copy), dispatch (copy)
    p41 = p41 or {}

    if v1 then
        if not GameFlags.SoundEffects:Get() or v2 ~= nil and not v2.IsOn("SFX") then
            return nil
        end

        local v29 = placementOf(p40)

        if v29.Frame == nil and typeof(p40) == "Instance" and p40:IsA("Model") and not p40:IsA("Workspace") then
            warn((("Audio.Play skipped: %* has no PrimaryPart"):format((p40:GetFullName()))))

            return nil
        end

        local v30 = p41.MaxDistance or 200

        if p41.Looped ~= true and not inEarshot(p40, v29, v30) then
            return nil
        end

        local v31

        if typeof(p39) == "Instance" then
            assert(p39:IsA("Sound"), "an Instance sound source must be a Sound")
            v31 = retouchSound(p39:Clone(), p41)
        else
            v31 = authorSound(Instance.new("Sound"), p39, p41)
        end

        attachEffects(v31, p41.Effects)

        local Frame = v29.Frame
        local Attachment, Attachment2

        if typeof(p40) == "Instance" then
            Attachment = if typeof(p40) == "Instance" and p40:IsA("Model") and not p40:IsA("Workspace") then assert(p40.PrimaryPart) else p40
        else
            Attachment = Instance.new("Attachment")
            Attachment2 = Attachment
            Attachment.Name = "SoundStage"
            Attachment.Parent = Workspace.Terrain
            Attachment.WorldCFrame = Frame
        end

        v31.Parent = Attachment

        if p41.Deferred then
            if Attachment2 ~= nil then
                local Destroying = v31.Destroying
                local Attachment = Attachment2

                Destroying:Once(function() -- line: 403
                    -- upvalues: Attachment (copy)
                    Attachment:Destroy()
                end)
            end
        else
            local v32 = Attachment2 or v31

            local function retire() -- line: 331
                -- upvalues: v32 (copy)
                v32:Destroy()
            end

            v31.Ended:Once(retire)
            v31.Stopped:Once(retire)
            v31:Play()
        end

        return v31
    end

    dispatch(p39, p40, p41)

    return nil
end

function t6.PlaySound(p42, p43) -- line: 412
    if p43 then
        p42.Parent = p43
    end

    local function retire() -- line: 331
        -- upvalues: p42 (copy)
        p42:Destroy()
    end

    p42.Ended:Once(retire)
    p42.Stopped:Once(retire)
    p42:Play()

    return p42
end

function t6.PlayFile(p44, p45, p46) -- line: 419
    -- upvalues: t6 (copy)
    local Data = p44.Data
    local t17 = {
        Deferred = Data.SkipPlay,
        Looped = Data.Looped,
        MaxDistance = Data.MaxDistance,
        PlaybackSpeed = Data.Speed,
        Recipient = Data.Player,
        SoundGroup = Data.SoundGroup,
        TimePosition = Data.TimePos,
        Volume = Data.Volume
    }

    t17.Effects = p46

    return t6.Play(p44.SoundId, p45, t17)
end

function t6.Configure(p47, p48) -- line: 425
    -- upvalues: authorSound (copy)
    local SoundId = p48.SoundId

    assert(typeof(SoundId) ~= "Instance", "a catalogued Sound cannot be configured from another Sound")

    local Data = p48.Data

    return (authorSound(p47, SoundId, {
        Deferred = Data.SkipPlay,
        Looped = Data.Looped,
        MaxDistance = Data.MaxDistance,
        PlaybackSpeed = Data.Speed,
        Recipient = Data.Player,
        SoundGroup = Data.SoundGroup,
        TimePosition = Data.TimePos,
        Volume = Data.Volume
    }))
end

function t6.CreateConfigured(p49, p50, p51) -- line: 431
    -- upvalues: t6 (copy)
    local v34 = t6.Configure(Instance.new("Sound"), p50)

    v34.Name = p51 or "CatalogSound"
    v34.Parent = p49

    return v34
end

function t6.MusicTrack(p52) -- line: 439
    -- upvalues: SoundService (copy), v4 (ref), pickAsset (ref), resolveGroup (copy)
    local Sound = Instance.new("Sound")

    Sound.Looped = p52.Looped
    Sound.Name = p52.Name
    Sound.SoundGroup = resolveGroup(nil, "Music")

    local Source = p52.Source

    Sound.SoundId = ("rbxassetid://%*"):format((pickAsset(Source)))
    Sound.Volume = 0

    local v35 = v4

    if not v35 or v35.Parent == nil then
        v35 = Instance.new("Folder")
        v35.Name = "MusicTracks"
        v35.Parent = SoundService
        v4 = v35
    end

    Sound.Parent = v35

    return Sound
end

function t6.FadeTo(p53, p54) -- line: 450
    -- upvalues: TweenService (copy), t3 (copy)
    local tween = TweenService:Create(p53, TweenInfo.new(p54.Seconds, p54.Style or t3.Style, p54.Direction or t3.Direction), {
        Volume = p54.Volume
    })

    tween:Play()

    return tween
end

function t6.Chime(p55, p56, p57) -- line: 462
    -- upvalues: t1 (copy), t6 (copy)
    t6.Play(131342831254185, script, {
        Recipient = p57,
        Volume = (t1[p55] or 1) * (p56 or 1)
    })
end

if v1 then
    Remotes.SoundBus.EmitSound.OnClientEvent:Connect(function(p58) -- line: 472
        -- upvalues: t6 (copy)
        t6.Play(p58.Source, p58.Emitter, p58.Options)
    end)
end

return table.freeze(t6)
