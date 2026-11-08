-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local GhostBoss = require(ReplicatedStorage.Shared.Util.GhostBoss)
local Shake = require(ReplicatedStorage.Client.Shake)
local Trove = require(ReplicatedStorage.Packages.Trove)
local VFX = require(ReplicatedStorage.Shared.Utils.VFX)
local v1 = Color3.fromRGB(80, 255, 210)
local v2 = Color3.fromRGB(70, 255, 120)
local v3 = Color3.fromRGB(200, 255, 240)
local v4 = Color3.new(1, 1, 1)
local Quint = Enum.EasingStyle.Quint
local t1 = {
    SurfaceAppearance = true,
    SpecialMesh = true,
    Decal = true,
    Texture = true
}
local v5 = Random.new()
local t2 = {
    RuptureSeconds = 0.36
}

local function sound(...) -- line: 68
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")

    for _, v6 in { ... } do
        Assets = if Assets then Assets:FindFirstChild(v6) else nil
    end

    return if Assets and Assets:IsA("Sound") then Assets else nil
end

local function ghostSound(p1) -- line: 76
    -- upvalues: ReplicatedStorage (copy), GhostBoss (copy)
    local v7 = ReplicatedStorage:FindFirstChild(GhostBoss.AssetsName)
    local Sounds = v7 and v7:FindFirstChild("Sounds")
    local v8 = Sounds and Sounds:FindFirstChild(p1)

    return if v8 and v8:IsA("Sound") then v8 else nil
end

local function play(p2, p3, p4, p5) -- line: 83
    -- upvalues: Audio (copy)
    if p2 then
        Audio.Play(p2, p3, {
            MaxDistance = 320,
            Volume = p4,
            PlaybackSpeed = p5
        })
    end
end

local function templates(...) -- line: 89
    -- upvalues: ReplicatedStorage (copy), GhostBoss (copy)
    local v9 = ReplicatedStorage:FindFirstChild(GhostBoss.AssetsName)
    local v10 = v9 and v9:FindFirstChild("VFX")

    for _, v11 in { ... } do
        v10 = if v10 then v10:FindFirstChild(v11) else nil
    end

    local t3 = {}

    if v10 ~= nil then
        for _, descendant in v10:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                table.insert(t3, descendant)
            end
        end
    end

    return t3
end

local function debrisFolder() -- line: 107
    -- upvalues: Workspace (copy)
    return Workspace:FindFirstChild("Transient") or Workspace
end

local function shell(p6, p7, p8) -- line: 111
    local Part = Instance.new("Part")

    Part.Name = p6
    Part.Shape = p7
    Part.Material = Enum.Material.Neon
    Part.Color = p8
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Locked = true

    return Part
end

local function expand(p9, p10, p11, p12, p13) -- line: 126
    -- upvalues: TweenService (copy), Workspace (copy), VFX (copy)
    p9.Transparency = p12
    p9.Parent = Workspace:FindFirstChild("Transient") or Workspace
    TweenService:Create(p9, TweenInfo.new(p11, p13, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = p10
    }):Play()
    VFX.Discard(p9, p11 + 0.1)
end

local function ring(p14, p15, p16, p17, p18) -- line: 142
    -- upvalues: TweenService (copy), Workspace (copy), VFX (copy), v1 (copy), Quint (copy)
    local Block = Enum.PartType.Block
    local Part = Instance.new("Part")

    Part.Name = "GhostBossShockwave"
    Part.Shape = Block
    Part.Material = Enum.Material.Neon
    Part.Color = v1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Locked = true
    Part.Size = Vector3.new(p15, 0.05, p15)
    Part.CFrame = CFrame.new(p14) * p18
    Part.Transparency = 1

    local v12 = TweenInfo.new(p17, Quint, Enum.EasingDirection.Out)

    for _, v13 in {
            Enum.NormalId.Top,
            Enum.NormalId.Bottom
        } do
        local Decal = Instance.new("Decal")

        Decal.Texture = "rbxassetid://109600784699514"
        Decal.Color3 = v1
        Decal.Face = v13
        Decal.Transparency = 0
        Decal.Parent = Part
        TweenService:Create(Decal, v12, {
            Transparency = 1
        }):Play()
    end

    Part.Parent = Workspace:FindFirstChild("Transient") or Workspace
    TweenService:Create(Part, v12, {
        Size = Vector3.new(p16, 0.05, p16)
    }):Play()
    VFX.Discard(Part, p17 + 0.1)
