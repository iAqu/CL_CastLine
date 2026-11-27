-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local CommonUtils = require(script.Parent.Parent:WaitForChild("CommonUtils"))
local InputSlots = require(script.Parent:WaitForChild("InputSlots"))
local ConnectionUtil = CommonUtils.get("ConnectionUtil")
local DPadUp, M = Enum.KeyCode.DPadUp, Enum.KeyCode.M
local v1 = Color3.fromRGB(18, 18, 21)
local BuilderSans = Enum.Font.BuilderSans
local v2 = Color3.fromRGB(247, 247, 248)
local BuilderSansBold = Enum.Font.BuilderSansBold
local v3 = Color3.fromRGB(247, 247, 248)
local v4 = Color3.fromRGB(18, 18, 21)
local t1 = {}

for _, v5 in {
        Enum.KeyCode.ButtonA,
        Enum.KeyCode.ButtonB,
        Enum.KeyCode.ButtonX,
        Enum.KeyCode.ButtonY,
        Enum.KeyCode.ButtonL1,
        Enum.KeyCode.ButtonR1,
        Enum.KeyCode.ButtonL2,
        Enum.KeyCode.ButtonR2,
        Enum.KeyCode.ButtonL3,
        Enum.KeyCode.ButtonR3,
        Enum.KeyCode.ButtonStart,
        Enum.KeyCode.ButtonSelect,
        Enum.KeyCode.DPadLeft,
        Enum.KeyCode.DPadRight,
        Enum.KeyCode.DPadUp,
        Enum.KeyCode.DPadDown,
        Enum.KeyCode.Thumbstick1,
        Enum.KeyCode.Thumbstick2
    } do
    t1[v5] = true
end

local t2 = {
    [Enum.KeyCode.ButtonCenter] = true,
    [Enum.KeyCode.ButtonUp] = true,
    [Enum.KeyCode.ButtonDown] = true,
    [Enum.KeyCode.ButtonLeft] = true,
    [Enum.KeyCode.ButtonRight] = true
}

local function actionKeyCode(p1) -- line: 85
    -- upvalues: UserInputService (copy), t1 (copy), t2 (copy)
    for _, child in p1:GetChildren() do
        if child:IsA("InputBinding") then
            local KeyCode = child.KeyCode

            if if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then t1[KeyCode] == true else KeyCode ~= Enum.KeyCode.None and not t1[KeyCode] and not t2[KeyCode] then
                return KeyCode
            end
        end
    end

    return nil
end

local function createEntryFrame(p2, p3, p4) -- line: 105
    local Frame = Instance.new("Frame")

    Frame.Name = p3
    Frame.LayoutOrder = p4
    Frame.Size = UDim2.new(0, 0, 0, 28)
    Frame.AutomaticSize = Enum.AutomaticSize.X
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Parent = p2

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingRight = UDim.new(0, 8)
    UIPadding.Parent = Frame

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.Parent = Frame

    return Frame
end

local function createKeyIndicator(p5, p6, p7) -- line: 130
    -- upvalues: UserInputService (copy), BuilderSansBold (copy), v3 (copy), v4 (copy)
    local StringForKeyCode

    if p6 then
        if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
            local ImageForKeyCode = UserInputService:GetImageForKeyCode(p6)

            if ImageForKeyCode ~= "" then
                local ImageLabel = Instance.new("ImageLabel")

                ImageLabel.Name = "Key"
                ImageLabel.LayoutOrder = p7
                ImageLabel.Size = UDim2.new(0, 24, 0, 24)
                ImageLabel.BackgroundTransparency = 1
                ImageLabel.Image = ImageForKeyCode
                ImageLabel.Parent = p5

                return
            end
        end

        if p6 == Enum.KeyCode.None then
            StringForKeyCode = "?"
        else
            StringForKeyCode = UserInputService:GetStringForKeyCode(p6, Enum.KeyCodeStringFormat.Abbreviated)

            if StringForKeyCode:match("^%s*$") then
                StringForKeyCode = p6.Name
            end
        end
    else
        StringForKeyCode = "?"
    end

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Key"
    TextLabel.LayoutOrder = p7
    TextLabel.AutomaticSize = Enum.AutomaticSize.XY
    TextLabel.Size = UDim2.new(0, 0, 0, 0)
    TextLabel.BackgroundColor3 = v3
    TextLabel.BackgroundTransparency = 0
    TextLabel.BorderSizePixel = 0
    TextLabel.Font = BuilderSansBold
    TextLabel.TextSize = 14
    TextLabel.TextColor3 = v4
    TextLabel.Text = StringForKeyCode
    TextLabel.Parent = p5

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 2)
    UICorner.Parent = TextLabel

    local UISizeConstraint = Instance.new("UISizeConstraint")

    UISizeConstraint.MinSize = Vector2.new(10, 10)
    UISizeConstraint.Parent = TextLabel

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 5)
    UIPadding.PaddingRight = UDim.new(0, 5)
    UIPadding.PaddingTop = UDim.new(0, 1)
    UIPadding.PaddingBottom = UDim.new(0, 2)
    UIPadding.Parent = TextLabel
