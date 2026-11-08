-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local BalanceConfig = require(ReplicatedStorage.Shared.Flags.BalanceConfig)
local LimitedEgg = require(ReplicatedStorage.Data.LimitedEgg)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = CFrame.lookAlong(Vector3.new(540, 67.58, -403.45), (Vector3.new(-0.6805, 0, 0.7328)))
local t1 = {
    "Assets",
    "Models",
    "Eggs",
    "Halloween Egg"
}
local t2 = {
    {
        part = "RightUpperArm",
        joint = "RightShoulder",
        pose = CFrame.Angles(0, 0, 0.20943951023931956) * CFrame.Angles(2.9321531433504737, 0, 0)
    },
    {
        part = "LeftUpperArm",
        joint = "LeftShoulder",
        pose = CFrame.Angles(0, 0, -0.20943951023931956) * CFrame.Angles(2.9321531433504737, 0, 0)
    },
    {
        part = "RightLowerArm",
        joint = "RightElbow",
        pose = CFrame.Angles(0.17453292519943295, 0, 0)
    },
    {
        part = "LeftLowerArm",
        joint = "LeftElbow",
        pose = CFrame.Angles(0.17453292519943295, 0, 0)
    },
    {
        part = "RightHand",
        joint = "RightWrist",
        pose = CFrame.identity
    },
    {
        part = "LeftHand",
        joint = "LeftWrist",
        pose = CFrame.identity
    }
}
local LocalPlayer = Players.LocalPlayer
local v2 = false
local n1 = 0
local v3
local t3 = {}
local t4 = {}

local function onSale() -- line: 66
    -- upvalues: LimitedEgg (copy)
    local function v4() -- line: 67
        -- upvalues: LimitedEgg (copy)
        return LimitedEgg.IsOnSale(LimitedEgg.Halloween)
    end

    local ok, result = pcall(v4)

    return ok and result == true
end

local function eggTemplate() -- line: 73
    -- upvalues: ReplicatedStorage (copy), t1 (copy)
    local v5 = ReplicatedStorage

    for _, v6 in t1 do
        v5 = v5 and v5:FindFirstChild(v6)
    end

    return if v5 and v5:IsA("Model") then v5 else nil
end

local function starHandler() -- line: 81
    -- upvalues: CollectionService (copy), Workspace (copy)
    for _, v7 in CollectionService:GetTagged("StarHandlerNpc") do
        if v7:IsA("Model") and v7:IsDescendantOf(Workspace) then
            return v7
        end
    end

    return nil
end

local function ring() -- line: 90
    -- upvalues: CollectionService (copy), Workspace (copy)
    for _, v8 in CollectionService:GetTagged("StarHandlerProp") do
        if v8:IsA("BasePart") and v8:IsDescendantOf(Workspace) then
            return v8
        end
    end

    return nil
end

local function spot(p1) -- line: 99
    -- upvalues: CollectionService (copy), Players (copy), Workspace (copy), v1 (copy), starHandler (copy), ring (copy)
    local v9 = starHandler()
    local v10 = v1

    if v9 then
        local Pivot = v9:GetPivot()
        local v11 = Pivot.LookVector * Vector3.new(1, 0, 1)

        v10 = if v11.Magnitude > 0.01 then CFrame.lookAlong(Pivot.Position, v11.Unit) else CFrame.new(Pivot.Position) * v1.Rotation
    end

    local v12 = ring()

    if v12 then
        v10 = CFrame.new(v12.Position.X, v10.Position.Y, v12.Position.Z) * v10.Rotation
    end

    local t5 = {
        p1
    }

    for _, v13 in { "StarHandlerNpc", "StarHandlerProp" } do
        for _, v14 in CollectionService:GetTagged(v13) do
            table.insert(t5, v14)
        end
    end

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t5, player.Character)
        end
    end

    local v15 = RaycastParams.new()

    v15.FilterType = Enum.RaycastFilterType.Exclude
    v15.FilterDescendantsInstances = t5

    local v16 = Workspace:Raycast(v10.Position + Vector3.new(0, 10, 0), Vector3.new(0, -60, 0), v15)
    local Y = if v16 then v16.Position.Y else v1.Position.Y

    return CFrame.new(v10.Position.X, Y, v10.Position.Z) * v10.Rotation
end

local function description(p2) -- line: 133
    local v17 = (p2.Character or p2.CharacterAdded:Wait()):WaitForChild("Humanoid", 10)

    if v17 == nil or not v17:IsA("Humanoid") then
        return nil
    end

    local function v18() -- line: 139
        -- upvalues: v17 (copy)
        return v17:GetAppliedDescription()
    end

    local ok, result = pcall(v18)

    return if ok and result then result else nil
