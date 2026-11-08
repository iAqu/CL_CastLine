-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t2 = {}
local t3 = {}
local iconsDictionary
local CurrentCamera = workspace.CurrentCamera
local t4 = {}
local t5 = {}
local Utility = require(script.Parent.Parent.Utility)
local v1 = false
local v2 = false
local v3
local t1 = {}

function t1.start(p1) -- line: 21
    -- upvalues: t1 (copy), t2 (copy), iconsDictionary (ref), CurrentCamera (copy), Utility (copy), v1 (ref), v3 (ref)
    v3 = p1
    iconsDictionary = v3.iconsDictionary

    local v4

    for _, v5 in pairs(v3.container) do
        if v4 == nil and v5.ScreenInsets == Enum.ScreenInsets.TopbarSafeInsets then
            v4 = v5
        end

        for _, child in pairs(v5.Holders:GetChildren()) do
            if child:GetAttribute("IsAHolder") then
                t2[child.Name] = child
            end
        end
    end

    local v6 = false
    local v7 = Utility.createStagger(0.1, function(p2) -- line: 39
        -- upvalues: v6 (ref), t1 (copy)
        if not v6 then
            return
        end

        if not p2 then
            t1.updateAvailableIcons("Center")
        end

        t1.updateBoundary("Left")
        t1.updateBoundary("Right")
    end)

    task.delay(0.5, function() -- line: 49
        -- upvalues: v6 (ref), v7 (copy)
        v6 = true
        v7()
    end)
    task.delay(2, function() -- line: 53
        -- upvalues: v7 (copy), v1 (ref)
        v1 = true
        v7()
    end)
    v3.iconAdded:Connect(v7)
    v3.iconRemoved:Connect(v7)
    v3.iconChanged:Connect(v7)
    CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 63
        -- upvalues: v7 (copy)
        v7(true)
    end)
    v4:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 66
        -- upvalues: v7 (copy)
        v7(true)
    end)
end

function t1.getWidth(p3, _) -- line: 71
    local widget = p3.widget

    return widget:GetAttribute("TargetWidth") or widget.AbsoluteSize.X
end

function t1.getAvailableIcons(p5) -- line: 76
    -- upvalues: t1 (copy), t3 (copy)
    return t3[p5] or t1.updateAvailableIcons(p5)
end

function t1.updateAvailableIcons(p6) -- line: 84
    -- upvalues: t3 (copy), iconsDictionary (ref), t5 (copy)
    local t6 = {}
    local n1 = 0

    for _, v8 in pairs(iconsDictionary) do
        local parentIconUID = v8.parentIconUID
        local v9 = not parentIconUID or t5[parentIconUID]
        local v10 = t5[v8.UID]

        if v9 and v8.alignment == p6 and not v10 then
            table.insert(t6, v8)
            n1 += 1
        end
    end

    if n1 <= 0 then
        return {}
    end

    table.sort(t6, function(p7, p8) -- line: 105
        local LayoutOrder = p7.widget.LayoutOrder
        local LayoutOrder2 = p8.widget.LayoutOrder
        local parentIconUID = p7.parentIconUID
        local parentIconUID2 = p8.parentIconUID

        if parentIconUID == parentIconUID2 then
            if LayoutOrder < LayoutOrder2 then
                return true
            end

            if LayoutOrder2 < LayoutOrder then
                return false
            end

            return p7.widget.AbsolutePosition.X < p8.widget.AbsolutePosition.X
        end

        if parentIconUID2 then
            return false
        end

        return if parentIconUID then true else nil
    end)
    t3[p6] = t6

    return t6
end

function t1.getRealXPositions(p9, p10) -- line: 131
    -- upvalues: t1 (copy), t2 (copy), Utility (copy)
    local v11 = p9 == "Left"
    local v12 = t2[p9]
    local X = v12.AbsolutePosition.X
    local X2 = v12.AbsoluteSize.X
    local Offset = v12.UIListLayout.Padding.Offset

    if not v11 or not X then
        X += X2
    end

    local t7 = {}

    if v11 then
        Utility.reverseTable(p10)
    end

    for i = #p10, 1, -1 do
        local v13 = p10[i]
        local v14 = t1.getWidth(v13)

        if not v11 then
            X -= v14
        end

        t7[v13.UID] = X

        if v11 then
            X += v14
        end

        X += if v11 and Offset then Offset else -Offset
    end

    return t7
