-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Fx = require(script.Parent.Fx)
local GhostDogQuest = require(ReplicatedStorage.Data.GhostDogQuest)
local Memories = require(script.Parent.Memories)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Trove = require(ReplicatedStorage.Packages.Trove)
local GhostDogQuest2 = ReplicatedStorage.Assets.GhostDogQuest
local CollectFirefly = ReplicatedStorage.Assets.Sounds.BeanstalkEvent.CollectFirefly
local v1 = Color3.fromRGB(255, 85, 85)
local v2 = Color3.fromRGB(150, 225, 255)
local t1 = {}
local v3 = false
local t2 = {}
local t3 = {}

local function pillar(p1, p2) -- line: 43
    -- upvalues: Fx (copy)
    local v4 = p1:Add(Instance.new("Part"))

    v4.Name = "GhostDogPillar"
    v4.Anchored = true
    v4.CanCollide = false
    v4.CanQuery = false
    v4.CanTouch = false
    v4.Transparency = 1
    v4.Size = Vector3.new(1, 1, 1)
    v4.CFrame = CFrame.new(p2)

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = v4

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = Fx.Sparkle
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(190, 245, 255))
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Rate = 6
    ParticleEmitter.Lifetime = NumberRange.new(1.5, 2.5)
    ParticleEmitter.Speed = NumberRange.new(4, 8)
    ParticleEmitter.SpreadAngle = Vector2.new(12, 12)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Size = NumberSequence.new(0.5, 0)
    ParticleEmitter.Parent = Attachment

    local PointLight = Instance.new("PointLight")

    PointLight.Color = Color3.fromRGB(150, 235, 255)
    PointLight.Range = 14
    PointLight.Brightness = 1.2
    PointLight.Parent = v4
    v4.Parent = workspace

    return v4
end

local function take(p3) -- line: 75
    -- upvalues: Fx (copy), GhostDogQuest (copy), Memories (copy), Remotes (copy), Toast (copy), CollectFirefly (copy), v1 (copy), v2 (copy), t1 (copy), v3 (ref), t2 (copy)
    if p3.Taken or v3 then
        return
    end

    v3 = true

    local function v5() -- line: 80
        -- upvalues: p3 (copy), Remotes (copy)
        return Remotes.GhostDogQuest.Collect:InvokeServer(p3.Artifact.Id)
    end

    local v6, v7, v8 = pcall(v5)

    v3 = false

    if not v6 or v7 ~= true then
        if v6 and typeof(v8) == "string" then
            Toast.Show({
                Seconds = 2.5,
                Text = v8,
                Color = v1
            })
        end
    else
        p3.Taken = true
        t2[p3.Artifact.Id] = true
        p3.Prompt.Enabled = false

        local Model = p3.Model
        local Pivot = Model:GetPivot()

        Fx.Play(CollectFirefly, {
            Volume = 0.7
        })
        Fx.Burst(Pivot.Position, Color3.fromRGB(190, 245, 255), 28, 18, 0.9)
        Fx.Ring(CFrame.new(Pivot.Position - Vector3.new(0, 2.9, 0)), Color3.fromRGB(150, 235, 255), 2, 18, 0.6)

        local elapsed = os.clock()

        while os.clock() - elapsed < 0.45 do
            local v9 = (os.clock() - elapsed) / 0.45
            local v10 = Fx.Ease(v9, Enum.EasingStyle.Back, Enum.EasingDirection.Out) * 4

            Model:PivotTo(CFrame.new(Pivot.Position + Vector3.new(0, v10, 0)) * CFrame.Angles(0, v9 * 12, 0))
            Model:ScaleTo((math.max(math.sin(v9 * 3.141592653589793) * 0.6 + 1 - v9 * 0.9, 0.05)))
            task.wait()
        end

        p3.Trove:Destroy()
        t1[p3.Artifact.Id] = nil
        Toast.Show({
            Seconds = 3,
            Text = ("%*: \"%*\""):format(GhostDogQuest.DogName, p3.Artifact.Found),
            Color = v2
        })
        Memories.Celebrate(p3.Artifact.Id)
    end
end

