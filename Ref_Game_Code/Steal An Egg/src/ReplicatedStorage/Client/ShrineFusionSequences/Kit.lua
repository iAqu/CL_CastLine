-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Assets = require(ReplicatedStorage.Data.Assets)
local Audio = require(ReplicatedStorage.Shared.Audio)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}
local self = setmetatable({}, {
    __mode = "k"
})
local self2 = setmetatable({}, {
    __mode = "k"
})
local self3 = setmetatable({}, {
    __mode = "k"
})

function t1.Lerp(p1, p2, p3) -- line: 18
    return p1 + (p2 - p1) * p3
end

function t1.Clamp01(p4) -- line: 22
    return (math.clamp(p4, 0, 1))
end

function t1.Smooth(p5) -- line: 26
    local v4 = math.clamp(p5, 0, 1)

    return v4 * v4 * (3 - v4 * 2)
end

function t1.Window(p6, p7, p8) -- line: 31
    return (math.clamp((p6 - p7) / math.max(p8 - p7, 0.001), 0, 1))
end

function t1.BackOut(p9) -- line: 35
    local v8 = math.clamp(p9, 0, 1) - 1

    return v8 * 2.70158 * v8 * v8 + 1 + v8 * 1.70158 * v8
end

function t1.Ease(p10, p11, p12) -- line: 42
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(math.clamp(p10, 0, 1), p11, p12)
end

function t1.Bezier(p13, p14, p15, p16) -- line: 46
    local v9 = 1 - p16

    return p13 * (v9 * v9) + p14 * (v9 * 2 * p16) + p15 * (p16 * p16)
end

function t1.Flat(p17) -- line: 51
    local v10 = p17 * Vector3.new(1, 0, 1)

    if v10.Magnitude > 0.001 then
        return v10.Unit
    end

    return (Vector3.new(0, 0, 1))
end

function t1.ReducedMotion() -- line: 56
    -- upvalues: GuiService (copy)
    local function v11() -- line: 57
        -- upvalues: GuiService (copy)
        return GuiService.ReducedMotionEnabled
    end

    local ok, result = pcall(v11)

    return ok and result == true
end

function t1.Part(p18) -- line: 63
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Locked = true
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth

    for v12, v13 in p18 or {} do
        Part[v12] = v13
    end

    return Part
end

function t1.Emitter(p19, p20) -- line: 79
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.LightEmission = 1
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Rate = 0
    ParticleEmitter.Enabled = false

    for v14, v15 in p20 do
        ParticleEmitter[v14] = v15
    end

    ParticleEmitter.Parent = p19

    return ParticleEmitter
end

function t1.Freeze(p21) -- line: 92
    for _, descendant in p21:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.Massless = true
        elseif descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") or descendant:IsA("ProximityPrompt") then
            descendant.Enabled = false
        elseif descendant:IsA("Script") then
            descendant:Destroy()
        end
    end
end

function t1.Normalize(p22, p23) -- line: 112
    local _, BoundingBox = p22:GetBoundingBox()
    local v16 = math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z)

    if v16 > 0.01 then
        p22:ScaleTo((math.clamp(p22:GetScale() * (p23 / v16), 0.01, 50)))
    end
end

function t1.PetModel(p24, p25, p26) -- line: 120
    -- upvalues: ReplicatedStorage (copy), t1 (copy)
    local v18 = p26 or (if p24 then ReplicatedStorage.AssetModels:FindFirstChild(p24) else nil)

    if not (v18 and v18:IsA("Model")) then
        return nil
    end

    local clone = v18:Clone()

    t1.Freeze(clone)

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("Beam") then
            descendant.Enabled = false
        end
    end

    local HumanoidRootPart = clone:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        clone.PrimaryPart = HumanoidRootPart
        HumanoidRootPart.Transparency = 1
    end

    t1.Normalize(clone, p25)

    return clone
end

local function eggTemplate(p27) -- line: 142
    -- upvalues: ReplicatedStorage (copy), Assets (copy), EggRecords (copy)
    local v19 = if p27 then Assets.Directory[p27] else nil
    local v20 = if not (v19 and v19.Egg) then p27 else v19.Egg.ModelName
    local v21 = if v20 then ReplicatedStorage.Assets.Models.Eggs:FindFirstChild(v20) else nil

    if v21 then
        return v21
    end

    local EggModelTemplate = EggRecords.EggModelTemplate
    local ok, result = pcall(EggModelTemplate, p27)

    return if ok and typeof(result) == "Instance" then result else nil
