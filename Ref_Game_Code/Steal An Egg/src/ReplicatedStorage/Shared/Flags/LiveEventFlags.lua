-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local DeepCopyPureUnsafe = require(ReplicatedStorage.UserGenerated.Collections.DeepCopyPureUnsafe)
local DeepEqualsPureUnsafe = require(ReplicatedStorage.UserGenerated.Collections.DeepEqualsPureUnsafe)
local DeepFreezeUnsafe = require(ReplicatedStorage.UserGenerated.Collections.DeepFreezeUnsafe)
local Signal = require(ReplicatedStorage.Packages.Signal)
local t1 = {}

local function decodeJson(p1) -- line: 40
    -- upvalues: HttpService (copy)
    if type(p1) ~= "string" then
        return false, nil
    end

    local JSONDecode = HttpService.JSONDecode

    return pcall(JSONDecode, HttpService, p1)
end

local function define(p2, p3, p4) -- line: 47
    -- upvalues: HttpService (copy), Asserts (copy), DeepCopyPureUnsafe (copy), DeepEqualsPureUnsafe (copy), DeepFreezeUnsafe (copy), Signal (copy)
    Asserts.String(p2)
    assert(string.match(p2, "^%w+$") ~= nil, (("live event flag name %* must be alphanumeric"):format(p2)))
    Asserts.Function(p3)
    p3(p4)
    Asserts.Storable(p4)

    local v3 = DeepFreezeUnsafe(DeepCopyPureUnsafe(p4))
    local v4 = "LiveEventFlag_" .. p2
    local v5 = v4 .. "_Steps"
    local v6 = Signal.new()

    local function decodeAttribute(p5) -- line: 59
        -- upvalues: p2 (copy), p3 (copy), v3 (copy), HttpService (copy), DeepFreezeUnsafe (copy)
        if p5 == nil then
            return false, v3
        end

        local ok, result

        if type(p5) == "string" then
            local JSONDecode = HttpService.JSONDecode

            ok, result = pcall(JSONDecode, HttpService, p5)
        else
            ok = false
        end

        if not ok then
            warn((("[LiveEventFlags] UndecodableValue '%*'"):format(p2)))

            return true, v3
        end

        local ok2, result2 = pcall(p3, result)

        if ok2 then
            return true, DeepFreezeUnsafe(result)
        end

        warn(("[LiveEventFlags] InvalidStoredValue '%*':"):format(p2), result2, result)

        return true, v3
    end

    local Attribute
    local v7 = false
    local v8 = v3

    local function refreshFromAttribute() -- line: 80
        -- upvalues: v4 (copy), decodeAttribute (copy), Attribute (ref), v7 (ref), v8 (ref)
        local Attribute2 = workspace:GetAttribute(v4)

        if Attribute2 == Attribute then
            return
        end

        Attribute = Attribute2
        v7, v8 = decodeAttribute(Attribute2)
    end

    local Attribute2 = workspace:GetAttribute(v4)

    if Attribute2 ~= Attribute then
        Attribute = Attribute2
        v7, v8 = decodeAttribute(Attribute2)
    end

    local v9 = v8
    local t2 = {
        Name = p2,
        AttributeName = v4,
        StepsAttributeName = v5,
        DefaultValue = v3,
        Assertion = p3,
        Changed = v6,
        Get = function(_) -- Get | line: 98
            -- upvalues: v4 (copy), decodeAttribute (copy), Attribute (ref), v7 (ref), v8 (ref)
            local Attribute2 = workspace:GetAttribute(v4)

            if Attribute2 ~= Attribute then
                Attribute = Attribute2
                v7, v8 = decodeAttribute(Attribute2)
            end

            return v8
        end,
        IsSynced = function(_) -- IsSynced | line: 102
            -- upvalues: v4 (copy), decodeAttribute (copy), Attribute (ref), v7 (ref), v8 (ref)
            local Attribute2 = workspace:GetAttribute(v4)

            if Attribute2 ~= Attribute then
                Attribute = Attribute2
                v7, v8 = decodeAttribute(Attribute2)
            end

            return v7
        end,
        GetPendingSteps = function(_) -- GetPendingSteps | line: 106
            -- upvalues: p3 (copy), v5 (copy), HttpService (copy), DeepFreezeUnsafe (copy)
            local t3 = {}
            local Attribute = workspace:GetAttribute(v5)
            local ok, result

            if type(Attribute) == "string" then
                local JSONDecode = HttpService.JSONDecode

                ok, result = pcall(JSONDecode, HttpService, Attribute)
            else
                ok = false
            end

            if ok and type(result) == "table" then
                local v10 = os.time()

                for _, v11 in result do
                    if type(v11) == "table" and type(v11.At) == "number" and not (v11.At <= v10) then
                        local Value = v11.Value

                        if pcall(p3, Value) then
                            table.insert(t3, {
                                At = v11.At,
                                Value = DeepFreezeUnsafe(v11.Value)
                            })
                        end
                    end
                end

                table.sort(t3, function(p9, p10) -- line: 121
                    return p9.At < p10.At
                end)
            end

            return t3
        end
    }

    workspace:GetAttributeChangedSignal(v4):Connect(function() -- line: 128
        -- upvalues: v4 (copy), v6 (copy), decodeAttribute (copy), Attribute (ref), v7 (ref), v8 (ref), v9 (ref), DeepEqualsPureUnsafe (copy)
        local Attribute2 = workspace:GetAttribute(v4)

        if Attribute2 ~= Attribute then
            Attribute = Attribute2
            v7, v8 = decodeAttribute(Attribute2)
        end

        if DeepEqualsPureUnsafe(v8, v9) then
            return
        end

        local v12 = v9

        v9 = v8
        v6:Fire(v8, v12)
    end)

    return table.freeze(t2)
