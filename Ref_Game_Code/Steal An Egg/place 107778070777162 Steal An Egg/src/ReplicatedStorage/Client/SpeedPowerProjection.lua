-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Save = require(ReplicatedStorage.Shared.Save)
local Signal = require(ReplicatedStorage.Packages.Signal)
local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.number)
local t1 = {
    Changed = Signal.new()
}
local DEFAULT_BASE_SPEED_POWER = TreadmillUtil.DEFAULT_BASE_SPEED_POWER
local v2 = DEFAULT_BASE_SPEED_POWER
local v3 = DEFAULT_BASE_SPEED_POWER
local v4
local v5 = false
local v6 = DEFAULT_BASE_SPEED_POWER
local n1 = 0

local function readSavedPower() -- line: 31
    -- upvalues: Save (copy), TreadmillUtil (copy)
    local v7 = Save.Await()

    return TreadmillUtil.NormalizeSpeedPower(if v7 == nil then nil else v7.SpeedPower)
end

local function readOverride(p1) -- line: 37
    -- upvalues: Workspace (copy)
    local Attribute = Workspace:GetAttribute(p1)

    return if type(Attribute) == "number" and Attribute > 0 then Attribute else nil
end

local function republish() -- line: 63
    -- upvalues: Workspace (copy), t1 (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), n1 (ref)
    local EqualisedSpeedPower = Workspace:GetAttribute("EqualisedSpeedPower")

    if type(EqualisedSpeedPower) ~= "number" or not (EqualisedSpeedPower > 0) then
        EqualisedSpeedPower = nil
    end

    if EqualisedSpeedPower == nil then
        local v8 = v6 + n1

        if v4 ~= nil then
            if not v5 then
                v8 = math.max(v2, v8)
            end
        else
            v8 = v2
        end

        local MinimumSpeedPower = Workspace:GetAttribute("MinimumSpeedPower")

        if type(MinimumSpeedPower) ~= "number" or not (MinimumSpeedPower > 0) then
            MinimumSpeedPower = nil
        end

        EqualisedSpeedPower = if MinimumSpeedPower ~= nil then math.max(v8, MinimumSpeedPower) else v8
    end

    if EqualisedSpeedPower == v3 then
        return
    end

    v3 = EqualisedSpeedPower
    t1.Changed:Fire(v3)
end

local function syncWithSave() -- line: 71
    -- upvalues: Workspace (copy), Save (copy), TreadmillUtil (copy), t1 (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), n1 (ref)
    local v11 = Save.Await()

    v2 = TreadmillUtil.NormalizeSpeedPower(if v11 == nil then nil else v11.SpeedPower)

    local v12 = not v5 and v4 ~= nil and v2 >= v6 + n1

    if v12 then
        v4 = nil
        v6 = v2
        n1 = 0
    end

    local EqualisedSpeedPower = Workspace:GetAttribute("EqualisedSpeedPower")

    if type(EqualisedSpeedPower) ~= "number" or not (EqualisedSpeedPower > 0) then
        EqualisedSpeedPower = nil
    end

    if EqualisedSpeedPower == nil then
        local v14 = v6 + n1

        if v4 ~= nil then
            if not v5 then
                v14 = math.max(v2, v14)
            end
        else
            v14 = v2
        end

        local MinimumSpeedPower = Workspace:GetAttribute("MinimumSpeedPower")

        if type(MinimumSpeedPower) ~= "number" or not (MinimumSpeedPower > 0) then
            MinimumSpeedPower = nil
        end

        EqualisedSpeedPower = if MinimumSpeedPower ~= nil then math.max(v14, MinimumSpeedPower) else v14
    end

    if EqualisedSpeedPower == v3 then
        return
    end

    v3 = EqualisedSpeedPower
    t1.Changed:Fire(v3)
end

function t1.ReadProjected() -- line: 84
    -- upvalues: v3 (ref)
    return v3
end

function t1.OpenSession(p2) -- line: 86
    -- upvalues: Workspace (copy), Save (copy), TreadmillUtil (copy), v1 (copy), t1 (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), n1 (ref)
    v1(p2)

    local v17 = Save.Await()

    v2 = TreadmillUtil.NormalizeSpeedPower(if v17 == nil then nil else v17.SpeedPower)
    v5 = true
    v4 = p2
    v6 = math.max(v2, v3)
    n1 = 0

    local EqualisedSpeedPower = Workspace:GetAttribute("EqualisedSpeedPower")

    if type(EqualisedSpeedPower) ~= "number" or not (EqualisedSpeedPower > 0) then
        EqualisedSpeedPower = nil
    end

    if EqualisedSpeedPower == nil then
        local v20 = v6 + n1

        if v4 ~= nil then
            if not v5 then
                v20 = math.max(v2, v20)
            end
        else
            v20 = v2
        end

        local MinimumSpeedPower = Workspace:GetAttribute("MinimumSpeedPower")

        if type(MinimumSpeedPower) ~= "number" or not (MinimumSpeedPower > 0) then
            MinimumSpeedPower = nil
        end

        EqualisedSpeedPower = if MinimumSpeedPower ~= nil then math.max(v20, MinimumSpeedPower) else v20
    end

    if EqualisedSpeedPower == v3 then
        return
    end

    v3 = EqualisedSpeedPower
    t1.Changed:Fire(v3)
