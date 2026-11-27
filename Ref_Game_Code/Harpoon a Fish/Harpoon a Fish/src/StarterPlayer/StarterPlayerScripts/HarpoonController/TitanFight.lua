-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local TitanConfig = require(Modules:WaitForChild("TitanConfig"))
local TitanPath = require(Modules:WaitForChild("TitanPath"))
local TitanBody = require(Modules:WaitForChild("TitanBody"))
local NorseText = require(Modules:WaitForChild("NorseText"))
local LocalPlayer = Players.LocalPlayer
local t1 = {}

function t1.Target(p1) -- line: 31
    -- upvalues: TitanConfig (copy), TitanPath (copy), TitanBody (copy)
    local TitanRide = p1:GetAttribute("TitanRide")
    local TitanU = p1:GetAttribute("TitanU")
    local TitanAngle = p1:GetAttribute("TitanAngle")

    if type(TitanRide) ~= "number" or type(TitanU) ~= "number" or type(TitanAngle) ~= "number" then
        return nil
    end

    local cave = TitanPath.cave

    TitanPath.cave = true

    local v2 = TitanBody.Point(TitanRide, TitanConfig.Now(), TitanU, TitanAngle)

    TitanPath.cave = cave

    return v2
end

function t1.Predict(p2) -- line: 42
    -- upvalues: LocalPlayer (copy)
    p2.tally = (p2.tally or 0) + 1

    if p2.tally >= (p2.tallyNeed or 5) then
        p2.tally = 0
        p2.bars = (p2.bars or 0) + 1

        local v3 = if p2.v1 < 0 then -1 else 1
        local vBase = p2.vBase

        if not vBase then
            vBase = math.abs(p2.v1)
        end

        p2.v1 = v3 * vBase
        p2.v0 = p2.v1
        p2.arcSize = p2.arcBase or p2.arcSize
    end

    LocalPlayer:SetAttribute("TitanTallyLocal", p2.tally)
    LocalPlayer:SetAttribute("TitanBarsLocal", p2.bars or 0)
    LocalPlayer:SetAttribute("TitanPredictAt", os.clock())
end

function t1.Stunned(p3, p4) -- line: 57
    return p3.titan and p3.stunUntil ~= nil and p4 < p3.stunUntil
end

local _ = {
    OUT = 0.22,
    IN = 0.32
}
local n1 = 0

