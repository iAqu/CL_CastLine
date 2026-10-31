-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local MutationsConfig = require(ReplicatedStorage.Config.MutationsConfig)
local AnimalEconomy = require(ReplicatedStorage.Config.AnimalEconomy)
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local MutationTextures = ReplicatedStorage:WaitForChild("MutationTextures")
local t1 = {}
local t2 = {}

for _, v1 in ipairs(MutationsConfig.List) do
    table.insert(t2, v1)
end

table.sort(t2, function(p1, p2) -- line: 63
    return p1.Chance < p2.Chance
end)

local function random(p3) -- line: 65
    return p3 and p3:NextNumber() or math.random()
end

function t1.Roll(p4) -- line: 74
    -- upvalues: t2 (copy)
    local v2 = p4 and p4:NextNumber() or math.random()
    local n1 = 0

    for _, v3 in ipairs(t2) do
        n1 += v3.Chance

        if v2 < n1 then
            return v3.Name
        end
    end

    return nil
end

function t1.RollSize(p5) -- line: 85
    -- upvalues: MutationsConfig (copy)
    local Size = MutationsConfig.Size
    local v4 = 1
    local v5 = Size.Chance
    local v6 = 0

    while true do
        if v6 < Size.MaxSteps then
            local v7 = if p5 then p5:NextNumber() else nil

            if (if not p5 or not v7 then math.random() else v7) < v5 then
                v4 *= Size.Step
                v6 += 1
                v5 = math.min(v5 + Size.ChanceStep, Size.MaxChance)
                continue
            end
        end

        break
    end

    return v4
end

function t1.RollLucky(p6, p7) -- line: 99
    -- upvalues: MutationsConfig (copy), t1 (copy)
    local n2 = 0
    local v12

    for _ = 1, math.max(1, (math.floor(p6 or 1))) do
        local v13 = t1.Roll(p7)
        local v14 = MutationsConfig.Get(v13)

        if v14 and n2 < v14.Multiplier then
            v12 = v13
            n2 = v14.Multiplier
        end
    end

    return v12
end

function t1.RollSizeLucky(p8, p9) -- line: 113
    -- upvalues: t1 (copy)
    local n3 = 1

    for _ = 1, math.max(1, (math.floor(p8 or 1))) do
        n3 = math.max(n3, t1.RollSize(p9))
    end

    return n3
end

function t1.IncomeMultiplier(p10, p11) -- line: 122
    -- upvalues: MutationsConfig (copy)
    local v18 = MutationsConfig.Get(p10)

    return (v18 and v18.Multiplier or 1) * (p11 or 1) ^ MutationsConfig.Size.IncomeExponent
end

function t1.Income(p12, p13, p14) -- line: 130
    -- upvalues: AnimalEconomy (copy), t1 (copy)
    local v19 = AnimalEconomy.Get(p12)
    local Income = v19 and v19.Income or 0

    if Income <= 0 then
        return 0
    end

    return (math.max(1, (math.floor(Income * t1.IncomeMultiplier(p13, p14) + 0.5))))
end

function t1.IncomeOf(p15, p16) -- line: 139
    -- upvalues: t1 (copy)
    if p15.OfBest then
        return (math.floor(p15.OfBest * (p16 or 0) + 0.5))
    end

    return t1.Income(p15.ModelName, p15.Mutation, p15.Size)
end

function t1.SellPrice(p17, p18) -- line: 147
    -- upvalues: GameConfig (copy), t1 (copy)
    return t1.IncomeOf(p17, p18) * GameConfig.Economy.SellMultiplier
end

function t1.BestIncome(p19) -- line: 154
    -- upvalues: t1 (copy)
    local n4 = 1

    for _, v23 in pairs(p19 or {}) do
        if type(v23) == "table" and not v23.OfBest and v23.ModelName then
            n4 = math.max(n4, t1.Income(v23.ModelName, v23.Mutation, v23.Size))
        end
    end

    return n4
end

function t1.Weight(p20, p21) -- line: 170
    -- upvalues: AnimalEconomy (copy)
    local v24 = AnimalEconomy.Get(p20)

    return (v24 and v24.Weight or 1) * (p21 or 1) ^ 3
end

local function sig3(p22) -- line: 177
    if p22 >= 100 then
        return string.format("%d", (math.floor(p22 + 0.5)))
    end

    return ((p22 >= 10 and string.format("%.1f", p22) or string.format("%.2f", p22)):gsub("0+$", ""):gsub("%.$", ""))
