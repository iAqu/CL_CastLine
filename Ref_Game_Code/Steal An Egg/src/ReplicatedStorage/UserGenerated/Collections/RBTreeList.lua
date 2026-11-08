-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function insertRight2(p1, p2) -- line: 75
    local Right2 = p1.Right2

    p2.Right2 = Right2
    p2.Left2 = p1
    p1.Right2 = p2
    Right2.Left2 = p2
end

local function unlink2(p3) -- line: 83
    p3.Left2.Right2 = p3.Right2
    p3.Right2.Left2 = p3.Left2
end

local function unlink(p4) -- line: 88
    p4.Left2.Right2 = p4.Right2
    p4.Right2.Left2 = p4.Left2
    p4.Left1 = nil
    p4.Right1 = nil
    p4.Left2 = nil
    p4.Right2 = nil
end

local function isRed(p5) -- line: 98
    if p5 then
        return p5.Color1
    end

    return false
end

local function rotateLeft(p6) -- line: 106
    local Right1 = p6.Right1

    p6.Right1 = Right1.Left1
    Right1.Left1 = p6
    Right1.Color1 = p6.Color1
    p6.Color1 = true

    return Right1
end

local function rotateRight(p7) -- line: 116
    local Left1 = p7.Left1

    p7.Left1 = Left1.Right1
    Left1.Right1 = p7
    Left1.Color1 = p7.Color1
    p7.Color1 = true

    return Left1
end

local function flipColors(p8) -- line: 126
    p8.Color1 = not p8.Color1

    local Left1 = p8.Left1

    Left1.Color1 = not Left1.Color1

    local Right1 = p8.Right1

    Right1.Color1 = not Right1.Color1
end

local function moveRedLeft(p9) -- line: 136
    p9.Color1 = not p9.Color1

    local Left1 = p9.Left1

    Left1.Color1 = not Left1.Color1

    local Right1 = p9.Right1

    Right1.Color1 = not Right1.Color1

    local Left1_2 = p9.Right1.Left1
    local Right1_2

    if not Left1_2 or not Left1_2.Color1 then
        Right1_2 = p9

        return Right1_2
    end

    local Right1_3 = p9.Right1
    local Left1_3 = Right1_3.Left1

    Right1_3.Left1 = Left1_3.Right1
    Left1_3.Right1 = Right1_3
    Left1_3.Color1 = Right1_3.Color1
    Right1_3.Color1 = true
    p9.Right1 = Left1_3
    Right1_2 = p9.Right1
    p9.Right1 = Right1_2.Left1
    Right1_2.Left1 = p9
    Right1_2.Color1 = p9.Color1
    p9.Color1 = true
    Right1_2.Color1 = not Right1_2.Color1

    local Left1_4 = Right1_2.Left1

    Left1_4.Color1 = not Left1_4.Color1

    local Right1_4 = Right1_2.Right1

    Right1_4.Color1 = not Right1_4.Color1

    return Right1_2
end

local function moveRedRight(p10) -- line: 148
    p10.Color1 = not p10.Color1

    local Left1 = p10.Left1

    Left1.Color1 = not Left1.Color1

    local Right1 = p10.Right1

    Right1.Color1 = not Right1.Color1

    local Left1_2 = p10.Left1.Left1
    local Left1_3

    if not Left1_2 or not Left1_2.Color1 then
        Left1_3 = p10

        return Left1_3
    end

    Left1_3 = p10.Left1
    p10.Left1 = Left1_3.Right1
    Left1_3.Right1 = p10
    Left1_3.Color1 = p10.Color1
    p10.Color1 = true
    Left1_3.Color1 = not Left1_3.Color1

    local Left1_4 = Left1_3.Left1

    Left1_4.Color1 = not Left1_4.Color1

    local Right1_2 = Left1_3.Right1

    Right1_2.Color1 = not Right1_2.Color1

    return Left1_3
end

