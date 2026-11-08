-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local OverlayRoot = require(ReplicatedStorage.Client.UI.VFX.OverlayRoot)

local function quintOut(p1, p2) -- line: 9
    return TweenInfo.new(p1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, p2 or 0)
end

local t1 = {
    pitch = 1,
    lensWide = 100,
    lensResting = 70,
    cues = {
        {
            id = 91650233387983,
            volume = 0.8
        },
        {
            id = 112792997660073,
            volume = 1
        }
    },
    sheetProperties = {
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.fromRGB(255, 175, 0),
        Size = UDim2.new(1, 0, 1, 0)
    },
    sheetFade = TweenInfo.new(1.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0.05),
    lensPush = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0.05),
    lensSettle = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
}

local function stage(p3, p4, p5) -- line: 38
    -- upvalues: TweenService (copy)
    return TweenService:Create(p3, p4, p5)
end

return function() -- line: 42
    -- upvalues: TweenService (copy), Audio (copy), OverlayRoot (copy), t1 (copy)
    for _, v1 in t1.cues do
        Audio.Play(v1.id, script, {
            PlaybackSpeed = t1.pitch,
            Volume = v1.volume
        })
    end

    local Frame = Instance.new("Frame")

    for v2, v3 in t1.sheetProperties do
        Frame[v2] = v3
    end

    Frame.Parent = OverlayRoot()

    local CurrentCamera = workspace.CurrentCamera
    local tween = TweenService:Create(CurrentCamera, t1.lensSettle, {
        FieldOfView = t1.lensResting
    })
    local tween2 = TweenService:Create(CurrentCamera, t1.lensPush, {
        FieldOfView = t1.lensWide
    })
    local tween3 = TweenService:Create(Frame, t1.sheetFade, {
        BackgroundTransparency = 1
    })

    tween2.Completed:Once(function() -- line: 64
        -- upvalues: tween (copy)
        tween:Play()
    end)
    tween3.Completed:Once(function() -- line: 65
        -- upvalues: Frame (copy)
        Frame:Destroy()
    end)
    tween2:Play()
    tween3:Play()
end
