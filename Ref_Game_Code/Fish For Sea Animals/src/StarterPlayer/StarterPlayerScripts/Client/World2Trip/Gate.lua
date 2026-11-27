-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Settings = require(script.Parent.Parent.UI.Settings)
local BossJuice = require(script.Parent.Parent.Boss.BossJuice)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local v1 = false
local v2 = false
local t2 = {}

local function seal() -- line: 30
    local EventHole = workspace:FindFirstChild("EventHole")
    local Seal = EventHole and EventHole:FindFirstChild("Seal")

    return if Seal and Seal:IsA("Model") then Seal else nil
end

function t1.isOpen() -- line: 36
    -- upvalues: v1 (ref)
    return v1
end

function t1.zone() -- line: 41
    -- upvalues: v1 (ref), v2 (ref)
    local EventHole = workspace:FindFirstChild("EventHole")
    local Seal = EventHole and EventHole:FindFirstChild("Seal")

    if not (Seal and Seal:IsA("Model")) then
        Seal = nil
    end

    local UnlockZone = Seal and Seal:FindFirstChild("UnlockZone")

    return if UnlockZone and UnlockZone:IsA("BasePart") and not v1 and not v2 then UnlockZone else nil
end

function t1.price() -- line: 47
    local EventHole = workspace:FindFirstChild("EventHole")
    local v3 = EventHole and EventHole:FindFirstChild("Seal")

    if not (v3 and v3:IsA("Model")) then
        v3 = nil
    end

    if v3 then
        local EventHole = workspace:FindFirstChild("EventHole")
        local Seal = EventHole and EventHole:FindFirstChild("Seal")

        if not (Seal and Seal:IsA("Model")) then
            Seal = nil
        end

        v3 = Seal:FindFirstChild("UnlockZone")
    end

    return v3 and v3:GetAttribute("Price") or 0
end

local function setGone(p1) -- line: 52
    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = 1

            if descendant:GetAttribute("Collider") then
                descendant.CanCollide = false
            end
        end
    end
end

local function openNow() -- line: 64
    -- upvalues: v1 (ref), setGone (copy)
    v1 = true

    local EventHole = workspace:FindFirstChild("EventHole")
    local Seal = EventHole and EventHole:FindFirstChild("Seal")

    if not (Seal and Seal:IsA("Model")) then
        Seal = nil
    end

    if Seal then
        setGone(Seal)
    end
end

local function shakeFor(p2, p3) -- line: 73
    -- upvalues: RunService (copy), Settings (copy), LocalPlayer (copy)
    local v4 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    if v4 and Settings.get("Shake") then
        local elapsed = os.clock()
        local connection

        connection = RunService.RenderStepped:Connect(function() -- line: 80
            -- upvalues: p2 (copy), p3 (copy), v4 (copy), elapsed (copy), connection (ref)
            local v5 = os.clock() - elapsed

            if p2 <= v5 or not v4.Parent then
                connection:Disconnect()
                v4.CameraOffset = Vector3.new(0, 0, 0)
            else
                local v6 = p3(v5)

                v4.CameraOffset = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * 2 * v6
            end
        end)
    end
end

local function dust(p4, p5, p6, p7) -- line: 92
    -- upvalues: Debris (copy)
    local Part = Instance.new("Part")

    Part.Name = "SealDust"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = p5
    Part.CFrame = CFrame.new(p4)
    Part.Parent = workspace

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(150, 140, 160))
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2),
        NumberSequenceKeypoint.new(1, 7)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.35),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(1.5, 2.8)
    ParticleEmitter.Speed = NumberRange.new(p7 * 0.4, p7)
    ParticleEmitter.SpreadAngle = Vector2.new(70, 70)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Right
    ParticleEmitter.Drag = 2.5
    ParticleEmitter.Acceleration = Vector3.new(0, 2, 0)
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-40, 40)
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit(p6)
    Debris:AddItem(Part, 4)

    return Part
end

