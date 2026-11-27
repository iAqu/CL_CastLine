-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local CosmicEvent = require(Shared.Data.CosmicEvent)
local Fish = require(Shared.Data.Fish)
local Variants = require(Shared.Data.Variants)
local Sizes = require(Shared.Data.Sizes)

require(script.Parent.UIKit)

local Toasts = require(script.Parent.Toasts)
local t1 = {
    Beams = 0,
    Mutations = 0,
    Swept = 0
}
local LocalPlayer = Players.LocalPlayer
local fromRGB, new = Color3.fromRGB, Vector3.new
local Neon = Enum.Material.Neon
local v1 = fromRGB(245, 225, 255)
local v2 = fromRGB(170, 90, 255)
local v3

local function part(p1) -- line: 32
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part:SetAttribute("NoStuds", true)

    for v4, v5 in pairs(p1) do
        Part[v4] = v5
    end

    return Part
end

local function clamp01(p2) -- line: 48
    return (math.clamp(p2, 0, 1))
end

local function stretch(p3, p4, p5, p6) -- line: 53
    -- upvalues: new (copy)
    p3.Size = new(math.max((p5 - p4).Magnitude, 0.1), p6, p6)
    p3.CFrame = CFrame.lookAt((p4 + p5) / 2, p5) * CFrame.Angles(0, 1.5707963267948966, 0)
end

local function wrapAngle(p7) -- line: 59
    return (p7 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

local function penOf(p8) -- line: 64
    local World = workspace:FindFirstChild("World")
    local Plots = World and World:FindFirstChild("Plots")

    for _, v7 in ipairs(Plots and Plots:GetChildren() or {}) do
        if v7:GetAttribute("OwnerUserId") == p8 then
            local Pond = v7:FindFirstChild("Pond")
            local Water = Pond and Pond:FindFirstChild("Water")

            return if Water and Water:IsA("BasePart") then Water else nil
        end
    end

    return nil
end

function t1.Begin(p9, p10) -- line: 77
    -- upvalues: v3 (ref)
    v3 = p10
    p9.storm = {
        yaw = 0,
        pitch = -0.08,
        folder = nil,
        beams = {}
    }

    local Folder = Instance.new("Folder")

    Folder.Name = "CosmicBeams"
    Folder.Parent = p9.folder
    p9.storm.folder = Folder
end

function t1.Finish(p11) -- line: 86
    if p11.storm then
        for _, v8 in ipairs(p11.storm.beams) do
            if v8.parts then
                for _, v9 in pairs(v8.parts) do
                    v9:Destroy()
                end
            end
        end

        table.clear(p11.storm.beams)
    end
end

function t1.Pose(p12, p13) -- line: 101
    -- upvalues: CosmicEvent (copy), new (copy)
    local v10 = p12.storm or {
        yaw = 0,
        pitch = -0.08
    }
    local v12 = math.clamp((p13 - (p12.battleAt - p12.start + CosmicEvent.BATTLE.LEN)) / 6, 0, 1)
    local v13 = v12 * v12 * (3 - v12 * 2)
    local v20 = CosmicEvent.GIANT_POS + new(math.sin(p13 * 0.19) * 16, math.sin(p13 * 0.33) * 7, math.cos(p13 * 0.15) * 12) * v13

    return CFrame.new(v20) * CFrame.Angles(0, v10.yaw, 0) * CFrame.Angles(v10.pitch, 0, math.sin(p13 * 0.27) * 0.05 * v13), CosmicEvent.GIANT_SCALE
end

function t1.OnBeam(p14, p15) -- line: 111
    if not p14.storm or type(p15) ~= "table" then
        return
    end

    if typeof(p15.a) == "Vector3" and typeof(p15.b) == "Vector3" then
        table.insert(p14.storm.beams, {
            parts = nil,
            trailAt = 0,
            data = p15,
            sounds = {}
        })
    end
end

local function newBeamParts(p16) -- line: 118
    -- upvalues: fromRGB (copy), Neon (copy), v1 (copy), v2 (copy), part (copy)
    local t3 = {
        charge = part({
            Name = "Charge",
            Size = Vector3.new(2, 2, 2),
            Transparency = 0.1,
            Shape = Enum.PartType.Ball,
            Material = Neon,
            Color = v1
        }),
        chargeGlow = part({
            Name = "ChargeGlow",
            Size = Vector3.new(4, 4, 4),
            Transparency = 0.55,
            Shape = Enum.PartType.Ball,
            Material = Neon,
            Color = v2
        }),
        mark = part({
            Name = "Mark",
            Size = Vector3.new(0.6, 28, 28),
            Transparency = 0.4,
            Shape = Enum.PartType.Cylinder,
            Material = Neon,
            Color = v2
        }),
        core = part({
            Name = "BeamCore",
            Size = Vector3.new(1, 6, 6),
            Transparency = 1,
            Shape = Enum.PartType.Cylinder,
            Material = Neon,
            Color = v1
        }),
        glow = part({
            Name = "BeamGlow",
            Size = Vector3.new(1, 16, 16),
            Transparency = 1,
            Shape = Enum.PartType.Cylinder,
            Material = Neon,
            Color = v2
        }),
        hit = part({
            Name = "Hit",
            Size = Vector3.new(20, 20, 20),
            Transparency = 1,
            Shape = Enum.PartType.Ball,
            Material = Neon,
            Color = v1
        })
    }
    local PointLight = Instance.new("PointLight")

    PointLight.Color = fromRGB(200, 140, 255)
    PointLight.Range = 40
    PointLight.Brightness = 0
    PointLight.Shadows = false
    PointLight.Parent = t3.hit
    t3.light = PointLight

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(fromRGB(255, 255, 255), fromRGB(180, 110, 255))
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2.4),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Lifetime = NumberRange.new(0.5, 1.1)
    ParticleEmitter.Speed = NumberRange.new(14, 34)
    ParticleEmitter.SpreadAngle = Vector2.new(70, 70)
    ParticleEmitter.Acceleration = Vector3.new(0, -30, 0)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = t3.hit
    t3.sparks = ParticleEmitter

    for _, v23 in pairs(t3) do
        if typeof(v23) == "Instance" and v23:IsA("BasePart") then
            v23.Parent = p16
        end
    end

    return t3
