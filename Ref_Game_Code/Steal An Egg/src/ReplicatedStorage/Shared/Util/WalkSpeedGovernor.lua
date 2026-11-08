-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))
local v2 = t.strict(v1)
local v3 = t.strict(t.optional(t.instanceIsA("Humanoid")))
local v4 = t.strict(t.optional(t.string))
local v5 = t.strict(t.string)
local t1 = {}

t1.__index = t1

local function foldModifiers(p1, p2) -- line: 63
    -- upvalues: v2 (copy)
    v2(p1)

    local t2 = {}
    local n1 = 0

    for _, v6 in ipairs(p2) do
        if v6.type == "positive" then
            n1 += v6.value
        elseif v6.type == "malus" then
            table.insert(t2, v6.value)
        end
    end

    local v7 = p1 * (n1 + 1)

    for _, v8 in ipairs(t2) do
        v7 *= v8 + 1
    end

    return (math.max(0, v7))
end

local function refold(p3) -- line: 86
    -- upvalues: foldModifiers (copy)
    local v9 = foldModifiers(p3.baseSpeed, p3.modifiers)
    local v10

    for _, v11 in p3.speedOverrides do
        v10 = if v10 ~= nil then math.min(v10, v11.value) else v11.value
    end

    if v10 ~= nil then
        v9 = v10
    end

    if not (math.abs(v9 - p3.appliedSpeed) < 0.001) then
        p3.appliedSpeed = v9

        if p3.humanoid then
            p3.humanoid.WalkSpeed = v9
        end
    end
end

function t1.new(p4) -- line: 105
    -- upvalues: Constants (copy), v2 (copy), t1 (copy)
    p4 = p4 or Constants.BASE_WALK_SPEED
    v2(p4)
    assert(p4 > 0)

    local self = setmetatable({}, t1)

    self.baseSpeed = p4
    self.appliedSpeed = p4
    self.modifiers = {}
    self.speedOverrides = {}
    self.humanoid = nil

    return self
end

function t1:CurrentSpeed() -- line: 122
    return self.appliedSpeed
end

function t1:BaseSpeed() -- line: 126
    return self.baseSpeed
end

function t1:Modifiers() -- line: 130
    return self.modifiers
end

function t1:Bind(p9) -- line: 134
    -- upvalues: v3 (copy)
    v3(p9)

    if self.humanoid ~= p9 then
        self.humanoid = p9

        if p9 then
            p9.WalkSpeed = self.appliedSpeed
        end
    end
end

function t1:Rebase(p11) -- line: 148
    -- upvalues: v2 (copy), refold (copy)
    v2(p11)
    assert(p11 > 0)

    if self.baseSpeed ~= p11 then
        self.baseSpeed = p11
        refold(self)
    end
end

function t1:Attach(p13, p14, p15, p16) -- line: 160
    -- upvalues: v2 (copy), v4 (copy), v5 (copy), refold (copy)
    v5(p13)
    assert(p14 == "positive" or p14 == "malus")
    v2(p15)
    v4(p16)

    for _, v18 in ipairs(self.modifiers) do
        if v18.id == p13 then
            error((("A modifier called %* is already attached to this stat"):format(p13)))
        end
    end

    table.insert(self.modifiers, {
        id = p13,
        type = p14,
        value = p15,
        source = p16
    })
    refold(self)
end

function t1:HasModifier(p18) -- line: 182
    -- upvalues: v5 (copy)
    v5(p18)

    for _, v19 in ipairs(self.modifiers) do
        if v19.id == p18 then
            return true
        end
    end

    return false
end

function t1:Detach(p20) -- line: 194
    -- upvalues: v5 (copy), refold (copy)
    v5(p20)

    for v20, v21 in ipairs(self.modifiers) do
        if v21.id == p20 then
            table.remove(self.modifiers, v20)
            refold(self)

            return
        end
    end
end

function t1:Override(p22, p23, p24) -- line: 206
    -- upvalues: v2 (copy), v4 (copy), v5 (copy), refold (copy)
    v5(p22)
    v4(p24)

    if p23 ~= nil then
        v2(p23)
        assert(p23 >= 0)
    end

    local speedOverrides = self.speedOverrides

    if p23 ~= nil then
        speedOverrides[p22] = {
            value = p23,
            source = p24
        }
    else
        speedOverrides[p22] = nil
    end

    refold(self)
end

function t1:DetachSource(p26) -- line: 214
    -- upvalues: v5 (copy), refold (copy)
    v5(p26)

    local v23 = #self.modifiers
    local v24 = false

    for i = v23, 1, -1 do
        if self.modifiers[i].source == p26 then
            v24 = true
            table.remove(self.modifiers, i)
        end
    end

    for v25, v26 in self.speedOverrides do
        if v26.source == p26 then
            v24 = true
            self.speedOverrides[v25] = nil
        end
    end

    if v24 then
        refold(self)
    end
end

function t1:Destroy() -- line: 234
    self.humanoid = nil
end

return t1
