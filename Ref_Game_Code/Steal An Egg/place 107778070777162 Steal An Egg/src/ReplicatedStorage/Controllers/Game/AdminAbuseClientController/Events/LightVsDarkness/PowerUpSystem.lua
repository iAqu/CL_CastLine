-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Shake = require(ReplicatedStorage.Client.Shake)
local FallenPowerUp = require(ReplicatedStorage.Data.FallenPowerUp)
local LightVsDarknessEventFlags = require(ReplicatedStorage.Shared.Flags.LightVsDarknessEventFlags)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LightVsDarknessSounds = ReplicatedStorage.Assets.Sounds:WaitForChild("LightVsDarknessSounds")
local v1 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local LocalPlayer = Players.LocalPlayer
local v2 = Trove.new()
local v3
local t1 = {}
local t2 = {}
local t3 = {}
local Folder
local n1 = 0
local v4
local n2 = 0

local function serverNow() -- line: 83
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

local function keypoint(p1, p2) -- line: 87
    return NumberSequenceKeypoint.new(p1, p2)
end

local function itemsFolder() -- line: 91
    -- upvalues: Workspace (copy), v2 (copy), Folder (ref)
    local Folder2 = Folder

    if Folder2 ~= nil then
        return Folder2
    end

    local Folder3 = Instance.new("Folder")

    Folder3.Name = "LightVsDarknessPowerUps"
    Folder3.Parent = Workspace
    v2:Add(Folder3)
    v2:Add(function() -- line: 100
        -- upvalues: Folder (ref)
        Folder = nil
    end)
    Folder = Folder3

    return Folder3
end

local function stripModel(p3) -- line: 107
    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        end
    end
end

local function vfxEnabled() -- line: 118
    -- upvalues: LightVsDarknessEventFlags (copy)
    return LightVsDarknessEventFlags.PowerUpDropVfxEnabled:Get()
end

local function punchEnabled() -- line: 122
    -- upvalues: LightVsDarknessEventFlags (copy)
    return LightVsDarknessEventFlags.PowerUpDropVfxEnabled:Get() and LightVsDarknessEventFlags.PowerUpDropPunchEnabled:Get()
end

local function soundsEnabled() -- line: 126
    -- upvalues: LightVsDarknessEventFlags (copy)
    return LightVsDarknessEventFlags.PowerUpDropSoundsEnabled:Get()
end

local function cometScale() -- line: 130
    -- upvalues: LightVsDarknessEventFlags (copy)
    return LightVsDarknessEventFlags.PowerUpCometScale:Get()
end

