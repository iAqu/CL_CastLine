-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Fx = require(script.Parent.Fx)
local GhostDogQuest = require(ReplicatedStorage.Data.GhostDogQuest)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local Rig = require(script.Parent.Rig)
local Speech = require(script.Parent.Speech)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local GhostDogQuest2 = ReplicatedStorage.Assets.GhostDogQuest
local t1 = {
    AgentRadius = 2.5,
    AgentHeight = 5,
    AgentCanJump = true,
    AgentCanClimb = false,
    WaypointSpacing = 6,
    Costs = {
        Water = 1e999
    }
}
local BuddyChatter2 = ReplicatedStorage.Assets.ShootingStar.Sounds.BuddyChatter2
local v1 = Trove.new()
local v2, v3, v4, v5
local v6 = false
local v7 = false
local n1 = 0
local t2 = {}

local function rootOf() -- line: 63
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end

local function makePrompt(p1, p2, p3, p4) -- line: 69
    local ProximityPrompt = Instance.new("ProximityPrompt")

    ProximityPrompt.ActionText = p2
    ProximityPrompt.ObjectText = p3
    ProximityPrompt.HoldDuration = 0
    ProximityPrompt.MaxActivationDistance = p4
    ProximityPrompt.RequiresLineOfSight = false
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
    ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
    ProximityPrompt.GamepadKeyCode = Enum.KeyCode.ButtonX
    ProximityPrompt.Parent = p1

    return ProximityPrompt
end

local function groundFilter() -- line: 88
    -- upvalues: Workspace (copy), GhostDogQuest (copy), HalloweenDimension (copy)
    local v8 = Workspace:FindFirstChild(HalloweenDimension.MapName)
    local t3 = {}

    if v8 then
        for _, v9 in { "Ground", "Paths" } do
            local v10 = v8:FindFirstChild(v9)

            if v10 then
                table.insert(t3, v10)
            end
        end

        local v11 = v8:FindFirstChild(GhostDogQuest.FolderName)
        local Dock = v11 and v11:FindFirstChild("Dock")

        if Dock then
            table.insert(t3, Dock)
        end
    end

    return t3
end

local function groundBelow(p5, p6) -- line: 107
    -- upvalues: Workspace (copy)
    local v12 = Workspace:Raycast(p5 + Vector3.new(0, 30, 0), Vector3.new(0, -90, 0), p6)

    return if v12 then v12.Position.Y else nil
end

local function headOf(p7) -- line: 112
    local Head = p7:FindFirstChild("Head")

    if Head and Head:IsA("BasePart") then
        return Head
    end

    local v13 = p7.PrimaryPart
    local n2 = (-1e999)

    for _, descendant in p7:GetDescendants() do
        if descendant:IsA("MeshPart") then
            local v14 = descendant.Position.Y + descendant.Size.Y * 0.5

            if n2 < v14 then
                n2 = v14
                v13 = descendant
            end
        end
    end

    return v13
end

local function voiceOf(p8) -- line: 131
    -- upvalues: BuddyChatter2 (copy)
    local t4 = {}
    local Barks = p8:FindFirstChild("Barks")

    if Barks then
        for _, child in Barks:GetChildren() do
            if child:IsA("Sound") then
                table.insert(t4, child)
            end
        end
    end

    if #t4 == 0 then
        table.insert(t4, BuddyChatter2)
    end

    return t4
end

local function build(p9, p10, p11, p12) -- line: 147
    -- upvalues: Workspace (copy), GhostDogQuest (copy), Rig (copy), v1 (copy), headOf (copy), voiceOf (copy)
    local clone = v1:Clone(p9)

    clone:PivotTo(p10)
    clone.Parent = Workspace

    local v15 = Rig.new(clone, p11)

    v15:SetRoot(p10)

    local v16 = headOf(clone)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "PromptPoint"
    Attachment.Position = Vector3.new(0, 3, 0)
    Attachment.Parent = clone.PrimaryPart

    local TalkDistance = GhostDogQuest.TalkDistance
    local ProximityPrompt = Instance.new("ProximityPrompt")

    ProximityPrompt.ActionText = "Talk"
    ProximityPrompt.ObjectText = p12
    ProximityPrompt.HoldDuration = 0
    ProximityPrompt.MaxActivationDistance = TalkDistance
    ProximityPrompt.RequiresLineOfSight = false
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
    ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
    ProximityPrompt.GamepadKeyCode = Enum.KeyCode.ButtonX
    ProximityPrompt.Parent = Attachment

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "QuestMarker"
    BillboardGui.Size = UDim2.fromScale(2.4, 2.4)
    BillboardGui.StudsOffset = Vector3.new(0, 3.2, 0)
    BillboardGui.AlwaysOnTop = false
    BillboardGui.LightInfluence = 0
    BillboardGui.Brightness = 1.5
    BillboardGui.MaxDistance = 220
    BillboardGui.Enabled = false
    BillboardGui.Adornee = v16

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Mark"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.fromRGB(255, 225, 90)
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 4
    UIStroke.Parent = TextLabel
    TextLabel.Parent = BillboardGui
    BillboardGui.Parent = clone

    return {
        Model = clone,
        Rig = v15,
        Head = v16,
        Prompt = ProximityPrompt,
        Home = p10,
        Voice = voiceOf(clone)
    }
