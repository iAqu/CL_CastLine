-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Fx = require(script.Parent.Fx)
local GhostDogQuest = require(ReplicatedStorage.Data.GhostDogQuest)
local Npcs = require(script.Parent.Npcs)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local Sounds = ReplicatedStorage.Assets.Sounds
local Swoosh, Pop = Sounds.ScrambleBoss.Swoosh, Sounds.ScrambleBoss.Pop
local CollectSecretRing = Sounds.LightVsDarknessSounds.CollectSecretRing
local v1 = Color3.fromRGB(120, 255, 175)
local v2 = false
local t1 = {}

local function playerRod(p1) -- line: 34
    -- upvalues: GhostDogQuest (copy), LocalPlayer (copy)
    for _, v3 in {
            p1,
            LocalPlayer:FindFirstChildOfClass("Backpack")
        } do
        if v3 ~= nil then
            for _, child in v3:GetChildren() do
                if child:IsA("Tool") and child:GetAttribute(GhostDogQuest.RodAttribute) == true then
                    return child
                end
            end
        end
    end

    return nil
end

local function setLocalAlpha(p2, p3) -- line: 49
    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = p3
        end
    end
end

local function isEffect(p4) -- line: 57
    return p4:IsA("ParticleEmitter") or p4:IsA("Beam") or p4:IsA("Light") or p4:IsA("Trail")
end

local function heldGrip(p5) -- line: 64
    local Grip = p5.Model:GetAttribute("Grip")

    if typeof(Grip) == "CFrame" then
        return Grip
    end

    local RightHand = p5.Model:FindFirstChild("RightHand")
    local RightGrip = RightHand and RightHand:FindFirstChild("RightGrip")

    if RightGrip and RightGrip:IsA("Motor6D") then
        return RightGrip.C1
    end

    return CFrame.identity
end

local function gripFrame(p6, p7) -- line: 77
    local v4 = p6:FindFirstChild("RightHand") or p6:FindFirstChild("Right Arm")

    if v4 ~= nil and v4:IsA("BasePart") then
        local RightGripAttachment = v4:FindFirstChild("RightGripAttachment")
        local v5 = if RightGripAttachment and RightGripAttachment:IsA("Attachment") then RightGripAttachment.CFrame else CFrame.new(0, -v4.Size.Y * 0.5, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)

        return v4.CFrame * v5 * p7:Inverse()
    end

    return nil
end

local function landingGrip(p8, p9) -- line: 89
    -- upvalues: playerRod (copy)
    local v6 = playerRod(p8)

    if v6 then
        return v6.Grip
    end

    return p9
end

function t1.HasRod() -- line: 94
    -- upvalues: LocalPlayer (copy), playerRod (copy)
    return playerRod(LocalPlayer.Character) ~= nil
end

function t1.IsRunning() -- line: 98
    -- upvalues: v2 (ref)
    return v2
end

