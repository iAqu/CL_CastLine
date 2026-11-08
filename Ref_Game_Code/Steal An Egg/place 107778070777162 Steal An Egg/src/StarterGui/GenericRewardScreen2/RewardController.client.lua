-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Parent = script.Parent
local Quint, Quad = Enum.EasingStyle.Quint, Enum.EasingStyle.Quad
local RewardScreen = Parent:WaitForChild("RewardScreen")
local ContentHolder = RewardScreen:WaitForChild("ContentHolder")
local TopBar = RewardScreen:WaitForChild("TopBar")
local BottomBar = RewardScreen:WaitForChild("BottomBar")
local TopBarAccent = RewardScreen:WaitForChild("TopBarAccent")
local ImageTransparency = RewardScreen:WaitForChild("TopBarAccent2")
local BottombarAccent = RewardScreen:WaitForChild("BottombarAccent")
local Title = ContentHolder:WaitForChild("Title")
local ItemName = ContentHolder:WaitForChild("ItemName")
local RarityLabel = ContentHolder:WaitForChild("RarityLabel")
local TapAnywhereToSkip = ContentHolder:WaitForChild("TapAnywhereToSkip")
local Pet = ContentHolder:WaitForChild("Pet")
local Glow = ContentHolder:WaitForChild("Glow")
local Glow2 = ContentHolder:WaitForChild("Glow2")
local RewardSFX = require(Parent:WaitForChild("RewardSFX"))

RewardSFX.preload()

local v1, v2

task.spawn(function() -- line: 124
    -- upvalues: Parent (copy), v1 (ref), v2 (ref)
    local ConfettiCannon = Parent:FindFirstChild("ConfettiCannon")

    if ConfettiCannon then
        v1 = ConfettiCannon:WaitForChild("Burst", 10)
        v2 = ConfettiCannon:WaitForChild("Fade", 10)
    end
end)

local function transparencyProperty(p1) -- line: 143
    if p1:IsA("ImageLabel") or p1:IsA("ImageButton") then
        return "ImageTransparency"
    end

    if p1:IsA("TextLabel") or p1:IsA("TextButton") then
        return "TextTransparency"
    end

    if p1:IsA("UIStroke") then
        return "Transparency"
    end

    return "BackgroundTransparency"
end

local t1 = {}
local t2 = {}

