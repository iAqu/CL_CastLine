-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local v1 = TweenInfo.new(0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, -1, true)
local v2 = TweenInfo.new(0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)

return {
    new = function(p1, p2, p3) -- new | line: 10
        -- upvalues: TweenService (copy), v1 (copy), v2 (copy)
        local t2 = {
            _showing = false,
            _dismissed = false,
            _destroyed = false
        }
        local Highlight = Instance.new("Highlight")

        Highlight.Adornee = p2
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.FillTransparency = 1
        Highlight.OutlineTransparency = 1
        Highlight.OutlineColor = Color3.new(1, 1, 1)
        Highlight.Enabled = true
        Highlight.Parent = p1

        local BillboardGui = Instance.new("BillboardGui")

        BillboardGui.Adornee = p2
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Size = UDim2.fromScale(1.75, 1.75)
        BillboardGui.ExtentsOffsetWorldSpace = Vector3.new(-0.85, -1, 0)
        BillboardGui.ClipsDescendants = true
        BillboardGui.Enabled = false
        BillboardGui.Parent = p1

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Image = "rbxassetid://72802720009643"
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Parent = BillboardGui

        local UIScale = Instance.new("UIScale")

        UIScale.Scale = 1
        UIScale.Parent = ImageLabel

        local v3, v4

        p3.Activated:Once(function() -- line: 50
            -- upvalues: t2 (copy)
            t2._dismissed = true
            t2:hide()
        end)

        function t2.show(p4) -- line: 56
            -- upvalues: Highlight (copy), BillboardGui (copy), UIScale (copy), v3 (ref), v4 (ref), TweenService (copy), v1 (copy)
            if p4._showing or p4._dismissed or p4._destroyed then
                return
            end

            p4._showing = true
            BillboardGui.Enabled = true
            v3 = TweenService:Create(Highlight, v1, {
                OutlineTransparency = 0
            })
            v3:Play()
            v4 = TweenService:Create(UIScale, v1, {
                Scale = 0.75
            })
            v4:Play()
        end

        function t2.hide(p5) -- line: 67
            -- upvalues: Highlight (copy), BillboardGui (copy), UIScale (copy), v3 (ref), v4 (ref), TweenService (copy), v2 (copy)
            if not p5._showing or p5._destroyed then
                return
            else
                p5._showing = false

                if v3 then
                    v3:Cancel()
                end
            end

            if v4 then
                v4:Cancel()
            end

            TweenService:Create(Highlight, v2, {
                OutlineTransparency = 1
            }):Play()
            BillboardGui.Enabled = false
            UIScale.Scale = 1
        end

        function t2.destroy(p6) -- line: 77
            -- upvalues: Highlight (copy), BillboardGui (copy)
            if p6._destroyed then
                return
            end

            p6._destroyed = true
            p6:hide()
            Highlight:Destroy()
            BillboardGui:Destroy()
        end

        return t2
    end
}
