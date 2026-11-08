-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local PumpkinBossState = require(ReplicatedStorage.Shared.Util.PumpkinBossState)
local Kit = require(script.Parent.Kit)
local ModelAttributes, Attributes, CannonAttributes, TrapAttributes = PumpkinBossState.ModelAttributes, PumpkinBossState.Attributes, PumpkinBossState.CannonAttributes, PumpkinBossState.TrapAttributes
local Phases = PumpkinBossState.Phases
local t1 = {
    Brute = true,
    King = true
}
local v1 = Color3.fromRGB(255, 230, 80)
local v2 = Color3.fromRGB(255, 40, 40)
local v3 = Color3.fromRGB(255, 235, 90)
local Clips, Anims = PumpkinBossState.Clips, PumpkinBossState.Anims
local t2 = {
    SwipeLeft = "Swipe",
    SwipeRight = "Swipe"
}
local v4 = false
local t3 = {}
local t4 = {}

local function vineTemplate(p1) -- line: 79
    -- upvalues: ReplicatedStorage (copy), t3 (copy), t4 (copy)
    local v5 = t4[p1]
    local HalloweenDimension

    if v5 ~= nil or t3[p1] then
        return v5
    else
        local Assets = ReplicatedStorage:FindFirstChild("Assets")

        HalloweenDimension = Assets and Assets:FindFirstChild("HalloweenDimension")
    end

    local PumpkinBoss = HalloweenDimension and HalloweenDimension:FindFirstChild("PumpkinBoss")
    local v7 = PumpkinBoss and PumpkinBoss:FindFirstChild(p1)

    if v7 == nil or not v7:IsA("Model") then
        t3[p1] = true

        return nil
    end

    local clone = v7:Clone()

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        end
    end

    local _, BoundingBox = clone:GetBoundingBox()

    if BoundingBox.Y > 0.001 then
        clone:ScaleTo(clone:GetScale() * 6.6 / BoundingBox.Y)
    end

    local BoundingBox2, BoundingBox3 = clone:GetBoundingBox()
    local t5 = {
        Model = clone,
        Offset = CFrame.new(BoundingBox2.Position - Vector3.new(0, BoundingBox3.Y / 2, 0)):ToObjectSpace(clone:GetPivot())
    }

    t4[p1] = t5

    return t5
end

local function vineShield(p2) -- line: 116
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local HalloweenDimension = Assets and Assets:FindFirstChild("HalloweenDimension")
    local PumpkinBoss = HalloweenDimension and HalloweenDimension:FindFirstChild("PumpkinBoss")
    local VineShield = PumpkinBoss and PumpkinBoss:FindFirstChild("VineShield")

    if VineShield == nil or not VineShield:IsA("Model") then
        return nil, CFrame.identity
    end

    local clone = VineShield:Clone()

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.CastShadow = false
        end
    end

    local _, BoundingBox = clone:GetBoundingBox()
    local v9 = math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z)

    if v9 > 0.001 then
        clone:ScaleTo(clone:GetScale() * p2 / v9)
    end

    return clone, clone:GetBoundingBox():ToObjectSpace(clone:GetPivot())
end

local function now() -- line: 144
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

local function setFade(p3, p4, p5) -- line: 148
    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("BasePart") then
            if not p5 or descendant:GetAttribute("Head") ~= true then
                descendant.LocalTransparencyModifier = p4
            end
        elseif descendant:IsA("Decal") then
            descendant.LocalTransparencyModifier = p4
        end
    end
end

local function findAnimator(p6) -- line: 161
    local v10 = p6:FindFirstChildWhichIsA("Animator", true)

    if v10 then
        return v10
    end

    local v11 = p6:FindFirstChildWhichIsA("Humanoid", true) or p6:FindFirstChildWhichIsA("AnimationController", true)

    if v11 == nil then
        return nil
    end

    local Animator = Instance.new("Animator")

    Animator.Parent = v11

    return Animator
end

local function findAnimation(p7, p8) -- line: 178
    -- upvalues: ReplicatedStorage (copy), t2 (copy), findAnimation (copy)
    local Animations = p7:FindFirstChild("Animations")
    local v12 = Animations and Animations:FindFirstChild(p8)

    if v12 and v12:IsA("Animation") then
        return v12
    end

    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Animations2 = Assets and Assets:FindFirstChild("Animations")
    local PumpkinBoss = Animations2 and Animations2:FindFirstChild("PumpkinBoss")
    local v13 = PumpkinBoss and PumpkinBoss:FindFirstChild(p7.Name)
    local v14 = v13 and v13:FindFirstChild(p8) or PumpkinBoss and PumpkinBoss:FindFirstChild(p8)

    if v14 and v14:IsA("Animation") then
        return v14
    end

    local v15 = t2[p8]

    return if v15 then findAnimation(p7, v15) else nil
end

local function clipAnimation(p9) -- line: 199
    local Animation = Instance.new("Animation")

    Animation.AnimationId = "rbxassetid://" .. p9

    return Animation
end