end

function t1.EggModel(p28, p29, p30) -- line: 153
    -- upvalues: t1 (copy), eggTemplate (copy)
    local v22 = eggTemplate(p28)
    local Model

    if not (v22 and v22:IsA("Model")) then
        Model = Instance.new("Model")
        t1.Part({
            Size = Vector3.new(2.6, 3.2, 2.6),
            Shape = Enum.PartType.Ball,
            Material = Enum.Material.Neon,
            Color = p30
        }).Parent = Model
    else
        Model = v22:Clone()
    end

    t1.Freeze(Model)
    Model.PrimaryPart = nil
    Model.WorldPivot = Model:GetBoundingBox()
    t1.Normalize(Model, p29)

    return Model
end

function t1.PlayAnimation(p31, p32, p33) -- line: 176
    if typeof(p32) ~= "Instance" or not p32:IsA("Animation") then
        return nil
    end

    local v23 = p31:FindFirstChildWhichIsA("AnimationController", true)
    local Animator = if v23 then v23:FindFirstChildOfClass("Animator") else nil

    if not Animator then
        return nil
    end

    local function v24() -- line: 185
        -- upvalues: p32 (copy), Animator (copy)
        return Animator:LoadAnimation(p32)
    end

    local ok, result = pcall(v24)

    if not ok or not result then
        return nil
    end

    result.Looped = true
    result:Play(0.2, 1, p33 or 1)

    return result
end

function t1.Sound(p34, p35, p36, p37) -- line: 196
    -- upvalues: Audio (copy)
    if not p34 then
        return nil
    end

    local Play = Audio.Play
    local t8 = {
        MaxDistance = 260,
        Volume = p36 or 1,
        PlaybackSpeed = p37 or 1
    }
    local ok, result = pcall(Play, p34, p35, t8)

    return if ok and typeof(result) == "Instance" then result else nil
end

local function switchable(p38) -- line: 208
    return p38:IsA("ParticleEmitter")
        or p38:IsA("Beam")
        or p38:IsA("Trail")
        or p38:IsA("Light")
        or p38:IsA("Highlight")
        or p38:IsA("Fire")
        or p38:IsA("Smoke")
        or p38:IsA("Sparkles")
end

local function hideItem(p39) -- line: 219
    -- upvalues: self (copy), self2 (copy), self3 (copy), switchable (copy)
    if p39:IsA("BasePart") then
        self[p39] = true
        p39.LocalTransparencyModifier = 1
    elseif p39:IsA("Decal") then
        if self3[p39] == nil then
            self3[p39] = p39.Transparency
        end

        p39.Transparency = 1
    elseif switchable(p39) then
        if self2[p39] == nil then
            self2[p39] = p39.Enabled
        end

        p39.Enabled = false
    end
end

local function showItem(p40) -- line: 236
    -- upvalues: self (copy), self2 (copy), self3 (copy), switchable (copy)
    if p40:IsA("BasePart") then
        if self[p40] then
            self[p40] = nil
            p40.LocalTransparencyModifier = 0
        end
    elseif p40:IsA("Decal") then
        local v25 = self3[p40]

        if v25 ~= nil then
            p40.Transparency = v25
            self3[p40] = nil
        end
    elseif switchable(p40) then
        local v26 = self2[p40]

        if v26 ~= nil then
            p40.Enabled = v26
            self2[p40] = nil
        end
    end
end

function t1.Hide(p41) -- line: 257
    -- upvalues: hideItem (copy)
    hideItem(p41)

    for _, descendant in p41:GetDescendants() do
        hideItem(descendant)
    end
end

function t1.Show(p42) -- line: 264
    -- upvalues: showItem (copy)
    showItem(p42)

    for _, descendant in p42:GetDescendants() do
        showItem(descendant)
    end
end

local t9 = {}

t9.__index = t9