function t1.Collapse(p5, p6) -- line: 63
    -- upvalues: TweenService (copy), n1 (ref)
    local Circle = p5 and p5:FindFirstChild("Circle")
    local Pulse = Circle and Circle:FindFirstChild("Pulse")

    if not Pulse or type(p6) ~= "number" then
        return
    end

    n1 += 1

    local v4 = n1

    TweenService:Create(Pulse, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Scale = 0
    }):Play()
    task.delay(math.max(0.22, p6 - workspace:GetServerTimeNow()), function() -- line: 70
        -- upvalues: p5 (copy), Circle (copy), Pulse (copy), v4 (copy), TweenService (copy), n1 (ref)
        if v4 ~= n1 or not Pulse.Parent or not p5.Enabled or not Circle.Visible then
            return
        end

        Pulse.Scale = 0
        TweenService:Create(Pulse, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end)
end

function t1.PopIn(p7) -- line: 79
    -- upvalues: TweenService (copy), n1 (ref)
    local Circle = p7 and p7:FindFirstChild("Circle")
    local Pulse = Circle and Circle:FindFirstChild("Pulse")

    if not Pulse then
        return
    end

    n1 += 1
    Pulse.Scale = 0
    TweenService:Create(Pulse, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
end

local t2 = {
    TIME = 3,
    TEXT = "ARE YOU SURE? YOU WILL LOSE",
    HINT_Y = 0.05,
    NAME_Y = 0.22,
    NAME_H = 0.2,
    HZ = 3.2,
    SPREAD = 0.55,
    GLINT_HZ = 2.2,
    SHARP = 8,
    BUTTON = {
        TEXT_Y = -0.62,
        TEXT_H = 0.32,
        NAME_Y = -0.22,
        NAME_H = 0.42
    },
    FONT = Font.new("rbxasset://fonts/families/Merriweather.json", Enum.FontWeight.Heavy),
    DEEP = Color3.fromRGB(36, 86, 214),
    BRIGHT = Color3.fromRGB(150, 225, 255),
    GLINT = Color3.fromRGB(240, 252, 255)
}
local t3 = {
    DEEP = Color3.fromRGB(26, 110, 48),
    BRIGHT = Color3.fromRGB(130, 240, 145),
    GLINT = Color3.fromRGB(235, 255, 238)
}
local t4 = nil

local function askParts(p8, p9) -- line: 103
    -- upvalues: NorseText (copy), t2 (copy), t4 (ref)
    if t4 and t4.hintText.Parent and t4.line.Parent then
        return t4
    end

    local Key = p8 and p8:FindFirstChild("Key")
    local Hint = Key and Key:FindFirstChild("Hint")

    if not (Hint and p9) then
        return nil
    end

    local t5 = {
        hintText = Hint,
        hintY = Hint.Position,
        hintFont = Hint.FontFace,
        hintWords = Hint.Text
    }

    local function norse(p10, p11, p12, p13) -- line: 109
        -- upvalues: Hint (copy), NorseText (copy), t2 (copy)
        local v6 = NorseText.Make(p10, "", {
            name = "TitanLose",
            position = UDim2.fromScale(0.5, p11),
            size = UDim2.fromScale(p12, p13),
            color = t2.DEEP,
            zindex = Hint.ZIndex
        })

        v6.Visible = false

        return v6
    end

    local function words(p14, p15, p16, p17) -- line: 115
        -- upvalues: Hint (copy), t2 (copy)
        local clone = Hint:Clone()

        clone.Name = "TitanAsk"
        clone.Text = t2.TEXT
        clone.FontFace = t2.FONT
        clone.Position = UDim2.fromScale(0.5, p15)
        clone.Size = UDim2.fromScale(p16, p17)
        clone.Visible = false
        clone.Parent = p14

        return clone
    end

    t5.lose = norse(Key, t2.NAME_Y, 1.2, t2.NAME_H)

    local BUTTON = t2.BUTTON
    local TEXT_Y, TEXT_H = BUTTON.TEXT_Y, BUTTON.TEXT_H
    local clone = Hint:Clone()

    clone.Name = "TitanAsk"
    clone.Text = t2.TEXT
    clone.FontFace = t2.FONT
    clone.Position = UDim2.fromScale(0.5, TEXT_Y)
    clone.Size = UDim2.fromScale(1.1, TEXT_H)
    clone.Visible = false
    clone.Parent = p9
    t5.line = clone
    t5.lineName = norse(p9, BUTTON.NAME_Y, 1, BUTTON.NAME_H)

    local Frame = Instance.new("Frame")

    Frame.Name = "TitanAskPad"
    Frame.BackgroundTransparency = 1

    local AnchorPoint, Position, Size = p8.AnchorPoint, p8.Position, p8.Size

    Frame.AnchorPoint = AnchorPoint
    Frame.Position = Position
    Frame.Size = Size

    local UIAspectRatioConstraint = p8:FindFirstChildOfClass("UIAspectRatioConstraint")

    if UIAspectRatioConstraint then
        UIAspectRatioConstraint:Clone().Parent = Frame
    end

    Frame.Visible = false
    Frame.Parent = p8.Parent

    local HINT_Y = t2.HINT_Y
    local Scale = Hint.Size.X.Scale
    local Scale2 = Hint.Size.Y.Scale
    local clone2 = Hint:Clone()

    clone2.Name = "TitanAsk"
    clone2.Text = t2.TEXT
    clone2.FontFace = t2.FONT
    clone2.Position = UDim2.fromScale(0.5, HINT_Y)
    clone2.Size = UDim2.fromScale(Scale, Scale2)
    clone2.Visible = false
    clone2.Parent = Frame
    clone2.Visible = true
    t5.padName = norse(Frame, t2.NAME_Y, 1.2, t2.NAME_H)
    t5.padName.Visible = true
    t5.pad = Frame
    t4 = t5

    return t5
end

local function myTitanName() -- line: 147
    -- upvalues: TitanConfig (copy), LocalPlayer (copy)
    for _, child in ipairs(workspace:WaitForChild("Plots"):GetChildren()) do
        local Harpoon = child:FindFirstChild("Harpoon")

        if Harpoon then
            Harpoon = Harpoon:GetAttribute("OccupantUserId") == LocalPlayer.UserId and Harpoon:GetAttribute("TitanRide")
        end

        if type(Harpoon) == "number" then
            return TitanConfig.NameOf(Harpoon), Harpoon
        end
    end

    return "TITAN"
end

local function showAsk(p18, p19, p20) -- line: 155
    -- upvalues: RunService (copy), TitanConfig (copy), NorseText (copy), t2 (copy), t3 (copy), myTitanName (copy)
    if p19 then
        local v7, v8 = myTitanName()

        for _, v9 in ipairs({
                p18.lose,
                p18.lineName,
                p18.padName
            }) do
            NorseText.Set(v9, v7)
        end

        p18.pal = if v8 and TitanConfig.IsJurassicTitan(TitanConfig.RiseSpecies(v8)) and t3 then t3 else t2
    end

    p18.hintText.Text = p19 and t2.TEXT or p18.hintWords
    p18.hintText.FontFace = p19 and t2.FONT or p18.hintFont
    p18.hintText.Position = p19 and UDim2.fromScale(0.5, t2.HINT_Y) or p18.hintY

    local lose, line, lineName = p18.lose, p18.line, p18.lineName

    lose.Visible = p19
    line.Visible = p19
    lineName.Visible = p19
    p18.pad.Visible = p19 and p20 == true

    if not p19 or p18.conn then
        if not p19 and p18.conn then
            p18.conn:Disconnect()
            p18.conn = nil
        end
    else
        p18.conn = RunService.RenderStepped:Connect(function() -- line: 168
            -- upvalues: p18 (copy), t2 (copy)
            local elapsed = os.clock()

            for _, v11 in ipairs({
                    p18.lose,
                    p18.lineName,
                    p18.padName
                }) do
                for _, child in ipairs(v11:GetChildren()) do
                    local ImageLabel = child:IsA("ImageLabel")

                    ImageLabel = ImageLabel and tonumber(child.Name:sub(2))

                    if ImageLabel then
                        local v13 = math.sin(elapsed * t2.HZ - ImageLabel * t2.SPREAD) * 0.5 + 0.5
                        local v16 = math.max(0, (math.cos(elapsed * t2.GLINT_HZ - ImageLabel * t2.SPREAD))) ^ t2.SHARP
                        local v17 = p18.pal or t2

                        child.ImageColor3 = v17.DEEP:Lerp(v17.BRIGHT, v13):Lerp(v17.GLINT, v16)
                    end
                end
            end
        end)
    end
end

function t1.ConfirmLeave(p21, p22, p23) -- line: 187
    -- upvalues: TweenService (copy), t2 (copy), t4 (ref), askParts (copy), showAsk (copy)
    local v18 = askParts(p21, p22)

    if not v18 then
        return true
    end

    local elapsed = os.clock()

    if v18.at and elapsed - v18.at <= t2.TIME then
        v18.at = nil
        v18.hintText.Text = v18.hintWords
        v18.hintText.FontFace = v18.hintFont
        v18.hintText.Position = v18.hintY

        local lose, line, lineName = v18.lose, v18.line, v18.lineName

        lose.Visible = false
        line.Visible = false
        lineName.Visible = false
        v18.pad.Visible = false

        if v18.conn then
            v18.conn:Disconnect()
            v18.conn = nil
        end

        return true
    end

    v18.at = elapsed
    showAsk(v18, true, p23)

    for _, v19 in ipairs({
            p21,
            p22,
            v18.pad
        }) do
        local Visible = v19.Visible and (v19:FindFirstChild("HoverScale") or v19:FindFirstChild("PopScale"))

        if Visible then
            Visible.Scale = 1.18
            TweenService:Create(Visible, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1
            }):Play()
        end
    end

    task.delay(t2.TIME, function() -- line: 206
        -- upvalues: v18 (copy), elapsed (copy), t4 (ref)
        if t4 ~= v18 or v18.at ~= elapsed then
            return
        end

        v18.at = nil
        v18.hintText.Text = v18.hintWords
        v18.hintText.FontFace = v18.hintFont
        v18.hintText.Position = v18.hintY

        local lose, line, lineName = v18.lose, v18.line, v18.lineName

        lose.Visible = false
        line.Visible = false
        lineName.Visible = false
        v18.pad.Visible = false

        if v18.conn then
            v18.conn:Disconnect()
            v18.conn = nil
        end
    end)

    return false
end

return t1
