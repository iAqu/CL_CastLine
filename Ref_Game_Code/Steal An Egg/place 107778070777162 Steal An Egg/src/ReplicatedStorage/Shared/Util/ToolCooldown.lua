-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))
local t1 = {
    {
        attribute = "CooldownEndTime",
        kind = "number",
        blank = 0
    },
    {
        attribute = "CooldownDuration",
        kind = "number",
        blank = 0
    },
    {
        attribute = "CooldownActive",
        kind = "boolean",
        blank = false
    }
}
local v2 = t.strict(v1)
local v3 = t.strict(t.instanceIsA("Tool"))
local t2 = {}

local function readyAtOf(p1) -- line: 30
    local CooldownEndTime = p1:GetAttribute("CooldownEndTime")

    return if type(CooldownEndTime) == "number" then CooldownEndTime else nil
end

local function markIdle(p2) -- line: 35
    p2:SetAttribute("CooldownActive", false)
    p2:SetAttribute("CooldownDuration", 0)
    p2:SetAttribute("CooldownEndTime", 0)
end

function t2.PrimeTool(p3) -- line: 41
    -- upvalues: t1 (copy), v3 (copy)
    v3(p3)

    for _, v4 in t1 do
        if typeof(p3:GetAttribute(v4.attribute)) ~= v4.kind then
            p3:SetAttribute(v4.attribute, v4.blank)
        end
    end
end

function t2.IsRunning(p4) -- line: 51
    -- upvalues: v3 (copy)
    v3(p4)

    local CooldownEndTime

    if p4:GetAttribute("CooldownActive") then
        CooldownEndTime = p4:GetAttribute("CooldownEndTime")

        if type(CooldownEndTime) ~= "number" then
            CooldownEndTime = nil
        end
    end

    return CooldownEndTime ~= nil and workspace:GetServerTimeNow() < CooldownEndTime
end

function t2.SecondsRemaining(p5) -- line: 58
    -- upvalues: v3 (copy), t2 (copy)
    v3(p5)

    local CooldownEndTime

    if t2.IsRunning(p5) then
        CooldownEndTime = p5:GetAttribute("CooldownEndTime")

        if type(CooldownEndTime) ~= "number" then
            CooldownEndTime = nil
        end
    end

    if CooldownEndTime == nil then
        return 0
    end

    return (math.max(0, CooldownEndTime - workspace:GetServerTimeNow()))
end

function t2.Begin(p6, p7) -- line: 65
    -- upvalues: v2 (copy), v3 (copy)
    v3(p6)
    v2(p7)
    assert(p7 >= 0)

    local v7 = workspace:GetServerTimeNow() + p7

    p6:SetAttribute("CooldownDuration", p7)
    p6:SetAttribute("CooldownEndTime", v7)
    p6:SetAttribute("CooldownActive", true)
    task.delay(p7, function() -- line: 75
        -- upvalues: p6 (copy), v7 (copy)
        if not p6 or not p6.Parent or p6:GetAttribute("CooldownEndTime") ~= v7 then
            return
        end

        p6:SetAttribute("CooldownActive", false)
        p6:SetAttribute("CooldownDuration", 0)
        p6:SetAttribute("CooldownEndTime", 0)
    end)
end

function t2.Cancel(p8) -- line: 83
    -- upvalues: v3 (copy)
    v3(p8)
    p8:SetAttribute("CooldownActive", false)
    p8:SetAttribute("CooldownDuration", 0)
    p8:SetAttribute("CooldownEndTime", 0)
end

return t2