end

function t1.CreditRevealedGain(p3, p4) -- line: 97
    -- upvalues: Workspace (copy), v1 (copy), t1 (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), n1 (ref)
    v1(p3)
    v1(p4)

    local v23 = v4 == p3 and p4 > 0

    if v23 then
        n1 += p4

        local EqualisedSpeedPower = Workspace:GetAttribute("EqualisedSpeedPower")

        if type(EqualisedSpeedPower) ~= "number" or not (EqualisedSpeedPower > 0) then
            EqualisedSpeedPower = nil
        end

        if EqualisedSpeedPower == nil then
            local v24 = v6 + n1

            if v4 ~= nil then
                if not v5 then
                    v24 = math.max(v2, v24)
                end
            else
                v24 = v2
            end

            local MinimumSpeedPower = Workspace:GetAttribute("MinimumSpeedPower")

            if type(MinimumSpeedPower) ~= "number" or not (MinimumSpeedPower > 0) then
                MinimumSpeedPower = nil
            end

            EqualisedSpeedPower = if MinimumSpeedPower ~= nil then math.max(v24, MinimumSpeedPower) else v24
        end

        if EqualisedSpeedPower ~= v3 then
            v3 = EqualisedSpeedPower
            t1.Changed:Fire(v3)
        end
    end

    return v23
end

function t1.CloseSession(p5) -- line: 110
    -- upvalues: Workspace (copy), Save (copy), TreadmillUtil (copy), v1 (copy), t1 (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), n1 (ref)
    v1(p5)

    if v4 ~= p5 then
        return
    end

    v5 = false

    local v27 = Save.Await()

    v2 = TreadmillUtil.NormalizeSpeedPower(if v27 == nil then nil else v27.SpeedPower)

    local v28 = not v5 and v4 ~= nil and v2 >= v6 + n1

    if v28 then
        v4 = nil
        v6 = v2
        n1 = 0
    end

    local EqualisedSpeedPower = Workspace:GetAttribute("EqualisedSpeedPower")

    if type(EqualisedSpeedPower) ~= "number" or not (EqualisedSpeedPower > 0) then
        EqualisedSpeedPower = nil
    end

    if EqualisedSpeedPower == nil then
        local v30 = v6 + n1

        if v4 ~= nil then
            if not v5 then
                v30 = math.max(v2, v30)
            end
        else
            v30 = v2
        end

        local MinimumSpeedPower = Workspace:GetAttribute("MinimumSpeedPower")

        if type(MinimumSpeedPower) ~= "number" or not (MinimumSpeedPower > 0) then
            MinimumSpeedPower = nil
        end

        EqualisedSpeedPower = if MinimumSpeedPower ~= nil then math.max(v30, MinimumSpeedPower) else v30
    end

    if EqualisedSpeedPower == v3 then
        return
    end

    v3 = EqualisedSpeedPower
    t1.Changed:Fire(v3)
end

local v33 = Save.Await()

v2 = TreadmillUtil.NormalizeSpeedPower(if v33 == nil then nil else v33.SpeedPower)

local v34 = not v5 and v4 ~= nil and v6 + n1 <= v2

if v34 then
    v4 = nil
    v6 = v2
    n1 = 0
end

local EqualisedSpeedPower = Workspace:GetAttribute("EqualisedSpeedPower")

if type(EqualisedSpeedPower) ~= "number" or not (EqualisedSpeedPower > 0) then
    EqualisedSpeedPower = nil
end

if EqualisedSpeedPower == nil then
    local v35 = v6 + n1

    if v4 == nil then
        v35 = v2
    elseif not v5 then
        v35 = math.max(v2, v35)
    end

    local MinimumSpeedPower = Workspace:GetAttribute("MinimumSpeedPower")

    if type(MinimumSpeedPower) ~= "number" or not (MinimumSpeedPower > 0) then
        MinimumSpeedPower = nil
    end

    EqualisedSpeedPower = if MinimumSpeedPower == nil then v35 else math.max(v35, MinimumSpeedPower)
end

if EqualisedSpeedPower ~= v3 then
    v3 = EqualisedSpeedPower

    local Changed = t1.Changed

    Changed:Fire(v3)
end

Save.Watch("SpeedPower"):Connect(syncWithSave)
Workspace:GetAttributeChangedSignal("EqualisedSpeedPower"):Connect(republish)
Workspace:GetAttributeChangedSignal("MinimumSpeedPower"):Connect(republish)

return t1
