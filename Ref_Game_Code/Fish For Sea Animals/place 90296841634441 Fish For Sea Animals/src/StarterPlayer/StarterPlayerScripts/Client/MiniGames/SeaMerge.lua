-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Kit = require(script.Parent.Kit)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local t1 = {
    Id = "SeaMerge",
    Name = "Sea Merge",
    Icon = "🐳",
    Color = Color3.fromRGB(60, 200, 130)
}
local t2 = {
    {
        r = 16,
        icon = "🦐",
        color = Color3.fromRGB(255, 150, 170)
    },
    {
        r = 21,
        icon = "🐟",
        color = Color3.fromRGB(90, 170, 255)
    },
    {
        r = 27,
        icon = "🐠",
        color = Color3.fromRGB(255, 215, 60)
    },
    {
        r = 33,
        icon = "🐡",
        color = Color3.fromRGB(255, 150, 60)
    },
    {
        r = 40,
        icon = "🦀",
        color = Color3.fromRGB(240, 75, 65)
    },
    {
        r = 48,
        icon = "🐙",
        color = Color3.fromRGB(170, 95, 240)
    },
    {
        r = 57,
        icon = "🐢",
        color = Color3.fromRGB(95, 200, 95)
    },
    {
        r = 67,
        icon = "🐬",
        color = Color3.fromRGB(110, 210, 255)
    },
    {
        r = 78,
        icon = "🦈",
        color = Color3.fromRGB(125, 145, 175)
    },
    {
        r = 92,
        icon = "🐳",
        color = Color3.fromRGB(50, 95, 225)
    }
}
local t3 = {
    36, 30, 20, 10, 4
}

local function points(p1) -- line: 42
    return p1 * (p1 + 1) // 2
end

local function randomTier() -- line: 46
    -- upvalues: t3 (copy)
    local n1 = 0

    for _, v1 in t3 do
        n1 += v1
    end

    local v2 = math.random() * n1

    for v3, v4 in t3 do
        v2 -= v4

        if v2 <= 0 then
            return v3
        end
    end

    return 1
end

local function creature(p2, p3, p4) -- line: 62
    -- upvalues: Kit (copy), t2 (copy)
    local v5 = t2[p3]
    local v6 = Kit.frame(p2, {
        BackgroundColor3 = v5.color,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(p4 * 2, p4 * 2)
    })
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = v6
    Kit.stroke(v6, 3)
    Kit.shade(v6, 0.7)
    Kit.text(v6, v5.icon, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.52),
        Size = UDim2.fromScale(0.68, 0.68)
    }).UIStroke.Enabled = false

    return v6
end