end

local function light(p19, p20, p21, p22, p23) -- line: 162
    -- upvalues: TweenService (copy), Workspace (copy), VFX (copy), v1 (copy)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "GhostBossFlashLight"
    Attachment.WorldPosition = p19
    Attachment.Parent = Workspace.Terrain

    local PointLight = Instance.new("PointLight")

    PointLight.Color = p23 or v1
    PointLight.Brightness = p20
    PointLight.Range = p21
    PointLight.Shadows = false
    PointLight.Parent = Attachment
    TweenService:Create(PointLight, TweenInfo.new(p22, Enum.EasingStyle.Quad), {
        Brightness = 0,
        Range = p21 * 0.3
    }):Play()
    VFX.Discard(Attachment, p22 + 0.1)
end

local function nearness(p24) -- line: 186
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return 0
    end

    return (math.clamp(1 - (CurrentCamera.CFrame.Position - p24).Magnitude / 220, 0, 1))
end

local function shardOf(p25) -- line: 195
    -- upvalues: t1 (copy)
    local Archivable = p25.Archivable

    p25.Archivable = true

    local clone = p25:Clone()

    p25.Archivable = Archivable

    if clone == nil then
        return nil
    end

    for _, child in clone:GetChildren() do
        if not t1[child.ClassName] then
            child:Destroy()
        end
    end

    clone.Name = "GhostBossShard"
    clone.Anchored = true
    clone.CanCollide = false
    clone.CanQuery = false
    clone.CanTouch = false
    clone.CastShadow = false
    clone.Massless = true
    clone.LocalTransparencyModifier = 0

    return clone
end

local function flatDirection(p26) -- line: 219
    -- upvalues: v5 (copy)
    local v15 = Vector3.new(p26.X, 0, p26.Z)

    if v15.Magnitude > 0.1 then
        return v15.Unit
    end

    local v16 = v5:NextNumber(0, 6.283185307179586)

    return (Vector3.new(math.cos(v16), 0, (math.sin(v16))))
end

function t2.Rupture(p27) -- line: 232
    -- upvalues: GuiService (copy), ReplicatedStorage (copy), TweenService (copy), Workspace (copy), Audio (copy), GhostBoss (copy), Shake (copy), VFX (copy), v3 (copy), sound (copy), templates (copy)
    local Part = Instance.new("Part")

    Part.Name = "GhostBossRuptureGather"
    Part.Shape = Enum.PartType.Ball
    Part.Size = Vector3.new(18, 18, 18)
    Part.CFrame = CFrame.new(p27)
    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Locked = true
    Part.Parent = Workspace:FindFirstChild("Transient") or Workspace
    VFX.EmitAt(Part, templates("Death", "Rupture", "Gather"))
    VFX.Discard(Part, 0.96)
    VFX.EmitAt(p27, templates("Death", "Rupture", "Core"))

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "GhostBossRuptureLight"
    Attachment.WorldPosition = p27
    Attachment.Parent = Workspace.Terrain

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v3
    PointLight.Brightness = 0
    PointLight.Range = 24
    PointLight.Shadows = false
    PointLight.Parent = Attachment
    TweenService:Create(PointLight, TweenInfo.new(0.36, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Brightness = 12,
        Range = 44
    }):Play()
    VFX.Discard(Attachment, 0.41)

    local v19 = ReplicatedStorage:FindFirstChild(GhostBoss.AssetsName)
    local Sounds = v19 and v19:FindFirstChild("Sounds")
    local Hurt1 = Sounds and Sounds:FindFirstChild("Hurt1")

    if not (Hurt1 and Hurt1:IsA("Sound")) then
        Hurt1 = nil
    end

    if Hurt1 then
        Audio.Play(Hurt1, p27, {
            Volume = 1,
            PlaybackSpeed = 0.85,
            MaxDistance = 320
        })
    end

    local CollectChargedRing = sound("Sounds", "LightVsDarknessSounds", "CollectChargedRing")

    if CollectChargedRing then
        Audio.Play(CollectChargedRing, p27, {
            Volume = 0.5,
            PlaybackSpeed = 0.6,
            MaxDistance = 320
        })
    end

    if not GuiService.ReducedMotionEnabled then
        Shake.Play({
            Seconds = 0.36,
            Magnitude = 0.45,
            Shape = "Pulse",
            Range = {
                Near = 30,
                Far = 160,
                Center = p27
            }
        })
    end
