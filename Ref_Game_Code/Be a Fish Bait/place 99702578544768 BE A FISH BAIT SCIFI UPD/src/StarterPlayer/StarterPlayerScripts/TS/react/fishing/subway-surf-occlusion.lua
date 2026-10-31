-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local CollectionService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").CollectionService
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local hookFlightSteeringActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "hook-flight-steering-atom").hookFlightSteeringActiveAtom
local subwaySurfOcclusionConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "subway-surf-occlusion-config").subwaySurfOcclusionConfig

local function applyParticleFade(p1, p2) -- line: 10
    local v1 = 1 - math.clamp(p2, 0, 1)
    local Keypoints = p1.Keypoints
    local v2 = table.create(#Keypoints)

    for v3, v4 in Keypoints do
        local _ = v3 - 1
        local v5 = 1 - (1 - v4.Value) * v1

        v2[v3] = NumberSequenceKeypoint.new(v4.Time, v5, v4.Envelope * v1)
    end

    return NumberSequence.new(v2)
end

local function collectEntry(p3) -- line: 25
    local t1 = {}
    local t2 = {}
    local t3 = {}

    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t1, {
                part = descendant,
                originalModifier = descendant.LocalTransparencyModifier
            })
        elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") then
            table.insert(t2, {
                effect = descendant,
                originalTransparency = descendant.Transparency
            })
        elseif descendant:IsA("Smoke") then
            table.insert(t3, {
                effect = descendant,
                originalOpacity = descendant.Opacity
            })
        end
    end

    return {
        model = p3,
        numberSequenceVfx = t2,
        parts = t1,
        smokeVfx = t3
    }
end

local function restoreEntry(p4) -- line: 57
    for _, v6 in p4.parts do
        if v6.part.Parent ~= nil then
            v6.part.LocalTransparencyModifier = v6.originalModifier
        end
    end

    for _, v7 in p4.numberSequenceVfx do
        if v7.effect.Parent ~= nil then
            v7.effect.Transparency = v7.originalTransparency
        end
    end

    for _, v8 in p4.smokeVfx do
        if v8.effect.Parent ~= nil then
            v8.effect.Opacity = v8.originalOpacity
        end
    end
end

local function applyEntry(p5) -- line: 74
    -- upvalues: subwaySurfOcclusionConfig (copy), applyParticleFade (copy)
    local occlusionMaxTransparency = subwaySurfOcclusionConfig.occlusionMaxTransparency

    for _, v9 in p5.parts do
        if v9.part.Parent ~= nil then
            v9.part.LocalTransparencyModifier = 1 - (1 - v9.originalModifier) * (1 - occlusionMaxTransparency)
        end
    end

    for _, v10 in p5.numberSequenceVfx do
        if v10.effect.Parent ~= nil then
            v10.effect.Transparency = applyParticleFade(v10.originalTransparency, occlusionMaxTransparency)
        end
    end

    for _, v11 in p5.smokeVfx do
        if v11.effect.Parent ~= nil then
            v11.effect.Opacity = v11.originalOpacity * (1 - occlusionMaxTransparency)
        end
    end
end

return {
    SubwaySurfOcclusion = function() -- SubwaySurfOcclusion | line: 93
        -- upvalues: react (copy), useEffect (copy), CollectionService (copy), subscribe (copy), hookFlightSteeringActiveAtom (copy), collectEntry (copy), restoreEntry (copy), applyEntry (copy)
        useEffect(function() -- line: 94
            -- upvalues: CollectionService (copy), subscribe (copy), hookFlightSteeringActiveAtom (copy), collectEntry (copy), restoreEntry (copy), applyEntry (copy)
            local t7 = {}
            local v12 = false

            local function v13() -- line: 97
                -- upvalues: t7 (ref), v12 (ref), restoreEntry (copy)
                local v14 = v12

                if not v14 and #t7 == 0 then
                    return nil
                end

                for _, v15 in t7 do
                    restoreEntry(v15)
                end

                t7 = {}
                v12 = false
            end

            local function v16() -- line: 107
                -- upvalues: t7 (ref), v12 (ref), v13 (copy), CollectionService (copy), collectEntry (copy), applyEntry (copy)
                v13()

                for _, v17 in CollectionService:GetTagged("SubwaySurfOcclusion") do
                    if v17:IsA("Model") then
                        local v18 = collectEntry(v17)

                        if #v18.parts ~= 0 or #v18.numberSequenceVfx ~= 0 or #v18.smokeVfx ~= 0 then
                            applyEntry(v18)
                            table.insert(t7, v18)
                        end
                    end
                end

                v12 = true
            end

            local v20 = subscribe(hookFlightSteeringActiveAtom, function(p6) -- line: 122
                -- upvalues: v13 (copy), v16 (copy)
                if p6 then
                    v16()
                else
                    v13()
                end
            end)

            if hookFlightSteeringActiveAtom() then
                v16()
            else
                v13()
            end

            return function() -- line: 131
                -- upvalues: v13 (copy), v20 (copy)
                v20()
                v13()
            end
        end, {})

        return react.createElement(react.Fragment)
    end
}
