-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local v1 = Color3.new(1, 1, 1)

return {
    new = function(p1) -- new | line: 28
        -- upvalues: TweenService (copy), v1 (copy)
        local v2, v3, v4, v5, v6
        local t1 = {}

        function t1.frameScale(p2, p3) -- line: 37
            -- upvalues: p1 (copy), v2 (ref), TweenService (copy)
            if not p1.frameScale then
                return nil
            end

            if v2 then
                v2:Cancel()
            end

            local v7 = TweenInfo.new(p3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            v2 = TweenService:Create(p1.frameScale, v7, {
                Scale = p2
            })
            v2:Play()

            return v2
        end

        function t1.buttonScale(p4, p5) -- line: 50
            -- upvalues: p1 (copy), v3 (ref), TweenService (copy)
            if not p1.buttonScale then
                return nil
            end

            if v3 then
                v3:Cancel()
            end

            local v8 = TweenInfo.new(p5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            v3 = TweenService:Create(p1.buttonScale, v8, {
                Scale = p4
            })
            v3:Play()

            return v3
        end

        function t1.stroke(p6, p7) -- line: 63
            -- upvalues: p1 (copy), v4 (ref), TweenService (copy)
            if p1.frameStroke then
                if v4 then
                    v4:Cancel()
                end

                local v9 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                v4 = TweenService:Create(p1.frameStroke, v9, {
                    Color = p6,
                    Thickness = p7
                })
                v4:Play()
            end
        end

        function t1.strokeHoverIn() -- line: 78
            -- upvalues: t1 (copy), v1 (copy)
            t1.stroke(v1, 10)
        end

        function t1.strokeHoverOut() -- line: 82
            -- upvalues: p1 (copy), t1 (copy)
            t1.stroke(p1.baseStrokeColor, p1.baseStrokeThickness)
        end

        function t1.brightness(p8, p9) -- line: 86
            -- upvalues: p1 (copy), v5 (ref), TweenService (copy)
            if v5 then
                v5:Cancel()
            end

            local v10 = TweenInfo.new(p9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            v5 = TweenService:Create(p1.surfaceGui, v10, {
                Brightness = p8
            })
            v5:Play()
        end

        function t1.background(p10, p11) -- line: 95
            -- upvalues: p1 (copy), v6 (ref), TweenService (copy)
            if p1.surface then
                if v6 then
                    v6:Cancel()
                end

                local v11 = TweenInfo.new(p11, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                v6 = TweenService:Create(p1.surface, v11, {
                    BackgroundColor3 = p10
                })
                v6:Play()
            end
        end

        function t1.hoverIn() -- line: 107
            -- upvalues: p1 (copy), t1 (copy)
            t1.frameScale(1.03, 0.12)
            t1.buttonScale(1.15, 0.12)
            t1.strokeHoverIn()
            t1.brightness(1.25, 0.12)
            t1.background(p1.bumpedBackground, 0.12)
        end

        function t1.resetHover() -- line: 115
            -- upvalues: p1 (copy), t1 (copy)
            t1.frameScale(1, 0.12)
            t1.buttonScale(1, 0.12)
            t1.strokeHoverOut()
            t1.brightness(p1.baseBrightness, 0.12)
            t1.background(p1.baseBackground, 0.12)
        end

        local v12 = false

        function t1.shakeIcon() -- line: 125
            -- upvalues: p1 (copy), v12 (ref), TweenService (copy)
            if v12 or #p1.shakeTargets == 0 then
                return
            end

            v12 = true

            for _, v13 in p1.shakeTargets do
                v13.instance.Rotation = v13.baseRotation
            end

            task.spawn(function() -- line: 136
                -- upvalues: p1 (copy), v12 (ref), TweenService (copy)
                local v14 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                for _, v15 in { 4, -4, 4, 0 } do
                    local v16

                    for _, v17 in p1.shakeTargets do
                        v16 = TweenService:Create(v17.instance, v14, {
                            Rotation = v17.baseRotation + v15
                        })
                        v16:Play()
                    end

                    if v16 then
                        v16.Completed:Wait()
                    end
                end

                for _, v18 in p1.shakeTargets do
                    v18.instance.Rotation = v18.baseRotation
                end

                v12 = false
            end)
        end

        return t1
    end
}