local function holdPoint(p10, p11) -- line: 205
    if p10.HoldAt then
        return (math.min(p10.HoldAt, p11 - 0.05))
    end

    return if p10.Hold then math.max(p11 - 0.05, 0) else nil
end

local function preloadClips() -- line: 214
    -- upvalues: ContentProvider (copy), Clips (copy), v4 (ref)
    if v4 then
        return
    end

    v4 = true

    local t6 = {}

    for _, v18 in Clips do
        for _, v19 in v18 do
            local Id = v19.Id
            local Animation = Instance.new("Animation")

            Animation.AnimationId = "rbxassetid://" .. Id
            table.insert(t6, Animation)
        end
    end

    local function v20() -- line: 225
        -- upvalues: t6 (copy), ContentProvider (copy)
        ContentProvider:PreloadAsync(t6)
    end

    pcall(v20)

    for _, v21 in t6 do
        v21:Destroy()
    end
end

local function billboard(p12, p13, p14, p15, p16) -- line: 234
    -- upvalues: ReplicatedStorage (copy), Kit (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local HalloweenDimension = Assets and Assets:FindFirstChild("HalloweenDimension")
    local MonsterBillboard = HalloweenDimension and HalloweenDimension:FindFirstChild("MonsterBillboard")
    local clone = if not (MonsterBillboard and MonsterBillboard:IsA("BillboardGui")) then nil else MonsterBillboard:Clone()
    local v22 = clone and clone:FindFirstChild("Health")
    local Fill = v22 and v22:FindFirstChild("Fill")
    local TextLabel = v22 and v22:FindFirstChild("TextLabel")

    if clone and Fill and Fill:IsA("GuiObject") and TextLabel and TextLabel:IsA("TextLabel") then
        local Title = clone:FindFirstChild("Title")

        if Title and Title:IsA("TextLabel") then
            Title.Text = p14
        end

        clone.Name = "PumpkinHealth"
        clone.Adornee = p13
        clone.StudsOffsetWorldSpace = Vector3.new(0, p13.Size.Y / 2 + p16 + clone.Size.Y.Scale / 2, 0)
        clone.Parent = Kit.Debris()
        p12:Add(clone)

        return clone, function(p17, p18) -- line: 268
            -- upvalues: Fill (copy), TextLabel (copy)
            local v28 = math.clamp(p17 / p18, 0, 1)

            TextLabel.Text = string.format("%d / %d HP", math.max(0, (math.ceil(p17))), p18)
            Fill.Size = UDim2.fromScale(v28, 1)
            Fill.Visible = v28 > 0
        end
    end

    if clone then
        clone:Destroy()
    end

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "PumpkinHealth"
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.fromOffset(90, 12)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, p13.Size.Y / 2 + p16, 0)
    BillboardGui.MaxDistance = 160
    BillboardGui.Adornee = p13

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 10, 0)
    Frame.BorderSizePixel = 0
    Frame.Parent = BillboardGui

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Fill"
    Frame2.Size = UDim2.fromScale(1, 1)
    Frame2.BackgroundColor3 = p15
    Frame2.BorderSizePixel = 0
    Frame2.Parent = Frame
    BillboardGui.Parent = Kit.Debris()
    p12:Add(BillboardGui)

    return BillboardGui, function(p19, p20) -- line: 303
        -- upvalues: Frame2 (copy)
        Frame2.Size = UDim2.fromScale(math.clamp(p19 / p20, 0, 1), 1)
    end
end

local function trackHealth(p21, p22, p23, p24, p25, p26, p27) -- line: 308
    -- upvalues: billboard (copy)
    local v32, v33 = billboard(p21, p27 or p22, p23, p24, p25)

    local function refresh() -- line: 318
        -- upvalues: p22 (copy), p26 (copy), v32 (copy), v33 (copy)
        local Health = p22:GetAttribute("Health")
        local MaxHealth = p22:GetAttribute("MaxHealth")
        local v34, v35

        if typeof(Health) ~= "number" or typeof(MaxHealth) ~= "number" or MaxHealth <= 0 then
            v32.Enabled = false
        else
            v34 = v32
            v35 = p26 == nil or p26()
            v34.Enabled = v35
            v33(Health, MaxHealth)
        end
    end

    p21:Connect(p22:GetAttributeChangedSignal("Health"), refresh)
    p21:Connect(p22:GetAttributeChangedSignal("MaxHealth"), refresh)
    refresh()
end

local function trappedRoot(p28) -- line: 335
    -- upvalues: Players (copy), TrapAttributes (copy)
    local Attribute = p28:GetAttribute(TrapAttributes.TrapUserId)
    local v37 = if typeof(Attribute) == "number" then Players:GetPlayerByUserId(Attribute) else nil
    local v38 = v37 and v37.Character
    local HumanoidRootPart = v38 and v38:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end

local t7 = {}

t7.__index = t7