function t1.start(p5, p6) -- line: 83
    -- upvalues: RunService (copy), UserInputService (copy), Kit (copy), UIUtil (copy), t2 (copy), t3 (copy), creature (copy)
    local t4 = {}
    local n2 = 0
    local n3 = 0

    for _, v7 in t3 do
        n3 += v7
    end

    local v8 = math.random() * n3
    local v9 = false
    local v10

    for v11, v12 in t3 do
        v8 -= v12

        if v8 <= 0 then
            v10 = v11
            v9 = true
            break
        end
    end

    if not v9 then
        v10 = 1
    end

    local n4 = 0

    for _, v13 in t3 do
        n4 += v13
    end

    local v14 = math.random() * n4
    local v15 = false
    local v16

    for v17, v18 in t3 do
        v14 -= v18

        if v14 <= 0 then
            v16 = v17
            v15 = true
            break
        end
    end

    if not v15 then
        v16 = 1
    end

    local n5 = 200
    local n6 = 0
    local v19 = false
    local v20 = false
    local t5 = {}
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Tank"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = Color3.new(1, 1, 1)
    TextButton.ClipsDescendants = true
    TextButton.Position = UDim2.fromOffset(24, 14)
    TextButton.Size = UDim2.fromOffset(400, 540)
    Kit.corner(TextButton, 10)
    Kit.stroke(TextButton, 5)

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new(Color3.fromRGB(110, 200, 255), Color3.fromRGB(35, 85, 185))
    UIGradient.Parent = TextButton
    Kit.studs(TextButton, 0.75, 50, 10)
    TextButton.Parent = p5

    local v21 = Kit.frame(TextButton, {
        Name = "Line",
        BackgroundTransparency = 0.5,
        ZIndex = 5,
        BackgroundColor3 = Color3.fromRGB(255, 70, 70),
        Position = UDim2.fromOffset(0, 94),
        Size = UDim2.new(1, 0, 0, 4)
    })
    local v22 = Kit.frame(TextButton, {
        Name = "Guide",
        BackgroundTransparency = 0.75,
        ZIndex = 1,
        BackgroundColor3 = Color3.new(1, 1, 1),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(0, 3, 1, 0)
    })
    local v23
    local v24 = Kit.frame(p5, {
        Name = "Side",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(450, 14),
        Size = UDim2.new(1, -470, 0, 540)
    })
    local v25 = Kit.frame(v24, {
        BackgroundColor3 = Color3.fromRGB(44, 46, 60),
        Size = UDim2.new(1, 0, 0, 170)
    })

    Kit.corner(v25, 12)
    Kit.stroke(v25, 4)
    Kit.studs(v25, 0.45, 44, 12)
    Kit.text(v25, "NEXT", {
        Position = UDim2.fromOffset(16, 10),
        Size = UDim2.new(1, -32, 0, 34)
    })

    local v26
    local v27 = Kit.frame(v24, {
        BackgroundColor3 = Color3.fromRGB(44, 46, 60),
        Position = UDim2.fromOffset(0, 184),
        Size = UDim2.new(1, 0, 0, 236)
    })

    Kit.corner(v27, 12)
    Kit.stroke(v27, 4)
    Kit.studs(v27, 0.45, 44, 12)
    Kit.text(v27, "MERGE CHAIN", {
        Position = UDim2.fromOffset(16, 10),
        Size = UDim2.new(1, -32, 0, 32)
    })

    for v28 in t2 do
        local v29 = (v28 - 1) % 5
        local v30 = (v28 - 1) // 5

        creature(v27, v28, 24).Position = UDim2.new(0.1 + v29 * 0.2, 0, 0, 90 + v30 * 74)
        Kit.text(v27, `+{ v28 * (v28 + 1) // 2 }`, {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.1 + v29 * 0.2, 0, 0, 116 + v30 * 74),
            Size = UDim2.fromOffset(56, 20),
            TextColor3 = Color3.fromRGB(255, 225, 90)
        })
    end

    local function refreshDropper() -- line: 166
        -- upvalues: v10 (ref), v16 (ref), n5 (ref), TextButton (copy), v22 (copy), v23 (ref), v25 (copy), v26 (ref), UIUtil (copy), t2 (copy), creature (copy)
        if v23 then
            v23:Destroy()
        end

        v23 = creature(TextButton, v10, t2[v10].r)
        v23.ZIndex = 4

        local r = t2[v10].r
        local v31 = n5

        n5 = math.clamp(v31, r, 400 - r)

        local v33 = v23

        v33.Position = UDim2.fromOffset(n5, 48)
        v22.Position = UDim2.fromOffset(n5, 0)

        if v26 then
            v26:Destroy()
        end

        local v34 = v16

        v26 = creature(v25, v34, (math.min(t2[v16].r, 46)))

        local v35 = v26

        v35.Position = UDim2.new(0.5, 0, 0, 104)
        UIUtil.pop(v26, 0.5)
    end

    local function addBall(p7, p8, p9, p10, p11) -- line: 184
        -- upvalues: t4 (copy), TextButton (copy), t2 (copy), creature (copy)
        local t6 = {
            age = 0,
            overTime = 0,
            tier = p7,
            r = t2[p7].r,
            x = p8,
            y = p9,
            vx = p10,
            vy = p11
        }

        t6.frame = creature(TextButton, p7, t6.r)
        t6.frame.ZIndex = 2
        t6.frame.Position = UDim2.fromOffset(p8, p9)
        table.insert(t4, t6)

        return t6
    end

    local function drop() -- line: 193
        -- upvalues: v10 (ref), v16 (ref), n5 (ref), n6 (ref), v19 (ref), v20 (ref), TextButton (copy), v23 (ref), refreshDropper (copy), addBall (copy), UIUtil (copy), t3 (copy)
        if v19 or v20 or os.clock() - n6 < 0.45 then
            return
        end

        n6 = os.clock()
        addBall(v10, n5, 48, 0, 0)
        UIUtil.sound("Whoosh", 0.3, 1.4, 2)

        local v36 = v16
        local n7 = 0

        for _, v37 in t3 do
            n7 += v37
        end

        local v38 = math.random() * n7
        local v39 = false
        local v40

        for v41, v42 in t3 do
            v38 -= v42

            if v38 <= 0 then
                v40 = v41
                v39 = true
                break
            end
        end

        if not v39 then
            v40 = 1
        end

        v10 = v36
        v16 = v40

        if v23 then
            v23:Destroy()
            v23 = nil
        end

        task.delay(0.36000000000000004, function() -- line: 205
            -- upvalues: v19 (ref), TextButton (copy), refreshDropper (copy)
            if TextButton.Parent and not v19 then
                refreshDropper()
            end
        end)
    end

    local function aim(p12) -- line: 212
        -- upvalues: v10 (ref), n5 (ref), TextButton (copy), v22 (copy), v23 (ref), t2 (copy)
        local v43 = 400 / TextButton.AbsoluteSize.X
        local r = t2[v10].r

        n5 = math.clamp((p12.X - TextButton.AbsolutePosition.X) * v43, r, 400 - r)
        v22.Position = UDim2.fromOffset(n5, 0)

        if v23 then
            local v46 = v23

            v46.Position = UDim2.fromOffset(n5, 48)
        end
    end

    local function step(p13) -- line: 222
        -- upvalues: t4 (copy)
        for _, v47 in t4 do
            v47.vy += p13 * 1500
            v47.vx *= 0.999
            v47.x += v47.vx * p13
            v47.y += v47.vy * p13
        end
    end

    local function collide(p14) -- line: 232
        -- upvalues: t4 (copy)
        local v48 = #t4

        for i = 1, v48 do
            local v49 = t4[i]

            if v49.x - v49.r < 0 then
                v49.x = v49.r
                v49.vx = math.abs(v49.vx) * 0.15
            elseif v49.x + v49.r > 400 then
                v49.x = 400 - v49.r
                v49.vx = -math.abs(v49.vx) * 0.15
            end

            if v49.y + v49.r > 540 then
                v49.y = 540 - v49.r
                v49.vy = -math.abs(v49.vy) * 0.15
                v49.vx *= 0.98
            end

            for j = i + 1, v48 do
                local v50 = t4[j]
                local v51 = v50.x - v49.x
                local v52 = v50.y - v49.y
                local v53 = v49.r + v50.r
                local v54 = v51 * v51 + v52 * v52

                if v54 < v53 * v53 and not v49.merging and not v50.merging then
                    if v49.tier == v50.tier then
                        v49.merging = true
                        v50.merging = true
                        table.insert(p14, {
                            v49,
                            v50
                        })
                    else
                        local v56 = math.max(math.sqrt(v54), 0.001)
                        local v57 = v51 / v56
                        local v58 = v52 / v56
                        local v59 = v49.r * v49.r
                        local v60 = v50.r * v50.r
                        local v61 = (v53 - v56) / (v59 + v60)

                        v49.x -= v57 * v61 * v60
                        v49.y -= v58 * v61 * v60
                        v50.x += v57 * v61 * v59
                        v50.y += v58 * v61 * v59

                        local v62 = (v50.vx - v49.vx) * v57 + (v50.vy - v49.vy) * v58

                        if v62 < 0 then
                            local v63 = -1.15 * v62 / (1 / v59 + 1 / v60)

                            v49.vx -= v63 / v59 * v57
                            v49.vy -= v63 / v59 * v58
                            v50.vx += v63 / v60 * v57
                            v50.vy += v63 / v60 * v58
                        end
                    end
                end
            end
        end
    end

    local function merge(p15, p16) -- line: 280
        -- upvalues: p6 (copy), t4 (copy), n2 (ref), TextButton (copy), addBall (copy), Kit (copy), UIUtil (copy), t2 (copy)
        p15.frame:Destroy()
        p16.frame:Destroy()
        table.remove(t4, table.find(t4, p15))
        table.remove(t4, table.find(t4, p16))

        local v64 = p15.tier + 1
        local v65 = Vector2.new((p15.x + p16.x) / 2, (p15.y + p16.y) / 2)
        local color = t2[p15.tier].color

        if #t2 < v64 then
            n2 += 100
            UIUtil.sound("Splash", 0.8)
            UIUtil.sound("GoodCast", 0.6)
            Kit.burst(TextButton, v65, color, 36, 220)
            Kit.ring(TextButton, v65, Color3.new(1, 1, 1), 420)
            Kit.flash(TextButton, Color3.fromRGB(170, 230, 255), 0.6)
            Kit.shake(TextButton, 10, 0.35)
            Kit.floatText(TextButton, v65, `WHALE SPLASH! +{100}`, Color3.fromRGB(255, 230, 90), 44)
        else
            local v66 = n2

            n2 = v66 + v64 * (v64 + 1) // 2

            local v69 = addBall(v64, v65.X, v65.Y, (p15.vx + p16.vx) / 4, (math.min((p15.vy + p16.vy) / 4, 0)))

            v69.age = math.max(p15.age, p16.age)
            UIUtil.pop(v69.frame, 0.6)
            UIUtil.sound("Pop", 0.7, 1.4 - v64 * 0.07)

            local r = t2[v64].r

            Kit.burst(TextButton, v65, t2[v64].color:Lerp(Color3.new(1, 1, 1), 0.2), 6 + v64 * 2, r * 2.2)
            Kit.ring(TextButton, v65, Color3.new(1, 1, 1), r * 3.2)
            Kit.floatText(TextButton, v65 - Vector2.new(0, r), `+{ v64 * (v64 + 1) // 2 }`, Color3.fromRGB(255, 230, 90), 22 + v64 * 2)

            if v64 >= 6 then
                Kit.shake(TextButton, v64 - 3, 0.2)
                Kit.flash(TextButton, t2[v64].color:Lerp(Color3.new(1, 1, 1), 0.5), 0.3)
            end
        end

        p6(n2)
    end

    local restart, revive

    table.insert(t5, RunService.Heartbeat:Connect(function(p17) -- line: 326
        -- upvalues: p5 (copy), t4 (copy), n2 (ref), v19 (ref), v20 (ref), v21 (copy), step (copy), collide (copy), merge (copy), restart (ref), revive (ref), Kit (copy), UIUtil (copy)
        if not v19 and not v20 then
            local v71 = math.min(p17, 0.03333333333333333)
            local v72 = v71 / 4

            for _ = 1, 4 do
                step(v72)

                local t8 = {}

                collide(t8)
                collide(t8)

                for _, v73 in t8 do
                    merge(v73[1], v73[2])
                end
            end

            local v74 = false

            for _, v75 in t4 do
                v75.age += v71

                if v75.age > 1 and v75.y - v75.r < 96 then
                    v75.overTime += v71

                    if v75.overTime > 2 and not v19 then
                        v19 = true
                        UIUtil.sound("Clank", 0.6)
                        v21.BackgroundTransparency = 0
                        Kit.overlay(p5, "Tank's full!", ("Score: %*"):format(n2), "PLAY AGAIN", restart, revive)
                    end

                    v74 = true
                else
                    v75.overTime = 0
                end

                v75.frame.Position = UDim2.fromOffset(v75.x, v75.y)
            end

            v21.BackgroundTransparency = if v74 then (math.sin(os.clock() * 12) + 1) * 0.4 / 2 + 0.1 else 0.5
        end
    end))
    table.insert(t5, UserInputService.InputChanged:Connect(function(p18) -- line: 358
        -- upvalues: aim (copy)
        if p18.UserInputType == Enum.UserInputType.MouseMovement or p18.UserInputType == Enum.UserInputType.Touch then
            aim(p18.Position)
        end
    end))
    table.insert(t5, TextButton.InputBegan:Connect(function(p19) -- line: 363
        -- upvalues: aim (copy)
        if p19.UserInputType == Enum.UserInputType.Touch or p19.UserInputType == Enum.UserInputType.MouseButton1 then
            aim(p19.Position)
        end
    end))
    table.insert(t5, TextButton.Activated:Connect(drop))

    function restart() -- line: 370
        -- upvalues: p5 (copy), p6 (copy), t4 (copy), n2 (ref), v10 (ref), v16 (ref), v19 (ref), refreshDropper (copy), t3 (copy)
        local Overlay = p5:FindFirstChild("Overlay")

        if Overlay then
            Overlay:Destroy()
        end

        for _, v80 in t4 do
            v80.frame:Destroy()
        end

        table.clear(t4)
        n2 = 0
        v19 = false

        local n8 = 0

        for _, v81 in t3 do
            n8 += v81
        end

        local v82 = math.random() * n8
        local v83 = false
        local v84

        for v85, v86 in t3 do
            v82 -= v86

            if v82 <= 0 then
                v84 = v85
                v83 = true
                break
            end
        end

        if not v83 then
            v84 = 1
        end

        local n9 = 0

        for _, v87 in t3 do
            n9 += v87
        end

        local v88 = math.random() * n9
        local v89 = false
        local v90

        for v91, v92 in t3 do
            v88 -= v92

            if v88 <= 0 then
                v90 = v91
                v89 = true
                break
            end
        end

        if not v89 then
            v90 = 1
        end

        v10 = v84
        v16 = v90
        p6(0)
        refreshDropper()
    end

    function revive() -- line: 386
        -- upvalues: t4 (copy), v19 (ref), TextButton (copy), Kit (copy), t2 (copy)
        for i = #t4, 1, -1 do
            local v93 = t4[i]

            if v93.y < 270 then
                Kit.burst(TextButton, Vector2.new(v93.x, v93.y), t2[v93.tier].color, 6, v93.r * 2)
                v93.frame:Destroy()
                table.remove(t4, i)
            end
        end

        for _, v94 in t4 do
            v94.overTime = 0
        end

        v19 = false
        Kit.flash(TextButton, Color3.fromRGB(255, 120, 150), 0.6)
        Kit.floatText(TextButton, Vector2.new(200, 270), "REVIVED!", Color3.fromRGB(255, 140, 170), 56)
    end

    restart()

    return function() -- line: 404
        -- upvalues: t5 (copy)
        for _, v95 in t5 do
            v95:Disconnect()
        end
    end, function(p20) -- line: 408
        -- upvalues: v20 (ref)
        v20 = p20
    end
end

return t1