local function addMover(p2, p3) -- line: 157
    -- upvalues: transparencyProperty (copy), t1 (copy)
    local v3 = transparencyProperty(p2)
    local Position = p2.Position
    local v4 = p2[v3]
    local t3 = {
        content = false,
        outGoal = nil,
        inst = p2,
        property = v3,
        rest = Position,
        hidden = UDim2.new(Position.X.Scale + p3 * 1.15, Position.X.Offset, Position.Y.Scale, Position.Y.Offset),
        alpha = v4,
        goal = {
            Position = Position,
            [v3] = v4
        }
    }

    t3.outGoal = {
        Position = t3.hidden,
        [v3] = 1
    }
    t1[#t1 + 1] = t3
end

local function addFader(p4) -- line: 180
    -- upvalues: transparencyProperty (copy), t2 (copy)
    local v5 = transparencyProperty(p4)
    local v6 = p4[v5]

    t2[#t2 + 1] = {
        content = false,
        inst = p4,
        property = v5,
        alpha = v6,
        goal = {
            [v5] = v6
        },
        outGoal = {
            [v5] = 1
        }
    }
end

addMover(TopBar, 1)
addMover(TopBarAccent, 1)
addMover(ImageTransparency, 1)
addMover(BottomBar, -1)
addMover(BottombarAccent, -1)

local v7 = #t1

addMover(Title, -1)
addMover(ItemName, 1)
addMover(RarityLabel, -1)
addFader(TapAnywhereToSkip)
addFader(Glow)
addFader(Glow2)

local function addDescendantFaders(p5) -- line: 213
    -- upvalues: addFader (copy)
    for _, descendant in ipairs(p5:GetDescendants()) do
        if descendant:IsA("UIStroke") or descendant:IsA("TextLabel") then
            addFader(descendant)
        end
    end
end

addDescendantFaders(Title)
addDescendantFaders(ItemName)
addDescendantFaders(RarityLabel)
addDescendantFaders(TapAnywhereToSkip)

local Size, PetPosition = Pet.Size, Pet.Position

ImageTransparency = Pet.ImageTransparency

local v8 = UDim2.fromScale(Size.X.Scale * 0.9, Size.Y.Scale * 0.9)
local t6 = {
    Size = Size
}
local t7 = {
    ImageTransparency = ImageTransparency
}
local t8 = {
    ImageTransparency = 1,
    Size = v8
}
local t9 = {
    BackgroundTransparency = 0.45
}
local t10 = {
    BackgroundTransparency = 1
}
local Rotation = Glow.Rotation
local Rotation2 = Glow2.Rotation

RewardScreen.BackgroundColor3 = Color3.new(0, 0, 0)

local v9 = table.create(v7)

for i = 1, v7 do
    v9[i] = TweenInfo.new(0.42, Quint, Enum.EasingDirection.Out, 0, false, (i - 1) * 0.03)
end

local v10 = table.create(#t1 - v7)

for i = 1, #t1 - v7 do
    v10[i] = TweenInfo.new(0.42, Quint, Enum.EasingDirection.Out, 0, false, (i - 1) * 0.045 + 0.06)
end

local v11 = TweenInfo.new(0.34, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.06)
local v12 = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0.06)
local v13 = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.06)
local v14 = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v15 = TweenInfo.new(0.2, Quad, Enum.EasingDirection.In)
local v16 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v17 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v18 = TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v19 = table.create(32)
local n1 = 0

local function play(p6, p7, p8) -- line: 270
    -- upvalues: TweenService (copy), v19 (copy), n1 (ref)
    local tween = TweenService:Create(p6, p7, p8)

    n1 += 1
    v19[n1] = tween
    tween:Play()
end

local function cancelAll() -- line: 277
    -- upvalues: v19 (copy), n1 (ref)
    local v20 = n1

    for i = 1, v20 do
        v19[i]:Cancel()
        v19[i] = nil
    end

    n1 = 0
end

local n2 = 0
local v21 = Parent:GetAttribute("IdleMotion") ~= false
local connection, v22
local n3 = 0

local function onRender(p9) -- line: 300
    -- upvalues: Pet (copy), Glow (copy), Glow2 (copy), PetPosition (copy), Rotation (copy), Rotation2 (copy), v21 (ref), n3 (ref)
    n3 += p9

    if n3 > 3600 then
        n3 -= 3600
    end

    if not v21 then
        return
    end

    Glow.Rotation = Rotation + n3 * -26
    Glow2.Rotation = Rotation2 + n3 * 8
    Pet.Position = UDim2.new(PetPosition.X.Scale, PetPosition.X.Offset, PetPosition.Y.Scale + math.sin(n3 * 1.9634954084936207) * 0.006, PetPosition.Y.Offset)
end

local hide, requestNext

local function startIdle() -- line: 321
    -- upvalues: RunService (copy), connection (ref), n3 (ref), onRender (copy)
    if not connection then
        n3 = 0
        connection = RunService.RenderStepped:Connect(onRender)
    end
end

local function stopIdle() -- line: 330
    -- upvalues: Pet (copy), Glow (copy), Glow2 (copy), PetPosition (copy), Rotation (copy), Rotation2 (copy), connection (ref)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    Glow.Rotation = Rotation
    Glow2.Rotation = Rotation2
    Pet.Position = PetPosition
end

Parent:GetAttributeChangedSignal("IdleMotion"):Connect(function() -- line: 340
    -- upvalues: Parent (copy), Pet (copy), Glow (copy), Glow2 (copy), PetPosition (copy), Rotation (copy), Rotation2 (copy), v21 (ref)
    v21 = Parent:GetAttribute("IdleMotion") ~= false

    if v21 then
        return
    end

    Glow.Rotation = Rotation
    Glow2.Rotation = Rotation2
    Pet.Position = PetPosition
end)