function t7.new(p29, p30) -- line: 346
    -- upvalues: RunService (copy), PumpkinBossState (copy), t1 (copy), preloadClips (copy), t7 (copy)
    local v39 = setmetatable({
        Boss = nil,
        Bubble = nil,
        ShieldSpan = nil,
        ShieldAt = nil,
        ShieldBone = nil,
        ShieldGlow = nil,
        HitFlash = 0,
        ShieldFlash = 0,
        Bump = 0,
        BumpStrength = 1,
        BumpDirection = Vector3.new(1, 0, 0),
        Trove = p29,
        Arena = p30,
        ShieldOffset = CFrame.identity,
        CannonFlashes = {},
        Bound = setmetatable({}, {
            __mode = "k"
        })
    }, t7)

    local function onChild(p31) -- line: 366
        -- upvalues: v39 (copy), PumpkinBossState (copy), t1 (copy)
        if t1[p31.Name] and p31:IsA("Model") then
            v39:BindBoss(p31)
        elseif p31.Name == PumpkinBossState.VineFolder then
            v39:WatchFolder(p31, function(p32, p33) -- line: 370
                -- upvalues: v39 (copy)
                v39:BindVine(p32, p33)
            end)
        elseif p31.Name == PumpkinBossState.CannonFolder then
            v39:WatchFolder(p31, function(p34, p35) -- line: 374
                -- upvalues: v39 (copy)
                v39:BindCannon(p34, p35)
            end)
        elseif p31.Name == PumpkinBossState.MinionFolder then
            v39:WatchFolder(p31, function(p36, p37) -- line: 378
                -- upvalues: v39 (copy)
                v39:BindMinion(p36, p37)
            end)
        end
    end

    task.spawn(preloadClips)
    p29:Connect(p30.ChildAdded, onChild)

    for _, child in p30:GetChildren() do
        task.spawn(onChild, child)
    end

    p29:Connect(RunService.RenderStepped, function(p38) -- line: 390
        -- upvalues: v39 (copy)
        v39:Step(p38)
    end)
    p29:Add(function() -- line: 393
        -- upvalues: v39 (copy)
        if v39.Bubble then
            v39.Bubble:Destroy()
        end
    end)

    return v39
end

function t7.WatchFolder(p39, p40, p41) -- line: 402
    if p39.Bound[p40] then
        return
    end

    p39.Bound[p40] = true

    local t11 = {}

    local function added(p42) -- line: 409
        -- upvalues: p39 (copy), p41 (copy), t11 (copy)
        if t11[p42] then
            return
        end

        local v40 = p39.Trove:Extend()

        t11[p42] = v40
        task.spawn(p41, p42, v40)
    end

    p39.Trove:Connect(p40.ChildAdded, added)
    p39.Trove:Connect(p40.ChildRemoved, function(p43) -- line: 419
        -- upvalues: t11 (copy)
        local v41 = t11[p43]

        t11[p43] = nil

        if v41 then
            v41:Destroy()
        end
    end)

    for _, child in p40:GetChildren() do
        if not t11[child] then
            local v42 = p39.Trove:Extend()

            t11[child] = v42
            task.spawn(p41, child, v42)
        end
    end
end