end

local function holdTrack(p13) -- line: 192
    local Animations = p13.Model:FindFirstChild("Animations")
    local Hold = Animations and Animations:FindFirstChild("Hold")
    local Humanoid = p13.Model:FindFirstChildOfClass("Humanoid")
    local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

    if Hold == nil or not Hold:IsA("Animation") or Animator == nil then
        return nil
    end

    local LoadAnimation = Animator.LoadAnimation
    local ok, result = pcall(LoadAnimation, Animator, Hold)

    if not ok or result == nil then
        return nil
    end

    result.Priority = Enum.AnimationPriority.Movement
    result.Looped = true

    return result
end

local function planted(p14) -- line: 209
    -- upvalues: Workspace (copy), groundFilter (copy)
    local v17 = RaycastParams.new()

    v17.FilterType = Enum.RaycastFilterType.Include
    v17.FilterDescendantsInstances = groundFilter()

    local v18 = Workspace:Raycast(p14.Position + Vector3.new(0, 30, 0), Vector3.new(0, -90, 0), v17)
    local Y = if v18 then v18.Position.Y else nil

    if Y == nil then
        return p14
    end

    return p14.Rotation + Vector3.new(p14.X, Y, p14.Z)
end

function t2.Spawn(p15, p16, _) -- line: 220
    -- upvalues: RunService (copy), Workspace (copy), GhostDogQuest (copy), Rig (copy), Speech (copy), GhostDogQuest2 (copy), v1 (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), t2 (copy), groundFilter (copy), build (copy), holdTrack (copy)
    t2.Clear()

    local _CFrame = p15:FindFirstChild(if p16 then "DogHome" else "DogSpot").CFrame
    local _CFrame2 = p15:FindFirstChild("FishermanSpot").CFrame
    local GhostDog = GhostDogQuest2.GhostDog
    local v19 = RaycastParams.new()

    v19.FilterType = Enum.RaycastFilterType.Include
    v19.FilterDescendantsInstances = groundFilter()

    local v20 = Workspace:Raycast(_CFrame.Position + Vector3.new(0, 30, 0), Vector3.new(0, -90, 0), v19)
    local Y = if v20 then v20.Position.Y else nil

    if Y ~= nil then
        _CFrame = _CFrame.Rotation + Vector3.new(_CFrame.X, Y, _CFrame.Z)
    end

    v2 = build(GhostDog, _CFrame, Rig.Dog, GhostDogQuest.DogName)

    local GhostFisherman = GhostDogQuest2.GhostFisherman
    local v21 = RaycastParams.new()

    v21.FilterType = Enum.RaycastFilterType.Include
    v21.FilterDescendantsInstances = groundFilter()

    local v22 = Workspace:Raycast(_CFrame2.Position + Vector3.new(0, 30, 0), Vector3.new(0, -90, 0), v21)
    local Y2 = if v22 then v22.Position.Y else nil

    if Y2 ~= nil then
        _CFrame2 = _CFrame2.Rotation + Vector3.new(_CFrame2.X, Y2, _CFrame2.Z)
    end

    local v23 = build(GhostFisherman, _CFrame2, Rig.Fisherman, GhostDogQuest.FishermanName)

    v3 = v23
    v4 = holdTrack(v23)
    t2.SetRodVisible(true)
    v5 = nil
    v6 = false
    v1:Connect(RunService.RenderStepped, function(p18) -- line: 238
        -- upvalues: GhostDogQuest (copy), Speech (copy), v2 (ref), v3 (ref), v5 (ref), v6 (ref), v7 (ref)
        local v24 = if v7 or Speech.IsTalking() then 0 else GhostDogQuest.TalkDistance
        local v25 = v2

        if v25 then
            v25.Prompt.MaxActivationDistance = v24

            local v26 = v5

            if v26 and not v6 then
                local Root = v25.Rig.Root
                local v28 = Root.Rotation:Lerp(v26.Rotation, (math.min(p18 * 8, 1)))

                v25.Rig:SetRoot(CFrame.new(Root.Position) * v28)
            end

            v25.Rig:Step(p18)

            local QuestMarker = v25.Model:FindFirstChild("QuestMarker")

            if QuestMarker and QuestMarker:IsA("BillboardGui") and QuestMarker.Enabled then
                QuestMarker.StudsOffset = Vector3.new(0, math.sin(os.clock() * 4) * 0.35 + 3.2, 0)
            end
        end

        local v31 = v3

        if v31 then
            v31.Prompt.MaxActivationDistance = v24
            v31.Rig:Step(p18)
        end
    end)