end

local function rigFor(p3) -- line: 148
    -- upvalues: Players (copy)
    local function v19() -- line: 149
        -- upvalues: p3 (copy), Players (copy)
        return Players:CreateHumanoidModelFromDescriptionAsync(p3, Enum.HumanoidRigType.R15)
    end

    local ok, result = pcall(v19)

    return if ok and result ~= nil then result else nil
end

local function freeze(p4) -- line: 158
    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.Massless = true
            descendant:GetPropertyChangedSignal("CanCollide"):Connect(function() -- line: 166
                -- upvalues: descendant (copy)
                if descendant.CanCollide then
                    descendant.CanCollide = false
                end
            end)
        elseif descendant:IsA("Script") or descendant:IsA("LocalScript") then
            descendant:Destroy()
        end
    end
end

local function settle(p5, p6) -- line: 177
    local t6 = {
        [p6] = p6.CFrame
    }
    local t7 = {}

    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("JointInstance") and descendant.Part0 and descendant.Part1 and descendant.Name ~= "EggGrip" then
            table.insert(t7, descendant)
        end
    end

    local v20 = true

    while v20 do
        v20 = false

        for _, v21 in t7 do
            local Part0, Part1 = v21.Part0, v21.Part1
            local v22 = if v21:IsA("Motor6D") then v21.Transform else CFrame.identity
            local v23 = t6[Part0]
            local v24 = t6[Part1]

            if v23 then
                if not v24 then
                    v20 = true
                    t6[Part1] = v23 * v21.C0 * v22 * v21.C1:Inverse()
                end
            elseif v24 then
                v20 = true
                t6[Part0] = v24 * v21.C1 * v22:Inverse() * v21.C0:Inverse()
            end
        end
    end

    return t6
end

local function raise(p7) -- line: 206
    -- upvalues: t2 (copy)
    for _, v25 in t2 do
        local v26 = p7:FindFirstChild(v25.part)
        local v27 = v26 and v26:FindFirstChild(v25.joint)

        if v27 and v27:IsA("Motor6D") then
            v27.Transform = v25.pose
        end
    end
end

local function idleAnimation(p8) -- line: 216
    local Animate = p8:FindFirstChild("Animate")
    local idle = Animate and Animate:FindFirstChild("idle")
    local AnimationId

    if idle then
        local n2 = (-1e999)
        local AnimationId2

        for _, child in idle:GetChildren() do
            if child:IsA("Animation") and child.AnimationId ~= "" then
                local Weight = child:FindFirstChild("Weight")
                local v28 = if Weight and Weight:IsA("NumberValue") then Weight.Value else 1

                if n2 < v28 then
                    n2 = v28
                    AnimationId2 = child.AnimationId
                end
            end

            AnimationId = AnimationId2
        end
    end

    return AnimationId or "rbxassetid://507766388"
end

local function playIdle(p9, p10) -- line: 236
    -- upvalues: playIdle (copy)
    local Animator = p9:FindFirstChildOfClass("Animator")
    local Animator2 = Animator

    if Animator == nil then
        local Animator = Instance.new("Animator")

        Animator.Parent = p9
        Animator2 = Animator
    end

    local Animation = Instance.new("Animation")

    Animation.AnimationId = p10

    local function v29() -- line: 245
        -- upvalues: Animator2 (ref), Animation (copy)
        return Animator2:LoadAnimation(Animation)
    end

    local ok, result = pcall(v29)

    if ok and result ~= nil then
        result.Priority = Enum.AnimationPriority.Idle
        result.Looped = true
        result:Play()
    elseif p10 ~= "rbxassetid://507766388" then
        playIdle(p9, "rbxassetid://507766388")
    end
end

local function clasp(p11, p12, p13, p14) -- line: 259
    local UpperTorso = p11:FindFirstChild("UpperTorso")

    if not (UpperTorso and UpperTorso:IsA("BasePart") and p14[UpperTorso]) then
        UpperTorso = p13
    end

    local v30 = p14[UpperTorso] or UpperTorso.CFrame

    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("BasePart") then
            local Weld = Instance.new("Weld")

            Weld.Name = "EggGrip"
            Weld.Part0 = UpperTorso
            Weld.Part1 = descendant
            Weld.C0 = v30:ToObjectSpace(descendant.CFrame)
            Weld.Parent = descendant
            descendant.Massless = true
            descendant.Anchored = false
        end
    end
end

local function release(p15) -- line: 277
    for _, descendant in p15:GetDescendants() do
        if descendant:IsA("Weld") and descendant.Name == "EggGrip" then
            descendant:Destroy()
        elseif descendant:IsA("BasePart") then
            descendant.Anchored = true
        end
    end
