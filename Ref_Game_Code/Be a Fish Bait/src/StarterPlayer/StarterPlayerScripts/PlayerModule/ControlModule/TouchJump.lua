-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

game:GetService("Players")

local GuiService = game:GetService("GuiService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))
local CharacterUtil = require(CommonUtils:WaitForChild("CharacterUtil"))
local UserAllowAbilityControls = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserAllowAbilityControls")
local v1 = if UserAllowAbilityControls then require(script.Parent:WaitForChild("AvatarAbilitiesInterface")) else nil
local t1 = {
    "rbxasset://textures/ui/Input/JumpButtonRegular.png",
    "rbxasset://textures/ui/Input/JumpButtonPressed.png"
}
local _ = {
    HUMANOID_STATE_ENABLED_CHANGED = "HUMANOID_STATE_ENABLED_CHANGED",
    HUMANOID_JUMP_POWER = "HUMANOID_JUMP_POWER",
    HUMANOID_JUMP_HEIGHT = "HUMANOID_JUMP_HEIGHT",
    HUMANOID = "HUMANOID",
    JUMP_INPUT_ENDED = "JUMP_INPUT_ENDED",
    MENU_OPENED = "MENU_OPENED"
}
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local self = setmetatable({}, BaseCharacterController)

self.__index = self

function self.new() -- line: 61
    -- upvalues: ConnectionUtil (copy), BaseCharacterController (copy), self (copy)
    local v4 = setmetatable(BaseCharacterController.new(), self)

    v4.parentUIFrame = nil
    v4.jumpButton = nil
    v4.externallyEnabled = false
    v4.isJumping = false
    v4._active = false
    v4._connectionUtil = ConnectionUtil.new()

    return v4
end

function self._reset(p1) -- line: 75
    -- upvalues: UserAllowAbilityControls (copy), v1 (copy), t1 (copy)
    p1.isJumping = false
    p1.touchObject = nil

    if p1.jumpButton then
        if UserAllowAbilityControls and v1.isEnabled() then
            p1.jumpButton.Image = t1[1]
        else
            p1.jumpButton.ImageRectOffset = Vector2.new(1, 146)
        end
    end
end

function self.EnableButton(p2, p3) -- line: 90
    -- upvalues: GuiService (copy)
    if p3 == p2._active then
        return
    end

    if p3 then
        if not p2.jumpButton then
            p2:Create()
        end

        p2.jumpButton.Visible = true
        p2._connectionUtil:trackConnection("JUMP_INPUT_ENDED", p2.jumpButton.InputEnded:Connect(function(p4) -- line: 105
            -- upvalues: p2 (copy)
            if p4 == p2.touchObject then
                p2:_reset()
            end
        end))
        p2._connectionUtil:trackConnection("MENU_OPENED", GuiService.MenuOpened:Connect(function() -- line: 115
            -- upvalues: p2 (copy)
            if p2.touchObject then
                p2:_reset()
            end
        end))
    else
        if p2.jumpButton then
            p2.jumpButton.Visible = false
        end

        p2._connectionUtil:disconnect("JUMP_INPUT_ENDED")
        p2._connectionUtil:disconnect("MENU_OPENED")
    end

    p2:_reset()
    p2._active = p3
end

function self.UpdateEnabled(p5) -- line: 132
    -- upvalues: CharacterUtil (copy)
    local Humanoid = CharacterUtil.getChild("Humanoid", "Humanoid")

    if Humanoid and p5.externallyEnabled and (Humanoid.UseJumpPower and Humanoid.JumpPower > 0 or not Humanoid.UseJumpPower and Humanoid.JumpHeight > 0) and Humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
        p5:EnableButton(true)
    else
        p5:EnableButton(false)
    end
end

function self._setupConfigurations(p6) -- line: 141
    -- upvalues: CharacterUtil (copy)
    local function update() -- line: 142
        -- upvalues: p6 (copy)
        p6:UpdateEnabled()
    end

    local v5 = CharacterUtil.onChild("Humanoid", "Humanoid", function(p7) -- line: 147
        -- upvalues: p6 (copy), update (copy)
        p6:UpdateEnabled()
        p6:_reset()
        p6._connectionUtil:trackConnection("HUMANOID_JUMP_POWER", p7:GetPropertyChangedSignal("JumpPower"):Connect(update))
        p6._connectionUtil:trackConnection("HUMANOID_JUMP_HEIGHT", p7:GetPropertyChangedSignal("JumpHeight"):Connect(update))
        p6._connectionUtil:trackConnection("HUMANOID_STATE_ENABLED_CHANGED", p7.StateEnabledChanged:Connect(function(p8, p9) -- line: 160
            -- upvalues: p6 (copy)
            if p8 == Enum.HumanoidStateType.Jumping and p9 ~= p6._active then
                p6:UpdateEnabled()
            end
        end))
    end)

    p6._connectionUtil:trackConnection("HUMANOID", v5)
end

function self.Enable(p10, p11, p12) -- line: 172
    if p12 then
        p10.parentUIFrame = p12
    end

    if p10.externallyEnabled == p11 then
        return
    end

    p10.externallyEnabled = p11
    p10:UpdateEnabled()

    if p11 then
        p10:_setupConfigurations()
    else
        p10._connectionUtil:disconnectAll()
    end
end

function self.Create(p13) -- line: 189
    -- upvalues: UserAllowAbilityControls (copy), v1 (copy), t1 (copy)
    if p13.parentUIFrame then
        if p13.jumpButton then
            p13.jumpButton:Destroy()
            p13.jumpButton = nil
        end

        if p13.absoluteSizeChangedConn then
            p13.absoluteSizeChangedConn:Disconnect()
            p13.absoluteSizeChangedConn = nil
        end

        if UserAllowAbilityControls and p13.avatarAbilitiesEnabledChangedConn then
            p13.avatarAbilitiesEnabledChangedConn:Disconnect()
            p13.avatarAbilitiesEnabledChangedConn = nil
        end

        p13.jumpButton = Instance.new("ImageButton")
        p13.jumpButton.Name = "JumpButton"
        p13.jumpButton.Visible = false
        p13.jumpButton.BackgroundTransparency = 1

        if not (UserAllowAbilityControls and v1.isEnabled()) then
            p13.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
            p13.jumpButton.ImageRectOffset = Vector2.new(1, 146)
            p13.jumpButton.ImageRectSize = Vector2.new(144, 144)
        else
            p13.jumpButton.Image = t1[1]
        end

        local function ResizeJumpButton() -- line: 224
            -- upvalues: p13 (copy), UserAllowAbilityControls (copy), v1 (copy), t1 (copy)
            local v6 = math.min(p13.parentUIFrame.AbsoluteSize.x, p13.parentUIFrame.AbsoluteSize.y) <= 500

            if UserAllowAbilityControls and v1.isEnabled() then
                local v7 = if v6 then 72 else 120
                local v8 = if v6 then 64 else 100
                local v9 = if v6 then 64 else 112
                local v10 = -v7 - v8
                local v11 = -v7 - v9

                p13.jumpButton.Image = t1[1]
                p13.jumpButton.ImageRectOffset = Vector2.new(0, 0)
                p13.jumpButton.ImageRectSize = Vector2.new(0, 0)
                p13.jumpButton.Size = UDim2.new(0, v7, 0, v7)
                p13.jumpButton.Position = UDim2.new(1, v10, 1, v11)
            else
                local v12 = if v6 then 70 else 120

                if UserAllowAbilityControls then
                    p13.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
                    p13.jumpButton.ImageRectOffset = Vector2.new(1, 146)
                    p13.jumpButton.ImageRectSize = Vector2.new(144, 144)
                end

                p13.jumpButton.Size = UDim2.new(0, v12, 0, v12)
                p13.jumpButton.Position = v6 and UDim2.new(1, -(v12 * 1.5 - 10), 1, -v12 - 20) or UDim2.new(1, -(v12 * 1.5 - 10), 1, -v12 * 1.75)
            end
        end

        ResizeJumpButton()
        p13.absoluteSizeChangedConn = p13.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeJumpButton)

        if UserAllowAbilityControls then
            p13.avatarAbilitiesEnabledChangedConn = v1.GetEnabledChangedSignal():Connect(ResizeJumpButton)
        end

        p13.touchObject = nil
        p13.jumpButton.InputBegan:connect(function(p14) -- line: 262
            -- upvalues: p13 (copy), UserAllowAbilityControls (copy), v1 (copy), t1 (copy)
            if not p13.touchObject and p14.UserInputType == Enum.UserInputType.Touch and p14.UserInputState == Enum.UserInputState.Begin then
                p13.touchObject = p14

                if UserAllowAbilityControls and v1.isEnabled() then
                    p13.jumpButton.Image = t1[2]
                else
                    p13.jumpButton.ImageRectOffset = Vector2.new(146, 146)
                end

                p13.isJumping = true
            end
        end)
        p13.jumpButton.Parent = p13.parentUIFrame
    end
end

return self