local function balance(p11) -- line: 158
    local Right1 = p11.Right1
    local Right1_2 = p11

    if Right1 and Right1.Color1 then
        Right1_2 = p11.Right1
        p11.Right1 = Right1_2.Left1
        Right1_2.Left1 = p11
        Right1_2.Color1 = p11.Color1
        p11.Color1 = true
    end

    local Left1 = Right1_2.Left1
    local Left1_2 = Right1_2

    if Left1 and Left1.Color1 then
        local Left1 = Right1_2.Left1.Left1

        if Left1 and Left1.Color1 then
            Left1_2 = Right1_2.Left1
            Right1_2.Left1 = Left1_2.Right1
            Left1_2.Right1 = Right1_2
            Left1_2.Color1 = Right1_2.Color1
            Right1_2.Color1 = true
        end
    end

    local Left1_3 = Left1_2.Left1

    if Left1_3 and Left1_3.Color1 then
        local Right1 = Left1_2.Right1

        if Right1 and Right1.Color1 then
            Left1_2.Color1 = not Left1_2.Color1

            local Left1 = Left1_2.Left1

            Left1.Color1 = not Left1.Color1

            local Right1 = Left1_2.Right1

            Right1.Color1 = not Right1.Color1
        end
    end

    return Left1_2
end

local function removeMin(p12) -- line: 171
    -- upvalues: balance (copy), removeMin (copy)
    if not p12.Left1 then
        return nil, p12
    end

    local Left1 = p12.Left1
    local Right1 = p12

    if not Left1 or not Left1.Color1 then
        local Left1 = p12.Left1.Left1

        if not Left1 or not Left1.Color1 then
            p12.Color1 = not p12.Color1

            local Left1 = p12.Left1

            Left1.Color1 = not Left1.Color1

            local Right1_2 = p12.Right1

            Right1_2.Color1 = not Right1_2.Color1

            local Left1_2 = p12.Right1.Left1

            if Left1_2 and Left1_2.Color1 then
                local Right1_2 = p12.Right1
                local Left1 = Right1_2.Left1

                Right1_2.Left1 = Left1.Right1
                Left1.Right1 = Right1_2
                Left1.Color1 = Right1_2.Color1
                Right1_2.Color1 = true
                p12.Right1 = Left1
                Right1 = p12.Right1
                p12.Right1 = Right1.Left1
                Right1.Left1 = p12
                Right1.Color1 = p12.Color1
                p12.Color1 = true
                Right1.Color1 = not Right1.Color1

                local Left1_2 = Right1.Left1

                Left1_2.Color1 = not Left1_2.Color1

                local Right1_3 = Right1.Right1

                Right1_3.Color1 = not Right1_3.Color1
            end
        end
    end

    local v1, v2 = removeMin(Right1.Left1)

    Right1.Left1 = v1

    return balance(Right1), v2
end

local function removeMax(p13) -- line: 183
    -- upvalues: balance (copy), removeMax (copy)
    local Left1 = p13.Left1
    local Left1_2 = p13

    if Left1 and Left1.Color1 then
        Left1_2 = p13.Left1
        p13.Left1 = Left1_2.Right1
        Left1_2.Right1 = p13
        Left1_2.Color1 = p13.Color1
        p13.Color1 = true
    end

    if not Left1_2.Right1 then
        return nil, Left1_2
    end

    local Right1 = Left1_2.Right1
    local Left1_3 = Left1_2

    if not Right1 or not Right1.Color1 then
        local Left1 = Left1_2.Right1.Left1

        if not Left1 or not Left1.Color1 then
            Left1_2.Color1 = not Left1_2.Color1

            local Left1 = Left1_2.Left1

            Left1.Color1 = not Left1.Color1

            local Right1 = Left1_2.Right1

            Right1.Color1 = not Right1.Color1

            local Left1_4 = Left1_2.Left1.Left1

            if Left1_4 and Left1_4.Color1 then
                Left1_3 = Left1_2.Left1
                Left1_2.Left1 = Left1_3.Right1
                Left1_3.Right1 = Left1_2
                Left1_3.Color1 = Left1_2.Color1
                Left1_2.Color1 = true
                Left1_3.Color1 = not Left1_3.Color1

                local Left1 = Left1_3.Left1

                Left1.Color1 = not Left1.Color1

                local Right1 = Left1_3.Right1

                Right1.Color1 = not Right1.Color1
            end
        end
    end

    local v3, v4 = removeMax(Left1_3.Right1)

    Left1_3.Right1 = v3

    return balance(Left1_3), v4