end

local function createLabel(p8, p9, p10) -- line: 183
    -- upvalues: BuilderSans (copy), v2 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Label"
    TextLabel.LayoutOrder = p10
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.Size = UDim2.new(0, 0, 0, 28)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = BuilderSans
    TextLabel.TextSize = 18
    TextLabel.TextColor3 = v2
    TextLabel.Text = p9
    TextLabel.Parent = p8

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = UDim.new(0, -0)
    UIPadding.PaddingBottom = UDim.new(0, 0)
    UIPadding.Parent = TextLabel
end

local t3 = {}

t3.__index = t3

function t3.new(p11) -- line: 211
    -- upvalues: ConnectionUtil (copy), t3 (copy)
    local self = setmetatable({}, t3)

    self.parent = p11
    self.characterContext = nil
    self.created = false
    self.enabled = false
    self.bar = nil
    self.connections = ConnectionUtil.new()
    self.contextConnections = ConnectionUtil.new()

    return self
end

function t3.GetInputContextsParent(_) -- line: 226
    return script:FindFirstAncestor("PlayerModule")
end

function t3:ResolveCharacterContext() -- line: 230
    local InputContextsParent = self:GetInputContextsParent()
    local InputContexts = InputContextsParent and InputContextsParent:FindFirstChild("InputContexts")

    if InputContexts then
        return InputContexts:FindFirstChild("CharacterContext")
    end

    return nil
end

function t3:ResolveAndBind() -- line: 239
    self.connections:disconnect("ResolveWatcher")

    local v7 = self:ResolveCharacterContext()

    if v7 then
        self:BindCharacterContext(v7)
    else
        local InputContextsParent = self:GetInputContextsParent()

        if InputContextsParent then
            local function bindWhenCharacterContextReady(p15) -- line: 253
                -- upvalues: self (copy)
                local CharacterContext = p15:FindFirstChild("CharacterContext")

                if CharacterContext then
                    self.connections:disconnect("ResolveWatcher")
                    self:BindCharacterContext(CharacterContext)
                else
                    self.connections:trackConnection("ResolveWatcher", p15.ChildAdded:Connect(function(p16) -- line: 262
                        -- upvalues: self (copy)
                        if p16.Name == "CharacterContext" then
                            self.connections:disconnect("ResolveWatcher")
                            self:BindCharacterContext(p16)
                        end
                    end))
                end
            end

            local InputContexts = InputContextsParent:FindFirstChild("InputContexts")

            if InputContexts then
                bindWhenCharacterContextReady(InputContexts)
            else
                self.connections:trackConnection("ResolveWatcher", InputContextsParent.ChildAdded:Connect(function(p17) -- line: 278
                    -- upvalues: bindWhenCharacterContextReady (copy)
                    if p17.Name == "InputContexts" then
                        bindWhenCharacterContextReady(p17)
                    end
                end))
            end
        end
    end
end

function t3:BindCharacterContext(p19) -- line: 286
    -- upvalues: InputSlots (copy)
    self.characterContext = p19
    self.contextConnections:disconnectAll()

    if p19 then
        local function watchAction(p20) -- line: 292
            -- upvalues: self (copy)
            self.contextConnections:trackConnection(p20.Name .. "_Enabled", p20:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 295
                -- upvalues: self (copy)
                self:Rebuild()
            end))
            self.contextConnections:trackConnection(p20.Name .. "_AttributeChanged", p20.AttributeChanged:Connect(function() -- line: 301
                -- upvalues: self (copy)
                self:Rebuild()
            end))
        end

        for i = 1, InputSlots.GetNumAbilitySlots() do
            local v8 = p19:FindFirstChild("AbilityAction" .. i)

            if v8 then
                watchAction(v8)
            end
        end

        self.contextConnections:trackConnection("ChildAdded", p19.ChildAdded:Connect(function(p21) -- line: 314
            -- upvalues: self (copy), watchAction (copy)
            if p21:IsA("InputAction") and string.match(p21.Name, "^AbilityAction%d+$") then
                watchAction(p21)
                self:Rebuild()
            end
        end))
        self.contextConnections:trackConnection("ChildRemoved", p19.ChildRemoved:Connect(function(p22) -- line: 323
            -- upvalues: self (copy)
            if not (p22:IsA("InputAction") and string.match(p22.Name, "^AbilityAction%d+$")) then
                return
            end

            self.contextConnections:disconnect(p22.Name .. "_Enabled")
            self.contextConnections:disconnect(p22.Name .. "_AttributeChanged")
            self:Rebuild()
        end))
    end

    self:Rebuild()
