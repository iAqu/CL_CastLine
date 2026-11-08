-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Confetti = require(ReplicatedStorage.Client.UI.VFX.Confetti)
local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)
local SwapGradient = require(ReplicatedStorage.Shared.Utils.SwapGradient)
local MonsterParasite = require(ReplicatedStorage.Data.MonsterParasite)
local MonsterParasite2 = require(ReplicatedStorage.Shared.Types.MonsterParasite)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local Rarities = require(ReplicatedStorage.Data.Rarity).Rarities
local Spring = require(ReplicatedStorage.Packages.Spring)
local Trove = require(ReplicatedStorage.Packages.Trove)
local _ = {
    Fallback = "rbxassetid://116351329433541",
    Glow = "rbxassetid://109516122757226",
    GlowScale = 1.1,
    GlowTransparency = 0.45,
    CenterY = 0.3,
    Size = 0.54
}
local v1 = Random.new()
local v2 = assert(Players.LocalPlayer, "Crate spinner requires a local player")
local v3 = false
local t1 = {}

local function waitForChild(p1, p2) -- line: 74
    local v4 = p1:WaitForChild(p2, 5)

    assert(v4 ~= nil, (("%*.%* did not load"):format(p1:GetFullName(), p2)))

    return v4
end

local function getView() -- line: 80
    -- upvalues: v2 (copy)
    local v7 = v2:WaitForChild("PlayerGui", 5)

    assert(v7 ~= nil, (("%*.PlayerGui did not load"):format((v2:GetFullName()))))

    local v10 = v7:WaitForChild("CrateOpeningPopUpFrame", 5)

    assert(v10 ~= nil, (("%*.CrateOpeningPopUpFrame did not load"):format((v7:GetFullName()))))
    assert(v10:IsA("ScreenGui"), "CrateOpeningPopUpFrame must be a ScreenGui")

    local v13 = v10:WaitForChild("CrateOpeningPopUp", 5)

    assert(v13 ~= nil, (("%*.CrateOpeningPopUp did not load"):format((v10:GetFullName()))))
    assert(v13:IsA("GuiObject"), "CrateOpeningPopUp must be a GuiObject")

    local v16 = v13:WaitForChild("Main", 5)

    assert(v16 ~= nil, (("%*.Main did not load"):format((v13:GetFullName()))))
    assert(v16:IsA("Frame"), "CrateOpeningPopUp.Main must be a Frame")

    local v19 = v16:WaitForChild("Holder", 5)

    assert(v19 ~= nil, (("%*.Holder did not load"):format((v16:GetFullName()))))
    assert(v19:IsA("Frame"), "CrateOpeningPopUp.Main.Holder must be a Frame")

    local v22 = v19:WaitForChild("GenericFrameTemplate", 5)

    assert(v22 ~= nil, (("%*.GenericFrameTemplate did not load"):format((v19:GetFullName()))))
    assert(v22:IsA("Frame"), "GenericFrameTemplate must be a Frame")

    local v25 = v19:WaitForChild("SpecialFrameTemplate", 5)

    assert(v25 ~= nil, (("%*.SpecialFrameTemplate did not load"):format((v19:GetFullName()))))
    assert(v25:IsA("Frame"), "SpecialFrameTemplate must be a Frame")

    local v28 = v19:WaitForChild("UIListLayout", 5)

    assert(v28 ~= nil, (("%*.UIListLayout did not load"):format((v19:GetFullName()))))
    assert(v28:IsA("UIListLayout"), "Holder.UIListLayout must be a UIListLayout")

    local v31 = v19:WaitForChild("UIPadding", 5)

    assert(v31 ~= nil, (("%*.UIPadding did not load"):format((v19:GetFullName()))))
    assert(v31:IsA("UIPadding"), "Holder.UIPadding must be a UIPadding")

    local v34 = v13:WaitForChild("Skip", 5)

    assert(v34 ~= nil, (("%*.Skip did not load"):format((v13:GetFullName()))))
    assert(v34:IsA("ImageButton"), "CrateOpeningPopUp.Skip must be an ImageButton")

    local v37 = v13:WaitForChild("Arrow", 5)

    assert(v37 ~= nil, (("%*.Arrow did not load"):format((v13:GetFullName()))))
    assert(v37:IsA("ImageLabel"), "CrateOpeningPopUp.Arrow must be an ImageLabel")

    local v40 = v13:WaitForChild("RewardTitleFrame", 5)

    assert(v40 ~= nil, (("%*.RewardTitleFrame did not load"):format((v13:GetFullName()))))
    assert(v40:IsA("Frame"), "RewardTitleFrame must be a Frame")

    local v43 = v40:WaitForChild("RewardName", 5)

    assert(v43 ~= nil, (("%*.RewardName did not load"):format((v40:GetFullName()))))
    assert(v43:IsA("TextLabel"), "RewardTitleFrame.RewardName must be a TextLabel")
    assert(v28.FillDirection == Enum.FillDirection.Horizontal and v28.SortOrder == Enum.SortOrder.LayoutOrder and not v28.Wraps, "Holder.UIListLayout must be a single horizontal row sorted by LayoutOrder")

    return {
        Arrow = v37,
        GenericTemplate = v22,
        Holder = v19,
        Layout = v28,
        Main = v16,
        Padding = v31,
        Popup = v13,
        RewardName = v43,
        RewardTitle = v40,
        Screen = v10,
        Skip = v34,
        SpecialTemplate = v25
    }
