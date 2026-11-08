-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local SammyEventFlags = require(ReplicatedStorage.Shared.Flags.SammyEventFlags)

require(ReplicatedStorage.Packages.Trove)

local ExplosionVFX = ReplicatedStorage.Assets.Particles:WaitForChild("SammyEventVFX"):WaitForChild("ExplosionVFX")
local Explosion = ReplicatedStorage.Assets.Sounds:WaitForChild("Explosion")
local v1 = Color3.fromRGB(255, 40, 40)
local v2 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local v3 = ReplicatedStorage.Assets:WaitForChild("SammyEventVisuals"):WaitForChild("Strawberry Elephant Attacker")
local v4 = CFrame.Angles(0, -1.5707963267948966, 0)
local v5 = CameraShaker.new()
local v6
local n1 = 0
local n2 = 0

assert(Explosion:IsA("Sound"), "Assets.Sounds.Explosion must be a Sound")
assert(v3:IsA("Model"), "Strawberry Elephant Attacker must be a Model")
assert(v3.Rig.RootPart.Anchored, "Strawberry Elephant Attacker.Rig.RootPart must be anchored")

local v7 = RaycastParams.new()

v7.FilterType = Enum.RaycastFilterType.Include
v7.RespectCanCollide = true

local function sammyRoot() -- line: 88
    -- upvalues: v6 (ref)
    local v8 = v6

    if v8 == nil or v8.Parent == nil or v8:GetAttribute("Chasing") ~= true or v8:GetAttribute("Stunned") == true then
        return nil
    end

    local HumanoidRootPart = v8:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end

local function step() -- line: 101
    -- upvalues: Player (copy), SammyEventFlags (copy), v5 (copy), n1 (ref), sammyRoot (copy)
    local v9 = sammyRoot()

    if v9 ~= nil then
        local elapsed = os.clock()

        if not (elapsed < n1) then
            local v10 = Player.FindPrimaryPart()

            if v10 ~= nil then
                local v11 = SammyEventFlags.SammyShakeRadiusStuds:Get()
                local Magnitude = (v10.Position - v9.Position).Magnitude

                if not (v11 <= Magnitude) then
                    n1 = elapsed + 0.35
                    v5:ShakeOnce(3.5 * (1 - Magnitude / v11), 8, 0.1, 0.6)
                end
            end
        end
    end
end

