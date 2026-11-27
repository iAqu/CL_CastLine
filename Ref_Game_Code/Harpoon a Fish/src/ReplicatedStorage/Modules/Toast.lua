-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RarityStyle = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RarityStyle"))
local Loc = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Loc"))
local t1 = {
    GREEN = Color3.fromRGB(90, 255, 110),
    RED = Color3.fromRGB(255, 95, 95),
    ORANGE = Color3.fromRGB(255, 150, 40)
}
local t2 = {
    equip = {
        id = "rbxassetid://111815218120844",
        pitch = { 0.95, 1.05 }
    },
    deny = {
        id = "rbxassetid://106434292728423",
        pitch = { 0.95, 1.05 }
    },
    steal = {
        id = "rbxassetid://75115925005960",
        pitch = { 0.95, 1.05 }
    }
}
local t3 = {
    FROM = 0.6,
    IN = 0.28,
    HOLD = 1.6,
    OUT = 0.35,
    CENTER_HOLD = 5
}

t1.FEEL = t3

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local ToastGui = PlayerGui:WaitForChild("ToastGui")
local Toast = ToastGui:WaitForChild("Toast")
local Scale = Toast:WaitForChild("Scale")
local Phrase = Toast:WaitForChild("Phrase")
local Fish = Toast:WaitForChild("Fish")

Phrase.AutoLocalize = false
Fish.AutoLocalize = false

local Size, ToastPosition = Toast.Size, Toast.Position

local function promptTop() -- line: 76
    -- upvalues: PlayerGui (copy)
    local DiveGui = PlayerGui:FindFirstChild("DiveGui")

    if not (DiveGui and DiveGui.Enabled) then
        return nil
    end

    local Leave = DiveGui:FindFirstChild("Leave")
    local v1 = if Leave and Leave.Visible then Leave.AbsolutePosition.Y else nil
    local SpaceHint = DiveGui:FindFirstChild("SpaceHint")

    SpaceHint = SpaceHint and SpaceHint.Visible and SpaceHint:FindFirstChild("Hint", true)

    if SpaceHint then
        v1 = math.min(v1 or 1e999, SpaceHint.AbsolutePosition.Y)
    end

    for _, v3 in ipairs({ "Dive", "Equip" }) do
        local v4 = DiveGui:FindFirstChild(v3)

        if v4 and v4.Visible and v4.AbsoluteSize.Y > 1 then
            v1 = math.min(v1 or 1e999, v4.AbsolutePosition.Y)
        end
    end

    return v1
end

local t4 = {}

local function placeToast() -- line: 93
    -- upvalues: ToastGui (copy), Toast (copy), Size (copy), ToastPosition (copy), promptTop (copy), t4 (copy)
    local v6 = promptTop()
    local Y = ToastGui.AbsoluteSize.Y
    local v7 = ToastPosition.Y.Scale * Y + ToastPosition.Y.Offset

    if v6 then
        v7 = math.min(v7, v6 - ToastGui.AbsolutePosition.Y - 0.012 * Y)
    end

    Toast.Position = UDim2.new(ToastPosition.X.Scale, ToastPosition.X.Offset, 0, v7)

    for v9 in pairs(t4) do
        if v9.Parent then
            v9.Position = UDim2.new(Toast.Position.X.Scale, Toast.Position.X.Offset, 0, Toast.Position.Y.Offset - (Size.Y.Scale * Y + Size.Y.Offset) - 0.012 * Y)
        else
            t4[v9] = nil
        end
    end
end

task.spawn(function() -- line: 109
    -- upvalues: PlayerGui (copy), ToastGui (copy), Toast (copy), placeToast (copy)
    local DiveGui = PlayerGui:WaitForChild("DiveGui")

    local function replace() -- line: 111
        -- upvalues: Toast (copy), placeToast (copy)
        if Toast.Visible then
            placeToast()
        end
    end

    for _, v10 in ipairs({ "Leave", "SpaceHint", "Dive", "Equip" }) do
        local v11 = DiveGui:WaitForChild(v10)

        v11:GetPropertyChangedSignal("Visible"):Connect(replace)
        v11:GetPropertyChangedSignal("AbsolutePosition"):Connect(replace)
    end

    ToastGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(replace)
end)

local Center = ToastGui:WaitForChild("Center")
local v12 = Random.new()
local t5 = {}

for v13, v14 in pairs(t2) do
    local Sound = Instance.new("Sound")

    Sound.Name = "Toast_" .. v13
    Sound.SoundId = v14.id
    Sound.Parent = ToastGui
    t5[v13] = Sound
end

