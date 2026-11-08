-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local function available(p1, p2) -- line: 5
    if not p1.Selectable then
        return false
    end

    local v1 = p1

    while v1 and v1 ~= p2 do
        if v1:IsA("GuiObject") and not v1.Visible then
            return false
        end

        v1 = v1.Parent
    end

    return v1 == p2
end

local function nearest(p3, p4, p5) -- line: 15
    local v2 = p4.AbsolutePosition + p4.AbsoluteSize / 2
    local v3, v4

    for _, v5 in p3 do
        local v7 = math.abs((v5.AbsolutePosition + v5.AbsoluteSize / 2)[p5] - v2[p5])

        if not v4 or v7 < v4 then
            v4 = v7
            v3 = v5
        end
    end

    return v3
end

local function readingOrder(p6, p7) -- line: 26
    local AbsolutePosition = p6.AbsolutePosition
    local AbsolutePosition2 = p7.AbsolutePosition

    if math.abs(AbsolutePosition.Y - AbsolutePosition2.Y) > math.min(p6.AbsoluteSize.Y, p7.AbsoluteSize.Y) / 2 then
        return AbsolutePosition.Y < AbsolutePosition2.Y
    end

    return AbsolutePosition.X < AbsolutePosition2.X
end

return function(p8, p9, p10, p11, p12) -- line: 34
    -- upvalues: GuiService (copy), RunService (copy), available (copy), nearest (copy), readingOrder (copy)
    p8.SelectionGroup = true
    p8.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
    p8.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
    p8.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
    p8.SelectionBehaviorRight = Enum.SelectionBehavior.Stop

    local v10 = true
    local t1 = {}
    local t2 = {}
    local t3 = {}

    local function invalidate() -- line: 42
        -- upvalues: v10 (ref)
        v10 = true
    end

    local function connect(p13, p14) -- line: 43
        -- upvalues: t1 (copy)
        table.insert(t1, p13:Connect(p14))
    end

    local function watch(p15) -- line: 46
        -- upvalues: v10 (ref), t2 (copy), invalidate (copy)
        if not p15:IsA("GuiObject") or t2[p15] then
            return
        end

        local t4 = {}

        for _, v11 in { "Visible", "Selectable", "AbsolutePosition", "AbsoluteSize", "LayoutOrder" } do
            table.insert(t4, p15:GetPropertyChangedSignal(v11):Connect(invalidate))
        end

        t2[p15] = t4
        v10 = true
    end

    local function relevant(p16) -- line: 55
        -- upvalues: p10 (copy), p11 (copy), p12 (copy)
        if p16.Parent == p10 or p16.Parent == p11 or p16.Parent == p12 then
            return true
        end

        return p16:IsA("GuiButton") and p16:IsDescendantOf(p12)
    end

    for _, descendant in p8:GetDescendants() do
        if descendant.Parent == p10 or descendant.Parent == p11 or descendant.Parent == p12 or descendant:IsA("GuiButton") and descendant:IsDescendantOf(p12) then
            watch(descendant)
        end
    end

    table.insert(t1, p8.DescendantAdded:Connect(function(p17) -- line: 62
        -- upvalues: p10 (copy), p11 (copy), p12 (copy), watch (copy)
        if p17.Parent == p10 or p17.Parent == p11 or p17.Parent == p12 or p17:IsA("GuiButton") and p17:IsDescendantOf(p12) then
            watch(p17)
        end
    end))
    table.insert(t1, p8.DescendantRemoving:Connect(function(p18) -- line: 65
        -- upvalues: v10 (ref), t2 (copy)
        if t2[p18] then
            for _, v14 in t2[p18] do
                v14:Disconnect()
            end

            t2[p18] = nil
            v10 = true
        end
    end))
    table.insert(t1, p9:GetPropertyChangedSignal("Visible"):Connect(invalidate))
    table.insert(t1, p8:GetPropertyChangedSignal("Visible"):Connect(invalidate))

    local function collect(p19, p20) -- line: 74
        -- upvalues: p8 (copy), available (copy), readingOrder (copy)
        local t5 = {}
        local v15 = if p20 then p19:GetDescendants() else p19:GetChildren()

        for _, v16 in v15 do
            if v16:IsA("GuiButton") and available(v16, p8) and (p20 or v16:GetAttribute("IsInventorySlot") ~= nil) then
                table.insert(t5, v16)
            end
        end

        table.sort(t5, readingOrder)

        return t5
    end

    local function rebuild() -- line: 85
        -- upvalues: p10 (copy), p11 (copy), p12 (copy), t3 (ref), collect (copy), GuiService (copy), nearest (copy)
        local v17 = collect(p10, false)
        local v18 = collect(p11, false)
        local v19 = collect(p12, true)
        local t6 = {}

        for _, v20 in v17 do
            local v21 = t6[#t6]

            if not v21 or math.abs(v20.AbsolutePosition.Y - v21[1].AbsolutePosition.Y) > v20.AbsoluteSize.Y / 2 then
                v21 = {}
                table.insert(t6, v21)
            end

            table.insert(v21, v20)
        end

        local t7 = t3

        t3 = {}

        local n1 = 0

        for v23, v24 in t6 do
            local v25 = n1

            for v26, v27 in v24 do
                v25 += 1
                n1 = v25

                local t8 = t3

                t8[v27] = true
                v27.NextSelectionRight = v17[v25 + 1] or v18[1] or v27
                v27.NextSelectionLeft = v24[v26 - 1] or nearest(v19, v27, "Y") or v17[v25 - 1] or v27

                if v23 > 1 then
                    v27.NextSelectionUp = nearest(t6[v23 - 1], v27, "X")
                else
                    v27.NextSelectionUp = nil
                end

                v27.NextSelectionDown = nearest(t6[v23 + 1] or v18, v27, "X") or v27
            end
        end

        for v28, v29 in v18 do
            local t9 = t3

            t9[v29] = true
            v29.NextSelectionRight = v18[v28 + 1] or v17[1] or v29
            v29.NextSelectionLeft = v18[v28 - 1] or nearest(v19, v29, "Y") or v29
            v29.NextSelectionUp = nearest(t6[#t6] or v19, v29, "X") or v29
            v29.NextSelectionDown = nil
        end

        for v30, v31 in v19 do
            local t10 = t3

            t10[v31] = true
            v31.NextSelectionUp = v19[v30 - 1] or v31
            v31.NextSelectionDown = v19[v30 + 1] or v18[1] or v31
            v31.NextSelectionLeft = v31
            v31.NextSelectionRight = nearest(t6[1] or v18, v31, "Y") or v31
        end

        local SelectedObject = GuiService.SelectedObject
        local GuiService2, v32

        if SelectedObject and t7[SelectedObject] and not t3[SelectedObject] then
            GuiService2 = GuiService
            v32 = v19[1] or v17[1] or v18[1]
            GuiService2.SelectedObject = v32
        end
    end

    table.insert(t1, RunService.RenderStepped:Connect(function() -- line: 130
        -- upvalues: p8 (copy), p9 (copy), v10 (ref), rebuild (copy)
        if v10 and p9.Visible and p8.Visible then
            v10 = false
            rebuild()
        end
    end))
    table.insert(t1, p8.Destroying:Connect(function() -- line: 136
        -- upvalues: t1 (copy), t2 (copy)
        for _, v35 in t1 do
            v35:Disconnect()
        end

        for _, v36 in t2 do
            for _, v37 in v36 do
                v37:Disconnect()
            end
        end
    end))
end
