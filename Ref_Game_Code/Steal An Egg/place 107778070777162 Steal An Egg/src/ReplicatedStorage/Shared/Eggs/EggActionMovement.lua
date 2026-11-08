-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))

local function v2(p1) -- line: 12
    -- upvalues: v1 (copy)
    if typeof(p1) ~= "CFrame" then
        return false
    end

    for _, v3 in ipairs({ p1:GetComponents() }) do
        if not v1(v3) then
            return false
        end
    end

    return true
end

local BulkPartMotion = require(ReplicatedStorage.Client.BulkPartMotion)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}
local t2 = {}

local function newModelState(p2) -- line: 43
    -- upvalues: t (copy), BulkPartMotion (copy), Trove (copy), t1 (copy), t2 (copy)
    local PrimaryPart = p2.PrimaryPart

    t.strict(t.instanceIsA("BasePart"))(PrimaryPart)
    PrimaryPart.Anchored = true

    local v4 = Trove.new()
    local t3 = {}

    for v5, v6 in { PrimaryPart } do
        t3[v5] = BulkPartMotion.Register(v6)
    end

    v4:Add(function() -- line: 55
        -- upvalues: t3 (copy)
        for _, v7 in t3 do
            v7:Destroy()
        end
    end)

    local t4 = {
        Parts = { PrimaryPart },
        Components = t3,
        Trove = v4
    }

    t1[p2] = t4
    v4:Connect(p2.Destroying, function() -- line: 67
        -- upvalues: p2 (copy), t2 (copy)
        t2.Remove(p2)
    end)

    return t4
end

function t2.SetPivot(p3, p4) -- line: 76
    -- upvalues: t (copy), v2 (copy), t1 (copy), newModelState (copy)
    t.strict(t.instanceIsA("Model"))(p3)
    t.strict(v2)(p4)

    local v8 = t1[p3] or newModelState(p3)
    local Pivot = p3:GetPivot()

    for v9, v10 in v8.Parts do
        local v11 = Pivot:ToObjectSpace(v10.CFrame)

        v8.Components[v9]:SetCFrame(p4 * v11)
    end
end

function t2.Remove(p5) -- line: 88
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.instanceIsA("Model"))(p5)

    local v12 = t1[p5]

    if v12 ~= nil then
        t1[p5] = nil
        v12.Trove:Destroy()
    end
end

return t2
