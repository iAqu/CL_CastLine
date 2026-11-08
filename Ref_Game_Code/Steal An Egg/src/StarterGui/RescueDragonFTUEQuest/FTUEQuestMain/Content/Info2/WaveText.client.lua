-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local t1 = {
    WaveAmplitude = 0.16,
    WaveSpeed = 5,
    WavePhase = 0.85,
    WaveRotation = 8,
    WaveScale = 0.1,
    WaveEveryCharacter = false,
    MinFontSize = 6,
    MaxFontSize = 100,
    RebuildDebounce = 0.1,
    RescaleThreshold = 0.04,
    MinStrokeThickness = 0.5
}
local Parent = script.Parent

assert(Parent:IsA("TextLabel") or Parent:IsA("TextButton"), "WaveText must be parented to a text label")

local UIStroke = Parent:FindFirstChildOfClass("UIStroke")
local Text = Parent.Text
local t2 = {
    ["&amp;"] = "&",
    ["&lt;"] = "<",
    ["&gt;"] = ">",
    ["&quot;"] = "\"",
    ["&apos;"] = "'"
}

local function parseRichText(p1, p2) -- line: 60
    -- upvalues: t2 (copy)
    local t3 = {}

    if p2 then
        local t4 = {}
        local n1 = 1

        while n1 <= #p1 do
            local v2 = p1:sub(n1, n1)

            if v2 == "<" then
                local v3 = p1:find(">", n1, true)
                local v4 = false
                local v5 = false
                local v6 = false
                local v7 = false
                local v8 = false
                local v9 = false

                if v3 then
                    v4 = true
                else
                    v9 = true
                end

                local v10

                if v4 then
                    v10 = p1:sub(n1 + 1, v3 - 1)

                    if v10:sub(1, 1) == "/" then
                        v6 = true
                    else
                        v5 = true
                    end
                end

                v4 = false

                if v5 then
                    if v10:sub(-1) == "/" then
                        v9 = false
                    else
                        v4 = true
                    end
                end

                v5 = false

                if v4 then
                    if v10:lower():match("^font") ~= nil then
                        v5 = true
                    else
                        v7 = true
                    end
                end

                v4 = false

                local v11

                if v5 then
                    v11 = true
                    v4 = true
                end

                v5 = false

                if v7 then
                    v11 = false
                    v4 = true
                end

                v7 = false

                if v4 then
                    if v11 then
                        v7 = true
                    else
                        v5 = true
                    end
                end

                v4 = false

                local v12

                if v7 then
                    local v13 = v10:match("color%s*=%s*\"([^\"]+)\"")

                    if v13 then
                        v12 = v13
                        v8 = true
                    else
                        v4 = true
                    end
                end

                v7 = false

                if v4 then
                    v12 = v10:match("color%s*=%s*'([^']+)'")
                    v8 = true
                end

                v4 = false

                if v8 then
                    if v12 then
                        v4 = true
                    else
                        v5 = true
                    end
                end

                v8 = false

                local result2

                if v4 then
                    local fromHex = Color3.fromHex
                    local ok

                    ok, result2 = pcall(fromHex, v12)

                    if ok then
                        v8 = true
                    else
                        v7 = true
                    end
                end

                v4 = false

                local result3

                if v8 then
                    if result2 then
                        result3 = result2
                        v4 = true
                    else
                        v7 = true
                    end
                end

                if v7 then
                    result3 = nil
                    v4 = true
                end

                local result

                if v4 then
                    result = result3
                    v5 = true
                end

                v4 = false

                if v5 then
                    v9 = false
                    t4[#t4 + 1] = {
                        isFont = v11,
                        color = result,
                        indices = {}
                    }
                end

                local v14

                if v6 then
                    v14 = table.remove(t4)

                    if v14 then
                        v4 = true
                    else
                        v9 = false
                    end
                end

                v6 = false

                if v4 then
                    if v14.isFont then
                        v6 = true
                    else
                        v9 = false
                    end
                end

                v4 = false

                if v6 then
                    if #v14.indices == 1 then
                        v4 = true
                    else
                        v9 = false
                    end
                end

                if v4 then
                    v9 = false
                    t3[v14.indices[1]].wavy = true
                end

                if v9 then
                    break
                end

                n1 = v3 + 1
            else
                local v15
                local v16 = n1

                if v2 == "&" then
                    local v17 = p1:find(";", n1, true)
                    local v18 = v17 and v17 - n1 <= 6 and p1:sub(n1, v17)

                    if v18 and t2[v18] then
                        v15 = t2[v18]
                        v16 = v17 + 1
                    end
                end

                local v19, v20

                if v15 then
                    v20 = v15
                    v19 = v16
                else
                    v19 = utf8.offset(p1, 2, v16) or v16 + 1
                    v20 = p1:sub(v16, v19 - 1)
                end

                local v22 = #t4
                local color

                for i = v22, 1, -1 do
                    if t4[i].color then
                        color = t4[i].color
                        break
                    end
                end

                t3[#t3 + 1] = {
                    char = v20,
                    color = color
                }

                local v23 = #t4

                n1 = v19

                for i = 1, v23 do
                    n1 = v19

                    local indices = t4[i].indices

                    indices[#indices + 1] = #t3
                end
            end
        end
    else
        for _, v24 in utf8.codes(p1) do
            t3[#t3 + 1] = {
                char = utf8.char(v24)
            }
        end
    end

    return t3
end

local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

GetTextBoundsParams.RichText = false

local t5 = {}

local function measure(p3, p4, p5) -- line: 149
    -- upvalues: TextService (copy), Parent (copy), GetTextBoundsParams (copy), t5 (ref)
    if p3 == "" then
        return Vector2.zero
    end

    local v25 = string.format("%d|%d|%s", p4, p5 or 0, p3)
    local v26 = t5[v25]

    if v26 then
        return v26
    end

    GetTextBoundsParams.Font = Parent.FontFace
    GetTextBoundsParams.Text = p3
    GetTextBoundsParams.Size = p4
    GetTextBoundsParams.Width = p5 or 0

    local function v27() -- line: 165
        -- upvalues: TextService (copy), GetTextBoundsParams (copy)
        return TextService:GetTextBoundsAsync(GetTextBoundsParams)
    end

    local ok, result = pcall(v27)

    if not ok then
        return Vector2.zero
    end

    local t6 = t5

    t6[v25] = result

    return result
end

local function fitFontSize(p6, p7) -- line: 177
    -- upvalues: Parent (copy), measure (copy)
    if not Parent.TextScaled then
        return Parent.TextSize
    end

    local n2 = 6
    local n3 = 100
    local n4 = 6

    while n2 <= n3 do
        local v29 = math.floor((n2 + n3) / 2)
        local v30 = measure(p6, v29, (math.floor(p7.X)))

        if not (v30.X <= p7.X and v30.Y <= p7.Y) then
            n3 = v29 - 1
        else
            n4 = v29
            n2 = v29 + 1
        end
    end

    return n4
end

local Frame
local t7 = {}
local t8 = {}
local t9 = {}
local v31 = false
local n5 = 0
local n6 = 0
local n7 = 0
local n8 = 0

local function syncSize(p8) -- line: 217
    -- upvalues: Parent (copy), t7 (copy), t8 (copy), n6 (ref), n7 (ref), n8 (ref)
    if n6 <= 0 or #t7 == 0 then
        return
    end

    local v32 = Parent.AbsoluteSize.X / n6

    if not (v32 <= 0) then
        local v33 = if not p8 then math.abs(v32 - n8) < 0.04 else nil

        if p8 or not v33 then
            n8 = v32

            local v36 = math.max(1, n7 * v32)

            for _, v37 in ipairs(t7) do
                v37.TextSize = v36
            end

            for _, v38 in ipairs(t8) do
                v38.Thickness = v38:GetAttribute("BaseThickness") * v32
            end
        end
    end
end

local function syncTransparency() -- line: 241
    -- upvalues: Parent (copy), UIStroke (copy), t7 (copy), t8 (copy)
    for _, v39 in ipairs(t7) do
        v39.TextTransparency = Parent.TextTransparency
    end

    if UIStroke then
        for _, v40 in ipairs(t8) do
            v40.Transparency = UIStroke.Transparency
        end
    end
end

local function clearBuild() -- line: 252
    -- upvalues: Frame (ref), t7 (copy), t8 (copy), t9 (copy)
    table.clear(t7)
    table.clear(t8)
    table.clear(t9)

    if Frame then
        Frame:Destroy()
        Frame = nil
    end
end

local function build() -- line: 262
    -- upvalues: Parent (copy), UIStroke (copy), Text (ref), parseRichText (copy), measure (copy), fitFontSize (copy), Frame (ref), t7 (copy), t8 (copy), t9 (copy), v31 (ref), n5 (ref), n6 (ref), n7 (ref), syncSize (copy)
    if not v31 then
        v31 = true
        n5 += 1

        local v41 = n5
        local AbsoluteSize = Parent.AbsoluteSize

        if not (AbsoluteSize.X < 1 or AbsoluteSize.Y < 1) then
            local v42 = parseRichText(Text, Parent.RichText)

            if #v42 ~= 0 then
                local v43 = ""

                for _, v44 in ipairs(v42) do
                    v43 ..= v44.char
                end

                local v45 = fitFontSize(v43, AbsoluteSize)
                local t10 = {}
                local t11

                for _, v46 in ipairs(v42) do
                    if v46.char == " " then
                        t11 = nil
                    else
                        if not t11 then
                            t11 = {
                                text = "",
                                entries = {}
                            }
                            t10[#t10 + 1] = t11
                        end

                        t11.entries[#t11.entries + 1] = v46
                        t11.text ..= v46.char
                    end
                end

                for _, v47 in ipairs(t10) do
                    v47.width = measure(v47.text, v45).X
                end

                local v48 = measure("i i", v45).X - measure("ii", v45).X

                if v48 <= 0 then
                    v48 = v45 * 0.28
                end

                local t12 = {}
                local t13

                for _, v49 in ipairs(t10) do
                    if t13 then
                        local v50 = t13.width + v48 + v49.width

                        if v50 <= AbsoluteSize.X then
                            t13.words[#t13.words + 1] = v49
                            t13.width = v50
                        else
                            t13 = {
                                words = { v49 },
                                width = v49.width
                            }
                            t12[#t12 + 1] = t13
                        end
                    else
                        t13 = {
                            words = { v49 },
                            width = v49.width
                        }
                        t12[#t12 + 1] = t13
                    end
                end

                if v41 == n5 then
                    table.clear(t7)
                    table.clear(t8)
                    table.clear(t9)

                    if Frame then
                        Frame:Destroy()
                        Frame = nil
                    end

                    Frame = Instance.new("Frame")
                    Frame.Name = "WaveCharacters"
                    Frame.BackgroundTransparency = 1

                    local Frame2 = Frame

                    Frame2.Size = UDim2.fromScale(1, 1)

                    local Frame3 = Frame

                    Frame3.ZIndex = Parent.ZIndex
                    Frame.Parent = Parent

                    local v51 = v45 * Parent.LineHeight
                    local v52 = v51 * #t12
                    local v53 = if Parent.TextYAlignment == Enum.TextYAlignment.Top then 0 elseif Parent.TextYAlignment == Enum.TextYAlignment.Bottom then AbsoluteSize.Y - v52 else (AbsoluteSize.Y - v52) * 0.5
                    local v54 = v45 * 0.6
                    local n9 = 0

                    for v55, v56 in ipairs(t12) do
                        local v57 = v53 + (v55 - 0.5) * v51
                        local v58 = if Parent.TextXAlignment == Enum.TextXAlignment.Left then 0 elseif Parent.TextXAlignment == Enum.TextXAlignment.Right then AbsoluteSize.X - v56.width else (AbsoluteSize.X - v56.width) * 0.5
                        local v59 = n9

                        for v60, v61 in ipairs(v56.words) do
                            local n10 = 0
                            local v62 = ""

                            for _, v63 in ipairs(v61.entries) do
                                v62 ..= v63.char

                                local X = measure(v62, v45).X
                                local v64 = X - n10
                                local v65 = v58 + n10 + v64 * 0.5

                                n10 = X

                                local TextLabel = Instance.new("TextLabel")

                                TextLabel.Name = "Char"
                                TextLabel.BackgroundTransparency = 1
                                TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                                TextLabel.Position = UDim2.fromScale(v65 / AbsoluteSize.X, v57 / AbsoluteSize.Y)
                                TextLabel.Size = UDim2.fromScale((v64 + v54 * 2) / AbsoluteSize.X, v51 * 2 / AbsoluteSize.Y)
                                TextLabel.ZIndex = Parent.ZIndex
                                TextLabel.FontFace = Parent.FontFace
                                TextLabel.Text = v63.char
                                TextLabel.RichText = false
                                TextLabel.TextScaled = false
                                TextLabel.TextWrapped = false
                                TextLabel.TextSize = v45
                                TextLabel.TextColor3 = v63.color or Parent.TextColor3
                                TextLabel.TextTransparency = Parent.TextTransparency
                                TextLabel.TextStrokeTransparency = Parent.TextStrokeTransparency
                                TextLabel.TextStrokeColor3 = Parent.TextStrokeColor3
                                TextLabel.TextXAlignment = Enum.TextXAlignment.Center
                                TextLabel.TextYAlignment = Enum.TextYAlignment.Center
                                TextLabel.Parent = Frame

                                if UIStroke and UIStroke.Thickness >= 0.5 then
                                    local clone = UIStroke:Clone()

                                    clone:SetAttribute("BaseThickness", UIStroke.Thickness)
                                    clone.Parent = TextLabel
                                    t8[#t8 + 1] = clone
                                end

                                t7[#t7 + 1] = TextLabel

                                if v63.wavy then
                                    v59 += 1

                                    local UIScale = Instance.new("UIScale")

                                    UIScale.Parent = TextLabel
                                    t9[#t9 + 1] = {
                                        label = TextLabel,
                                        scale = UIScale,
                                        order = v59,
                                        x = v65 / AbsoluteSize.X,
                                        y = v57 / AbsoluteSize.Y
                                    }
                                end
                            end

                            n9 = v59

                            if v60 < #v56.words then
                                v58 += v61.width + v48
                            end
                        end
                    end

                    n6 = AbsoluteSize.X
                    n7 = v45
                    syncSize(true)
                    Parent.MaxVisibleGraphemes = 0
                end
            end
        end

        v31 = false
    end
end

local n11 = 0

local function step(p9) -- line: 458
    -- upvalues: t9 (copy), n11 (ref)
    if #t9 == 0 then
        return
    end

    n11 += p9

    local v66 = 0.16 * t9[1].label.TextSize

    for _, v67 in ipairs(t9) do
        local v68 = n11 * 5 - v67.order * 0.85
        local v69 = math.sin(v68)

        v67.label.Position = UDim2.new(v67.x, 0, v67.y, -v69 * v66)
        v67.label.Rotation = math.cos(v68) * 8
        v67.scale.Scale = 1 + math.max(v69, 0) * 0.1
    end
end

local function park() -- line: 475
    -- upvalues: t9 (copy)
    for _, v70 in ipairs(t9) do
        v70.label.Position = UDim2.fromScale(v70.x, v70.y)
        v70.label.Rotation = 0
        v70.scale.Scale = 1
    end
end

local v71 = false
local v72
local t14 = {}

local function computeShown() -- line: 492
    -- upvalues: Parent (copy)
    local Parent2 = Parent

    while true do
        if not Parent2 then
            return false
        end

        if Parent2:IsA("GuiObject") then
            if Parent2.Visible then
                Parent2 = Parent2.Parent
                continue
            end

            break
        end

        if Parent2:IsA("LayerCollector") then
            return Parent2.Enabled
        end

        Parent2 = Parent2.Parent
    end

    return false
end

local function refreshShown() -- line: 507
    -- upvalues: RunService (copy), step (copy), park (copy), v71 (ref), v72 (ref), computeShown (copy)
    local v73 = computeShown()

    if v73 ~= v71 then
        v71 = v73

        if v71 then
            v72 = v72 or RunService.RenderStepped:Connect(step)
        elseif v72 then
            v72:Disconnect()
            v72 = nil
            park()
        end
    end
end

local function watchAncestors() -- line: 525
    -- upvalues: RunService (copy), Parent (copy), step (copy), park (copy), v71 (ref), v72 (ref), t14 (copy), computeShown (copy), refreshShown (copy)
    for _, v74 in ipairs(t14) do
        v74:Disconnect()
    end

    table.clear(t14)

    local Parent2 = Parent

    while Parent2 do
        if Parent2:IsA("GuiObject") then
            t14[#t14 + 1] = Parent2:GetPropertyChangedSignal("Visible"):Connect(refreshShown)
        elseif Parent2:IsA("LayerCollector") then
            t14[#t14 + 1] = Parent2:GetPropertyChangedSignal("Enabled"):Connect(refreshShown)
            break
        end

        Parent2 = Parent2.Parent
    end

    local v75 = computeShown()

    if v75 ~= v71 then
        v71 = v75

        if v71 then
            v72 = v72 or RunService.RenderStepped:Connect(step)
        elseif v72 then
            v72:Disconnect()
            v72 = nil
            park()
        end
    end
end

local v76 = false

local function queueRebuild() -- line: 553
    -- upvalues: build (copy), v76 (ref)
    if not v76 then
        v76 = true
        task.delay(0.1, function() -- line: 558
            -- upvalues: build (copy), v76 (ref)
            v76 = false
            build()
        end)
    end
end

local v77 = false

Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 568
    -- upvalues: t1 (copy), t7 (copy), syncSize (copy), build (copy), v76 (ref), v77 (ref)
    if #t7 == 0 then
        if not v76 then
            v76 = true
            task.delay(t1.RebuildDebounce, function() -- line: 558
                -- upvalues: build (copy), v76 (ref)
                v76 = false
                build()
            end)
        end
    else
        syncSize()

        if not v77 then
            v77 = true
            task.delay(0.1, function() -- line: 580
                -- upvalues: syncSize (copy), v77 (ref)
                v77 = false
                syncSize(true)
            end)
        end
    end
end)
Parent:GetPropertyChangedSignal("FontFace"):Connect(queueRebuild)
Parent:GetPropertyChangedSignal("TextTransparency"):Connect(syncTransparency)

if UIStroke then
    UIStroke:GetPropertyChangedSignal("Transparency"):Connect(syncTransparency)
end

Parent:GetPropertyChangedSignal("Text"):Connect(function() -- line: 595
    -- upvalues: t1 (copy), Parent (copy), Text (ref), t5 (ref), build (copy), v76 (ref)
    if Parent.Text == "" then
        return
    end

    Text = Parent.Text
    t5 = {}

    if v76 then
        return
    end

    v76 = true
    task.delay(t1.RebuildDebounce, function() -- line: 558
        -- upvalues: build (copy), v76 (ref)
        v76 = false
        build()
    end)
end)
Parent.AncestryChanged:Connect(watchAncestors)
watchAncestors()
task.spawn(build)
