-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local ScreenGui
local t2 = {}
local Frame, UIStroke, v1
local n1 = 0

local function frame(p1) -- line: 23
    -- upvalues: ScreenGui (ref)
    local Frame = Instance.new("Frame")

    Frame.BorderSizePixel = 0
    Frame.Interactable = false
    Frame.Active = false

    for v2, v3 in p1 do
        Frame[v2] = v3
    end

    Frame.Parent = ScreenGui

    return Frame
end

local function rectOf(p2) -- line: 37
    return p2.AbsolutePosition - Vector2.one * 10, p2.AbsoluteSize + Vector2.one * 10 * 2
end

local function layout(p3, p4) -- line: 42
    -- upvalues: GuiService (copy), ScreenGui (ref), t2 (copy), Frame (ref)
    local AbsoluteSize = ScreenGui.AbsoluteSize
    local Y = GuiService:GetGuiInset().Y
    local v4 = p3.X + p4.X
    local v5 = p3.Y + p4.Y

    t2.top.Position = UDim2.fromOffset(0, -Y)
    t2.top.Size = UDim2.fromOffset(AbsoluteSize.X, (math.max(p3.Y + Y, 0)))
    t2.bottom.Position = UDim2.fromOffset(0, v5)
    t2.bottom.Size = UDim2.fromOffset(AbsoluteSize.X, (math.max(AbsoluteSize.Y - v5, 0)))
    t2.left.Position = UDim2.fromOffset(0, p3.Y)
    t2.left.Size = UDim2.fromOffset(math.max(p3.X, 0), p4.Y)
    t2.right.Position = UDim2.fromOffset(v4, p3.Y)
    t2.right.Size = UDim2.fromOffset(math.max(AbsoluteSize.X - v4, 0), p4.Y)

    local Frame2 = Frame

    Frame2.Position = UDim2.fromOffset(p3.X, p3.Y)

    local Frame3 = Frame

    Frame3.Size = UDim2.fromOffset(p4.X, p4.Y)
end

function t1.init() -- line: 58
    -- upvalues: GuiService (copy), RunService (copy), LocalPlayer (copy), ScreenGui (ref), t2 (copy), Frame (ref), UIStroke (ref), v1 (ref), n1 (ref), layout (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FocusCube"
    ScreenGui.IgnoreGuiInset = false
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 30
    ScreenGui.Enabled = false

    for _, v9 in { "top", "bottom", "left", "right" } do
        local t3 = {
            BackgroundTransparency = 0.45,
            Name = v9,
            BackgroundColor3 = Color3.new(0, 0, 0)
        }
        local Frame = Instance.new("Frame")

        Frame.BorderSizePixel = 0
        Frame.Interactable = false
        Frame.Active = false

        for v10, v11 in t3 do
            Frame[v10] = v11
        end

        Frame.Parent = ScreenGui
        t2[v9] = Frame
    end

    local t4 = {
        Name = "Window",
        BackgroundTransparency = 1
    }
    local Frame2 = Instance.new("Frame")

    Frame2.BorderSizePixel = 0
    Frame2.Interactable = false
    Frame2.Active = false

    for v12, v13 in t4 do
        Frame2[v12] = v13
    end

    Frame2.Parent = ScreenGui
    Frame = Frame2

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = Frame
    UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.new(1, 1, 1)
    UIStroke.Thickness = 5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    RunService.Heartbeat:Connect(function() -- line: 79
        -- upvalues: GuiService (copy), ScreenGui (ref), UIStroke (ref), v1 (ref), n1 (ref), layout (copy)
        if v1 then
            if not (v1.Parent and v1.Visible) then
                ScreenGui.Enabled = false
            else
                ScreenGui.Enabled = true

                local v14 = v1
                local v15 = v14.AbsolutePosition - Vector2.one * 10
                local v16 = v14.AbsoluteSize + Vector2.one * 10 * 2
                local v18 = 1 - (1 - math.clamp((os.clock() - n1) / 1.8, 0, 1)) ^ 3
                local Y = GuiService:GetGuiInset().Y
                local v19 = ScreenGui.AbsoluteSize + Vector2.new(0, Y)

                layout(Vector2.new(0, -Y):Lerp(v15, v18), v19:Lerp(v16, v18))

                local v21 = (math.sin(os.clock() * 6) + 1) / 2

                UIStroke.Thickness = v21 * 5 + 4
                UIStroke.Transparency = (1 - v21) * 0.25
            end
        end
    end)
end

function t1.show(p5) -- line: 102
    -- upvalues: v1 (ref), n1 (ref)
    if v1 ~= p5 then
        v1 = p5
        n1 = os.clock()
    end
end

function t1.hide() -- line: 110
    -- upvalues: ScreenGui (ref), v1 (ref)
    v1 = nil
    ScreenGui.Enabled = false
end

function t1.isShowing() -- line: 115
    -- upvalues: v1 (ref)
    return v1 ~= nil
end

return t1