end

local function hands(p16, p17) -- line: 287
    local RightHand = p16:FindFirstChild("RightHand")
    local LeftHand = p16:FindFirstChild("LeftHand")

    if RightHand and LeftHand and RightHand:IsA("BasePart") and LeftHand:IsA("BasePart") then
        local v31 = p17[RightHand] or RightHand.CFrame
        local v32 = p17[LeftHand] or LeftHand.CFrame

        return (v31.Position + v32.Position) / 2
    end

    return nil
end

local function egg(p18) -- line: 298
    local clone = p18:Clone()

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false

            if descendant.Name == "Hitbox" then
                descendant.Transparency = 1
            end
        end
    end

    local _, BoundingBox = clone:GetBoundingBox()

    if BoundingBox.Y > 0 then
        clone:ScaleTo(clone:GetScale() * 4.25 / BoundingBox.Y)
    end

    clone.Name = "Egg"

    return clone
end

local function lift(p19, p20, p21) -- line: 319
    -- upvalues: hands (copy)
    local Head = p19:FindFirstChild("Head")
    local v33 = hands(p19, p21)

    if not v33 then
        v33 = if not (Head and Head:IsA("BasePart")) then p19:GetPivot().Position else Head.Position + Vector3.new(0, 2, 0)
    end

    local BoundingBox, BoundingBox2 = p20:GetBoundingBox()
    local v35 = v33 + Vector3.new(0, BoundingBox2.Y / 2 + 0.3, 0)

    p20:PivotTo(CFrame.new(v35) * p19:GetPivot().Rotation * BoundingBox:ToObjectSpace(p20:GetPivot()))
end

local function stand(p22, p23, p24) -- line: 334
    -- upvalues: RunService (copy), t2 (copy), freeze (copy), settle (copy), raise (copy), idleAnimation (copy), playIdle (copy), clasp (copy), release (copy), egg (copy), lift (copy)
    local Humanoid = p22:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = p22:FindFirstChild("HumanoidRootPart")
    local v36, v37, v38

    if Humanoid == nil or HumanoidRootPart == nil then
        v38 = true
    elseif HumanoidRootPart:IsA("BasePart") then
        v36 = idleAnimation(p22)
        freeze(p22)
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        Humanoid.EvaluateStateMachine = false
        Humanoid.BreakJointsOnDeath = false
        Humanoid.RequiresNeck = false
        HumanoidRootPart.Anchored = true
        HumanoidRootPart.Transparency = 1

        if p24 then
            v37 = egg(p24)
        end

        v38 = false
    else
        v38 = true
    end

    if v38 then
        return nil
    end

    if v37 then
        v37.Parent = p22
    end

    local v39 = false

    local function refresh() -- line: 354
        -- upvalues: p22 (copy), p23 (copy), Humanoid (copy), HumanoidRootPart (copy), v37 (ref), v39 (ref), settle (copy), raise (copy), clasp (copy), release (copy), lift (copy)
        v39 = false

        if p22.Parent == nil then
            return
        end

        if v37 then
            release(v37)
        end

        p22:PivotTo(p23 * CFrame.new(0, Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2, 0))
        raise(p22)

        local v40 = settle(p22, HumanoidRootPart)

        if v37 then
            lift(p22, v37, v40)
            clasp(p22, v37, HumanoidRootPart, v40)
        end
    end

    local function queue() -- line: 370
        -- upvalues: v39 (ref), refresh (copy)
        if not v39 then
            v39 = true
            task.defer(refresh)
        end
    end

    for _, v41 in t2 do
        local v42 = p22:FindFirstChild(v41.part)
        local v43 = v42 and v42:FindFirstChild(v41.joint)

        if v43 and v43:IsA("Motor6D") then
            v43:GetPropertyChangedSignal("C0"):Connect(queue)
        end
    end

    p22.DescendantAdded:Connect(function(p25) -- line: 383
        -- upvalues: v39 (ref), refresh (copy)
        if p25:IsA("JointInstance") and p25.Name ~= "EggGrip" and not v39 then
            v39 = true
            task.defer(refresh)
        end
    end)
    Humanoid:GetPropertyChangedSignal("HipHeight"):Connect(queue)
    refresh()
    playIdle(Humanoid, v36)

    local connection

    connection = RunService.PreSimulation:Connect(function() -- line: 392
        -- upvalues: p22 (copy), connection (ref), raise (copy)
        if p22.Parent ~= nil then
            raise(p22)
        elseif connection then
            connection:Disconnect()
        end
    end)
    p22.Destroying:Once(function() -- line: 401
        -- upvalues: connection (ref)
        if connection then
            connection:Disconnect()
        end
    end)

    return HumanoidRootPart