function t7.BindBoss(p44, p45) -- line: 431
    -- upvalues: RunService (copy), Workspace (copy), Kit (copy), ModelAttributes (copy), v1 (copy), v2 (copy), v3 (copy), Clips (copy), Anims (copy), setFade (copy), findAnimator (copy), findAnimation (copy)
    if p44.Bound[p45] then
        return
    end

    p44.Bound[p45] = true

    local v43 = p44.Trove:Extend()

    v43:Connect(p45.AncestryChanged, function() -- line: 438
        -- upvalues: p45 (copy), v43 (copy)
        if p45.Parent == nil then
            v43:Destroy()
        end
    end)
    p44.Boss = p45

    local v44
    local t12 = {}
    local v45
    local n1 = 0

    local function stopTrack() -- line: 450
        -- upvalues: v44 (ref), v45 (ref)
        if v44 then
            v44:Stop(0.15)
            v44 = nil
        end

        v45 = nil
    end

    local function loadClip(p46, p47, p48) -- line: 458
        -- upvalues: v43 (copy), t12 (copy), Clips (copy)
        local v46 = t12[p48]

        if v46 then
            return v46
        end

        local v47 = Clips[p47]
        local v48 = v47 and v47[p48]

        if v48 == nil then
            return nil
        end

        local Id = v48.Id
        local Animation = Instance.new("Animation")

        Animation.AnimationId = "rbxassetid://" .. Id

        local v49 = v43:Add(Animation)

        local function v50() -- line: 469
            -- upvalues: p46 (copy), v49 (copy)
            return p46:LoadAnimation(v49)
        end

        local ok, result = pcall(v50)

        if not ok or result == nil then
            return nil
        end

        t12[p48] = result

        return result
    end

    local function playClip(p49, p50, p51) -- line: 479
        -- upvalues: p45 (copy), v44 (ref), v45 (ref), n1 (ref), loadClip (copy), Workspace (copy), ModelAttributes (copy), Clips (copy)
        local v51 = loadClip(p49, p50, p51.Clip)

        if v51 == nil then
            return
        end

        if v44 ~= v51 then
            if v44 then
                v44:Stop(0.15)
                v44 = nil
            end

            v45 = nil
        end

        v44 = v51
        v45 = p51

        local v52 = Clips[p50][p51.Clip]

        n1 = if v51.Length > 0 then v51.Length else v52.Length

        local Attribute = p45:GetAttribute(ModelAttributes.AnimAt)
        local v53 = if typeof(Attribute) == "number" then math.max(Workspace:GetServerTimeNow() - Attribute, 0) else 0
        local v55 = p51.Speed or 1
        local v56 = (p51.From or 0) + v53 * v55

        if p51.Loop then
            v56 %= n1
        end

        local v57 = n1
        local v58 = if p51.HoldAt then math.min(p51.HoldAt, v57 - 0.05) elseif p51.Hold then math.max(v57 - 0.05, 0) else nil
        local v62 = math.min(v56, v58 or n1 - 0.05)

        v51.Looped = p51.Loop == true

        if not v51.IsPlaying then
            v51:Play(0.15)
        end

        v51.TimePosition = math.max(v62, 0)

        if v58 and v58 <= v62 then
            v55 = 0
        end

        v51:AdjustSpeed(v55)
    end

    local function playAnim() -- line: 509
        -- upvalues: p45 (copy), v44 (ref), v45 (ref), playClip (copy), Workspace (copy), ModelAttributes (copy), Anims (copy), findAnimator (copy), findAnimation (copy)
        local Attribute = p45:GetAttribute(ModelAttributes.Anim)

        if typeof(Attribute) == "string" then
            local v63 = findAnimator(p45)

            if v63 ~= nil then
                local Name = p45.Name
                local v64 = Anims[Name]
                local v65 = v64 and v64[Attribute]

                if v65 then
                    playClip(v63, Name, v65)
                else
                    local v66 = findAnimation(p45, Attribute)

                    if v66 ~= nil then
                        if v44 then
                            v44:Stop(0.15)
                            v44 = nil
                        end

                        v45 = nil

                        local track = v63:LoadAnimation(v66)

                        v44 = track
                        track:Play(0.15)

                        local Attribute = p45:GetAttribute(ModelAttributes.AnimAt)

                        if typeof(Attribute) == "number" and track.Length > 0 and not track.Looped then
                            local v67 = Workspace:GetServerTimeNow() - Attribute

                            if v67 > 0.1 and v67 < track.Length then
                                track.TimePosition = v67
                            end
                        end
                    end
                end
            end
        end
    end

    v43:Connect(p45:GetAttributeChangedSignal(ModelAttributes.Anim), playAnim)
    v43:Connect(p45:GetAttributeChangedSignal(ModelAttributes.AnimAt), playAnim)
    v43:Connect(RunService.PreAnimation, function() -- line: 545
        -- upvalues: v44 (ref), v45 (ref), n1 (ref)
        local v68 = v45
        local v69 = v44

        if v68 == nil or v69 == nil then
            return
        end

        if v69.Length > 0 then
            n1 = v69.Length
        end

        local v70 = n1
        local v71 = if v68.HoldAt then math.min(v68.HoldAt, v70 - 0.05) elseif v68.Hold then math.max(v70 - 0.05, 0) else nil

        if v71 ~= nil then
            if v69.IsPlaying then
                if v69.Speed ~= 0 and v71 <= v69.TimePosition then
                    v69.TimePosition = v71
                    v69:AdjustSpeed(0)
                end
            else
                v69:Play(0)
                v69.TimePosition = v71
                v69:AdjustSpeed(0)
            end
        end
    end)
    playAnim()

    local function refreshDecay() -- line: 570
        -- upvalues: p45 (copy), v43 (copy), RunService (copy), ModelAttributes (copy), setFade (copy)
        local Attribute = p45:GetAttribute(ModelAttributes.Decaying)

        if Attribute == nil or Attribute == false then
            return
        end

        local v74 = if type(Attribute) == "number" and Attribute > 0 then Attribute else 0.8
        local elapsed = os.clock()
        local connection

        connection = v43:Connect(RunService.RenderStepped, function() -- line: 580
            -- upvalues: elapsed (copy), connection (ref), v74 (copy), p45 (copy), setFade (copy)
            local v76 = math.clamp((os.clock() - elapsed) / v74, 0, 1)

            setFade(p45, v76, true)

            if v76 >= 1 then
                connection:Disconnect()
            end
        end)
    end

    v43:Connect(p45:GetAttributeChangedSignal(ModelAttributes.Decaying), refreshDecay)
    refreshDecay()

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "PumpkinHighlight"
    Highlight.Enabled = false
    Highlight.Adornee = p45
    Highlight.Parent = Kit.Debris()
    v43:Add(Highlight)
    v43:Connect(RunService.RenderStepped, function() -- line: 599
        -- upvalues: p44 (copy), p45 (copy), Highlight (copy), ModelAttributes (copy), v1 (copy), v2 (copy)
        local v77 = if p44.Boss == p45 then p44.HitFlash else 0
        local v78 = p45:GetAttribute(ModelAttributes.Stunned) == true

        Highlight.Enabled = v78 or v77 > 0

        if Highlight.Enabled then
            local v79 = (if v78 then v1 else v2):Lerp(v2, v77)

            Highlight.FillColor = v79
            Highlight.OutlineColor = v79

            if v78 then
                Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                Highlight.FillTransparency = 0.6 + -0.44999999999999996 * v77
                Highlight.OutlineTransparency = 0
            else
                Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                Highlight.FillTransparency = 1 - 0.85 * v77
                Highlight.OutlineTransparency = 1 - v77
            end
        end
    end)

    local PrimaryPart = p45.PrimaryPart
    local t13 = {}

    if PrimaryPart then
        for _, descendant in p45:GetDescendants() do
            if descendant:IsA("Motor6D") and descendant.Part0 == PrimaryPart or descendant:IsA("Bone") and descendant.Parent == PrimaryPart then
                table.insert(t13, descendant)
            end
        end
    end

    local t14 = {}

    local function restore() -- line: 633
        -- upvalues: t14 (copy)
        for v80, v81 in t14 do
            v80.Transform = v81
        end

        table.clear(t14)
    end

    v43:Connect(RunService.PreAnimation, restore)
    v43:Connect(RunService.PreSimulation, function() -- line: 640
        -- upvalues: p44 (copy), p45 (copy), t13 (copy), t14 (copy)
        local v82 = if p44.Boss == p45 then p44:BumpOffset(p45) else nil

        if v82 ~= nil then
            for _, v83 in t13 do
                if v83.Parent ~= nil and not t14[v83] then
                    local v84 = if v83:IsA("Motor6D") then v83.C0 else v83.CFrame
                    local Transform = v83.Transform

                    t14[v83] = Transform
                    v83.Transform = v84:Inverse() * v82 * v84 * Transform
                end
            end
        end
    end)
    v43:Add(restore)

    local t15 = {}

    local function clearStars() -- line: 658
        -- upvalues: t15 (copy)
        for _, v85 in t15 do
            v85:Destroy()
        end

        table.clear(t15)
    end

    v43:Add(clearStars)
    v43:Connect(RunService.RenderStepped, function() -- line: 665
        -- upvalues: p45 (copy), t15 (copy), Kit (copy), ModelAttributes (copy), v3 (copy)
        local Hitbox = p45:FindFirstChild("Hitbox")
        local BodyHeight, v86

        if p45:GetAttribute(ModelAttributes.Stunned) ~= true or Hitbox == nil then
            v86 = true
        elseif Hitbox:IsA("BasePart") then
            BodyHeight = p45:GetAttribute("BodyHeight")

            if type(BodyHeight) ~= "number" then
                BodyHeight = Hitbox.Size.Y
            end

            v86 = false
        else
            v86 = true
        end

        if not v86 then
            if #t15 == 0 then
                for i = 1, 5 do
                    local v87 = Kit.Part({
                        Name = "PumpkinStunStar",
                        Color = v3,
                        Size = Vector3.new(1, 1, 1) * BodyHeight * 0.07
                    })

                    v87.Parent = Kit.Debris()
                    t15[i] = v87
                end
            end

            local v89 = Hitbox.CFrame:PointToWorldSpace((Vector3.new(0, Hitbox.Size.Y / 2, 0)))
            local elapsed = os.clock()

            for v90, v91 in t15 do
                local v92 = elapsed * 3.490658503988659 + v90 / 5 * 3.141592653589793 * 2
                local v94 = math.sin(elapsed * 4 + v90) * BodyHeight * 0.04
                local v97 = Vector3.new(math.cos(v92), 0, (math.sin(v92))) * BodyHeight * 0.3

                v91.CFrame = CFrame.new(v89 + v97 + Vector3.new(0, v94, 0)) * CFrame.Angles(v92, v92 * 2, 0.7853981633974483)
            end
        elseif #t15 > 0 then
            for _, v98 in t15 do
                v98:Destroy()
            end

            table.clear(t15)
        end
    end)
