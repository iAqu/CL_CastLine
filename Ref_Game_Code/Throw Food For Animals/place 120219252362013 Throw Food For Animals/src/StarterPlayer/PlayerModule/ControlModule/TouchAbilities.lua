-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local CommonUtils = require(script.Parent.Parent:WaitForChild("CommonUtils"))
local v1 = require(script.Parent:WaitForChild("AvatarAbilitiesInterface")).get(Players.LocalPlayer)
local InputSlots = require(script.Parent:WaitForChild("InputSlots"))
local FlagUtil = CommonUtils.get("FlagUtil")
local UserAbilitiesUserInterfaceA = FlagUtil.getUserFlag("UserAbilitiesUserInterfaceA")
local UserAbilitiesUserInterfaceC = FlagUtil.getUserFlag("UserAbilitiesUserInterfaceC")
local t1 = {
    {
        small = { 72, 60, 60 },
        large = { 92, 112, 112 }
    },
    {
        small = { 44, 132, 132 },
        large = { 56, 200, 200 }
    },
    {
        small = { 44, 132, 16 },
        large = { 56, 200, 60 }
    },
    {
        small = { 44, 16, 132 },
        large = { 56, 60, 200 }
    },
    {
        small = { 44, 156, 74 },
        large = { 56, 228, 130 }
    },
    {
        small = { 44, 74, 156 },
        large = { 56, 130, 228 }
    },
    {
        small = { 44, 16, 16 },
        large = { 56, 60, 60 }
    }
}
local t2 = {
    28, 44
}
local t3 = {
    36, 56
}
local t4 = {
    16, 12
}
local t5 = {
    16, 12
}

local function IsPortrait() -- line: 52
    -- upvalues: Players (copy)
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui then
        return PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait
    end

    return false
end

local t6 = {}

t6.__index = t6

function t6.new(p1) -- line: 70
    -- upvalues: t6 (copy)
    local self = setmetatable({}, t6)

    self.parentUIFrame = p1
    self.managedButtons = {}
    self.created = false
    self.enabled = false
    self.enabledChangedEvent = Instance.new("BindableEvent")

    return self
end

function t6:Enable(p3) -- line: 83
    if self.enabled == p3 then
        return
    end

    self.enabled = p3

    if p3 and not self.created then
        self:Create()
        self.created = true
    end

    self.enabledChangedEvent:Fire()
end

