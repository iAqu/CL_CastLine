-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

game:GetService("Players")

local GuiService = game:GetService("GuiService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))
local CharacterUtil = require(CommonUtils:WaitForChild("CharacterUtil"))
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local _ = {
    HUMANOID_STATE_ENABLED_CHANGED = "HUMANOID_STATE_ENABLED_CHANGED",
    HUMANOID_JUMP_POWER = "HUMANOID_JUMP_POWER",
    HUMANOID_JUMP_HEIGHT = "HUMANOID_JUMP_HEIGHT",
    HUMANOID = "HUMANOID",
    JUMP_INPUT_ENDED = "JUMP_INPUT_ENDED",
    MENU_OPENED = "MENU_OPENED"
}
local UserTouchJumpHeightDisable = FlagUtil.getUserFlag("UserTouchJumpHeightDisable")
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local self = setmetatable({}, BaseCharacterController)

self.__index = self

function self.new() -- line: 54
    -- upvalues: ConnectionUtil (copy), BaseCharacterController (copy), self (copy)
    local v3 = setmetatable(BaseCharacterController.new(), self)

    v3.parentUIFrame = nil
    v3.jumpButton = nil
    v3.externallyEnabled = false
    v3.isJumping = false
    v3._active = false
    v3._connectionUtil = ConnectionUtil.new()

    return v3
end

function self._reset(p1) -- line: 68
    p1.isJumping = false
    p1.touchObject = nil

    if p1.jumpButton then
        p1.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    end
end

function self.EnableButton(p2, p3) -- line: 79
    -- upvalues: GuiService (copy), UserTouchJumpHeightDisable (copy)
    if p3 == p2._active then
        if not UserTouchJumpHeightDisable then
            p2:_reset()
        end
    else
        if p3 then
            if not p2.jumpButton then
                p2:Create()
            end

            p2.jumpButton.Visible = true
            p2._connectionUtil:trackConnection("JUMP_INPUT_ENDED", p2.jumpButton.InputEnded:Connect(function(p4) -- line: 97
                -- upvalues: p2 (copy)
                if p4 == p2.touchObject then
                    p2:_reset()
                end
            end))
            p2._connectionUtil:trackConnection("MENU_OPENED", GuiService.MenuOpened:Connect(function() -- line: 107
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
end

function self.UpdateEnabled(p5) -- line: 124
    -- upvalues: CharacterUtil (copy), UserTouchJumpHeightDisable (copy)
    local Humanoid = CharacterUtil.getChild("Humanoid", "Humanoid")

    if UserTouchJumpHeightDisable then
        if Humanoid and p5.externallyEnabled and (Humanoid.UseJumpPower and Humanoid.JumpPower > 0 or not Humanoid.UseJumpPower and Humanoid.JumpHeight > 0) and Humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
            p5:EnableButton(true)

            return
        end
    elseif Humanoid and p5.externallyEnabled and Humanoid.JumpPower > 0 and Humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
        p5:EnableButton(true)

        return
    end

    p5:EnableButton(false)
end

function self._setupConfigurations(p6) -- line: 141
    -- upvalues: CharacterUtil (copy), UserTouchJumpHeightDisable (copy)
    local function update() -- line: 142
        -- upvalues: p6 (copy)
        p6:UpdateEnabled()
    end

    local v4 = CharacterUtil.onChild("Humanoid", "Humanoid", function(p7) -- line: 147
        -- upvalues: p6 (copy), update (copy), UserTouchJumpHeightDisable (copy)
        p6:UpdateEnabled()

        if UserTouchJumpHeightDisable then
            p6:_reset()
        end

        p6._connectionUtil:trackConnection("HUMANOID_JUMP_POWER", p7:GetPropertyChangedSignal("JumpPower"):Connect(update))

        if UserTouchJumpHeightDisable then
            p6._connectionUtil:trackConnection("HUMANOID_JUMP_HEIGHT", p7:GetPropertyChangedSignal("JumpHeight"):Connect(update))
        end

        p6._connectionUtil:trackConnection("HUMANOID_STATE_ENABLED_CHANGED", p7.StateEnabledChanged:Connect(function(p8, p9) -- line: 164
            -- upvalues: p6 (copy)
            if p8 == Enum.HumanoidStateType.Jumping and p9 ~= p6._active then
                p6:UpdateEnabled()
            end
        end))
    end)

    p6._connectionUtil:trackConnection("HUMANOID", v4)
end

function self.Enable(p10, p11, p12) -- line: 176
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

function self.Create(p13) -- line: 193
    if p13.parentUIFrame then
        if p13.jumpButton then
            p13.jumpButton:Destroy()
            p13.jumpButton = nil
        end

        if p13.absoluteSizeChangedConn then
            p13.absoluteSizeChangedConn:Disconnect()
            p13.absoluteSizeChangedConn = nil
        end

        p13.jumpButton = Instance.new("ImageButton")
        p13.jumpButton.Name = "JumpButton"
        p13.jumpButton.Visible = false
        p13.jumpButton.BackgroundTransparency = 1
        p13.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
        p13.jumpButton.ImageRectOffset = Vector2.new(1, 146)
        p13.jumpButton.ImageRectSize = Vector2.new(144, 144)

        local function ResizeJumpButton() -- line: 216
            -- upvalues: p13 (copy)
            local v5 = math.min(p13.parentUIFrame.AbsoluteSize.x, p13.parentUIFrame.AbsoluteSize.y) <= 500
            local v6 = if v5 then 70 else 120

            p13.jumpButton.Size = UDim2.new(0, v6, 0, v6)
            p13.jumpButton.Position = v5 and UDim2.new(1, -(v6 * 1.5 - 10), 1, -v6 - 20) or UDim2.new(1, -(v6 * 1.5 - 10), 1, -v6 * 1.75)
        end

        ResizeJumpButton()
        p13.absoluteSizeChangedConn = p13.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeJumpButton)
        p13.touchObject = nil
        p13.jumpButton.InputBegan:connect(function(p14) -- line: 230
            -- upvalues: p13 (copy)
            if p13.touchObject or p14.UserInputType ~= Enum.UserInputType.Touch or p14.UserInputState ~= Enum.UserInputState.Begin then
                return
            end

            p13.touchObject = p14
            p13.jumpButton.ImageRectOffset = Vector2.new(146, 146)
            p13.isJumping = true
        end)
        p13.jumpButton.Parent = p13.parentUIFrame
    end
end

return self