end

function t7.Flash(p52, p53, p54) -- line: 704
    -- upvalues: Workspace (copy), Kit (copy)
    p54 = p54 or 1
    p52.BumpStrength = if p52.Bump > 0.5 then math.max(p52.BumpStrength, p54) else p54
    p52.HitFlash = 1
    p52.Bump = 1

    local CurrentCamera = Workspace.CurrentCamera
    local v100 = Kit.Flat(p53 or (if CurrentCamera then CurrentCamera.CFrame.LookVector else Vector3.new(1, 0, 0)))

    if v100.Magnitude > 0.001 then
        p52.BumpDirection = v100.Unit
    else
        p52.BumpDirection = Vector3.new(1, 0, 0)
    end
end

function t7.FlashShield(p55, p56, p57) -- line: 714
    p55.ShieldFlash = 1
    p55:Flash(p56, p57)
end

function t7.FlashCannon(p58, p59) -- line: 719
    if p58.CannonFlashes[p59] ~= nil then
        p58.CannonFlashes[p59] = 1
    end
end

function t7.BumpOffset(p60, p61) -- line: 725
    local Bump = p60.Bump
    local PrimaryPart = p61.PrimaryPart

    if Bump <= 0 or PrimaryPart == nil then
        return nil
    end

    local BodyHeight = p61:GetAttribute("BodyHeight")

    if type(BodyHeight) ~= "number" then
        BodyHeight = PrimaryPart.Size.Y
    end

    local v102 = math.sin((1 - Bump) * 3.141592653589793 * 2.5) * Bump * Bump * p60.BumpStrength
    local v103 = PrimaryPart.CFrame:VectorToObjectSpace(p60.BumpDirection)
    local v104 = (Vector3.new(0, 1, 0)):Cross(v103)
    local v105 = if v104.Magnitude > 0.001 then CFrame.fromAxisAngle(v104.Unit, 0.08726646259971647 * v102) else CFrame.identity

    return CFrame.new(v103 * BodyHeight * 0.035 * v102) * v105