end

function t2.Shatter(p28, p29, p30) -- line: 280
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), Trove (copy), v1 (copy), v2 (copy), v4 (copy), v5 (copy), shardOf (copy)
    local v20 = Trove.new()
    local v21 = v20:Add(Instance.new("Model"))

    v21.Name = "GhostBossShards"

    local Highlight = Instance.new("Highlight")

    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.FillColor = v4
    Highlight.FillTransparency = 0
    Highlight.OutlineColor = v1
    Highlight.OutlineTransparency = 0
    Highlight.Parent = v21

    local t4 = {}

    for _, descendant in p28:GetDescendants() do
        if #t4 >= 12 then
            break
        end

        if descendant:IsA("BasePart") and not (descendant.Transparency >= 1) then
            local v22 = shardOf(descendant)

            if v22 ~= nil then
                local v23 = descendant.Position - p29
                local v24 = Vector3.new(0, 1, 0) * v5:NextNumber(0, 0.6)
                local t5 = {
                    Part = v22,
                    Offset = v23,
                    Rotation = descendant.CFrame.Rotation,
                    Size = descendant.Size,
                    Transparency = v22.Transparency
                }
                local v25 = Vector3.new(v23.X, 0, v23.Z)
                local v26

                if v25.Magnitude > 0.1 then
                    v26 = v25.Unit
                else
                    local v27 = v5:NextNumber(0, 6.283185307179586)

                    v26 = Vector3.new(math.cos(v27), 0, (math.sin(v27)))
                end

                t5.Travel = (v26 + v24).Unit * v5:NextNumber(7, 15) * p30
                t5.Axis = v5:NextUnitVector()
                t5.Spin = v5:NextNumber(3, 7) * (v5:NextNumber() < 0.5 and -1 or 1)
                table.insert(t4, t5)
                v22.Parent = v21
            end
        end
    end

    if #t4 == 0 then
        v20:Destroy()
    else
        v21.Parent = Workspace:FindFirstChild("Transient") or Workspace

        local elapsed = os.clock()

        v20:Connect(RunService.RenderStepped, function() -- line: 328
            -- upvalues: p29 (copy), p30 (copy), v20 (copy), Highlight (copy), t4 (copy), elapsed (copy), TweenService (copy), v2 (copy), v4 (copy)
            local v30 = (os.clock() - elapsed) / 0.62

            if v30 >= 1 then
                v20:Destroy()
            else
                local Value = TweenService:GetValue(v30, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                local v31 = 1 - TweenService:GetValue(v30, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

                Highlight.FillColor = v4:Lerp(v2, (math.min(v30 * 2, 1)))
                Highlight.FillTransparency = v30 * 0.6
                Highlight.OutlineTransparency = v30

                for _, v33 in t4 do
                    local v34 = p29 + v33.Offset * (1 + 0.3 * Value) + v33.Travel * Value + Vector3.new(0, 3, 0) * p30 * Value

                    v33.Part.Size = v33.Size * math.max(v31, 0.01)
                    v33.Part.Transparency = v33.Transparency + (1 - v33.Transparency) * v30 ^ 3
                    v33.Part.CFrame = CFrame.new(v34) * CFrame.fromAxisAngle(v33.Axis, v33.Spin * Value) * v33.Rotation
                end
            end
        end)
        task.delay(1.12, function() -- line: 352
            -- upvalues: v20 (copy)
            v20:Destroy()
        end)
    end
end

function t2.Explode(p31, p32) -- line: 357
    -- upvalues: GuiService (copy), ReplicatedStorage (copy), Workspace (copy), Audio (copy), Flash (copy), GhostBoss (copy), Shake (copy), VFX (copy), v1 (copy), v2 (copy), v3 (copy), Quint (copy), sound (copy), templates (copy), expand (copy), ring (copy), light (copy)
    local Ball = Enum.PartType.Ball
    local Part = Instance.new("Part")

    Part.Name = "GhostBossCore"
    Part.Shape = Ball
    Part.Material = Enum.Material.Neon
    Part.Color = v3
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Locked = true
    Part.Size = Vector3.new(2, 2, 2)
    Part.CFrame = CFrame.new(p31)
    expand(Part, Vector3.new(30, 30, 30), 0.5, 0, Quint)

    local Ball2 = Enum.PartType.Ball
    local Part2 = Instance.new("Part")

    Part2.Name = "GhostBossAura"
    Part2.Shape = Ball2
    Part2.Material = Enum.Material.Neon
    Part2.Color = v2
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.CastShadow = false
    Part2.Locked = true
    Part2.Size = Vector3.new(4, 4, 4)
    Part2.CFrame = CFrame.new(p31)
    expand(Part2, Vector3.new(52, 52, 52), 0.9, 0.35, Enum.EasingStyle.Cubic)
    ring(p31, 4, 84, 0.8, CFrame.identity)
    ring(p31, 3, 58, 0.65, CFrame.Angles(1.2217304763960306, 0, 0.3490658503988659))
    ring(p31, 3, 50, 0.6, CFrame.Angles(-1.0471975511965976, 0, -0.6108652381980153))
    light(p31, 16, 70, 1.1)
    VFX.EmitAt(p31, templates("Explosion"))
    VFX.EmitAt(p31, templates("Death", "Burst"))

    local v35 = (p32 or p31 - Vector3.new(0, 3, 0)) + Vector3.new(0, 0.35, 0)

    ring(v35, 6, 120, 1.1, CFrame.identity)
    task.delay(0.12, ring, v35, 4, 72, 0.95, CFrame.identity)
    VFX.EmitAt(v35 + Vector3.new(0, 0.2, 0), templates("Death", "Ground"))
    light(v35 + Vector3.new(0, 5, 0), 9, 80, 2.4, v2)

    local CinematicBoom = sound("Sounds", "CinematicBoom")

    if CinematicBoom then
        Audio.Play(CinematicBoom, p31, {
            Volume = 1,
            PlaybackSpeed = 1,
            MaxDistance = 320
        })
    end

    local ImpactBoom = sound("Sounds", "ImpactBoom")

    if ImpactBoom then
        Audio.Play(ImpactBoom, p31, {
            Volume = 0.7,
            PlaybackSpeed = 0.85,
            MaxDistance = 320
        })
    end

    local Pop = sound("Sounds", "ScrambleBoss", "Pop")

    if Pop then
        Audio.Play(Pop, p31, {
            Volume = 0.6,
            PlaybackSpeed = 1.2,
            MaxDistance = 320
        })
    end

    local v36 = ReplicatedStorage:FindFirstChild(GhostBoss.AssetsName)
    local Sounds = v36 and v36:FindFirstChild("Sounds")
    local Swing = Sounds and Sounds:FindFirstChild("Swing")

    if not (Swing and Swing:IsA("Sound")) then
        Swing = nil
    end

    if Swing then
        Audio.Play(Swing, p31, {
            Volume = 0.7,
            PlaybackSpeed = 1.3,
            MaxDistance = 320
        })
    end

    local CurrentCamera = Workspace.CurrentCamera
    local v37 = if CurrentCamera == nil then 0 else math.clamp(1 - (CurrentCamera.CFrame.Position - p31).Magnitude / 220, 0, 1)

    if v37 > 0 then
        Flash.Play({
            Attack = 0.03,
            Decay = 0.8,
            Tint = v1,
            Opacity = v37 * 0.55
        })
    end

    if not GuiService.ReducedMotionEnabled then
        Shake.Play({
            Seconds = 1.1,
            Magnitude = 1.8,
            Shape = "Fade",
            Range = {
                Near = 35,
                Far = 200,
                Center = p31
            }
        })
    end
end

function t2.SpawnPuff(p33) -- line: 400
    -- upvalues: GuiService (copy), Audio (copy), Shake (copy), VFX (copy), sound (copy), templates (copy), ring (copy), light (copy)
    ring(p33 + Vector3.new(0, 0.5, 0), 4, 48, 0.9, CFrame.identity)
    light(p33 + Vector3.new(0, 6, 0), 8, 40, 1.4)
    VFX.EmitAt(p33 + Vector3.new(0, 1, 0), templates("Spawn"))

    local v39 = sound("Sounds", "BossEventSounds", "Boss Spawn")

    if v39 then
        Audio.Play(v39, p33, {
            Volume = 0.8,
            PlaybackSpeed = 1.1,
            MaxDistance = 320
        })
    end

    if not GuiService.ReducedMotionEnabled then
        Shake.Play({
            Seconds = 0.6,
            Magnitude = 0.6,
            Shape = "Pulse",
            Range = {
                Near = 40,
                Far = 200,
                Center = p33
            }
        })
    end
end

return table.freeze(t2)