local v15 = TweenInfo.new(t3.IN, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v16 = TweenInfo.new(t3.IN * 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v17 = TweenInfo.new(t3.OUT, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local n1 = 0

function t1.Show(p1, p2, p3, p4, p5, p6, p7) -- line: 142
    -- upvalues: TweenService (copy), RarityStyle (copy), Loc (copy), t1 (copy), t2 (copy), t3 (copy), Toast (copy), Scale (copy), Phrase (copy), Fish (copy), Size (copy), placeToast (copy), v12 (copy), t5 (copy), v15 (copy), v16 (copy), v17 (copy), n1 (ref)
    n1 += 1

    local v18 = n1
    local v19 = Loc.T(p1)
    local v20 = p5 and t5[p5]

    if v20 then
        local pitch = t2[p5].pitch

        v20.PlaybackSpeed = v12:NextNumber(pitch[1], pitch[2])
        v20:Play()
    end

    Toast.Size = string.find(v19, "\n", 1, true) and UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * 2, Size.Y.Offset * 2) or Size
    placeToast()
    Phrase.LayoutOrder = p6 and 3 or 1
    Phrase.Text = v19
    Phrase.TextColor3 = p4 or t1.GREEN
    Phrase.UIStroke.Color = RarityStyle.StrokeOf(p4 or t1.GREEN)
    Fish.Text = Loc.T(p2)
    RarityStyle.Apply(Fish, p3 or Color3.new(1, 1, 1))

    local Icon = Toast:FindFirstChild("Icon")

    if Icon then
        Icon.Visible = p7 ~= nil

        if p7 then
            Icon.Image = p7
        end
    end

    Scale.Scale = t3.FROM
    Toast.GroupTransparency = 1
    Toast.Visible = true
    TweenService:Create(Scale, v15, {
        Scale = 1
    }):Play()
    TweenService:Create(Toast, v16, {
        GroupTransparency = 0
    }):Play()
    task.delay(t3.IN + t3.HOLD, function() -- line: 177
        -- upvalues: v18 (copy), TweenService (copy), Toast (copy), v17 (copy), n1 (ref)
        if n1 ~= v18 then
            return
        end

        local tween = TweenService:Create(Toast, v17, {
            GroupTransparency = 1
        })

        tween.Completed:Once(function() -- line: 180
            -- upvalues: v18 (copy), Toast (copy), n1 (ref)
            if n1 == v18 then
                Toast.Visible = false
            end
        end)
        tween:Play()
    end)
end

function t1.ShowAbove(p8, p9) -- line: 188
    -- upvalues: TweenService (copy), RarityStyle (copy), Loc (copy), t3 (copy), ToastGui (copy), Toast (copy), Size (copy), t4 (copy), v15 (copy), v16 (copy), v17 (copy)
    local Y = ToastGui.AbsoluteSize.Y
    local clone = Toast:Clone()

    if clone:FindFirstChild("Icon") then
        clone.Icon:Destroy()
    end

    clone.Name = "ToastAbove"
    clone.Size = Size
    clone.Position = UDim2.new(Toast.Position.X.Scale, Toast.Position.X.Offset, 0, Toast.Position.Y.Offset - (Size.Y.Scale * Y + Size.Y.Offset) - 0.012 * Y)
    clone.Phrase:Destroy()

    local Fish = clone.Fish

    Fish.AutoLocalize = false
    Fish.AutomaticSize = Enum.AutomaticSize.None
    Fish.Size = UDim2.fromScale(1, 1)
    Fish.Text = Loc.T(p8)
    RarityStyle.Apply(Fish, p9 or Color3.new(1, 1, 1))

    local Scale = clone:FindFirstChild("Scale")

    Scale.Scale = t3.FROM
    clone.GroupTransparency = 1
    clone.Visible = true
    clone.Parent = ToastGui
    t4[clone] = true
    TweenService:Create(Scale, v15, {
        Scale = 1
    }):Play()
    TweenService:Create(clone, v16, {
        GroupTransparency = 0
    }):Play()
    task.delay(t3.IN + t3.HOLD, function() -- line: 211
        -- upvalues: clone (copy), TweenService (copy), v17 (copy)
        local tween = TweenService:Create(clone, v17, {
            GroupTransparency = 1
        })

        tween.Completed:Once(function() -- line: 213
            -- upvalues: clone (copy)
            clone:Destroy()
        end)
        tween:Play()
    end)
end

local _ = {
    Y = 0.11,
    W = 0.5
}
local clone = nil

function t1.ShowTop(p10, p11, p12) -- line: 224
    -- upvalues: TweenService (copy), RarityStyle (copy), Loc (copy), t1 (copy), t2 (copy), t3 (copy), ToastGui (copy), Toast (copy), Size (copy), v12 (copy), t5 (copy), v15 (copy), v16 (copy), v17 (copy), clone (ref)
    if clone then
        clone:Destroy()
    end

    local v22 = p12 and t5[p12]

    if v22 then
        local pitch = t2[p12].pitch

        v22.PlaybackSpeed = v12:NextNumber(pitch[1], pitch[2])
        v22:Play()
    end

    local clone2 = Toast:Clone()

    if clone2:FindFirstChild("Icon") then
        clone2.Icon:Destroy()
    end

    clone2.Name = "ToastTop"
    clone2.AnchorPoint = Vector2.new(0.5, 0)
    clone2.Position = UDim2.fromScale(0.5, 0.11)
    clone2.Size = UDim2.fromScale(0.5, Size.Y.Scale)
    clone2.Fish:Destroy()

    local Phrase = clone2.Phrase

    Phrase.AutoLocalize = false
    Phrase.AutomaticSize = Enum.AutomaticSize.None
    Phrase.Size = UDim2.fromScale(1, 1)
    Phrase.Text = Loc.T(p10)
    Phrase.TextColor3 = p11 or t1.GREEN
    Phrase.UIStroke.Color = RarityStyle.StrokeOf(p11 or t1.GREEN)

    local Scale = clone2:FindFirstChild("Scale")

    Scale.Scale = t3.FROM
    clone2.GroupTransparency = 1
    clone2.Visible = true
    clone2.Parent = ToastGui
    clone = clone2
    TweenService:Create(Scale, v15, {
        Scale = 1
    }):Play()
    TweenService:Create(clone2, v16, {
        GroupTransparency = 0
    }):Play()
    task.delay(t3.IN + t3.HOLD, function() -- line: 255
        -- upvalues: clone2 (copy), TweenService (copy), v17 (copy), clone (ref)
        if clone ~= clone2 then
            return
        end

        local tween = TweenService:Create(clone2, v17, {
            GroupTransparency = 1
        })

        tween.Completed:Once(function() -- line: 258
            -- upvalues: clone2 (copy), clone (ref)
            clone2:Destroy()

            if clone == clone2 then
                clone = nil
            end
        end)
        tween:Play()
    end)
end

local function fitCenter() -- line: 266
    -- upvalues: Size (copy), Center (copy)
    local t6 = {}

    for _, child in ipairs(Center:GetChildren()) do
        if child:IsA("CanvasGroup") then
            t6[#t6 + 1] = child
        end
    end

    local v23 = #t6

    if v23 == 0 then
        return
    end

    local UIListLayout = Center:FindFirstChildOfClass("UIListLayout")
    local Scale = UIListLayout and UIListLayout.Padding.Scale or 0
    local v26 = math.min(Size.Y.Scale / Center.Size.Y.Scale, (1 - (v23 - 1) * Scale) / v23)

    for _, v27 in ipairs(t6) do
        v27.Size = UDim2.fromScale(1, v26)
    end
end

Center.ChildRemoved:Connect(fitCenter)

function t1.ShowCenter(p13, p14, p15) -- line: 285
    -- upvalues: Players (copy), TweenService (copy), RarityStyle (copy), t3 (copy), Toast (copy), Size (copy), Center (copy), v15 (copy), v16 (copy), v17 (copy), fitCenter (copy)
    if Players.LocalPlayer:GetAttribute("TitanRiding") or Players.LocalPlayer:GetAttribute("TurkeyRun") ~= nil then
        return nil
    end

    local clone = Toast:Clone()

    if clone:FindFirstChild("Icon") then
        clone.Icon:Destroy()
    end

    clone.AnchorPoint = Vector2.zero
    clone.Position = UDim2.new()
    clone.Size = UDim2.fromScale(1, Size.Y.Scale / Center.Size.Y.Scale)
    clone.LayoutOrder = p15 or 0
    clone.Phrase:Destroy()

    local Fish = clone.Fish

    Fish.AutoLocalize = false
    Fish.AutomaticSize = Enum.AutomaticSize.None
    Fish.Size = UDim2.fromScale(1, 1)
    Fish.Text = p13
    RarityStyle.Apply(Fish, p14 or Color3.new(1, 1, 1))

    local Scale = clone:FindFirstChild("Scale")

    Scale.Scale = t3.FROM
    clone.GroupTransparency = 1
    clone.Visible = true
    clone.Parent = Center
    fitCenter()
    TweenService:Create(Scale, v15, {
        Scale = 1
    }):Play()
    TweenService:Create(clone, v16, {
        GroupTransparency = 0
    }):Play()
    task.delay(t3.IN + t3.CENTER_HOLD, function() -- line: 312
        -- upvalues: clone (copy), TweenService (copy), v17 (copy)
        local tween = TweenService:Create(clone, v17, {
            GroupTransparency = 1
        })

        tween.Completed:Once(function() -- line: 314
            -- upvalues: clone (copy)
            clone:Destroy()
        end)
        tween:Play()
    end)

    return clone
end

return t1
