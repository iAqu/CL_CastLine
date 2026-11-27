-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local t1 = {}

t1.__index = t1
t1.COMMON = 0
t1.STANDARD = 1
t1.LEGENDARY = 2
t1.MYTHIC = 3
t1.LEGENDARY_ORDER = 5
t1.MYTHIC_ORDER = 6
t1.BLOOM_INTENSITY = 0.12
t1.BLOOM_THRESHOLD = 2.4

local v1

function t1:TierOf() -- line: 18
    -- upvalues: t1 (copy)
    local order = self and self.order or 1

    if t1.MYTHIC_ORDER <= order then
        return t1.MYTHIC
    end

    if t1.LEGENDARY_ORDER <= order then
        return t1.LEGENDARY
    end

    if order <= 1 then
        return t1.COMMON
    end

    return t1.STANDARD
end

function t1.new(p2, p3) -- line: 30
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.Rarity = p2
    self.Variant = p3
    self.Tier = t1.TierOf(p2)
    self.Color = p2.Color
    self.Folder = Instance.new("Folder")
    self.Folder.Name = "RevealStage"
    self.Folder.Parent = workspace
    self.Key = nil
    self.Highlight = nil
    self.Column = nil
    self.Fish = nil
    self.Radius = 1
    self.Offset = Vector3.new(0, 0, 0)
    t1.SoftenBloom()

    return self
end

function t1.SoftenBloom() -- line: 49
    -- upvalues: Lighting (copy), t1 (copy), v1 (ref)
    local BloomEffect = Lighting:FindFirstChildOfClass("BloomEffect")

    if not BloomEffect then
        return
    end

    v1 = v1 or {
        BloomEffect,
        BloomEffect.Intensity,
        BloomEffect.Threshold
    }
    BloomEffect.Intensity = t1.BLOOM_INTENSITY
    BloomEffect.Threshold = t1.BLOOM_THRESHOLD
end

function t1.Restore() -- line: 61
    -- upvalues: v1 (ref)
    if not v1 then
        return
    end

    local v3 = v1[1]

    if v3.Parent then
        v3.Intensity = v1[2]
        v3.Threshold = v1[3]
    end

    v1 = nil
end

function t1:Vivid() -- line: 72
    local v4, v5, v6 = self:ToHSV()

    return Color3.fromHSV(v4, math.max(v5, 0.65), (math.max(v6, 0.9)))
end

function t1:IsCommon() -- line: 77
    -- upvalues: t1 (copy)
    return self.Tier == t1.COMMON
end

function t1:Pace(p7, p8) -- line: 81
    if self:IsCommon() then
        return p7 * 0.6, p8 * 0.55
    end

    return p7, p8
end

function t1:MinHold(p10) -- line: 88
    if self:IsCommon() then
        return (math.min(p10, 0.35))
    end

    return p10
end

function t1:Shake(p12, p13) -- line: 95
    -- upvalues: t1 (copy)
    if self.Tier >= t1.MYTHIC then
        return math.max(p12, 1.4), 1.6
    end

    if self.Tier >= t1.LEGENDARY then
        return math.max(p12, 1), 1.1
    end

    return p12, p13
end

function t1:Light(p15, p16, p17, p18) -- line: 104
    -- upvalues: t1 (copy)
    self.Fish = p15
    self.Offset = p16
    self.Radius = math.max(p17, 1)

    if p18 then
        p18.Brightness = math.min(p18.Brightness, 0.6)
    end

    local Part = Instance.new("Part")

    Part.Name = "KeyLight"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.Parent = self.Folder

    local PointLight = Instance.new("PointLight")

    PointLight.Color = t1.Vivid(self.Color)
    PointLight.Brightness = 6
    PointLight.Range = math.clamp(self.Radius * 3 + 20, 20, 60)
    PointLight.Shadows = false
    PointLight.Parent = Part
    self.Key = Part

    if self.Variant and (self.Variant.index or 1) >= 2 then
        local Highlight = Instance.new("Highlight")

        Highlight.Name = "MutationGlow"
        Highlight.Adornee = p15
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded

        local v8 = t1.Vivid(self.Variant.Color)

        Highlight.FillColor = v8
        Highlight.FillTransparency = 0.55
        Highlight.OutlineColor = v8
        Highlight.OutlineTransparency = 0
        Highlight.Parent = self.Folder
        self.Highlight = Highlight
    end

    self:Step(0)
end

function t1:Center() -- line: 144
    return if self.Fish and self.Fish.Parent then (self.Fish:GetPivot() * CFrame.new(self.Offset)).Position else nil
end

function t1:DarkenSea(p21) -- line: 151
    -- upvalues: t1 (copy)
    if self.Tier >= t1.MYTHIC then
        p21.Darken(0.75, 1.2)
    end
end

function t1:Reveal(p23, p24) -- line: 157
    -- upvalues: TweenService (copy), t1 (copy)
    if self.Tier < t1.LEGENDARY then
        return
    end

    local v9 = self:Center()

    if v9 then
        local v10 = math.max(p23, p24) * 0.45 + 4
        local Part = Instance.new("Part")

        Part.Name = "LightColumn"
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Material = Enum.Material.Neon
        Part.Shape = Enum.PartType.Cylinder
        Part.Color = self.Color
        Part.Transparency = 1
        Part.Size = Vector3.new(600, 1, 1)
        self.ColumnLift = p24 * 0.5 + 1.5
        Part.CFrame = CFrame.new(v9 + Vector3.new(0, self.ColumnLift + 300, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
        Part:SetAttribute("NoStuds", true)
        Part.Parent = self.Folder
        TweenService:Create(Part, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0.68,
            Size = Vector3.new(600, v10, v10)
        }):Play()
        self.Column = Part
        self.ColumnWide = v10
    end
end

function t1:Step(p26) -- line: 187
    local v12 = self:Center()

    if not v12 then
        return
    end

    local CFramePosition = workspace.CurrentCamera.CFrame.Position

    if self.Key then
        local v13 = CFramePosition - v12
        local v14 = if v13.Magnitude > 0.01 then v13.Unit else Vector3.new(0, 0, 1)

        self.Key.CFrame = CFrame.new(v12 + v14 * (self.Radius * 0.8 + 3) + Vector3.new(0, self.Radius * 0.5 + 2, 0))
    end

    if self.Highlight and self.Variant.id == "Rainbow" then
        local v17 = Color3.fromHSV(p26 * 0.35 % 1, 0.75, 1)

        self.Highlight.FillColor = v17
        self.Highlight.OutlineColor = v17
    end

    if not (self.Column and self.Column.Parent) then
        return
    end

    local v19 = math.sin(p26 * 4) * 0.06 + 0.68

    if p26 > 0.35 then
        self.Column.Transparency = v19
    end

    self.Column.CFrame = CFrame.new(v12 + Vector3.new(0, (self.ColumnLift or 0) + 300, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
end

function t1:Destroy() -- line: 212
    -- upvalues: t1 (copy)
    if self.Folder then
        self.Folder:Destroy()
        self.Folder = nil
    end

    t1.Restore()
end

return t1
