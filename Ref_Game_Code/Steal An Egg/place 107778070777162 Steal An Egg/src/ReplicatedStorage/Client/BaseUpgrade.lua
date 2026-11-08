-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Bases = require(ReplicatedStorage.Data.Bases)
local QueueLock = require(ReplicatedStorage.Shared.Modules.QueueLock)
local Log = require(ReplicatedStorage.Packages.Log)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Audio = require(ReplicatedStorage.Shared.Audio)
local t = require(ReplicatedStorage.Packages.t)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local v1 = Color3.fromRGB(255, 64, 64)
local t1 = {
    soundId = 119855061490364,
    volume = 1.5,
    pitchRange = { 0.9, 1.1 }
}
local LocalPlayer = Players.LocalPlayer
local v2 = Log.new()
local v3 = QueueLock.new()
local v4 = Signal.new()
local v5 = false
local t2 = {}
local t3 = {
    Completed = v4,
    Begin = function() -- Begin | line: 52
        -- upvalues: v5 (ref)
        assert(not v5, "nested base upgrade transitions are not supported")
        v5 = true
    end
}

function t3.Complete() -- line: 57
    -- upvalues: v4 (copy), v5 (ref)
    assert(v5, "no base upgrade transition is in flight to finish")
    v5 = false
    v4:Fire()
end

function t3.IsPlaying() -- line: 63
    -- upvalues: v5 (ref)
    return v5
end

function t3.Play(p1) -- line: 65
    -- upvalues: Audio (copy), t1 (copy), t3 (copy)
    assert(workspace.CurrentCamera ~= nil, "no render camera is bound on this client")
    t3.Begin()
    Audio.Play(t1.soundId, script, {
        PlaybackSpeed = t1.pitchRange,
        Volume = t1.volume
    })
    task.spawn(p1)
    t3.Complete()
end

t2.Transition = t3

local function tierAbove(p2) -- line: 83
    -- upvalues: Bases (copy), t (copy)
    t.strict(t.intersection(t.integer, t.numberMin(0)))(p2.BaseUpgradeLevel)

    local v9 = p2.BaseUpgradeLevel + 1

    return v9, Bases.BASES[v9]
end

local function isWithinBudget(p3, p4) -- line: 91
    return p4 ~= nil and p3.Money >= p4.Cost
end

local function blockingNotice(p5, p6) -- line: 96
    -- upvalues: v1 (copy)
    if p6 == nil then
        return {
            Text = "Max base upgrade reached",
            Seconds = 2
        }
    end

    return if p5.Money < p6.Cost then {
        Text = "Not enough money",
        Seconds = 2,
        Color = v1
    } else nil
end

local function playThenAsk() -- line: 109
    -- upvalues: Remotes (copy), t3 (copy)
    t3.Play(function() -- line: 110
        -- upvalues: Remotes (copy)
        Remotes.Homestead.AskBaseTierRaise:FireServer()
    end)
end

function t2.PurchaseNextTier() -- line: 117
    -- upvalues: Bases (copy), Toast (copy), Save (copy), t (copy), TryCall (copy), LocalPlayer (copy), v2 (copy), v3 (copy), blockingNotice (copy), playThenAsk (copy)
    local v10 = Save.Await(LocalPlayer)

    assert(v10 ~= nil, "local save data has not arrived yet")
    t.strict(t.intersection(t.integer, t.numberMin(0)))(v10.BaseUpgradeLevel)

    local v12 = v10.BaseUpgradeLevel + 1
    local v14 = blockingNotice(v10, Bases.BASES[v12])

    if v14 ~= nil then
        Toast.Show(v14)
    end

    local v15 = if v14 == nil then v3:TryTake() else nil

    if v15 == nil then
        return false
    end

    task.spawn(function() -- line: 132
        -- upvalues: v15 (copy), TryCall (copy), v2 (copy), playThenAsk (copy)
        local v16, v17 = TryCall(playThenAsk)

        v15:GiveBack()

        if not v16 then
            v2:AtError():Log((("upgrade transition aborted before firing: %*"):format(v17)))
        end
    end)

    return true
end

function t2.ResolveNextTier(p7) -- line: 142
    -- upvalues: tierAbove (copy)
    return tierAbove(p7)
end

function t2.IsNextTierAffordable(p8) -- line: 146
    -- upvalues: Bases (copy), t (copy)
    t.strict(t.intersection(t.integer, t.numberMin(0)))(p8.BaseUpgradeLevel)

    local v18 = p8.BaseUpgradeLevel + 1
    local v19 = Bases.BASES[v18]

    return v19 ~= nil and p8.Money >= v19.Cost
end

return t2