end

(function()
    local height

    function height(p14) -- line: 198
        -- upvalues: height (ref)
        if not p14 then
            return -1
        end

        local v5 = height(p14.Left1)
        local height2 = height

        return math.max(v5, height2(p14.Right1)) + 1
    end

    return height
end)()

local function isBST(p15, p16, p17, p18) -- line: 205
    -- upvalues: isBST (copy)
    if not p16 then
        return true
    end

    if p17 ~= nil and p15(p16.Key, p17) <= 0 or p18 ~= nil and p15(p16.Key, p18) >= 0 then
        return false
    end

    return isBST(p15, p16.Left1, p17, p16.Key) and isBST(p15, p16.Right1, p16.Key, p18)
end

local function remove(p19, p20, p21) -- line: 219
    -- upvalues: balance (copy), removeMin (copy), remove (copy)
    local v6, v7

    if not p20 then
        v7 = p20

        return v7, v6
    end

    local Right1

    if p19(p20.Key, p21) > 0 then
        local Left1 = p20.Left1

        Right1 = p20

        if not Left1 or not Left1.Color1 then
            local Left1 = p20.Left1.Left1

            if not Left1 or not Left1.Color1 then
                p20.Color1 = not p20.Color1

                local Left1 = p20.Left1

                Left1.Color1 = not Left1.Color1

                local Right1_2 = p20.Right1

                Right1_2.Color1 = not Right1_2.Color1

                local Left1_2 = p20.Right1.Left1

                if Left1_2 and Left1_2.Color1 then
                    local Right1_2 = p20.Right1
                    local Left1 = Right1_2.Left1

                    Right1_2.Left1 = Left1.Right1
                    Left1.Right1 = Right1_2
                    Left1.Color1 = Right1_2.Color1
                    Right1_2.Color1 = true
                    p20.Right1 = Left1
                    Right1 = p20.Right1
                    p20.Right1 = Right1.Left1
                    Right1.Left1 = p20
                    Right1.Color1 = p20.Color1
                    p20.Color1 = true
                    Right1.Color1 = not Right1.Color1

                    local Left1_2 = Right1.Left1

                    Left1_2.Color1 = not Left1_2.Color1

                    local Right1_3 = Right1.Right1

                    Right1_3.Color1 = not Right1_3.Color1
                end
            end
        end

        local v8

        v8, v6 = remove(p19, Right1.Left1, p21)
        Right1.Left1 = v8
    else
        local Left1 = p20.Left1
        local Left1_2 = p20

        if Left1 and Left1.Color1 then
            Left1_2 = p20.Left1
            p20.Left1 = Left1_2.Right1
            Left1_2.Right1 = p20
            Left1_2.Color1 = p20.Color1
            p20.Color1 = true
        end

        if p19(Left1_2.Key, p21) == 0 and not Left1_2.Right1 then
            Left1_2.Left2.Right2 = Left1_2.Right2
            Left1_2.Right2.Left2 = Left1_2.Left2
            Left1_2.Left1 = nil
            Left1_2.Right1 = nil
            Left1_2.Left2 = nil
            Left1_2.Right2 = nil

            return nil, Left1_2
        end

        v6 = Left1_2

        if Left1_2.Right1 then
            local Right1 = Left1_2.Right1

            if not Right1 or not Right1.Color1 then
                local Left1 = Left1_2.Right1.Left1

                if not Left1 or not Left1.Color1 then
                    Left1_2.Color1 = not Left1_2.Color1

                    local Left1 = Left1_2.Left1

                    Left1.Color1 = not Left1.Color1

                    local Right1 = Left1_2.Right1

                    Right1.Color1 = not Right1.Color1

                    local Left1_3 = Left1_2.Left1.Left1

                    if Left1_3 and Left1_3.Color1 then
                        v6 = Left1_2.Left1
                        Left1_2.Left1 = v6.Right1
                        v6.Right1 = Left1_2
                        v6.Color1 = Left1_2.Color1
                        Left1_2.Color1 = true
                        v6.Color1 = not v6.Color1

                        local Left1 = v6.Left1

                        Left1.Color1 = not Left1.Color1

                        local Right1 = v6.Right1

                        Right1.Color1 = not Right1.Color1
                    end
                end
            end
        end

        if p19(v6.Key, p21) == 0 then
            local Left1, Right1_2, Color1 = v6.Left1, v6.Right1, v6.Color1

            v6.Left2.Right2 = v6.Right2
            v6.Right2.Left2 = v6.Left2
            v6.Left1 = nil
            v6.Right1 = nil
            v6.Left2 = nil
            v6.Right2 = nil

            if not Left1 or not Right1_2 then
                Right1 = Left1 or Right1_2
            else
                local v9

                v9, Right1 = removeMin(Right1_2)
                Right1.Right1 = v9
                Right1.Left1 = Left1
            end

            Right1.Color1 = Color1
        else
            local v10, v11 = remove(p19, v6.Right1, p21)

            v6.Right1 = v10
            Right1 = v6
            v6 = v11
        end
    end

    return balance(Right1), v6