end

function t7.BindVine(_, p63, p64) -- line: 743
    -- upvalues: Kit (copy), vineTemplate (copy), trackHealth (copy), trappedRoot (copy)
    if not p63:IsA("BasePart") then
        return
    end

    local Style = p63:GetAttribute("Style")
    local v106 = if Style == "King" then Kit.Green else Color3.fromRGB(150, 40, 20)
    local Folder = Instance.new("Folder")

    Folder.Name = "PumpkinVineCage"
    Folder.Parent = Kit.Debris()
    p64:Add(Folder)

    local Y = p63.Size.Y
    local v107 = p63.Position.Y - Y / 2
    local v108 = trappedRoot(p63)

    local function base() -- line: 758
        -- upvalues: p63 (copy), v107 (copy), v108 (copy)
        local Position = if not (v108 and v108.Parent) then p63.Position else v108.Position

        return (Vector3.new(Position.X, v107, Position.Z))
    end

    local Position = if not (v108 and v108.Parent) then p63.Position else v108.Position
    local v109 = Vector3.new(Position.X, v107, Position.Z)
    local v111 = Kit.Part({
        Name = "VineAnchor",
        Transparency = 1,
        Size = p63.Size,
        CFrame = CFrame.new(v109 + Vector3.new(0, Y / 2, 0)),
        Parent = Folder
    })
    local v113 = vineTemplate(if Style == "King" then "GreenVines" else "OrangeVines")
    local v114

    if v113 then
        v114 = v113.Model:Clone()

        local v115 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)

        v114:PivotTo(CFrame.new(v109) * v115 * v113.Offset)
    else
        v114 = Instance.new("Model")
        v114.Name = "VineCage"

        local v116 = math.max(p63.Size.X, p63.Size.Z) / 2

        for i = 1, 6 do
            local v117 = i / 6 * 3.141592653589793 * 2
            local v120 = v109 + Vector3.new(math.cos(v117), 0, (math.sin(v117))) * v116
            local v126 = v109 + Vector3.new(0, Y, 0) + Vector3.new(math.cos(v117 + 1), 0, (math.sin(v117 + 1))) * v116 * 0.35
            local v127 = v126 - v120

            Kit.Part({
                Name = "Vine",
                Material = Enum.Material.Grass,
                Color = v106,
                Size = Vector3.new(0.9, 0.9, v127.Magnitude),
                CFrame = CFrame.lookAt(v120 + v127 / 2, v126),
                Parent = v114
            })
        end
    end

    v114.Parent = Folder

    if v108 then
        local v128 = v109

        p64:Connect(v108:GetPropertyChangedSignal("Anchored"), function() -- line: 806
            -- upvalues: p63 (copy), Y (copy), v107 (copy), v108 (copy), v111 (copy), v114 (ref), v128 (ref)
            local Position = if not (v108 and v108.Parent) then p63.Position else v108.Position
            local v129 = Vector3.new(Position.X, v107, Position.Z)

            v111.CFrame = CFrame.new(v129 + Vector3.new(0, Y / 2, 0))
            v114:PivotTo(v114:GetPivot() + (v129 - v128))
            v128 = v129
        end)
    end

    trackHealth(p64, p63, "Vines", v106, 1, nil, v111)
end

local function standVisuals(p65) -- line: 818
    local t18 = {}
    local OperatorPad = p65:FindFirstChild("OperatorPad")

    if OperatorPad then
        for _, descendant in OperatorPad:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                t18[descendant] = descendant.Transparency
            end
        end
    else
        local OperatorZone = p65:FindFirstChild("OperatorZone")

        if OperatorZone and OperatorZone:IsA("BasePart") then
            t18[OperatorZone] = OperatorZone.Transparency
        end
    end

    return t18
end

