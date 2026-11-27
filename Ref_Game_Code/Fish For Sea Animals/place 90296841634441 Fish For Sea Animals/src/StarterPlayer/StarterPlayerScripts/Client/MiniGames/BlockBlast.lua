-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local Kit = require(script.Parent.Kit)
local BlockDeal = require(script.Parent.BlockDeal)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local t1 = {
    Id = "BlockBlast",
    Name = "Block Game",
    Icon = "🧱",
    Color = Color3.fromRGB(255, 140, 40)
}
local v1 = Color3.fromRGB(34, 38, 60)
local t2 = {
    Color3.fromRGB(255, 80, 80),
    Color3.fromRGB(255, 160, 40),
    Color3.fromRGB(255, 215, 50),
    Color3.fromRGB(90, 215, 80),
    Color3.fromRGB(60, 190, 255),
    Color3.fromRGB(70, 110, 255),
    Color3.fromRGB(175, 90, 255)
}
local t3 = {
    [2] = "GREAT!",
    [3] = "AMAZING!",
    [4] = "INCREDIBLE!"
}

local function dims(p1) -- line: 38
    local n1 = 0
    local n2 = 0

    for _, v2 in p1 do
        n1 = math.max(n1, v2[1] + 1)
        n2 = math.max(n2, v2[2] + 1)
    end

    return n1, n2
end

local function drawPiece(p2, p3, p4, p5) -- line: 48
    -- upvalues: Kit (copy)
    local n3 = 0
    local n4 = 0

    for _, v5 in p3.shape do
        n3 = math.max(n3, v5[1] + 1)
        n4 = math.max(n4, v5[2] + 1)
    end

    local v8 = Kit.frame(p2, {
        Name = "Piece",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(n4 * (p4 + p5) - p5, n3 * (p4 + p5) - p5)
    })

    for _, v9 in p3.shape do
        local v10 = Kit.frame(v8, {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(v9[2] * (p4 + p5), v9[1] * (p4 + p5)),
            Size = UDim2.fromOffset(p4, p4)
        })

        Kit.block(v10, p3.color)
    end

    return v8
end

local function isPress(p6) -- line: 68
    if p6.UserInputType == Enum.UserInputType.MouseButton1 then
        return true
    end

    return p6.UserInputType == Enum.UserInputType.Touch
end