local function headPixels(p4) -- line: 134
    -- upvalues: Workspace (copy), FallenPowerUp (copy), LightVsDarknessEventFlags (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return FallenPowerUp.HeadPixelMin
    end

    local v5 = math.max((CurrentCamera.CFrame.Position - p4).Magnitude, 1)

    return (math.clamp(FallenPowerUp.HeadPixelRef * LightVsDarknessEventFlags.PowerUpCometScale:Get() / v5, FallenPowerUp.HeadPixelMin, FallenPowerUp.HeadPixelMax))
end

local function skyTargetY(p5) -- line: 147
    -- upvalues: LightVsDarknessEventFlags (copy), v4 (ref)
    local v7 = v4

    if v7 == nil or not LightVsDarknessEventFlags.PowerUpSkyLiftEnabled:Get() then
        return p5.Y
    end

    return v7
end

local function fxAnchor(p6) -- line: 155
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(p6)

    return Part
end

local function playPickupSound() -- line: 167
    -- upvalues: LightVsDarknessSounds (copy)
    local CollectChargedRing = LightVsDarknessSounds:FindFirstChild("CollectChargedRing")

    if CollectChargedRing ~= nil and CollectChargedRing:IsA("Sound") then
        local clone = CollectChargedRing:Clone()

        clone.Parent = CollectChargedRing.Parent
        clone.PlayOnRemove = true
        clone.PlaybackSpeed = 1.15
        task.defer(function() -- line: 176
            -- upvalues: clone (copy)
            clone:Destroy()
        end)
    end
end

local function playRiser() -- line: 181
    -- upvalues: SoundService (copy), FallenPowerUp (copy)
    local Sound = Instance.new("Sound")

    Sound.SoundId = FallenPowerUp.RiserSoundId
    Sound.Volume = FallenPowerUp.RiserVolume
    Sound.PlayOnRemove = true
    Sound.Parent = SoundService
    task.defer(function() -- line: 187
        -- upvalues: Sound (copy)
        Sound:Destroy()
    end)
end

local function playLandSound(p7) -- line: 192
    -- upvalues: FallenPowerUp (copy), itemsFolder (copy)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(p7)

    local Sound = Instance.new("Sound")

    Sound.SoundId = FallenPowerUp.ImpactSoundId
    Sound.Volume = FallenPowerUp.ImpactVolume
    Sound.RollOffMode = Enum.RollOffMode.InverseTapered
    Sound.RollOffMaxDistance = FallenPowerUp.ImpactRangeStuds
    Sound.PlayOnRemove = true
    Sound.Parent = Part
    Part.Parent = itemsFolder()
    task.defer(function() -- line: 202
        -- upvalues: Part (copy)
        Part:Destroy()
    end)
end

local function groundRing(p8, p9, p10) -- line: 207
    -- upvalues: FallenPowerUp (copy)
    local v8 = p8 + Vector3.new(0, FallenPowerUp.MarkerLiftStuds, 0)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(v8)
    Part.Size = Vector3.new(p9, FallenPowerUp.MarkerThickStuds, p9)

    local Decal = Instance.new("Decal")

    Decal.Name = "Ring"
    Decal.Face = Enum.NormalId.Top
    Decal.Texture = FallenPowerUp.MarkerTexture
    Decal.Color3 = p10
    Decal.Parent = Part

    return Part, Decal
end

local function playShockwave(p11, p12) -- line: 221
    -- upvalues: TweenService (copy), FallenPowerUp (copy), v1 (copy), itemsFolder (copy)
    local v9 = p11 + Vector3.new(0, FallenPowerUp.MarkerLiftStuds, 0)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(v9)
    Part.Size = Vector3.new(8, FallenPowerUp.MarkerThickStuds, 8)

    local Decal = Instance.new("Decal")

    Decal.Name = "Ring"
    Decal.Face = Enum.NormalId.Top
    Decal.Texture = FallenPowerUp.MarkerTexture
    Decal.Color3 = p12
    Decal.Parent = Part

    local PointLight = Instance.new("PointLight")

    PointLight.Color = p12
    PointLight.Brightness = FallenPowerUp.LandFlashBrightness
    PointLight.Range = FallenPowerUp.LandFlashRangeStuds
    PointLight.Parent = Part
    Part.Parent = itemsFolder()

    local v10 = TweenInfo.new(FallenPowerUp.ShockwaveSeconds, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local ShockwaveStuds = FallenPowerUp.ShockwaveStuds

    TweenService:Create(Part, v10, {
        Size = Vector3.new(ShockwaveStuds, FallenPowerUp.MarkerThickStuds, ShockwaveStuds)
    }):Play()
    TweenService:Create(Decal, v10, {
        Transparency = 1
    }):Play()
    TweenService:Create(PointLight, v1, {
        Brightness = 0
    }):Play()
    task.delay(FallenPowerUp.ShockwaveSeconds + 0.2, function() -- line: 242
        -- upvalues: Part (copy)
        Part:Destroy()
    end)
end

local function playImpact(p13, p14) -- line: 247
    -- upvalues: ReplicatedStorage (copy), Workspace (copy)
    local BigHitGroundAttach = ReplicatedStorage.Assets.Particles:FindFirstChild("BigHitGroundAttach")

    if BigHitGroundAttach == nil then
        return
    end

    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(p13)
    Part.Parent = Workspace

    local clone = BigHitGroundAttach:Clone()

    clone.Parent = Part

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Color = ColorSequence.new(p14)
            descendant:Emit(descendant:GetAttribute("EmitCount") or 18)
        end
    end

    if clone:IsA("ParticleEmitter") then
        clone.Color = ColorSequence.new(p14)
        clone:Emit(clone:GetAttribute("EmitCount") or 18)
    end

    task.delay(3, function() -- line: 266
        -- upvalues: Part (copy)
        Part:Destroy()
    end)
end

local function playSpawnBurst(p15, p16, p17) -- line: 271
    -- upvalues: TweenService (copy), FallenPowerUp (copy), v1 (copy), keypoint (copy), itemsFolder (copy)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(p15)

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = FallenPowerUp.BurstShockTexture
    ParticleEmitter.Color = ColorSequence.new(p16)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Lifetime = NumberRange.new(0.45, 0.6)
    ParticleEmitter.Rate = 0
    ParticleEmitter.Speed = NumberRange.new(0)
    ParticleEmitter.Rotation = NumberRange.new(0, 360)

    local new = NumberSequence.new
    local v11 = p17 * 2
    local v12 = NumberSequenceKeypoint.new(0, v11)
    local v13 = p17 * 11

    ParticleEmitter.Size = new({
        v12,
        NumberSequenceKeypoint.new(0.4, v13),
        keypoint(1, p17 * 15)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(0.7, 0.5),
        keypoint(1, 1)
    })
    ParticleEmitter.Parent = Part

    local ParticleEmitter2 = Instance.new("ParticleEmitter")

    ParticleEmitter2.Texture = FallenPowerUp.BurstGlowTexture
    ParticleEmitter2.Color = ColorSequence.new(Color3.new(1, 1, 1), p16)
    ParticleEmitter2.LightEmission = 1
    ParticleEmitter2.LightInfluence = 0
    ParticleEmitter2.Lifetime = NumberRange.new(0.35)
    ParticleEmitter2.Rate = 0
    ParticleEmitter2.Speed = NumberRange.new(0)

    local new2 = NumberSequence.new
    local v14 = p17 * 10

    ParticleEmitter2.Size = new2({
        NumberSequenceKeypoint.new(0, v14),
        keypoint(1, 0)
    })
    ParticleEmitter2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        keypoint(1, 1)
    })
    ParticleEmitter2.Parent = Part

    local ParticleEmitter3 = Instance.new("ParticleEmitter")

    ParticleEmitter3.Texture = FallenPowerUp.BurstGlowTexture
    ParticleEmitter3.Color = ColorSequence.new(p16)
    ParticleEmitter3.LightEmission = 1
    ParticleEmitter3.LightInfluence = 0
    ParticleEmitter3.Lifetime = NumberRange.new(0.5, 0.8)
    ParticleEmitter3.Rate = 0
    ParticleEmitter3.Speed = NumberRange.new(p17 * 16, p17 * 26)
    ParticleEmitter3.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter3.Drag = 5

    local new3 = NumberSequence.new
    local v15 = p17 * 0.8

    ParticleEmitter3.Size = new3({
        NumberSequenceKeypoint.new(0, v15),
        keypoint(1, 0)
    })
    ParticleEmitter3.Parent = Part

    local PointLight = Instance.new("PointLight")

    PointLight.Color = p16
    PointLight.Brightness = 6
    PointLight.Range = p17 * 30
    PointLight.Parent = Part
    Part.Parent = itemsFolder()
    ParticleEmitter:Emit(2)
    ParticleEmitter2:Emit(1)
    ParticleEmitter3:Emit((math.floor(p17 * 24)))
    TweenService:Create(PointLight, v1, {
        Brightness = 0
    }):Play()
    task.delay(2, function() -- line: 323
        -- upvalues: Part (copy)
        Part:Destroy()
    end)
