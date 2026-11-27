-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t2 = {
    size = 0.4,
    at = Vector2.new(0.1, 0.1),
    red = Color3.fromRGB(235, 45, 45)
}

return {
    Attach = function(p1, p2) -- Attach | line: 32
        -- upvalues: t2 (copy)
        local v1 = table.clone(t2)

        for v2, v3 in pairs(p2 or {}) do
            v1[v2] = v3
        end

        local icon = v1.icon
        local TextLabel, ImageLabel, ImageLabel2

        if v1.image then
            ImageLabel = Instance.new("ImageLabel")
            ImageLabel2 = ImageLabel
            ImageLabel.Image = v1.image
            ImageLabel.BackgroundTransparency = 1
        else
            ImageLabel = Instance.new("Frame")
            ImageLabel2 = ImageLabel
            ImageLabel.BackgroundColor3 = v1.red
        end

        ImageLabel.Name = "Badge"
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Position = UDim2.fromScale(v1.at.X, v1.at.Y)
        ImageLabel.Size = UDim2.fromScale(v1.size, v1.size)
        ImageLabel.BorderSizePixel = 0
        ImageLabel.ZIndex = v1.zIndex or (icon and icon.ZIndex or p1.ZIndex) + 1
        ImageLabel.Visible = false

        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectRatio = 1
        UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
        UIAspectRatioConstraint.Parent = ImageLabel

        if not v1.image then
            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = ImageLabel

            local TextLabel2 = Instance.new("TextLabel")

            TextLabel = TextLabel2
            TextLabel2.Name = "Count"
            TextLabel2.BackgroundTransparency = 1
            TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
            TextLabel2.Position = UDim2.fromScale(0.5, 0.5)
            TextLabel2.Size = v1.text and UDim2.fromScale(0.9, 0.92) or UDim2.fromScale(0.8, 0.7)
            TextLabel2.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.ExtraBold)
            TextLabel2.TextColor3 = Color3.new(1, 1, 1)
            TextLabel2.TextScaled = true
            TextLabel2.Text = ""
            TextLabel2.ZIndex = ImageLabel.ZIndex + 1
            TextLabel2.Parent = ImageLabel
        end

        ImageLabel.Parent = p1

        return {
            Set = function(p3) -- Set | line: 78
                -- upvalues: v1 (copy), TextLabel (ref), ImageLabel2 (ref)
                local v4 = tonumber(p3) or 0

                if TextLabel and v4 > 0 then
                    local TextLabel2 = TextLabel

                    TextLabel2.Text = v1.text or tostring(v4)
                end

                local ImageLabel = ImageLabel2

                ImageLabel.Visible = v4 > 0
            end,
            Destroy = function() -- Destroy | line: 83
                -- upvalues: ImageLabel2 (ref)
                ImageLabel2:Destroy()
            end
        }
    end
}
