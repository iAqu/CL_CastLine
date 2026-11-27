-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIKit = require(script.Parent.UIKit)
local GameConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameConfig"))
local t1 = {}

t1.__index = t1
t1.Strikes = 0

local t2 = {
    "SkyboxBk",
    "SkyboxDn",
    "SkyboxFt",
    "SkyboxLf",
    "SkyboxRt",
    "SkyboxUp",
    "SunTextureId",
    "SunAngularSize",
    "MoonTextureId",
    "MoonAngularSize",
    "StarCount",
    "CelestialBodiesShown"
}
local t3 = {
    Density = 0,
    Offset = 0,
    Glare = 0,
    Haze = 0
}

local function lerp(p1, p2, p3) -- line: 19
    return p1 + (p2 - p1) * p3
end

local function quiet(p4) -- line: 23
    p4.Anchored = true
    p4.CanCollide = false
    p4.CanQuery = false
    p4.CanTouch = false
    p4.CastShadow = false
    p4.Transparency = 1
    p4:SetAttribute("NoStuds", true)
end

function t1.new(p5) -- line: 33
    -- upvalues: Lighting (copy), ReplicatedStorage (copy), t1 (copy), t2 (copy), t3 (copy)
    local v1 = ReplicatedStorage:WaitForChild("Assets"):FindFirstChild(p5.fx.kit)
    local Model = v1 and v1:FindFirstChildWhichIsA("Model")

    if Model then
        local self = setmetatable({}, t1)

        self.def = p5
        self.weight = 0
        self.target = 1
        self.fade = 5
        self.flash = 0
        self.dead = false
        self.skySwapped = false
        self.nextStrike = os.clock() + 2.5
        self.sky = Lighting:FindFirstChildOfClass("Sky")

        local Sky = Model:FindFirstChildOfClass("Sky")

        if self.sky and Sky then
            local t5 = {}

            self.skyBase = {}
            self.skyKit = t5

            for _, v3 in t2 do
                self.skyBase[v3] = self.sky[v3]
                self.skyKit[v3] = Sky[v3]
            end
        end

        local Atmosphere = Model:FindFirstChildOfClass("Atmosphere")

        if Atmosphere then
            self.atmosGoal = {
                Density = Atmosphere.Density,
                Offset = Atmosphere.Offset,
                Glare = Atmosphere.Glare,
                Haze = Atmosphere.Haze
            }
            self.atmos = Atmosphere:Clone()
            self.atmos.Name = "AdminAbuseAtmosphere"

            for v4, v5 in t3 do
                self.atmos[v4] = v5
            end
        end

        local BloomEffect = Model:FindFirstChildOfClass("BloomEffect")

        self.bloom = Lighting:FindFirstChildOfClass("BloomEffect")

        if BloomEffect and self.bloom then
            self.bloomBase = {
                Intensity = self.bloom.Intensity,
                Size = self.bloom.Size,
                Threshold = self.bloom.Threshold
            }
            self.bloomKit = {
                Intensity = BloomEffect.Intensity,
                Size = BloomEffect.Size,
                Threshold = BloomEffect.Threshold
            }
        end

        local ColorCorrectionEffect = Model:FindFirstChildOfClass("ColorCorrectionEffect")

        self.cc = Lighting:FindFirstChild("ColorCorrection")

        if ColorCorrectionEffect and self.cc and self.cc:IsA("ColorCorrectionEffect") then
            self.ccBase = {
                Brightness = self.cc.Brightness,
                Contrast = self.cc.Contrast,
                Saturation = self.cc.Saturation,
                TintColor = self.cc.TintColor
            }
            self.ccKit = {
                Brightness = ColorCorrectionEffect.Brightness,
                Contrast = ColorCorrectionEffect.Contrast,
                Saturation = ColorCorrectionEffect.Saturation,
                TintColor = ColorCorrectionEffect.TintColor
            }
        else
            self.cc = nil
        end

        self.root = Instance.new("Folder")
        self.root.Name = "AdminAbuseFx"
        self.borders = {}
        self.bolts = {}

        local EffectBorderFolder = Model:FindFirstChild("EffectBorderFolder")
        local v6 = if EffectBorderFolder then EffectBorderFolder:GetChildren() else {}

        for _, v7 in v6 do
            if v7:IsA("BasePart") then
                local clone = v7:Clone()

                clone.Anchored = true
                clone.CanCollide = false
                clone.CanQuery = false
                clone.CanTouch = false
                clone.CastShadow = false
                clone.Transparency = 1
                clone:SetAttribute("NoStuds", true)

                local t6 = {
                    on = nil,
                    part = clone,
                    emitters = {}
                }

                for _, descendant in clone:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        if p5.fx.strikes and descendant.Name:find("Lightning") then
                            if #self.bolts < 3 then
                                table.insert(self.bolts, descendant:Clone())
                            end

                            descendant:Destroy()
                        elseif descendant.Enabled then
                            descendant.Enabled = false
                            table.insert(t6.emitters, {
                                e = descendant,
                                rate = descendant.Rate
                            })
                        end
                    end
                end

                table.insert(self.borders, t6)
                clone.Parent = self.root
            end
        end

        self.root.Parent = workspace

        return self
    end

    warn("[AdminAbuseFx] missing kit " .. tostring(p5.fx.kit))

    return nil