end

local function destroyFx(p18) -- line: 328
    local Fx = p18.Fx

    if Fx ~= nil then
        p18.Fx = nil
        Fx:Destroy()
    end

    local Mark = p18.Mark

    if Mark ~= nil then
        p18.Mark = nil
        p18.Ring = nil
        Mark:Destroy()
    end

    local Head = p18.Head

    if Head ~= nil then
        p18.Head = nil
        Head:Destroy()
    end
end

local function buildHead(p19, p20) -- line: 347
    -- upvalues: FallenPowerUp (copy)
    local BasePart = p19.Model:FindFirstChildWhichIsA("BasePart")

    if BasePart == nil then
        return
    end

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "CometHead"
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.Adornee = BasePart
    BillboardGui.Size = UDim2.fromOffset(FallenPowerUp.HeadPixelMin, FallenPowerUp.HeadPixelMin)

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = FallenPowerUp.HeadGlowTexture
    ImageLabel.ImageColor3 = p20
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.Parent = BillboardGui

    local ImageLabel2 = Instance.new("ImageLabel")

    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.Image = FallenPowerUp.HeadGlowTexture
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel2.Size = UDim2.fromScale(FallenPowerUp.HeadCoreScale, FallenPowerUp.HeadCoreScale)
    ImageLabel2.Parent = BillboardGui
    BillboardGui.Parent = BasePart
    p19.Head = BillboardGui
end

local function buildMark(p21, p22, p23) -- line: 384
    -- upvalues: FallenPowerUp (copy), itemsFolder (copy)
    local MarkerStartStuds = FallenPowerUp.MarkerStartStuds
    local v17 = p22 + Vector3.new(0, FallenPowerUp.MarkerLiftStuds, 0)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(v17)
    Part.Size = Vector3.new(MarkerStartStuds, FallenPowerUp.MarkerThickStuds, MarkerStartStuds)

    local Decal = Instance.new("Decal")

    Decal.Name = "Ring"
    Decal.Face = Enum.NormalId.Top
    Decal.Texture = FallenPowerUp.MarkerTexture
    Decal.Color3 = p23
    Decal.Parent = Part
    Part.Parent = itemsFolder()
    p21.Mark = Part
    p21.Ring = Decal
end

local function buildTail(p24, p25, p26, p27, p28) -- line: 392
    -- upvalues: FallenPowerUp (copy), keypoint (copy), itemsFolder (copy)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(p25)
    Part.CFrame = CFrame.lookAt(p25, p26)

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = Part

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Position = Vector3.new(0, 0, p28)
    Attachment2.Parent = Part

    local Beam = Instance.new("Beam")

    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.Texture = FallenPowerUp.TailTexture
    Beam.TextureMode = Enum.TextureMode.Stretch
    Beam.TextureLength = 1
    Beam.TextureSpeed = 0.6
    Beam.FaceCamera = true
    Beam.LightEmission = 1
    Beam.LightInfluence = 0
    Beam.Width0 = FallenPowerUp.TailWidthStuds
    Beam.Width1 = FallenPowerUp.TailTipWidthStuds
    Beam.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.25, p27),
        ColorSequenceKeypoint.new(1, p27)
    })
    Beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.05),
        NumberSequenceKeypoint.new(0.6, 0.45),
        keypoint(1, 1)
    })
    Beam.Parent = Part

    local clone = Beam:Clone()

    clone.Width0 = FallenPowerUp.TailWidthStuds * FallenPowerUp.PlumeWidthScale
    clone.Width1 = FallenPowerUp.TailTipWidthStuds * FallenPowerUp.PlumeWidthScale
    clone.TextureSpeed = 0.25
    clone.Color = ColorSequence.new(p27)

    local new = NumberSequence.new
    local PlumeTransparency = FallenPowerUp.PlumeTransparency

    clone.Transparency = new({
        NumberSequenceKeypoint.new(0, PlumeTransparency),
        NumberSequenceKeypoint.new(0.7, 0.9),
        keypoint(1, 1)
    })
    clone.Parent = Part

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = FallenPowerUp.BurstGlowTexture
    ParticleEmitter.Color = ColorSequence.new(p27)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Lifetime = NumberRange.new(0.35, 0.55)
    ParticleEmitter.Rate = FallenPowerUp.TailSparkRate
    ParticleEmitter.Speed = NumberRange.new(2, 6)
    ParticleEmitter.SpreadAngle = Vector2.new(35, 35)

    local new2 = NumberSequence.new
    local TailSparkStuds = FallenPowerUp.TailSparkStuds

    ParticleEmitter.Size = new2({
        NumberSequenceKeypoint.new(0, TailSparkStuds),
        keypoint(1, 0)
    })
    ParticleEmitter.Parent = Attachment
    Part.Parent = itemsFolder()
    p24.Fx = Part
end

local function buildBeacon(p29, p30, p31) -- line: 453
    -- upvalues: FallenPowerUp (copy), keypoint (copy), itemsFolder (copy)
    local Fx = p29.Fx

    if Fx ~= nil then
        p29.Fx = nil
        Fx:Destroy()
    end

    local Mark = p29.Mark

    if Mark ~= nil then
        p29.Mark = nil
        p29.Ring = nil
        Mark:Destroy()
    end

    local Head = p29.Head

    if Head ~= nil then
        p29.Head = nil
        Head:Destroy()
    end

    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(p30)

    local Attachment = Instance.new("Attachment")

    Attachment.Position = Vector3.new(0, FallenPowerUp.BeaconBaseStuds, 0)
    Attachment.Parent = Part

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Position = Vector3.new(0, FallenPowerUp.BeaconHeightStuds, 0)
    Attachment2.Parent = Part

    local Beam = Instance.new("Beam")

    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.Texture = FallenPowerUp.BeaconTexture
    Beam.TextureMode = Enum.TextureMode.Stretch
    Beam.TextureLength = 1
    Beam.TextureSpeed = 0.35
    Beam.FaceCamera = true
    Beam.LightEmission = 1
    Beam.LightInfluence = 0
    Beam.Width0 = FallenPowerUp.BeaconWidthStuds
    Beam.Width1 = 1.2
    Beam.Color = ColorSequence.new(p31)
    Beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.25),
        NumberSequenceKeypoint.new(0.75, 0.55),
        keypoint(1, 1)
    })
    Beam.Parent = Part
    Part.Parent = itemsFolder()
    p29.Fx = Part
