-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    {
        property = "BackgroundTransparency",
        classes = { "GuiObject" }
    },
    {
        property = "GroupTransparency",
        classes = { "CanvasGroup" }
    },
    {
        property = "ImageTransparency",
        classes = { "ImageLabel", "ImageButton" }
    },
    {
        property = "TextTransparency",
        classes = { "TextLabel", "TextButton", "TextBox" }
    },
    {
        property = "TextStrokeTransparency",
        classes = { "TextLabel", "TextButton", "TextBox" }
    },
    {
        property = "Transparency",
        classes = { "UIStroke" }
    }
}
local t2 = {}

t2.__index = t2
t2.__class = "GuiTransitionGroup"

local function isAnyOf(p1, p2) -- line: 52
    local v1 = false

    for _, v2 in p2 do
        v1 = v1 or p1:IsA(v2)
    end

    return v1
end

local function captureFade(p3) -- line: 60
    -- upvalues: t1 (copy)
    local t3 = {}
    local t4 = {}

    for _, v3 in t1 do
        local v4 = false

        for _, v5 in v3.classes do
            v4 = v4 or p3:IsA(v5)
        end

        if v4 then
            t3[#t3 + 1] = v3.property
            t4[v3.property] = p3[v3.property]
        end
    end

    return if t3[1] then {
        element = p3,
        properties = t3,
        restingAlpha = t4
    } else nil
end

local function raised(p4, p5) -- line: 76
    return UDim2.new(p4.X.Scale, p4.X.Offset, p4.Y.Scale - p5, p4.Y.Offset)
end

local function schedule(p6, p7, p8, p9) -- line: 80
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p7, p8, p9)

    p6[#p6 + 1] = tween
    tween:Play()
end

local function placeSlides(p10, p11) -- line: 86
    for _, v6 in p10.slides do
        local element = v6.element

        if p11 then
            element.Position = v6.homePosition
        else
            element.Position = v6.liftedPosition
        end
    end
end

local function drift(p12, p13, p14) -- line: 92
    -- upvalues: TweenService (copy)
    for _, v7 in p12.fades do
        local t5 = {}

        for _, v8 in v7.properties do
            if p14 then
                t5[v8] = v7.restingAlpha[v8]
            else
                t5[v8] = 1
            end
        end

        local running = p12.running
        local tween = TweenService:Create(v7.element, p13, t5)

        running[#running + 1] = tween
        tween:Play()
    end

    for _, v9 in p12.slides do
        local v10 = if p14 then v9.homePosition else v9.liftedPosition
        local running = p12.running
        local tween = TweenService:Create(v9.element, p13, {
            Position = v10
        })

        running[#running + 1] = tween
        tween:Play()
    end
end

function t2.new(p15, p16, p17) -- line: 107
    -- upvalues: t (copy), t2 (copy), captureFade (copy)
    t.strict(t.Instance)(p15)
    t.strict(t.Instance)(p16)
    t.strict(t.number)(p17)

    local self = setmetatable({}, t2)

    self.running = {}
    self.fades = {}
    self.slides = {}

    for _, descendant in p15:GetDescendants() do
        local v12 = captureFade(descendant)

        if v12 ~= nil then
            self.fades[#self.fades + 1] = v12
        end
    end

    for _, child in p16:GetChildren() do
        if child:IsA("GuiObject") then
            local Position = child.Position

            self.slides[#self.slides + 1] = {
                element = child,
                homePosition = Position,
                liftedPosition = UDim2.new(Position.X.Scale, Position.X.Offset, Position.Y.Scale - p17, Position.Y.Offset)
            }
        end
    end

    return self
end

function t2:Halt() -- line: 138
    for _, v13 in self.running do
        v13:Cancel()
    end

    table.clear(self.running)
end

function t2:SnapHidden() -- line: 145
    for _, v14 in self.fades do
        local element = v14.element

        for _, v15 in v14.properties do
            element[v15] = 1
        end
    end

    for _, v16 in self.slides do
        v16.element.Position = v16.liftedPosition
    end
end

function t2.Reveal(p20, p21) -- line: 156
    -- upvalues: drift (copy)
    drift(p20, p21, true)
end

function t2.Conceal(p22, p23) -- line: 158
    -- upvalues: drift (copy)
    drift(p22, p23, false)
end

function t2:Rehome() -- line: 160
    for _, v17 in self.slides do
        v17.element.Position = v17.homePosition
    end
end

return t2