function t1.Play(p10) -- line: 102
    -- upvalues: Workspace (copy), Fx (copy), GhostDogQuest (copy), Npcs (copy), Remotes (copy), Toast (copy), Trove (copy), LocalPlayer (copy), Swoosh (copy), Pop (copy), CollectSecretRing (copy), v1 (copy), v2 (ref), playerRod (copy), setLocalAlpha (copy), heldGrip (copy), gripFrame (copy)
    if v2 then
        return false
    end

    local Character = LocalPlayer.Character
    local v7 = Npcs.Rod()
    local v8 = v7 and v7.PrimaryPart

    if Character ~= nil and v7 ~= nil and v8 ~= nil then
        v2 = true

        local v9 = heldGrip(p10)
        local t2 = {}

        local function conceal(p11) -- line: 115
            -- upvalues: t2 (copy)
            for _, descendant in p11:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.LocalTransparencyModifier = 1
                elseif (descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Light") or descendant:IsA("Trail")) and t2[descendant] == nil then
                    t2[descendant] = descendant.Enabled
                    descendant.Enabled = false
                end
            end
        end

        local function reveal(p12) -- line: 126
            -- upvalues: t2 (copy), setLocalAlpha (copy)
            if p12 then
                setLocalAlpha(p12, 0)
            end

            for v10, v11 in t2 do
                if v10.Parent then
                    v10.Enabled = v11
                end
            end

            table.clear(t2)
        end

        local v12 = Trove.new()

        local function hideArrival(p13) -- line: 139
            -- upvalues: conceal (copy), GhostDogQuest (copy)
            if p13:IsA("Tool") and p13:GetAttribute(GhostDogQuest.RodAttribute) == true then
                conceal(p13)
            end
        end

        for _, v13 in {
                Character,
                LocalPlayer:FindFirstChildOfClass("Backpack")
            } do
            if v13 ~= nil then
                v12:Connect(v13.ChildAdded, hideArrival)

                for _, child in v13:GetChildren() do
                    if child:IsA("Tool") and child:GetAttribute(GhostDogQuest.RodAttribute) == true then
                        conceal(child)
                    end
                end
            end
        end

        local v14

        task.spawn(function() -- line: 155
            -- upvalues: v14 (ref), Remotes (copy)
            local function v15() -- line: 156
                -- upvalues: Remotes (copy)
                return Remotes.GhostDogQuest.Talk:InvokeServer("Rod")
            end

            local ok, result = pcall(v15)

            v14 = ok and result == "RodGiven"
        end)
        p10.Rig:Play("Point", 0.2, 1.1)
        task.wait(0.45)

        local clone = v7:Clone()

        clone.Name = "GhostDogRodHandoff"

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.LocalTransparencyModifier = 0
            elseif descendant:IsA("JointInstance") or descendant:IsA("WeldConstraint") then
                descendant:Destroy()
            end
        end

        local PrimaryPart = clone.PrimaryPart
        local t3 = {}

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") then
                t3[descendant] = PrimaryPart.CFrame:ToObjectSpace(descendant.CFrame)
            end
        end

        local function place(p14) -- line: 180
            -- upvalues: t3 (copy)
            for v16, v17 in t3 do
                v16.CFrame = p14 * v17
            end
        end

        local LeftHand = p10.Model:FindFirstChild("LeftHand")
        local v18 = if not (LeftHand and LeftHand:IsA("BasePart")) then v8.Position + p10.Rig.Root.CFrame.RightVector * -2.5 else LeftHand.Position + Vector3.new(0, 0.6, 0)
        local v19 = CFrame.new(v18) * v8.CFrame.Rotation

        for v20, v21 in t3 do
            v20.CFrame = v19 * v21
        end

        setLocalAlpha(clone, 1)
        clone.Parent = Workspace
        Fx.Play(Pop, {
            Volume = 0.5,
            PlaybackSpeed = 0.8
        })
        Fx.Burst(v18, v1, 18, 6, 0.5)

        local elapsed = os.clock()

        while os.clock() - elapsed < 0.35 do
            local v22 = (os.clock() - elapsed) / 0.35

            setLocalAlpha(clone, 1 - Fx.Ease(v22))

            local v23 = v19 * CFrame.new(0, v22 * 0.8, 0) * CFrame.Angles(0, v22 * 3.141592653589793, 0)

            for v24, v25 in t3 do
                v24.CFrame = v23 * v25
            end

            task.wait()
        end

        setLocalAlpha(clone, 0)

        local v26 = v19 * CFrame.new(0, 0.8, 0) * CFrame.Angles(0, 3.141592653589793, 0)

        for v27, v28 in t3 do
            v27.CFrame = v26 * v28
        end

        Fx.Play(Swoosh, {
            Volume = 0.6,
            PlaybackSpeed = 1.15
        })

        local Attachment = Instance.new("Attachment")

        Attachment.Parent = PrimaryPart

        local ParticleEmitter = Instance.new("ParticleEmitter")

        ParticleEmitter.Texture = Fx.Sparkle
        ParticleEmitter.Color = ColorSequence.new(v1)
        ParticleEmitter.LightEmission = 1
        ParticleEmitter.Size = NumberSequence.new(0.5, 0)
        ParticleEmitter.Lifetime = NumberRange.new(0.3, 0.6)
        ParticleEmitter.Speed = NumberRange.new(0.5, 2)
        ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
        ParticleEmitter.Rate = 60
        ParticleEmitter.Parent = Attachment

        local elapsed2 = os.clock()

        while true do
            local v30 = math.min((os.clock() - elapsed2) / 0.9, 1)
            local v31 = Fx.Ease(v30, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local v32 = playerRod(Character)
            local v34 = gripFrame(Character, if v32 then v32.Grip else v9) or v26
            local v36 = math.sin(v30 * 3.141592653589793) * 3.5
            local v37 = v26.Position:Lerp(v34.Position, v31) + Vector3.new(0, v36, 0)
            local v38 = v26.Rotation:Lerp(v34.Rotation, v31) * CFrame.Angles(0, (1 - v31) * 3.141592653589793 * 2, 0)
            local v39 = CFrame.new(v37) * v38

            for v40, v41 in t3 do
                v40.CFrame = v39 * v41
            end

            local v42 = playerRod(Character)

            if v42 and v42.Parent == Character then
                conceal(v42)
            end

            if v30 >= 1 then
                break
            end

            task.wait()
        end

        local elapsed3 = os.clock()

        while os.clock() - elapsed3 < 2.5 do
            local v43 = playerRod(Character)

            if v14 == false or v43 and v43.Parent == Character then
                break
            end

            local v44 = playerRod(Character)
            local v46 = gripFrame(Character, if v44 then v44.Grip else v9)

            if v46 then
                for v47, v48 in t3 do
                    v47.CFrame = v46 * v48
                end
            end

            task.wait()
        end

        local v49 = playerRod(Character)

        v12:Destroy()

        if v49 then
            setLocalAlpha(v49, 0)
        end

        for v50, v51 in t2 do
            if v50.Parent then
                v50.Enabled = v51
            end
        end

        table.clear(t2)

        local PrimaryPartPosition = PrimaryPart.Position

        clone:Destroy()
        v2 = false

        if v14 == false or v49 == nil then
            return false
        end

        Fx.Play(Pop, {
            Volume = 0.8,
            PlaybackSpeed = 1.2
        })
        Fx.Play(CollectSecretRing, {
            Volume = 0.6
        })
        Fx.Burst(PrimaryPartPosition, v1, 22, 10, 0.6)
        Toast.Show({
            Seconds = 3,
            Text = ("You got the %*!"):format(GhostDogQuest.RodName),
            Color = v1
        })

        return true
    end

    return false
end

return table.freeze(t1)