end

local function playLandShake(p32) -- line: 484
    -- upvalues: Shake (copy), FallenPowerUp (copy), LightVsDarknessEventFlags (copy), Player (copy), LocalPlayer (copy)
    if not LightVsDarknessEventFlags.PowerUpLandShakeEnabled:Get() then
        return
    end

    local v18 = LightVsDarknessEventFlags.PowerUpLandShakeRadiusStuds:Get()
    local v19 = Player.FindPrimaryPart(LocalPlayer)
    local v21 = math.clamp(1 - (if v19 == nil then 1e999 else (v19.Position - p32).Magnitude) / math.max(v18, 1), 0, 1) ^ FallenPowerUp.LandShakeFalloff
    local v22 = FallenPowerUp.GlobalBumpSeconds + (FallenPowerUp.LandShakeSeconds - FallenPowerUp.GlobalBumpSeconds) * v21
    local v23 = FallenPowerUp.GlobalBumpIntensity + (FallenPowerUp.LandShakeIntensity - FallenPowerUp.GlobalBumpIntensity) * v21

    Shake.Play({
        Shape = "Pulse",
        Seconds = v22,
        Magnitude = v23
    })
end

local function buildItem(p33) -- line: 499
    -- upvalues: TweenService (copy), Workspace (copy), FallenPowerUp (copy), LightVsDarknessEventFlags (copy), t1 (copy), itemsFolder (copy), stripModel (copy), buildHead (copy), buildTail (copy)
    local v24 = FallenPowerUp.KindById(p33.Kind)
    local v25 = FallenPowerUp.ModelFor(p33.Kind)

    if v24 ~= nil and v25 ~= nil then
        local v26 = Vector3.new(p33.SX, p33.SY, p33.SZ)
        local clone = v25:Clone()

        stripModel(clone)
        clone.Name = ("PowerUp%*"):format(p33.Id)
        clone:PivotTo(CFrame.new(v26))

        local Highlight = Instance.new("Highlight")

        Highlight.FillColor = v24.Color
        Highlight.OutlineColor = v24.Color
        Highlight.FillTransparency = FallenPowerUp.HighlightFillTransparency
        Highlight.OutlineTransparency = FallenPowerUp.HighlightOutlineTransparency
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.Adornee = clone
        Highlight.Parent = clone
        TweenService:Create(Highlight, FallenPowerUp.HighlightPulse, {
            FillTransparency = FallenPowerUp.HighlightPulseFill
        }):Play()

        local BasePart = clone:FindFirstChildWhichIsA("BasePart")

        if BasePart ~= nil then
            local PointLight = Instance.new("PointLight")

            PointLight.Color = v24.Color
            PointLight.Brightness = FallenPowerUp.LightBrightness
            PointLight.Range = FallenPowerUp.LightRangeStuds
            PointLight.Parent = BasePart
        end

        local v27 = clone:GetScale() * FallenPowerUp.WorldScale
        local BoundingBox, BoundingBox2 = clone:GetBoundingBox()
        local v29 = math.max(clone:GetPivot().Position.Y - (BoundingBox.Position.Y - BoundingBox2.Y * 0.5), 0) * FallenPowerUp.WorldScale + FallenPowerUp.BobStuds + FallenPowerUp.HoverStuds
        local v30 = Workspace:GetServerTimeNow() < p33.LandAt
        local v31 = if v30 and LightVsDarknessEventFlags.PowerUpDropVfxEnabled:Get() and LightVsDarknessEventFlags.PowerUpDropPunchEnabled:Get() then v27 * FallenPowerUp.FlightScale * LightVsDarknessEventFlags.PowerUpCometScale:Get() else v27

        clone:ScaleTo(v31)
        clone.Parent = itemsFolder()

        local t5 = {
            AskedAt = 0,
            Landed = false,
            Fx = nil,
            Mark = nil,
            Ring = nil,
            Head = nil,
            ShrinkAt = 0,
            Item = p33,
            Model = clone,
            Scale = v27,
            Start = v26,
            BaseY = p33.Y,
            Flight = v31,
            Rest = v29
        }

        t1[p33.Id] = t5

        if v30 and LightVsDarknessEventFlags.PowerUpDropVfxEnabled:Get() then
            local v32 = Vector3.new(p33.X, p33.Y, p33.Z)
            local v34 = (v26 - v32).Magnitude / math.max(p33.FallSeconds or 1, 0.1)
            local v36 = math.clamp(FallenPowerUp.TailLengthStuds * v34 / FallenPowerUp.TailSpeedRef, FallenPowerUp.TailLengthStuds, FallenPowerUp.TailMaxLengthStuds)

            buildTail(t5, v26, v32, v24.Color, v36)

            if LightVsDarknessEventFlags.PowerUpDropVfxEnabled:Get() and LightVsDarknessEventFlags.PowerUpDropPunchEnabled:Get() then
                buildHead(t5, v24.Color)

                local Color = v24.Color
                local MarkerStartStuds = FallenPowerUp.MarkerStartStuds
                local v37 = v32 + Vector3.new(0, FallenPowerUp.MarkerLiftStuds, 0)
                local Part = Instance.new("Part")

                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.CanTouch = false
                Part.Transparency = 1
                Part.Size = Vector3.new(0.2, 0.2, 0.2)
                Part.CFrame = CFrame.new(v37)
                Part.Size = Vector3.new(MarkerStartStuds, FallenPowerUp.MarkerThickStuds, MarkerStartStuds)

                local Decal = Instance.new("Decal")

                Decal.Name = "Ring"
                Decal.Face = Enum.NormalId.Top
                Decal.Texture = FallenPowerUp.MarkerTexture
                Decal.Color3 = Color
                Decal.Parent = Part
                Part.Parent = itemsFolder()
                t5.Mark = Part
                t5.Ring = Decal
            end
        end
    end