local function startSkipListener() -- line: 349
    -- upvalues: UserInputService (copy), v22 (ref), requestNext (ref)
    v22 = v22 or UserInputService.InputBegan:Connect(function(p10, p11) -- line: 353
        -- upvalues: requestNext (ref)
        if not p11 then
            local UserInputType = p10.UserInputType

            if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
                requestNext()
            end
        end
    end)
end

local function stopSkipListener() -- line: 364
    -- upvalues: v22 (ref)
    if v22 then
        v22:Disconnect()
        v22 = nil
    end
end

local v24 = false
local n4 = 0
local n5 = 0
local v25 = false
local v26 = table.create(8)
local n6 = 1
local n7 = 0

local function sanitize(p12) -- line: 423
    local v27 = tostring(p12)
    local v28 = string.gsub(v27, "&", "&amp;")
    local v29 = string.gsub(v28, "<", "&lt;")

    return (string.gsub(v29, ">", "&gt;"))
end

local function applyContent(p13) -- line: 431
    -- upvalues: Title (copy), ItemName (copy), RarityLabel (copy), Pet (copy)
    if not p13 then
        return
    end

    if p13.title then
        local v30 = tostring(p13.title)
        local v31 = string.gsub(v30, "&", "&amp;")
        local v32 = string.gsub(v31, "<", "&lt;")

        Title.Text = string.gsub(v32, ">", "&gt;")
    end

    if p13.item then
        local v33 = tostring(p13.item)
        local v34 = string.gsub(v33, "&", "&amp;")
        local v35 = string.gsub(v34, "<", "&lt;")

        ItemName.Text = string.gsub(v35, ">", "&gt;")
    end

    if p13.rarity then
        local v36 = tostring(p13.rarity)
        local v37 = string.gsub(v36, "&", "&amp;")
        local v38 = string.gsub(v37, "<", "&lt;")

        RarityLabel.Text = string.gsub(v38, ">", "&gt;")
    end

    if p13.image then
        Pet.Image = p13.image
    end
end

local function celebrate() -- line: 449
    -- upvalues: RewardSFX (copy), v1 (ref)
    if v1 then
        v1:Fire()
    end

    RewardSFX.play("Reward")
end

local t11 = {}
local t12 = {}

local function registerSwap(p14, p15, p16) -- line: 465
    -- upvalues: t11 (copy), t12 (copy)
    local v39 = #t11 + 1

    t11[v39] = {
        inst = p14,
        goal = {
            [p15] = p16
        }
    }
    t12[v39] = {
        inst = p14,
        goal = {
            [p15] = 1
        }
    }
end

local function isContent(p17) -- line: 471
    -- upvalues: Title (copy), ItemName (copy), RarityLabel (copy)
    if p17 == Title or p17 == ItemName or p17 == RarityLabel then
        return true
    end

    return p17:IsDescendantOf(Title) or p17:IsDescendantOf(ItemName) or p17:IsDescendantOf(RarityLabel)
end

local v41, inst

for i = 1, #t1 do
    v41 = t1[i]
    inst = v41.inst

    if inst == Title or inst == ItemName or inst == RarityLabel then
        v41.content = true
    else
        v41.content = inst:IsDescendantOf(Title) or inst:IsDescendantOf(ItemName) or inst:IsDescendantOf(RarityLabel)
    end

    if v41.content then
        registerSwap(v41.inst, v41.property, v41.alpha)
    end
end

for i = 1, #t2 do
    v41 = t2[i]
    inst = v41.inst

    if inst == Title or inst == ItemName or inst == RarityLabel then
        v41.content = true
    else
        v41.content = inst:IsDescendantOf(Title) or inst:IsDescendantOf(ItemName) or inst:IsDescendantOf(RarityLabel)
    end

    if v41.content then
        registerSwap(v41.inst, v41.property, v41.alpha)
    end
