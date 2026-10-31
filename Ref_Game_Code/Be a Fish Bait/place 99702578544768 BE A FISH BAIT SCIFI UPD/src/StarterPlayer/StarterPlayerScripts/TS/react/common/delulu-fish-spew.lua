-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local mutations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mutations")
local deluluMutationName, deluluSpewPhrases = mutations.deluluMutationName, mutations.deluluSpewPhrases
local default = RuntimeLib.import(script, script.Parent, "text-spew").default

local function getOrCreateSpewAnchor(p1) -- line: 23
    local __DeluluSpewAnchor = p1:FindFirstChild("__DeluluSpewAnchor")

    if __DeluluSpewAnchor ~= nil and __DeluluSpewAnchor:IsA("BasePart") then
        return __DeluluSpewAnchor
    end

    local PrimaryPart = p1.PrimaryPart

    if PrimaryPart == nil then
        return nil
    end

    local BoundingBox, BoundingBox2 = p1:GetBoundingBox()
    local Part = Instance.new("Part")

    Part.Name = "__DeluluSpewAnchor"
    Part.Size = BoundingBox2
    Part.CFrame = BoundingBox
    Part.Transparency = 1
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Massless = true
    Part.Anchored = false
    Part.Parent = p1

    local WeldConstraint = Instance.new("WeldConstraint")

    WeldConstraint.Part0 = Part
    WeldConstraint.Part1 = PrimaryPart
    WeldConstraint.Parent = Part

    return Part
end

local function areDeluluFishSpewPropsEqual(p2, p3) -- line: 50
    if p2.model ~= p3.model then
        return false
    end

    if p2.mutations ~= p3.mutations then
        if #p2.mutations ~= #p3.mutations then
            return false
        end

        for v1, v2 in p2.mutations do
            local v3 = v1 - 1

            if v2 ~= p3.mutations[v3 + 1] then
                return false
            end
        end
    end

    return true
end

local function DeluluFishSpewInner(p4) -- line: 84
    -- upvalues: react (copy), useEffect (copy), useState (copy), deluluMutationName (copy), deluluSpewPhrases (copy), default (copy), getOrCreateSpewAnchor (copy)
    local model, mutations = p4.model, p4.mutations
    local v4 = table.find(mutations, deluluMutationName) ~= nil
    local v5, v6 = useState(0)
    local v7, v8 = useState()

    useEffect(function() -- line: 90
        -- upvalues: model (copy), v8 (copy), v4 (copy), getOrCreateSpewAnchor (copy)
        if not v4 then
            return nil
        end

        v8((getOrCreateSpewAnchor(model)))
    end, { v4, model })
    useEffect(function() -- line: 96
        -- upvalues: v6 (copy), v4 (copy)
        if not v4 then
            return nil
        end

        local v9, v10

        v10 = function() -- line: 102
            -- upvalues: v10 (ref), v9 (ref), v6 (copy)
            v9 = task.delay(math.random(4, 6), function() -- line: 103
                -- upvalues: v10 (ref), v6 (copy)
                v6(function(p5) -- line: 104
                    return p5 + 1
                end)
                v10()
            end)
        end

        v6(function(p6) -- line: 110
            return p6 + 1
        end)
        v10()

        return function() -- line: 114
            -- upvalues: v9 (ref)
            if v9 ~= nil then
                task.cancel(v9)
            end
        end
    end, { v4 })

    if v4 then
        return react.createElement(default, {
            count = 1,
            adornee = v7,
            color = Color3.new(1, 0.5, 0.9),
            model = model,
            size = UDim2.fromScale(0.025, 0.025),
            texts = deluluSpewPhrases,
            trigger = v5
        })
    end

    return nil
end

return {
    default = react.memo(DeluluFishSpewInner, areDeluluFishSpewPropsEqual)
}
