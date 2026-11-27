-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {
    TIME = 3,
    TEXT = "ARE YOU SURE?",
    LOSE = "YOU WILL LOSE YOUR TURKEY!",
    HINT_Y = 0.05,
    LOSE_Y = 0.22,
    LOSE_H = 0.2,
    HZ = 4,
    BUTTON = {
        TEXT_Y = -0.62,
        TEXT_H = 0.32,
        LOSE_Y = -0.22,
        LOSE_H = 0.42
    },
    FONT = Font.new("rbxasset://fonts/families/FredokaOne.json"),
    DEEP = Color3.fromRGB(200, 96, 28),
    BRIGHT = Color3.fromRGB(255, 196, 110)
}
local t3 = nil

local function askParts(p1, p2) -- line: 22
    -- upvalues: t2 (copy), t3 (ref)
    if t3 and t3.hintText.Parent and t3.line.Parent then
        return t3
    end

    local Key = p1 and p1:FindFirstChild("Key")
    local Hint = Key and Key:FindFirstChild("Hint")

    if not (Hint and p2) then
        return nil
    end

    local t4 = {
        hintText = Hint,
        hintY = Hint.Position,
        hintFont = Hint.FontFace,
        hintWords = Hint.Text
    }

    local function words(p3, p4, p5, p6, p7, p8) -- line: 28
        -- upvalues: Hint (copy), t2 (copy)
        local clone = Hint:Clone()

        clone.Name = p8 and "TurkeyLose" or "TurkeyAsk"
        clone.Text = p4
        clone.FontFace = t2.FONT
        clone.Position = UDim2.fromScale(0.5, p5)
        clone.Size = UDim2.fromScale(p6, p7)

        if p8 then
            clone.TextColor3 = t2.DEEP
        end

        clone.Visible = false
        clone.Parent = p3

        return clone
    end

    local LOSE, LOSE_Y, LOSE_H = t2.LOSE, t2.LOSE_Y, t2.LOSE_H
    local clone = Hint:Clone()

    clone.Name = "TurkeyLose"
    clone.Text = LOSE
    clone.FontFace = t2.FONT
    clone.Position = UDim2.fromScale(0.5, LOSE_Y)
    clone.Size = UDim2.fromScale(1.2, LOSE_H)
    clone.TextColor3 = t2.DEEP
    clone.Visible = false
    clone.Parent = Key
    t4.lose = clone

    local BUTTON, TEXT = t2.BUTTON, t2.TEXT
    local TEXT_Y, TEXT_H = BUTTON.TEXT_Y, BUTTON.TEXT_H
    local clone2 = Hint:Clone()

    clone2.Name = "TurkeyAsk"
    clone2.Text = TEXT
    clone2.FontFace = t2.FONT
    clone2.Position = UDim2.fromScale(0.5, TEXT_Y)
    clone2.Size = UDim2.fromScale(1.1, TEXT_H)
    clone2.Visible = false
    clone2.Parent = p2
    t4.line = clone2

    local LOSE2 = t2.LOSE
    local LOSE_Y2, LOSE_H2 = BUTTON.LOSE_Y, BUTTON.LOSE_H
    local clone3 = Hint:Clone()

    clone3.Name = "TurkeyLose"
    clone3.Text = LOSE2
    clone3.FontFace = t2.FONT
    clone3.Position = UDim2.fromScale(0.5, LOSE_Y2)
    clone3.Size = UDim2.fromScale(1.3, LOSE_H2)
    clone3.TextColor3 = t2.DEEP
    clone3.Visible = false
    clone3.Parent = p2
    t4.lineLose = clone3

    local Frame = Instance.new("Frame")

    Frame.Name = "TurkeyAskPad"
    Frame.BackgroundTransparency = 1

    local AnchorPoint, Position, Size = p1.AnchorPoint, p1.Position, p1.Size

    Frame.AnchorPoint = AnchorPoint
    Frame.Position = Position
    Frame.Size = Size

    local UIAspectRatioConstraint = p1:FindFirstChildOfClass("UIAspectRatioConstraint")

    if UIAspectRatioConstraint then
        UIAspectRatioConstraint:Clone().Parent = Frame
    end

    Frame.Visible = false
    Frame.Parent = p1.Parent

    local TEXT2, HINT_Y = t2.TEXT, t2.HINT_Y
    local Scale = Hint.Size.X.Scale
    local Scale2 = Hint.Size.Y.Scale
    local clone4 = Hint:Clone()

    clone4.Name = "TurkeyAsk"
    clone4.Text = TEXT2
    clone4.FontFace = t2.FONT
    clone4.Position = UDim2.fromScale(0.5, HINT_Y)
    clone4.Size = UDim2.fromScale(Scale, Scale2)
    clone4.Visible = false
    clone4.Parent = Frame
    clone4.Visible = true

    local LOSE3, LOSE_Y3, LOSE_H3 = t2.LOSE, t2.LOSE_Y, t2.LOSE_H
    local clone5 = Hint:Clone()

    clone5.Name = "TurkeyLose"
    clone5.Text = LOSE3
    clone5.FontFace = t2.FONT
    clone5.Position = UDim2.fromScale(0.5, LOSE_Y3)
    clone5.Size = UDim2.fromScale(1.2, LOSE_H3)
    clone5.TextColor3 = t2.DEEP
    clone5.Visible = false
    clone5.Parent = Frame
    t4.padLose = clone5
    t4.padLose.Visible = true
    t4.pad = Frame
    t3 = t4

    return t4
