-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local t1 = {}
local t2 = {
    GLOW_LAP = 9,
    POOL = 18,
    EMBER_EVERY = { 0.12, 0.28 },
    EMBER_LIFE = { 1.6, 2.6 },
    EMBER_SIZE = { 0.006, 0.014 },
    EMBER_RISE = { 0.25, 0.5 }
}
local v1 = Random.new()

local function range(p1) -- line: 22
    -- upvalues: v1 (copy)
    return v1:NextNumber(p1[1], p1[2])
end

local self = setmetatable({}, {
    __mode = "k"
})

local function build(p2) -- line: 27
    -- upvalues: t2 (copy), self (copy)
    if self[p2] then
        return self[p2]
    end

    local t5 = {
        embers = {}
    }
    local Tiles = p2:FindFirstChild("Tiles")

    if Tiles then
        local HellHydra = Tiles:FindFirstChild("HellHydra")

        if HellHydra then
            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "Glow"
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Image = "rbxassetid://84880292033466"
            ImageLabel.ImageColor3 = Color3.fromRGB(255, 150, 40)
            ImageLabel.ImageTransparency = 0.45
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
            ImageLabel.Size = UDim2.fromScale(1.15, 1.15)
            ImageLabel.ZIndex = 7
            Instance.new("UIAspectRatioConstraint").Parent = ImageLabel
            ImageLabel.Parent = HellHydra
            t5.glow = ImageLabel
        end
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "Embers"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ZIndex = 6
    Frame.ClipsDescendants = true
    Frame.Parent = p2

    for i = 1, t2.POOL do
        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Ember" .. i
        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = Color3.fromRGB(255, 170, 60)
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame2.Visible = false
        Frame2.ZIndex = 6

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = Frame2
        Instance.new("UIAspectRatioConstraint").Parent = Frame2
        Frame2.Parent = Frame
        t5.embers[i] = {
            busy = false,
            gui = Frame2
        }
    end

    self[p2] = t5

    return t5
end

local function ember(p3, p4) -- line: 78
    -- upvalues: TweenService (copy), t2 (copy), v1 (copy)
    local v3, v4

    for _, v5 in ipairs(p3.embers) do
        if not v5.busy then
            v3 = v5
            v4 = v5
            break
        end
    end

    if not v4 then
        return
    end

    v4.busy = true

    local gui = v4.gui
    local v6 = v1:NextNumber(0.03, 0.97)
    local v7 = v1:NextNumber(0.78, 0.98)
    local EMBER_SIZE = t2.EMBER_SIZE
    local v8 = v1:NextNumber(EMBER_SIZE[1], EMBER_SIZE[2])

    gui.Position = UDim2.fromScale(v6, v7)
    gui.Size = UDim2.fromScale(v8, v8 * p4)
    gui.BackgroundColor3 = Color3.fromRGB(255, v1:NextInteger(120, 210), v1:NextInteger(30, 80))
    gui.BackgroundTransparency = 0.1
    gui.Visible = true

    local EMBER_LIFE = t2.EMBER_LIFE
    local v9 = v1:NextNumber(EMBER_LIFE[1], EMBER_LIFE[2])
    local v10 = v1:NextNumber(-0.04, 0.04)
    local v11 = TweenInfo.new(v9, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local fromScale = UDim2.fromScale
    local v12 = v6 + v10
    local EMBER_RISE = t2.EMBER_RISE

    TweenService:Create(gui, v11, {
        Position = fromScale(v12, v7 - v1:NextNumber(EMBER_RISE[1], EMBER_RISE[2]))
    }):Play()

    local tween = TweenService:Create(gui, TweenInfo.new(v9, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })

    tween.Completed:Once(function() -- line: 95
        -- upvalues: v3 (ref), gui (copy)
        gui.Visible = false
        v3.busy = false
    end)
    tween:Play()
end

function t1.Run(p5, p6, p7) -- line: 100
    -- upvalues: TweenService (copy), t2 (copy), range (copy), build (copy), ember (copy)
    local v13 = build(p5)
    local t7 = {}

    local function forever(p8, p9, p10, p11, p12) -- line: 103
        -- upvalues: t7 (copy), TweenService (copy)
        local tween = TweenService:Create(p8, TweenInfo.new(p9, p12 or Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, p11), p10)

        tween:Play()
        t7[#t7 + 1] = tween
    end

    if v13.glow then
        v13.glow.Rotation = 0
        forever(v13.glow, t2.GLOW_LAP, {
            Rotation = 360
        }, false, Enum.EasingStyle.Linear)
    end

    task.spawn(function() -- line: 112
        -- upvalues: p5 (copy), p6 (copy), p7 (copy), v13 (copy), t7 (copy), t2 (copy), range (copy), ember (copy)
        while p7() do
            if p6() then
                ember(v13, p5.AbsoluteSize.X / math.max(1, p5.AbsoluteSize.Y))
            end

            task.wait(range(t2.EMBER_EVERY))
        end

        for _, v14 in ipairs(t7) do
            v14:Cancel()
        end
    end)
end

return t1