end

local function pickRewardId() -- line: 145
    -- upvalues: MonsterParasite (copy), v1 (copy)
    local v47 = v1:NextNumber(0, 100)
    local n1 = 0

    for _, v48 in MonsterParasite.Rewards do
        n1 += v48.Weight

        if v47 <= n1 then
            return v48.Id
        end
    end

    return MonsterParasite.Rewards[#MonsterParasite.Rewards].Id
end

local function buildRewardIds(p3, p4) -- line: 157
    -- upvalues: pickRewardId (copy)
    local v49 = table.create(36)

    for i = 1, 36 do
        if i == p4 then
            v49[i] = p3
        else
            v49[i] = pickRewardId()
        end
    end

    return v49
end

local function ensureCardImage(p5, p6, p7, p8, p9) -- line: 174
    local v50 = p5:FindFirstChild(p6)

    if v50 ~= nil and v50:IsA("ImageLabel") then
        return v50
    end

    if v50 ~= nil then
        v50:Destroy()
    end

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = p6
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.fromScale(0.5, 0.3)
    ImageLabel.ScaleType = p9
    ImageLabel.Size = UDim2.fromScale(p8, p8)
    ImageLabel.ZIndex = p7
    ImageLabel.Parent = p5

    return ImageLabel
end

local function setFrameText(p10, p11) -- line: 201
    -- upvalues: SwapGradient (copy), MonsterParasite (copy), MonsterParasite2 (copy), Rarities (copy), ensureCardImage (copy)
    local ItemName = p10:FindFirstChild("ItemName")

    assert(ItemName and ItemName:IsA("TextLabel"), "Reward frame requires ItemName")

    local RarityLabel = p10:FindFirstChild("RarityLabel")

    assert(RarityLabel and RarityLabel:IsA("TextLabel"), "Reward frame requires RarityLabel")

    local v53 = MonsterParasite.GetReward(p11)

    ItemName.Text = MonsterParasite.RewardLabel(v53)

    local Rarity = v53.Rarity

    RarityLabel.Text = Rarity

    if p11 == MonsterParasite2.RewardIds.MonsterEgg then
        Rarity = "Prismatic"
    end

    local v56 = assert(Rarities[Rarity], (("Unknown Monster Chest rarity: %*"):format(Rarity)))

    SwapGradient(RarityLabel, v56.RarityGradient)

    local UIStroke = RarityLabel:FindFirstChildOfClass("UIStroke")

    if UIStroke ~= nil then
        SwapGradient(UIStroke, v56.RarityGradient)
    end

    local v57 = ensureCardImage(p10, "Glow", 2, 0.5940000000000001, Enum.ScaleType.Stretch)

    v57.Image = "rbxassetid://109516122757226"
    v57.ImageTransparency = 0.45
    v57.ImageColor3 = v56.RarityGradient.Color.Keypoints[1].Value
    v57.Visible = true

    local v58 = ensureCardImage(p10, "Icon", 3, 0.54, Enum.ScaleType.Fit)
    local FallbackIcon = p10:GetAttribute("FallbackIcon")
    local Icon = v53.Icon

    if not Icon then
        Icon = if typeof(FallbackIcon) == "string" then FallbackIcon else "rbxassetid://116351329433541"
    end

    v58.Image = Icon
    v58.Visible = true
end

local function buildFrames(p12, p13, p14, p15) -- line: 257
    -- upvalues: MonsterParasite2 (copy), setFrameText (copy)
    local v59 = table.create(#p14)
    local MonsterEgg = MonsterParasite2.RewardIds.MonsterEgg

    for v60, v61 in p14 do
        local v62 = if v61 == MonsterEgg then p12.SpecialTemplate else p12.GenericTemplate
        local Frame = Instance.new("Frame")

        Frame.Name = ("RewardSlot%*"):format(v60)
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        Frame.LayoutOrder = v60
        Frame.Size = UDim2.fromOffset(p15, p15)
        Frame.Parent = p12.Holder
        p13:Add(Frame)

        local clone = v62:Clone()

        clone.Name = ("RewardFrame%*"):format(v60)
        clone.AnchorPoint = Vector2.new(0.5, 0.5)
        clone.Position = UDim2.fromScale(0.5, 0.5)
        clone.Size = UDim2.fromScale(1, 1)
        clone.Visible = true
        setFrameText(clone, v61)

        local UIScale = clone:FindFirstChildOfClass("UIScale")

        assert(UIScale ~= nil, "Reward frame requires UIScale")
        UIScale.Scale = 0.7
        clone.Parent = Frame
        v59[v60] = {
            Scale = UIScale,
            Slot = Frame
        }
    end

    return v59
end

local function spinCurve(p16) -- line: 298
    if p16 < 0.055 then
        local v64 = p16 / 0.055

        return v64 ^ 2 * (v64 * 0.6772486772486772 + 0.3227513227513228) * 0.08
    end

    return (1 - (1 - (p16 - 0.055) / 0.945) ^ 4) * 0.92 + 0.08
end

local function formatReward(p17) -- line: 320
    -- upvalues: MonsterParasite2 (copy), Mutations (copy)
    if p17.Id ~= MonsterParasite2.RewardIds.MonsterEgg or p17.Egg == nil then
        return p17.DisplayName
    end

    return (("x1 %* %*"):format(Mutations.LabelOf(p17.Egg.Mutation), p17.Egg.AssetCategory))
end

local function playTween(p18, p19, p20) -- line: 330
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p18, p19, p20)

    tween:Play()
    tween.Completed:Wait()
end

local function runPresentation(p21, p22, p23) -- line: 340
    -- upvalues: GuiService (copy), RunService (copy), TweenService (copy), Audio (copy), Confetti (copy), MenuNavigation (copy), MonsterParasite2 (copy), Mutations (copy), Spring (copy), v1 (copy), buildRewardIds (copy), buildFrames (copy)
    local v65 = assert(p22.Reward, "Successful Monster Chest result requires a reward")

    p21.Screen.DisplayOrder = math.max(p21.Screen.DisplayOrder, 200)
    p21.Screen.ResetOnSpawn = false
    p21.Popup.Visible = false
    p21.Main.Visible = false
    p21.RewardTitle.Visible = false
    p21.Skip.Visible = true
    p21.Skip.Active = true
    p21.GenericTemplate.Visible = false
    p21.SpecialTemplate.Visible = false

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "CrateOpeningRuntimeScale"
    UIScale.Scale = 1
    UIScale.Parent = p21.Popup
    p23:Add(UIScale)
    RunService.Heartbeat:Wait()

    local v66 = math.max(p21.Main.AbsoluteSize.X, 1)
    local v67 = math.max(p21.Main.AbsoluteSize.Y, 1)
    local v68 = v66 * 0.176
    local v69 = v66 * 0.01
    local v71 = math.max(8, v66 * 0.01)
    local v72 = v1:NextInteger(29, 33)
    local v73 = buildRewardIds(v65.Id, v72)

    p21.Layout.Padding = UDim.new(0, v69)
    p21.Padding.PaddingLeft = UDim.new(0, v71)
    p21.Padding.PaddingRight = UDim.new(0, v71)
    p21.Holder.Size = UDim2.fromOffset(v71 * 2 + v68 * 36 + v69 * 35, v67)
    p21.Holder.Position = UDim2.fromOffset(0, 0)

    local v74 = buildFrames(p21, p23, v73, v68)

    RunService.Heartbeat:Wait()

    local v75 = p21.Arrow.AbsolutePosition.X + p21.Arrow.AbsoluteSize.X * 0.5
    local Slot = v74[v72].Slot
    local v76 = v75 - (Slot.AbsolutePosition.X + Slot.AbsoluteSize.X * 0.5)
    local SelectedObject = GuiService.SelectedObject
    local Active, ZIndex, SelectionGroup, SelectionBehaviorDown = p21.Popup.Active, p21.Popup.ZIndex, p21.Popup.SelectionGroup, p21.Popup.SelectionBehaviorDown
    local SelectionBehaviorLeft, SelectionBehaviorRight, SelectionBehaviorUp = p21.Popup.SelectionBehaviorLeft, p21.Popup.SelectionBehaviorRight, p21.Popup.SelectionBehaviorUp
    local Active2 = p21.Main.Active
    local Selectable = p21.RewardTitle.Selectable
    local Modal, Selectable2 = p21.Skip.Modal, p21.Skip.Selectable

    p23:Add(function() -- line: 404
        -- upvalues: p21 (copy), SelectedObject (copy), Active (copy), ZIndex (copy), SelectionGroup (copy), SelectionBehaviorDown (copy), SelectionBehaviorLeft (copy), SelectionBehaviorRight (copy), SelectionBehaviorUp (copy), Active2 (copy), Selectable (copy), Modal (copy), Selectable2 (copy), GuiService (copy)
        if GuiService.SelectedObject == p21.Skip then
            GuiService.SelectedObject = SelectedObject
        end

        p21.Popup.Active = Active
        p21.Popup.ZIndex = ZIndex
        p21.Popup.SelectionGroup = SelectionGroup
        p21.Popup.SelectionBehaviorDown = SelectionBehaviorDown
        p21.Popup.SelectionBehaviorLeft = SelectionBehaviorLeft
        p21.Popup.SelectionBehaviorRight = SelectionBehaviorRight
        p21.Popup.SelectionBehaviorUp = SelectionBehaviorUp
        p21.Main.Active = Active2
        p21.RewardTitle.Selectable = Selectable
        p21.Skip.Modal = Modal
        p21.Skip.Selectable = Selectable2
    end)

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "CrateOpeningInputBlocker"
    TextButton.Active = true
    TextButton.AutoButtonColor = false
    TextButton.BackgroundTransparency = 1
    TextButton.Modal = true
    TextButton.Selectable = false
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.Text = ""
    TextButton.ZIndex = 1
    TextButton.Parent = p21.Screen
    p23:Add(TextButton)
    p21.Popup.Active = true
    p21.Popup.ZIndex = math.max(2, ZIndex)
    p21.Popup.SelectionGroup = true
    p21.Popup.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
    p21.Popup.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
    p21.Popup.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
    p21.Popup.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
    p21.Main.Active = true
    p21.RewardTitle.Selectable = false
    p21.Skip.Modal = true
    p21.Skip.Selectable = true

    if not MenuNavigation.IsCursorActive() then
        GuiService.SelectedObject = p21.Skip
    end

    UIScale.Scale = 0.86
    p21.Popup.Visible = true
    p21.Main.Visible = true
    TweenService:Create(UIScale, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()

    local v77 = false

    MenuNavigation.SetOverride("CrateOpening", p21.Popup, p21.Skip, function() -- line: 456
        -- upvalues: p21 (copy), v77 (ref)
        v77 = true
        p21.Skip.Active = false
    end, 2000, true)
    p23:Add(function() -- line: 460
        -- upvalues: MenuNavigation (copy)
        MenuNavigation.SetOverride("CrateOpening", nil)
    end)
    p23:Connect(p21.Skip.Activated, function() -- line: 461
        -- upvalues: p21 (copy), v77 (ref)
        v77 = true
        p21.Skip.Active = false
    end)

    local Rotation = p21.Arrow.Rotation
    local v78 = Spring.new(0)

    v78.Speed = 19
    v78.Damper = 0.58

    local v79 = table.create(#v74)

    local function renderOffset(p24, p25) -- line: 472
        -- upvalues: p21 (copy), v74 (copy), Rotation (copy), v78 (copy), v79 (copy), Audio (copy)
        p21.Holder.Position = UDim2.fromOffset(p24, 0)

        for v80, v81 in v74 do
            local v82 = p21.Arrow.AbsolutePosition.X + p21.Arrow.AbsoluteSize.X * 0.5
            local v83 = v81.Slot.AbsolutePosition.X + v81.Slot.AbsoluteSize.X * 0.5
            local v89 = math.lerp(1, 0.7, (math.clamp(math.abs(v83 - v82) / math.max(p21.Main.AbsoluteSize.X * 0.5, 1), 0, 1)))

            v81.Scale.Scale = v89

            local v90 = v83 - v81.Slot.AbsoluteSize.X * v89 * 0.5

            if p25 then
                local v91 = v79[v80]

                if v91 and v82 < v91 and v90 <= v82 then
                    Audio.Play("rbxassetid://137872392480008", script, {
                        Volume = 0.72,
                        PlaybackSpeed = { 0.97, 1.03 }
                    })
                    v78:Impulse(24 * v78.Speed)
                end
            end

            v79[v80] = v90
        end

        p21.Arrow.Rotation = Rotation + math.clamp(v78.Position, -24, 24)
    end

    renderOffset(0, false)

    local v92 = if v1:NextNumber() < 0.5 then -1 else 1
    local v93 = v76 + v68 * v1:NextNumber(0.1, 0.19) * v92
    local v94 = v1:NextNumber(3, 6)
    local elapsed = os.clock()
    local n2 = 0
    local n3 = 0
    local elapsed2

    while true do
        local elapsed3 = os.clock()

        if v77 and elapsed2 == nil then
            n2 = n3
            elapsed2 = elapsed3
        end

        local v95

        if elapsed2 then
            local v97 = math.clamp((elapsed3 - elapsed2) / 0.55, 0, 1)

            n3 = math.lerp(n2, v93, 1 - (1 - v97) ^ 5)
            v95 = v97 >= 1
        else
            local v100 = math.clamp((elapsed3 - elapsed) / v94, 0, 1)
            local v101

            if v100 < 0.055 then
                local v102 = v100 / 0.055

                v101 = v102 ^ 2 * (v102 * 0.6772486772486772 + 0.3227513227513228) * 0.08
            else
                v101 = (1 - (1 - (v100 - 0.055) / 0.945) ^ 4) * 0.92 + 0.08
            end

            n3 = math.lerp(0, v93, v101)
            v95 = v100 >= 1
        end

        renderOffset(n3, true)

        if v95 then
            break
        end

        RunService.RenderStepped:Wait()
    end

    task.wait(0.1)

    local v103 = p21.Arrow.AbsolutePosition.X + p21.Arrow.AbsoluteSize.X * 0.5
    local v104 = Slot.AbsolutePosition.X + Slot.AbsoluteSize.X * 0.5
    local v105 = n3 + v103 - v104
    local elapsed3 = os.clock()

    while true do
        local v107 = math.clamp((os.clock() - elapsed3) / 0.48, 0, 1)

        renderOffset(math.lerp(v93, v105, (TweenService:GetValue(v107, Enum.EasingStyle.Back, Enum.EasingDirection.Out))), false)

        if v107 >= 1 then
            break
        end

        RunService.RenderStepped:Wait()
    end

    renderOffset(v105, false)
    p21.Skip.Visible = false

    local RewardName = p21.RewardName

    if v65.Id ~= MonsterParasite2.RewardIds.MonsterEgg or v65.Egg == nil then
        RewardName.Text = v65.DisplayName
    else
        RewardName.Text = ("x1 %* %*"):format(Mutations.LabelOf(v65.Egg.Mutation), v65.Egg.AssetCategory)
    end

    p21.RewardTitle.Visible = true

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Scale = 0.55
    UIScale2.Parent = p21.RewardTitle
    p23:Add(UIScale2)

    local Scale = v74[v72].Scale

    Scale.Scale = 1

    local tween = TweenService:Create(UIScale2, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    })

    tween:Play()
    TweenService:Create(Scale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1.16
    }):Play()
    tween.Completed:Wait()
    Confetti.Burst()

    local tween2 = TweenService:Create(Scale, TweenInfo.new(0.34, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Scale = 1.04
    })

    tween2:Play()
    tween2.Completed:Wait()
    task.wait(0.85)

    local tween3 = TweenService:Create(UIScale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Scale = 0.9
    })

    tween3:Play()
    tween3.Completed:Wait()
    p21.Arrow.Rotation = Rotation
end

function t1.Play(p26) -- line: 610
    -- upvalues: Trove (copy), v3 (ref), getView (copy), runPresentation (copy)
    assert(p26.Success and p26.Reward ~= nil, "Crate spinner requires a successful reward")

    if v3 then
        return
    end

    v3 = true

    local v111 = Trove.new()
    local v112, Rotation

    local function v113() -- line: 623
        -- upvalues: p26 (copy), v111 (copy), v112 (ref), Rotation (ref), getView (copy), runPresentation (copy)
        local v114 = getView()

        v112 = v114
        Rotation = v114.Arrow.Rotation
        runPresentation(v114, p26, v111)
    end

    local traceback = debug.traceback
    local v115, v116 = xpcall(v113, traceback)

    if v112 ~= nil then
        v112.Popup.Visible = false
        v112.Main.Visible = false
        v112.RewardTitle.Visible = false
        v112.Skip.Active = false

        if Rotation ~= nil then
            v112.Arrow.Rotation = Rotation
        end
    end

    v111:Destroy()
    v3 = false

    if not v115 then
        error(v116, 2)
    end
end

return table.freeze(t1)
