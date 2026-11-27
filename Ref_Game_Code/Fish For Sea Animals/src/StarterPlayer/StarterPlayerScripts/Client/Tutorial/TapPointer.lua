-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Vector2.new(0.1, 0.08)
local ScreenGui, ImageLabel, v2, v3, v4
local v5 = Vector2.zero
local n1 = 0

local function ring(p1) -- line: 33
    -- upvalues: UIUtil (copy)
    local Part = Instance.new("Part")

    Part.Shape = Enum.PartType.Cylinder
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Color = Color3.new(1, 1, 1)
    Part.Size = Vector3.new(0.15, 1.5, 1.5)
    Part.CFrame = CFrame.new(p1 + Vector3.new(0, 0.1, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part.Parent = workspace
    UIUtil.tween(Part, 0.7, {
        Size = Vector3.new(0.05, 9, 9),
        Transparency = 1
    }, Enum.EasingStyle.Quart)
    task.delay(0.75, Part.Destroy, Part)
end

local function screenRing(p2, p3) -- line: 47
    -- upvalues: UIUtil (copy), ImageLabel (ref)
    local Frame = Instance.new("Frame")

    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromOffset(p2.X, p2.Y)
    Frame.Size = UDim2.fromOffset(16, 16)
    Frame.BackgroundTransparency = 1
    Frame.Interactable = false
    Frame.ZIndex = ImageLabel.ZIndex - 1

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Color3.new(1, 1, 1)
    UIStroke.Thickness = 5
    UIStroke.Parent = Frame
    Frame.Parent = p3

    local v6 = math.clamp(UIUtil.scale, 0.6, 1) * 110

    UIUtil.tween(Frame, 0.6, {
        Size = UDim2.fromOffset(v6, v6)
    }, Enum.EasingStyle.Quart)
    UIUtil.tween(UIStroke, 0.6, {
        Transparency = 1,
        Thickness = 1
    }, Enum.EasingStyle.Quart)
    task.delay(0.65, Frame.Destroy, Frame)
end

local function onPad() -- line: 69
    -- upvalues: UserInputService (copy)
    return UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil
end

local function render() -- line: 73
    -- upvalues: UserInputService (copy), UIUtil (copy), v1 (copy), ScreenGui (ref), ImageLabel (ref), v2 (ref), v3 (ref), v4 (ref), v5 (ref), n1 (ref), ring (copy), screenRing (copy)
    local v7 = v3 and v3()
    local ScreenGui2 = ScreenGui
    local v8, v9, v12
    local v10 = ScreenGui2
    local v11 = v7

    if v7 then
    elseif v4 then
        v8 = v4()
        v9 = v8 and v8:FindFirstAncestorOfClass("ScreenGui")

        if v9 then
            local v13 = v8.AbsolutePosition - v9.AbsolutePosition

            v11 = v13 + v8.AbsoluteSize * v5
            v10 = v9
            v12 = v13.X + v8.AbsoluteSize.X
        end
    end

    if ImageLabel.Parent ~= v10 then
        ImageLabel.Parent = v10
    end

    local v14 = not v11 and v2 and v2()

    if not v14 and not v11 then
        ScreenGui.Enabled = false

        return
    end

    local v15 = os.clock() % 0.9 / 0.9
    local v16 = if v15 < 0.6 then math.sin(v15 / 0.6 * 3.141592653589793) else 0
    local v18 = v11 ~= nil and UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil
    local v20 = (if v18 then 84 else 150) * math.clamp(UIUtil.scale, 0.6, 1)
    local v21 = if v18 then UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonA) else "rbxassetid://284663799"

    if ImageLabel.Image ~= v21 then
        ImageLabel.Image = v21
    end

    local ImageLabel2 = ImageLabel

    if v18 then
        ImageLabel2.AnchorPoint = Vector2.new(0, 0.5)
        ImageLabel.Position = UDim2.fromOffset((v12 or v11.X) + v20 * 0.15, v11.Y)
        ScreenGui.Enabled = true
    else
        ImageLabel2.AnchorPoint = v1

        if v11 then
            ImageLabel.Position = UDim2.fromOffset(v11.X, v11.Y - v16 * v20 * 0.4)
            ScreenGui.Enabled = true
        else
            local v23, v24 = workspace.CurrentCamera:WorldToViewportPoint(v14 + Vector3.new(0, v16 * 2.6 + 0.4, 0))

            ScreenGui.Enabled = v24
            ImageLabel.Position = UDim2.fromOffset(v23.X, v23.Y)
        end
    end

    local v25 = if not (v15 >= 0.6 and v15 < 0.75) then 1 else 0.88

    ImageLabel.Size = UDim2.fromOffset(v20 / v25, v20 * v25)

    if v15 >= 0.6 and os.clock() - n1 > 0.45 then
        n1 = os.clock()

        if v11 then
            screenRing(v11, v10)
        else
            ring(v14)
        end
    end
end

function t1.init() -- line: 131
    -- upvalues: RunService (copy), LocalPlayer (copy), v1 (copy), ScreenGui (ref), ImageLabel (ref), render (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TutorialPointer"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Enabled = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    ImageLabel = Instance.new("ImageLabel")
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://284663799"
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.AnchorPoint = v1
    ImageLabel.Interactable = false
    ImageLabel.ZIndex = 20
    ImageLabel.Parent = ScreenGui
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    RunService:BindToRenderStep("TutorialPointer", Enum.RenderPriority.Camera.Value + 1, render)
end

function t1.show(p4) -- line: 154
    -- upvalues: v2 (ref), v3 (ref), v4 (ref)
    v2 = p4
    v3 = nil
    v4 = nil
end

function t1.showOnScreen(p5) -- line: 162
    -- upvalues: v2 (ref), v3 (ref), v4 (ref)
    v3 = p5
    v2 = nil
    v4 = nil
end

function t1.showOnObject(p6, p7) -- line: 169
    -- upvalues: v2 (ref), v3 (ref), v4 (ref), v5 (ref)
    v4 = p6
    v5 = p7
    v2 = nil
    v3 = nil
end

function t1.hide() -- line: 176
    -- upvalues: ScreenGui (ref), ImageLabel (ref), v2 (ref), v3 (ref), v4 (ref)
    v2 = nil
    v3 = nil
    v4 = nil
    ScreenGui.Enabled = false
    ImageLabel.Parent = ScreenGui
end

return t1