function t1.start(p7, p8) -- line: 72
    -- upvalues: UserInputService (copy), Kit (copy), BlockDeal (copy), UIUtil (copy), v1 (copy), t2 (copy), t3 (copy), drawPiece (copy)
    local ScreenGui = p7:FindFirstAncestorOfClass("ScreenGui")
    local t4 = {}
    local t5 = {}
    local t6 = {}
    local t7 = {}
    local n5 = 0
    local n6 = 0
    local t8
    local v11 = false
    local v12 = false
    local t9 = {}
    local v13 = Kit.frame(p7, {
        Name = "Board",
        BackgroundColor3 = Color3.fromRGB(18, 20, 34),
        Position = UDim2.fromOffset(20, 22),
        Size = UDim2.fromOffset(524, 524)
    })

    Kit.corner(v13, 12)
    Kit.stroke(v13, 4)
    Kit.studs(v13, 0.6, 40, 12)

    for i = 1, 8 do
        local t10 = {}

        t4[i] = {}
        t5[i] = t10

        for j = 1, 8 do
            t4[i][j] = false

            local v14 = Kit.frame(v13, {
                BackgroundColor3 = v1,
                Position = UDim2.fromOffset((j - 1) * 64 + 8, (i - 1) * 64 + 8),
                Size = UDim2.fromOffset(60, 60)
            })

            Kit.corner(v14, 6)

            local v15 = Kit.block(v14, t2[1])

            v15.Visible = false
            t5[i][j] = v15
        end
    end

    for i = 1, 3 do
        local TextButton = Instance.new("TextButton")

        TextButton.Name = ("Slot%*"):format(i)
        TextButton.Text = ""
        TextButton.AutoButtonColor = false
        TextButton.BackgroundColor3 = Color3.fromRGB(18, 20, 34)
        TextButton.BackgroundTransparency = 0.25
        TextButton.BorderSizePixel = 0
        TextButton.Position = UDim2.fromOffset(564, (i - 1) * 177 + 22)
        TextButton.Size = UDim2.fromOffset(204, 170)
        Kit.corner(TextButton, 12)
        Kit.stroke(TextButton, 3)
        TextButton.Parent = p7
        t7[i] = TextButton
    end

    local function fits(p9, p10, p11) -- line: 125
        -- upvalues: t4 (copy)
        for _, v16 in p9 do
            local v17 = p10 + v16[1]
            local v18 = p11 + v16[2]

            if v17 < 1 or v17 > 8 or v18 < 1 or v18 > 8 or t4[v17][v18] then
                return false
            end
        end

        return true
    end

    local function fullLines(p12) -- line: 136
        local t11 = {}
        local t12 = {}

        for i = 1, 8 do
            local v19 = true
            local v20 = true

            for j = 1, 8 do
                v19 = v19 and p12[i][j] ~= false
                v20 = v20 and p12[j][i] ~= false
            end

            if v19 then
                table.insert(t11, i)
            end

            if v20 then
                table.insert(t12, i)
            end
        end

        return t11, t12
    end

    local function show(p13, p14, p15, p16) -- line: 154
        -- upvalues: t5 (copy)
        local v21 = t5[p13][p14]

        v21.Visible = p15 ~= nil

        if not p15 then
            return
        end

        v21.BackgroundColor3 = p15
        v21.BackgroundTransparency = p16 and 0.55 or 0
    end

    local function render() -- line: 164
        -- upvalues: t4 (copy), t5 (copy), t8 (ref), fullLines (copy)
        for i = 1, 8 do
            for j = 1, 8 do
                local v22 = t4[i][j] or nil
                local v23 = t5[i][j]

                v23.Visible = v22 ~= nil

                if v22 then
                    v23.BackgroundColor3 = v22
                    v23.BackgroundTransparency = 0
                end
            end
        end

        if not (t8 and t8.row) then
            return
        end

        local piece = t8.piece
        local v24 = table.clone(t4)

        for i = 1, 8 do
            v24[i] = table.clone(t4[i])
        end

        for _, v25 in piece.shape do
            local v26 = t8.row + v25[1]
            local v27 = t8.col + v25[2]

            v24[v26][v27] = piece.color

            local color = piece.color
            local v28 = t5[v26][v27]

            v28.Visible = color ~= nil

            if color then
                v28.BackgroundColor3 = color
                v28.BackgroundTransparency = 0.55
            end
        end

        local v29, v30 = fullLines(v24)

        for _, v31 in v29 do
            for j = 1, 8 do
                local color = piece.color
                local v32 = t5[v31][j]

                v32.Visible = color ~= nil

                if color then
                    v32.BackgroundColor3 = color
                    v32.BackgroundTransparency = 0
                end
            end
        end

        for _, v33 in v30 do
            for k = 1, 8 do
                local color = piece.color
                local v34 = t5[k][v33]

                v34.Visible = color ~= nil

                if color then
                    v34.BackgroundColor3 = color
                    v34.BackgroundTransparency = 0
                end
            end
        end
    end

    local function drawSlot(p17) -- line: 196
        -- upvalues: t6 (copy), t7 (copy), drawPiece (copy)
        local Piece = t7[p17]:FindFirstChild("Piece")

        if Piece then
            Piece:Destroy()
        end

        if t6[p17] then
            drawPiece(t7[p17], t6[p17], 28, 3)
        end
    end

    local function deal() -- line: 206
        -- upvalues: t4 (copy), t6 (copy), t7 (copy), BlockDeal (copy), UIUtil (copy), t2 (copy), drawPiece (copy)
        local v35 = table.create(8, 0)

        for i = 1, 8 do
            for j = 1, 8 do
                if t4[i][j] then
                    v35[i] = bit32.bor(v35[i], (bit32.lshift(1, j - 1)))
                end
            end
        end

        local v38 = BlockDeal.deal(v35)

        for i = 1, 3 do
            t6[i] = {
                shape = v38[i],
                color = t2[math.random(#t2)]
            }

            local Piece = t7[i]:FindFirstChild("Piece")

            if Piece then
                Piece:Destroy()
            end

            if t6[i] then
                drawPiece(t7[i], t6[i], 28, 3)
            end

            local Piece2 = t7[i]:FindFirstChild("Piece")

            if Piece2 then
                UIUtil.pop(Piece2, 0.3)
            end
        end
    end

    local function anyMoves() -- line: 226
        -- upvalues: t6 (copy), fits (copy)
        for i = 1, 3 do
            local v39 = t6[i]

            if v39 then
                for j = 1, 8 do
                    for k = 1, 8 do
                        if fits(v39.shape, j, k) then
                            return true
                        end
                    end
                end
            end
        end

        return false
    end

    local function cellCenter(p18, p19) -- line: 242
        return Vector2.new((p19 - 1) * 64 + 8 + 30, (p18 - 1) * 64 + 8 + 30)
    end

    local function burst(p20, p21, p22) -- line: 247
        -- upvalues: t5 (copy), v13 (copy), Kit (copy), UIUtil (copy)
        local v40 = Kit.block(t5[p20][p21].Parent, p22)

        v40.AnchorPoint = Vector2.new(0.5, 0.5)
        v40.Position = UDim2.fromScale(0.5, 0.5)
        v40.ZIndex = 3

        local v41 = Kit.frame(v40, {
            ZIndex = 4,
            BackgroundColor3 = Color3.new(1, 1, 1),
            Size = UDim2.fromScale(1, 1)
        })

        Kit.corner(v41, 6)
        UIUtil.tween(v41, 0.18, {
            BackgroundTransparency = 1
        })
        UIUtil.tween(v40, 0.32, {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1.5, 1.5),
            Rotation = math.random(-40, 40)
        }, Enum.EasingStyle.Quad)
        Kit.burst(v13, Vector2.new((p21 - 1) * 64 + 8 + 30, (p20 - 1) * 64 + 8 + 30), p22, 3, 60)
        task.delay(0.32, function() -- line: 261
            -- upvalues: v40 (copy)
            v40:Destroy()
        end)
    end

    local function sweep(p23, p24, p25) -- line: 267
        -- upvalues: v13 (copy), Kit (copy), UIUtil (copy)
        local v42 = Kit.frame(v13, {
            BackgroundTransparency = 0.1,
            ZIndex = 6,
            BackgroundColor3 = p25:Lerp(Color3.new(1, 1, 1), 0.6),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        local v44 = if p23 then p24 else 1
        local v43 = if p23 then 1 else p24
        local v45 = Vector2.new((v43 - 1) * 64 + 8 + 30, (v44 - 1) * 64 + 8 + 30)

        if p23 then
            v42.Position = UDim2.fromOffset(262, v45.Y)
            v42.Size = UDim2.fromOffset(516, 60)
        else
            v42.Position = UDim2.fromOffset(v45.X, 262)
            v42.Size = UDim2.fromOffset(60, 516)
        end

        Kit.corner(v42, 8)

        local v46 = if p23 then UDim2.fromOffset(516, 4) else UDim2.fromOffset(4, 516)

        UIUtil.tween(v42, 0.35, {
            BackgroundTransparency = 1,
            Size = v46
        }, Enum.EasingStyle.Quad)
        task.delay(0.35, function() -- line: 286
            -- upvalues: v42 (copy)
            v42:Destroy()
        end)
    end

    local function cheer(p26, p27, p28) -- line: 292
        -- upvalues: v13 (copy), Kit (copy)
        Kit.floatText(v13, Vector2.new(262, 252), p26, p27, p28)
    end

    local restart, revive

    local function place(p29, p30, p31) -- line: 298
        -- upvalues: p7 (copy), p8 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), n5 (ref), n6 (ref), v11 (ref), v13 (copy), fullLines (copy), render (copy), deal (copy), anyMoves (copy), burst (copy), sweep (copy), cheer (copy), restart (ref), revive (ref), Kit (copy), UIUtil (copy), t3 (copy), drawPiece (copy)
        local v47 = t6[p29]

        t6[p29] = nil

        local Piece = t7[p29]:FindFirstChild("Piece")

        if Piece then
            Piece:Destroy()
        end

        if t6[p29] then
            drawPiece(t7[p29], t6[p29], 28, 3)
        end

        local v48 = Vector2.zero

        for _, v49 in v47.shape do
            t4[p30 + v49[1]][p31 + v49[2]] = v47.color

            local v50 = p30 + v49[1]
            local v51 = p31 + v49[2]

            v48 += Vector2.new((v51 - 1) * 64 + 8 + 30, (v50 - 1) * 64 + 8 + 30)
        end

        local v52 = v48 / #v47.shape
        local v53 = n5

        n5 = v53 + #v47.shape
        render()

        for _, v54 in v47.shape do
            UIUtil.pop(t5[p30 + v54[1]][p31 + v54[2]], 0.75)
        end

        UIUtil.sound("Place", 0.5, 1.1)

        local v55, v56 = fullLines(t4)
        local v57 = #v55 + #v56
        local t13 = {}

        for _, v58 in v55 do
            for i = 1, 8 do
                t13[(v58 - 1) * 8 + i] = { v58, i }
            end
        end

        for _, v59 in v56 do
            for j = 1, 8 do
                t13[(j - 1) * 8 + v59] = { j, v59 }
            end
        end

        for _, v60 in t13 do
            local v61 = v60[1]
            local v62 = v60[2]
            local v63 = t4[v61][v62]

            t4[v61][v62] = false

            local v64 = (Vector2.new((v62 - 1) * 64 + 8 + 30, (v61 - 1) * 64 + 8 + 30) - v52).Magnitude / 64 * 0.03

            task.delay(v64, function() -- line: 334
                -- upvalues: v61 (copy), v62 (copy), v63 (copy), p7 (copy), burst (copy)
                if p7.Parent then
                    burst(v61, v62, v63)
                end
            end)
        end

        local v65 = #v47.shape

        if v57 > 0 then
            n6 += 1

            local v66 = v57 * 10 * v57 * n6

            n5 += v66
            v65 += v66

            for v67, v68 in v55 do
                sweep(true, v68, v47.color)
                task.delay((v67 - 1) * 0.07, UIUtil.sound, "Pop", 0.8, 0.95 + 0.12 * (v67 - 1) + math.min(n6, 6) * 0.08)
            end

            for v72, v73 in v56 do
                sweep(false, v73, v47.color)
                task.delay((#v55 + v72 - 1) * 0.07, UIUtil.sound, "Pop", 0.8, 0.95 + 0.12 * (#v55 + v72 - 1) + math.min(n6, 6) * 0.08)
            end

            Kit.flash(v13, v47.color:Lerp(Color3.new(1, 1, 1), 0.5), v57 * 0.08 + 0.25)
            Kit.shake(v13, v57 * 3 + 3, v57 * 0.06 + 0.15)
            Kit.ring(v13, v52, v47.color:Lerp(Color3.new(1, 1, 1), 0.4), v57 * 80 + 220)

            if v57 >= 2 then
                UIUtil.sound("GoodCast", 0.5, v57 * 0.05 + 1)

                local v77 = t3[math.min(v57, 4)]
                local v78 = Color3.fromRGB(255, 230, 90)

                Kit.floatText(v13, Vector2.new(262, 252), v77, v78, 64)
            end

            if n6 > 1 then
                task.delay(0.15, cheer, ("COMBO x%*!"):format(n6), Color3.fromRGB(255, 140, 220), 48)
            end

            local v79 = true

            for i = 1, 8 do
                for j = 1, 8 do
                    v79 = v79 and not t4[i][j]
                end
            end

            if v79 then
                n5 += 300
                v65 += 300
                task.delay(0.3, cheer, "ALL CLEAR!", Color3.fromRGB(120, 255, 160), 72)
                task.delay(0.3, Kit.burst, v13, Vector2.new(262, 262), Color3.fromRGB(120, 255, 160), 30, 260)
            end
        else
            n6 = 0
        end

        Kit.floatText(v13, v52, ("+%*"):format(v65), Color3.new(1, 1, 1), v57 > 0 and 40 or 28)
        p8(n5)

        if not t6[1] and not t6[2] and not t6[3] then
            deal()
        end

        render()

        if not anyMoves() then
            v11 = true
            task.delay(0.6, function() -- line: 388
                -- upvalues: p7 (copy), n5 (ref), restart (ref), revive (ref), Kit (copy), UIUtil (copy)
                if p7.Parent then
                    UIUtil.sound("Clank", 0.5)
                    Kit.overlay(p7, "No more room!", ("Score: %*"):format(n5), "PLAY AGAIN", restart, revive)
                end
            end)
        end
    end

    local function move(p32) -- line: 397
        -- upvalues: t5 (copy), t8 (ref), fits (copy), render (copy)
        local t14 = t8
        local Parent = t5[1][1].Parent
        local X = Parent.AbsoluteSize.X
        local v80 = X * 64 / 60
        local v81 = if t14.touch then v80 * 1.8 else 0
        local v82 = Vector2.new(p32.X, p32.Y - v81)

        t14.float.Position = UDim2.fromOffset(v82.X, v82.Y)

        local n7 = 0
        local n8 = 0

        for _, v83 in t14.piece.shape do
            n7 = math.max(n7, v83[1] + 1)
            n8 = math.max(n8, v83[2] + 1)
        end

        local v86 = v82 - (Vector2.new(n8 * v80, n7 * v80) - Vector2.one * (v80 - X)) / 2
        local v88 = math.floor((v86.X - Parent.AbsolutePosition.X) / v80 + 0.5) + 1
        local v90 = math.floor((v86.Y - Parent.AbsolutePosition.Y) / v80 + 0.5) + 1

        if fits(t14.piece.shape, v90, v88) then
            t14.row = v90
            t14.col = v88
        else
            t14.row = nil
            t14.col = nil
        end

        render()
    end

    local function endDrag() -- line: 418
        -- upvalues: t6 (copy), t7 (copy), t8 (ref), render (copy), place (copy), drawPiece (copy)
        local t15 = t8

        t8 = nil
        t15.float:Destroy()

        if t15.row then
            place(t15.slot, t15.row, t15.col)
        else
            local slot = t15.slot
            local Piece = t7[slot]:FindFirstChild("Piece")

            if Piece then
                Piece:Destroy()
            end

            if t6[slot] then
                drawPiece(t7[slot], t6[slot], 28, 3)
            end

            render()
        end
    end

    for v91, v92 in t7 do
        table.insert(t9, v92.InputBegan:Connect(function(p33) -- line: 431
            -- upvalues: ScreenGui (copy), t5 (copy), t6 (copy), t8 (ref), v11 (ref), v12 (ref), move (copy), v92 (copy), v91 (copy), UIUtil (copy), drawPiece (copy)
            local v94, v95

            if v11 or v12 or t8 then
                v95 = true
            elseif t6[v91] then
                v94 = p33.UserInputType == Enum.UserInputType.MouseButton1 or p33.UserInputType == Enum.UserInputType.Touch
                v95 = false
            else
                v95 = true
            end

            if v95 or not v94 then
                return
            end

            local X = t5[1][1].Parent.AbsoluteSize.X
            local v96 = X * 4 / 60
            local v97 = drawPiece(ScreenGui, t6[v91], X, v96)

            v97.ZIndex = 50

            local Piece = v92:FindFirstChild("Piece")

            if Piece then
                Piece:Destroy()
            end

            t8 = {
                slot = v91,
                piece = t6[v91],
                float = v97,
                touch = p33.UserInputType == Enum.UserInputType.Touch
            }
            UIUtil.sound("Click", 0.4, 1.2)
            move(p33.Position)
        end))
    end

    table.insert(t9, UserInputService.InputChanged:Connect(function(p34) -- line: 448
        -- upvalues: t8 (ref), move (copy)
        if t8 and (p34.UserInputType == Enum.UserInputType.MouseMovement or p34.UserInputType == Enum.UserInputType.Touch) then
            move(p34.Position)
        end
    end))
    table.insert(t9, UserInputService.InputEnded:Connect(function(p35) -- line: 453
        -- upvalues: t6 (copy), t7 (copy), t8 (ref), render (copy), place (copy), drawPiece (copy)
        if not (t8 and (p35.UserInputType == Enum.UserInputType.MouseButton1 or p35.UserInputType == Enum.UserInputType.Touch)) then
            return
        end

        local t16 = t8

        t8 = nil
        t16.float:Destroy()

        if t16.row then
            place(t16.slot, t16.row, t16.col)
        else
            local slot = t16.slot
            local Piece = t7[slot]:FindFirstChild("Piece")

            if Piece then
                Piece:Destroy()
            end

            if t6[slot] then
                drawPiece(t7[slot], t6[slot], 28, 3)
            end

            render()
        end
    end))

    function restart() -- line: 459
        -- upvalues: p7 (copy), p8 (copy), t4 (copy), n5 (ref), n6 (ref), v11 (ref), render (copy), deal (copy)
        local Overlay = p7:FindFirstChild("Overlay")

        if Overlay then
            Overlay:Destroy()
        end

        for i = 1, 8 do
            t4[i][1] = false
            t4[i][2] = false
            t4[i][3] = false
            t4[i][4] = false
            t4[i][5] = false
            t4[i][6] = false
            t4[i][7] = false
            t4[i][8] = false
        end

        n5 = 0
        n6 = 0
        v11 = false
        p8(0)
        deal()
        render()
    end

    function revive() -- line: 476
        -- upvalues: t4 (copy), n6 (ref), v11 (ref), v13 (copy), render (copy), deal (copy), Kit (copy)
        for i = 1, 8 do
            t4[i][1] = false
            t4[i][2] = false
            t4[i][3] = false
            t4[i][4] = false
            t4[i][5] = false
            t4[i][6] = false
            t4[i][7] = false
            t4[i][8] = false
        end

        n6 = 0
        v11 = false
        deal()
        render()
        Kit.flash(v13, Color3.fromRGB(255, 120, 150), 0.6)
        Kit.floatText(v13, Vector2.new(262, 262), "REVIVED!", Color3.fromRGB(255, 140, 170), 64)
    end

    local function dropDrag() -- line: 490
        -- upvalues: t6 (copy), t7 (copy), t8 (ref), render (copy), drawPiece (copy)
        if not t8 then
            return
        end

        local t17 = t8

        t8 = nil
        t17.float:Destroy()

        local slot = t17.slot
        local Piece = t7[slot]:FindFirstChild("Piece")

        if Piece then
            Piece:Destroy()
        end

        if t6[slot] then
            drawPiece(t7[slot], t6[slot], 28, 3)
        end

        render()
    end

    restart()

    return function() -- line: 501
        -- upvalues: t6 (copy), t7 (copy), t8 (ref), t9 (copy), render (copy), drawPiece (copy)
        for _, v100 in t9 do
            v100:Disconnect()
        end

        if not t8 then
            return
        end

        local t18 = t8

        t8 = nil
        t18.float:Destroy()

        local slot = t18.slot
        local Piece = t7[slot]:FindFirstChild("Piece")

        if Piece then
            Piece:Destroy()
        end

        if t6[slot] then
            drawPiece(t7[slot], t6[slot], 28, 3)
        end

        render()
    end, function(p36) -- line: 506
        -- upvalues: t6 (copy), t7 (copy), t8 (ref), v12 (ref), render (copy), drawPiece (copy)
        v12 = p36

        if not (p36 and t8) then
            return
        end

        local t19 = t8

        t8 = nil
        t19.float:Destroy()

        local slot = t19.slot
        local Piece = t7[slot]:FindFirstChild("Piece")

        if Piece then
            Piece:Destroy()
        end

        if t6[slot] then
            drawPiece(t7[slot], t6[slot], 28, 3)
        end

        render()
    end
end

return t1
