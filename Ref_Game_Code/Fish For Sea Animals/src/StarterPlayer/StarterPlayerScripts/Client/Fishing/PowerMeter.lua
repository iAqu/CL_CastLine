-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Offers = require(script.Parent.Parent.Shop.Offers)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local ThrowCap = require(script.Parent.ThrowCap)
local t1 = {}
local v1, Meter, Track, Marker, Prompt, Result, Glow, TextLabel, connection
local n1 = 0
local t2 = {
    {
        text = "PERFECT!",
        max = 1 - Config.PerfectQuality,
        color = Color3.fromRGB(90, 255, 110)
    },
    {
        max = 0.37,
        text = "GREAT!",
        color = Color3.fromRGB(255, 225, 60)
    },
    {
        max = 0.67,
        text = "GOOD",
        color = Color3.fromRGB(255, 160, 50)
    },
    {
        max = 1e999,
        text = "WEAK...",
        color = Color3.fromRGB(240, 70, 70)
    }
}

local function place() -- line: 40
    -- upvalues: UIUtil (copy), Offers (copy), v1 (ref), Meter (ref), Prompt (ref), Result (ref), TextLabel (ref)
    local scale = UIUtil.scale
    local v2 = scale * UIUtil.smallScreenBoost(scale, 1.5)

    Meter.Scale.Scale = v2

    local v3 = 445 * v2
    local v4 = v1.AbsolutePosition + v1.AbsoluteSize / 2
    local v5, v6 = Offers.luckCardArea()
    local v7 = v6 + 6
    local v8 = v5 - 8
    local v9 = Meter.Size.Y.Offset / 2 * v2
    local v10 = v4.Y - v9
    local v11 = (TextLabel.Position.Y.Offset + TextLabel.Size.Y.Offset) * v2
    local v13 = math.max(0, v1.AbsolutePosition.Y + v1.AbsoluteSize.Y - 6 - (v4.Y + v9 + v11))
    local v14

    if v10 < v7 then
        local v15 = v4.X + v3 + Meter.Size.X.Offset / 2 * v2 - v8

        if v15 > 0 then
            v14 = math.min(v7 - v10, v13)

            if v14 < v7 - v10 then
                v3 -= math.min(v15, v3 * 0.4)
            end
        else
            v14 = 0
        end
    else
        v14 = 0
    end

    local v18 = v10 - (Prompt.Size.Y.Offset - Prompt.Position.Y.Offset) * v2
    local v19 = 0

    if v18 + v14 < v7 then
        local v20 = (v4.X + v3 + Prompt.Size.X.Offset / 2 * v2 - v8) / v2

        if v20 > 0 then
            v14 = math.min(v7 - v18, v13)
            v19 = if v14 < v7 - v18 then math.min(v20, (Prompt.Size.X.Offset - Meter.Size.X.Offset) / 2) else 0
        end
    end

    local Prompt2 = Prompt

    Prompt2.Position = UDim2.new(0.5, -math.round(v19), Prompt.Position.Y.Scale, Prompt.Position.Y.Offset)

    local Result2 = Result

    Result2.Position = UDim2.new(0.5, -math.round(v19), Result.Position.Y.Scale, Result.Position.Y.Offset)

    local Meter2 = Meter

    Meter2.Position = UDim2.new(0.5, math.round(v3), 0.5, (math.round(v14)))
end

function t1.init() -- line: 79
    -- upvalues: Config (copy), UIUtil (copy), ThrowCap (copy), v1 (ref), Meter (ref), Track (ref), Marker (ref), Prompt (ref), Result (ref), Glow (ref), TextLabel (ref), place (copy)
    v1 = UIUtil.gui("PowerMeter")
    Meter = v1:WaitForChild("Meter")
    Track = Meter:WaitForChild("Track")
    Marker = Track:WaitForChild("Marker")
    Prompt = Meter.Prompt
    Result = Meter.Result
    Glow = Track:FindFirstChild("Glow")
    TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Reach"
    TextLabel.BackgroundTransparency = 1
    TextLabel.AnchorPoint = Vector2.new(0.5, 0)
    TextLabel.Position = UDim2.new(0.5, 0, 1, 6)
    TextLabel.Size = UDim2.fromOffset(300, 58)
    TextLabel.FontFace = Config.Font
    TextLabel.RichText = true
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.new(1, 1, 1)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Color = Color3.fromRGB(20, 20, 30)
    UIStroke.Parent = TextLabel
    TextLabel.Parent = Meter
    ThrowCap.attach(TextLabel)
    UIUtil.onScale(place)
    v1:GetPropertyChangedSignal("AbsoluteSize"):Connect(place)