function t7.BindCannon(p66, p67, p68) -- line: 836
    -- upvalues: Players (copy), RunService (copy), Kit (copy), Attributes (copy), CannonAttributes (copy), TrapAttributes (copy), Phases (copy), v2 (copy), trackHealth (copy), standVisuals (copy)
    local v131 = p67:FindFirstChild("RootHitbox") or p67:WaitForChild("RootHitbox", 5)

    if v131 == nil or not v131:IsA("BasePart") or p67.Parent == nil then
        return
    end

    local function locked() -- line: 842
        -- upvalues: p67 (copy), CannonAttributes (copy)
        return p67:GetAttribute(CannonAttributes.Ready) ~= true
    end

    trackHealth(p68, v131, "Roots", Kit.Green, 2, locked)

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "PumpkinCannonFlash"
    Highlight.Enabled = false
    Highlight.FillColor = v2
    Highlight.OutlineColor = v2
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Adornee = p67
    Highlight.Parent = Kit.Debris()
    p68:Add(Highlight)
    p66.CannonFlashes[p67] = 0
    p68:Add(function() -- line: 857
        -- upvalues: p66 (copy), p67 (copy)
        p66.CannonFlashes[p67] = nil
    end)
    p68:Connect(RunService.RenderStepped, function(p69) -- line: 860
        -- upvalues: p66 (copy), p67 (copy), Highlight (copy)
        local v132 = p66.CannonFlashes[p67]

        if v132 == nil then
            return
        end

        local v134 = math.max(0, v132 - p69 / 0.15)

        p66.CannonFlashes[p67] = v134
        Highlight.Enabled = v134 > 0

        if v134 > 0 then
            Highlight.FillTransparency = 1 - 0.85 * v134
            Highlight.OutlineTransparency = 1 - v134
        end
    end)

    local v135 = standVisuals(p67)
    local v136
    local n2 = 0
    local LocalPlayer = Players.LocalPlayer

    local function usable() -- line: 880
        -- upvalues: p66 (copy), p67 (copy), LocalPlayer (copy), Attributes (copy), CannonAttributes (copy), TrapAttributes (copy), Phases (copy)
        local Attribute = p66.Arena:GetAttribute(Attributes.Phase)

        if p67:GetAttribute(CannonAttributes.Ready) ~= true or Attribute ~= Phases.Shield and Attribute ~= Phases.Stunned then
            return false
        end

        local Attribute2 = p67:GetAttribute(CannonAttributes.OwnerUserId)

        if Attribute2 == LocalPlayer.UserId or Attribute2 == 0 then
            local Character = LocalPlayer.Character

            if Character ~= nil and Character:GetAttribute(TrapAttributes.Trapped) ~= true then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                return Humanoid ~= nil and Humanoid.Health > 0
            end
        end

        return false
    end

    local function refresh() -- line: 896
        -- upvalues: v135 (copy), v136 (ref), n2 (ref), usable (copy)
        n2 = os.clock() + 0.1

        local v137 = usable()

        if not v137 or v137 == v136 then
            if not v137 then
                for v138 in v135 do
                    if v138.Transparency ~= 1 then
                        v138.Transparency = 1
                    end
                end
            end
        else
            for v139, v140 in v135 do
                v139.Transparency = v140
            end
        end

        v136 = v137
    end

    p68:Connect(p67:GetAttributeChangedSignal(CannonAttributes.Ready), refresh)
    p68:Connect(p67:GetAttributeChangedSignal(CannonAttributes.OwnerUserId), refresh)
    p68:Connect(p66.Arena:GetAttributeChangedSignal(Attributes.Phase), refresh)
    p68:Connect(RunService.Heartbeat, function() -- line: 915
        -- upvalues: n2 (ref), refresh (copy)
        if os.clock() >= n2 then
            refresh()
        end
    end)
    refresh()
    p68:Add(function() -- line: 922
        -- upvalues: v135 (copy)
        for v141, v142 in v135 do
            v141.Transparency = v142
        end
    end)
end

