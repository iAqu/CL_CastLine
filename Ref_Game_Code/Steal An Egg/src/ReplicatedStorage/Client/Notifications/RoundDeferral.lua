-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local t1 = {
    Loading = true,
    InProgress = true,
    RoundEnd = true
}
local t2 = {}
local LocalPlayer = Players.LocalPlayer
local v1 = false

local function roundState() -- line: 20
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting"
end

local function recompute(p1) -- line: 26
    -- upvalues: LocalPlayer (copy), v1 (ref)
    local v2 = LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting"

    v1 = if p1 ~= nil then p1 else LocalPlayer:GetAttribute("MurderMysteryRole") ~= nil and v2 ~= "Waiting"
end

function t2.HoldsBack(p2) -- line: 33
    -- upvalues: t1 (copy), LocalPlayer (copy), v1 (ref)
    if p2 == true then
        return v1 and t1[LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting"] == true
    end

    return false
end

function t2.TakeAdmissible(p3) -- line: 37
    -- upvalues: t2 (copy)
    for v3, v4 in p3 do
        if not t2.HoldsBack(v4.config.DelayInRound) then
            return table.remove(p3, v3)
        end
    end

    return nil
end

local v5 = LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting"

v1 = LocalPlayer:GetAttribute("MurderMysteryRole") ~= nil and v5 ~= "Waiting"
LocalPlayer:GetAttributeChangedSignal("MurderMysteryRoundState"):Connect(function() -- line: 51
    -- upvalues: LocalPlayer (copy), v1 (ref)
    local v6 = (LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting") ~= "Waiting" and nil
    local v7 = LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting"

    if v6 == nil then
        v6 = LocalPlayer:GetAttribute("MurderMysteryRole") ~= nil and v7 ~= "Waiting"
    end

    v1 = v6
end)
LocalPlayer:GetAttributeChangedSignal("MurderMysteryRole"):Connect(function() -- line: 53
    -- upvalues: LocalPlayer (copy), v1 (ref)
    local v8 = LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting"

    v1 = LocalPlayer:GetAttribute("MurderMysteryRole") ~= nil and v8 ~= "Waiting"
end)
Remotes.Whodunnit.RoundShifted.OnClientEvent:Connect(function(p4) -- line: 56
    -- upvalues: LocalPlayer (copy), v1 (ref)
    if typeof(p4) ~= "table" then
        return
    end

    local isParticipant = p4.isParticipant

    if typeof(isParticipant) ~= "boolean" then
        isParticipant = nil
    end

    local v9 = LocalPlayer:GetAttribute("MurderMysteryRoundState") or "Waiting"

    if isParticipant == nil then
        isParticipant = LocalPlayer:GetAttribute("MurderMysteryRole") ~= nil and v9 ~= "Waiting"
    end

    v1 = isParticipant
end)

return t2