end

local function nameplate(p26, p27) -- line: 409
    local Nameplate = script:FindFirstChild("Nameplate")
    local clone, v44

    if Nameplate ~= nil then
        if Nameplate:IsA("BillboardGui") then
            clone = Nameplate:Clone()
            clone.Adornee = p26
            clone.StudsOffsetWorldSpace = Vector3.new(0, p26.Size.Y / 2 + 2.4, 0)

            local Title = clone:FindFirstChild("Title")

            if Title and Title:IsA("TextLabel") then
                Title.Text = "HALLOWEEN EGG"
            end

            v44 = false
        else
            v44 = true
        end
    else
        v44 = true
    end

    if v44 then
        return
    end

    clone.Enabled = true
    clone.Parent = p27
end

local function openShop() -- line: 425
    -- upvalues: ReplicatedStorage (copy)
    require(ReplicatedStorage.Client.ShopNavigation).Open("Featured")
end

local function prompt(p28, p29) -- line: 430
    -- upvalues: openShop (copy)
    local Part = Instance.new("Part")

    Part.Name = "PromptPoint"
    Part.Size = Vector3.new(1, 1, 1)
    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CFrame = p28 * CFrame.new(0, 3, 0)
    Part.Parent = p29

    local ProximityPrompt = Instance.new("ProximityPrompt")

    ProximityPrompt.Name = "HalloweenEggPrompt"
    ProximityPrompt.ActionText = "Open"
    ProximityPrompt.ObjectText = "Halloween Egg"
    ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
    ProximityPrompt.HoldDuration = 0
    ProximityPrompt.MaxActivationDistance = 10
    ProximityPrompt.RequiresLineOfSight = false
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
    ProximityPrompt.Parent = Part
    ProximityPrompt.Triggered:Connect(openShop)
end

local function assemble(p30, p31, p32) -- line: 454
    -- upvalues: Players (copy), Workspace (copy), eggTemplate (copy), stand (copy), nameplate (copy), prompt (copy)
    local function v46() -- line: 149
        -- upvalues: p32 (copy), Players (copy)
        return Players:CreateHumanoidModelFromDescriptionAsync(p32, Enum.HumanoidRigType.R15)
    end

    local ok, result = pcall(v46)

    if not ok or result == nil then
        result = nil
    end

    if p30:IsDescendantOf(Workspace) then
        if result ~= nil then
            result.Name = "HalloweenEggHolder"
            result.Parent = p30

            local v47 = stand(result, p31, (eggTemplate()))
            local Egg = result:FindFirstChild("Egg")

            if Egg and Egg:IsA("Model") and Egg.PrimaryPart then
                v47 = Egg.PrimaryPart
            end

            if v47 then
                nameplate(v47, p30)
            end

            prompt(p31, p30)
        end
    elseif result then
        result:Destroy()
    end
end

local function build(p33, p34) -- line: 480
    -- upvalues: Workspace (copy), LocalPlayer (copy), n1 (ref), spot (copy), description (copy), assemble (copy)
    local v48 = p34:Add(Instance.new("Folder"))

    v48.Name = "HalloweenEggHolders"

    local v49 = description(LocalPlayer)

    if p33 ~= n1 then
        return
    end

    local v50 = spot(v48)

    v48.Parent = Workspace
    assemble(v48, v50, v49 or Instance.new("HumanoidDescription"))
end

local function apply() -- line: 492
    -- upvalues: LimitedEgg (copy), Trove (copy), v2 (ref), n1 (ref), v3 (ref), t3 (copy), build (copy)
    local function v51() -- line: 67
        -- upvalues: LimitedEgg (copy)
        return LimitedEgg.IsOnSale(LimitedEgg.Halloween)
    end

    local ok, result = pcall(v51)
    local v52 = ok and result == true

    if v52 == v2 then
        return
    end

    v2 = v52
    n1 += 1

    if v3 then
        v3:Destroy()
        v3 = nil
    end

    if v52 then
        local v53 = Trove.new()

        v3 = v53
        task.spawn(build, n1, v53)
    end

    for _, v54 in t3 do
        task.spawn(v54, v52)
    end
end

function t4.IsActive() -- line: 517
    -- upvalues: v2 (ref)
    return v2
end

function t4.Changed(p35) -- line: 521
    -- upvalues: t3 (copy)
    table.insert(t3, p35)
end

function t4.Start() -- line: 525
    -- upvalues: BalanceConfig (copy), apply (copy)
    apply()
    BalanceConfig.Changed:Connect(apply)
    task.spawn(function() -- line: 528
        -- upvalues: apply (copy)
        while true do
            task.wait(5)
            apply()
        end
    end)
end

return t4