end

local function destroyRendered(p34) -- line: 582
    -- upvalues: t1 (copy)
    local v38 = t1[p34]

    if v38 == nil then
        return
    end

    t1[p34] = nil

    local Fx = v38.Fx

    if Fx ~= nil then
        v38.Fx = nil
        Fx:Destroy()
    end

    local Mark = v38.Mark

    if Mark ~= nil then
        v38.Mark = nil
        v38.Ring = nil
        Mark:Destroy()
    end

    local Head = v38.Head

    if Head ~= nil then
        v38.Head = nil
        Head:Destroy()
    end

    v38.Model:Destroy()
end

local function fadeRendered(p35) -- line: 592
    -- upvalues: TweenService (copy), v1 (copy), t1 (copy)
    local v39 = t1[p35]

    if v39 == nil then
        return
    end

    t1[p35] = nil

    local Fx = v39.Fx

    if Fx ~= nil then
        v39.Fx = nil
        Fx:Destroy()
    end

    local Mark = v39.Mark

    if Mark ~= nil then
        v39.Mark = nil
        v39.Ring = nil
        Mark:Destroy()
    end

    local Head = v39.Head

    if Head ~= nil then
        v39.Head = nil
        Head:Destroy()
    end

    local Model = v39.Model

    for _, descendant in Model:GetDescendants() do
        if descendant:IsA("BasePart") then
            TweenService:Create(descendant, v1, {
                Transparency = 1
            }):Play()
        elseif descendant:IsA("Highlight") then
            TweenService:Create(descendant, v1, {
                FillTransparency = 1,
                OutlineTransparency = 1
            }):Play()
        elseif descendant:IsA("PointLight") then
            TweenService:Create(descendant, v1, {
                Brightness = 0
            }):Play()
        end
    end

    task.delay(0.3, function() -- line: 612
        -- upvalues: Model (copy)
        Model:Destroy()
    end)
end

local function clearItems() -- line: 617
    -- upvalues: v3 (ref), t1 (copy)
    v3 = nil

    for v40 in t1 do
        local v41 = t1[v40]

        if v41 ~= nil then
            t1[v40] = nil

            local Fx = v41.Fx

            if Fx ~= nil then
                v41.Fx = nil
                Fx:Destroy()
            end

            local Mark = v41.Mark

            if Mark ~= nil then
                v41.Mark = nil
                v41.Ring = nil
                Mark:Destroy()
            end

            local Head = v41.Head

            if Head ~= nil then
                v41.Head = nil
                Head:Destroy()
            end

            v41.Model:Destroy()
        end
    end

    table.clear(t1)
end

local function adoptBatch(p36, p37) -- line: 625
    -- upvalues: SoundService (copy), Workspace (copy), FallenPowerUp (copy), LightVsDarknessEventFlags (copy), v3 (ref), t1 (copy), playSpawnBurst (copy), buildItem (copy)
    v3 = nil

    for v42 in t1 do
        local v43 = t1[v42]

        if v43 ~= nil then
            t1[v42] = nil

            local Fx = v43.Fx

            if Fx ~= nil then
                v43.Fx = nil
                Fx:Destroy()
            end

            local Mark = v43.Mark

            if Mark ~= nil then
                v43.Mark = nil
                v43.Ring = nil
                Mark:Destroy()
            end

            local Head = v43.Head

            if Head ~= nil then
                v43.Head = nil
                Head:Destroy()
            end

            v43.Model:Destroy()
        end
    end

    table.clear(t1)
    v3 = p36

    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v44

    for _, v45 in p37 do
        buildItem(v45)

        if v44 == nil and ServerTimeNow < v45.LandAt then
            v44 = Vector3.new(v45.SX, v45.SY, v45.SZ)
        end
    end

    if v44 ~= nil and LightVsDarknessEventFlags.PowerUpDropVfxEnabled:Get() then
        playSpawnBurst(v44, Color3.fromRGB(255, 240, 200), FallenPowerUp.BurstOriginScale)
    end

    if v44 ~= nil and LightVsDarknessEventFlags.PowerUpDropSoundsEnabled:Get() then
        local Sound = Instance.new("Sound")

        Sound.SoundId = FallenPowerUp.RiserSoundId
        Sound.Volume = FallenPowerUp.RiserVolume
        Sound.PlayOnRemove = true
        Sound.Parent = SoundService
        task.defer(function() -- line: 187
            -- upvalues: Sound (copy)
            Sound:Destroy()
        end)
    end
end

local function onDropped(p38, p39) -- line: 644
    -- upvalues: adoptBatch (copy)
    adoptBatch(p38, p39)
end

local function onCleared(p40) -- line: 648
    -- upvalues: v3 (ref), t1 (copy), fadeRendered (copy)
    if p40 ~= v3 then
        return
    end

    v3 = nil

    for v46 in t1 do
        fadeRendered(v46)
    end

    table.clear(t1)
end

