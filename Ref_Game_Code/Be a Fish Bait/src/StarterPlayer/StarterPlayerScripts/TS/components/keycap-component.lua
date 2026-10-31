-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local TweenService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local v1 = Font.fromEnum(Enum.Font.GothamBlack)
local v2 = Color3.new(0, 0, 0)
local v3 = TweenInfo.new(0.23, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

local function getRandomLetter() -- line: 20
    return (string.char(math.random(65, 90)))
end

local t1 = {
    Color3.fromHex("#e777da"),
    Color3.fromHex("#e18dd8"),
    Color3.fromHex("#c499ec")
}

local function getRandomColor(p1) -- line: 25
    -- upvalues: t1 (copy)
    local t2 = {
        p1.randomColorOption1 or t1[1],
        p1.randomColorOption2 or t1[2],
        p1.randomColorOption3 or t1[3]
    }

    return t2[math.random(0, #t2 - 1) + 1]
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 33
        return "KeycapComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 39
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p2, p3, p4) -- line: 43
    -- upvalues: BaseComponent (copy), Maid (copy), getRandomColor (copy)
    BaseComponent.constructor(p2)
    p2._soundController = p3
    p2._keycapProximityController = p4
    p2._maid = Maid.new()
    p2._isPressed = false

    if p2.attributes.randomColor then
        p2.instance.Color = getRandomColor(p2.attributes)
    end

    p2._originalColor = p2.instance.Color
    p2._pressedColor = p2.attributes.overridePressedColor or Color3.new(p2._originalColor.R * 0.65, p2._originalColor.G * 0.65, p2._originalColor.B * 0.65)
    p2._originalSize = p2.instance.Size
    p2._originalCFrame = p2.instance.CFrame

    local v11 = p2._originalSize.Y * 0.22

    p2._pressedSize = Vector3.new(p2._originalSize.X, v11, p2._originalSize.Z)

    local v12 = (p2._originalSize.Y - v11) / 2

    p2._pressedCFrame = p2._originalCFrame * CFrame.new(0, -v12, 0)
    p2:_buildTextSurface()
end

function self.onStart(p5) -- line: 64
    p5._keycapProximityController:register(p5)
    p5._maid:GiveTask(function() -- line: 66
        -- upvalues: p5 (copy)
        return p5._keycapProximityController:unregister(p5)
    end)
end

function self.destroy(p6) -- line: 70
    -- upvalues: BaseComponent (copy)
    BaseComponent.destroy(p6)
    p6._maid:Destroy()
end

function self.setIsPlayerOnKeycap(p7, p8) -- line: 74
    if p8 then
        p7:_press()
    else
        p7:_release()
    end
end

function self._buildTextSurface(p9) -- line: 81
    -- upvalues: v1 (copy), v2 (copy)
    local SurfaceGui = Instance.new("SurfaceGui")

    SurfaceGui.Face = Enum.NormalId.Top
    SurfaceGui.Name = "TextSurface"
    SurfaceGui.LightInfluence = 0
    SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    SurfaceGui.PixelsPerStud = 90
    SurfaceGui.Parent = p9.instance

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Frame"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(0.7, 0, 0.7, 0)
    TextLabel.Position = UDim2.new(0.15, 0, 0.15, 0)
    TextLabel.FontFace = p9.attributes.overrideFont or v1

    local overrideLetter = p9.attributes.overrideLetter

    TextLabel.Text = if overrideLetter == nil then string.char(math.random(65, 90)) else overrideLetter
    TextLabel.TextColor3 = p9.attributes.overrideTextColor or v2
    TextLabel.TextScaled = true
    TextLabel.Parent = SurfaceGui
    p9._maid:GiveTask(SurfaceGui)
end

function self._press(p10) -- line: 105
    -- upvalues: TweenService (copy), v3 (copy), v5 (copy)
    if p10._isPressed then
        return nil
    end

    p10._isPressed = true
    TweenService:Create(p10.instance, v3, {
        CFrame = p10._pressedCFrame,
        Size = p10._pressedSize
    }):Play()
    TweenService:Create(p10.instance, v5, {
        Color = p10._pressedColor
    }):Play()
    p10:_playSound()
end

function self._release(p11) -- line: 119
    -- upvalues: TweenService (copy), v4 (copy), v5 (copy)
    if not p11._isPressed then
        return nil
    end

    p11._isPressed = false
    TweenService:Create(p11.instance, v4, {
        CFrame = p11._originalCFrame,
        Size = p11._originalSize
    }):Play()
    TweenService:Create(p11.instance, v5, {
        Color = p11._originalColor
    }):Play()
end

function self._playSound(p12) -- line: 132
    local v13 = 0.9 + math.random() * 0.12

    p12._soundController:playSoundPolyphonic("KeycapSound", v13)
end

Reflect.defineMetadata(self, "identifier", "client/components/keycap-component@KeycapComponent")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/sound-controller@SoundController", "client/controllers/keycap-proximity-controller@KeycapProximityController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "Keycap",
        attributes = {
            overrideFont = t.optional(t.Font),
            overrideLetter = t.optional(t.string),
            overridePressedColor = t.optional(t.Color3),
            overrideTextColor = t.optional(t.Color3),
            randomColor = t.optional(t.boolean),
            randomColorOption1 = t.optional(t.Color3),
            randomColorOption2 = t.optional(t.Color3),
            randomColorOption3 = t.optional(t.Color3)
        },
        instanceGuard = t.instanceIsA("BasePart")
    }
})

return {
    KeycapComponent = self
}