function t6:CreateAbilityButton(p5, p6, p7, p8, p9) -- line: 95
    -- upvalues: v1 (copy)
    local v3 = "rbxassetid://136780077406114"
    local v4 = "rbxassetid://76895455502876"
    local ButtonInvalidAssetId
    local v5 = false
    local v6

    if p6.ButtonAssetId then
        local ButtonAssetId = p6.ButtonAssetId

        v6 = ButtonAssetId
        v3 = ButtonAssetId
    else
        v6 = "rbxassetid://136780077406114"
    end

    if p6.ButtonPressedAssetId then
        v4 = p6.ButtonPressedAssetId
    end

    if p6.ButtonInvalidAssetId then
        ButtonInvalidAssetId = p6.ButtonInvalidAssetId
    end

    local ImageButton = Instance.new("ImageButton")

    ImageButton.Name = p5 .. "Button"
    ImageButton.Visible = false
    ImageButton.BackgroundTransparency = 1
    ImageButton.Image = v6
    ImageButton.Parent = self.parentUIFrame

    for _, child in p7:GetChildren() do
        if string.find(child.Name, "Touch") and child:IsA("InputBinding") then
            child.UIButton = ImageButton
            break
        end
    end

    local function ResizeButton() -- line: 124
        -- upvalues: self (copy), p8 (copy), p9 (copy), ImageButton (copy)
        local small = math.min(self.parentUIFrame.AbsoluteSize.x, self.parentUIFrame.AbsoluteSize.y) <= 500 and p8.small or p8.large
        local v7 = small[1]
        local v8 = small[2]
        local v9 = small[3]
        local v10 = -v8 - v7

        ImageButton.Size = UDim2.new(0, v7, 0, v7)

        if p9 then
            ImageButton.Position = UDim2.new(1, v10, 0, v9)
        else
            local v11 = -v9 - v7

            ImageButton.Position = UDim2.new(1, v10, 1, v11)
        end
    end

    ResizeButton()

    local t8 = {}

    table.insert(t8, self.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeButton))

    local function UpdateButtonState() -- line: 151
        -- upvalues: self (copy), p5 (copy), p7 (copy), v3 (ref), v4 (ref), ButtonInvalidAssetId (ref), v5 (ref), ImageButton (copy), v1 (copy)
        local AbilityValid = v1:GetAbilityValid(p5)
        local AbilityActive = v1:GetAbilityActive(p5)

        ImageButton.Visible = self.enabled and p7.Enabled

        if ImageButton.Visible then
            if AbilityActive or v5 and AbilityValid then
                ImageButton.Image = v4
                ImageButton.ImageTransparency = 0
            elseif AbilityValid then
                ImageButton.Image = v3
                ImageButton.ImageTransparency = 0
            elseif ButtonInvalidAssetId then
                ImageButton.Image = ButtonInvalidAssetId
                ImageButton.ImageTransparency = 0
            else
                ImageButton.Image = v3
                ImageButton.ImageTransparency = 0.6
            end
        end
    end

    UpdateButtonState()
    ImageButton.MouseButton1Down:Connect(function() -- line: 176
        -- upvalues: v5 (ref), UpdateButtonState (copy)
        v5 = true
        UpdateButtonState()
    end)
    ImageButton.MouseButton1Up:Connect(function() -- line: 181
        -- upvalues: v5 (ref), UpdateButtonState (copy)
        v5 = false
        UpdateButtonState()
    end)
    ImageButton.MouseLeave:Connect(function() -- line: 186
        -- upvalues: v5 (ref), UpdateButtonState (copy)
        v5 = false
        UpdateButtonState()
    end)
    table.insert(t8, v1:GetAbilityActiveChangedSignal(p5):Connect(UpdateButtonState))
    table.insert(t8, v1:GetAbilityValidChangedSignal(p5):Connect(UpdateButtonState))
    table.insert(t8, self.enabledChangedEvent.Event:Connect(UpdateButtonState))
    table.insert(t8, p7:GetPropertyChangedSignal("Enabled"):Connect(UpdateButtonState))
    ImageButton.Destroying:Connect(function() -- line: 196
        -- upvalues: t8 (copy)
        for _, v12 in t8 do
            v12:Disconnect()
        end

        table.clear(t8)
    end)

    return ImageButton
end

function t6:CreateOverflowScrollButton(p11) -- line: 206
    -- upvalues: Players (copy), InputSlots (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy)
    local ImageButton = Instance.new("ImageButton")

    ImageButton.Name = "ScrollButton"
    ImageButton.BackgroundTransparency = 1
    ImageButton.Image = "rbxassetid://120193229129639"
    ImageButton.PressedImage = "rbxassetid://122643389561468"
    ImageButton.Parent = self.parentUIFrame

    local function ResizeButton() -- line: 217
        -- upvalues: self (copy), p11 (copy), ImageButton (copy), Players (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy)
        local v13 = math.min(self.parentUIFrame.AbsoluteSize.x, self.parentUIFrame.AbsoluteSize.y)
        local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local v14 = not not (PlayerGui and PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait)
        local v15, v16, v17, v18

        if v13 <= 500 then
            v15 = t2 or t3
            v16 = t4 or t5
            v17 = 8
            v18 = 44
        else
            v15 = t3
            v16 = t5
            v17 = 10
            v18 = 56
        end

        ImageButton.Size = UDim2.new(0, v15[1], 0, v15[2])

        if p11 then
            if v14 then
                ImageButton.Position = UDim2.new(1, -v16[1] - v15[2] + 0.5 * (v15[2] - v15[1]), 0, v16[2] + v15[1] + 4 * v17 + 3 * v18 - 0.5 * (v15[2] - v15[1]))
                ImageButton.Rotation = 270
            else
                ImageButton.Position = UDim2.new(1, -v16[1] - 2 * v15[1] - 4 * v17 - 3 * v18, 0, v16[2])
                ImageButton.Rotation = 0
            end
        else
            ImageButton.Position = UDim2.new(1, -v16[1] - v15[1], 0, v16[2])

            if v14 then
                ImageButton.Position = UDim2.new(1, -v16[1] - v15[2] + 0.5 * (v15[2] - v15[1]), 0, v16[2] - 0.5 * (v15[2] - v15[1]))
                ImageButton.Rotation = 90
            else
                ImageButton.Position = UDim2.new(1, -v16[1] - v15[1], 0, v16[2])
                ImageButton.Rotation = 180
            end
        end
    end

    ResizeButton()

    local t9 = {}

    table.insert(t9, self.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeButton))
    ImageButton.Activated:Connect(function() -- line: 253
        -- upvalues: p11 (copy), InputSlots (copy)
        if p11 then
            InputSlots.setOverflowScrollIndex(InputSlots.getOverflowScrollIndex() + 1)
        else
            InputSlots.setOverflowScrollIndex(InputSlots.getOverflowScrollIndex() - 1)
        end
    end)
    ImageButton.Destroying:Connect(function() -- line: 261
        -- upvalues: t9 (copy)
        for _, v19 in t9 do
            v19:Disconnect()
        end

        table.clear(t9)
    end)

    return ImageButton
