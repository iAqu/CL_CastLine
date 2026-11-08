-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Burst = require(script.Parent.Burst)
local GhostBossFlags = require(ReplicatedStorage.Shared.Flags.GhostBossFlags)
local GhostBoss = require(ReplicatedStorage.Shared.Util.GhostBoss)
local SoulsHud = require(script.Parent.SoulsHud)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local RuptureSeconds = Burst.RuptureSeconds
local t1 = {}

t1.__index = t1

local function sound(...) -- line: 115
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")

    for _, v1 in { ... } do
        Assets = if Assets then Assets:FindFirstChild(v1) else nil
    end

    return if Assets and Assets:IsA("Sound") then Assets else nil
end

local function playAt(p1, p2, p3, p4) -- line: 123
    -- upvalues: Audio (copy)
    if p1 then
        Audio.Play(p1, p2, {
            MaxDistance = 160,
            Volume = p3,
            PlaybackSpeed = p4
        })
    end
end

local function arc(p5, p6, p7, p8) -- line: 129
    return p5:Lerp(p6, p8) + Vector3.new(0, p7 * 4 * p8 * (1 - p8), 0)
end

local function assets() -- line: 134
    -- upvalues: ReplicatedStorage (copy), GhostBoss (copy)
    return ReplicatedStorage:FindFirstChild(GhostBoss.AssetsName)
end

local function prepareMaster(p9) -- line: 138
    -- upvalues: ReplicatedStorage (copy), GhostBoss (copy)
    local clone = p9:Clone()
    local n1 = 0

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            n1 = math.max(n1, descendant.Size.Magnitude)
        end
    end

    local v4

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("LuaSourceContainer") then
            descendant:Destroy()
        elseif descendant:IsA("BasePart") then
            if descendant.Size.Magnitude < n1 * 0.4 then
                descendant:Destroy()
            else
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.CanQuery = false
                descendant.CastShadow = false
                v4 = v4 or descendant
            end
        end
    end

    assert(v4, "Green fire has no parts")

    local BoundingBox, BoundingBox2 = clone:GetBoundingBox()

    clone.PrimaryPart = v4

    local v6 = BoundingBox.Position - Vector3.new(0, BoundingBox2.Y / 2, 0)

    v4.PivotOffset = CFrame.new(v4.CFrame:PointToObjectSpace(v6))

    local v7 = ReplicatedStorage:FindFirstChild(GhostBoss.AssetsName)
    local VFX = v7 and v7:FindFirstChild("VFX")
    local Embers = VFX and VFX:FindFirstChild("Embers")
    local ParticleEmitter = Embers and Embers:FindFirstChildWhichIsA("ParticleEmitter")
    local clone2

    if ParticleEmitter then
        clone2 = ParticleEmitter:Clone()
        clone2.Rate = math.min(clone2.Rate, 3)
        clone2.Enabled = true
    end

    return clone, BoundingBox2.Y, clone2
end

local function rootPosition() -- line: 181
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart.Position else nil
end

local function orbCount(p10) -- line: 187
    -- upvalues: GhostBossFlags (copy)
    local v9 = math.max(GhostBossFlags.SoulsPerOrb:Get(), 1)
    local v10 = GhostBossFlags.SoulOrbsMinimum:Get()
    local v11 = math.max(v10, GhostBossFlags.SoulOrbsMaximum:Get())

    return (math.min(math.clamp(math.ceil(p10 / v9), v10, v11), 150, p10))
end

local function groundParams(p11) -- line: 194
    -- upvalues: Players (copy)
    local t2 = {
        p11
    }

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t2, player.Character)
        end
    end

    local v15 = RaycastParams.new()

    v15.FilterType = Enum.RaycastFilterType.Exclude
    v15.FilterDescendantsInstances = t2
    v15.RespectCanCollide = true

    return v15
end

