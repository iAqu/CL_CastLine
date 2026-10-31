-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local t1 = {}
local v1

local function cloneLayout(p1) -- line: 8
    local t2 = {}
    local t3 = {}
    local v2 = #t3
    local backpackItems = p1.backpackItems

    table.move(backpackItems, 1, #backpackItems, v2 + 1, t3)
    t2.backpackItems = t3

    local t4 = {}
    local v3 = #t4
    local toolbarSlots = p1.toolbarSlots

    table.move(toolbarSlots, 1, #toolbarSlots, v3 + 1, t4)
    t2.toolbarSlots = t4

    return t2
end

local function emitChanged() -- line: 24
    -- upvalues: t1 (copy)
    for v4 in t1 do
        v4()
    end
end

local function getLayoutSourceItemIdKey(p2, p3) -- line: 29
    local t5 = {}
    local t6 = {}

    for _, v5 in p3 do
        if v5.itemType ~= "fish" then
            t6[v5.itemId] = true
        end
    end

    for _, v6 in p2 do
        if v6.itemType == "fish" or t6[v6.itemId] ~= nil then
            table.insert(t5, v6.itemId)
        end
    end

    table.sort(t5)

    return table.concat(t5, ",")
end

local function getLayoutItemIdKey(p4) -- line: 52
    local t7 = {}

    for _, v7 in p4.toolbarSlots do
        if v7 ~= false then
            table.insert(t7, v7.itemId)
        end
    end

    for _, v8 in p4.backpackItems do
        table.insert(t7, v8.itemId)
    end

    table.sort(t7)

    return table.concat(t7, ",")
end

local function createInitialLayout(p5, p6, p7) -- line: 67
    local t8 = {}
    local t9 = {}
    local t10 = {}
    local n1 = 0
    local v9 = false

    while true do
        if v9 then
            n1 += 1
        else
            v9 = true
        end

        if not (n1 < p7) then
            break
        end

        local v10 = p6[n1 + 1]

        table.insert(t8, v10 or false)

        if v10 ~= nil then
            t10[v10.itemId] = true
        end
    end

    for _, v12 in p5 do
        if v12.itemType == "fish" and t10[v12.itemId] == nil then
            table.insert(t9, v12)
        end
    end

    return {
        backpackItems = t9,
        toolbarSlots = t8
    }
end

local function reconcileLayout(p8, p9, p10, p11) -- line: 107
    -- upvalues: getLayoutSourceItemIdKey (copy), getLayoutItemIdKey (copy), createInitialLayout (copy)
    if getLayoutSourceItemIdKey(p8, p9) ~= getLayoutItemIdKey(p11) then
        return (createInitialLayout(p8, p9, p10))
    end

    local t11 = {}

    for _, v13 in p8 do
        t11[v13.itemId] = v13
    end

    local t12 = {}

    for _, v14 in p9 do
        if v14.itemType ~= "fish" then
            t12[v14.itemId] = true
        end
    end

    local t13 = {}
    local n2 = 0
    local v15 = false

    repeat
        if v15 then
            n2 += 1
        else
            v15 = true
        end

        local v16 = false
        local v17 = false
        local v18 = false
        local v19 = false
        local v20 = false
        local v21 = false

        if n2 < p10 then
            v16 = true
        else
            v21 = true
        end

        local v22

        if v16 then
            v22 = p9[n2 + 1]

            if v22 ~= nil then
                v17 = true
            else
                v18 = true
            end
        end

        v16 = false

        if v17 then
            if v22.itemType == "fish" then
                v18 = true
            else
                v16 = true
            end
        end

        v17 = false

        if v16 then
            v21 = false
            table.insert(t13, v22)
        end

        v16 = false

        local v23

        if v18 then
            local v24 = p11.toolbarSlots[n2 + 1]

            if v24 ~= nil then
                v23 = v24
                v17 = true
            else
                v16 = true
            end
        end

        v18 = false

        if v16 then
            v23 = false
            v17 = true
        end

        v16 = false

        local v25

        if v17 then
            if v23 == false then
                v25 = false
                v18 = true
            else
                v16 = true
            end
        end

        v17 = false

        if v16 then
            if v23.itemType == "fish" then
                v19 = true
            else
                v17 = true
            end
        end

        v16 = false

        if v17 then
            v25 = true
            v18 = true
        end

        v17 = false

        if v19 then
            v25 = false
            v18 = true
        end

        v19 = false

        local v26

        if v18 then
            if v25 then
                v19 = true
            else
                v26 = v25
                v17 = true
            end
        end

        v18 = false

        if v19 then
            if t12[v23.itemId] ~= nil then
                v18 = true
            else
                v16 = true
            end
        end

        v19 = false

        local v27

        if v18 then
            v27 = true
            v19 = true
        end

        v18 = false

        if v16 then
            v27 = false
            v19 = true
        end

        v16 = false

        if v19 then
            v26 = not v27
            v17 = true
        end

        v19 = false

        if v17 then
            if v26 then
                v16 = true
            else
                v19 = true
            end
        end

        v17 = false

        if v19 then
            if v23 == false then
                v18 = true
            else
                v17 = true
            end
        end

        v19 = false

        local v28

        if v17 then
            local v29 = t11[v23.itemId]

            if v29 ~= nil then
                v28 = v29
                v20 = true
            else
                v19 = true
            end
        end

        if v19 then
            v28 = false
            v20 = true
        end

        v19 = false

        local v30

        if v20 then
            v30 = v28
            v19 = true
        end

        if v18 then
            v30 = false
            v19 = true
        end

        if v19 then
            v21 = false
            table.insert(t13, v30)
        end

        if v16 then
            v21 = false
            table.insert(t13, false)
        end
    until v21

    local t14 = {}

    for _, v31 in t13 do
        if v31 ~= false then
            t14[v31.itemId] = true
        end
    end

    local t15 = {}

    for _, v32 in p11.backpackItems do
        local v33 = t11[v32.itemId]

        if v33 ~= nil and t14[v33.itemId] == nil then
            table.insert(t15, v33)
        end
    end

    for _, v34 in p8 do
        local v35 = v34.itemType == "fish"

        if v35 then
            v35 = t14[v34.itemId] == nil

            if v35 then
                local v36 = false

                for v37, v38 in t15 do
                    local _ = v37 - 1

                    if v38.itemId == v34.itemId then
                        v36 = true
                        break
                    end
                end

                v35 = not v36
            end
        end

        if v35 then
            table.insert(t15, v34)
        end
    end

    return {
        backpackItems = t15,
        toolbarSlots = t13
    }
end

local function syncToolbarLayout(p12, p13, p14) -- line: 219
    -- upvalues: t1 (copy), v1 (ref), createInitialLayout (copy), reconcileLayout (copy)
    v1 = if v1 ~= nil then reconcileLayout(p12, p13, p14, v1) else createInitialLayout(p12, p13, p14)

    for v39 in t1 do
        v39()
    end
end

local function getToolbarLayout() -- line: 224
    -- upvalues: v1 (ref), cloneLayout (copy)
    if v1 == nil then
        return {
            backpackItems = {},
            toolbarSlots = {}
        }
    end

    return (cloneLayout(v1))
end

local function subscribeToolbarLayout(p15) -- line: 230
    -- upvalues: t1 (copy)
    t1[p15] = true

    return function() -- line: 233
        -- upvalues: p15 (copy), t1 (copy)
        local v40 = t1[p15] ~= nil

        t1[p15] = nil

        return v40
    end
end

local function useSharedToolbarLayout(p16, p17, p18) -- line: 242
    -- upvalues: useEffect (copy), useState (copy), t1 (copy), v1 (ref), createInitialLayout (copy), reconcileLayout (copy), getToolbarLayout (copy)
    local v41, v42 = useState(getToolbarLayout)

    useEffect(function() -- line: 244
        -- upvalues: p16 (copy), p17 (copy), p18 (copy), v42 (copy), t1 (copy), v1 (ref), createInitialLayout (copy), reconcileLayout (copy), getToolbarLayout (copy)
        v1 = if v1 ~= nil then reconcileLayout(p16, p17, p18, v1) else createInitialLayout(p16, p17, p18)

        for v43 in t1 do
            v43()
        end

        v42((getToolbarLayout()))

        local function v44() -- line: 247
            -- upvalues: v42 (copy), getToolbarLayout (copy)
            return v42((getToolbarLayout()))
        end

        t1[v44] = true

        local function v45() -- line: 233
            -- upvalues: v44 (copy), t1 (copy)
            local v46 = t1[v44] ~= nil

            t1[v44] = nil

            return v46
        end

        return function() -- line: 250
            -- upvalues: v45 (copy)
            v45()
        end
    end, { p16, p17, p18 })

    return v41
end

local function findToolbarSlot(p19, p20) -- line: 256
    for i = 0, #p19.toolbarSlots - 1 do
        local v47 = p19.toolbarSlots[i + 1]

        if v47 ~= false and v47.itemId == p20 then
            return i
        end
    end

    return nil
end

local function findBackpackIndex(p21, p22) -- line: 265
    for i = 0, #p21.backpackItems - 1 do
        if p21.backpackItems[i + 1].itemId == p22 then
            return i
        end
    end

    return nil
end

local function moveToolbarItemToBackpack(p23) -- line: 273
    -- upvalues: t1 (copy), v1 (ref), cloneLayout (copy), findToolbarSlot (copy)
    if v1 == nil then
        return nil
    end

    local v48 = cloneLayout(v1)
    local v49 = findToolbarSlot(v48, p23)

    if v49 == nil then
        return nil
    end

    local v50 = v48.toolbarSlots[v49 + 1]

    if v50 == false or v50.itemType ~= "fish" then
        return nil
    end

    v48.toolbarSlots[v49 + 1] = false
    table.insert(v48.backpackItems, v50)
    v1 = v48

    for v51 in t1 do
        v51()
    end
end

return {
    syncToolbarLayout = syncToolbarLayout,
    getToolbarLayout = getToolbarLayout,
    subscribeToolbarLayout = subscribeToolbarLayout,
    useSharedToolbarLayout = useSharedToolbarLayout,
    moveToolbarItemToBackpack = moveToolbarItemToBackpack,
    moveToolbarItemToToolbarSlot = function(p24, p25) -- moveToolbarItemToToolbarSlot | line: 292
        -- upvalues: t1 (copy), v1 (ref), cloneLayout (copy), findToolbarSlot (copy)
        if v1 == nil then
            return nil
        end

        local v52 = cloneLayout(v1)
        local v53 = findToolbarSlot(v52, p24)
        local v54 = #v52.backpackItems - 1
        local v55 = false
        local v56

        for i = 0, v54 do
            if v52.backpackItems[i + 1].itemId == p24 then
                v56 = i
                v55 = true
                break
            end
        end

        if not v55 then
            v56 = nil
        end

        if v53 == nil then
            if v56 ~= nil then
                if v52.toolbarSlots[p25 + 1] ~= false then
                    return nil
                end

                local v57 = table.remove(v52.backpackItems, v56 + 1)

                if v57 == nil then
                    return nil
                end

                v52.toolbarSlots[p25 + 1] = v57
                v1 = v52

                for v58 in t1 do
                    v58()
                end
            end

            return
        end

        local v59 = v52.toolbarSlots[v53 + 1]

        if v59 ~= false and v59.itemType == "fish" then
            local v60 = v52.toolbarSlots[p25 + 1]

            v52.toolbarSlots[p25 + 1] = v59
            v52.toolbarSlots[v53 + 1] = v60
            v1 = v52

            for v61 in t1 do
                v61()
            end
        end

        return nil
    end
}