end

registerSwap(Pet, "ImageTransparency", ImageTransparency)

local function resetToHidden() -- line: 500
    -- upvalues: RewardScreen (copy), Pet (copy), Glow (copy), Glow2 (copy), t1 (copy), t2 (copy), PetPosition (copy), v8 (copy), Rotation (copy), Rotation2 (copy)
    RewardScreen.BackgroundTransparency = 1

    for i = 1, #t1 do
        local v42 = t1[i]
        local inst = v42.inst

        inst.Position = v42.hidden
        inst[v42.property] = 1
    end

    for i = 1, #t2 do
        local v43 = t2[i]

        v43.inst[v43.property] = 1
    end

    Pet.Size = v8
    Pet.Position = PetPosition
    Pet.ImageTransparency = 1
    Glow.Rotation = Rotation
    Glow2.Rotation = Rotation2
end

local advance

local function armAutoClose(p18) -- line: 524
    -- upvalues: hide (ref), v24 (ref), n4 (ref)
    n4 += 1

    local autoClose = p18 and p18.autoClose or 4

    if autoClose <= 0 then
        return
    end

    local v44 = n4

    task.delay(autoClose, function() -- line: 531
        -- upvalues: v44 (copy), hide (ref), v24 (ref), n4 (ref)
        if v44 == n4 and v24 then
            hide()
        end
    end)
end

local function settleEntrance() -- line: 555
    -- upvalues: RewardScreen (copy), t1 (copy), t2 (copy)
    for i = 1, #t1 do
        local v45 = t1[i]
        local inst = v45.inst

        inst.Position = v45.rest

        if not v45.content then
            inst[v45.property] = v45.alpha
        end
    end

    for i = 1, #t2 do
        local v46 = t2[i]

        if not v46.content then
            v46.inst[v46.property] = v46.alpha
        end
    end

    RewardScreen.BackgroundTransparency = 0.45
end