end

local function insert(p22, p23, p24, p25, p26) -- line: 262
    -- upvalues: balance (copy), insert (copy)
    if p23 then
        local v12 = p22(p23.Key, p25)
        local v13, v14
        local v15 = p23

        if v12 == 0 then
            p23.Value = p26
            v13 = p23
            v14 = false
        else
            if v12 > 0 then
                local v16

                v16, v13, v14 = insert(p22, p23.Left1, p23.Left2, p25, p26)
                p23.Left1 = v16
            else
                local v17

                v17, v13, v14 = insert(p22, p23.Right1, p23, p25, p26)
                p23.Right1 = v17
            end

            if v14 then
                v15 = balance(p23)
            end
        end

        return v15, v13, v14
    end

    local t1 = {
        Color1 = true,
        Left2 = nil,
        Right2 = nil,
        Key = p25,
        Value = p26
    }
    local Right2 = p24.Right2

    t1.Right2 = Right2
    t1.Left2 = p24
    p24.Right2 = t1
    Right2.Left2 = t1

    return t1, t1, true
end

local function isBalanced(p27, p28) -- line: 293
    -- upvalues: isBalanced (copy)
    if not p27 then
        return p28 == 0
    end

    local v18 = if p27.Color1 then p28 else p28 - 1

    return isBalanced(p27.Left1, v18) and isBalanced(p27.Right1, v18)
end

local function size(p29) -- line: 303
    -- upvalues: size (copy)
    if p29 then
        return 0 + 1 + size(p29.Left1) + size(p29.Right1)
    end

    return 0
end

local function selectRank(p30, p31) -- line: 313
    -- upvalues: size (copy), selectRank (copy)
    if not p30 then
        return nil
    end

    local Left1 = p30.Left1
    local v19 = if Left1 then 0 + 1 + size(Left1.Left1) + size(Left1.Right1) else 0

    if p31 < v19 then
        return selectRank(p30.Left1, p31)
    end

    if v19 < p31 then
        return selectRank(p30.Right1, p31 - v19 - 1)
    end

    return p30.Key
end

local function rank(p32, p33, p34) -- line: 327
    -- upvalues: size (copy), rank (copy)
    if not p34 then
        return 0
    end

    local v20 = p32(p34.Key, p33)

    if v20 > 0 then
        return rank(p32, p33, p34.Left1)
    end

    if v20 < 0 then
        local Left1 = p34.Left1

        return (if Left1 then 0 + 1 + size(Left1.Left1) + size(Left1.Right1) else 0) + 1 + rank(p32, p33, p34.Right1)
    end

    local Left1 = p34.Left1

    if Left1 then
        return 0 + 1 + size(Left1.Left1) + size(Left1.Right1)
    end

    return 0