end

local function showAsk(p9, p10, p11) -- line: 61
    -- upvalues: RunService (copy), t2 (copy)
    p9.hintText.Text = p10 and t2.TEXT or p9.hintWords
    p9.hintText.FontFace = p10 and t2.FONT or p9.hintFont
    p9.hintText.Position = p10 and UDim2.fromScale(0.5, t2.HINT_Y) or p9.hintY

    local lose, line, lineLose = p9.lose, p9.line, p9.lineLose

    lose.Visible = p10
    line.Visible = p10
    lineLose.Visible = p10
    p9.pad.Visible = p10 and p11 == true

    if not p10 or p9.conn then
        if not p10 and p9.conn then
            p9.conn:Disconnect()
            p9.conn = nil
        end
    else
        p9.conn = RunService.RenderStepped:Connect(function() -- line: 69
            -- upvalues: p9 (copy), t2 (copy)
            local v2 = t2.DEEP:Lerp(t2.BRIGHT, math.sin(os.clock() * t2.HZ) * 0.5 + 0.5)
            local lose, lineLose, padLose = p9.lose, p9.lineLose, p9.padLose

            lose.TextColor3 = v2
            lineLose.TextColor3 = v2
            padLose.TextColor3 = v2
        end)
    end
end

function t1.Confirm(p12, p13, p14) -- line: 79
    -- upvalues: RunService (copy), TweenService (copy), t2 (copy), t3 (ref), askParts (copy)
    local v3 = askParts(p12, p13)

    if not v3 then
        return true
    end

    local elapsed = os.clock()

    if v3.at and elapsed - v3.at <= t2.TIME then
        v3.at = nil
        v3.hintText.Text = v3.hintWords
        v3.hintText.FontFace = v3.hintFont
        v3.hintText.Position = v3.hintY

        local lose, line, lineLose = v3.lose, v3.line, v3.lineLose

        lose.Visible = false
        line.Visible = false
        lineLose.Visible = false
        v3.pad.Visible = false

        if v3.conn then
            v3.conn:Disconnect()
            v3.conn = nil
        end

        return true
    end

    v3.at = elapsed
    v3.hintText.Text = t2.TEXT or v3.hintWords
    v3.hintText.FontFace = t2.FONT or v3.hintFont
    v3.hintText.Position = UDim2.fromScale(0.5, t2.HINT_Y) or v3.hintY

    local lose, line, lineLose = v3.lose, v3.line, v3.lineLose

    lose.Visible = true
    line.Visible = true
    lineLose.Visible = true
    v3.pad.Visible = p14 == true

    if not v3.conn then
        v3.conn = RunService.RenderStepped:Connect(function() -- line: 69
            -- upvalues: v3 (copy), t2 (copy)
            local v5 = t2.DEEP:Lerp(t2.BRIGHT, math.sin(os.clock() * t2.HZ) * 0.5 + 0.5)
            local lose, lineLose, padLose = v3.lose, v3.lineLose, v3.padLose

            lose.TextColor3 = v5
            lineLose.TextColor3 = v5
            padLose.TextColor3 = v5
        end)
    end

    for _, v6 in ipairs({
            p12,
            p13,
            v3.pad
        }) do
        local Visible = v6.Visible and (v6:FindFirstChild("HoverScale") or v6:FindFirstChild("PopScale"))

        if Visible then
            Visible.Scale = 1.18
            TweenService:Create(Visible, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1
            }):Play()
        end
    end

    task.delay(t2.TIME, function() -- line: 98
        -- upvalues: v3 (copy), elapsed (copy), t3 (ref)
        if t3 ~= v3 or v3.at ~= elapsed then
            return
        end

        v3.at = nil
        v3.hintText.Text = v3.hintWords
        v3.hintText.FontFace = v3.hintFont
        v3.hintText.Position = v3.hintY

        local lose, line, lineLose = v3.lose, v3.line, v3.lineLose

        lose.Visible = false
        line.Visible = false
        lineLose.Visible = false
        v3.pad.Visible = false

        if v3.conn then
            v3.conn:Disconnect()
            v3.conn = nil
        end
    end)

    return false
end

LocalPlayer:GetAttributeChangedSignal("TurkeyRun"):Connect(function() -- line: 108
    -- upvalues: LocalPlayer (copy), t3 (ref)
    if LocalPlayer:GetAttribute("TurkeyRun") ~= nil or not t3 or not t3.at then
        return
    end

    t3.at = nil

    local t5 = t3

    t5.hintText.Text = t5.hintWords
    t5.hintText.FontFace = t5.hintFont
    t5.hintText.Position = t5.hintY

    local lose, line, lineLose = t5.lose, t5.line, t5.lineLose

    lose.Visible = false
    line.Visible = false
    lineLose.Visible = false
    t5.pad.Visible = false

    if t5.conn then
        t5.conn:Disconnect()
        t5.conn = nil
    end
end)

return t1
