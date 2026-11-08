-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LiveEventFlags = require(ReplicatedStorage.Shared.Flags.LiveEventFlags)
local RiftFlags = require(ReplicatedStorage.Shared.Flags.RiftFlags)
local RiftMachineSchedule = require(ReplicatedStorage.Shared.Util.RiftMachineSchedule)
local t1 = {
    CutsceneSeenAttribute = "RiftCutscene2Seen",
    OpenAttribute = LiveEventFlags.Directory.RiftOpen.AttributeName
}

function t1.IsFeatureLive() -- line: 20
    -- upvalues: RiftFlags (copy), RiftMachineSchedule (copy)
    return not RiftMachineSchedule.IsLaboratoryTime() and not RiftFlags.Retired:Get()
end

function t1.IsEligible(p1) -- line: 24
    -- upvalues: RiftFlags (copy)
    return RiftFlags.SpeedPowerRequirement:Get() <= p1
end

function t1.HasSeenReveal(p2) -- line: 28
    return p2:GetAttribute("RiftCutscene2Seen") == true
end

function t1.IsRevealed(p3, p4, p5) -- line: 32
    -- upvalues: RiftFlags (copy), t1 (copy)
    if not t1.IsFeatureLive() then
        return false
    end

    if not (RiftFlags.SpeedPowerRequirement:Get() <= p4) and p5 == 0 then
        return (t1.HasSeenReveal(p3))
    end

    return true
end

return table.freeze(t1)
