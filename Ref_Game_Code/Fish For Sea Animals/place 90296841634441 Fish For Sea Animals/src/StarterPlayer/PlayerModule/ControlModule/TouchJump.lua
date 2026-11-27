-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CommonUtils = require(script.Parent.Parent:WaitForChild("CommonUtils"))
local ConnectionUtil = CommonUtils.get("ConnectionUtil")
local CharacterUtil = CommonUtils.get("CharacterUtil")
local FlagUtil = CommonUtils.get("FlagUtil")
local v1 = FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationD") or FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationDGA")
local UserPlayerScriptsRefactor1 = FlagUtil.getUserFlag("UserPlayerScriptsRefactor1")
local UserPlayerScriptsFixTouchJumpVisibility = FlagUtil.getUserFlag("UserPlayerScriptsFixTouchJumpVisibility")

game:GetService("Players")

local AvatarAbilitiesInterface = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"))
local t1 = {
    "rbxasset://textures/ui/Input/JumpButtonRegular.png",
    "rbxasset://textures/ui/Input/JumpButtonPressed.png"
}
local _ = {
    HUMANOID_STATE_ENABLED_CHANGED = "HUMANOID_STATE_ENABLED_CHANGED",
    HUMANOID_JUMP_POWER = "HUMANOID_JUMP_POWER",
    HUMANOID_JUMP_HEIGHT = "HUMANOID_JUMP_HEIGHT",
    HUMANOID = "HUMANOID",
    ACTIONS_RELOADED = "ACTIONS_RELOADED"
}
local ActionController = require(script.Parent:WaitForChild("ActionController"))
local self = setmetatable({}, ActionController)

self.__index = self

function self.new(p1) -- line: 66
    -- upvalues: ConnectionUtil (copy), UserPlayerScriptsFixTouchJumpVisibility (copy), ActionController (copy), self (copy)
    local v4 = setmetatable(ActionController.new(), self)

    v4.data = p1
    v4._actionsReloadedConn = p1.eventBus:subscribe("ACTIONS_RELOADED"):Connect(function() -- line: 70
        -- upvalues: v4 (copy), UserPlayerScriptsFixTouchJumpVisibility (copy)
        v4:Create()

        if UserPlayerScriptsFixTouchJumpVisibility and v4._active then
            v4._active = false
            v4:EnableButton(true)
        end
    end)
    v4.parentUIFrame = nil
    v4.jumpButton = nil
    v4.externallyEnabled = false
    v4._active = false
    v4._connectionUtil = ConnectionUtil.new()

    return v4
end

function self._reset(p2) -- line: 88
    -- upvalues: AvatarAbilitiesInterface (copy), t1 (copy), v1 (copy)
    if p2.jumpButton then
        if not v1 and AvatarAbilitiesInterface.isEnabled() then
            p2.jumpButton.Image = t1[1]
        else
            p2.jumpButton.ImageRectOffset = Vector2.new(1, 146)
        end
    end
end

function self.EnableButton(p3, p4) -- line: 101
    if p4 == p3._active then
        return
    end

    if p4 then
        if not p3.jumpButton then
            p3:Create()
        end

        p3.jumpButton.Visible = true
    elseif p3.jumpButton then
        p3.jumpButton.Visible = false
    end

    p3:_reset()
    p3._active = p4
end

function self.UpdateEnabled(p5) -- line: 120
    -- upvalues: CharacterUtil (copy)
    local Humanoid = CharacterUtil.getChild("Humanoid", "Humanoid")

    if Humanoid and p5.externallyEnabled and (Humanoid.UseJumpPower and Humanoid.JumpPower > 0 or not Humanoid.UseJumpPower and Humanoid.JumpHeight > 0) and Humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
        p5:EnableButton(true)
    else
        p5:EnableButton(false)
    end
end

function self._setupConfigurations(p6) -- line: 134
    -- upvalues: CharacterUtil (copy)
    local function update() -- line: 135
        -- upvalues: p6 (copy)
        p6:UpdateEnabled()
    end

    local v5 = CharacterUtil.onChild("Humanoid", "Humanoid", function(p7) -- line: 140
        -- upvalues: p6 (copy), update (copy)
        p6:UpdateEnabled()
        p6:_reset()
        p6._connectionUtil:trackConnection("HUMANOID_JUMP_POWER", p7:GetPropertyChangedSignal("JumpPower"):Connect(update))
        p6._connectionUtil:trackConnection("HUMANOID_JUMP_HEIGHT", p7:GetPropertyChangedSignal("JumpHeight"):Connect(update))
        p6._connectionUtil:trackConnection("HUMANOID_STATE_ENABLED_CHANGED", p7.StateEnabledChanged:Connect(function(p8, p9) -- line: 153
            -- upvalues: p6 (copy)
            if p8 == Enum.HumanoidStateType.Jumping and p9 ~= p6._active then
                p6:UpdateEnabled()
            end
        end))
    end)

    p6._connectionUtil:trackConnection("HUMANOID", v5)
end

function self.Enable(p10, p11, p12) -- line: 165
    -- upvalues: ActionController (copy)
    if p12 then
        p10.parentUIFrame = p12
    end

    if p10.externallyEnabled == p11 then
        return
    end

    p10.externallyEnabled = p11
    ActionController.Enable(p10, p11)
    p10:UpdateEnabled()

    if p11 then
        p10:_setupConfigurations()
    else
        p10._connectionUtil:disconnectAll()
    end