end

function t1.Stop(p6) -- line: 121
    p6.target = 0
    p6.fade = 6
end

function t1._setSky(p7, p8) -- line: 126
    if p7.skyBase and p7.skySwapped ~= p8 then
        p7.skySwapped = p8

        local v8 = if p8 then p7.skyKit else p7.skyBase

        for v9, v10 in v8 do
            p7.sky[v9] = v10
        end
    end
end

function t1._apply(p9, p10, p11) -- line: 137
    -- upvalues: Lighting (copy)
    local weight = p9.weight

    if p9.atmos then
        local Lighting2 = if p11 or weight <= 0.001 then nil else Lighting

        if p9.atmos.Parent ~= Lighting2 then
            p9.atmos.Parent = Lighting2
        end

        for v11, v12 in p9.atmosGoal do
            p9.atmos[v11] = v12 * weight
        end
    end

    if p9.bloomBase then
        for v13, v14 in p9.bloomKit do
            local bloom = p9.bloom
            local v15 = p9.bloomBase[v13]

            bloom[v13] = v15 + (v14 - v15) * weight
        end
    end

    if p9.cc then
        local cc = p9.cc
        local Brightness = p9.ccBase.Brightness

        cc.Brightness = Brightness + (p9.ccKit.Brightness - Brightness) * weight + p9.flash

        local cc2 = p9.cc
        local Contrast = p9.ccBase.Contrast

        cc2.Contrast = Contrast + (p9.ccKit.Contrast - Contrast) * weight

        local cc3 = p9.cc
        local Saturation = p9.ccBase.Saturation

        cc3.Saturation = Saturation + (p9.ccKit.Saturation - Saturation) * weight
        p9.cc.TintColor = p9.ccBase.TintColor:Lerp(p9.ccKit.TintColor, weight)
    end

    p9:_setSky(weight >= 0.5)

    local CFramePosition = p10.CFrame.Position

    for _, v16 in p9.borders do
        local partPosition, Size = v16.part.Position, v16.part.Size
        local v17 = not p11

        if v17 then
            v17 = false

            if weight > 0.05 and math.abs(CFramePosition.Z - partPosition.Z) < Size.Z / 2 + 700 then
                v17 = math.abs(CFramePosition.X - partPosition.X) < Size.X / 2 + 700
            end
        end

        if v16.on ~= v17 then
            v16.on = v17

            for _, v20 in v16.emitters do
                v20.e.Enabled = v17
            end
        end

        if v17 then
            for _, v21 in v16.emitters do
                local v22 = v21.rate * weight

                if math.abs(v21.e.Rate - v22) > v21.rate * 0.05 then
                    v21.e.Rate = v22
                end
            end
        end
    end
end

