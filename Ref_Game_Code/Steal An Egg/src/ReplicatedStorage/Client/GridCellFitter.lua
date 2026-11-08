-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function renderScale(p1) -- line: 13
    local n1 = 1
    local v1 = p1

    while v1 ~= nil and not v1:IsA("LayerCollector") do
        local UIScale = v1:FindFirstChildWhichIsA("UIScale")

        n1 = if UIScale == nil then n1 else n1 * UIScale.Scale
        v1 = v1.Parent
    end

    if n1 > 0 then
        return n1
    end

    return 1
end

local function wholePixels(p2, p3) -- line: 26
    return (math.floor(p2.Scale * p3 + p2.Offset))
end

function t1.Fit(p4, p5, p6) -- line: 34
    -- upvalues: renderScale (copy)
    local Parent = p4.Parent

    assert(Parent ~= nil and Parent:IsA("GuiObject"), (("%* needs a GuiObject parent"):format((p4:GetFullName()))))

    local v5 = p6 or UDim2.new()
    local v6 = p5

    local function refit(p7) -- line: 41
        -- upvalues: p4 (copy), Parent (copy), v6 (ref), v5 (copy), renderScale (copy)
        if p7 ~= nil then
            v6 = p7
        end

        assert(v6 >= 1, (("%* cannot fit %* columns"):format(p4:GetFullName(), v6)))

        local v9 = renderScale(Parent)
        local Parent2 = if Parent:IsA("ScrollingFrame") then Parent else nil
        local v10 = (if Parent2 == nil then Parent.AbsoluteSize else Parent2.AbsoluteWindowSize) / v9
        local X = v5.X
        local X2 = v10.X
        local v12 = math.floor(X.Scale * X2 + X.Offset)
        local Y = v5.Y
        local Y2 = v10.Y
        local v14 = math.floor(Y.Scale * Y2 + Y.Offset)
        local v15 = Parent.AbsoluteSize.X / v9

        if Parent2 ~= nil then
            v15 -= Parent2.ScrollBarThickness
        end

        local v18 = math.max(math.floor(v15 / v6) - v12, 0)

        p4.CellPadding = UDim2.fromOffset(v12, v14)
        p4.CellSize = UDim2.fromOffset(v18, v18)
    end

    local connection = Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 63
        -- upvalues: refit (copy)
        refit()
    end)

    p4.Destroying:Once(function() -- line: 66
        -- upvalues: connection (copy)
        connection:Disconnect()
    end)
    refit()

    return refit
end

return table.freeze(t1)
