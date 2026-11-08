-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GUI = require(ReplicatedStorage.Client.GUI)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local t1 = {
    Changed = Signal.new()
}
local t2 = {
    GUI.HUD(),
    GUI.Backpack(),
    GUI.OfflineMoneyInPlot()
}
local n1 = 0
local v1

local function isHidden() -- line: 21
    -- upvalues: n1 (ref)
    return n1 > 0
end

local function update() -- line: 25
    -- upvalues: Tabs (copy), t2 (copy), n1 (ref), v1 (ref)
    v1 = nil

    local v2 = not (n1 > 0)

    for _, v3 in t2 do
        v3.Enabled = v2
    end

    if not v2 then
        Tabs.Deactivate()
    end
end

local function scheduleUpdate() -- line: 36
    -- upvalues: v1 (ref), update (copy)
    if v1 then
        task.cancel(v1)
    end

    v1 = task.defer(update)
end

function t1.IsHidden() -- line: 43
    -- upvalues: n1 (ref)
    return n1 > 0
end

function t1.Acquire() -- line: 47
    -- upvalues: t1 (copy), n1 (ref), v1 (ref), update (copy)
    n1 += 1

    if v1 then
        task.cancel(v1)
    end

    v1 = task.defer(update)
    t1.Changed:Fire(true)

    local v4 = false

    return function() -- line: 53
        -- upvalues: v4 (ref), t1 (copy), n1 (ref), v1 (ref), update (copy)
        if v4 then
            return
        end

        v4 = true
        n1 -= 1
        assert(n1 >= 0, "hidden UI holder count became negative")

        if v1 then
            task.cancel(v1)
        end

        v1 = task.defer(update)
        t1.Changed:Fire(n1 > 0)
    end
end

return table.freeze(t1)