function t1._strike(p12, p13) -- line: 181
    -- upvalues: Debris (copy), UIKit (copy), GameConfig (copy), t1 (copy)
    local _CFrame = p13.CFrame
    local v24 = Vector3.new(_CFrame.LookVector.X, 0, _CFrame.LookVector.Z)
    local v25 = if v24.Magnitude > 0.01 then v24.Unit else Vector3.new(0, 0, -1)
    local v27 = Vector3.new(-v25.Z, 0, v25.X)
    local v28 = Random.new()
    local v29 = _CFrame.Position + v25 * v28:NextNumber(45, 120) + v27 * v28:NextNumber(-60, 60)
    local v30 = RaycastParams.new()

    v30.FilterType = Enum.RaycastFilterType.Exclude
    v30.FilterDescendantsInstances = {
        p12.root,
        workspace.CurrentCamera
    }

    local v31 = workspace:Raycast(Vector3.new(v29.X, 400, v29.Z), Vector3.new(0, -800, 0), v30)
    local v32 = if v31 then v31.Position else Vector3.new(v29.X, GameConfig.WATER_Y, v29.Z)
    local v34 = Vector3.new(v32.X, math.max(v32.Y, GameConfig.WATER_Y), v32.Z)
    local Part = Instance.new("Part")

    Part.Name = "Strike"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part:SetAttribute("NoStuds", true)
    Part.Size = Vector3.new(4, 140, 4)
    Part.CFrame = CFrame.new(v34 + Vector3.new(0, 70, 0))

    local PointLight = Instance.new("PointLight")

    PointLight.Color = p12.def.Color
    PointLight.Range = 60
    PointLight.Brightness = 10
    PointLight.Shadows = false
    PointLight.Parent = Part
    Part.Parent = p12.root

    for _, v35 in p12.bolts do
        local clone = v35:Clone()

        clone.Rate = 0
        clone.Enabled = true
        clone.Parent = Part
        clone:Emit(clone.Name == "LightningShards" and 24 or 7)
    end

    p12.flash = 0.35
    t1.Strikes += 1
    UIKit.sound("Thunder")
    Debris:AddItem(Part, 2.5)
    task.spawn(function() -- line: 217
        -- upvalues: PointLight (copy)
        for i = 1, 10 do
            task.wait(0.05)

            if PointLight.Parent then
                PointLight.Brightness = (1 - i / 10) * 10
            end
        end
    end)
end

function t1.Step(p14, p15, p16, p17) -- line: 227
    if p14.dead then
        return false
    end

    if p16 then
        p14.weight = 0
        p14.fade = 1.5
    else
        local v36 = p15 / p14.fade

        if p14.weight < p14.target then
            p14.weight = math.min(p14.target, p14.weight + v36)
        elseif p14.weight > p14.target then
            p14.weight = math.max(p14.target, p14.weight - v36)
        end

        if p14.weight >= p14.target and p14.target == 1 then
            p14.fade = 5
        end
    end

    p14.flash = math.max(0, p14.flash - p15 * 1.2)
    p14:_apply(p17, p16)

    local strikes = p14.def.fx.strikes

    if strikes and #p14.bolts > 0 and p14.target == 1 and not p16 and p14.weight > 0.9 and os.clock() >= p14.nextStrike then
        p14.nextStrike = os.clock() + Random.new():NextNumber(strikes[1], strikes[2])
        p14:_strike(p17)
    end

    if p14.target ~= 0 or not (p14.weight <= 0) and not p16 then
        return true
    end

    p14:Destroy()

    return false
end

function t1.Destroy(p18) -- line: 259
    if p18.dead then
        return
    end

    p18.dead = true
    p18.weight = 0
    p18.flash = 0

    if p18.bloomBase then
        for v40, v41 in p18.bloomBase do
            p18.bloom[v40] = v41
        end
    end

    if p18.cc then
        for v42, v43 in p18.ccBase do
            p18.cc[v42] = v43
        end
    end

    p18:_setSky(false)

    if p18.atmos then
        p18.atmos:Destroy()
    end

    p18.root:Destroy()
end

return t1
