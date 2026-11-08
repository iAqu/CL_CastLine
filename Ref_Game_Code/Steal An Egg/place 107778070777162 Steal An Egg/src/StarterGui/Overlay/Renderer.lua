-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Codec = require(script.Parent.Codec)
local t1 = {
    OWNER = "QAOverlayV1"
}

local function createFrame(p1) -- line: 22
    local Frame = Instance.new("Frame")

    Frame.Name = p1
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Active = false
    Frame.Interactable = false
    Frame.Selectable = false

    return Frame
end

local function createDot(p2, p3) -- line: 33
    local name = p3.name
    local Frame = Instance.new("Frame")

    Frame.Name = name
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Active = false
    Frame.Interactable = false
    Frame.Selectable = false
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(p3.position.X, p3.position.Y)
    Frame.Size = UDim2.fromOffset(p3.diameter, p3.diameter)

    if p3.isWhite then
        Frame.BackgroundColor3 = Color3.new(1, 1, 1)
    else
        Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    end

    Frame.BackgroundTransparency = 1 - p3.opacity

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = Frame
    Frame.Parent = p2
end

function t1.clear(p4) -- line: 48
    -- upvalues: t1 (copy)
    for _, child in p4:GetChildren() do
        if child:GetAttribute("OverlayOwner") == t1.OWNER then
            child:Destroy()
        end
    end
end

function t1.mount(p5, p6) -- line: 56
    -- upvalues: Codec (copy), t1 (copy), createDot (copy)
    assert(Codec.getIsPayload(p6.payload), "Invalid overlay payload")
    assert(p6.viewport.X > 0 and p6.viewport.Y > 0, "Overlay has no viewport")

    local DotOpacity = p5:GetAttribute("DotOpacity")

    if type(DotOpacity) ~= "number" or DotOpacity ~= DotOpacity then
        DotOpacity = 0.06
    end

    local v3 = math.clamp(DotOpacity, 0.01, 0.18)
    local TilePixels = p5:GetAttribute("TilePixels")

    if type(TilePixels) ~= "number" or TilePixels ~= TilePixels then
        TilePixels = 325
    end

    local v9 = math.min(math.ceil(math.max(math.clamp(TilePixels, 260, 650), p6.viewport.X / 4, p6.viewport.Y / 3) / 13) * 13, p6.viewport.X, p6.viewport.Y)
    local v10 = v9 * 4 / 325
    local v11 = Codec.encode(p6.payload)
    local Frame = Instance.new("Frame")

    Frame.Name = "FingerprintLayer"
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Active = false
    Frame.Interactable = false
    Frame.Selectable = false
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ClipsDescendants = true
    Frame:SetAttribute("OverlayOwner", t1.OWNER)
    Frame:SetAttribute("ProtocolVersion", Codec.VERSION)
    Frame:SetAttribute("TilePixels", v9)
    Frame:SetAttribute("PreviewOnly", p6.isPreview)

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Tile_0_0"
    Frame2.BackgroundTransparency = 1
    Frame2.BorderSizePixel = 0
    Frame2.Active = false
    Frame2.Interactable = false
    Frame2.Selectable = false
    Frame2.Size = UDim2.fromOffset(v9, v9)

    for i = 0, 168 do
        local v12 = Codec.getPair(i)
        local v13 = v11[i + 1] == 1

        createDot(Frame2, {
            name = "A" .. i,
            position = Vector2.new(v12.ax, v12.ay),
            diameter = v10,
            opacity = v3,
            isWhite = v13
        })
        createDot(Frame2, {
            name = "B" .. i,
            position = Vector2.new(v12.bx, v12.by),
            diameter = v10,
            opacity = v3,
            isWhite = not v13
        })
    end

    local v15 = math.ceil(p6.viewport.X / v9)
    local v17 = math.ceil(p6.viewport.Y / v9)

    for i = 0, v17 - 1 do
        for j = 0, v15 - 1 do
            local v18 = if i ~= 0 or j ~= 0 then Frame2:Clone() else Frame2

            v18.Name = string.format("Tile_%d_%d", j, i)
            v18.Position = UDim2.fromOffset(j * v9, i * v9)
            v18.Parent = Frame
        end
    end

    Frame:SetAttribute("TileCount", v15 * v17)
    t1.clear(p5)
    Frame.Parent = p5

    return Frame
end

return table.freeze(t1)