function advance() -- line: 576
    -- upvalues: TweenService (copy), Title (copy), ItemName (copy), RarityLabel (copy), Pet (copy), RewardSFX (copy), v1 (ref), v8 (copy), t6 (copy), v16 (copy), v17 (copy), v18 (copy), v19 (copy), n1 (ref), n2 (ref), hide (ref), v24 (ref), n4 (ref), n5 (ref), v25 (ref), v26 (copy), n6 (ref), n7 (ref), t11 (copy), t12 (copy), advance (ref), settleEntrance (copy)
    local v47

    if not (n6 > n7) then
        v47 = v26[n6]
        v26[n6] = nil
        n6 += 1

        if n6 > n7 then
            n6 = 1
            n7 = 0
        end
    end

    if v47 == nil then
        return
    end

    n2 += 1

    local v50 = n2

    for i = 1, n1 do
        v19[i]:Cancel()
        v19[i] = nil
    end

    n1 = 0
    settleEntrance()

    for i = 1, #t12 do
        local tween = TweenService:Create(t12[i].inst, v16, t12[i].goal)

        n1 += 1
        v19[n1] = tween
        tween:Play()
    end

    task.delay(0.18, function() -- line: 591
        -- upvalues: v47 (ref), v50 (copy), TweenService (copy), Title (copy), ItemName (copy), RarityLabel (copy), Pet (copy), RewardSFX (copy), v1 (ref), v8 (copy), t6 (copy), v17 (copy), v18 (copy), v19 (copy), n1 (ref), n2 (ref), hide (ref), v24 (ref), n4 (ref), n5 (ref), v25 (ref), n6 (ref), n7 (ref), t11 (copy), advance (ref)
        if n2 == v50 and v24 then
            for i = 1, n1 do
                v19[i]:Cancel()
                v19[i] = nil
            end

            n1 = 0

            local v53 = v47 or nil

            if v53 then
                if v53.title then
                    local v54 = tostring(v53.title)
                    local v55 = string.gsub(v54, "&", "&amp;")
                    local v56 = string.gsub(v55, "<", "&lt;")

                    Title.Text = string.gsub(v56, ">", "&gt;")
                end

                if v53.item then
                    local v57 = tostring(v53.item)
                    local v58 = string.gsub(v57, "&", "&amp;")
                    local v59 = string.gsub(v58, "<", "&lt;")

                    ItemName.Text = string.gsub(v59, ">", "&gt;")
                end

                if v53.rarity then
                    local v60 = tostring(v53.rarity)
                    local v61 = string.gsub(v60, "&", "&amp;")
                    local v62 = string.gsub(v61, "<", "&lt;")

                    RarityLabel.Text = string.gsub(v62, ">", "&gt;")
                end

                if v53.image then
                    Pet.Image = v53.image
                end
            end

            Pet.Size = v8

            for i = 1, #t11 do
                local tween = TweenService:Create(t11[i].inst, v17, t11[i].goal)

                n1 += 1
                v19[n1] = tween
                tween:Play()
            end

            local tween = TweenService:Create(Pet, v18, t6)

            n1 += 1
            v19[n1] = tween
            tween:Play()

            if v1 then
                v1:Fire()
            end

            RewardSFX.play("Reward")

            local v63 = v47 or nil

            n4 += 1

            local autoClose = v63 and v63.autoClose or 4

            if not (autoClose <= 0) then
                local v64 = n4

                task.delay(autoClose, function() -- line: 531
                    -- upvalues: v64 (copy), hide (ref), v24 (ref), n4 (ref)
                    if v64 == n4 and v24 then
                        hide()
                    end
                end)
            end

            n5 += 1
            v25 = false

            local v65 = n5

            task.delay(1.2, function() -- line: 542
                -- upvalues: v65 (copy), v24 (ref), n5 (ref), v25 (ref), n6 (ref), n7 (ref), advance (ref)
                if v65 ~= n5 or not v24 then
                    return
                end

                v25 = true

                if n7 - n6 + 1 > 0 then
                    advance()
                end
            end)
        end
    end)
end

function requestNext() -- line: 608
    -- upvalues: hide (ref), v24 (ref), n6 (ref), n7 (ref), advance (ref)
    if v24 then
        if n7 - n6 + 1 > 0 then
            advance()
        else
            hide()
        end
    end
end