end

function t2.SetQuiet(p19) -- line: 263
    -- upvalues: v7 (ref)
    v7 = p19
end

function t2.Rod() -- line: 267
    -- upvalues: v3 (ref)
    local v32 = v3
    local v33 = v32 and v32.Model:FindFirstChild("Rod")

    return if v33 and v33:IsA("Model") then v33 else nil
end

function t2.SetRodVisible(p20) -- line: 273
    -- upvalues: v4 (ref), t2 (copy)
    local v34 = t2.Rod()

    if v34 == nil then
        return
    end

    local v35 = v4

    if v35 and p20 and not v35.IsPlaying then
        v35:Play(0.2)
    elseif v35 and not p20 and v35.IsPlaying then
        v35:Stop(0.2)
    end

    for _, descendant in v34:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = p20 and 0 or 1
        elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Light") or descendant:IsA("Trail") then
            descendant.Enabled = p20
        end
    end
end

function t2.SetMarker(p21, p22) -- line: 298
    -- upvalues: Fx (copy), v2 (ref), v3 (ref)
    local v36 = if p21 == "Dog" then v2 else v3
    local v37 = v36 and v36.Model:FindFirstChild("QuestMarker")
    local Mark, v38, v39

    if v37 ~= nil then
        if v37:IsA("BillboardGui") then
            Mark = v37:FindFirstChild("Mark")
            v38 = p22 ~= nil
            v39 = false
        else
            v39 = true
        end
    else
        v39 = true
    end

    if v39 then
        return
    end

    if v38 and (not v37.Enabled or Mark.Text ~= p22) then
        Mark.Text = p22
        v37.Enabled = true

        local v40 = Mark:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")

        v40.Parent = Mark
        Fx.Punch(v40, 1.6, 0.35)
    elseif not v38 then
        v37.Enabled = false
    end
end

function t2.Clear() -- line: 317
    -- upvalues: v1 (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref)
    v1:Clean()
    v2 = nil
    v3 = nil
    v4 = nil
    v5 = nil
    v6 = false
end

function t2.Dog() -- line: 326
    -- upvalues: v2 (ref)
    return v2
end

function t2.Fisherman() -- line: 330
    -- upvalues: v3 (ref)
    return v3
end

function t2.FacePlayer(p23) -- line: 334
    -- upvalues: Fx (copy), LocalPlayer (copy), v2 (ref), v5 (ref)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        HumanoidRootPart = nil
    end

    if HumanoidRootPart == nil then
        return
    end

    local RootPosition = p23.Rig.Root.Position
    local v41 = Vector3.new(HumanoidRootPart.Position.X, RootPosition.Y, HumanoidRootPart.Position.Z)

    if not ((v41 - RootPosition).Magnitude < 0.5) then
        if p23 == v2 then
            v5 = CFrame.lookAt(RootPosition, v41)
        else
            local Root = p23.Rig.Root
            local v42 = CFrame.lookAt(RootPosition, v41)

            task.spawn(function() -- line: 349
                -- upvalues: p23 (copy), Root (copy), v42 (copy), Fx (copy)
                local elapsed = os.clock()

                while os.clock() - elapsed < 0.35 do
                    local v43 = Fx.Ease((os.clock() - elapsed) / 0.35)

                    p23.Rig:SetRoot(Root:Lerp(v42, v43))
                    task.wait()
                end

                p23.Rig:SetRoot(v42)
            end)
        end
    end
end

function t2.SetDogMood(p24) -- line: 361
    -- upvalues: v2 (ref)
    if v2 then
        v2.Rig:SetMood(p24)
    end