end

function t3.IsVisiblePlatform(_) -- line: 336
    -- upvalues: UserInputService (copy)
    local PreferredInput = UserInputService.PreferredInput

    if PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
        return true
    end

    return PreferredInput == Enum.PreferredInput.Gamepad
end

function t3:Enable(p25) -- line: 341
    if self.enabled == p25 then
        return
    end

    self.enabled = p25

    if p25 and not self.created then
        self:Create()
        self.created = true
    end

    self:Rebuild()
end

function t3:CreateEntry(p27, p28, p29) -- line: 355
    -- upvalues: createEntryFrame (copy), createKeyIndicator (copy), createLabel (copy)
    local v9 = createEntryFrame(self.bar, "Slot" .. p27, p27)

    createKeyIndicator(v9, p29, 1)
    createLabel(v9, p28, 2)
end

function t3:CreateActionEntry(p31, p32, p33, p34) -- line: 362
    -- upvalues: createEntryFrame (copy), createKeyIndicator (copy), createLabel (copy)
    local v10 = createEntryFrame(self.bar, p31, p32)

    createKeyIndicator(v10, p34, 1)
    createLabel(v10, p33, 2)
end

function t3:Rebuild() -- line: 374
    -- upvalues: UserInputService (copy), InputSlots (copy), DPadUp (copy), M (copy), actionKeyCode (copy)
    if self.bar then
        for _, child in self.bar:GetChildren() do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local characterContext = self.characterContext

        if not self.enabled or not self:IsVisiblePlatform() or not characterContext then
            self.bar.Visible = false

            return
        end

        local PreferredInput = UserInputService.PreferredInput
        local v11

        if #InputSlots.GetAbilitiesInOverflow() > 0 then
            if PreferredInput == Enum.PreferredInput.Gamepad then
                if DPadUp then
                    v11 = true
                    self:CreateActionEntry("MoreActions", InputSlots.GetNumAbilitySlots() + 1, "More Actions", DPadUp)
                else
                    v11 = false
                end
            elseif PreferredInput == Enum.PreferredInput.KeyboardAndMouse and M then
                v11 = true
                self:CreateActionEntry("MoreActions", InputSlots.GetNumAbilitySlots() + 1, "More Actions", M)
            else
                v11 = false
            end
        else
            v11 = false
        end

        for i = 1, InputSlots.GetNumAbilitySlots() do
            local v12 = characterContext:FindFirstChild("AbilityAction" .. i)

            if v12 and v12.Enabled then
                local DisplayName = v12.DisplayName

                if type(DisplayName) == "string" and DisplayName ~= "" then
                    v11 = true
                    self:CreateEntry(i, DisplayName, (actionKeyCode(v12)))
                end
            end
        end

        self.bar.Visible = v11
    end
end

function t3:Create() -- line: 422
    -- upvalues: UserInputService (copy), InputSlots (copy), v1 (copy)
    if self.parent then
        local Frame = Instance.new("Frame")

        Frame.Name = "AbilityKeybindBar"
        Frame.AnchorPoint = Vector2.new(1, 1)
        Frame.Position = UDim2.new(1, -17, 1, -17)
        Frame.Size = UDim2.new(0, 0, 0, 28)
        Frame.AutomaticSize = Enum.AutomaticSize.XY
        Frame.BackgroundColor3 = v1
        Frame.BackgroundTransparency = 0.4
        Frame.BorderSizePixel = 0
        Frame.Visible = false
        Frame.Parent = self.parent
        self.bar = Frame

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = Frame

        local UIPadding = Instance.new("UIPadding")

        UIPadding.PaddingLeft = UDim.new(0, 16)
        UIPadding.PaddingRight = UDim.new(0, 12)
        UIPadding.PaddingTop = UDim.new(0, 4)
        UIPadding.PaddingBottom = UDim.new(0, 4)
        UIPadding.Parent = Frame

        local UIListLayout = Instance.new("UIListLayout")

        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 8)
        UIListLayout.Parent = Frame
        self.connections:trackConnection("PreferredInput", UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 461
            -- upvalues: self (copy)
            self:Rebuild()
        end))
        self.connections:trackConnection("SlotMapChanged", InputSlots.GetSlotMapChangedSignal():Connect(function() -- line: 468
            -- upvalues: self (copy)
            self:Rebuild()
        end))
        self.connections:trackConnection("ParentDestroying", self.parent.Destroying:Connect(function() -- line: 475
            -- upvalues: self (copy)
            self:Teardown()
        end))
        self:ResolveAndBind()
    end
end

function t3:Teardown() -- line: 483
    self.connections:disconnectAll()
    self.contextConnections:disconnectAll()

    if self.bar then
        self.bar:Destroy()
        self.bar = nil
    end

    self.created = false
end

return t3