local function present(p19) -- line: 619
    -- upvalues: RunService (copy), TweenService (copy), UserInputService (copy), Parent (copy), RewardScreen (copy), Title (copy), ItemName (copy), RarityLabel (copy), Pet (copy), RewardSFX (copy), v1 (ref), t1 (copy), t2 (copy), v7 (copy), t6 (copy), t7 (copy), t9 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), v19 (copy), n1 (ref), n2 (ref), connection (ref), v22 (ref), n3 (ref), onRender (copy), hide (ref), requestNext (ref), v24 (ref), n4 (ref), n5 (ref), v25 (ref), n6 (ref), n7 (ref), resetToHidden (copy), advance (ref)
    n2 += 1

    local v68 = n2
    local v69 = n1

    for i = 1, v69 do
        v19[i]:Cancel()
        v19[i] = nil
    end

    n1 = 0

    if p19 then
        if p19.title then
            local v70 = tostring(p19.title)
            local v71 = string.gsub(v70, "&", "&amp;")
            local v72 = string.gsub(v71, "<", "&lt;")

            Title.Text = string.gsub(v72, ">", "&gt;")
        end

        if p19.item then
            local v73 = tostring(p19.item)
            local v74 = string.gsub(v73, "&", "&amp;")
            local v75 = string.gsub(v74, "<", "&lt;")

            ItemName.Text = string.gsub(v75, ">", "&gt;")
        end

        if p19.rarity then
            local v76 = tostring(p19.rarity)
            local v77 = string.gsub(v76, "&", "&amp;")
            local v78 = string.gsub(v77, "<", "&lt;")

            RarityLabel.Text = string.gsub(v78, ">", "&gt;")
        end

        if p19.image then
            Pet.Image = p19.image
        end
    end

    resetToHidden()
    Parent.Enabled = true
    v24 = true

    local tween = TweenService:Create(RewardScreen, v14, t9)

    n1 += 1
    v19[n1] = tween
    tween:Play()

    for i = 1, #t1 do
        local v79 = t1[i]
        local v80 = if i <= v7 then v9[i] else v10[i - v7]
        local tween = TweenService:Create(v79.inst, v80, v79.goal)

        n1 += 1
        v19[n1] = tween
        tween:Play()
    end

    for i = 1, #t2 do
        local tween = TweenService:Create(t2[i].inst, v11, t2[i].goal)

        n1 += 1
        v19[n1] = tween
        tween:Play()
    end

    local tween2 = TweenService:Create(Pet, v12, t6)

    n1 += 1
    v19[n1] = tween2
    tween2:Play()

    local tween3 = TweenService:Create(Pet, v13, t7)

    n1 += 1
    v19[n1] = tween3
    tween3:Play()

    if not connection then
        n3 = 0
        connection = RunService.RenderStepped:Connect(onRender)
    end

    task.delay(0.25, function() -- line: 655
        -- upvalues: v68 (copy), UserInputService (copy), n2 (ref), v22 (ref), requestNext (ref), v24 (ref)
        if n2 == v68 and v24 then
            if v22 then
                return
            end

            v22 = UserInputService.InputBegan:Connect(function(p20, p21) -- line: 353
                -- upvalues: requestNext (ref)
                if not p21 then
                    local UserInputType = p20.UserInputType

                    if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
                        requestNext()
                    end
                end
            end)
        end
    end)
    task.delay(0.12, function() -- line: 661
        -- upvalues: v68 (copy), RewardSFX (copy), v1 (ref), n2 (ref), v24 (ref)
        if n2 == v68 and v24 then
            if v1 then
                v1:Fire()
            end

            RewardSFX.play("Reward")
        end
    end)
    n4 += 1

    local autoClose = p19 and p19.autoClose or 4

    if not (autoClose <= 0) then
        local v81 = n4

        task.delay(autoClose, function() -- line: 531
            -- upvalues: v81 (copy), hide (ref), v24 (ref), n4 (ref)
            if v81 == n4 and v24 then
                hide()
            end
        end)
    end

    n5 += 1
    v25 = false

    local v82 = n5

    task.delay(1.2, function() -- line: 542
        -- upvalues: v82 (copy), v24 (ref), n5 (ref), v25 (ref), n6 (ref), n7 (ref), advance (ref)
        if v82 ~= n5 or not v24 then
            return
        end

        v25 = true

        if n7 - n6 + 1 > 0 then
            advance()
        end
    end)
end

local function show(p22) -- line: 671
    -- upvalues: v24 (ref), v25 (ref), v26 (copy), n6 (ref), n7 (ref), advance (ref), present (copy)
    if v24 then
        if not (n7 - n6 + 1 >= 8) then
            n7 += 1
            v26[n7] = p22 or false

            if v25 then
                advance()
            end
        end
    else
        present(p22)
    end
end