end

local function is23(p35, p36) -- line: 341
    -- upvalues: is23 (copy)
    if not p36 then
        return true
    end

    local Right1 = p36.Right1

    if Right1 and Right1.Color1 then
        return false
    end

    if p36 ~= p35 and p36.Color1 then
        local Left1 = p36.Left1

        if Left1 and Left1.Color1 then
            return false
        end
    end

    return is23(p35, p36.Left1) and is23(p36.Right1)
end

local t2 = {}
local v21 = table.freeze({
    __index = t2
})

function t2.Insert(p37, p38, p39) -- line: 360
    -- upvalues: insert (copy)
    local v22, v23, v24 = insert(p37.Comparator, p37.Root, p37.List, p38, p39)

    v22.Color1 = false
    p37.Root = v22

    if v24 then
        p37.Size += 1
    end

    return v23, v24
end

function t2.Remove(p40, p41) -- line: 370
    -- upvalues: remove (copy)
    local Root = p40.Root
    local v25

    if Root then
        local Left1 = Root.Left1

        if not (Left1 and Left1.Color1) then
            local Right1 = Root.Right1

            if not (Right1 and Right1.Color1) then
                Root.Color1 = true
            end
        end

        local v26

        v26, v25 = remove(p40.Comparator, Root, p41)

        if v26 then
            v26.Color1 = false
        end

        p40.Root = v26

        if v25 then
            p40.Size -= 1
        end
    end

    return v25
end

function t2.RemoveMin(p42) -- line: 389
    -- upvalues: removeMin (copy)
    local Root = p42.Root
    local v27

    if Root then
        local Left1 = Root.Left1

        if not (Left1 and Left1.Color1) then
            local Right1 = Root.Right1

            if not (Right1 and Right1.Color1) then
                Root.Color1 = true
            end
        end

        local v28

        v28, v27 = removeMin(Root)

        if v28 then
            v28.Color1 = false
        end

        p42.Root = v28

        if v27 then
            p42.Size -= 1
        end
    end

    return v27
end

function t2.RemoveMax(p43) -- line: 408
    -- upvalues: removeMax (copy)
    local Root = p43.Root
    local v29

    if Root then
        local Left1 = Root.Left1

        if not (Left1 and Left1.Color1) then
            local Right1 = Root.Right1

            if not (Right1 and Right1.Color1) then
                Root.Color1 = true
            end
        end

        local v30

        v30, v29 = removeMax(Root)

        if v30 then
            v30.Color1 = false
        end

        p43.Root = v30

        if v29 then
            p43.Size -= 1
        end
    end

    return v29
end

function t2.Min(p44) -- line: 427
    local List = p44.List
    local Left1 = List.Left1

    return if Left1 ~= List then Left1 else nil
end

function t2.Max(p45) -- line: 436
    local List = p45.List
    local Right1 = List.Right1

    return if Right1 ~= List then Right1 else nil
end

function t2.GetSize(p46) -- line: 445
    return p46.Size
end

function t2.ForEach(p47, p48) -- line: 449
    assert(type(p48) == "function")

    local List = p47.List
    local v32 = List

    while true do
        v32 = v32.Right2

        if v32 == List then
            break
        end

        p48(v32.Key, v32.Value)
    end
end

function t2.Next(p49, p50) -- line: 462
    local List = p49.List
    local Right2 = (if p50 == nil then p49.List else p50).Right2

    if Right2 == List then
        return nil, nil
    end

    return Right2, Right2
end

function t2.Iterator(p51) -- line: 472
    return p51.Next, p51
end

