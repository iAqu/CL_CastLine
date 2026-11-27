-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local ConnectionUtil = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("ConnectionUtil")
local v1 = require(script.Parent:WaitForChild("AvatarAbilitiesInterface")).get(Players.LocalPlayer)
local InputSlots = require(script.Parent:WaitForChild("InputSlots"))
local AbilityButton = require(script.Parent:WaitForChild("AbilityButton"))
local t1 = {
    28, 44
}
local t2 = {
    36, 56
}
local t3 = {
    16, 12
}
local t4 = {
    16, 12
}

local function IsPortrait() -- line: 32
    -- upvalues: Players (copy)
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui then
        return PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait
    end

    return false
end

local t5 = {}

t5.__index = t5

function t5.new(p1) -- line: 49
    -- upvalues: ConnectionUtil (copy), t5 (copy)
    local self = setmetatable({}, t5)

    self.parentUIFrame = p1
    self.managedButtons = {}
    self.created = false
    self.enabled = false
    self.enabledChangedEvent = Instance.new("BindableEvent")
    self.selectionMode = false
    self.selectedVisibleSlot = 1
    self.numVisibleSlots = 0
    self.abilityButtonsByVisibleSlot = {}
    self.selectionRing = nil
    self.activeActionSlot = nil
    self.activeButton = nil
    self.scrollHighlightDirection = "none"
    self.connections = ConnectionUtil.new()
    self.inputFolder = nil
    self.navContext = nil

    return self
end

function t5:Enable(p3) -- line: 74
    if self.enabled == p3 then
        return
    end

    self.enabled = p3

    if p3 and not self.created then
        self:Create()
        self.created = true
    end

    if not p3 then
        self:ExitSelectionMode()
    end

    if self.created then
        self:UpdateInputMode()
    end

    self.enabledChangedEvent:Fire()
end

function t5:CreateOverflowScrollButton(p5) -- line: 96
    -- upvalues: Players (copy), ConnectionUtil (copy), InputSlots (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy)
    local ImageButton = Instance.new("ImageButton")

    ImageButton.Name = "ScrollButton"
    ImageButton.BackgroundTransparency = 1
    ImageButton.Image = "rbxassetid://120193229129639"
    ImageButton.PressedImage = "rbxassetid://122643389561468"
    ImageButton.Parent = self.parentUIFrame

    local function ResizeButton() -- line: 104
        -- upvalues: self (copy), p5 (copy), ImageButton (copy), Players (copy), InputSlots (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy)
        local v3 = math.min(self.parentUIFrame.AbsoluteSize.x, self.parentUIFrame.AbsoluteSize.y)
        local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local v4 = not not (PlayerGui and PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait)
        local v5, v6, v7, v8

        if v3 <= 500 then
            v5 = t1 or t2
            v6 = t3 or t4
            v8 = 8
            v7 = 44
        else
            v5 = t2
            v6 = t4
            v8 = 10
            v7 = 56
        end

        local v9 = v5[1]
        local v10 = v5[2]
        local v11 = v6[1]
        local v12 = v6[2]
        local v13 = 0.5 * (v10 - v9)
        local v14 = InputSlots.GetNumOverflowSlots()
        local v15 = v14 * v7 + (v14 + 1) * v8

        ImageButton.Size = UDim2.new(0, v9, 0, v10)

        if p5 == "previous" then
            if v4 then
                ImageButton.Position = UDim2.new(1, -v11 - v10 + v13, 0, v12 + v9 + v15 - v13)
                ImageButton.Rotation = 270
            else
                ImageButton.Position = UDim2.new(1, -v11 - 2 * v9 - v15, 0, v12)
                ImageButton.Rotation = 0
            end
        elseif v4 then
            ImageButton.Position = UDim2.new(1, -v11 - v10 + v13, 0, v12 - v13)
            ImageButton.Rotation = 90
        else
            ImageButton.Position = UDim2.new(1, -v11 - v9, 0, v12)
            ImageButton.Rotation = 180
        end
    end

    ResizeButton()

    local v16 = ConnectionUtil.new()

    v16:trackConnection("ParentResize", self.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeButton))
    ImageButton.Activated:Connect(function() -- line: 161
        -- upvalues: p5 (copy), InputSlots (copy)
        if p5 == "previous" then
            InputSlots.setOverflowScrollIndex(InputSlots.getOverflowScrollIndex() + 1)
        else
            InputSlots.setOverflowScrollIndex(InputSlots.getOverflowScrollIndex() - 1)
        end
    end)
    ImageButton.Destroying:Connect(function() -- line: 169
        -- upvalues: v16 (copy)
        v16:disconnectAll()
    end)
    ImageButton.Selectable = false

    if t5.IsGamepad() then
        ImageButton.Active = false
        ImageButton.AutoButtonColor = false
    end

    return ImageButton