local function onCollected(p41, p42, p43) -- line: 659
    -- upvalues: FallenPowerUp (copy), LocalPlayer (copy), v3 (ref), t1 (copy), t2 (copy), playPickupSound (copy), playImpact (copy)
    if p41 ~= v3 then
        return
    end

    local v47 = t1[p42]

    if v47 ~= nil then
        t1[p42] = nil

        local Fx = v47.Fx

        if Fx ~= nil then
            v47.Fx = nil
            Fx:Destroy()
        end

        local Mark = v47.Mark

        if Mark ~= nil then
            v47.Mark = nil
            v47.Ring = nil
            Mark:Destroy()
        end

        local Head = v47.Head

        if Head ~= nil then
            v47.Head = nil
            Head:Destroy()
        end

        local v48 = FallenPowerUp.KindById(v47.Item.Kind)

        if v48 ~= nil then
            playImpact(v47.Model:GetPivot().Position, v48.Color)
        end

        t2[v47.Model] = {
            Model = v47.Model,
            From = v47.Model:GetPivot().Position,
            StartedAt = os.clock(),
            Scale = v47.Model:GetScale(),
            TargetUserId = p43
        }

        if p43 == LocalPlayer.UserId then
            playPickupSound()
        end
    end
end

local function onSky(p44) -- line: 685
    -- upvalues: v4 (ref)
    v4 = if type(p44) == "number" then p44 else nil
end

local function stepAbsorbs(p45) -- line: 689
    -- upvalues: Players (copy), FallenPowerUp (copy), Player (copy), t2 (copy)
    for v49, v50 in t2 do
        if v49.Parent ~= nil then
            local v51 = (p45 - v50.StartedAt) / FallenPowerUp.AbsorbSeconds

            if v51 >= 1 then
                t2[v49] = nil
                v49:Destroy()
            else
                local PlayerByUserId = Players:GetPlayerByUserId(v50.TargetUserId)
                local v52 = if PlayerByUserId == nil then nil else Player.FindRootPart(PlayerByUserId)
                local From = if v52 == nil then v50.From elseif v52:IsA("BasePart") then v52.Position else v50.From
                local v53 = v51 * v51

                v49:PivotTo(CFrame.new(v50.From:Lerp(From, v53)))
                v49:ScaleTo((math.max(v50.Scale * (1 - 0.92 * v51), 0.05)))
            end
        else
            t2[v49] = nil
        end
    end
end