function t2.IsBST(p52) -- line: 476
    -- upvalues: isBST (copy)
    local Comparator, Root = p52.Comparator, p52.Root
    local v33 = if Root then isBST(Comparator, Root.Left1, nil, Root.Key) else nil

    if (not Root or v33) and Root then
        return (isBST(Comparator, Root.Right1, Root.Key, nil))
    end

    if not Root then
        v33 = true
    end

    return v33
end

function t2.IsSizeConsistent(p53) -- line: 480
    -- upvalues: size (copy)
    local Size, Root = p53.Size, p53.Root

    if Size ~= (if Root then 0 + 1 + size(Root.Left1) + size(Root.Right1) else 0) then
        return false
    end

    local List = p53.List
    local n1 = 0
    local v34 = List

    while true do
        v34 = v34.Right2

        if v34 == List then
            break
        end

        n1 += 1
    end

    return Size == n1
end

function t2.IsRankConsistent(p54) -- line: 502
    -- upvalues: size (copy), selectRank (copy), rank (copy)
    for i = 0, p54.Size - 1 do
        local Root = p54.Root
        local v35

        if Root then
            local Left1 = Root.Left1
            local v36 = if Left1 then 0 + 1 + size(Left1.Left1) + size(Left1.Right1) else 0

            v35 = if i < v36 then selectRank(Root.Left1, i) elseif v36 < i then selectRank(Root.Right1, i - v36 - 1) else Root.Key
        end

        if i ~= rank(p54.Comparator, v35, p54.Root) then
            return false
        end
    end

    p54:ForEach(function(p55, _) -- line: 512
        -- upvalues: p54 (copy), size (copy), selectRank (copy), rank (copy)
        local v37 = rank(p54.Comparator, p55, p54.Root)
        local Root = p54.Root
        local v38

        if Root then
            local Left1 = Root.Left1
            local v39 = if Left1 then 0 + 1 + size(Left1.Left1) + size(Left1.Right1) else 0

            v38 = if v37 < v39 then selectRank(Root.Left1, v37) elseif v39 < v37 then selectRank(Root.Right1, v37 - v39 - 1) else Root.Key
        end

        if p54.Comparator(v38, p55) == 0 then
            return
        end

        return false
    end)

    return true
end

function t2.Is23(p57) -- line: 522
    -- upvalues: is23 (copy)
    return (is23(p57.Root, p57.Root))
end

function t2.IsBalanced(p58) -- line: 526
    -- upvalues: isBalanced (copy)
    local Root = p58.Root
    local n2 = 0
    local v40 = Root

    while v40 do
        if not (v40 and v40.Color1) then
            n2 += 1
        end

        v40 = v40.Left1
    end

    local v41

    if not Root then
        v41 = n2 == 0

        return v41
    end

    if not Root.Color1 then
        n2 -= 1
    end

    v41 = isBalanced(Root.Left1, n2)

    if v41 then
        return (isBalanced(Root.Right1, n2))
    end

    return v41
end

function t2.Check(p59) -- line: 539
    if not p59:IsBST() then
        return false, "Not in symmetric order"
    end

    if not p59:IsSizeConsistent() then
        return false, "Subtree counts not consistent"
    end

    if not p59:IsRankConsistent() then
        return false, "Ranks not consistent"
    end

    if not p59:Is23() then
        return false, "Not a 2-3 tree"
    end

    if p59:IsBalanced() then
        return true
    end

    return false, "Not balanced"
end

table.freeze(t2)

local t3 = {
    Compare = function(p60, p61) -- Compare | line: 563
        if p60 < p61 then
            return -1
        end

        if p61 < p60 then
            return 1
        end

        return 0
    end,
    new = function(p62, _, _) -- new | line: 573
        -- upvalues: v21 (copy)
        assert(type(p62) == "function")

        local t4 = {
            Color1 = false,
            Key = nil,
            Value = nil
        }

        t4.Left2 = t4
        t4.Right2 = t4

        return (setmetatable({
            Root = nil,
            Size = 0,
            Comparator = p62,
            List = t4
        }, v21))
    end
}

return table.freeze(t3)