end

local function trailMark(p17, p18) -- line: 155
    -- upvalues: Debris (copy), TweenService (copy), Neon (copy), v2 (copy), part (copy)
    local v24 = part({
        Name = "Scorch",
        Size = Vector3.new(0.4, 15, 15),
        Transparency = 0.2,
        Shape = Enum.PartType.Cylinder,
        Material = Neon,
        Color = v2
    })

    v24.CFrame = CFrame.new(p18 + Vector3.new(0, 0.35, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    v24.Parent = p17
    TweenService:Create(v24, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = Vector3.new(0.4, 6, 6),
        Transparency = 1
    }):Play()
    Debris:AddItem(v24, 1.7)
end

function t1.Step(p19, p20, p21, p22, p23) -- line: 164
    -- upvalues: CosmicEvent (copy), t1 (copy), new (copy), v3 (ref), newBeamParts (copy), trailMark (copy)
    local storm = p19.storm

    if not storm then
        return
    end

    local v25

    for _, v26 in ipairs(storm.beams) do
        local data = v26.data

        if data.fire - CosmicEvent.BEAM_CHARGE - 0.8 <= p20 and p20 < data.fire + CosmicEvent.BEAM_SWEEP then
            local v28 = math.clamp((p20 - data.fire) / CosmicEvent.BEAM_SWEEP, 0, 1)

            v25 = data.a:Lerp(data.b, v28)
            break
        end

        v25 = nil
    end

    local v30 = 1 - math.exp(-p21 * 1.8)

    if not v25 or not p22 then
        storm.yaw += p21 * 0.04
        storm.pitch += (-0.08 - storm.pitch) * v30
    else
        local v31 = v25 - p22.Position
        local v34 = math.atan2(-v31.X, -v31.Z)

        storm.yaw += ((v34 - storm.yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * v30

        local v35 = math.max(new(v31.X, 0, v31.Z).Magnitude, 1)
        local v38 = -math.clamp(math.atan2(-v31.Y, v35) * 0.55, 0.05, 0.6)

        storm.pitch += (v38 - storm.pitch) * v30
    end

    if not p22 then
        return
    end

    local v39 = p22.Position + p22.LookVector * (CosmicEvent.KHAOS_LENGTH * p23 * 0.46) - p22.UpVector * (CosmicEvent.KHAOS_LENGTH * p23 * 0.04)

    for i = #storm.beams, 1, -1 do
        local v40 = storm.beams[i]
        local data = v40.data
        local v41 = p20 - data.fire

        if CosmicEvent.BEAM_SWEEP + 0.6 < v41 then
            if v40.parts then
                for _, v42 in pairs(v40.parts) do
                    if typeof(v42) == "Instance" and v42:IsA("BasePart") then
                        v42:Destroy()
                    end
                end
            end

            table.remove(storm.beams, i)
        elseif -CosmicEvent.BEAM_CHARGE < v41 then
            if not v40.parts then
                v40.parts = newBeamParts(storm.folder)
                t1.Beams += 1
            end

            local parts = v40.parts
            local v43 = (workspace.CurrentCamera.CFrame.Position - data.a).Magnitude < 420

            if v41 < 0 then
                local v45 = math.clamp(1 + v41 / CosmicEvent.BEAM_CHARGE, 0, 1)

                if not v40.sounds.charge then
                    v40.sounds.charge = true

                    if v43 then
                        v3.sound("NoiseBuild", 1.15)
                    end
                end

                parts.charge.CFrame = CFrame.new(v39)
                parts.charge.Size = Vector3.new(1, 1, 1) * (v45 * 20 + 3)
                parts.chargeGlow.CFrame = CFrame.new(v39)
                parts.chargeGlow.Size = Vector3.new(1, 1, 1) * (v45 * 44 + 6 + math.sin(p20 * 30) * 3)
                parts.mark.CFrame = CFrame.new(data.a + Vector3.new(0, 0.4, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)

                local v49 = math.sin(p20 * 14) * 0.5 + 0.5

                parts.mark.Size = new(0.6, v49 * 12 + 20, v49 * 12 + 20)
                parts.mark.Transparency = v49 * 0.35 + 0.25
            elseif v41 < CosmicEvent.BEAM_SWEEP then
                local v52 = v41 / CosmicEvent.BEAM_SWEEP
                local v53 = data.a:Lerp(data.b, v52)

                if not v40.sounds.fire then
                    v40.sounds.fire = true

                    if v43 then
                        v3.sound("Zap", 0.55)
                        v3.sound("SubBoom", 0.9)
                    end
                end

                parts.mark.Transparency = 1
                parts.charge.CFrame = CFrame.new(v39)
                parts.charge.Size = Vector3.new(1, 1, 1) * (math.sin(p20 * 40) * 2 + 20)
                parts.chargeGlow.CFrame = CFrame.new(v39)

                local v56 = math.sin(p20 * 45) * 0.12 + 1
                local core = parts.core
                local v57 = v56 * 7

                core.Size = new(math.max((v53 - v39).Magnitude, 0.1), v57, v57)
                core.CFrame = CFrame.lookAt((v39 + v53) / 2, v53) * CFrame.Angles(0, 1.5707963267948966, 0)

                local glow = parts.glow
                local v59 = v56 * 18

                glow.Size = new(math.max((v53 - v39).Magnitude, 0.1), v59, v59)
                glow.CFrame = CFrame.lookAt((v39 + v53) / 2, v53) * CFrame.Angles(0, 1.5707963267948966, 0)
                parts.core.Transparency = 0.05
                parts.glow.Transparency = 0.5
                parts.hit.CFrame = CFrame.new(v53 + Vector3.new(0, 2, 0))
                parts.hit.Size = Vector3.new(1, 1, 1) * (math.sin(p20 * 33) * 4 + 16)
                parts.hit.Transparency = 0.25
                parts.light.Brightness = 4

                if v43 then
                    parts.sparks:Emit(2)
                end

                if p20 - v40.trailAt > 0.07 then
                    v40.trailAt = p20
                    trailMark(storm.folder, v53)
                end
            else
                local v63 = math.clamp((v41 - CosmicEvent.BEAM_SWEEP) / 0.6, 0, 1)
                local b = data.b
                local core = parts.core
                local v64 = (1 - v63) * 7

                core.Size = new(math.max((b - v39).Magnitude, 0.1), v64, v64)
                core.CFrame = CFrame.lookAt((v39 + b) / 2, b) * CFrame.Angles(0, 1.5707963267948966, 0)

                local glow = parts.glow
                local v66 = (1 - v63) * 18

                glow.Size = new(math.max((b - v39).Magnitude, 0.1), v66, v66)
                glow.CFrame = CFrame.lookAt((v39 + b) / 2, b) * CFrame.Angles(0, 1.5707963267948966, 0)
                parts.core.Transparency = v63 * 0.95 + 0.05
                parts.glow.Transparency = v63 * 0.5 + 0.5
                parts.hit.Transparency = v63 * 0.75 + 0.25
                parts.light.Brightness = (1 - v63) * 4
                parts.charge.Transparency = v63 * 0.9 + 0.1
                parts.chargeGlow.Transparency = v63 * 0.45 + 0.55
            end
        end
    end
end

local function fishName(p24) -- line: 280
    -- upvalues: Fish (copy), Variants (copy), Sizes (copy)
    local v68 = Fish.ById[p24.fishId]
    local v69 = Variants.List[p24.v] or Variants.List[1]
    local v70 = Sizes.List[p24.s] or Sizes.List[Sizes.NORMAL_INDEX]
    local v71 = if v69.index and v69.index >= 2 then v69.id .. " " else ""

    if v70.index ~= Sizes.NORMAL_INDEX then
        v71 ..= v70.id .. " "
    end

    return v71 .. (if v68 then v68.name else "fish")
end

function t1.OnMutated(p25, p26) -- line: 295
    -- upvalues: Debris (copy), TweenService (copy), Toasts (copy), t1 (copy), LocalPlayer (copy), fromRGB (copy), new (copy), Neon (copy), v3 (ref), part (copy), penOf (copy), fishName (copy)
    if type(p26) ~= "table" then
        return
    end

    t1.Mutations += 1

    local v72 = penOf(p26.userId)

    if v72 and p25.folder then
        local v74 = v72.Position + new(0, v72.Size.Y / 2, 0)
        local v75 = part({
            Name = "CosmicColumn",
            Size = Vector3.new(400, 10, 10),
            Transparency = 0.1,
            Shape = Enum.PartType.Cylinder,
            Material = Neon,
            Color = fromRGB(200, 170, 255)
        })

        v75.CFrame = CFrame.new(v74 + Vector3.new(0, 200, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
        v75.Parent = p25.folder
        TweenService:Create(v75, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(400, 60, 60),
            Transparency = 1
        }):Play()
        Debris:AddItem(v75, 1.9)

        local v76 = part({
            Name = "CosmicRing",
            Size = Vector3.new(0.6, 10, 10),
            Transparency = 0.1,
            Shape = Enum.PartType.Cylinder,
            Material = Neon,
            Color = fromRGB(240, 220, 255)
        })

        v76.CFrame = CFrame.new(v74 + Vector3.new(0, 0.5, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
        v76.Parent = p25.folder
        TweenService:Create(v76, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(0.6, 160, 160),
            Transparency = 1
        }):Play()
        Debris:AddItem(v76, 1.3)
    end

    if p26.userId == LocalPlayer.UserId then
        v3.sound("StingChoir")
        v3.sound("EggShine", 0.8)
        v3.card("YOUR FISH TURNED COSMIC!", fromRGB(200, 230, 255), fromRGB(170, 110, 255), 74, 2.6, 0.3)
    else
        v3.sound("Twinkle", 0.8)
        Toasts.Show("gold", ("💫 %s's %s was struck by Khaos's beam: COSMIC x300!"):format(tostring(p26.name), (fishName(p26))))
    end
end

function t1.OnSwept(p27) -- line: 326
    -- upvalues: Debris (copy), TweenService (copy), t1 (copy), LocalPlayer (copy), fromRGB (copy), part (copy), penOf (copy)
    t1.Swept += 1

    local v77 = penOf(LocalPlayer.UserId)

    if not v77 then
        return
    end

    local v78 = part({
        Name = "SoClose",
        Size = Vector3.new(1, 1, 1),
        Transparency = 1
    })

    v78.Position = v77.Position + Vector3.new(0, 14, 0)
    v78.Parent = p27.folder or workspace

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromOffset(320, 70)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 400
    BillboardGui.Parent = v78

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.Font = Enum.Font.FredokaOne
    TextLabel.Text = "SO CLOSE!"
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = fromRGB(220, 200, 255)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Color = fromRGB(40, 20, 80)
    UIStroke.Parent = TextLabel
    TextLabel.Parent = BillboardGui
    TweenService:Create(BillboardGui, TweenInfo.new(1.6), {
        StudsOffsetWorldSpace = Vector3.new(0, 8, 0)
    }):Play()
    TweenService:Create(TextLabel, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    }):Play()
    TweenService:Create(UIStroke, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1
    }):Play()
    Debris:AddItem(v78, 1.7)
end

return t1
