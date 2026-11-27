-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local t1 = {}
local ScreenGui

local function getHolder() -- line: 16
    -- upvalues: Players (copy), ScreenGui (ref)
    if ScreenGui and ScreenGui.Parent then
        return ScreenGui
    end

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ImageWarm"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = -1000

    local ScreenGui2 = ScreenGui

    ScreenGui2.ScreenInsets = Enum.ScreenInsets.None

    local ScreenGui3 = ScreenGui

    ScreenGui3.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    return ScreenGui
end

function t1.Keep(p1) -- line: 28
    -- upvalues: Players (copy), ScreenGui (ref)
    if (p1:IsA("ImageLabel") or p1:IsA("ImageButton")) and p1.Image ~= "" then
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = p1.Name
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.ImageTransparency = 0.99
        ImageLabel.ScaleType = p1.ScaleType
        ImageLabel.SliceCenter = p1.SliceCenter
        ImageLabel.ImageRectOffset = p1.ImageRectOffset
        ImageLabel.ImageRectSize = p1.ImageRectSize

        local function sync() -- line: 38
            -- upvalues: p1 (copy), ImageLabel (copy)
            ImageLabel.Image = p1.Image

            local AbsoluteSize = p1.AbsoluteSize

            ImageLabel.Size = UDim2.fromOffset(math.max(1, AbsoluteSize.X), (math.max(1, AbsoluteSize.Y)))
        end

        p1:GetPropertyChangedSignal("Image"):Connect(sync)
        p1:GetPropertyChangedSignal("AbsoluteSize"):Connect(sync)
        p1.Destroying:Connect(function() -- line: 45
            -- upvalues: ImageLabel (copy)
            ImageLabel:Destroy()
        end)
        ImageLabel.Image = p1.Image

        local AbsoluteSize = p1.AbsoluteSize

        ImageLabel.Size = UDim2.fromOffset(math.max(1, AbsoluteSize.X), (math.max(1, AbsoluteSize.Y)))

        if not ScreenGui or not ScreenGui.Parent then
            ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "ImageWarm"
            ScreenGui.ResetOnSpawn = false
            ScreenGui.DisplayOrder = -1000
            ScreenGui.ScreenInsets = Enum.ScreenInsets.None
            ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end

        local ScreenGui2 = ScreenGui

        ImageLabel.Parent = ScreenGui2
    end
end

function t1.KeepAll(p2) -- line: 51
    -- upvalues: t1 (copy)
    for _, descendant in ipairs(p2:GetDescendants()) do
        t1.Keep(descendant)
    end
end

return t1
