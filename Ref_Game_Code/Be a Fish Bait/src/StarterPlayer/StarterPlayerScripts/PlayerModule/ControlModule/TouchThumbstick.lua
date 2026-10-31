-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

game:GetService("Players")

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

UserSettings():GetService("UserGameSettings")

local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local UserAllowAbilityControls = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserAllowAbilityControls")
local v1 = if UserAllowAbilityControls then require(script.Parent:WaitForChild("AvatarAbilitiesInterface")) else nil
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local self = setmetatable({}, BaseCharacterController)

self.__index = self

function self.new() -- line: 29
    -- upvalues: BaseCharacterController (copy), self (copy)
    local v4 = setmetatable(BaseCharacterController.new(), self)

    v4.isFollowStick = false
    v4.thumbstickFrame = nil
    v4.moveTouchObject = nil
    v4.onTouchMovedConn = nil
    v4.onTouchEndedConn = nil
    v4.screenPos = nil
    v4.stickImage = nil
    v4.thumbstickSize = nil

    return v4
end

function self.Enable(p1, p2, p3) -- line: 44
    if p2 == nil then
        return false
    end

    local v5 = not not p2

    if p1.enabled == v5 then
        return true
    end

    p1.moveVector = Vector3.new(0, 0, 0)
    p1.isJumping = false

    if v5 then
        if not p1.thumbstickFrame then
            p1:Create(p3)
        end

        p1.thumbstickFrame.Visible = true
    else
        p1.thumbstickFrame.Visible = false
        p1:OnInputEnded()
    end

    p1.enabled = v5
end

function self.OnInputEnded(p4) -- line: 65
    p4.thumbstickFrame.Position = p4.screenPos
    p4.stickImage.Position = UDim2.new(0, p4.thumbstickFrame.Size.X.Offset / 2 - p4.thumbstickSize / 4, 0, p4.thumbstickFrame.Size.Y.Offset / 2 - p4.thumbstickSize / 4)
    p4.moveVector = Vector3.new(0, 0, 0)
    p4.isJumping = false
    p4.thumbstickFrame.Position = p4.screenPos
    p4.moveTouchObject = nil
end

