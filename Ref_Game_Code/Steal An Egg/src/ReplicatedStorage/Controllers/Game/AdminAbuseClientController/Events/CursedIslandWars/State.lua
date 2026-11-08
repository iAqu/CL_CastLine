-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

require(ReplicatedStorage.Data.CursedIslandWars)

local Signal = require(ReplicatedStorage.Packages.Signal)
local LocalPlayer = Players.LocalPlayer
local t1 = {
    Snapshot = nil,
    Changed = Signal.new()
}

function t1.Now() -- line: 20
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

function t1.Set(p1) -- line: 24
    -- upvalues: t1 (copy)
    t1.Snapshot = p1
    t1.Changed:Fire(p1)
end

function t1.Entries() -- line: 29
    -- upvalues: t1 (copy)
    local Snapshot = t1.Snapshot

    if Snapshot then
        return Snapshot.Entries
    end

    return {}
end

function t1.Entry(p2) -- line: 34
    -- upvalues: t1 (copy)
    if p2 == nil then
        return nil
    end

    for _, v1 in t1.Entries() do
        if v1.Id == p2 then
            return v1
        end
    end

    return nil
end

function t1.Me() -- line: 46
    -- upvalues: LocalPlayer (copy), t1 (copy)
    for _, v2 in t1.Entries() do
        if v2.UserId == LocalPlayer.UserId then
            return v2
        end
    end

    return nil
end

function t1.Root(p3) -- line: 55
    local Model = if p3 then p3.Model else nil

    return if Model then Model:FindFirstChild("HumanoidRootPart") else nil
end

function t1.Phase() -- line: 60
    -- upvalues: t1 (copy)
    local Snapshot = t1.Snapshot

    return if Snapshot then Snapshot.Phase else nil
end

function t1.Island() -- line: 65
    -- upvalues: t1 (copy)
    local Snapshot = t1.Snapshot

    return if Snapshot then Snapshot.Island else nil
end

function t1.Fighting() -- line: 70
    -- upvalues: t1 (copy)
    local v3 = t1.Phase()

    if v3 == "Match" then
        return true
    end

    return v3 == "SuddenDeath"
end

function t1.Armed() -- line: 75
    -- upvalues: t1 (copy)
    if t1.Phase() == "Prep" then
        return true
    end

    return (t1.Fighting())
end

return t1