end

function t1.updateBoundary(p11) -- line: 160
    -- upvalues: t1 (copy), t2 (copy), t4 (copy), t5 (copy), Utility (copy), v1 (ref), v2 (ref), v3 (ref)
    local v15 = t2[p11]
    local UIListLayout = v15.UIListLayout
    local X = v15.AbsolutePosition.X
    local X2 = v15.AbsoluteSize.X
    local Offset, Offset2 = UIListLayout.Padding.Offset, UIListLayout.Padding.Offset
    local v16 = t1.updateAvailableIcons(p11)
    local n2 = 0
    local n3 = 0

    for _, v17 in pairs(v16) do
        n2 += t1.getWidth(v17) + Offset2
        n3 += 1
    end

    if n3 <= 0 then
        return
    end

    local v18 = p11 == "Center"
    local v19 = p11 == "Left"
    local v20 = not v19
    local v21 = t4[p11]
    local v23
    local v22 = v21

    if v21 or v18 then
    elseif #v16 > 0 then
        v23 = if v19 then -9999999 else 9999999
        v22 = v3.new()
        v22:setImage(6069276526, "Deselected")
        v22:setName("Overflow" .. p11)
        v22:setOrder(v23)
        v22:setAlignment(p11)
        v22:autoDeselect(false)
        v22.isAnOverflow = true
        v22:select("OverflowStart", v22)
        v22:setEnabled(false)
        t4[p11] = v22
        t5[v22.UID] = true
    end

    local v24 = if p11 == "Left" then "Right" else "Left"
    local v25 = t1.updateAvailableIcons(v24)
    local v26 = v19 and v25[1] or v20 and v25[#v25]
    local v27 = t4[v24]
    local v28 = v19 and X + X2 or X

    if v26 then
        local v29 = t1.getRealXPositions(v24, v25)[v26.UID]
        local v30 = t1.getWidth(v26)

        v28 = v19 and v29 - Offset or v29 + v30 + Offset
    end

    local n4 = 0

    local function checkToShiftCentralIcon() -- line: 223
        -- upvalues: p11 (copy), Offset (copy), v16 (copy), v19 (copy), v20 (copy), n4 (ref), checkToShiftCentralIcon (copy), t1 (copy), v1 (ref), v2 (ref)
        local Center = t1.getAvailableIcons("Center")
        local v31 = Center[if v19 then 1 else #Center]

        local function secondaryCheck() -- line: 227
            -- upvalues: p11 (copy), t1 (copy), v2 (ref)
            if not v2 then
                v2 = true
                task.delay(3, t1.updateBoundary, p11)
            end
        end

        local v32

        if not v31 or v31.hasRelocatedInOverflow then
            return
        elseif v19 then
            v32 = v16[#v16]

            if not v32 then
                v32 = v20

                if v20 then
                    v32 = v16[1]
                end
            end
        else
            v32 = v20

            if v20 then
                v32 = v16[1]
            end
        end

        local X = v31.widget.AbsolutePosition.X
        local X2 = v32.widget.AbsolutePosition.X
        local v34 = t1.getWidth(v32)
        local v35 = v19 and X - Offset or X + t1.getWidth(v31) + Offset
        local v36 = if v19 then X2 + v34 else nil

        if v19 and v36 then
            X2 = v36
        end

        local v37

        if v19 then
            if v35 < X2 then
                if not v1 then
                    if not v2 then
                        v2 = true
                        task.delay(3, t1.updateBoundary, p11)
                    end

                    return
                end

                v31:align("Left")
                v37 = true
                v31.hasRelocatedInOverflow = true
            else
                v37 = false
            end
        elseif v20 and X2 < v35 then
            if not v1 or X2 < 0 then
                if not v2 then
                    v2 = true
                    task.delay(3, t1.updateBoundary, p11)
                end

                return
            end

            v31:align("Right")
            v37 = true
            v31.hasRelocatedInOverflow = true
        else
            v37 = false
        end

        if v37 then
            n4 += 1

            if n4 <= 4 then
                t1.updateAvailableIcons("Center")
                checkToShiftCentralIcon()
            end
        end
    end

    checkToShiftCentralIcon()

    local v41 = false
    local v42 = false
    local v43 = false
    local v44 = false

    if v22 then
        v41 = true
    else
        v44 = true
    end

    local Menu, v45, v46

    if v41 then
        Menu = v22:getInstance("Menu")
        v45 = X + X2

        if Menu then
            v42 = true
        else
            v46 = X2
            v44 = false
        end
    end

    v41 = false

    if v42 then
        if v27 then
            v41 = true
        else
            v46 = X2
            v44 = false
        end
    end

    v42 = false

    local X3, v47

    if v41 then
        X3 = v27.widget.AbsolutePosition.X
        v47 = t1.getWidth(v27)

        if v19 then
            v42 = true
        else
            v43 = true
        end
    end

    v41 = false

    local v48

    if v42 then
        local v49 = X3 - Offset

        if v49 then
            v48 = v49
            v41 = true
        else
            v43 = true
        end
    end

    v42 = false

    if v43 then
        v48 = X3 + v47 + Offset
        v41 = true
    end

    v43 = false

    if v41 then
        local Menu2 = v27:getInstance("Menu")

        if Menu.AbsoluteCanvasSize.X >= Menu2.AbsoluteCanvasSize.X then
            v42 = true
        else
            v43 = true
        end
    end

    v41 = false

    local v50

    if v43 then
        v50 = false
        v41 = true
    end

    v43 = false

    if v42 then
        v50 = true
        v41 = true
    end

    v42 = false

    local v51

    if v41 then
        v51 = X + X2 / 2

        if v19 then
            v42 = true
        else
            v43 = true
        end
    end

    v41 = false

    local v52

    if v42 then
        local v53 = v51 - Offset / 2

        if v53 then
            v52 = v53
            v41 = true
        else
            v43 = true
        end
    end

    v42 = false

    if v43 then
        v52 = v51 + Offset / 2
        v41 = true
    end

    v43 = false

    local v54

    if v41 then
        if v50 then
            v43 = true
        else
            v54 = v52
            v42 = true
        end
    end

    v41 = false

    if v43 then
        v54 = v48
        v42 = true
    end

    v43 = false

    if v42 then
        if v19 then
            v43 = true
        else
            v41 = true
        end
    end

    v42 = false

    local v55

    if v43 then
        local v56 = v54 - X

        if v56 then
            v55 = v56
            v42 = true
        else
            v41 = true
        end
    end

    if v41 then
        v55 = v45 - v54
        v42 = true
    end

    if v42 then
        v46 = v55
        v44 = false
    end

    if not v44 then
        local MaxWidth = Menu and Menu:GetAttribute("MaxWidth")
        local v57 = Utility.round(v46)

        if Menu and MaxWidth ~= v57 then
            Menu:SetAttribute("MaxWidth", v57)
        end
    end

    local v58 = t1.getRealXPositions(p11, v16)
    local v59 = #v16
    local v60 = false

    for i = v59, 1, -1 do
        local v61 = v16[i]
        local v62 = t1.getWidth(v61)
        local v63 = v58[v61.UID]

        if v19 and v28 <= v63 + v62 or v20 and v63 <= v28 then
            v60 = true
        end
    end

    for i = #v16, 1, -1 do
        local v64 = v16[i]

        if not t5[v64.UID] then
            local parentIconUID = if v60 then v64.parentIconUID else nil

            if not v60 or parentIconUID then
                if not v60 and v64.parentIconUID then
                    v64:leave()
                end
            else
                v64:joinMenu(v22)
            end
        end
    end

    if v22.isEnabled ~= v60 then
        v22:setEnabled(v60)
    end

    if v22.isEnabled and not v22.overflowAlreadyOpened then
        v22.overflowAlreadyOpened = true
        v22:select()
    end
end

return t1
