-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CommonUtils = require(script.Parent.Parent:WaitForChild("CommonUtils"))
local ConnectionUtil = CommonUtils.get("ConnectionUtil")
local CharacterUtil = CommonUtils.get("CharacterUtil")
local FlagUtil = CommonUtils.get("FlagUtil")
local UserPlayerScriptsCCLIntegrationD = FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationD")
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

function self.new(p1) -- line: 61
    -- upvalues: ConnectionUtil (copy), UserPlayerScriptsFixTouchJumpVisibility (copy), ActionController (copy), self (copy)
    local v3 = setmetatable(ActionController.new(), self)

    v3.data = p1
    p1.eventBus:subscribe("ACTIONS_RELOADED"):Connect(function() -- line: 65
        -- upvalues: v3 (copy), UserPlayerScriptsFixTouchJumpVisibility (copy)
        v3:Create()

        if UserPlayerScriptsFixTouchJumpVisibility and v3._active then
            v3._active = false
            v3:EnableButton(true)
        end
    end)
    v3.parentUIFrame = nil
    v3.jumpButton = nil
    v3.externallyEnabled = false
    v3._active = false
    v3._connectionUtil = ConnectionUtil.new()

    return v3
end

function self._reset(p2) -- line: 83
    -- upvalues: UserPlayerScriptsCCLIntegrationD (copy), AvatarAbilitiesInterface (copy), t1 (copy)
    if p2.jumpButton then
        if not UserPlayerScriptsCCLIntegrationD and AvatarAbilitiesInterface.isEnabled() then
            p2.jumpButton.Image = t1[1]
        else
            p2.jumpButton.ImageRectOffset = Vector2.new(1, 146)
        end
    end
end

function self.EnableButton(p3, p4) -- line: 96
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

function self.UpdateEnabled(p5) -- line: 115
    -- upvalues: CharacterUtil (copy)
    local Humanoid = CharacterUtil.getChild("Humanoid", "Humanoid")

    if Humanoid and p5.externallyEnabled and (Humanoid.UseJumpPower and Humanoid.JumpPower > 0 or not Humanoid.UseJumpPower and Humanoid.JumpHeight > 0) and Humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
        p5:EnableButton(true)
    else
        p5:EnableButton(false)
    end
end

function self._setupConfigurations(p6) -- line: 124
    -- upvalues: CharacterUtil (copy)
    local function update() -- line: 125
        -- upvalues: p6 (copy)
        p6:UpdateEnabled()
    end

    local v4 = CharacterUtil.onChild("Humanoid", "Humanoid", function(p7) -- line: 130
        -- upvalues: p6 (copy), update (copy)
        p6:UpdateEnabled()
        p6:_reset()
        p6._connectionUtil:trackConnection("HUMANOID_JUMP_POWER", p7:GetPropertyChangedSignal("JumpPower"):Connect(update))
        p6._connectionUtil:trackConnection("HUMANOID_JUMP_HEIGHT", p7:GetPropertyChangedSignal("JumpHeight"):Connect(update))
        p6._connectionUtil:trackConnection("HUMANOID_STATE_ENABLED_CHANGED", p7.StateEnabledChanged:Connect(function(p8, p9) -- line: 143
            -- upvalues: p6 (copy)
            if p8 == Enum.HumanoidStateType.Jumping and p9 ~= p6._active then
                p6:UpdateEnabled()
            end
        end))
    end)

    p6._connectionUtil:trackConnection("HUMANOID", v4)
end

function self.Enable(p10, p11, p12) -- line: 155
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