function hide() -- line: 684
    -- upvalues: TweenService (copy), Parent (copy), RewardScreen (copy), Pet (copy), Glow (copy), Glow2 (copy), v2 (ref), t1 (copy), t2 (copy), PetPosition (copy), t8 (copy), t10 (copy), Rotation (copy), Rotation2 (copy), v15 (copy), v19 (copy), n1 (ref), n2 (ref), connection (ref), v22 (ref), v24 (ref), n4 (ref), n5 (ref), v25 (ref), v26 (copy), n6 (ref), n7 (ref), resetToHidden (copy)
    if not v24 then
        return
    end

    n2 += 1

    local v86 = n2

    n4 += 1
    n5 += 1
    v25 = false
    v24 = false

    for i = n6, n7 do
        v26[i] = nil
    end

    n6 = 1
    n7 = 0

    for i = 1, n1 do
        v19[i]:Cancel()
        v19[i] = nil
    end

    n1 = 0

    if connection then
        connection:Disconnect()
        connection = nil
    end

    Glow.Rotation = Rotation
    Glow2.Rotation = Rotation2
    Pet.Position = PetPosition

    if v22 then
        v22:Disconnect()
        v22 = nil
    end

    if v2 then
        v2:Fire()
    end

    local tween = TweenService:Create(RewardScreen, v15, t10)

    n1 += 1
    v19[n1] = tween
    tween:Play()

    for i = 1, #t1 do
        local v90 = t1[i]
        local tween = TweenService:Create(v90.inst, v15, v90.outGoal)

        n1 += 1
        v19[n1] = tween
        tween:Play()
    end

    for i = 1, #t2 do
        local tween = TweenService:Create(t2[i].inst, v15, t2[i].outGoal)

        n1 += 1
        v19[n1] = tween
        tween:Play()
    end

    local tween2 = TweenService:Create(Pet, v15, t8)

    n1 += 1
    v19[n1] = tween2
    tween2:Play()
    task.delay(0.22, function() -- line: 714
        -- upvalues: v86 (copy), Parent (copy), n2 (ref), resetToHidden (copy)
        if n2 == v86 then
            Parent.Enabled = false
            resetToHidden()
        end
    end)
end

local BindableEvent = Instance.new("BindableEvent")

BindableEvent.Name = "ShowReward"
BindableEvent.Parent = Parent
BindableEvent.Event:Connect(show)

local BindableEvent2 = Instance.new("BindableEvent")

BindableEvent2.Name = "HideReward"
BindableEvent2.Parent = Parent
BindableEvent2.Event:Connect(function() -- line: 734
    -- upvalues: hide (ref)
    hide()
end)

local BindableEvent3 = Instance.new("BindableEvent")

BindableEvent3.Name = "NextReward"
BindableEvent3.Parent = Parent
BindableEvent3.Event:Connect(function() -- line: 741
    -- upvalues: requestNext (ref)
    requestNext()
end)

local connection2

task.spawn(function() -- line: 748
    -- upvalues: ReplicatedStorage (copy), v24 (ref), v25 (ref), v26 (copy), n6 (ref), n7 (ref), advance (ref), present (copy), connection2 (ref)
    connection2 = require(ReplicatedStorage.Shared.Remotes).RewardScreen.Show.OnClientEvent:Connect(function(p23) -- line: 752
        -- upvalues: v24 (ref), v25 (ref), v26 (copy), n6 (ref), n7 (ref), advance (ref), present (copy)
        if typeof(p23) == "table" or p23 == nil then
            if v24 then
                if n7 - n6 + 1 >= 8 then
                    return
                end

                n7 += 1
                v26[n7] = p23 or false

                if v25 then
                    advance()
                end
            else
                present(p23)
            end
        end
    end)
end)
Parent.Enabled = false
resetToHidden()
script.Destroying:Once(function() -- line: 765
    -- upvalues: Pet (copy), Glow (copy), Glow2 (copy), PetPosition (copy), Rotation (copy), Rotation2 (copy), v19 (copy), n1 (ref), n2 (ref), connection (ref), v22 (ref), n4 (ref), n5 (ref), BindableEvent (copy), BindableEvent2 (copy), BindableEvent3 (copy), connection2 (ref)
    n2 += 1
    n4 += 1
    n5 += 1

    for i = 1, n1 do
        v19[i]:Cancel()
        v19[i] = nil
    end

    n1 = 0

    if connection then
        connection:Disconnect()
        connection = nil
    end

    Glow.Rotation = Rotation
    Glow2.Rotation = Rotation2
    Pet.Position = PetPosition

    if v22 then
        v22:Disconnect()
        v22 = nil
    end

    if connection2 then
        connection2:Disconnect()
    end

    BindableEvent:Destroy()
    BindableEvent2:Destroy()
    BindableEvent3:Destroy()
end)