function self.Create(p5, p6) -- line: 74
    -- upvalues: GuiService (copy), UserInputService (copy), UserAllowAbilityControls (copy), v1 (copy)
    if p5.thumbstickFrame then
        p5.thumbstickFrame:Destroy()
        p5.thumbstickFrame = nil

        if p5.onTouchMovedConn then
            p5.onTouchMovedConn:Disconnect()
            p5.onTouchMovedConn = nil
        end

        if p5.onTouchEndedConn then
            p5.onTouchEndedConn:Disconnect()
            p5.onTouchEndedConn = nil
        end

        if p5.absoluteSizeChangedConn then
            p5.absoluteSizeChangedConn:Disconnect()
            p5.absoluteSizeChangedConn = nil
        end

        if UserAllowAbilityControls and p5.avatarAbilitiesEnabledChangedConn then
            p5.avatarAbilitiesEnabledChangedConn:Disconnect()
            p5.avatarAbilitiesEnabledChangedConn = nil
        end
    end

    p5.thumbstickFrame = Instance.new("Frame")
    p5.thumbstickFrame.Name = "ThumbstickFrame"
    p5.thumbstickFrame.Active = true
    p5.thumbstickFrame.Visible = false
    p5.thumbstickFrame.BackgroundTransparency = 1

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "OuterImage"
    ImageLabel.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
    ImageLabel.ImageRectOffset = Vector2.new()
    ImageLabel.ImageRectSize = Vector2.new(220, 220)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(0, 0, 0, 0)
    p5.stickImage = Instance.new("ImageLabel")
    p5.stickImage.Name = "StickImage"
    p5.stickImage.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
    p5.stickImage.ImageRectOffset = Vector2.new(220, 0)
    p5.stickImage.ImageRectSize = Vector2.new(111, 111)
    p5.stickImage.BackgroundTransparency = 1
    p5.stickImage.ZIndex = 2

    local function ResizeThumbstick() -- line: 120
        -- upvalues: p5 (copy), p6 (copy), ImageLabel (copy), UserAllowAbilityControls (copy), v1 (copy)
        local v6 = math.min(p6.AbsoluteSize.X, p6.AbsoluteSize.Y) <= 500

        if UserAllowAbilityControls and v1.isEnabled() then
            local v7 = if v6 then 64 else 100
            local v8 = if v6 then 64 else 112

            p5.thumbstickSize = v6 and 72 or 120
            p5.screenPos = UDim2.new(0, v7, 1, -p5.thumbstickSize - v8)
        else
            p5.thumbstickSize = v6 and 70 or 120

            local v10 = if v6 then UDim2.new(0, p5.thumbstickSize / 2 - 10, 1, -p5.thumbstickSize - 20) else nil

            p5.screenPos = if not v6 or not v10 then UDim2.new(0, p5.thumbstickSize / 2, 1, -p5.thumbstickSize * 1.75) else v10
        end

        p5.thumbstickFrame.Size = UDim2.new(0, p5.thumbstickSize, 0, p5.thumbstickSize)
        p5.thumbstickFrame.Position = p5.screenPos
        ImageLabel.Size = UDim2.new(0, p5.thumbstickSize, 0, p5.thumbstickSize)
        p5.stickImage.Size = UDim2.new(0, p5.thumbstickSize / 2, 0, p5.thumbstickSize / 2)
        p5.stickImage.Position = UDim2.new(0, p5.thumbstickSize / 2 - p5.thumbstickSize / 4, 0, p5.thumbstickSize / 2 - p5.thumbstickSize / 4)
    end

    ResizeThumbstick()
    p5.absoluteSizeChangedConn = p6:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick)

    if UserAllowAbilityControls then
        p5.avatarAbilitiesEnabledChangedConn = v1.GetEnabledChangedSignal():Connect(ResizeThumbstick)
    end

    ImageLabel.Parent = p5.thumbstickFrame
    p5.stickImage.Parent = p5.thumbstickFrame

    local v11

    local function DoMove(p7) -- line: 154
        -- upvalues: p5 (copy)
        local v12 = p7 / (p5.thumbstickSize / 2)
        local magnitude = v12.magnitude
        local v13

        if magnitude < 0.05 then
            v13 = Vector3.new()
        else
            local v15 = v12.unit * math.min(1, (magnitude - 0.05) / 0.95)

            v13 = Vector3.new(v15.X, 0, v15.Y)
        end

        p5.moveVector = v13
    end

    local function MoveStick(p8) -- line: 172
        -- upvalues: p5 (copy), v11 (ref)
        local v16 = Vector2.new(p8.X - v11.X, p8.Y - v11.Y)
        local magnitude = v16.magnitude
        local v17 = p5.thumbstickFrame.AbsoluteSize.X / 2

        if not (p5.isFollowStick and v17 < magnitude) then
            local v18 = math.min(magnitude, v17)

            v16 = v16.unit * v18
        else
            local v19 = v16.unit * v17

            p5.thumbstickFrame.Position = UDim2.new(0, p8.X - p5.thumbstickFrame.AbsoluteSize.X / 2 - v19.X, 0, p8.Y - p5.thumbstickFrame.AbsoluteSize.Y / 2 - v19.Y)
        end

        p5.stickImage.Position = UDim2.new(0, v16.X + p5.stickImage.AbsoluteSize.X / 2, 0, v16.Y + p5.stickImage.AbsoluteSize.Y / 2)
    end

    p5.thumbstickFrame.InputBegan:Connect(function(p9) -- line: 189
        -- upvalues: p5 (copy), v11 (ref)
        if p5.moveTouchObject or p9.UserInputType ~= Enum.UserInputType.Touch or p9.UserInputState ~= Enum.UserInputState.Begin then
            return
        end

        p5.moveTouchObject = p9
        p5.thumbstickFrame.Position = UDim2.new(0, p9.Position.X - p5.thumbstickFrame.Size.X.Offset / 2, 0, p9.Position.Y - p5.thumbstickFrame.Size.Y.Offset / 2)
        v11 = Vector2.new(p5.thumbstickFrame.AbsolutePosition.X + p5.thumbstickFrame.AbsoluteSize.X / 2, p5.thumbstickFrame.AbsolutePosition.Y + p5.thumbstickFrame.AbsoluteSize.Y / 2)
        Vector2.new(p9.Position.X - v11.X, p9.Position.Y - v11.Y)
    end)
    p5.onTouchMovedConn = UserInputService.TouchMoved:Connect(function(p10, _) -- line: 204
        -- upvalues: p5 (copy), v11 (ref), MoveStick (copy)
        if p10 ~= p5.moveTouchObject then
            return
        end

        v11 = Vector2.new(p5.thumbstickFrame.AbsolutePosition.X + p5.thumbstickFrame.AbsoluteSize.X / 2, p5.thumbstickFrame.AbsolutePosition.Y + p5.thumbstickFrame.AbsoluteSize.Y / 2)

        local v20 = Vector2.new(p10.Position.X - v11.X, p10.Position.Y - v11.Y) / (p5.thumbstickSize / 2)
        local magnitude = v20.magnitude
        local v21

        if magnitude < 0.05 then
            v21 = Vector3.new()
        else
            local v23 = v20.unit * math.min(1, (magnitude - 0.05) / 0.95)

            v21 = Vector3.new(v23.X, 0, v23.Y)
        end

        p5.moveVector = v21
        MoveStick(p10.Position)
    end)
    p5.onTouchEndedConn = UserInputService.TouchEnded:Connect(function(p12, _) -- line: 214
        -- upvalues: p5 (copy)
        if p12 == p5.moveTouchObject then
            p5:OnInputEnded()
        end
    end)
    GuiService.MenuOpened:Connect(function() -- line: 220
        -- upvalues: p5 (copy)
        if p5.moveTouchObject then
            p5:OnInputEnded()
        end
    end)
    p5.thumbstickFrame.Parent = p6
end

return self
