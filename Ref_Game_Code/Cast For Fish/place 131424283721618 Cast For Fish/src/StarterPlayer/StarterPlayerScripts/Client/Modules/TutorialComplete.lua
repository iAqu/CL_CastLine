-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local UIKit = require(script.Parent.UIKit)
local t1 = {}

t1.__index = t1
t1.DURATION = 3.8
t1.PIECES = 90
t1.COLORS = {
    Color3.fromRGB(255, 221, 40),
    Color3.fromRGB(255, 90, 120),
    Color3.fromRGB(90, 200, 255),
    Color3.fromRGB(120, 255, 140),
    Color3.fromRGB(200, 120, 255),
    Color3.fromRGB(255, 160, 40)
}
t1.Played = 0
t1.AFTER = 2
t1.BusyUntil = 0

function t1.Busy() -- line: 20
    -- upvalues: t1 (copy)
    return os.clock() < t1.BusyUntil
end

function t1.new() -- line: 24
    -- upvalues: UIKit (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self.Gui = UIKit.screenGui("TutorialComplete", 40)
    self.Gui.Enabled = false
    self.Layer = UIKit.frame(self.Gui, {
        Name = "Confetti",
        Transparency = 1,
        ZIndex = 1,
        Size = UDim2.fromScale(1, 1)
    })
    self.Banner = UIKit.frame(self.Gui, {
        Name = "Banner",
        Transparency = 1,
        ZIndex = 5,
        Size = UDim2.fromOffset(1200, 260),
        Position = UDim2.fromScale(0.5, 0.45),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local v2 = UIKit.text(self.Banner, {
        Name = "Title",
        Text = "TUTORIAL COMPLETE!",
        TextSize = 120,
        Stroke = 10,
        ZIndex = 6,
        Size = UDim2.new(1, 0, 0, 140),
        StrokeColor = Color3.fromRGB(110, 60, 0)
    })

    v2.TextColor3 = Color3.new(1, 1, 1)
    UIKit.gradient(v2, Color3.fromRGB(255, 245, 120), Color3.fromRGB(255, 165, 30))
    UIKit.text(self.Banner, {
        Name = "Sub",
        Text = "You're ready! Catch, train and cast farther!",
        TextSize = 52,
        Stroke = 6,
        ZIndex = 6,
        Size = UDim2.new(1, 0, 0, 64),
        Position = UDim2.fromOffset(0, 150)
    })
    self.Bits = {}
    self.Conn = nil

    return self
end

function t1:Spawn() -- line: 39
    local Frame = Instance.new("Frame")

    Frame.Name = "Bit"
    Frame.BorderSizePixel = 0
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = self.COLORS[math.random(1, #self.COLORS)]
    Frame.Size = UDim2.fromScale(0.012 + math.random() * 0.01, 0.02 + math.random() * 0.02)
    Frame.ZIndex = 2
    Frame.Parent = self.Layer

    local v3 = math.random() < 0.5

    table.insert(self.Bits, {
        age = 0,
        frame = Frame,
        x = v3 and -0.02 or 1.02,
        y = 0.75 + math.random() * 0.2,
        vx = (v3 and 1 or -1) * (0.25 + math.random() * 0.45),
        vy = -(1.1 + math.random() * 0.7),
        rot = math.random(0, 360),
        vr = math.random(-540, 540),
        life = 2.6 + math.random() * 1.2
    })
end

function t1:Step(p3) -- line: 62
    for i = #self.Bits, 1, -1 do
        local v4 = self.Bits[i]

        v4.age += p3

        if v4.age >= v4.life or v4.y > 1.15 then
            v4.frame:Destroy()
            table.remove(self.Bits, i)
        else
            v4.vy += p3 * 1.6
            v4.vx *= 1 - p3 * 0.8
            v4.x += v4.vx * p3
            v4.y += v4.vy * p3
            v4.rot += v4.vr * p3
            v4.frame.Position = UDim2.fromScale(v4.x, v4.y)
            v4.frame.Rotation = v4.rot
            v4.frame.BackgroundTransparency = math.clamp((v4.age - (v4.life - 0.5)) / 0.5, 0, 1)
        end
    end
end

function t1:Play() -- line: 82
    -- upvalues: RunService (copy), UIKit (copy), t1 (copy)
    t1.Played += 1
    t1.BusyUntil = os.clock() + self.DURATION + self.AFTER

    if self.Conn then
        self.Conn:Disconnect()
    end

    self.Gui.Enabled = true
    self.Banner.Visible = true

    for _, v6 in ipairs({
            self.Banner.Title,
            self.Banner.Sub
        }) do
        v6.TextTransparency = 0

        local UIStroke = v6:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Transparency = 0
        end
    end

    UIKit.pop(self.Banner, 1.8)
    UIKit.sound("Unlock")
    UIKit.sound("LevelUp", 1.1)

    for _ = 1, self.PIECES do
        self:Spawn()
    end

    local elapsed = os.clock()
    local v7 = false
    local v8 = false

    self.Conn = RunService.RenderStepped:Connect(function(p5) -- line: 106
        -- upvalues: self (copy), elapsed (copy), v7 (ref), v8 (ref), UIKit (copy)
        self:Step(p5)

        local v9 = os.clock() - elapsed

        if not v7 and v9 > 0.45 then
            v7 = true

            for _ = 1, math.floor(self.PIECES / 2) do
                self:Spawn()
            end
        end

        if self.DURATION - 0.5 < v9 and not v8 then
            v8 = true

            for _, v11 in ipairs({
                    self.Banner.Title,
                    self.Banner.Sub
                }) do
                UIKit.tween(v11, 0.45, {
                    TextTransparency = 1
                })

                local UIStroke = v11:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIKit.tween(UIStroke, 0.45, {
                        Transparency = 1
                    })
                end
            end
        end

        if not (self.DURATION < v9) or #self.Bits ~= 0 then
            return
        end

        self.Conn:Disconnect()
        self.Conn = nil
        self.Banner.Visible = false
        self.Gui.Enabled = false
    end)
end

return t1