end

local function AssertLightDarkReveal(p11) -- line: 148
    if p11 == false then
        return p11
    end

    assert(type(p11) == "table", "LightDarkReveal must be false or a table")
    assert(type(p11.RevealPeriod) == "number" and p11.RevealPeriod % 1 == 0, "LightDarkReveal.RevealPeriod must be an integer")
    assert(p11.Winner == "Light" or p11.Winner == "Dark", "LightDarkReveal.Winner must be Light or Dark")

    local v17 = p11.WinnerPeriod == nil or type(p11.WinnerPeriod) == "number" and p11.WinnerPeriod % 1 == 0

    assert(v17, "LightDarkReveal.WinnerPeriod must be nil or an integer")

    return p11
end

local function AssertTrainEventOpen(p12) -- line: 170
    -- upvalues: Asserts (copy)
    if p12 == false then
        return p12
    end

    assert(type(p12) == "table", "TrainEventOpen must be false or a table")
    Asserts.FinitePositive(p12.CutsceneEndedAt)

    return p12
end

t1.Directory = table.freeze({
    TrainEventOpen = define("TrainEventOpen", AssertTrainEventOpen, false),
    LightDarkReveal = define("LightDarkReveal", AssertLightDarkReveal, false),
    RiftOpen = define("RiftOpen", Asserts.Boolean, false),
    EnchantedForestOpen = define("EnchantedForestOpen", Asserts.Boolean, false),
    StarHandlerOpen = define("StarHandlerOpen", Asserts.Boolean, false),
    HalloweenDimensionContentEnabled = define("HalloweenDimensionContentEnabled", Asserts.Boolean, false),
    HalloweenManorGateOpen = define("HalloweenManorGateOpen", Asserts.Boolean, false)
})

local t5 = {}
local t6 = {}

for v19, v20 in t1.Directory do
    t5[v19] = v20
    table.insert(t6, v19)
end

table.sort(t6)
t1.Names = table.freeze(t6)

function t1.Get(p13) -- line: 203
    -- upvalues: t5 (copy)
    local v21 = t5[p13]

    assert(v21 ~= nil, (("unknown live event flag %*"):format(p13)))

    return v21
end

function t1.IsKnown(p14) -- line: 209
    -- upvalues: t5 (copy)
    if type(p14) == "string" then
        return t5[p14] ~= nil
    end

    return false
end

return table.freeze(t1)
