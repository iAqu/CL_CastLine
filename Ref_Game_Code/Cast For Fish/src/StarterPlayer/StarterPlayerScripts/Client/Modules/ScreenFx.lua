-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UIKit = require(script.Parent.UIKit)
local v1, v2, v3
local t2 = {}
local v4

return {
    Init = function() -- Init | line: 10
        -- upvalues: UIKit (copy), v1 (ref), v2 (ref), v3 (ref), t2 (copy), v4 (ref)
        local v5 = UIKit.screenGui("ScreenFx", 50)

        v5.ScreenInsets = Enum.ScreenInsets.None
        v1 = UIKit.frame(v5, {
            Name = "BarTop",
            Size = UDim2.fromScale(1, 0.13),
            Position = UDim2.fromScale(0, -0.13),
            Color = Color3.new()
        })
        v2 = UIKit.frame(v5, {
            Name = "BarBottom",
            Size = UDim2.fromScale(1, 0.13),
            Position = UDim2.fromScale(0, 1),
            Color = Color3.new()
        })
        v3 = UIKit.frame(v5, {
            Name = "Fade",
            Transparency = 1,
            ZIndex = 5,
            Color = Color3.new()
        })
        v4 = v5

        local v6 = UIKit.frame(v5, {
            Name = "SpeedLines",
            Transparency = 1,
            ZIndex = 2
        })

        for i = 1, 30 do
            local v7 = UIKit.frame(v6, {
                Name = "Line",
                Transparency = 1,
                ZIndex = 2,
                Size = UDim2.fromOffset(6, 300),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Color = Color3.new(1, 1, 1)
            })
            local UIGradient = Instance.new("UIGradient")

            UIGradient.Rotation = 90
            UIGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
            UIGradient.Parent = v7
            v7.Visible = false
            t2[i] = v7
        end
    end,
    Letterbox = function(p1, p2) -- Letterbox | line: 29
        -- upvalues: UIKit (copy), v1 (ref), v2 (ref)
        local tween = UIKit.tween
        local v8 = v1

        tween(v8, p2 or 0.3, {
            Position = UDim2.fromScale(0, p1 and 0 or -0.13)
        })

        local tween2 = UIKit.tween
        local v10 = v2

        tween2(v10, p2 or 0.3, {
            Position = UDim2.fromScale(0, p1 and 0.87 or 1)
        })
    end,
    Fade = function(p3, p4, p5) -- Fade | line: 35
        -- upvalues: UIKit (copy), v3 (ref)
        if p5 then
            v3.BackgroundColor3 = p5
        end

        return UIKit.tween(v3, p4 or 0.5, {
            BackgroundTransparency = 1 - p3
        }, Enum.EasingStyle.Linear)
    end,
    SpeedLines = function(p6, p7) -- SpeedLines | line: 44
        -- upvalues: t2 (copy), v4 (ref)
        local v12 = math.clamp(p6, 0, 1)
        local AbsoluteSize = v4.AbsoluteSize

        for v13, v14 in ipairs(t2) do
            if v12 <= 0.02 then
                v14.Visible = false
            else
                local v15 = v13 / #t2 * 3.141592653589793 * 2 + math.random() * 0.2
                local v16 = 0.37 + math.random() * 0.2

                v14.Position = UDim2.fromScale(0.5 + math.cos(v15) * v16, 0.5 + math.sin(v15) * v16)
                v14.Rotation = math.deg((math.atan2(math.sin(v15) * AbsoluteSize.Y, math.cos(v15) * AbsoluteSize.X))) + 90
                v14.Size = UDim2.fromOffset(4 + math.random() * 6, 200 + math.random() * 320)

                if p7 and v13 % 3 == 0 then
                    v14.BackgroundColor3 = p7
                else
                    v14.BackgroundColor3 = Color3.new(1, 1, 1)
                end

                v14.BackgroundTransparency = 1 - v12 * (0.35 + 0.5 * math.random())
                v14.Visible = true
            end
        end
    end,
    Flash = function(p8, p9) -- Flash | line: 64
        -- upvalues: UIKit (copy), v3 (ref)
        local v20 = v3

        v20.BackgroundColor3 = p9 or Color3.new(1, 1, 1)
        v3.BackgroundTransparency = 0

        return UIKit.tween(v3, p8 or 0.4, {
            BackgroundTransparency = 1
        })
    end
}