local function stepItems(p46, p47) -- line: 710
    -- upvalues: Workspace (copy), FallenPowerUp (copy), LightVsDarknessEventFlags (copy), Player (copy), Remotes (copy), LocalPlayer (copy), v3 (ref), t1 (copy), v4 (ref), playLandSound (copy), playShockwave (copy), playImpact (copy), buildBeacon (copy), playLandShake (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v55 = Player.FindPrimaryPart(LocalPlayer)
    local v56 = v3
    local v58 = 1 - math.exp(-FallenPowerUp.SkyLiftResponse * p47)

    for v59, v60 in t1 do
        local Item = v60.Item
        local LandAt = Item.LandAt
        local v61 = v4

        if v61 == nil or not LightVsDarknessEventFlags.PowerUpSkyLiftEnabled:Get() then
            v61 = Item.Y
        end

        if ServerTimeNow < LandAt then
            v60.BaseY = v61

            local v62 = Item.FallSeconds or LightVsDarknessEventFlags.PowerUpFallSeconds:Get()
            local v64 = math.clamp(1 - (LandAt - ServerTimeNow) / v62, 0, 1)
            local v65 = Vector3.new(Item.X, v61, Item.Z)
            local v66 = v60.Start:Lerp(v65, v64 ^ FallenPowerUp.FallEase)

            v60.Model:PivotTo(CFrame.new(v66) * CFrame.Angles(0, p46 * FallenPowerUp.SpinSpeed, 0))

            local Fx = v60.Fx

            if Fx ~= nil and (v65 - v66).Magnitude > 0.5 then
                Fx.CFrame = CFrame.lookAt(v66, v65)
            end

            local Head = v60.Head

            if Head ~= nil then
                local CurrentCamera = Workspace.CurrentCamera
                local v67

                if CurrentCamera ~= nil then
                    local v68 = math.max((CurrentCamera.CFrame.Position - v66).Magnitude, 1)

                    v67 = math.clamp(FallenPowerUp.HeadPixelRef * LightVsDarknessEventFlags.PowerUpCometScale:Get() / v68, FallenPowerUp.HeadPixelMin, FallenPowerUp.HeadPixelMax)
                else
                    v67 = FallenPowerUp.HeadPixelMin
                end

                Head.Size = UDim2.fromOffset(v67, v67)
            end

            local Mark, Ring = v60.Mark, v60.Ring

            if Mark ~= nil then
                local v70 = FallenPowerUp.MarkerStartStuds + (FallenPowerUp.MarkerEndStuds - FallenPowerUp.MarkerStartStuds) * v64

                Mark.Size = Vector3.new(v70, FallenPowerUp.MarkerThickStuds, v70)
                Mark.CFrame = CFrame.new(Item.X, v61 + FallenPowerUp.MarkerLiftStuds, Item.Z)
            end

            if Ring ~= nil then
                Ring.Transparency = 0.5 - math.abs((math.sin(p46 * FallenPowerUp.MarkerPulseSpeed))) * 0.35
            end
        else
            if not v60.Landed then
                v60.Landed = true
                v60.ShrinkAt = p46
                v60.BaseY = v61

                local v73 = Vector3.new(Item.X, v61, Item.Z)
                local Fx = v60.Fx

                if Fx ~= nil then
                    v60.Fx = nil
                    Fx:Destroy()
                end

                local Mark = v60.Mark

                if Mark ~= nil then
                    v60.Mark = nil
                    v60.Ring = nil
                    Mark:Destroy()
                end

                local Head = v60.Head

                if Head ~= nil then
                    v60.Head = nil
                    Head:Destroy()
                end

                local v74 = FallenPowerUp.KindById(Item.Kind)

                if v74 ~= nil then
                    playImpact(v73, v74.Color)

                    if LightVsDarknessEventFlags.PowerUpDropVfxEnabled:Get() and LightVsDarknessEventFlags.PowerUpDropPunchEnabled:Get() then
                        playShockwave(v73, v74.Color)
                    end

                    if LightVsDarknessEventFlags.PowerUpDropVfxEnabled:Get() then
                        buildBeacon(v60, v73, v74.Color)
                    end
                end

                if LightVsDarknessEventFlags.PowerUpDropSoundsEnabled:Get() then
                    playLandSound(v73)
                end

                playLandShake(v73)
            end

            local v75 = p46 - v60.ShrinkAt

            if not (v75 < FallenPowerUp.LandScaleSeconds) or v60.Flight == v60.Scale then
                if v60.Model:GetScale() ~= v60.Scale then
                    v60.Model:ScaleTo(v60.Scale)
                end
            else
                local v76 = v75 / FallenPowerUp.LandScaleSeconds

                v60.Model:ScaleTo(v60.Flight + (v60.Scale - v60.Flight) * v76)
            end

            v60.BaseY += (v61 - v60.BaseY) * v58

            local v77 = Vector3.new(Item.X, v60.BaseY, Item.Z)
            local v79 = math.sin(p46 * FallenPowerUp.BobSpeed + v59) * FallenPowerUp.BobStuds

            v60.Model:PivotTo(CFrame.new(v77 + Vector3.new(0, v60.Rest + v79, 0)) * CFrame.Angles(0, p46 * FallenPowerUp.SpinSpeed, 0))

            local Fx = v60.Fx

            if Fx ~= nil then
                Fx.CFrame = CFrame.new(v77)
            end

            if v56 ~= nil and v55 ~= nil and p46 - v60.AskedAt > FallenPowerUp.PickupRetrySeconds and (v55.Position - v77).Magnitude <= FallenPowerUp.PickupRadiusStuds then
                v60.AskedAt = p46
                Remotes.LightVsDarkness.AskCollectPowerUp:FireServer(v56, v59)
            end
        end
    end
end

local function activeKinds(p48, p49) -- line: 809
    -- upvalues: FallenPowerUp (copy)
    local t6 = {}

    for _, v81 in FallenPowerUp.KindList do
        if p49 < FallenPowerUp.ActiveUntil(p48, v81) then
            table.insert(t6, v81)
        end
    end

    return t6
end

local function destroyAuraKind(p50) -- line: 819
    if p50.Clone ~= nil then
        p50.Clone:Destroy()
    end

    p50.Attachment:Destroy()
end

local function destroyAura(p51) -- line: 826
    -- upvalues: t3 (copy)
    local v82 = t3[p51]

    if v82 ~= nil then
        t3[p51] = nil

        for _, v83 in v82.ByKind do
            if v83.Clone ~= nil then
                v83.Clone:Destroy()
            end

            v83.Attachment:Destroy()
        end
    end
end

local function buildAuraKind(p52, p53) -- line: 837
    -- upvalues: FallenPowerUp (copy), itemsFolder (copy), stripModel (copy)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = ("PowerUpAura%*"):format(p52.Id)
    Attachment.Parent = p53

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Color = ColorSequence.new(p52.Color)
    ParticleEmitter.LightEmission = 0.65
    ParticleEmitter.Lifetime = NumberRange.new(0.55, 0.9)
    ParticleEmitter.Rate = 16
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-40, 40)
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.55),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Speed = NumberRange.new(1.5, 3)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.25),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Parent = Attachment

    local v84 = FallenPowerUp.ModelFor(p52.Id)
    local clone

    if v84 ~= nil then
        clone = v84:Clone()
        stripModel(clone)
        clone.Name = ("PowerUpHalo%*"):format(p52.Id)
        clone:ScaleTo(clone:GetScale() * FallenPowerUp.HeadCloneScale)
        clone.Parent = itemsFolder()
    end

    return {
        Clone = clone,
        Emitter = ParticleEmitter,
        Attachment = Attachment
    }
end

local function syncAuras(p54) -- line: 879
    -- upvalues: Players (copy), FallenPowerUp (copy), Player (copy), t3 (copy), activeKinds (copy), buildAuraKind (copy)
    for _, player in Players:GetPlayers() do
        local Character = player.Character
        local v85 = Player.FindRootPart(player)
        local v86 = if Character == nil or v85 == nil then {} elseif v85:IsA("BasePart") then activeKinds(player, p54) else {}
        local v87 = t3[player]

        if #v86 == 0 then
            if v87 ~= nil then
                local v88 = t3[player]

                if v88 ~= nil then
                    t3[player] = nil

                    for _, v89 in v88.ByKind do
                        if v89.Clone ~= nil then
                            v89.Clone:Destroy()
                        end

                        v89.Attachment:Destroy()
                    end
                end
            end
        else
            if v87 ~= nil and (v87.Character ~= Character or v87.Root.Parent == nil) then
                local v92 = t3[player]

                v87 = nil

                if v92 ~= nil then
                    t3[player] = nil

                    for _, v93 in v92.ByKind do
                        if v93.Clone ~= nil then
                            v93.Clone:Destroy()
                        end

                        v93.Attachment:Destroy()
                    end
                end
            end

            if v87 == nil then
                v87 = {
                    Character = Character,
                    Root = v85,
                    ByKind = {}
                }
                t3[player] = v87
            end

            local t7 = {}

            for _, v94 in v86 do
                t7[v94] = true

                if v87.ByKind[v94] == nil then
                    local v95 = FallenPowerUp.KindById(v94)

                    if v95 ~= nil then
                        v87.ByKind[v94] = buildAuraKind(v95, v87.Root)
                    end
                end
            end

            for v96, v97 in v87.ByKind do
                if not t7[v96] then
                    v87.ByKind[v96] = nil

                    if v97.Clone ~= nil then
                        v97.Clone:Destroy()
                    end

                    v97.Attachment:Destroy()
                end
            end
        end
    end

    for v98 in t3 do
        if v98.Parent == nil then
            local v99 = t3[v98]

            if v99 ~= nil then
                t3[v98] = nil

                for _, v100 in v99.ByKind do
                    if v100.Clone ~= nil then
                        v100.Clone:Destroy()
                    end

                    v100.Attachment:Destroy()
                end
            end
        end
    end
