-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Audio = require(ReplicatedStorage.Shared.Audio)
local t1 = {}

local function sizeFactor(p1, p2, p3) -- line: 39
    local weight, baseWeight

    if p3 then
        weight = p3.weight
        baseWeight = p3.baseWeight
    end

    if p2 == "WalkSound" and typeof(weight) == "number" and typeof(baseWeight) == "number" and baseWeight > 0 then
        return (math.max(weight / baseWeight, 0.001))
    end

    local v2 = if not p3 then 1 elseif typeof(p3.baseModelScale) == "number" then p3.baseModelScale else 1

    if v2 <= 0 then
        v2 = 1
    end

    return (math.max(p1:GetScale() / v2, 0.001))
end

local function scaled(p4, p5, p6, p7) -- line: 62
    return if typeof(p4) == "number" then p4 * math.clamp(p5, p6, p7) else nil
end

local function splitMutationList(p8) -- line: 70
    local t2 = {}

    if typeof(p8) == "string" and p8 ~= "" then
        for match in string.gmatch(p8, "[^,]+") do
            local v4 = match:gsub("^%s*(.-)%s*$", "%1")

            if v4 ~= "" then
                table.insert(t2, v4)
            end
        end
    end

    return t2
end

function t1.BuildSound(p9, p10, p11, p12, p13) -- line: 86
    -- upvalues: Audio (copy), sizeFactor (copy)
    if not p11 then
        return nil
    end

    local Sound = Instance.new("Sound")

    Sound.Name = p12
    Audio.Configure(Sound, p11)
    Sound.RollOffMaxDistance = 40

    local v5 = sizeFactor(p10, p12, p13)

    if Sound.Volume > 0 then
        local v6 = if p12 == "WalkSound" then 3.5 else 3
        local Volume = Sound.Volume
        local v7 = if typeof(Volume) == "number" then Volume * math.clamp(v5, 1, v6) else nil

        if v7 then
            Sound.Volume = v7
        end
    end

    if Sound.RollOffMaxDistance > 0 then
        local RollOffMaxDistance = Sound.RollOffMaxDistance
        local v8 = if typeof(RollOffMaxDistance) == "number" then RollOffMaxDistance * math.clamp(v5, 0.7, 1.2) else nil

        if v8 then
            Sound.RollOffMaxDistance = v8
        end
    end

    Sound.Parent = p9

    return Sound
end

function t1.WeightedParams(p14) -- line: 129
    if p14 == nil or p14 <= 0 then
        return 1, 1
    end

    local v9 = math.clamp(p14, 50, 480)
    local v10 = (math.log(v9) - 3.912023005428146) / 2.2617630984737906
    local v11 = v10 * 0.5 + 2.5

    if not (v9 >= 80 and v9 <= 110) then
        return v11, 2 - v10 * 1.5
    end

    return v11, 1
end

function t1.ParseMutationList(p15) -- line: 145
    -- upvalues: splitMutationList (copy)
    return (splitMutationList(p15))
end

function t1.ReadMutationState(p16, p17, p18) -- line: 147
    -- upvalues: splitMutationList (copy)
    local v12 = splitMutationList(p16:GetAttribute(p17 or "Mutations"))
    local Attribute = p16:GetAttribute(p18 or "BaseMutation")

    if typeof(Attribute) ~= "string" or Attribute == "" then
        Attribute = nil
    end

    return v12, Attribute
end

function t1.AttachEffects(p19, p20) -- line: 160
    if not p19 then
        return nil
    end

    for _, v13 in ipairs(p19) do
        v13.Parent = p20
    end

    return p19
end

function t1.StartFootsteps(p21) -- line: 172
    if not p21 or p21.IsPlaying then
        return
    end

    p21.TimePosition = 0
    p21.Looped = true
    p21:Play()
end

function t1.StopFootsteps(p22) -- line: 182
    if p22 and p22.IsPlaying then
        p22:Stop()
    end
end

function t1.PlayJump(p23) -- line: 190
    if not p23 then
        return
    end

    p23.TimePosition = 0
    p23.Looped = false
    p23:Play()
end

return t1
