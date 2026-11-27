-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Style)

return {
    new = function(p1, p2) -- new | line: 19
        -- upvalues: RunService (copy), Kit (copy), Style (copy)
        local ImageButton = Instance.new("ImageButton")

        ImageButton.BackgroundTransparency = 1
        ImageButton.Image = ""
        ImageButton.Size = UDim2.fromOffset(p1, p1)

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Shine"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://86205314584043"
        ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Position = UDim2.fromScale(0.5, 0.45)
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.Parent = ImageButton

        local v1 = Kit.frame(ImageButton, {
            Name = "Art",
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.42),
            Size = UDim2.fromScale(0.72, 0.72)
        })
        local v3 = Kit.text(ImageButton, p2, {
            Name = "Label",
            ZIndex = 3,
            StrokeThickness = 4,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -2),
            Size = UDim2.new(1, 0, 0, (math.floor(p1 * 0.24)))
        })

        Style.gradient(v3, ColorSequence.new(Style.YELLOW, Style.GOLD))

        local v4 = true

        ImageButton.Destroying:Connect(function() -- line: 52
            -- upvalues: v4 (ref)
            v4 = false
        end)

        local elapsed = os.clock()

        task.spawn(function() -- line: 56
            -- upvalues: ImageButton (copy), ImageLabel (copy), v1 (copy), v4 (ref), elapsed (copy), RunService (copy)
            while v4 do
                if ImageButton.Visible and ImageButton.Parent then
                    local v5 = os.clock() - elapsed

                    ImageLabel.Rotation = v5 * 35 % 360
                    v1.Position = UDim2.new(0.5, 0, 0.42, math.sin(v5 * 3) * 4)

                    local Wiggle = ImageButton:GetAttribute("Wiggle")
                    local v7, v8

                    if Wiggle then
                        local v9 = (v5 + Wiggle) % 4

                        if v9 < 0.45 then
                            local v10 = v9 / 0.45

                            v7 = -16 * (1 - v10) * math.sin(v10 * 3.141592653589793 * 5)
                        else
                            v7 = 0
                        end

                        v8 = math.sin(math.min(v9 / 0.6, 1) * 3.141592653589793) * 0.18 + 1
                    else
                        v7 = 0
                        v8 = 1
                    end

                    v1.Rotation = math.sin(v5 * 2) * 4 + v7
                    v1.Size = UDim2.fromScale(v8 * 0.72, v8 * 0.72)
                end

                RunService.RenderStepped:Wait()
            end
        end)

        return ImageButton, v1, ImageLabel, v3
    end,
    wiggle = function(p3, p4) -- wiggle | line: 84
        p3:SetAttribute("Wiggle", p4 or 0)
    end,
    image = function(p5, p6) -- image | line: 89
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Icon"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = p6
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.ZIndex = 2
        ImageLabel.Parent = p5

        return ImageLabel
    end
}