end

function t1.start() -- line: 110
    -- upvalues: RunService (copy), UserInputService (copy), UIUtil (copy), ThrowCap (copy), v1 (ref), Meter (ref), Marker (ref), Prompt (ref), Result (ref), Glow (ref), connection (ref), n1 (ref), place (copy)
    if connection then
        connection:Disconnect()
    end

    Result.Visible = false

    local v23 = UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil

    Prompt.Text = v23 and "PRESS A IN THE GREEN!" or "STOP IN THE GREEN!"
    Prompt.Visible = true
    ThrowCap.refresh()
    v1.Enabled = true
    place()
    UIUtil.pop(Meter, 0.5)

    local elapsed = os.clock()

    n1 = -1
    connection = RunService.Heartbeat:Connect(function() -- line: 126
        -- upvalues: elapsed (copy), UIUtil (copy), Marker (ref), Prompt (ref), Glow (ref), n1 (ref)
        local v25 = 1 - math.abs((os.clock() - elapsed) / 1.1 % 2 - 1)
        local v26 = n1

        n1 = v25 * 2 - 1

        if v26 < 0 ~= (n1 < 0) then
            UIUtil.sound("Tick", 0.12, 1.6)
        end

        Marker.Position = UDim2.fromScale(0.5, n1 * 0.5 + 0.5)
        Prompt.Rotation = math.sin(os.clock() * 8) * 3

        if not Glow then
            return
        end

        local v30 = math.max(0, 1 - math.abs(n1) / 0.3)

        Glow.BackgroundTransparency = math.clamp(math.sin(os.clock() * 9) * 0.2 + 0.55 - v30 * 0.5, 0, 1)
    end)
end

function t1.track() -- line: 146
    -- upvalues: v1 (ref), Track (ref)
    return if v1 and v1.Enabled then Track else nil
end

function t1.stop() -- line: 151
    -- upvalues: UIUtil (copy), Kit (copy), v1 (ref), Meter (ref), Track (ref), Marker (ref), Prompt (ref), Result (ref), connection (ref), n1 (ref), t2 (copy)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    local v34 = math.abs(n1)
    local v35 = 1 - v34
    local v36

    for _, v37 in t2 do
        if v34 <= v37.max then
            v36 = v37
            break
        end
    end

    Prompt.Visible = false
    Result.Text = v36.text
    Result.TextColor3 = v36.color
    Result.Visible = true
    UIUtil.pop(Result, 2.4)
    UIUtil.pop(Marker, 1.6)
    UIUtil.pop(Meter, 1.08)

    if v34 <= t2[2].max then
        local v38 = Vector2.new(Track.Size.X.Offset / 2, Track.Size.Y.Offset * (n1 * 0.5 + 0.5))

        Kit.burst(Track, v38, v36.color, v34 <= t2[1].max and 16 or 8, 110)
        Kit.ring(Track, v38, v36.color, v34 <= t2[1].max and 220 or 140)
    end

    task.delay(0.8, function() -- line: 178
        -- upvalues: v1 (ref), connection (ref)
        if not connection then
            v1.Enabled = false
        end
    end)

    return v35, v34 <= t2[1].max, v34 <= t2[2].max
end

function t1.pull() -- line: 188
    -- upvalues: connection (ref), n1 (ref)
    if not connection then
        return 0
    end

    local v41 = math.clamp(1 - math.abs(n1) / 0.75, 0, 1)

    return v41 * v41 * (3 - v41 * 2)
end

function t1.cancel() -- line: 196
    -- upvalues: v1 (ref), connection (ref)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    v1.Enabled = false
end

return t1