local function groundAt(p12, p13, p14) -- line: 208
    -- upvalues: Workspace (copy)
    local v16 = Workspace:Raycast(p12 + Vector3.new(0, 20, 0), Vector3.new(0, -80, 0), p14)

    if v16 then
        return v16.Position
    end

    return (Vector3.new(p12.X, p13, p12.Z))
end

local function iconTarget(p15) -- line: 217
    -- upvalues: Workspace (copy), SoulsHud (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local v17 = SoulsHud.IconViewportPoint()

    if CurrentCamera == nil or v17 == nil then
        return p15
    end

    local v18 = CurrentCamera:ViewportPointToRay(v17.X, v17.Y)

    return v18.Origin + v18.Direction * 4
end

function t1.new(p16, p17, p18) -- line: 231
    -- upvalues: ReplicatedStorage (copy), GhostBoss (copy), Trove (copy), t1 (copy), prepareMaster (copy)
    local v19 = Trove.new()
    local v20 = ReplicatedStorage:FindFirstChild(GhostBoss.AssetsName)
    local GreenFire = v20 and v20:FindFirstChild("GreenFire")
    local v21, v22, v23

    if GreenFire and GreenFire:IsA("Model") then
        local v24, v25

        v24, v21, v25 = prepareMaster(GreenFire)
        v22 = v19:Add(v24)

        if v25 then
            v23 = v19:Add(v25)
        end
    else
        v21 = 4
    end

    return (setmetatable({
        SpawnedAt = nil,
        Queued = nil,
        Clock = 0,
        FadeAt = nil,
        Done = false,
        PopCount = 0,
        Lights = 0,
        Trove = v19,
        Parent = p18,
        Master = v22,
        Ember = v23,
        Height = v21,
        From = p16,
        To = p17,
        Born = os.clock(),
        Spirits = {},
        Absorbing = {},
        Random = Random.new()
    }, t1))
end

function t1.IsDone(p19) -- line: 267
    return p19.Done
end

function t1.SpawnSpirits(p20, p21) -- line: 271
    -- upvalues: Workspace (copy), groundParams (copy)
    local t4 = {}

    if p20.Master ~= nil and not (p21 <= 0) then
        local v27 = math.min(p21, 150 - #p20.Spirits)
        local Random = p20.Random
        local v28 = groundParams(p20.Parent)
        local elapsed = os.clock()
        local v29 = Random:NextNumber(0, 6.283185307179586)
        local v32 = math.max(math.floor(v27 / 4), 1)

        for i = 1, v27 do
            local v33 = v29 + i / v27 * 6.283185307179586 + Random:NextNumber(-0.3, 0.3)
            local v35 = math.sqrt((Random:NextNumber())) * 22 + 8
            local v38 = p20.To + Vector3.new(math.cos(v33) * v35, 0, math.sin(v33) * v35)
            local Y = p20.To.Y
            local v39 = Workspace:Raycast(v38 + Vector3.new(0, 20, 0), Vector3.new(0, -80, 0), v28)
            local v40 = if v39 then v39.Position else Vector3.new(v38.X, Y, v38.Z)
            local t5 = {
                Model = nil,
                Value = 0,
                LandedAt = nil,
                Grown = false,
                Scale = Random:NextNumber(0.55, 0.8),
                From = p20.From,
                To = v40,
                Position = p20.From
            }
            local v41 = v27 - 1

            t5.Born = elapsed + (i - 1) * 0.4 / math.max(v41, 1)
            t5.Flight = Random:NextNumber(1.1, 1.6)
            t5.Peak = Random:NextNumber(16, 28)
            t5.Tumble = Vector3.new(Random:NextNumber(-1, 1), Random:NextNumber(1, 2.5) * (if Random:NextNumber() < 0.5 then -1 else 1), Random:NextNumber(-1, 1))
            t5.Seed = Random:NextNumber(0, 100)
            t5.Ember = i % 3 == 0
            t5.Light = i % v32 == 1 or v32 == 1
            table.insert(p20.Spirits, t5)
            table.insert(t4, t5)
        end
    end

    return t4
end

function t1.Materialize(p22, p23) -- line: 318
    local Master = p22.Master

    if Master == nil then
        return nil
    end

    local v44 = p22.Trove:Add(Master:Clone())
    local PrimaryPart = v44.PrimaryPart

    if PrimaryPart then
        local Ember = p22.Ember

        if p23.Ember and Ember then
            Ember:Clone().Parent = PrimaryPart
        end

        if p23.Light and p22.Lights < 4 then
            p22.Lights += 1

            local PointLight = Instance.new("PointLight")

            PointLight.Name = "GreenFireLight"
            PointLight.Color = Color3.fromRGB(90, 255, 160)
            PointLight.Brightness = 1.6
            PointLight.Range = 14
            PointLight.Shadows = false
            PointLight.Parent = PrimaryPart
        end
    end

    v44:ScaleTo(p23.Scale * 0.3)
    v44:PivotTo(CFrame.new(p23.From))
    v44.Parent = p22.Parent
    p23.Model = v44

    return v44
end

function t1.Release(p24, p25) -- line: 348
    if p25 then
        p24.Trove:Remove(p25)
    end
end

function t1.AddSouls(p26, p27) -- line: 354
    -- upvalues: Audio (copy), GhostBossFlags (copy), SoulsHud (copy), sound (copy)
    if p27.Souls <= 0 then
        return
    end

    if p26.FadeAt or p26.Master == nil then
        SoulsHud.Prime(p27.Balance - p27.Souls)
        SoulsHud.Collect(p26.To, p27.Souls)
    elseif p26.SpawnedAt ~= nil then
        p26.Queued = nil
        SoulsHud.Prime(p27.Balance - p27.Souls)

        local Souls = p27.Souls
        local v46 = math.max(GhostBossFlags.SoulsPerOrb:Get(), 1)
        local v47 = GhostBossFlags.SoulOrbsMinimum:Get()
        local v48 = math.max(v47, GhostBossFlags.SoulOrbsMaximum:Get())
        local v52 = math.min(math.clamp(math.ceil(Souls / v46), v47, v48), 150, Souls)
        local t6 = {}

        for _, v53 in p26.Spirits do
            if v53.Value == 0 then
                table.insert(t6, v53)
            end
        end

        if #t6 < v52 then
            for _, v54 in p26:SpawnSpirits(v52 - #t6) do
                table.insert(t6, v54)
            end
        end

        local v56 = math.min(v52, #t6)

        if v56 <= 0 then
            SoulsHud.Collect(p26.To, p27.Souls)
        else
            local v58 = math.floor(p27.Souls / v56)
            local v59 = p27.Souls - v58 * v56

            for i = 1, v56 do
                t6[i].Value = v58 + (i <= v59 and 1 or 0)
            end

            local CollectRainbowRing = sound("Sounds", "LightVsDarknessSounds", "CollectRainbowRing")
            local To = p26.To

            if CollectRainbowRing then
                Audio.Play(CollectRainbowRing, To, {
                    Volume = 0.6,
                    PlaybackSpeed = 0.9,
                    MaxDistance = 160
                })
            end
        end
    else
        p26.Queued = p27
    end
end

function t1.StartAbsorb(p28, p29, p30, p31) -- line: 394
    -- upvalues: GuiService (copy), SoulsHud (copy)
    local Model = p29.Model

    if Model == nil or GuiService.ReducedMotionEnabled then
        SoulsHud.Collect(p31 + Vector3.new(0, p28.Height * p30 / 2, 0), p29.Value)
        p28:Release(Model)
    else
        table.insert(p28.Absorbing, {
            Model = Model,
            Value = p29.Value,
            Scale = p30,
            From = p31,
            Born = os.clock(),
            Yaw = p28.Clock * 0.9 + p29.Seed
        })
    end
end

function t1.StepSpirits(p32, _) -- line: 411
    -- upvalues: Audio (copy), GhostBossFlags (copy), SoulsHud (copy), LocalPlayer (copy), sound (copy)
    local elapsed = os.clock()
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local Position = if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then nil else HumanoidRootPart.Position
    local v61 = GhostBossFlags.SoulAutoCollectSeconds:Get()
    local v62 = GhostBossFlags.SoulPickupRadiusStuds:Get()
    local v63 = p32.SpawnedAt or elapsed
    local FadeAt = p32.FadeAt
    local v64 = if FadeAt then 1 - math.clamp((elapsed - FadeAt) / 0.8, 0, 1) else 1

    for i = #p32.Spirits, 1, -1 do
        local v66 = p32.Spirits[i]

        if not (elapsed < v66.Born) then
            local v67 = v66.Model or p32:Materialize(v66)

            if v67 ~= nil then
                local LandedAt = v66.LandedAt

                if LandedAt ~= nil then
                    local v75, v76, v77

                    if v66.Value > 0 and elapsed - LandedAt >= 0.15 then
                        v75 = v66.Position + Vector3.new(0, p32.Height * v66.Scale / 2, 0)
                        v76 = if Position then (Position - v75).Magnitude else 1e999
                        v77 = v76 <= v62 or v61 <= elapsed - v63
                    else
                        v77 = false
                    end

                    if v77 then
                        table.remove(p32.Spirits, i)

                        if v76 > 260 then
                            SoulsHud.Collect(v75, v66.Value)
                            p32:Release(v67)
                        else
                            p32:StartAbsorb(v66, v66.Scale, v67:GetPivot().Position)
                        end
                    else
                        local v79 = elapsed - LandedAt
                        local v80 = 0

                        if v79 < 0.45 then
                            local v81 = v79 / 0.45

                            v80 = math.abs((math.sin(v81 * 3.141592653589793 * 2))) * 1.2 * (1 - v81)
                        end

                        local v85 = (math.sin(p32.Clock * 2.6 + v66.Seed) * 0.5 + 0.5) * 0.35

                        if FadeAt then
                            v67:ScaleTo((math.max(v66.Scale * v64, 0.05)))
                        end

                        v67:PivotTo(CFrame.new(v66.Position + Vector3.new(0, v85 + 0.25 + v80, 0)) * CFrame.Angles(0, p32.Clock * 0.9 + v66.Seed, 0))
                    end
                else
                    local v69 = math.clamp((elapsed - v66.Born) / v66.Flight, 0, 1)
                    local v70 = v66.Tumble * (1 - v69) * 6.283185307179586
                    local From, To, Peak = v66.From, v66.To, v66.Peak

                    v66.Position = From:Lerp(To, v69) + Vector3.new(0, Peak * 4 * v69 * (1 - v69), 0)

                    if not v66.Grown then
                        local v74 = 1 - (1 - math.clamp(v69 / 0.3, 0, 1)) ^ 2

                        v67:ScaleTo(v66.Scale * (v74 * 0.7 + 0.3))
                        v66.Grown = v74 >= 1
                    end

                    v67:PivotTo(CFrame.new(v66.Position) * CFrame.Angles(v70.X * 0.15, v70.Y + p32.Clock * 0.9 + v66.Seed, v70.Z * 0.15))

                    if v69 >= 1 then
                        v66.LandedAt = elapsed

                        if not v66.Grown then
                            v66.Grown = true
                            v67:ScaleTo(v66.Scale)
                        end

                        p32.PopCount += 1

                        if p32.PopCount % 6 == 1 then
                            local BuddyPop = sound("ShootingStar", "Sounds", "BuddyPop")
                            local To = v66.To
                            local t8 = {
                                1.1, 1.4
                            }

                            if BuddyPop then
                                Audio.Play(BuddyPop, To, {
                                    Volume = 0.3,
                                    MaxDistance = 160,
                                    PlaybackSpeed = t8
                                })
                            end
                        end
                    end
                end
            end
        end
    end
end

function t1.StepAbsorbing(p34) -- line: 499
    -- upvalues: Workspace (copy), SoulsHud (copy)
    local elapsed = os.clock()

    for i = #p34.Absorbing, 1, -1 do
        local v88 = p34.Absorbing[i]
        local v90 = math.clamp((elapsed - v88.Born) / 0.25, 0, 1)
        local v91 = v90 * v90
        local From, From2 = v88.From, v88.From
        local CurrentCamera = Workspace.CurrentCamera
        local v92 = SoulsHud.IconViewportPoint()

        if CurrentCamera ~= nil and v92 ~= nil then
            local v93 = CurrentCamera:ViewportPointToRay(v92.X, v92.Y)

            From2 = v93.Origin + v93.Direction * 4
        end

        local v94 = From:Lerp(From2, v91 * 0.7)
        local v95 = v88.Scale * (1 - v91 * 0.8)

        v88.Model:ScaleTo(v95)
        v88.Model:PivotTo(CFrame.new(v94) * CFrame.Angles(0, v88.Yaw + v90 * 14, 0))

        if v90 >= 1 then
            SoulsHud.Collect(v94 + Vector3.new(0, p34.Height * v95 / 2, 0), v88.Value)
            p34:Release(v88.Model)
            table.remove(p34.Absorbing, i)
        end
    end
end

function t1.Step(p35, p36) -- line: 519
    -- upvalues: Audio (copy), GhostBossFlags (copy), SoulsHud (copy), RuptureSeconds (copy), sound (copy)
    if p35.Done then
        return
    end

    p35.Clock += p36

    local elapsed = os.clock()

    if p35.SpawnedAt == nil then
        local Queued = p35.Queued

        if elapsed - p35.Born < RuptureSeconds or Queued == nil and elapsed - p35.Born < 0.3 then
            return
        end

        p35.SpawnedAt = elapsed

        local v97

        if Queued then
            local Souls = Queued.Souls
            local v99 = math.max(GhostBossFlags.SoulsPerOrb:Get(), 1)
            local v100 = GhostBossFlags.SoulOrbsMinimum:Get()
            local v101 = math.max(v100, GhostBossFlags.SoulOrbsMaximum:Get())

            v97 = math.min(math.clamp(math.ceil(Souls / v99), v100, v101), 150, Souls)
        else
            v97 = math.min(GhostBossFlags.SoulOrbsMinimum:Get(), 150)
        end

        p35:SpawnSpirits(v97)

        local CollectRainbowRing = sound("Sounds", "LightVsDarknessSounds", "CollectRainbowRing")
        local From = p35.From

        if CollectRainbowRing then
            Audio.Play(CollectRainbowRing, From, {
                Volume = 0.5,
                PlaybackSpeed = 0.8,
                MaxDistance = 160
            })
        end

        if Queued then
            p35:AddSouls(Queued)
        end
    end

    p35:StepSpirits(p36)
    p35:StepAbsorbing()

    local SpawnedAt = p35.SpawnedAt

    if p35.FadeAt == nil then
        local n2 = 0

        for _, v106 in p35.Spirits do
            if v106.Value > 0 then
                n2 += 1
            end
        end

        local v107 = elapsed - SpawnedAt

        if n2 == 0 and p35.Queued == nil and v107 >= 6 or v107 >= 40 then
            p35.FadeAt = elapsed

            for i = #p35.Spirits, 1, -1 do
                local v108 = p35.Spirits[i]

                if v108.Value > 0 then
                    table.remove(p35.Spirits, i)

                    local Model = v108.Model

                    SoulsHud.Collect(if Model then Model:GetPivot().Position else v108.Position, v108.Value)
                    p35:Release(Model)
                end
            end
        end
    end

    local FadeAt = p35.FadeAt

    if FadeAt and elapsed - FadeAt >= 0.8 and #p35.Absorbing == 0 then
        p35.Done = true
    end
end

function t1.Destroy(p37) -- line: 578
    p37.Trove:Destroy()
end

return t1