end

local function stepAuras(p55) -- line: 929
    -- upvalues: FallenPowerUp (copy), t3 (copy)
    for _, v101 in t3 do
        local Root = v101.Root

        if Root.Parent ~= nil then
            local t8 = {}

            for v102, v103 in v101.ByKind do
                table.insert(t8, {
                    Kind = v102,
                    AuraKind = v103
                })
            end

            table.sort(t8, function(p56, p57) -- line: 939
                -- upvalues: FallenPowerUp (copy)
                local v104 = FallenPowerUp.KindById(p56.Kind)
                local v105 = FallenPowerUp.KindById(p57.Kind)

                return (if v104 then v104.Order else 0) < (if v105 then v105.Order else 0)
            end)

            local v106 = #t8

            for v107, v108 in t8 do
                local Clone = v108.AuraKind.Clone

                if Clone ~= nil and Clone.Parent ~= nil then
                    local v109 = (v107 - (v106 + 1) / 2) * FallenPowerUp.HeadCloneGapStuds
                    local v111 = math.sin(p55 * FallenPowerUp.BobSpeed + v107) * FallenPowerUp.HeadCloneBobStuds
                    local v113 = Root.Position + Vector3.new(0, FallenPowerUp.HeadCloneHoverStuds + v111, 0) + Root.CFrame.RightVector * v109

                    Clone:PivotTo(CFrame.new(v113) * CFrame.Angles(0, p55 * FallenPowerUp.HeadCloneSpinSpeed, 0))
                end
            end
        end
    end
end

local function step() -- line: 963
    -- upvalues: Workspace (copy), n1 (ref), n2 (ref), stepAbsorbs (copy), stepItems (copy), syncAuras (copy), stepAuras (copy)
    local elapsed = os.clock()
    local v115 = math.clamp(elapsed - n2, 0, 0.25)

    n2 = elapsed

    local ServerTimeNow = Workspace:GetServerTimeNow()

    stepItems(elapsed, v115)
    stepAbsorbs(elapsed)
    stepAuras(elapsed)

    if elapsed - n1 >= 0.2 then
        n1 = elapsed
        syncAuras(ServerTimeNow)
    end
end

local function start() -- line: 977
    -- upvalues: RunService (copy), Remotes (copy), v2 (copy), v3 (ref), t1 (copy), t2 (copy), t3 (copy), n1 (ref), v4 (ref), n2 (ref), adoptBatch (copy), onDropped (copy), onCleared (copy), onCollected (copy), onSky (copy), step (copy)
    v2:Clean()
    n1 = 0
    v4 = nil
    n2 = os.clock()
    v2:Connect(Remotes.LightVsDarkness.PowerUpsDropped.OnClientEvent, onDropped)
    v2:Connect(Remotes.LightVsDarkness.PowerUpsCleared.OnClientEvent, onCleared)
    v2:Connect(Remotes.LightVsDarkness.PowerUpCollected.OnClientEvent, onCollected)
    v2:Connect(Remotes.LightVsDarkness.PowerUpsSky.OnClientEvent, onSky)
    v2:Connect(RunService.Heartbeat, step)
    v2:Add(function() -- line: 987
        -- upvalues: v3 (ref), t1 (copy), t2 (copy), t3 (copy), v4 (ref)
        v3 = nil

        for v116 in t1 do
            local v117 = t1[v116]

            if v117 ~= nil then
                t1[v116] = nil

                local Fx = v117.Fx

                if Fx ~= nil then
                    v117.Fx = nil
                    Fx:Destroy()
                end

                local Mark = v117.Mark

                if Mark ~= nil then
                    v117.Mark = nil
                    v117.Ring = nil
                    Mark:Destroy()
                end

                local Head = v117.Head

                if Head ~= nil then
                    v117.Head = nil
                    Head:Destroy()
                end

                v117.Model:Destroy()
            end
        end

        table.clear(t1)
        v4 = nil

        for v118 in t2 do
            v118:Destroy()
        end

        table.clear(t2)

        for v119 in t3 do
            local v120 = t3[v119]

            if v120 ~= nil then
                t3[v119] = nil

                for _, v121 in v120.ByKind do
                    if v121.Clone ~= nil then
                        v121.Clone:Destroy()
                    end

                    v121.Attachment:Destroy()
                end
            end
        end
    end)
    v2:Add(task.spawn(function() -- line: 999
        -- upvalues: Remotes (copy), v3 (ref), v4 (ref), adoptBatch (copy)
        local v122, v123, v124 = Remotes.LightVsDarkness.FetchPowerUps:InvokeServer()

        if type(v124) ~= "number" then
            v124 = nil
        end

        v4 = v124

        if type(v122) == "number" and type(v123) == "table" and v3 == nil then
            adoptBatch(v122, v123)
        end
    end))
end

local function stop() -- line: 1008
    -- upvalues: v2 (copy)
    v2:Clean()
end

return function(_) -- line: 1014
    -- upvalues: start (copy), stop (copy)
    return {
        Start = start,
        Stop = stop
    }
end