end

function self.Destroy(p13) -- line: 185
    if p13._actionsReloadedConn then
        p13._actionsReloadedConn:Disconnect()
        p13._actionsReloadedConn = nil
    end

    if p13.jumpButton then
        p13.jumpButton:Destroy()
        p13.jumpButton = nil
    end

    if p13.absoluteSizeChangedConn then
        p13.absoluteSizeChangedConn:Disconnect()
        p13.absoluteSizeChangedConn = nil
    end

    if p13.avatarAbilitiesEnabledChangedConn then
        p13.avatarAbilitiesEnabledChangedConn:Disconnect()
        p13.avatarAbilitiesEnabledChangedConn = nil
    end

    p13._connectionUtil:disconnectAll()
    p13.externallyEnabled = false
    p13._active = false
    p13.parentUIFrame = nil
end

function self.Create(p14) -- line: 208
    -- upvalues: UserPlayerScriptsRefactor1 (copy), AvatarAbilitiesInterface (copy), t1 (copy), v1 (copy)
    if p14.parentUIFrame then
        if p14.jumpButton then
            p14.jumpButton:Destroy()
            p14.jumpButton = nil
        end

        if p14.absoluteSizeChangedConn then
            p14.absoluteSizeChangedConn:Disconnect()
            p14.absoluteSizeChangedConn = nil
        end

        if not v1 and p14.avatarAbilitiesEnabledChangedConn then
            p14.avatarAbilitiesEnabledChangedConn:Disconnect()
            p14.avatarAbilitiesEnabledChangedConn = nil
        end

        p14.jumpButton = Instance.new("ImageButton")
        p14.jumpButton.Name = "JumpButton"
        p14.jumpButton.Visible = false
        p14.jumpButton.BackgroundTransparency = 1

        if UserPlayerScriptsRefactor1 then
            p14.jumpButton.ZIndex = 10
        end

        if v1 or not AvatarAbilitiesInterface.isEnabled() then
            p14.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
            p14.jumpButton.ImageRectOffset = Vector2.new(1, 146)
            p14.jumpButton.ImageRectSize = Vector2.new(144, 144)
        else
            p14.jumpButton.Image = t1[1]
        end

        local function ResizeJumpButton() -- line: 246
            -- upvalues: p14 (copy), AvatarAbilitiesInterface (copy), t1 (copy), v1 (copy)
            local v6 = math.min(p14.parentUIFrame.AbsoluteSize.x, p14.parentUIFrame.AbsoluteSize.y) <= 500
            local v7, v8

            if v1 then
                v8 = true
            elseif AvatarAbilitiesInterface.isEnabled() then
                v7 = if v6 then 72 else 120
                v8 = false
            else
                v8 = true
            end

            if not v8 then
                local v9 = if v6 then 64 else 100
                local v10 = if v6 then 64 else 112
                local v11 = -v7 - v9
                local v12 = -v7 - v10

                p14.jumpButton.Image = t1[1]
                p14.jumpButton.ImageRectOffset = Vector2.new(0, 0)
                p14.jumpButton.ImageRectSize = Vector2.new(0, 0)
                p14.jumpButton.Size = UDim2.new(0, v7, 0, v7)
                p14.jumpButton.Position = UDim2.new(1, v11, 1, v12)
            else
                local v13 = if v6 then 70 else 120

                p14.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
                p14.jumpButton.ImageRectOffset = Vector2.new(1, 146)
                p14.jumpButton.ImageRectSize = Vector2.new(144, 144)
                p14.jumpButton.Size = UDim2.new(0, v13, 0, v13)
                p14.jumpButton.Position = v6 and UDim2.new(1, -(v13 * 1.5 - 10), 1, -v13 - 20) or UDim2.new(1, -(v13 * 1.5 - 10), 1, -v13 * 1.75)
            end
        end

        ResizeJumpButton()
        p14.absoluteSizeChangedConn = p14.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeJumpButton)

        if not v1 then
            p14.avatarAbilitiesEnabledChangedConn = AvatarAbilitiesInterface.GetEnabledChangedSignal():Connect(ResizeJumpButton)
        end

        p14.jumpButton.Parent = p14.parentUIFrame

        if not p14.data.controlModule.actions.JumpAction then
            return
        end

        p14.data.controlModule.actions.JumpAction:WaitForChild("TouchBinding").UIButton = p14.jumpButton
        p14.data.controlModule.actions.JumpAction.Pressed:Connect(function() -- line: 290
            -- upvalues: p14 (copy), AvatarAbilitiesInterface (copy), t1 (copy), v1 (copy)
            if p14.jumpButton then
                if v1 or not AvatarAbilitiesInterface.isEnabled() then
                    p14.jumpButton.ImageRectOffset = Vector2.new(146, 146)
                else
                    p14.jumpButton.Image = t1[2]
                end
            end
        end)
        p14.data.controlModule.actions.JumpAction.Released:Connect(function() -- line: 302
            -- upvalues: p14 (copy), AvatarAbilitiesInterface (copy), t1 (copy), v1 (copy)
            if p14.jumpButton then
                if v1 or not AvatarAbilitiesInterface.isEnabled() then
                    p14.jumpButton.ImageRectOffset = Vector2.new(1, 146)
                else
                    p14.jumpButton.Image = t1[1]
                end
            end
        end)
    end
end

return self