local function breakOpen() -- line: 122
    -- upvalues: RunService (copy), UIUtil (copy), BossJuice (copy), v1 (ref), v2 (ref), t2 (copy), setGone (copy), shakeFor (copy), dust (copy)
    local EventHole = workspace:FindFirstChild("EventHole")
    local Seal = EventHole and EventHole:FindFirstChild("Seal")

    if not (Seal and Seal:IsA("Model")) then
        Seal = nil
    end

    if not (v1 or v2) then
        if Seal then
            v2 = true

            local t3 = {}
            local t4 = {}

            for _, descendant in Seal:GetDescendants() do
                if descendant:IsA("BasePart") and descendant.Name == "Rock" then
                    t2[descendant] = t2[descendant] or descendant.CFrame
                    table.insert(t3, {
                        part = descendant,
                        home = t2[descendant]
                    })
                elseif descendant:IsA("BasePart") and descendant.Name == "CrackGlow" then
                    table.insert(t4, descendant)
                end
            end

            local Position = Seal:GetBoundingBox().Position
            local v10 = UIUtil.sound("Rumble", 1, 0.55, 8)

            UIUtil.sound("BossGrowl", 0.35, 0.35)
            shakeFor(1.6, function(p8) -- line: 145
                return 0.08 + (p8 / 1.6) ^ 2 * 0.55
            end)
            dust(Position + Vector3.new(1, 6, 0), Vector3.new(2, 10, 12), 18, 6)

            local elapsed = os.clock()
            local connection = RunService.RenderStepped:Connect(function() -- line: 150
                -- upvalues: t3 (copy), t4 (copy), elapsed (copy)
                local v12 = math.clamp((os.clock() - elapsed) / 1.6, 0, 1)
                local t6 = {}
                local t7 = {}

                for _, v13 in t3 do
                    local v14 = v12 * v12 * 0.35 + 0.06

                    table.insert(t6, v13.part)
                    table.insert(t7, v13.home * CFrame.new((math.random() - 0.5) * v14, (math.random() - 0.5) * v14, (math.random() - 0.5) * v14))
                end

                workspace:BulkMoveTo(t6, t7, Enum.BulkMoveMode.FireCFrameChanged)

                for _, v16 in t4 do
                    v16.Size = Vector3.new(v12 * 0.5 + 0.3, v16.Size.Y, v12 * 0.4 + 0.35)
                    v16.Color = Color3.fromRGB(80, 200, 255):Lerp(Color3.fromRGB(230, 250, 255), v12)
                end
            end)

            task.wait(1.6)
            connection:Disconnect()

            if v10 then
                UIUtil.tween(v10, 1.5, {
                    Volume = 0
                })
            end

            UIUtil.sound("SubBoom", 1, 0.6)
            UIUtil.sound("BossExplosion", 0.45, 0.7)
            UIUtil.sound("BigSplash", 0.4, 0.5)
            BossJuice.impactFrame(Color3.fromRGB(200, 235, 255), 0.45, 0.35)
            BossJuice.fovPunch(-5, 0.5)
            shakeFor(1.1, function(p9) -- line: 175
                return 1.1 * (1 - p9 / 1.1) ^ 1.5
            end)

            for _, descendant in Seal:GetDescendants() do
                if descendant:IsA("BasePart") and descendant:GetAttribute("Collider") then
                    descendant.CanCollide = false
                end
            end

            for _, v19 in t4 do
                v19.LocalTransparencyModifier = 1
            end

            dust(Position + Vector3.new(2, 0, 0), Vector3.new(3, 15, 12), 45, 26)

            local t8 = {}

            for _, v20 in t3 do
                local partPosition = v20.part.Position
                local v24 = Vector3.new(math.random() * 26 + 10, math.random() * 18 + partPosition.Y / 17 * 14, (math.random() - 0.5) * 26)
                local v28 = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * 9

                table.insert(t8, {
                    part = v20.part,
                    cf = v20.part.CFrame,
                    v = v24,
                    spin = v28,
                    half = v20.part.Size.Y / 2
                })
            end

            local elapsed2 = os.clock()
            local connection2
            local RenderStepped = RunService.RenderStepped
            local Seal2 = Seal

            connection2 = RenderStepped:Connect(function(p10) -- line: 197
                -- upvalues: t8 (copy), elapsed2 (copy), connection2 (ref), Seal2 (copy), setGone (copy)
                local v29 = math.min(p10, 0.03333333333333333)
                local v30 = os.clock() - elapsed2
                local t10 = {}
                local t11 = {}

                for _, v31 in t8 do
                    v31.v = v31.v + Vector3.new(0, -110 * v29, 0)

                    local v33 = v31.cf + v31.v * v29

                    if v33.Position.Y < v31.half then
                        v33 += Vector3.new(0, v31.half - v33.Position.Y, 0)
                        v31.v = Vector3.new(v31.v.X * 0.55, math.abs(v31.v.Y) * 0.25, v31.v.Z * 0.55)
                        v31.spin *= 0.5
                    end

                    v31.cf = v33 * CFrame.Angles(v31.spin.X * v29, v31.spin.Y * v29, v31.spin.Z * v29)
                    table.insert(t10, v31.part)
                    table.insert(t11, v31.cf)

                    local v39 = math.clamp((v30 - 0.9900000000000001) / 1.2100000000000002, 0, 1)

                    v31.part.LocalTransparencyModifier = v39
                end

                workspace:BulkMoveTo(t10, t11, Enum.BulkMoveMode.FireCFrameChanged)

                if not (v30 >= 2.2) then
                    return
                end

                connection2:Disconnect()

                for _, v40 in t8 do
                    v40.part.LocalTransparencyModifier = 1
                end

                setGone(Seal2)
            end)
            task.delay(0.45, function() -- line: 227
                -- upvalues: UIUtil (copy), BossJuice (copy)
                BossJuice.stamp("WORLD 2 UNLOCKED!", Color3.fromRGB(120, 230, 255), 96, 0.3, 2.4)
                UIUtil.sound("LevelUp", 0.8, 0.9)
            end)
            v1 = true
            v2 = false
        else
            v1 = true

            local EventHole = workspace:FindFirstChild("EventHole")
            local Seal = EventHole and EventHole:FindFirstChild("Seal")

            if not (Seal and Seal:IsA("Model")) then
                Seal = nil
            end

            if Seal then
                setGone(Seal)
            end
        end
    end