function t1.ToolGuard(p43) -- line: 274
    -- upvalues: Trove (copy), t1 (copy), hideItem (copy), t9 (copy)
    local v27 = setmetatable({
        Revealed = false,
        Trove = Trove.new(),
        Tools = {}
    }, t9)

    if p43 then
        local function cover(p44) -- line: 279
            -- upvalues: v27 (copy), t1 (copy), hideItem (copy)
            if not p44:IsA("Tool") or v27.Tools[p44] then
                return
            end

            v27.Tools[p44] = true
            t1.Hide(p44)
            v27.Trove:Connect(p44.DescendantAdded, function(p45) -- line: 285
                -- upvalues: v27 (copy), hideItem (copy)
                if not v27.Revealed then
                    hideItem(p45)
                end
            end)
        end

        v27.Held = p43:FindFirstChildOfClass("Tool")

        for _, child in p43:GetChildren() do
            cover(child)
        end

        v27.Trove:Connect(p43.ChildAdded, function(p46) -- line: 296
            -- upvalues: v27 (copy), cover (copy)
            if not v27.Revealed then
                cover(p46)
            end
        end)
    end

    return v27
end

function t9.Reveal(p47) -- line: 304
    -- upvalues: t1 (copy)
    if p47.Revealed then
        return
    end

    p47.Revealed = true
    p47.Trove:Clean()

    for v28 in p47.Tools do
        if v28.Parent then
            t1.Show(v28)
        end
    end

    table.clear(p47.Tools)
end

function t9.Destroy(p48) -- line: 318
    p48:Reveal()
end

local t11 = {}

t11.__index = t11

function t1.Ring(p49, p50, p51, p52) -- line: 325
    -- upvalues: t1 (copy), t11 (copy)
    local v29 = t1.Part({
        Name = "FusionRing",
        Transparency = 1,
        Size = Vector3.new(0.2, 0.2, 0.2)
    })
    local t12 = {}

    for i = 1, 4 do
        local Attachment = Instance.new("Attachment")

        Attachment.Parent = v29
        t12[i] = Attachment
    end

    local t13 = {}

    for i = 1, 4 do
        local Beam = Instance.new("Beam")

        Beam.Attachment0 = t12[i]
        Beam.Attachment1 = t12[i % 4 + 1]
        Beam.Color = ColorSequence.new(p50)
        Beam.LightEmission = 1
        Beam.LightInfluence = 0
        Beam.FaceCamera = false
        Beam.Segments = p52 or 12
        Beam.Width0 = p51
        Beam.Width1 = p51
        Beam.Parent = v29
        t13[i] = Beam
    end

    v29.Parent = p49

    local v30 = setmetatable({
        Host = v29,
        Points = t12,
        Beams = t13
    }, t11)

    v30:Set(CFrame.identity, 1, 1)

    return v30
end

function t11.Set(p53, p54, p55, p56, p57) -- line: 354
    p53.Host.CFrame = p54

    local v31 = p55 * 0.5523

    for v32, v33 in p53.Points do
        local v34 = (v32 - 1) * 3.141592653589793 / 2
        local v37 = Vector3.new(math.cos(v34), 0, (math.sin(v34)))
        local v40 = Vector3.new(-math.sin(v34), 0, (math.cos(v34)))

        v33.CFrame = CFrame.fromMatrix(v37 * p55, v40, v37)
    end

    for _, v41 in p53.Beams do
        v41.CurveSize0 = v31
        v41.CurveSize1 = v31
        v41.Transparency = NumberSequence.new((math.clamp(p56, 0, 1)))

        if p57 then
            v41.Width0 = p57
            v41.Width1 = p57
        end
    end
end

function t11.Style(p58, p59) -- line: 374
    for _, v42 in p58.Beams do
        for v43, v44 in p59 do
            v42[v43] = v44
        end
    end
end

function t11.SetColor(p60, p61) -- line: 382
    for _, v45 in p60.Beams do
        v45.Color = ColorSequence.new(p61)
    end
end

function t11.Destroy(p62) -- line: 388
    p62.Host:Destroy()
end

function t1.LocalPlayerCharacter() -- line: 392
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer

    return if LocalPlayer then LocalPlayer.Character else nil
end

function t1.RootOf(p63) -- line: 397
    local HumanoidRootPart = if p63 then p63:FindFirstChild("HumanoidRootPart") else nil

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end

return table.freeze(t1)