end

function t6:Create() -- line: 271
    -- upvalues: Players (copy), v1 (copy), InputSlots (copy), UserAbilitiesUserInterfaceA (copy), UserAbilitiesUserInterfaceC (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy)
    if self.parentUIFrame then
        local function CreateButtons() -- line: 276
            -- upvalues: self (copy), Players (copy), v1 (copy), InputSlots (copy), UserAbilitiesUserInterfaceA (copy), UserAbilitiesUserInterfaceC (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy)
            for _, v20 in self.managedButtons do
                v20:Destroy()
            end

            self.managedButtons = {}

            if not v1:isEnabled() then
                return
            end

            local v21 = InputSlots.GetSlotMap()

            for v22, v23 in pairs(v21) do
                local v24 = InputSlots.GetActionInSlot(v22)

                if v23 and v24 and v22 <= #t1 and (UserAbilitiesUserInterfaceA or v22 == 1) then
                    local AbilityConfig = v1:GetAbilityConfig(v23)

                    table.insert(self.managedButtons, self:CreateAbilityButton(v23, AbilityConfig, v24, t1[v22], false))
                end
            end

            if UserAbilitiesUserInterfaceA and UserAbilitiesUserInterfaceC then
                local v26 = InputSlots.GetAbilitiesInOverflow()
                local v27, v28

                if #v26 > InputSlots.GetNumOverflowSlots() then
                    if InputSlots.getOverflowScrollIndex() > 0 then
                        table.insert(self.managedButtons, self:CreateOverflowScrollButton(false))
                    end

                    if InputSlots.getOverflowScrollIndex() < #v26 - InputSlots.GetNumOverflowSlots() then
                        table.insert(self.managedButtons, self:CreateOverflowScrollButton(true))
                    end

                    v27 = t2[1] + 8
                    v28 = t3[1] + 10
                else
                    v27 = 0
                    v28 = 0
                end

                for i = 1, math.min(#v26, InputSlots.GetNumOverflowSlots()) do
                    local v30 = v26[i + InputSlots.getOverflowScrollIndex()]
                    local v31 = InputSlots.GetOverflowAction(i)

                    if v30 and v31 then
                        local AbilityConfig = v1:GetAbilityConfig(v30)
                        local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
                        local t10 = if PlayerGui and PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then {
                            small = {
                                44,
                                t4[1],
                                t4[2] + v27 + (i - 1) * 52
                            },
                            large = {
                                56,
                                t5[1],
                                t5[2] + v28 + (i - 1) * 66
                            }
                        } else {
                            small = {
                                44,
                                t4[1] + v27 + (i - 1) * 52,
                                t4[2]
                            },
                            large = {
                                56,
                                t5[1] + v28 + (i - 1) * 66,
                                t5[2]
                            }
                        }

                        table.insert(self.managedButtons, self:CreateAbilityButton(v30, AbilityConfig, v31, t10, true))
                    end
                end
            end
        end

        CreateButtons()
        InputSlots.GetSlotMapChangedSignal():Connect(CreateButtons)
        v1:GetEnabledChangedSignal():Connect(CreateButtons)
        InputSlots.getScrollIndexChangedEvent():Connect(CreateButtons)

        local v32 = Players.LocalPlayer:WaitForChild("PlayerGui", 5)

        if v32 then
            v32:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(CreateButtons)
        end
    end
end

return t6
