-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local t1 = {}
local v1 = Color3.fromRGB(255, 40, 90)
local v2 = Color3.fromRGB(40, 240, 255)
local t2 = {
    "#",
    "%",
    "&",
    "$",
    "@",
    "!",
    "?",
    "0",
    "1",
    "X",
    "/",
    "\\",
    "=",
    "+"
}
local v3 = Random.new()

local function scramble(p1, p2) -- line: 19
    -- upvalues: t2 (copy), v3 (copy)
    local v4 = string.split(p1, "")

    for _ = 1, p2 do
        local v5 = v3:NextInteger(1, #v4)

        if v4[v5] ~= " " then
            v4[v5] = t2[v3:NextInteger(1, #t2)]
        end
    end

    return table.concat(v4)
end

function t1.new(p3, p4) -- line: 30
    -- upvalues: RunService (copy), Kit (copy), v1 (copy), v2 (copy), v3 (copy), scramble (copy)
    local v6 = p4.ZIndex or 1
    local v7 = Kit.frame(p3, {
        Name = "Glitch",
        BackgroundTransparency = 1,
        Position = p4.Position,
        Size = p4.Size,
        ZIndex = v6
    })

    local function label(p5, p6, p7, p8) -- line: 39
        -- upvalues: Kit (copy)
        return Kit.text(p5, "", {
            TextColor3 = p6,
            Size = UDim2.fromScale(1, 1),
            ZIndex = p7,
            StrokeThickness = p8
        })
    end

    local v8 = Kit.text(v7, "", {
        StrokeThickness = 0,
        TextColor3 = v1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = v6
    })
    local v9 = Kit.text(v7, "", {
        StrokeThickness = 0,
        TextColor3 = v2,
        Size = UDim2.fromScale(1, 1),
        ZIndex = v6
    })

    for _, v10 in { v8, v9 } do
        v10.TextTransparency = 0.15

        local UIStroke = v10:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Enabled = false
        end
    end

    local t3 = {}

    for i = 0, 3 do
        local v11 = Kit.frame(v7, {
            Name = "Slice",
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Position = UDim2.fromScale(0, i / 4),
            Size = UDim2.fromScale(1, 0.25),
            ZIndex = v6 + 1
        })
        local v12 = Color3.new(1, 1, 1)
        local v13 = v6 + 1
        local v14 = p4.StrokeThickness or 2
        local v15 = Kit.text(v11, "", {
            TextColor3 = v12,
            Size = UDim2.fromScale(1, 1),
            ZIndex = v13,
            StrokeThickness = v14
        })

        v15.Size = UDim2.fromScale(1, 4)
        v15.Position = UDim2.fromScale(0, -i)

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 90
        UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(150, 255, 235))
        UIGradient.Parent = v15
        table.insert(t3, {
            strip = v11,
            label = v15
        })
    end

    local v16 = ""

    local function show(p9) -- line: 79
        -- upvalues: v8 (copy), v9 (copy), t3 (copy)
        v8.Text = p9
        v9.Text = p9

        for _, v17 in t3 do
            v17.label.Text = p9
        end
    end

    local n1 = 0
    local v18 = os.clock() + 1
    local n2 = 0

    RunService.RenderStepped:Connect(function() -- line: 87
        -- upvalues: v7 (copy), v8 (copy), v9 (copy), t3 (copy), v16 (ref), n1 (ref), v18 (ref), n2 (ref), v3 (copy), scramble (copy)
        if v7.Parent then
            local LayerCollector = v7:FindFirstAncestorWhichIsA("LayerCollector")

            if not LayerCollector or LayerCollector.Enabled then
                local elapsed = os.clock()

                if v18 <= elapsed then
                    n1 = elapsed + v3:NextNumber(0.12, 0.32)
                    v18 = elapsed + v3:NextNumber(1.2, 3)
                end

                local v19 = elapsed < n1

                if not (elapsed < n2) then
                    n2 = elapsed + (v19 and 0.04 or 0.08)

                    local v20 = if v19 then 0.035 else 0.008

                    v8.Position = UDim2.fromScale(-v20 + v3:NextNumber(-0.004, 0.004), v3:NextNumber(-0.03, 0.03))
                    v9.Position = UDim2.fromScale(v20 + v3:NextNumber(-0.004, 0.004), v3:NextNumber(-0.03, 0.03))

                    for _, v21 in t3 do
                        v21.strip.Position = UDim2.fromScale(if v19 and v3:NextNumber() < 0.6 then v3:NextNumber(-0.07, 0.07) else 0, v21.strip.Position.Y.Scale)
                    end

                    local v22 = if v19 then scramble(v16, v3:NextInteger(1, 3)) else v16

                    v8.Text = v22
                    v9.Text = v22

                    for _, v23 in t3 do
                        v23.label.Text = v22
                    end

                    v7.Rotation = if v19 then v3:NextNumber(-2, 2) else 0
                end
            end
        end
    end)

    return function(p10) -- line: 116
        -- upvalues: v8 (copy), v9 (copy), t3 (copy), v16 (ref)
        v16 = p10
        v8.Text = p10
        v9.Text = p10

        for _, v25 in t3 do
            v25.label.Text = p10
        end
    end
end

return t1
