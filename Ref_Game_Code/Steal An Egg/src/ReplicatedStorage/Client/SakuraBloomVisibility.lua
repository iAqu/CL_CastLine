-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {
    "LocalTransparencyModifier",
    "CanCollide",
    "CanQuery",
    "CanTouch"
}
local t2 = {
    CanCollide = false,
    CanQuery = false,
    CanTouch = false,
    LocalTransparencyModifier = 1
}
local t3 = {
    "Decal",
    "Texture"
}
local t4 = {
    "Transparency"
}
local t5 = {
    Transparency = 1
}
local t6 = {
    "Enabled"
}
local t7 = {
    Enabled = false
}
local t8 = {
    "ParticleEmitter",
    "Beam",
    "Trail",
    "BillboardGui",
    "SurfaceGui",
    "Highlight",
    "Light",
    "ProximityPrompt"
}
local t9 = {}

local function anyClassMatches(p1, p2) -- line: 36
    for _, v1 in p2 do
        if p1:IsA(v1) then
            return true
        end
    end

    return false
end

local function muteFields(p3, p4, p5, p6) -- line: 48
    local v2 = table.create(#p5)

    for v3, v4 in p5 do
        v2[v3] = p4[v4]
        p4[v4] = p6[v4]
    end

    p3:Add(function() -- line: 62
        -- upvalues: p4 (copy), p5 (copy), v2 (copy)
        if p4.Parent == nil then
            return
        end

        for v5, v6 in p5 do
            p4[v6] = v2[v5]
        end
    end)
end

local function mute(p7, p8) -- line: 73
    -- upvalues: t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), muteFields (copy)
    if p8:IsA("BasePart") then
        muteFields(p7, p8, t1, t2)
    else
        local v7 = false
        local v8

        for _, v9 in t3 do
            if p8:IsA(v9) then
                v8 = true
                v7 = true
                break
            end
        end

        if not v7 then
            v8 = false
        end

        if v8 then
            muteFields(p7, p8, t4, t5)
        else
            local v10 = false
            local v11

            for _, v12 in t8 do
                if p8:IsA(v12) then
                    v11 = true
                    v10 = true
                    break
                end
            end

            if not v10 then
                v11 = false
            end

            if v11 then
                muteFields(p7, p8, t6, t7)
            end
        end
    end
end

function t9.Conceal(p9) -- line: 83
    -- upvalues: Trove (copy), mute (copy)
    local v13 = Trove.new()

    for _, descendant in p9:GetDescendants() do
        mute(v13, descendant)
    end

    v13:Add(p9.DescendantAdded:Connect(function(p10) -- line: 90
        -- upvalues: v13 (copy), mute (copy)
        mute(v13, p10)
    end))

    return v13
end

return table.freeze(t9)