end

function t1.FormatWeight(p23) -- line: 184
    -- upvalues: sig3 (copy)
    if p23 < 1 then
        return sig3(p23 * 1000) .. " g"
    end

    if p23 < 1000 then
        return sig3(p23) .. " kg"
    end

    local t3 = {
        "",
        "k",
        "M",
        "G",
        "T",
        "P",
        "E"
    }
    local v26 = p23 / 1000
    local n5 = 1

    while v26 >= 1000 and n5 < #t3 do
        v26 /= 1000
        n5 += 1
    end

    return sig3(v26) .. " " .. t3[n5] .. "t"
end

function t1.SizeSuffix(p24) -- line: 201
    if p24 and not (p24 <= 1.0001) then
        local v27 = if p24 >= 100 then string.format("%d", (math.floor(p24 + 0.5))) else string.format("%.2f", p24):gsub("0+$", ""):gsub("%.$", "")

        return "(x" .. v27 .. ")"
    end

    return nil
end

function t1.SizeTitle(p25) -- line: 214
    -- upvalues: MutationsConfig (copy)
    if not p25 or p25 <= 1.0001 then
        return nil
    end

    local Size = MutationsConfig.Size
    local v32 = math.max(1, (math.floor(math.log(p25) / math.log(Size.Step) + 0.5)))
    local Titles = Size.Titles
    local v34 = Titles[math.min(v32, #Titles)]

    return v34.Name, v34.Color
end

function t1.WeightText(p26, p27) -- line: 224
    -- upvalues: t1 (copy)
    local v35 = t1.FormatWeight(t1.Weight(p26, p27))
    local v36 = t1.SizeTitle(p27)

    if v36 then
        v35 ..= " (" .. v36 .. ")"
    end

    return v35
end

function t1.NameGradient(p28) -- line: 232
    -- upvalues: MutationsConfig (copy)
    local v37 = MutationsConfig.Get(p28)

    return v37 and v37.Gradient or nil
end

function t1.Color(p29) -- line: 237
    -- upvalues: MutationsConfig (copy)
    local v38 = MutationsConfig.Get(p29)

    return v38 and v38.Color or nil
end

local function longestSide(p30) -- line: 246
    return (math.max(p30.Size.X, p30.Size.Y, p30.Size.Z))
end

local function clearVisuals(p31) -- line: 250
    -- upvalues: CollectionService (copy)
    for _, descendant in ipairs(p31:GetDescendants()) do
        if descendant:IsA("Texture") and CollectionService:HasTag(descendant, "MutationTexture") or descendant:IsA("ParticleEmitter") and descendant.Name == "MutationSparkles" then
            descendant:Destroy()
        end
    end
end

local function addSparkles(p32, p33, _) -- line: 258
    local v39 = math.max(p32.Size.X, p32.Size.Y, p32.Size.Z)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "MutationSparkles"
    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"

    local Color = p33.Color

    ParticleEmitter.Color = if typeof(Color) == "Color3" then ColorSequence.new(Color) else Color

    local v42 = (p33.Size or 0.35) * math.clamp(v39 / 4, 0.7, 3)

    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.3, v42),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.9, 1.6)
    ParticleEmitter.Speed = NumberRange.new(0.6, 1.8)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-60, 60)
    ParticleEmitter.LightEmission = p33.LightEmission or 1
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Rate = math.clamp((p33.Rate or 3) * v39, 3, 80)
    ParticleEmitter.Parent = p32

    return ParticleEmitter
end

function t1.GetTexture(p35) -- line: 282
    -- upvalues: MutationsConfig (copy), MutationTextures (copy)
    local v44 = MutationsConfig.Get(p35)

    return v44 and MutationTextures:FindFirstChild(v44.Texture) or nil
end

local v45