local function spawnPickup(p4, p5) -- line: 124
    -- upvalues: Players (copy), RunService (copy), GhostDogQuest (copy), Trove (copy), GhostDogQuest2 (copy), t1 (copy), pillar (copy), take (copy)
    local v13 = GhostDogQuest2.Artifacts:FindFirstChild(p4.Model)

    if v13 ~= nil and v13:IsA("Model") then
        local v14 = Trove.new()
        local clone = v14:Clone(v13)

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.CanQuery = false
            end
        end

        clone.WorldPivot = clone:GetBoundingBox()
        clone:ScaleTo(1.4)

        local v15 = CFrame.new(p5.Position + Vector3.new(0, 3.2, 0))

        clone:PivotTo(v15)

        local Highlight = Instance.new("Highlight")

        Highlight.FillColor = Color3.fromRGB(150, 235, 255)
        Highlight.FillTransparency = 1
        Highlight.OutlineColor = Color3.fromRGB(200, 250, 255)
        Highlight.OutlineTransparency = 1
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.Parent = clone
        clone.Parent = workspace

        local v16 = pillar(v14, p5.Position + Vector3.new(0, 0.2, 0))
        local ProximityPrompt = Instance.new("ProximityPrompt")

        ProximityPrompt.ActionText = "Pick up"
        ProximityPrompt.ObjectText = p4.DisplayName
        ProximityPrompt.HoldDuration = 0.2
        ProximityPrompt.MaxActivationDistance = GhostDogQuest.PickupDistance
        ProximityPrompt.RequiresLineOfSight = false
        ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
        ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
        ProximityPrompt.GamepadKeyCode = Enum.KeyCode.ButtonX
        ProximityPrompt.Parent = v16

        local t4 = {
            Taken = false,
            Artifact = p4,
            Model = clone,
            Base = v15,
            Prompt = ProximityPrompt,
            Trove = v14
        }

        v14:Connect(ProximityPrompt.Triggered, function() -- line: 171
            -- upvalues: t4 (copy), take (copy)
            task.spawn(take, t4)
        end)

        local v17 = math.random() * 6
        local n1 = 0

        v14:Connect(RunService.RenderStepped, function(p6) -- line: 176
            -- upvalues: clone (copy), v15 (copy), Highlight (copy), t4 (copy), v17 (copy), n1 (ref), Players (copy)
            if t4.Taken then
                return
            end

            local v18 = os.clock() + v17

            clone:PivotTo(v15 * CFrame.new(0, math.sin(v18 * 2) * 0.5, 0) * CFrame.Angles(0, v18 * 1.2, math.sin(v18 * 1.5) * 0.15))

            local Character = Players.LocalPlayer.Character
            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
            local v23 = if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") and (HumanoidRootPart.Position - v15.Position).Magnitude <= 10 then 1 else 0

            if n1 == v23 then
                return
            end

            local v24 = p6 / 0.3

            n1 = if n1 < v23 then math.min(n1 + v24, v23) else math.max(n1 - v24, v23)
            Highlight.FillTransparency = n1 * -0.25 + 1
            Highlight.OutlineTransparency = n1 * -0.9 + 1
        end)
        t1[p4.Id] = t4
    end
end

function t3.Sync(p7, p8, p9) -- line: 204
    -- upvalues: GhostDogQuest (copy), t1 (copy), t2 (copy), spawnPickup (copy)
    for v27, v28 in t1 do
        if not (p9 and p7 ~= nil and p8 ~= nil and p8[v27] ~= true) and not v28.Taken then
            v28.Trove:Destroy()
            t1[v27] = nil
        end
    end

    if p9 and p7 ~= nil and p8 ~= nil then
        for _, v29 in GhostDogQuest.Artifacts do
            if p8[v29.Id] then
                t2[v29.Id] = nil
            end

            if not p8[v29.Id] and not t1[v29.Id] and not t2[v29.Id] then
                local v30 = p7:FindFirstChild(v29.Marker)

                if v30 and v30:IsA("BasePart") then
                    spawnPickup(v29, v30)
                end
            end
        end
    end
end

function t3.Clear() -- line: 229
    -- upvalues: t1 (copy)
    for v31, v32 in t1 do
        v32.Trove:Destroy()
        t1[v31] = nil
    end
end

return table.freeze(t3)
