-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Parent = script.Parent
local BarHolder = Parent.BarHolder
local BarBG = BarHolder.BarBG
local LightBar, DarkBar = BarBG.LightBar, BarBG.DarkBar
local VSIcon = BarHolder.VSIcon
local VSText = BarHolder:FindFirstChild("VSText")
local AngelWing, DemonWing, LeftTeamAmountLabel, RightTeamAmountLabel = Parent.AngelWing, Parent.DemonWing, Parent.LeftTeamAmountLabel, Parent.RightTeamAmountLabel
local v1 = LightBar.Size.X.Scale + DarkBar.Size.X.Scale
local v2 = (1 - v1) * 0.5

local function spring() -- line: 61
    return {
        p = 0,
        v = 0
    }
end

local function stepSpring(p1, p2) -- line: 65
    p1.v += (p1.p * -260 - p1.v * 14) * p2
    p1.p += p1.v * p2
end

local function takeOverSprite(p3) -- line: 84
    local v3 = Vector2.new(8, 4)
    local PlaySprite = p3:FindFirstChild("PlaySprite")
    local v4

    if not PlaySprite or not PlaySprite:IsA("LocalScript") then
        v4 = 24

        return {
            frame = 0,
            accum = 0,
            image = p3,
            columns = v3.X,
            frames = v3.X * v3.Y,
            baseFps = v4,
            fps = v4,
            baseSize = p3.Size,
            punch = {
                p = 0,
                v = 0
            }
        }
    end

    v3 = PlaySprite:GetAttribute("Cells") or v3
    v4 = PlaySprite:GetAttribute("FPS") or 24
    PlaySprite.Disabled = true

    return {
        frame = 0,
        accum = 0,
        image = p3,
        columns = v3.X,
        frames = v3.X * v3.Y,
        baseFps = v4,
        fps = v4,
        baseSize = p3.Size,
        punch = {
            p = 0,
            v = 0
        }
    }
end

local function advanceSprite(p4, p5) -- line: 108
    p4.accum += p5

    local v5 = 1 / p4.fps
    local v6 = false

    while v5 <= p4.accum do
        p4.accum -= v5
        v6 = true
        p4.frame = (p4.frame + 1) % p4.frames
    end

    if v6 then
        local ImageRectSize = p4.image.ImageRectSize

        p4.image.ImageRectOffset = Vector2.new(ImageRectSize.X * (p4.frame % p4.columns), ImageRectSize.Y * math.floor(p4.frame / p4.columns))
    end

    local punch = p4.punch

    punch.v += (punch.p * -260 - punch.v * 14) * p5
    punch.p += punch.v * p5

    local v9 = p4.punch.p + 1
    local baseSize = p4.baseSize

    p4.image.Size = UDim2.new(baseSize.X.Scale * v9, baseSize.X.Offset, baseSize.Y.Scale * v9, baseSize.Y.Offset)
    p4.image.Rotation = p4.punch.p * 40
end

local v10 = takeOverSprite(AngelWing)
local v11 = takeOverSprite(DemonWing)
local BarHolderPosition = BarHolder.Position
local VSIconPosition, Size = VSIcon.Position, VSIcon.Size
local v13 = VSText and VSText.Position
local v12 = VSText and VSText.Size
local Size2 = LeftTeamAmountLabel.Size
local Size3 = RightTeamAmountLabel.Size
local TextColor3 = LeftTeamAmountLabel.TextColor3
local TextColor3_2 = RightTeamAmountLabel.TextColor3
local v14 = Color3.fromRGB(255, 245, 190)
local v15 = Color3.fromRGB(255, 150, 150)

local function comma(p6) -- line: 154
    local v18 = tostring((math.floor(p6 + 0.5)))

    repeat
        local v19

        v18, v19 = v18:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
    until v19 == 0

    return v18
end

