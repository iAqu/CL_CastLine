-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local t = require(ReplicatedStorage.Packages.t)
local DrawWeighted = require(ReplicatedStorage.Shared.Utils.Numeric).DrawWeighted
local v1 = Color3.fromRGB(255, 255, 255)
local v2 = t.strict(t.Color3)
local v3 = t.strict(t.optional(t.number))
local v4 = t.strict(t.optional(t.string))
local v5 = t.strict(t.instanceIsA("Model"))
local v6 = t.strict(t.number)
local v7 = t.strict(t.string)
local t1 = {}

local function speciesEntry(p1) -- line: 43
    -- upvalues: Assets (copy)
    local v8 = Assets.Directory[p1]

    assert(v8 ~= nil, (("Asset catalog carries no palette named %*"):format(p1)))

    return v8
end

local function wearsIris(p2) -- line: 49
    if p2:GetAttribute("IsEye") == true then
        return true
    end

    return string.find(string.lower(p2.Name), "eye", 1, true) ~= nil
end

local function wearsBaseCoat(p3, p4) -- line: 56
    local v11, v12, v13 = p3:ToHSV()
    local v14, v15, v16 = p4:ToHSV()
    local v17 = v12 < 0.16

    if v15 < 0.16 then
        if v17 then
            if v16 < 0.08 then
                return v13 <= 0.08
            end

            v17 = math.abs(v13 - v16) <= 0.18
        end

        return v17
    end

    local v20 = math.abs(v11 - v14)
    local v21 = v13 / math.max(v16, 0.001)

    return not v17 and math.min(v20, 1 - v20) <= 0.08 and v21 >= 0.08 and v21 <= 1.6
end

local function tint(p5, p6, p7, p8, p9) -- line: 79
    local _, _, v24 = p5.Color:ToHSV()
    local _, _, v25 = p6:ToHSV()
    local v26, v27, v28 = p7:ToHSV()

    if not (v25 < 0.08) then
        v28 *= v24 / math.max(v25, 0.001)
    end

    local v29 = v28 * Random.new(p8 + 7919 + p9):NextNumber(0.8333333333333334, 1.2)

    p5.Color = Color3.fromHSV(v26, v27, (math.clamp(v29, 0, 1)))

    if p5:IsA("UnionOperation") then
        p5.UsePartColor = true
    end
end

function t1.DrawEyeColorHex(p10) -- line: 95
    -- upvalues: t (copy)
    assert(t.Random(p10), "An iris draw needs a generator to draw from")

    local v31 = p10:NextNumber()
    local v32 = p10:NextNumber(0.35, 0.85)
    local v33 = p10:NextNumber(0.35, 0.9)

    return Color3.fromHSV(v31, v32, v33):ToHex()
end

function t1.DrawColorSeed(p11) -- line: 104
    -- upvalues: t (copy)
    assert(t.Random(p11), "A colour seed draw needs a generator to draw from")

    return p11:NextInteger(1, 2147483647)
end

function t1.DrawColorIndex(p12, p13) -- line: 110
    -- upvalues: Assets (copy), t (copy), DrawWeighted (copy), v7 (copy)
    v7(p12)
    assert(t.Random(p13), "A palette slot draw needs a generator to draw from")

    local v36 = Assets.Directory[p12]

    assert(v36 ~= nil, (("Asset catalog carries no palette named %*"):format(p12)))

    local v39 = DrawWeighted(v36.PossibleModelColors, p13)

    if v39 then
        return v39.Index
    end

    return 0
end

function t1.DrawFields(p14, p15) -- line: 119
    -- upvalues: t (copy), v7 (copy), t1 (copy)
    v7(p14)
    assert(t.Random(p15), "A palette draw needs a generator to draw from")

    return {
        EyeColor = t1.DrawEyeColorHex(p15),
        ColorSeed = t1.DrawColorSeed(p15),
        ColorIndex = t1.DrawColorIndex(p14, p15)
    }
end

function t1.SettleFields(p16, p17, p18, p19) -- line: 130
    -- upvalues: v3 (copy), v4 (copy), v7 (copy), t1 (copy)
    v7(p16)
    v4(p17)
    v3(p18)
    v3(p19)

    local v41 = if p18 == nil then 1 else p18

    return {
        EyeColor = if p17 == nil or p17 == "" then t1.DrawEyeColorHex(Random.new(v41)) else p17,
        ColorSeed = v41,
        ColorIndex = if p19 == nil then 1 else p19
    }
end

function t1.ModelColorAt(p20, p21) -- line: 153
    -- upvalues: Assets (copy), Constants (copy), v2 (copy), v6 (copy), v7 (copy)
    v7(p20)
    v6(p21)

    local v42 = Assets.Directory[p20]

    assert(v42 ~= nil, (("Asset catalog carries no palette named %*"):format(p20)))

    local PossibleModelColors = v42.PossibleModelColors

    if #PossibleModelColors == 0 or p21 <= 0 then
        return nil
    end

    if Constants.IS_STUDIO then
        assert(PossibleModelColors[p21], (("Palette for %* stops short of slot %*"):format(p20, p21)))
    end

    local v47 = PossibleModelColors[(p21 - 1) % #PossibleModelColors + 1][1]

    v2(v47)

    return v47
end

function t1.PaintModel(p22, p23, p24, p25, p26) -- line: 170
    -- upvalues: Assets (copy), v1 (copy), v5 (copy), v6 (copy), v7 (copy), t1 (copy), wearsBaseCoat (copy), tint (copy)
    v5(p22)
    v7(p23)
    v7(p24)
    v6(p25)
    v6(p26)

    local v48 = Assets.Directory[p23]

    assert(v48 ~= nil, (("Asset catalog carries no palette named %*"):format(p23)))

    local v51 = Color3.fromHex(p24)
    local v52 = t1.ModelColorAt(p23, p26)
    local v53 = Random.new(p25):NextNumber() < 0.5
    local n1 = 0

    for _, descendant in p22:GetDescendants() do
        local descendant2 = if descendant:IsA("BasePart") then descendant else nil

        if not (descendant2 == nil or descendant2:GetAttribute("DontModify") or descendant2.Transparency >= 1) then
            n1 += 1

            if descendant2:GetAttribute("IsEye") == true or string.find(string.lower(descendant2.Name), "eye", 1, true) ~= nil then
                if v53 then
                    descendant2.Color = v51
                end
            elseif v52 ~= nil then
                if v52 == v1 and v48.AlbinosColorFullWhite then
                    descendant2.Color = v52
                elseif wearsBaseCoat(descendant2.Color, v48.BaseModelColor) then
                    tint(descendant2, v48.BaseModelColor, v52, p25, n1)
                end
            end
        end
    end
end

return t1