end

function t2.SetFishermanMood(p25) -- line: 367
    -- upvalues: v3 (ref)
    if v3 then
        v3.Rig:SetMood(p25)
    end
end

local function yawOf(p26) -- line: 373
    return (math.atan2(-p26.X, -p26.Z))
end

local function barkEcho() -- line: 377
    local ReverbSoundEffect = Instance.new("ReverbSoundEffect")

    ReverbSoundEffect.DecayTime = 1.1
    ReverbSoundEffect.Density = 0.8
    ReverbSoundEffect.Diffusion = 0.9
    ReverbSoundEffect.DryLevel = 0
    ReverbSoundEffect.WetLevel = -9

    return { ReverbSoundEffect }
end

local function bark(p27) -- line: 387
    -- upvalues: Fx (copy), n1 (ref)
    local Voice = p27.Voice

    if #Voice == 0 then
        return
    end

    local v46 = math.random(1, #Voice)

    if #Voice > 1 and v46 == n1 then
        v46 = v46 % #Voice + 1
    end

    n1 = v46

    local PlayAt = Fx.PlayAt
    local v47 = Voice[v46]
    local Head = p27.Head
    local t5 = {
        Volume = 1,
        MaxDistance = 160,
        Looped = false,
        PlaybackSpeed = 1.08 + math.random() * 0.06
    }
    local ReverbSoundEffect = Instance.new("ReverbSoundEffect")

    ReverbSoundEffect.DecayTime = 1.1
    ReverbSoundEffect.Density = 0.8
    ReverbSoundEffect.Diffusion = 0.9
    ReverbSoundEffect.DryLevel = 0
    ReverbSoundEffect.WetLevel = -9
    t5.Effects = { ReverbSoundEffect }

    local v48 = PlayAt(v47, Head, t5)

    if v48 then
        v48.RollOffMode = Enum.RollOffMode.Inverse
        v48.RollOffMinDistance = 30
    end
end

local function turnToward(p28, p29, p30) -- line: 410
    return p28 + ((p29 - p28 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.min(p30, 1)
end

local function pathLeg(p31, p32) -- line: 415
    -- upvalues: PathfindingService (copy), t1 (copy)
    local v49 = PathfindingService:CreatePath(t1)

    local function v50() -- line: 417
        -- upvalues: p31 (copy), p32 (copy), v49 (copy)
        v49:ComputeAsync(p31, p32)
    end

    if not pcall(v50) or v49.Status ~= Enum.PathStatus.Success then
        return { p32 }
    end

    local t6 = {}

    for _, v51 in v49:GetWaypoints() do
        table.insert(t6, v51.Position)
    end

    if #t6 == 0 then
        return { p32 }
    end

    table.remove(t6, 1)

    if #t6 == 0 or (t6[#t6] - p32).Magnitude > 4 then
        table.insert(t6, p32)
    end

    return t6
end

local function pathRoute(p33, p34) -- line: 437
    -- upvalues: pathLeg (copy)
    local t7 = {}
    local v52 = p33

    for _, v53 in p34 do
        for _, v54 in pathLeg(v52, v53) do
            table.insert(t7, v54)
        end

        v52 = v53
    end

    return t7
end

function t2.Lead(p35, p36, p37) -- line: 449
    -- upvalues: Workspace (copy), Fx (copy), LocalPlayer (copy), v2 (ref), v5 (ref), v6 (ref), t2 (copy), groundFilter (copy), bark (copy), pathRoute (copy)
    local v55 = v2

    if v55 ~= nil then
        v6 = true
        v5 = nil

        local v56 = RaycastParams.new()

        v56.FilterType = Enum.RaycastFilterType.Include
        v56.FilterDescendantsInstances = groundFilter()

        local v57 = Workspace:Raycast(p36.Position + Vector3.new(0, 30, 0), Vector3.new(0, -90, 0), v56)
        local Y = if v57 then v57.Position.Y else nil
        local v58 = if Y == nil then p36 else p36.Rotation + Vector3.new(p36.X, Y, p36.Z)
        local v59 = RaycastParams.new()

        v59.FilterType = Enum.RaycastFilterType.Include
        v59.FilterDescendantsInstances = groundFilter()

        local RootPosition, LookVector = v55.Rig.Root.Position, v55.Rig.Root.LookVector
        local v62 = math.atan2(-LookVector.X, -LookVector.Z)
        local v63 = ""

        local function setMood(p38) -- line: 466
            -- upvalues: v55 (copy), v63 (ref)
            if v63 ~= p38 then
                v63 = p38
                v55.Rig:SetMood(p38)
            end
        end

        local v64 = pathRoute(RootPosition, p35)
        local n3 = 0
        local v65 = false
        local n4 = (-1e999)
        local n5 = 1

        while true do
            if n5 <= #v64 then
                local v66, v67, v68, v69

                if p37() then
                    v69 = true
                elseif v2 == v55 then
                    v66 = math.min(task.wait(), 0.1)

                    local v71 = v64[n5]

                    v67 = Vector3.new(v71.X - RootPosition.X, 0, v71.Z - RootPosition.Z)
                    v68 = n5 == #v64
                    v69 = false
                else
                    v69 = true
                end

                if v69 then
                    break
                end

                if v67.Magnitude < (if v68 then 1.5 else 2.5) then
                    n5 += 1
                else
                    local Character = LocalPlayer.Character
                    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                    local HumanoidRootPart2 = if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then nil else HumanoidRootPart
                    local v74 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    local v75 = if v74 then v74.WalkSpeed else 16
                    local v76 = if HumanoidRootPart2 then Vector3.new(HumanoidRootPart2.Position.X - RootPosition.X, 0, HumanoidRootPart2.Position.Z - RootPosition.Z).Magnitude else 0

                    if v65 and v76 <= 54 then
                        v65 = false
                        t2.SetMarker("Dog", nil)
                    elseif not v65 and v76 >= 96 then
                        t2.SetMarker("Dog", "!")
                        n4 = os.clock()
                        v65 = true
                        bark(v55)
                    end

                    local v80 = math.clamp(v75 * (if v76 < 54 then 1 else 0.55), 16, 90)

                    if v68 then
                        v80 = math.min(v80, (math.max(v67.Magnitude * 3, 8)))
                    end

                    if v65 then
                        v80 = 0
                    end

                    local v83 = if n3 < v80 then 70 else 120

                    n3 += math.clamp(v80 - n3, -v83 * v66, v83 * v66)

                    local Unit = v67.Unit

                    if v65 and HumanoidRootPart2 then
                        local v89 = Vector3.new(HumanoidRootPart2.Position.X - RootPosition.X, 0, HumanoidRootPart2.Position.Z - RootPosition.Z)

                        if v89.Magnitude > 1 then
                            Unit = v89.Unit
                        end
                    end

                    local v92 = math.atan2(-Unit.X, -Unit.Z)
                    local v93 = v66 * 8

                    v62 += ((v92 - v62 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.min(v93, 1)

                    local v95 = RootPosition + v67.Unit * math.min(n3 * v66, v67.Magnitude)
                    local v96 = Workspace:Raycast(v95 + Vector3.new(0, 30, 0), Vector3.new(0, -90, 0), v59)
                    local v97 = (if v96 then v96.Position.Y else nil) or RootPosition.Y

                    RootPosition = Vector3.new(v95.X, RootPosition.Y + (v97 - RootPosition.Y) * math.min(v66 * 12, 1), v95.Z)

                    local v101 = if n3 > 6 then "Run" elseif v65 then "Happy" else "Idle"

                    if v63 ~= v101 then
                        v63 = v101
                        v55.Rig:SetMood(v101)
                    end

                    v55.Rig:SetPace(n3)

                    local v102 = (os.clock() - n4) / 0.3
                    local v103 = if v102 < 1 then math.sin(v102 * 3.141592653589793) * 0.8 else 0

                    v55.Rig:SetRoot(CFrame.new(RootPosition + Vector3.new(0, v103, 0)) * CFrame.Angles(0, v62, 0))
                end

                continue
            end

            t2.SetMarker("Dog", nil)

            local Root = v55.Rig.Root

            if v63 ~= "Happy" then
                v63 = "Happy"
                v55.Rig:SetMood("Happy")
            end

            local elapsed = os.clock()

            while os.clock() - elapsed < 0.7 do
                local v105 = (os.clock() - elapsed) / 0.7
                local v108 = math.abs((math.sin(v105 * 3.141592653589793 * 2))) * 1.4 * (1 - v105)

                v55.Rig:SetRoot(Root:Lerp(v58, Fx.Ease(v105)) + Vector3.new(0, v108, 0))
                task.wait()
            end

            v55.Rig:SetRoot(v58)
            v55.Home = v58
            v5 = nil
            v6 = false

            return true
        end

        v6 = false
    end

    return false
end

return table.freeze(t2)