local function spawnBombIndicator(p1, p2) -- line: 129
    -- upvalues: TweenService (copy), Workspace (copy), v1 (copy), v2 (copy)
    local Part = Instance.new("Part")

    Part.Name = "SammyBombIndicator"
    Part.Shape = Enum.PartType.Cylinder
    Part.Size = Vector3.new(0.4, p2 * 2, p2 * 2)
    Part.CFrame = CFrame.new(p1 + Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part.Material = Enum.Material.Neon
    Part.Color = v1
    Part.Transparency = 0.3
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Parent = Workspace
    TweenService:Create(Part, v2, {
        Transparency = 0.8
    }):Play()

    return Part
end

local function burstEmitters(p3) -- line: 150
    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")
            local EmitDuration = descendant:GetAttribute("EmitDuration")
            local EmitDelay = descendant:GetAttribute("EmitDelay")

            local function fire() -- line: 158
                -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                if type(EmitCount) == "number" and EmitCount > 0 then
                    descendant:Emit((math.max(1, (math.floor(EmitCount + 0.5)))))
                end

                if type(EmitDuration) == "number" and EmitDuration > 0 then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 164
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end

            if type(EmitDelay) == "number" and EmitDelay > 0 then
                task.delay(EmitDelay, fire)
            else
                fire()
            end
        end
    end
end

local function playExplosion(p4) -- line: 177
    -- upvalues: Debris (copy), Workspace (copy), ExplosionVFX (copy), burstEmitters (copy)
    local Part = Instance.new("Part")

    Part.Name = "SammyBombExplosion"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.CFrame = CFrame.new(p4)

    local clone = ExplosionVFX:Clone()

    clone.Parent = Part
    Part.Parent = Workspace
    burstEmitters(clone)
    Debris:AddItem(Part, 3)
end

local function playExplosionSound(p5) -- line: 195
    -- upvalues: Debris (copy), Workspace (copy), Player (copy), Explosion (copy), n2 (ref)
    local elapsed = os.clock()
    local v16 = Player.FindPrimaryPart()

    if elapsed < n2 or v16 == nil then
        return
    end

    n2 = elapsed + 0.3

    local v17 = p5[1]

    for _, v18 in p5 do
        if (v18 - v16.Position).Magnitude < (v17 - v16.Position).Magnitude then
            v17 = v18
        end
    end

    local Part = Instance.new("Part")

    Part.Name = "SammyBombSound"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.CFrame = CFrame.new(v17)

    local clone = Explosion:Clone()

    clone.Parent = Part
    Part.Parent = Workspace
    clone:Play()
    Debris:AddItem(Part, 8)
end

local function shakeFromBlasts(p6, p7) -- line: 225
    -- upvalues: Player (copy), v5 (copy)
    local v19 = Player.FindPrimaryPart()

    if v19 == nil then
        return
    end

    local v20 = p7 * 3
    local n3 = 1e999

    for _, v21 in p6 do
        n3 = math.min(n3, (v19.Position - v21).Magnitude)
    end

    if not (v20 <= n3) then
        v5:ShakeOnce(5 * (1 - n3 / v20), 10, 0, 1.5, Vector3.new(0.25, 0.25, 0.25), (Vector3.new(4, 1, 1)))
    end
end

local function dropBombRow(p8, p9, p10, p11) -- line: 249
    -- upvalues: Workspace (copy), Player (copy), spawnBombIndicator (copy), playExplosion (copy), playExplosionSound (copy), shakeFromBlasts (copy)
    local v22 = Player.FindPrimaryPart()

    if v22 == nil then
        return
    end

    local t1 = {}

    for _, v23 in p9 do
        if (v23 - v22.Position).Magnitude <= 670 then
            table.insert(t1, v23)
        end
    end

    if #t1 == 0 then
        return
    end

    local t2 = {}

    for _, v24 in t1 do
        table.insert(t2, p8:Add((spawnBombIndicator(v24, p10))))
    end

    p8:Add(task.delay(math.max(p11 - Workspace:GetServerTimeNow(), 0), function() -- line: 267
        -- upvalues: p8 (copy), p10 (copy), t1 (copy), t2 (copy), playExplosion (copy), playExplosionSound (copy), shakeFromBlasts (copy)
        for _, v28 in t2 do
            p8:Remove(v28)
        end

        for _, v29 in t1 do
            playExplosion(v29)
        end

        shakeFromBlasts(t1, p10)
        playExplosionSound(t1)
    end))
end

local function elephantGround(p12) -- line: 279
    -- upvalues: Workspace (copy), v7 (copy)
    local v30 = Workspace:Raycast(p12 + Vector3.new(0, 60, 0), Vector3.new(0, -200, 0), v7)

    return if v30 ~= nil then v30.Position.Y else nil
end

local function spawnElephantWarning(p13) -- line: 289
    -- upvalues: TweenService (copy), Workspace (copy), v1 (copy), v2 (copy)
    local Part = Instance.new("Part")

    Part.Name = "SammyElephantWarning"
    Part.Size = Vector3.new(p13, 0.4, 50)
    Part.Material = Enum.Material.Neon
    Part.Color = v1
    Part.Transparency = 0.3
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Parent = Workspace
    TweenService:Create(Part, v2, {
        Transparency = 0.8
    }):Play()

    return Part
end

local function runElephants(p14, p15, p16, p17, p18, p19, p20) -- line: 310
    -- upvalues: RunService (copy), Workspace (copy), v3 (copy), v4 (copy), v7 (copy), spawnElephantWarning (copy)
    local t3 = {
        Workspace.World.Build,
        Workspace.Terrain
    }
    local SABMap = Workspace:FindFirstChild("SABMap")

    if SABMap ~= nil then
        table.insert(t3, SABMap)
    end

    v7.FilterDescendantsInstances = t3

    local Hitbox = v3.Hitbox
    local v31 = Hitbox.Size.Y * 0.5
    local v32 = Hitbox.Size.X * 0.5
    local Z = Hitbox.Size.Z
    local v34 = Vector3.new(-p17.Z, 0, p17.X)
    local t4 = {}

    for _, v35 in p20 do
        local v36 = p14:Add(v3:Clone())

        v36.Parent = Workspace

        local track = v36.Rig.AnimationController.Animator:LoadAnimation(v36.Animation)

        track.Looped = true
        track:Play()
        table.insert(t4, {
            Model = v36,
            Warning = p14:Add((spawnElephantWarning(Z))),
            Offset = v35,
            Y = p16.Y
        })
    end

    local v37

    v37 = p14:Add(RunService.Heartbeat:Connect(function(p21) -- line: 352
        -- upvalues: p14 (copy), p15 (copy), p16 (copy), p17 (copy), p18 (copy), p19 (copy), v31 (copy), v32 (copy), Z (copy), v34 (copy), t4 (copy), v37 (ref), Workspace (copy), v4 (copy), v7 (copy)
        local v38 = (Workspace:GetServerTimeNow() - p15) * p18

        if p19 <= v38 then
            for _, v39 in t4 do
                p14:Remove(v39.Model)
                p14:Remove(v39.Warning)
            end

            p14:Remove(v37)
        else
            local v42 = math.min(1, p21 * 10)
            local v44 = math.min(50, p19 - v38)

            for _, v45 in t4 do
                local v46 = p16 + p17 * math.max(v38, 0) + v34 * v45.Offset
                local Y = v45.Y
                local v47 = Workspace:Raycast(v46 + Vector3.new(0, 60, 0), Vector3.new(0, -200, 0), v7)

                v45.Y = Y + (((if v47 == nil then nil else v47.Position.Y) or v45.Y) - v45.Y) * v42

                local v49 = Vector3.new(v46.X, v45.Y + v31, v46.Z)

                v45.Model:PivotTo(CFrame.lookAt(v49, v49 + p17) * v4)

                local v51 = Vector3.new(v46.X, v45.Y + 0.15, v46.Z) + p17 * (v32 + v44 * 0.5)

                v45.Warning.Size = Vector3.new(Z, 0.4, v44)
                v45.Warning.CFrame = CFrame.lookAt(v51, v51 + p17)
            end
        end
    end))
end

local function watchMap(p22, p23) -- line: 378
    -- upvalues: v6 (ref)
    v6 = p23:FindFirstChild("Sammy")
    p22:Connect(p23.ChildAdded, function(p24) -- line: 380
        -- upvalues: v6 (ref)
        if p24.Name == "Sammy" and p24:IsA("Model") then
            v6 = p24
        end
    end)
    p22:Connect(p23.ChildRemoved, function(p25) -- line: 385
        -- upvalues: v6 (ref)
        if p25 == v6 then
            v6 = nil
        end
    end)
end

return {
    Start = function(p26) -- start | line: 392
        -- upvalues: RunService (copy), Workspace (copy), CameraShakerDriver (copy), Remotes (copy), v5 (copy), v6 (ref), n1 (ref), step (copy), dropBombRow (copy), runElephants (copy), watchMap (copy)
        v6 = nil
        n1 = 0
        CameraShakerDriver.Start(v5, Enum.RenderPriority.Camera.Value + 2)

        local SammyEventMap = Workspace:FindFirstChild("SammyEventMap")

        if SammyEventMap ~= nil then
            watchMap(p26, SammyEventMap)
        else
            p26:Connect(Workspace.ChildAdded, function(p27) -- line: 403
                -- upvalues: p26 (copy), watchMap (copy)
                if p27.Name == "SammyEventMap" then
                    watchMap(p26, p27)
                end
            end)
        end

        p26:Connect(Remotes.SammyEvent.ElephantCharge.OnClientEvent, function(p28, p29, p30, p31, p32, p33) -- line: 412
            -- upvalues: p26 (copy), runElephants (copy)
            runElephants(p26, p28, p29, p30, p31, p32, p33)
        end)
        p26:Connect(Remotes.SammyEvent.BomberRow.OnClientEvent, function(p34, p35, p36) -- line: 418
            -- upvalues: p26 (copy), dropBombRow (copy)
            dropBombRow(p26, p34, p35, p36)
        end)
        p26:Connect(RunService.Heartbeat, step)
        p26:Add(function() -- line: 423
            -- upvalues: CameraShakerDriver (copy), v5 (copy), v6 (ref)
            v6 = nil
            CameraShakerDriver.Stop(v5)
        end)
    end
}