local v20 = math.random() * 1000
local n1 = 0
local n2 = 0.5
local n3 = 0.5
local n4 = 0
local n5 = 0
local n6 = 0
local n7 = 1.5
local n8 = 0
local n9 = 0.5
local n10 = -1
local t1 = {
    p = 0,
    v = 0
}
local t2 = {
    p = 0,
    v = 0
}
local t3 = {
    p = 0,
    v = 0
}
local n11 = 0
local n12 = 0

local function applyRatio(p7) -- line: 186
    -- upvalues: LightBar (copy), DarkBar (copy), v1 (copy)
    LightBar.Size = UDim2.new(v1 * p7, 0, 1, 0)
    DarkBar.Size = UDim2.new(v1 * (1 - p7), 0, 1, 0)
end

local function step(p8) -- line: 202
    -- upvalues: Parent (copy), BarHolder (copy), LightBar (copy), DarkBar (copy), VSIcon (copy), VSText (copy), LeftTeamAmountLabel (copy), RightTeamAmountLabel (copy), v1 (copy), v2 (copy), advanceSprite (copy), v10 (copy), v11 (copy), BarHolderPosition (copy), VSIconPosition (copy), Size (copy), Size2 (copy), Size3 (copy), TextColor3 (copy), TextColor3_2 (copy), v14 (copy), v15 (copy), comma (copy), v20 (copy), n1 (ref), n2 (ref), n3 (ref), n4 (ref), n5 (ref), n6 (ref), n7 (ref), n8 (ref), n9 (ref), n10 (ref), t1 (copy), t2 (copy), t3 (copy), n11 (ref), n12 (ref), v12 (copy), v13 (copy)
    if Parent.Visible then
        local v21 = math.min(p8, 0.1)

        n1 += v21
        n7 -= v21

        if n7 <= 0 then
            n7 = 1.5 + math.random() * 3

            local v22 = 0.5 + math.random()
            local v23 = math.random() < 0.5

            n6 = (v23 and 1 or -1) * 0.22 * v22

            local v24 = math.min(v22, 1)
            local v26 = n11

            n11 = math.min(7, v26 + v24 * 7)
            t1.v += v24 * 9
            n12 += (v23 and 1 or -1) * 26 * v24

            if v23 then
                v10.punch.v += v24 * 7
            else
                v11.punch.v += v24 * 7
            end
        end

        n6 -= n6 * math.min(v21 * 1.6, 1)
        n2 = math.clamp(0.5 + math.noise(n1 * 0.32, v20) * 2 * 0.34 + n6, 0.12, 0.88)
        n4 += (n2 - n3) * 55 * v21
        n4 *= math.exp(v21 * -7)

        local v37 = n3

        n3 = math.clamp(v37 + n4 * v21, 0.05, 0.95)

        local v38 = n3

        LightBar.Size = UDim2.new(v1 * v38, 0, 1, 0)
        DarkBar.Size = UDim2.new(v1 * (1 - v38), 0, 1, 0)
        n5 += (n4 - n5) * (1 - math.exp(v21 * -8))

        local v43 = math.clamp(n5 / 0.5, -1, 1)

        v10.fps = v10.baseFps + (90 - v10.baseFps) * math.max(v43, 0)
        v11.fps = v11.baseFps + (90 - v11.baseFps) * math.max(-v43, 0)
        advanceSprite(v10, v21)
        advanceSprite(v11, v21)

        local v46 = v1 * n3 + v2

        n9 += (v46 - n9) * (1 - math.exp(v21 * -22))
        t1.v += (t1.p * -260 - t1.v * 14) * v21
        t1.p += t1.v * v21
        n12 -= n12 * math.min(v21 * 6, 1)

        local v53 = t1.p + 1
        local v54 = v43 * 10 + n12

        VSIcon.Position = UDim2.new(n9, VSIconPosition.X.Offset, VSIconPosition.Y.Scale, VSIconPosition.Y.Offset)
        VSIcon.Size = UDim2.new(Size.X.Scale * v53, Size.X.Offset, Size.Y.Scale * v53, Size.Y.Offset)
        VSIcon.Rotation = v54

        if VSText and v13 and v12 then
            VSText.Position = UDim2.new(n9, v13.X.Offset, v13.Y.Scale, v13.Y.Offset)
            VSText.Size = UDim2.new(v12.X.Scale * v53, v12.X.Offset, v12.Y.Scale * v53, v12.Y.Offset)
            VSText.Rotation = v54
        end

        n11 -= n11 * math.min(v21 * 6, 1)

        if n11 > 0.05 then
            BarHolder.Position = UDim2.new(BarHolderPosition.X.Scale, BarHolderPosition.X.Offset + (math.random() - 0.5) * 2 * n11, BarHolderPosition.Y.Scale, BarHolderPosition.Y.Offset + (math.random() - 0.5) * n11)
        elseif BarHolder.Position ~= BarHolderPosition then
            BarHolder.Position = BarHolderPosition
        end

        t2.v += (t2.p * -260 - t2.v * 14) * v21
        t2.p += t2.v * v21
        t3.v += (t3.p * -260 - t3.v * 14) * v21
        t3.p += t3.v * v21
        n8 += v21

        if n8 >= 0.08333333333333333 then
            n8 = 0

            local v59 = math.floor(n3 * 2E+05 + 0.5)

            if n10 >= 0 then
                local v61 = math.abs(v59 - n10) / 2E+05

                if v61 > 0.004 then
                    local v63 = math.min(v61 * 60, 1) * 5

                    if n10 < v59 then
                        t2.v += v63
                    else
                        t3.v += v63
                    end
                end
            end

            n10 = v59

            local v64 = comma(v59)
            local v65 = comma(2E+05 - v59)

            if LeftTeamAmountLabel.Text ~= v64 then
                LeftTeamAmountLabel.Text = v64
            end

            if RightTeamAmountLabel.Text ~= v65 then
                RightTeamAmountLabel.Text = v65
            end
        end

        local v66 = t2.p * 0.5 + 1

        LeftTeamAmountLabel.Size = UDim2.new(Size2.X.Scale * v66, Size2.X.Offset, Size2.Y.Scale * v66, Size2.Y.Offset)
        LeftTeamAmountLabel.TextColor3 = TextColor3:Lerp(v14, (math.clamp(t2.p * 4, 0, 1)))

        local v68 = t3.p * 0.5 + 1

        RightTeamAmountLabel.Size = UDim2.new(Size3.X.Scale * v68, Size3.X.Offset, Size3.Y.Scale * v68, Size3.Y.Offset)
        RightTeamAmountLabel.TextColor3 = TextColor3_2:Lerp(v15, (math.clamp(t3.p * 4, 0, 1)))
    end
