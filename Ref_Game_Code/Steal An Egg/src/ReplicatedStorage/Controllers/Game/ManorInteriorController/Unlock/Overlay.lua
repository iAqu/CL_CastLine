-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local t1 = {
    Build = function(p1) -- Build | line: 32
        -- upvalues: LocalPlayer (copy)
        local v1 = p1:Add(Instance.new("ScreenGui"))

        v1.Name = "ManorDoorOverlay"
        v1.IgnoreGuiInset = true
        v1.ResetOnSpawn = false
        v1.DisplayOrder = 46
        v1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Vignette"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://104574024062008"
        ImageLabel.ImageColor3 = Color3.fromRGB(12, 4, 16)
        ImageLabel.ImageTransparency = 1
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.ZIndex = 1
        ImageLabel.Parent = v1

        local Frame = Instance.new("Frame")

        Frame.Name = "Wash"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = Color3.new(1, 1, 1)
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.fromScale(1, 1)
        Frame.ZIndex = 3
        Frame.Parent = v1

        local ImageLabel2 = Instance.new("ImageLabel")

        ImageLabel2.Name = "Ring"
        ImageLabel2.BackgroundTransparency = 1
        ImageLabel2.Image = "rbxassetid://109600784699514"
        ImageLabel2.ImageColor3 = Color3.fromRGB(255, 236, 210)
        ImageLabel2.ImageTransparency = 1
        ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel2.Size = UDim2.fromScale(0.2, 0.2)
        ImageLabel2.ZIndex = 2

        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectRatio = 1
        UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
        UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
        UIAspectRatioConstraint.Parent = ImageLabel2
        ImageLabel2.Parent = v1
        v1.Parent = LocalPlayer:WaitForChild("PlayerGui")

        return {
            Gui = v1,
            Ring = ImageLabel2,
            Wash = Frame,
            Vignette = ImageLabel
        }
    end,
    Ring = function(p2, p3, p4) -- Ring | line: 80
        local Ring = p2.Ring

        Ring.Position = UDim2.fromScale(p3.X, p3.Y)

        if p4 <= 0 or p4 >= 1 then
            Ring.ImageTransparency = 1
        else
            local v2 = p4 * 1.1 + 0.12

            Ring.Size = UDim2.fromScale(v2, v2)
            Ring.ImageTransparency = p4 * 0.9 + 0.1
        end
    end,
    Wash = function(p5, p6, p7) -- Wash | line: 92
        p5.Wash.BackgroundColor3 = p6
        p5.Wash.BackgroundTransparency = 1 - math.clamp(p7, 0, 1)
    end,
    Vignette = function(p8, p9) -- Vignette | line: 97
        p8.Vignette.ImageTransparency = 1 - math.clamp(p9, 0, 1)
    end
}

return table.freeze(t1)
