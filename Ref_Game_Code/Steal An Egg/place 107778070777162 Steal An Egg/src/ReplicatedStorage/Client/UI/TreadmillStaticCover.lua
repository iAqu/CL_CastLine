-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GUI = require(ReplicatedStorage.Client.GUI)
local TreadmillVideoController = require(ReplicatedStorage.Shared.TreadmillVideoController)

require(ReplicatedStorage.Shared.TreadmillVideoController.Types.Interface)

local v1 = GUI.StaticTreadmillImageSurfaceGui()

assert(v1:IsA("SurfaceGui"), "Static treadmill image GUI must be a SurfaceGui")

local t1 = {}

function t1.Create(p1, p2) -- line: 23
    -- upvalues: v1 (copy)
    local clone = v1:Clone()

    clone.Name = p1
    clone.Adornee = p2
    clone.Enabled = true
    clone.Parent = v1.Parent

    return clone
end

function t1.SetEnabled(p3, p4) -- line: 35
    p3.Enabled = p4
end

function t1.ApplyMedia(p5, p6) -- line: 42
    -- upvalues: TreadmillVideoController (copy)
    p5.VideoFrame.Image.Image = TreadmillVideoController.ResolveCoverImage(p6)
    p5.VideoFrame.StopPlay.Image = TreadmillVideoController.GetStoppedIconImage()
    p5.VideoFrame.StopPlay.Visible = true
end

function t1.ApplyFeed(p7, p8) -- line: 51
    -- upvalues: TreadmillVideoController (copy), t1 (copy)
    t1.ApplyMedia(p7, TreadmillVideoController.GetCurrentMediaEntry(p8))
end

return t1