end

function t5:SetScrollHighlight(p7) -- line: 183
    if self.scrollHighlightDirection ~= p7 then
        self.scrollHighlightDirection = p7

        if self.created then
            self:CreateButtons()
        end
    end
end

function t5:GetScrollDirectionForMove(p9) -- line: 193
    -- upvalues: InputSlots (copy)
    local v17

    if not self.selectionMode or self.activeActionSlot or p9 == "none" then
        return "none"
    else
        v17 = if p9 == "previous" then 1 else -1
    end

    local v20 = math.max(0, #InputSlots.GetAbilitiesInOverflow() - InputSlots.GetNumOverflowSlots())
    local v21 = InputSlots.getOverflowScrollIndex()
    local v22 = self.selectedVisibleSlot + v17

    if v22 < 1 and v21 > 0 then
        return "next"
    end

    if not (self.numVisibleSlots < v22 and v21 < v20) then
        return "none"
    end

    return "previous"
end

function t5.IsGamepad() -- line: 212
    -- upvalues: UserInputService (copy)
    return UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
end

function t5.IsKeyboardMouse() -- line: 216
    -- upvalues: UserInputService (copy)
    return UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse
end

function t5.SupportsSelection() -- line: 220
    -- upvalues: t5 (copy)
    return t5.IsGamepad() or t5.IsKeyboardMouse()
end

function t5:EnsureSelectionRing() -- line: 224
    if self.selectionRing then
        return
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "SelectionRing"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(1, 8, 1, 8)
    Frame.Position = UDim2.new(0, -4, 0, -4)

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Color = Color3.new(1, 1, 1)
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame
    self.selectionRing = Frame
end

function t5:EnsureInputObjects() -- line: 248
    if self.inputFolder then
        return
    end

    local AbilitiesOverflowInput = script:FindFirstChild("AbilitiesOverflowInput")

    if AbilitiesOverflowInput then
        AbilitiesOverflowInput:Destroy()
    end

    local Folder = Instance.new("Folder")

    Folder.Name = "AbilitiesOverflowInput"

    local InputContext = Instance.new("InputContext")

    InputContext.Name = "AbilitiesOverflowNavContext"
    InputContext.Priority = 500
    InputContext.Sink = true
    InputContext.Enabled = false
    InputContext.Parent = Folder

    local function createNavAction(p12, p13) -- line: 268
        -- upvalues: InputContext (copy)
        local InputAction = Instance.new("InputAction")

        InputAction.Name = p12
        InputAction.Type = Enum.InputActionType.Bool
        InputAction.Parent = InputContext

        for v23, v24 in p13 do
            local InputBinding = Instance.new("InputBinding")

            InputBinding.Name = "Binding" .. v23
            InputBinding.KeyCode = v24
            InputBinding.Parent = InputAction
        end

        return InputAction
    end

    local v25 = createNavAction("NavPreviousAction", {
        Enum.KeyCode.ButtonL1,
        Enum.KeyCode.DPadLeft,
        Enum.KeyCode.Left
    })

    self.connections:trackConnection("NavPrevious", v25.StateChanged:Connect(function(p14) -- line: 288
        -- upvalues: self (copy)
        if p14 then
            self:SetScrollHighlight(self:GetScrollDirectionForMove("previous"))
        else
            self:SetScrollHighlight("none")
            self:MoveSelection("previous")
        end
    end))

    local v26 = createNavAction("NavNextAction", {
        Enum.KeyCode.ButtonR1,
        Enum.KeyCode.DPadRight,
        Enum.KeyCode.Right
    })

    self.connections:trackConnection("NavNext", v26.StateChanged:Connect(function(p15) -- line: 302
        -- upvalues: self (copy)
        if p15 then
            self:SetScrollHighlight(self:GetScrollDirectionForMove("next"))
        else
            self:SetScrollHighlight("none")
            self:MoveSelection("next")
        end
    end))

    local v27 = createNavAction("ExitAction", { Enum.KeyCode.ButtonB })

    self.connections:trackConnection("Exit", v27.Pressed:Connect(function() -- line: 315
        -- upvalues: self (copy)
        self:ExitSelectionMode()
    end))

    local v28 = createNavAction("ActivateAction", {
        Enum.KeyCode.ButtonA,
        Enum.KeyCode.Return,
        Enum.KeyCode.KeypadEnter
    })

    self.connections:trackConnection("Activate", v28.StateChanged:Connect(function(p16) -- line: 324
        -- upvalues: self (copy)
        if p16 then
            self.activeActionSlot = self.selectedVisibleSlot
            self.activeButton = self.abilityButtonsByVisibleSlot[self.activeActionSlot]

            if self.activeButton then
                self.activeButton:SetSelectionPressed(true)
            end
        elseif self.activeActionSlot then
            self:ExitSelectionMode()
        end
    end))
    createNavAction("AbilitySinkAction", {
        Enum.KeyCode.ButtonX,
        Enum.KeyCode.ButtonY,
        Enum.KeyCode.ButtonL2,
        Enum.KeyCode.ButtonR2,
        Enum.KeyCode.DPadDown
    })
    Folder.Parent = script
    self.inputFolder = Folder
    self.navContext = InputContext
end

function t5:UpdateInputMode() -- line: 351
    -- upvalues: t5 (copy)
    if self.parentUIFrame then
        if t5.SupportsSelection() then
            self:EnsureInputObjects()

            if not self.enabled and self.selectionMode then
                self:ExitSelectionMode()
            end
        elseif self.selectionMode then
            self:ExitSelectionMode()
        end

        self.parentUIFrame.Visible = true
    end
end

function t5:EnterSelectionMode() -- line: 370
    -- upvalues: t5 (copy)
    if self.selectionMode or not t5.SupportsSelection() or not self.enabled or self.numVisibleSlots <= 0 then
        return
    end

    self.selectionMode = true

    if self.navContext then
        self.navContext.Enabled = true
    end

    self.parentUIFrame.Visible = true
    self.selectedVisibleSlot = math.clamp(self.selectedVisibleSlot, 1, self.numVisibleSlots)
    self:RefreshSelection()
end

function t5:ExitSelectionMode() -- line: 390
    self.selectionMode = false

    if self.navContext then
        self.navContext.Enabled = false
    end

    if self.scrollHighlightDirection ~= "none" then
        self.scrollHighlightDirection = "none"

        if self.created then
            self:CreateButtons()
        end
    end

    if self.activeButton then
        self.activeButton:SetSelectionPressed(false)
        self.activeButton = nil
    end

    self.activeActionSlot = nil

    if self.selectionRing then
        self.selectionRing.Parent = nil
    end
end

function t5:MoveSelection(p21) -- line: 414
    -- upvalues: InputSlots (copy)
    if not self.selectionMode or self.activeActionSlot or p21 == "none" then
        return
    end

    local v29 = if p21 == "previous" then 1 else -1
    local v31 = math.max(0, #InputSlots.GetAbilitiesInOverflow() - InputSlots.GetNumOverflowSlots())
    local v32 = InputSlots.getOverflowScrollIndex()
    local v33 = self.selectedVisibleSlot + v29

    if v33 < 1 then
        if v32 > 0 then
            self.selectedVisibleSlot = 1
            InputSlots.setOverflowScrollIndex(v32 - 1)
        end
    elseif self.numVisibleSlots < v33 then
        if v32 < v31 then
            self.selectedVisibleSlot = self.numVisibleSlots
            InputSlots.setOverflowScrollIndex(v32 + 1)
        end
    else
        self.selectedVisibleSlot = v33
    end

    self:RefreshSelection()
end

function t5:RefreshSelection() -- line: 449
    -- upvalues: t5 (copy)
    if not t5.SupportsSelection() or not self.selectionMode or self.numVisibleSlots <= 0 then
        return
    end

    self.selectedVisibleSlot = math.clamp(self.selectedVisibleSlot, 1, self.numVisibleSlots)

    local v34 = self.abilityButtonsByVisibleSlot[self.selectedVisibleSlot]

    if not v34 then
        return
    end

    self:EnsureSelectionRing()
    self.selectionRing.Parent = v34.instance
    self.selectionRing.Visible = true
end

function t5:Teardown() -- line: 466
    self.connections:disconnectAll()
    self.created = false
    self:ExitSelectionMode()

    if self.inputFolder then
        self.inputFolder:Destroy()
        self.inputFolder = nil
        self.navContext = nil
    end

    if self.selectionRing then
        self.selectionRing:Destroy()
        self.selectionRing = nil
    end
end

function t5:CreateButtons() -- line: 484
    -- upvalues: Players (copy), v1 (copy), InputSlots (copy), AbilityButton (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy)
    if self.selectionRing then
        self.selectionRing.Parent = nil
    end

    for _, v35 in self.managedButtons do
        v35:Destroy()
    end

    self.managedButtons = {}
    self.abilityButtonsByVisibleSlot = {}
    self.numVisibleSlots = 0

    if not v1:isEnabled() then
        return
    end

    local v36 = InputSlots.GetAbilitiesInOverflow()
    local v38 = math.min(#v36, InputSlots.GetNumOverflowSlots())
    local previous, next, v39, v40

    if #v36 > InputSlots.GetNumOverflowSlots() then
        local v41 = InputSlots.getOverflowScrollIndex()
        local v42 = #v36 - InputSlots.GetNumOverflowSlots()
        local next2

        if v41 > 0 then
            next2 = self:CreateOverflowScrollButton("next")
            table.insert(self.managedButtons, next2)
        end

        if v41 < v42 then
            previous = self:CreateOverflowScrollButton("previous")
            table.insert(self.managedButtons, previous)
        end

        v39 = t1[1] + 8
        v40 = t2[1] + 10
        next = next2
    else
        v39 = 0
        v40 = 0
    end

    if self.scrollHighlightDirection ~= "previous" or not previous then
        if self.scrollHighlightDirection == "next" and next then
            next.Image = "rbxassetid://122643389561468"
        end
    else
        previous.Image = "rbxassetid://122643389561468"
    end

    for i = 1, v38 do
        local v43 = v36[i + InputSlots.getOverflowScrollIndex()]
        local v44 = InputSlots.GetOverflowAction(i)

        if v43 and v44 then
            local AbilityConfig = v1:GetAbilityConfig(v43)
            local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
            local t7 = if PlayerGui and PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then {
                small = {
                    44,
                    t3[1],
                    t3[2] + v39 + (i - 1) * 52
                },
                large = {
                    56,
                    t4[1],
                    t4[2] + v40 + (i - 1) * 66
                }
            } else {
                small = {
                    44,
                    t3[1] + v39 + (i - 1) * 52,
                    t3[2]
                },
                large = {
                    56,
                    t4[1] + v40 + (i - 1) * 66,
                    t4[2]
                }
            }
            local v45 = AbilityButton.create(self, v43, AbilityConfig, v44, t7, true, true)

            table.insert(self.managedButtons, v45)
            self.abilityButtonsByVisibleSlot[i] = v45
            self.numVisibleSlots = i

            if i == self.activeActionSlot then
                self.activeButton = v45
                v45:SetSelectionPressed(true)
            end
        end
    end

    self.parentUIFrame.Visible = true

    if self.selectionMode then
        if self.numVisibleSlots <= 0 then
            self:ExitSelectionMode()
        elseif t5.SupportsSelection() then
            self:RefreshSelection()
        end
    end
end

function t5:Create() -- line: 586
    -- upvalues: Players (copy), UserInputService (copy), GuiService (copy), v1 (copy), InputSlots (copy), t5 (copy)
    if self.parentUIFrame then
        self:CreateButtons()
        self.connections:trackConnection("SlotMapChanged", InputSlots.GetSlotMapChangedSignal():Connect(function() -- line: 595
            -- upvalues: self (copy)
            self:CreateButtons()
            self.selectedVisibleSlot = self.numVisibleSlots
            self:RefreshSelection()
        end))
        self.connections:trackConnection("AbilitiesEnabledChanged", v1:GetEnabledChangedSignal():Connect(function() -- line: 603
            -- upvalues: self (copy)
            self:CreateButtons()
        end))
        self.connections:trackConnection("ScrollIndexChanged", InputSlots.getScrollIndexChangedEvent():Connect(function() -- line: 609
            -- upvalues: self (copy)
            self:CreateButtons()
        end))
        self.connections:trackConnection("PreferredInput", UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 615
            -- upvalues: self (copy)
            self:UpdateInputMode()
            self:CreateButtons()
        end))
        self.connections:trackConnection("InputBegan", UserInputService.InputBegan:Connect(function(p26, p27) -- line: 623
            -- upvalues: self (copy), t5 (copy)
            if not p27 and self.enabled and (t5.IsGamepad() and p26.KeyCode == Enum.KeyCode.DPadUp or t5.IsKeyboardMouse() and p26.KeyCode == Enum.KeyCode.M) then
                if self.selectionMode then
                    self:ExitSelectionMode()
                else
                    self:EnterSelectionMode()
                end
            end
        end))
        self.connections:trackConnection("MenuOpened", GuiService.MenuOpened:Connect(function() -- line: 645
            -- upvalues: self (copy)
            if self.selectionMode then
                self:ExitSelectionMode()
            end
        end))

        local v46 = Players.LocalPlayer:WaitForChild("PlayerGui", 5)

        if v46 then
            self.connections:trackConnection("ScreenOrientation", v46:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function() -- line: 656
                -- upvalues: self (copy)
                self:CreateButtons()
            end))
        end

        self.parentUIFrame.Destroying:Connect(function() -- line: 662
            -- upvalues: self (copy)
            self:Teardown()
        end)
        self:UpdateInputMode()
    end
end

return t5
