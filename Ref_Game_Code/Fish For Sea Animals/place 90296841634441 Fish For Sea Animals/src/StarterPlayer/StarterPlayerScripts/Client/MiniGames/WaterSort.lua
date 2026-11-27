-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Kit = require(script.Parent.Kit)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local t1 = {
    Id = "WaterSort",
    Name = "Color Sort",
    Icon = "🧪",
    Color = Color3.fromRGB(60, 150, 255)
}
local t2 = {
    Color3.fromRGB(235, 60, 60),
    Color3.fromRGB(50, 110, 240),
    Color3.fromRGB(250, 210, 40),
    Color3.fromRGB(70, 200, 80),
    Color3.fromRGB(160, 80, 230),
    Color3.fromRGB(250, 140, 40),
    Color3.fromRGB(255, 120, 190),
    Color3.fromRGB(70, 215, 230),
    Color3.fromRGB(140, 90, 50)
}

local function colorsFor(p1) -- line: 33
    -- upvalues: t2 (copy)
    return (math.min(p1 + 3, #t2))
end

local function uniform(p2) -- line: 37
    for i = 2, #p2 do
        if p2[i] ~= p2[1] then
            return false
        end
    end

    return true
end

local function solved(p3) -- line: 46
    for _, v3 in p3 do
        if #v3 ~= 0 then
            if #v3 ~= 4 then
                return false
            end

            local v5 = true

            for i = 2, #v3 do
                if v3[i] ~= v3[1] then
                    v5 = false
                    break
                end
            end

            if not v5 then
                return false
            end
        end
    end

    return true
end

local function copy(p4) -- line: 55
    local t3 = {}

    for v6, v7 in p4 do
        t3[v6] = table.clone(v7)
    end

    return t3
end

local function generate(p5) -- line: 64
    -- upvalues: t2 (copy)
    local v10 = math.min(p5 + 3, #t2)
    local t4

    repeat
        local t5 = {}

        for i = 1, v10 do
            table.insert(t5, i)
            table.insert(t5, i)
            table.insert(t5, i)
            table.insert(t5, i)
        end

        for i = #t5, 2, -1 do
            local v11 = math.random(i)
            local v12 = t5[v11]
            local v13 = t5[i]

            t5[i] = v12
            t5[v11] = v13
        end

        t4 = {}

        for i = 1, v10 do
            t4[i] = table.move(t5, (i - 1) * 4 + 1, i * 4, 1, {})
        end

        local v14 = true

        for _, v15 in t4 do
            if v14 then
                local v17 = true

                for j = 2, #v15 do
                    if v15[j] ~= v15[1] then
                        v17 = false
                        break
                    end
                end

                v14 = not v17
            end
        end
    until v14

    table.insert(t4, {})
    table.insert(t4, {})

    return t4
end

function t1.start(p6, p7) -- line: 94
    -- upvalues: Kit (copy), UIUtil (copy), t2 (copy), solved (copy), copy (copy), generate (copy)
    local n1 = 1
    local v18, v19
    local t8 = {}
    local v20
    local t9 = {}
    local v21 = false
    local v22 = false
    local v23 = Kit.frame(p6, {
        Name = "Shelf",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -96)
    })
    local v24 = Kit.text(p6, "", {
        StrokeThickness = 4,
        Position = UDim2.new(0, 20, 1, -78),
        Size = UDim2.fromOffset(190, 56),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local function basePosition(p8) -- line: 116
        -- upvalues: v18 (ref)
        local v25 = #v18
        local v26 = v25 > 7
        local v27 = if v26 then math.ceil(v25 / 2) else v25
        local v29 = if not (v26 and v27 < p8) then 1 else 2
        local v30 = if v29 == 2 then p8 - v27 else p8

        if v29 == 2 then
            v27 = v25 - v27
        end

        local v31 = v27 * 62 + (v27 - 1) * 26
        local v32 = if v26 then (v29 - 1) * 234 + 34 else 141

        return UDim2.new(0.5, -v31 / 2 + (v30 - 1) * 88 + 31, 0, v32 + 95)
    end

    local v33 = Kit.frame(v23, {
        Name = "Fx",
        BackgroundTransparency = 1,
        ZIndex = 6,
        Position = UDim2.fromScale(0.5, 0),
        Size = UDim2.fromOffset(0, 0)
    })

    local function centerOf(p9) -- line: 138
        -- upvalues: basePosition (copy)
        local v34 = basePosition(p9)

        return Vector2.new(v34.X.Offset, v34.Y.Offset)
    end

    local function drawTube(p10) -- line: 143
        -- upvalues: v18 (ref), t9 (copy), Kit (copy), t2 (copy)
        local v35 = t9[p10]

        for _, child in v35:GetChildren() do
            if child.Name == "Layer" then
                child:Destroy()
            end
        end

        for v36, v37 in v18[p10] do
            local v38 = Kit.frame(v35, {
                Name = "Layer",
                ZIndex = 2,
                BackgroundColor3 = t2[v37],
                Position = UDim2.new(0, 6, 1, -6 - v36 * 40),
                Size = UDim2.new(1, -12, 0, (v36 == 1 and 0 or 2) + 40)
            })

            Kit.corner(v38, v36 == 1 and 14 or 3)
            Kit.shade(v38, 0.82).Rotation = 0
        end
    end

    local function setSelected(p11) -- line: 163
        -- upvalues: v20 (ref), t9 (copy), basePosition (copy), UIUtil (copy)
        if v20 and t9[v20] then
            UIUtil.tween(t9[v20], 0.15, {
                Position = basePosition(v20)
            })
        end

        v20 = p11

        if p11 then
            UIUtil.tween(t9[p11], 0.15, {
                Position = basePosition(p11) - UDim2.fromOffset(0, 22)
            })
        end
    end

    local function shake(p12) -- line: 173
        local Position = p12.Position

        task.spawn(function() -- line: 175
            -- upvalues: p12 (copy), Position (copy)
            for _, v39 in { -8, 8, -5, 5, 0 } do
                p12.Position = Position + UDim2.fromOffset(v39, 0)
                task.wait(0.04)
            end
        end)
    end

    local newLevel

    local function celebrateTube(p13, p14) -- line: 186
        -- upvalues: basePosition (copy), v33 (copy), Kit (copy), UIUtil (copy)
        local v40 = basePosition(p13)
        local v41 = Vector2.new(v40.X.Offset, v40.Y.Offset)

        Kit.burst(v33, v41, p14, 14, 90)
        Kit.ring(v33, v41, p14:Lerp(Color3.new(1, 1, 1), 0.4), 228)
        Kit.floatText(v33, v41 - Vector2.new(0, 105), "✔", Color3.fromRGB(140, 255, 120), 40)
        UIUtil.sound("Pop", 0.7, 1.1)
    end

    local function playPour(p15, p16, p17, p18) -- line: 196
        -- upvalues: p6 (copy), t9 (copy), v22 (ref), basePosition (copy), v33 (copy), Kit (copy), UIUtil (copy)
        v22 = true

        local v42 = t9[p15]
        local v43 = basePosition(p15)
        local X = Vector2.new(v43.X.Offset, v43.Y.Offset).X
        local v44 = basePosition(p16)
        local v45 = if X <= Vector2.new(v44.X.Offset, v44.Y.Offset).X then -1 else 1
        local v46 = basePosition(p16)

        v42.ZIndex = 5
        UIUtil.tween(v42, 0.22, {
            Position = v46 + UDim2.fromOffset(v45 * 62 * 0.75, -117.8),
            Rotation = -v45 * 72
        }, Enum.EasingStyle.Quad)
        task.wait(0.22)

        if p6.Parent then
            local v47 = basePosition(p16)
            local v48 = Vector2.new(v47.X.Offset, v47.Y.Offset) - Vector2.new(0, 129)
            local v49 = Kit.frame(v33, {
                Name = "Stream",
                ZIndex = 4,
                BackgroundColor3 = p17,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromOffset(v48.X, v48.Y),
                Size = UDim2.fromOffset(10, 0)
            })

            Kit.corner(v49, 5)
            UIUtil.tween(v49, 0.12, {
                Size = UDim2.fromOffset(10, 212)
            })
            UIUtil.sound("Splash", 0.35, 1.6)
            task.wait(0.12)
            p18()
            UIUtil.pop(t9[p16], 1.08)
            task.wait(0.16)
            UIUtil.tween(v49, 0.1, {
                Size = UDim2.fromOffset(4, 0),
                Position = UDim2.fromOffset(v48.X, v48.Y + 34 + 190 - 12)
            })
            UIUtil.tween(v42, 0.2, {
                Rotation = 0,
                Position = basePosition(p15)
            }, Enum.EasingStyle.Quad)
            task.wait(0.2)
            v49:Destroy()
            v42.ZIndex = 1
            v22 = false
        end
    end

    local function pour(p19, p20) -- line: 234
        -- upvalues: p6 (copy), p7 (copy), n1 (ref), v18 (ref), t8 (copy), v20 (ref), t9 (copy), v21 (ref), basePosition (copy), v33 (copy), drawTube (copy), newLevel (ref), celebrateTube (copy), playPour (copy), Kit (copy), UIUtil (copy), t2 (copy), solved (copy), copy (copy)
        local v50 = v18[p19]
        local v51 = v18[p20]
        local v52 = v50[#v50]

        if not (#v51 >= 4 or #v51 > 0 and v51[#v51] ~= v52) then
            table.insert(t8, (copy(v18)))

            while #v50 > 0 and v50[#v50] == v52 and #v51 < 4 do
                table.insert(v51, table.remove(v50))
            end

            v20 = nil

            local v54 = solved(v18)

            if v54 then
                v21 = true
            end

            task.spawn(playPour, p19, p20, t2[v52], function() -- line: 252
                -- upvalues: p19 (copy), p20 (copy), v51 (copy), v52 (copy), drawTube (copy), celebrateTube (copy), t2 (copy)
                drawTube(p19)
                drawTube(p20)

                if #v51 ~= 4 then
                    return
                end

                local v57 = false
                local v58

                for i = 2, #v51 do
                    if v51[i] ~= v51[1] then
                        v58 = false
                        v57 = true
                        break
                    end
                end

                if not v57 then
                    v58 = true
                end

                if v58 then
                    celebrateTube(p20, t2[v52])
                end
            end)

            if v54 then
                p7(n1)
                task.delay(0.9, function() -- line: 261
                    -- upvalues: p6 (copy), n1 (ref), v18 (ref), basePosition (copy), v33 (copy), newLevel (ref), Kit (copy), UIUtil (copy), t2 (copy)
                    if p6.Parent then
                        UIUtil.sound("GoodCast", 0.6)

                        for i = 1, #v18 do
                            local delay = task.delay
                            local burst = Kit.burst
                            local v59 = basePosition(i)

                            delay(i * 0.06, burst, v33, Vector2.new(v59.X.Offset, v59.Y.Offset), t2[(i - 1) % #t2 + 1], 10, 110)
                        end

                        task.wait(0.5)
                        Kit.overlay(p6, "Sorted!", ("Level %* complete"):format(n1), "NEXT LEVEL", function() -- line: 268
                            -- upvalues: n1 (ref), newLevel (ref)
                            n1 += 1
                            newLevel(true)
                        end)
                    end
                end)
            end
        else
            UIUtil.sound("Clank", 0.35, 1.4)

            local v60 = t9[p20]
            local Position = v60.Position

            task.spawn(function() -- line: 175
                -- upvalues: v60 (copy), Position (copy)
                for _, v61 in { -8, 8, -5, 5, 0 } do
                    v60.Position = Position + UDim2.fromOffset(v61, 0)
                    task.wait(0.04)
                end
            end)

            if v20 and t9[v20] then
                UIUtil.tween(t9[v20], 0.15, {
                    Position = basePosition(v20)
                })
            end

            v20 = nil
        end
    end

    local function onTube(p21) -- line: 277
        -- upvalues: v18 (ref), v20 (ref), t9 (copy), v21 (ref), v22 (ref), basePosition (copy), setSelected (copy), pour (copy), UIUtil (copy)
        if v21 or v22 then
            return
        end

        local v62 = v20 == nil
        local v63

        if v62 then
            v63 = #v18[p21] > 0
        else
            if v20 == p21 then
                if v20 and t9[v20] then
                    UIUtil.tween(t9[v20], 0.15, {
                        Position = basePosition(v20)
                    })
                end

                v20 = nil

                return
            end

            pour(v20, p21)
        end

        if (not v62 or v63) and v62 then
            UIUtil.sound("Click", 0.4, 1.3)
            setSelected(p21)
        end
    end

    local function build() -- line: 293
        -- upvalues: n1 (ref), v18 (ref), v20 (ref), t9 (copy), v23 (copy), v24 (copy), basePosition (copy), drawTube (copy), onTube (copy), Kit (copy)
        for _, v64 in t9 do
            v64:Destroy()
        end

        table.clear(t9)
        v20 = nil

        for v65 in v18 do
            local TextButton = Instance.new("TextButton")

            TextButton.Name = ("Tube%*"):format(v65)
            TextButton.Text = ""
            TextButton.AutoButtonColor = false
            TextButton.BackgroundColor3 = Color3.fromRGB(215, 235, 255)
            TextButton.BackgroundTransparency = 0.82
            TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
            TextButton.Size = UDim2.fromOffset(62, 190)
            TextButton.Position = basePosition(v65)
            Kit.corner(TextButton, 20)
            Kit.stroke(TextButton, 4, Color3.fromRGB(235, 245, 255)).Transparency = 0.1

            local v66 = Kit.frame(TextButton, {
                Name = "Rim",
                BackgroundTransparency = 0.15,
                BackgroundColor3 = Color3.fromRGB(235, 245, 255),
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.new(0.5, 0, 0, -4),
                Size = UDim2.new(1, 12, 0, 10)
            })

            Kit.corner(v66, 5)
            Kit.frame(TextButton, {
                Name = "Glint",
                BackgroundTransparency = 0.6,
                ZIndex = 3,
                BackgroundColor3 = Color3.new(1, 1, 1),
                Position = UDim2.fromOffset(10, 16),
                Size = UDim2.new(0, 6, 1, -40)
            })
            TextButton.Parent = v23
            t9[v65] = TextButton
            TextButton.Activated:Connect(function() -- line: 331
                -- upvalues: v65 (copy), onTube (copy)
                onTube(v65)
            end)
            drawTube(v65)
        end

        v24.Text = ("Level %*"):format(n1)
    end

    function newLevel(p22) -- line: 339
        -- upvalues: p6 (copy), n1 (ref), v18 (ref), v19 (ref), t8 (copy), v21 (ref), build (copy), copy (copy), generate (copy)
        local Overlay = p6:FindFirstChild("Overlay")

        if Overlay then
            Overlay:Destroy()
        end

        v21 = false

        if p22 or not v19 then
            v19 = generate(n1)
        end

        v18 = copy(v19)
        table.clear(t8)
        build()
    end

    local v67 = UDim2.new(0, 0, 1, -84)

    Kit.button(p6, "UNDO", Color3.fromRGB(60, 140, 255), {
        Position = v67 + UDim2.new(1, -558, 0, 0),
        Size = UDim2.fromOffset(170, 64)
    }, function() -- line: 357
        -- upvalues: v18 (ref), t8 (copy), v21 (ref), v22 (ref), build (copy)
        if v21 or v22 or #t8 == 0 then
            return
        end

        v18 = table.remove(t8)
        build()
    end)
    Kit.button(p6, "RESTART", Color3.fromRGB(255, 150, 40), {
        Position = v67 + UDim2.new(1, -374, 0, 0),
        Size = UDim2.fromOffset(170, 64)
    }, function() -- line: 367
        -- upvalues: v21 (ref), v22 (ref), newLevel (ref)
        if not v21 and not v22 then
            newLevel(false)
        end
    end)
    Kit.button(p6, "NEW PUZZLE", Color3.fromRGB(160, 90, 255), {
        Position = v67 + UDim2.new(1, -190, 0, 0),
        Size = UDim2.fromOffset(170, 64)
    }, function() -- line: 375
        -- upvalues: v21 (ref), v22 (ref), newLevel (ref)
        if not v21 and not v22 then
            newLevel(true)
        end
    end)
    p7(0)
    newLevel(true)

    return function() -- line: 383
    end, function() -- line: 383
    end
end

return t1