function self.Create(p13) -- line: 173
    -- upvalues: UserPlayerScriptsCCLIntegrationD (copy), UserPlayerScriptsRefactor1 (copy), AvatarAbilitiesInterface (copy), t1 (copy)
    if p13.parentUIFrame then
        if p13.jumpButton then
            p13.jumpButton:Destroy()
            p13.jumpButton = nil
        end

        if p13.absoluteSizeChangedConn then
            p13.absoluteSizeChangedConn:Disconnect()
            p13.absoluteSizeChangedConn = nil
        end

        if not UserPlayerScriptsCCLIntegrationD and p13.avatarAbilitiesEnabledChangedConn then
            p13.avatarAbilitiesEnabledChangedConn:Disconnect()
            p13.avatarAbilitiesEnabledChangedConn = nil
        end

        p13.jumpButton = Instance.new("ImageButton")
        p13.jumpButton.Name = "JumpButton"
        p13.jumpButton.Visible = false
        p13.jumpButton.BackgroundTransparency = 1

        if UserPlayerScriptsRefactor1 then
            p13.jumpButton.ZIndex = 10
        end

        if UserPlayerScriptsCCLIntegrationD or not AvatarAbilitiesInterface.isEnabled() then
            p13.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
            p13.jumpButton.ImageRectOffset = Vector2.new(1, 146)
            p13.jumpButton.ImageRectSize = Vector2.new(144, 144)
        else
            p13.jumpButton.Image = t1[1]
        end

        local function ResizeJumpButton() -- line: 211
            -- upvalues: p13 (copy), UserPlayerScriptsCCLIntegrationD (copy), AvatarAbilitiesInterface (copy), t1 (copy)
            local v5 = math.min(p13.parentUIFrame.AbsoluteSize.x, p13.parentUIFrame.AbsoluteSize.y) <= 500
            local v6, v7

            if UserPlayerScriptsCCLIntegrationD then
                v7 = true
            elseif AvatarAbilitiesInterface.isEnabled() then
                v6 = if v5 then 72 else 120
                v7 = false
            else
                v7 = true
            end

            if not v7 then
                local v8 = if v5 then 64 else 100
                local v9 = if v5 then 64 else 112
                local v10 = -v6 - v8
                local v11 = -v6 - v9

                p13.jumpButton.Image = t1[1]
                p13.jumpButton.ImageRectOffset = Vector2.new(0, 0)
                p13.jumpButton.ImageRectSize = Vector2.new(0, 0)
                p13.jumpButton.Size = UDim2.new(0, v6, 0, v6)
                p13.jumpButton.Position = UDim2.new(1, v10, 1, v11)
            else
                local v12 = if v5 then 70 else 120

                p13.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
                p13.jumpButton.ImageRectOffset = Vector2.new(1, 146)
                p13.jumpButton.ImageRectSize = Vector2.new(144, 144)
                p13.jumpButton.Size = UDim2.new(0, v12, 0, v12)
                p13.jumpButton.Position = v5 and UDim2.new(1, -(v12 * 1.5 - 10), 1, -v12 - 20) or UDim2.new(1, -(v12 * 1.5 - 10), 1, -v12 * 1.75)
            end
        end

        ResizeJumpButton()
        p13.absoluteSizeChangedConn = p13.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeJumpButton)

        if not UserPlayerScriptsCCLIntegrationD then
            p13.avatarAbilitiesEnabledChangedConn = AvatarAbilitiesInterface.GetEnabledChangedSignal():Connect(ResizeJumpButton)
        end

        p13.jumpButton.Parent = p13.parentUIFrame

        if not p13.data.actions.JumpAction then
            return
        end

        p13.data.actions.JumpAction:WaitForChild("TouchBinding").UIButton = p13.jumpButton
        p13.data.actions.JumpAction.Pressed:Connect(function() -- line: 253
            -- upvalues: p13 (copy), UserPlayerScriptsCCLIntegrationD (copy), AvatarAbilitiesInterface (copy), t1 (copy)
            if p13.jumpButton then
                if UserPlayerScriptsCCLIntegrationD or not AvatarAbilitiesInterface.isEnabled() then
                    p13.jumpButton.ImageRectOffset = Vector2.new(146, 146)
                else
                    p13.jumpButton.Image = t1[2]
                end
            end
        end)
        p13.data.actions.JumpAction.Released:Connect(function() -- line: 265
            -- upvalues: p13 (copy), UserPlayerScriptsCCLIntegrationD (copy), AvatarAbilitiesInterface (copy), t1 (copy)
            if p13.jumpButton then
                if UserPlayerScriptsCCLIntegrationD or not AvatarAbilitiesInterface.isEnabled() then
                    p13.jumpButton.ImageRectOffset = Vector2.new(1, 146)
                else
                    p13.jumpButton.Image = t1[1]
                end
            end
        end)
    end
end

return self
