-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    IMAGE = "rbxassetid://86559378178280",
    TRACK = 2,
    RUNES = {
        "ᚠ",
        "ᚢ",
        "ᚦ",
        "ᚨ",
        "ᚱ",
        "ᛉ",
        "ᛏ",
        "ᛒ",
        "ᛗ",
        "ᛟ",
        "ᚲ",
        "ᚷ",
        "ᚹ",
        "ᚺ",
        "ᚾ",
        "ᛁ",
        "ᛃ",
        "ᛇ",
        "ᛈ",
        "ᛊ",
        "ᛖ",
        "ᛚ",
        "ᛜ",
        "ᛞ"
    }
}
local Metrics = require(script:WaitForChild("Metrics"))
local LINE = Metrics.LINE

local function layout(p1) -- line: 28
    -- upvalues: t1 (copy), Metrics (copy)
    local t2 = {}
    local n1 = 0
    local n2 = 0

    for _, v1 in utf8.codes(p1) do
        local v2 = utf8.char(v1)

        if v1 < 128 then
            v2 = string.upper(v2)
        end

        local v3 = Metrics.GLYPHS[v2]

        if v3 then
            t2[#t2 + 1] = {
                g = v3,
                x = n1 + v3[4]
            }
            n2 = math.max(n2, n1 + v3[4] + v3[3])
            n1 += v3[5] + t1.TRACK
        else
            n1 += Metrics.SPACE + t1.TRACK
        end
    end

    return t2, (math.max(n2, n1, 1))
end

function t1.CanDraw(p2) -- line: 45
    -- upvalues: Metrics (copy)
    if type(p2) ~= "string" or p2 == "" or not utf8.len(p2) then
        return false
    end

    for _, v5 in utf8.codes(p2) do
        local v6 = utf8.char(v5)

        if v5 < 128 then
            v6 = string.upper(v6)
        end

        if v6 ~= " " and not Metrics.GLYPHS[v6] then
            return false
        end
    end

    return true
end

function t1.Set(p3, p4, p5) -- line: 55
    -- upvalues: t1 (copy), LINE (copy), layout (copy)
    local v7, v8 = layout(p4 or "")

    p3:SetAttribute("Text", p4)
    p3:FindFirstChild("Aspect").AspectRatio = v8 / LINE
    p5 = p5 or p3:GetAttribute("Color") or Color3.new(1, 1, 1)
    p3:SetAttribute("Color", p5)

    local t3 = {}

    for _, child in ipairs(p3:GetChildren()) do
        if child:IsA("ImageLabel") then
            t3[tonumber(child.Name:sub(2)) or 0] = child
        end
    end

    for v10, v11 in ipairs(v7) do
        local v12 = t3[v10]

        if not v12 then
            v12 = Instance.new("ImageLabel")
            v12.Name = "G" .. v10
            v12.BackgroundTransparency = 1
            v12.Image = t1.IMAGE
            v12.ScaleType = Enum.ScaleType.Stretch
            v12.ZIndex = p3.ZIndex
            v12.Parent = p3
        end

        local g = v11.g

        v12.ImageRectOffset = Vector2.new(g[1], g[2])
        v12.ImageRectSize = Vector2.new(g[3], LINE)
        v12.Position = UDim2.fromScale(v11.x / v8, 0)
        v12.Size = UDim2.fromScale(g[3] / v8, 1)
        v12.ImageColor3 = p5
        t3[v10] = nil
    end

    for v13, v14 in pairs(t3) do
        if #v7 < v13 then
            v14:Destroy()
        end
    end

    return p3
end

function t1.Make(p6, p7, p8) -- line: 91
    -- upvalues: t1 (copy)
    p8 = p8 or {}

    local Frame = Instance.new("Frame")

    Frame.Name = p8.name or "Norse"
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = p8.zindex or 1
    Frame.AnchorPoint = p8.anchor or Vector2.new(0.5, 0.5)
    Frame.Position = p8.position or UDim2.fromScale(0.5, 0.5)
    Frame.Size = p8.size or UDim2.fromScale(1, 1)

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.Name = "Aspect"
    UIAspectRatioConstraint.Parent = Frame
    t1.Set(Frame, p7, p8.color)
    Frame.Parent = p6

    return Frame
end

function t1.Rune(p9) -- line: 109
    -- upvalues: t1 (copy), Metrics (copy), LINE (copy)
    local v16 = Metrics.GLYPHS[t1.RUNES[(p9 - 1) % #t1.RUNES + 1]]

    return Vector2.new(v16[1], v16[2]), Vector2.new(v16[3], LINE), v16[3] / LINE
end

return t1
