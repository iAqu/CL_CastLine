-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Format = require(ReplicatedStorage.Shared.Format)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Effects = require(script.Parent.Effects)
local v1 = Color3.fromRGB(255, 225, 90)
local v2 = Color3.fromRGB(200, 210, 230)

return {
    play = function(p1, p2) -- play | line: 19
        -- upvalues: Format (copy), UIUtil (copy), Kit (copy), Effects (copy), v1 (copy), v2 (copy)
        Effects.flash(p1, Color3.new(1, 1, 1), 0.55, 0)
        UIUtil.sound("LuckRung", 1)

        local Frame = Instance.new("Frame")

        Frame.Name = "NewBest"
        Frame.BackgroundTransparency = 1
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.fromScale(0.5, 0.3)
        Frame.Size = UDim2.fromScale(0.62, 0.2)
        Frame.ZIndex = 30

        local v3 = Kit.text(Frame, "NEW BEST!", {
            Name = "Title",
            ZIndex = 31,
            StrokeThickness = 6,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.fromScale(1, 0.7)
        })
        local UIGradient = Instance.new("UIGradient")

        UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), v1)
        UIGradient.Rotation = 90
        UIGradient.Parent = v3

        local v4 = Kit.text(Frame, ("Beat %*m!"):format((Format.short((math.floor(p2))))), {
            Name = "Beat",
            ZIndex = 31,
            StrokeThickness = 4,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.7),
            Size = UDim2.fromScale(0.5, 0.3),
            TextColor3 = v2
        })

        v4.Visible = false
        Frame.Parent = p1

        local UIScale = Instance.new("UIScale")

        UIScale.Scale = 3
        UIScale.Parent = Frame
        Frame.Rotation = -14
        v3.TextTransparency = 1
        UIUtil.tween(v3, 0.12, {
            TextTransparency = 0
        })
        UIUtil.tween(UIScale, 0.22, {
            Scale = 1
        }, Enum.EasingStyle.Back)
        UIUtil.tween(Frame, 0.7, {
            Rotation = -4
        }, Enum.EasingStyle.Elastic)
        task.delay(0.2, function() -- line: 63
            -- upvalues: Frame (copy), v4 (copy), UIUtil (copy), Kit (copy), v1 (copy)
            local AbsoluteSize = Frame.AbsoluteSize

            Kit.burst(Frame, Vector2.new(AbsoluteSize.X / 2, AbsoluteSize.Y * 0.35), v1, 26, AbsoluteSize.X * 0.45)
            v4.Visible = true
            UIUtil.pop(v4, 1.6)
        end)
        task.delay(0.55, function() -- line: 70
            -- upvalues: Frame (copy), UIScale (copy), UIUtil (copy)
            if Frame.Parent then
                UIUtil.tween(UIScale, 0.12, {
                    Scale = 1.1
                }, Enum.EasingStyle.Quad)
                task.wait(0.12)
                UIUtil.tween(UIScale, 0.3, {
                    Scale = 1
                }, Enum.EasingStyle.Back)
            end
        end)
        task.delay(1.3, function() -- line: 77
            -- upvalues: Frame (copy), v3 (copy), v4 (copy), UIUtil (copy)
            UIUtil.tween(Frame, 0.5, {
                Position = UDim2.fromScale(0.5, 0.2)
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

            for _, v5 in { v3, v4 } do
                UIUtil.tween(v5, 0.45, {
                    TextTransparency = 1
                })

                local UIStroke = v5:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIUtil.tween(UIStroke, 0.45, {
                        Transparency = 1
                    })
                end
            end

            task.wait(0.5)
            Frame:Destroy()
        end)
    end,
    clear = function(p3) -- clear | line: 92
        local NewBest = p3:FindFirstChild("NewBest")

        if NewBest then
            NewBest:Destroy()
        end
    end
}