end

local v70 = n3

LightBar.Size = UDim2.new(v1 * v70, 0, 1, 0)
DarkBar.Size = UDim2.new(v1 * (1 - v70), 0, 1, 0)

local connection = RunService.RenderStepped:Connect(step)

script.Destroying:Connect(function() -- line: 324
    -- upvalues: BarHolder (copy), VSIcon (copy), AngelWing (copy), DemonWing (copy), LeftTeamAmountLabel (copy), RightTeamAmountLabel (copy), v10 (copy), v11 (copy), BarHolderPosition (copy), VSIconPosition (copy), Size (copy), Size2 (copy), Size3 (copy), TextColor3 (copy), TextColor3_2 (copy), connection (copy)
    connection:Disconnect()
    BarHolder.Position = BarHolderPosition
    VSIcon.Position = VSIconPosition
    VSIcon.Size = Size
    VSIcon.Rotation = 0
    LeftTeamAmountLabel.Size = Size2
    RightTeamAmountLabel.Size = Size3
    LeftTeamAmountLabel.TextColor3 = TextColor3
    RightTeamAmountLabel.TextColor3 = TextColor3_2
    AngelWing.Size = v10.baseSize
    DemonWing.Size = v11.baseSize
    AngelWing.Rotation = 0
    DemonWing.Rotation = 0
end)
