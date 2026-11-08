-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Measure = function(p1) -- Measure | line: 5
        local v1 = p1.X * 0.5271577
        local v2 = v1 / 1.2553575
        local v3 = if v2 < 400 then 48 else 64

        return {
            Width = v1,
            Height = v2,
            Header = v3,
            GridTop = v3 + 90
        }
    end
}

function t1.Apply(p2, p3) -- line: 17
    -- upvalues: t1 (copy)
    local v4 = t1.Measure(p3)

    p2.Size = UDim2.fromOffset(v4.Width, v4.Height)

    local UIAspectRatioConstraint = p2:FindFirstChildOfClass("UIAspectRatioConstraint")

    if UIAspectRatioConstraint then
        UIAspectRatioConstraint.AspectRatio = v4.Width / v4.Height
    end

    local Header = p2:FindFirstChild("Header")

    Header.AnchorPoint = Vector2.new(0.5, 0)
    Header.Position = UDim2.fromScale(0.5, 0)
    Header.Size = UDim2.new(1, 0, 0, v4.Header)

    local Close = p2:FindFirstChild("Close")

    Close.AnchorPoint = Vector2.new(1, 0)
    Close.Position = UDim2.new(1, -8, 0, (v4.Header - 44) / 2)
    Close.Size = UDim2.fromOffset(44, 44)

    local Title = p2:FindFirstChild("Title")

    Title.AnchorPoint = Vector2.zero
    Title.Position = UDim2.fromOffset(16, v4.Header + 6)
    Title.Size = UDim2.new(1, -32, 0, 26)

    local IncludeEquipped = p2:FindFirstChild("IncludeEquipped")

    IncludeEquipped.AnchorPoint = Vector2.zero
    IncludeEquipped.Position = UDim2.fromOffset(16, v4.Header + 36)
    IncludeEquipped.Size = UDim2.new(1, -32, 0, 44)

    local ScrollingFrame = p2:FindFirstChild("ScrollingFrame")

    ScrollingFrame.AnchorPoint = Vector2.zero
    ScrollingFrame.Position = UDim2.fromOffset(12, v4.GridTop)
    ScrollingFrame.Size = UDim2.new(1, -24, 1, -v4.GridTop - 12)

    local EmptyState = p2:FindFirstChild("EmptyState")

    EmptyState.AnchorPoint = Vector2.zero
    EmptyState.Position = UDim2.fromOffset(24, v4.GridTop)
    EmptyState.Size = UDim2.new(1, -48, 1, -v4.GridTop - 12)

    local Frame = p2:FindFirstChild("Frame")

    Frame.AnchorPoint = Vector2.zero
    Frame.Position = UDim2.fromOffset(8, v4.Header)
    Frame.Size = UDim2.new(1, -16, 1, -v4.Header - 8)
end

return table.freeze(t1)