end

function t1.reseal() -- line: 237
    -- upvalues: v1 (ref), v2 (ref), t2 (copy)
    local EventHole = workspace:FindFirstChild("EventHole")
    local Seal = EventHole and EventHole:FindFirstChild("Seal")

    if not (Seal and Seal:IsA("Model")) then
        Seal = nil
    end

    v1 = false
    v2 = false

    if Seal then
        for _, descendant in Seal:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = 0

                if t2[descendant] then
                    descendant.CFrame = t2[descendant]
                end

                if descendant:GetAttribute("Collider") then
                    descendant.CanCollide = true
                end
            end
        end
    end
end

function t1.replay() -- line: 255
    -- upvalues: t1 (copy), breakOpen (copy)
    t1.reseal()
    task.spawn(breakOpen)
end

function t1.init() -- line: 260
    -- upvalues: Remotes (copy), t1 (copy), LocalPlayer (copy), v1 (ref), v2 (ref), setGone (copy), breakOpen (copy)
    task.spawn(function() -- line: 261
        -- upvalues: LocalPlayer (copy), v1 (ref), setGone (copy)
        local v41 = workspace:WaitForChild("EventHole", 30)

        if not v41 or not v41:WaitForChild("Seal", 30) or LocalPlayer:GetAttribute("World2Unlocked") ~= true then
            return
        end

        v1 = true

        local EventHole = workspace:FindFirstChild("EventHole")
        local Seal = EventHole and EventHole:FindFirstChild("Seal")

        if not (Seal and Seal:IsA("Model")) then
            Seal = nil
        end

        if Seal then
            setGone(Seal)
        end
    end)
    LocalPlayer:GetAttributeChangedSignal("World2Unlocked"):Connect(function() -- line: 268
        -- upvalues: t1 (copy), LocalPlayer (copy), v1 (ref), v2 (ref), setGone (copy)
        task.delay(0.5, function() -- line: 271
            -- upvalues: t1 (copy), LocalPlayer (copy), v1 (ref), v2 (ref), setGone (copy)
            if LocalPlayer:GetAttribute("World2Unlocked") ~= true or v1 or v2 then
                if LocalPlayer:GetAttribute("World2Unlocked") == false and v1 then
                    t1.reseal()
                end
            else
                v1 = true

                local EventHole = workspace:FindFirstChild("EventHole")
                local Seal = EventHole and EventHole:FindFirstChild("Seal")

                if not (Seal and Seal:IsA("Model")) then
                    Seal = nil
                end

                if Seal then
                    setGone(Seal)
                end
            end
        end)
    end)
    Remotes.World2Trip.OnClientEvent:Connect(function(p11) -- line: 279
        -- upvalues: breakOpen (copy)
        if p11 == "Unlocked" then
            task.spawn(breakOpen)
        end
    end)
end

return t1