function t1.Apply(p36, p37, p38) -- line: 294
    -- upvalues: CollectionService (copy), MutationsConfig (copy), MutationTextures (copy), clearVisuals (copy), addSparkles (copy), v45 (ref)
    clearVisuals(p36)

    if p36:GetAttribute("PartMade") then
        return v45(p36, p37, p38)
    end

    local v46 = MutationsConfig.Get(p37)

    if not v46 then
        p36:SetAttribute("Mutation", nil)

        return
    end

    p36:SetAttribute("Mutation", p37)

    local v47 = MutationTextures:FindFirstChild(v46.Texture)

    if not v47 then
        warn("[Mutations] Missing texture " .. tostring(v46.Texture) .. " in MutationTextures")
    end

    local v48 = not (p38 and p38.Particles == false)

    for _, descendant in ipairs(p36:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            if v47 then
                for _, v49 in ipairs(Enum.NormalId:GetEnumItems()) do
                    local clone = v47:Clone()

                    clone.Name = "Mutation" .. v49.Name
                    clone.Face = v49
                    clone:SetAttribute("RestTransparency", v47.Transparency)

                    if p38 and p38.Hidden then
                        clone.Transparency = 1
                    end

                    if v46.Scroll then
                        clone:SetAttribute("ScrollU", v46.Scroll.X)
                        clone:SetAttribute("ScrollV", v46.Scroll.Y)
                    end

                    CollectionService:AddTag(clone, "MutationTexture")
                    clone.Parent = descendant
                end
            end

            if v48 and v46.Particles then
                local v50 = addSparkles(descendant, v46.Particles)

                if p38 and p38.Hidden then
                    v50.Enabled = false
                end
            end
        end
    end
end

function t1.SetHidden(p39, p40) -- line: 337
    -- upvalues: CollectionService (copy)
    if p39:GetAttribute("PartMade") then
        p39:SetAttribute("MutationHidden", p40 or nil)

        for _, descendant in ipairs(p39:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") and descendant:GetAttribute("MutationFX") then
                descendant.Enabled = not p40 and descendant:GetAttribute("RestEnabled") ~= false
            elseif descendant:IsA("BasePart") and not p40 then
                descendant.LocalTransparencyModifier = 0
            end
        end
    else
        for _, descendant in ipairs(p39:GetDescendants()) do
            if descendant:IsA("Texture") and CollectionService:HasTag(descendant, "MutationTexture") then
                if p40 then
                    descendant.Transparency = 1
                else
                    descendant.Transparency = descendant:GetAttribute("RestTransparency") or 0
                end
            elseif descendant:IsA("ParticleEmitter") and descendant.Name == "MutationSparkles" then
                descendant.Enabled = not p40
            end
        end
    end
end

v45 = function(p41, p42, p43) -- line: 367
    -- upvalues: ReplicatedStorage (copy), MutationsConfig (copy)
    p41:SetAttribute("Mutation", if not MutationsConfig.Get(p42) or not p42 then nil else p42)

    if p43 and p43.Hidden then
        p41:SetAttribute("MutationHidden", true)
    end

    require(ReplicatedStorage.Shared.StudioPieces).Sync(p41, p43)
end

function t1.ApplySize(p44, p45) -- line: 377
    -- upvalues: ReplicatedStorage (copy)
    p45 = p45 or 1
    p44:SetAttribute("SizeMult", p45)

    if p45 > 1.0001 then
        p44:ScaleTo(p44:GetScale() * p45)
        require(ReplicatedStorage.Shared.AnimalUtil).ApplyIdlePose(p44)
        p44:SetAttribute("VisualScale", (p44:GetAttribute("VisualScale") or 1) * p45)
    end

    return p45
end

function t1.ScalePOV(p46, p47) -- line: 393
    p47 = p47 or 1

    if not (p47 <= 1.0001) then
        for _, v53 in ipairs({ "HeadHeight", "Altitude", "StepLength", "HopLength", "HopHeight", "Bob", "Sway" }) do
            if p46[v53] then
                p46[v53] *= p47
            end
        end

        local v54 = math.min(p47, 2.5)

        p46.Weight = math.min((p46.Weight or 0.3) * v54, 1.5)
        p46.Shake = math.min((p46.Shake or 0.3) * v54, 1.5)
        p46.StepVolume = math.min((p46.StepVolume or 0.5) * (v54 * 0.2 + 0.8), 1)
        p46.StepPitch = (p46.StepPitch or 1) / ((v54 - 1) * 0.35 + 1)
    end

    return p46
end

local t4 = {}
local connection

local function track(p48) -- line: 414
    -- upvalues: t4 (copy)
    if p48:GetAttribute("ScrollU") or p48:GetAttribute("ScrollV") then
        t4[p48] = true
    end
end

function t1.TrackScrolling(p49) -- line: 423
    -- upvalues: t4 (copy)
    if p49:GetAttribute("ScrollU") or p49:GetAttribute("ScrollV") then
        t4[p49] = true
    end
end

function t1.StartScrolling() -- line: 428
    -- upvalues: ReplicatedStorage (copy), CollectionService (copy), RunService (copy), t1 (copy), t4 (copy), connection (ref), track (copy)
    if connection then
        return
    end

    for _, v58 in ipairs(CollectionService:GetTagged("MutationTexture")) do
        if v58:GetAttribute("ScrollU") or v58:GetAttribute("ScrollV") then
            t4[v58] = true
        end
    end

    CollectionService:GetInstanceAddedSignal("MutationTexture"):Connect(track)
    CollectionService:GetInstanceRemovedSignal("MutationTexture"):Connect(function(p50) -- line: 432
        -- upvalues: t4 (copy)
        t4[p50] = nil
    end)

    for _, v59 in ipairs(CollectionService:GetTagged("ScrollingTexture")) do
        if v59:GetAttribute("ScrollU") or v59:GetAttribute("ScrollV") then
            t4[v59] = true
        end
    end

    CollectionService:GetInstanceAddedSignal("ScrollingTexture"):Connect(track)
    CollectionService:GetInstanceRemovedSignal("ScrollingTexture"):Connect(function(p51) -- line: 435
        -- upvalues: t4 (copy)
        t4[p51] = nil
    end)

    local function watchFX(p52) -- line: 438
        -- upvalues: t1 (copy)
        if p52.Name == "StudioMutations" then
            local v60 = p52:WaitForChild("MutationFX", 30)

            if v60 then
                t1.UseRainbowFX(v60)
            end
        end
    end

    local StudioMutations = ReplicatedStorage:FindFirstChild("StudioMutations")

    if StudioMutations then
        task.spawn(watchFX, StudioMutations)
    end

    ReplicatedStorage.ChildAdded:Connect(function(p53) -- line: 445
        -- upvalues: watchFX (copy)
        if p53.Name == "StudioMutations" then
            task.spawn(watchFX, p53)
        end
    end)
    connection = RunService.Heartbeat:Connect(function(p54) -- line: 448
        -- upvalues: t4 (copy)
        for v61 in pairs(t4) do
            if v61.Parent then
                local v62 = v61:GetAttribute("ScrollU") or 0
                local v63 = v61:GetAttribute("ScrollV") or 0
                local v64 = math.max(v61.StudsPerTileU, 0.01)
                local v65 = math.max(v61.StudsPerTileV, 0.01)

                v61.OffsetStudsU = (v61.OffsetStudsU + v62 * p54) % v64
                v61.OffsetStudsV = (v61.OffsetStudsV + v63 * p54) % v65
                continue
            end

            t4[v61] = nil
        end
    end)
end

local v66 = false

function t1.UseRainbowFX(p55) -- line: 467
    -- upvalues: CollectionService (copy), RunService (copy), v66 (ref)
    if v66 or not RunService:IsClient() then
        return
    end

    local _require = require
    local ok, result = pcall(_require, p55)

    if not ok or type(result) ~= "table" then
        warn("[Mutations] MutationFX could not start: " .. tostring(result))
    else
        v66 = true

        local t5 = {}

        local function pieceCount(p56) -- line: 476
            local n6 = 0

            for _, descendant in ipairs(p56:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    n6 += 1
                end
            end

            return n6
        end

        local elapsed = os.clock()
        local n7 = 0
        local n8 = 0

        RunService.Heartbeat:Connect(function(p57) -- line: 482
            -- upvalues: result (copy), t5 (copy), pieceCount (copy), elapsed (copy), n7 (ref), n8 (ref), CollectionService (copy)
            n7 += p57
            n8 += p57

            if n8 >= 1 then
                n8 = 0

                for _, v67 in ipairs(CollectionService:GetTagged("RainbowAnimal")) do
                    local v68 = pieceCount(v67)
                    local v69 = t5[v67]

                    if not v69 or v69.count ~= v68 then
                        local v71 = result.attach(v67)

                        v71.count = v68
                        t5[v67] = v71
                    end
                end
            end

            if n7 < 0.03333333333333333 then
                return
            end

            n7 = 0

            local v72 = os.clock() - elapsed

            for v73, v74 in pairs(t5) do
                if v73.Parent and CollectionService:HasTag(v73, "RainbowAnimal") then
                    result.step(v74, v72)
                else
                    t5[v73] = nil
                end
            end
        end)
    end
end

return t1