function t7.BindMinion(_, p71, p72) -- line: 929
    -- upvalues: RunService (copy), Workspace (copy), Kit (copy), trackHealth (copy)
    local v143 = p71:FindFirstChild("Hitbox") or p71:WaitForChild("Hitbox", 5)

    if v143 == nil or not v143:IsA("BasePart") or p71.Parent == nil then
        return
    end

    trackHealth(p72, v143, "Pumpkin Minion", Kit.Orange, 1)

    if not p71:IsA("Model") then
        return
    end

    local Highlight, ServerTimeNow
    local n3 = 0

    p72:Add(function() -- disarm | line: 942
        -- upvalues: p71 (copy), Highlight (ref), ServerTimeNow (ref)
        ServerTimeNow = nil

        if Highlight then
            Highlight:Destroy()
            Highlight = nil
        end

        local v144 = p71.PrimaryPart and p71.PrimaryPart:FindFirstChild("DroneFuse")

        if v144 then
            v144:Destroy()
        end
    end)
    p72:Connect(RunService.RenderStepped, function(p73) -- line: 954
        -- upvalues: p71 (copy), Highlight (ref), ServerTimeNow (ref), n3 (ref), Workspace (copy), Kit (copy)
        if p71:GetAttribute("Armed") == true then
            local ServerTimeNow2 = Workspace:GetServerTimeNow()

            if ServerTimeNow == nil then
                ServerTimeNow = ServerTimeNow2
                n3 = 0

                local Highlight2 = Instance.new("Highlight")

                Highlight2.Name = "PumpkinFuse"
                Highlight2.Adornee = p71
                Highlight2.DepthMode = Enum.HighlightDepthMode.Occluded
                Highlight2.OutlineTransparency = 0
                Highlight2.Parent = Kit.Debris()
                Highlight = Highlight2

                if p71.PrimaryPart then
                    Kit.Sound("DroneFuse", p71.PrimaryPart, 0.8)
                end
            end

            local ServerTimeNow3 = ServerTimeNow
            local FuseEnds = p71:GetAttribute("FuseEnds")
            local v145 = if type(FuseEnds) ~= "number" or not (ServerTimeNow3 < FuseEnds) then 2.5 else FuseEnds - ServerTimeNow3
            local v147 = math.clamp((ServerTimeNow2 - ServerTimeNow3) / v145, 0, 1)

            n3 += p73 * (v147 * 13 * v147 + 3)

            local v149 = n3 % 1 < 0.5
            local Highlight2 = Highlight

            if v149 then
                Highlight2.FillColor = Color3.new(1, 1, 1)
                Highlight2.OutlineColor = Kit.Red
            else
                Highlight2.FillColor = Kit.Red
                Highlight2.OutlineColor = Color3.new(1, 1, 1)
            end

            Highlight2.FillTransparency = v149 and 0.05 or 0.6
        elseif ServerTimeNow then
            ServerTimeNow = nil

            if Highlight then
                Highlight:Destroy()
                Highlight = nil
            end

            local v150 = p71.PrimaryPart and p71.PrimaryPart:FindFirstChild("DroneFuse")

            if v150 then
                v150:Destroy()
            end
        end
    end)
end

function t7.Step(p74, p75) -- line: 993
    -- upvalues: Kit (copy), Attributes (copy), v2 (copy), vineShield (copy)
    p74.HitFlash = math.max(0, p74.HitFlash - p75 / 0.15)
    p74.ShieldFlash = math.max(0, p74.ShieldFlash - p75 / 0.15)
    p74.Bump = math.max(0, p74.Bump - p75 / 0.22)

    local Boss = p74.Boss
    local v154 = p74.Arena:GetAttribute(Attributes.ShieldActive) == true
    local Hitbox = if not (Boss and Boss.Parent) then nil else Boss:FindFirstChild("Hitbox")

    if not (Hitbox and Hitbox:IsA("BasePart")) then
        Hitbox = nil
    end

    if not v154 or Hitbox == nil then
        if p74.Bubble then
            p74.Bubble:Destroy()
            p74.Bubble = nil
        end
    else
        local Bubble = p74.Bubble

        if Bubble == nil then
            local v156 = math.max(Hitbox.Size.X, Hitbox.Size.Y, Hitbox.Size.Z) + 6
            local v157, v158 = vineShield(v156)

            Bubble = v157 or Kit.Part({
                Name = "PumpkinShield",
                Shape = Enum.PartType.Ball,
                Material = Enum.Material.ForceField,
                Color = Kit.Purple,
                Size = Vector3.new(1, 1, 1) * v156
            })
            Bubble.Parent = Kit.Debris()
            p74.Bubble = Bubble

            local Highlight = Instance.new("Highlight")

            Highlight.Name = "PumpkinShieldFlash"
            Highlight.Enabled = false
            Highlight.FillColor = v2
            Highlight.OutlineColor = v2
            Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
            Highlight.Parent = Bubble
            p74.ShieldGlow = Highlight
            p74.ShieldOffset = v158
            p74.ShieldSpan = v156
            p74.ShieldAt = nil

            if Boss then
                Boss = Boss:FindFirstChild("Spine", true)

                if not Boss or not Boss:IsA("Bone") then
                    Boss = nil
                end
            else
                Boss = nil
            end

            p74.ShieldBone = Boss
        end

        local ShieldBone = p74.ShieldBone
        local v159 = if not (ShieldBone and ShieldBone.Parent) then Vector3.new(0, 0, 0) else ShieldBone.TransformedWorldCFrame.Position - ShieldBone.WorldCFrame.Position
        local v160 = Hitbox.CFrame + v159

        if p74.ShieldAt ~= v160 then
            p74.ShieldAt = v160
            Bubble:PivotTo(v160 * p74.ShieldOffset)
        end

        local ShieldGlow = p74.ShieldGlow

        if ShieldGlow and ShieldGlow.Parent then
            local ShieldFlash = p74.ShieldFlash

            ShieldGlow.Enabled = ShieldFlash > 0
            ShieldGlow.FillTransparency = 1 - 0.85 * ShieldFlash
            ShieldGlow.OutlineTransparency = 1 - ShieldFlash
        end
    end
end

function t7.ShieldSize(p76) -- line: 1060
    return p76.ShieldSpan
end

return t7
