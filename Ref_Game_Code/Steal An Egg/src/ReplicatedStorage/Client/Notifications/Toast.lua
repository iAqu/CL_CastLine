-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local CorruptedAnnouncement = require(script.Parent.CorruptedAnnouncement)
local CorruptedPlate = require(script.Parent.CorruptedPlate)
local Lanes = require(script.Parent.Lanes)
local RareSpawnText = require(script.Parent.RareSpawnText)
local MsgNotif = ReplicatedStorage.Assets.UI.Notifs.MsgNotif
local t1 = {
    Feed = true,
    Banner = true
}
local t2 = {
    0.85, 1.15
}
local t3 = {
    0.92, 1.08
}
local v1 = TweenInfo.new(2.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t4 = {}

local function expectKind(p1, p2, p3) -- line: 91
    if p1 ~= nil and typeof(p1) ~= p2 then
        error(("toast field %* expects a %*, got %*"):format(p3, p2, (typeof(p1))), 3)
    end
end

local function validate(p4) -- line: 97
    -- upvalues: t1 (copy)
    if typeof(p4) ~= "table" then
        error(("Toast.Show expects a request table, got %*"):format((typeof(p4))), 3)
    end

    if typeof(p4.Text) ~= "string" then
        error("a toast needs a string Text", 3)
    end

    if typeof(p4.Seconds) ~= "number" then
        error("a toast needs a numeric Seconds", 3)
    end

    local Lane = p4.Lane

    if Lane ~= nil and (typeof(Lane) ~= "string" or t1[Lane] ~= true) then
        error(("toast field Lane expects \"Feed\" or \"Banner\", got %*"):format((tostring(Lane))), 3)
    end

    local Color = p4.Color

    if Color ~= nil and typeof(Color) ~= "Color3" then
        error(("toast field Color expects a Color3, got %*"):format((typeof(Color))), 3)
    end

    local StrokeColor = p4.StrokeColor

    if StrokeColor ~= nil and typeof(StrokeColor) ~= "Color3" then
        error(("toast field StrokeColor expects a Color3, got %*"):format((typeof(StrokeColor))), 3)
    end

    local Image = p4.Image

    if Image ~= nil and typeof(Image) ~= "string" then
        error(("toast field Image expects a string, got %*"):format((typeof(Image))), 3)
    end

    local WrapText = p4.WrapText

    if WrapText ~= nil and typeof(WrapText) ~= "boolean" then
        error(("toast field WrapText expects a boolean, got %*"):format((typeof(WrapText))), 3)
    end

    local SingleLine = p4.SingleLine

    if SingleLine ~= nil and typeof(SingleLine) ~= "boolean" then
        error(("toast field SingleLine expects a boolean, got %*"):format((typeof(SingleLine))), 3)
    end

    local DelayInRound = p4.DelayInRound

    if DelayInRound ~= nil and typeof(DelayInRound) ~= "boolean" then
        error(("toast field DelayInRound expects a boolean, got %*"):format((typeof(DelayInRound))), 3)
    end

    local Unique = p4.Unique

    if Unique ~= nil and typeof(Unique) ~= "boolean" then
        error(("toast field Unique expects a boolean, got %*"):format((typeof(Unique))), 3)
    end

    local UniqueKey = p4.UniqueKey

    if UniqueKey ~= nil and typeof(UniqueKey) ~= "string" then
        error(("toast field UniqueKey expects a string, got %*"):format((typeof(UniqueKey))), 3)
    end

    local Corrupted = p4.Corrupted

    if Corrupted ~= nil and typeof(Corrupted) ~= "boolean" then
        error(("toast field Corrupted expects a boolean, got %*"):format((typeof(Corrupted))), 3)
    end

    local Sound = p4.Sound

    if Sound ~= nil and typeof(Sound) ~= "string" and typeof(Sound) ~= "number" then
        error(("toast field Sound expects an asset id, got %*"):format((typeof(Sound))), 3)
    end

    local Gradient = p4.Gradient

    if Gradient ~= nil and (typeof(Gradient) ~= "Instance" or not Gradient:IsA("UIGradient")) then
        error("toast field Gradient expects a UIGradient", 3)
    end

    local PreText = p4.PreText

    if PreText == nil then
        return
    end

    if PreText ~= nil and typeof(PreText) ~= "table" then
        error(("toast field PreText expects a table, got %*"):format((typeof(PreText))), 3)
    end

    local Text2 = PreText.Text

    if Text2 ~= nil and typeof(Text2) ~= "string" then
        error(("toast field PreText.Text expects a string, got %*"):format((typeof(Text2))), 3)
    end

    local Color2 = PreText.Color

    if Color2 ~= nil and typeof(Color2) ~= "Color3" then
        error(("toast field PreText.Color expects a Color3, got %*"):format((typeof(Color2))), 3)
    end

    local StrokeColor2 = PreText.StrokeColor

    if StrokeColor2 ~= nil and typeof(StrokeColor2) ~= "Color3" then
        error(("toast field PreText.StrokeColor expects a Color3, got %*"):format((typeof(StrokeColor2))), 3)
    end
end

local function outlined(p5, p6) -- line: 140
    return (("<stroke color=\"#%*\" thickness=\"%*\" joins=\"round\">%*</stroke>"):format(p6:ToHex(), 2, p5))
end

local function tinted(p7, p8) -- line: 144
    return (("<font color=\"#%*\">%*</font>"):format(p8:ToHex(), p7))
end

local function compose(p9, p10, p11) -- line: 148
    local v2 = ("<stroke color=\"#%*\" thickness=\"%*\" joins=\"round\">%*</stroke>"):format((p11 or Color3.new()):ToHex(), 2, p9)

    if p10 == nil then
        return v2
    end

    return (("<font color=\"#%*\">%*</font>"):format(p10:ToHex(), v2))
end

local function isAlertTint(p12) -- line: 153
    if p12.R >= 0.999 and p12.G <= 0.001 then
        return p12.B <= 0.001
    end

    return false
end

local function playCue(p13, p14) -- line: 157
    -- upvalues: Audio (copy), t2 (copy), t3 (copy)
    local Sound = p13.Sound

    if Sound ~= nil then
        Audio.Play(Sound, script, {
            PlaybackSpeed = t3
        })
    elseif p14 ~= nil and p14.R >= 0.999 and p14.G <= 0.001 and p14.B <= 0.001 then
        Audio.Play(17208372272, script)
    else
        Audio.Play("rbxassetid://133842042346471", script, {
            Volume = 0.55,
            PlaybackSpeed = t2
        })
    end
end

local function scaleFactor(p15) -- line: 173
    local UIScale = p15:FindFirstChildOfClass("UIScale")

    if UIScale == nil or not (UIScale.Scale > 0) then
        return 1
    end

    return UIScale.Scale
end

local function plateRoom(p16, p17, p18) -- line: 178
    local UIScale = p16:FindFirstChildOfClass("UIScale")
    local v3 = if UIScale == nil or not (UIScale.Scale > 0) then 1 else UIScale.Scale
    local UIListLayout = p17:FindFirstChildOfClass("UIListLayout")
    local v4 = if UIListLayout == nil then 0 else UIListLayout.Padding.Offset
    local v5 = p17.AbsoluteSize.X / v3

    for _, child in p17:GetChildren() do
        if child:IsA("GuiObject") and child.Visible and table.find(p18, child) == nil then
            v5 -= child.AbsoluteSize.X / v3 + v4
        end
    end

    return v5, p17.AbsoluteSize.Y / v3
end

local function lineWidth(p19, p20) -- line: 191
    -- upvalues: TextService (copy)
    local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

    GetTextBoundsParams.Font = p19.FontFace
    GetTextBoundsParams.Size = p20
    GetTextBoundsParams.Text = p19.ContentText
    GetTextBoundsParams.Width = 0

    local GetTextBoundsAsync = TextService.GetTextBoundsAsync
    local ok, result = pcall(GetTextBoundsAsync, TextService, GetTextBoundsParams)

    return if ok and typeof(result) == "Vector2" and result.X > 0 then result.X else nil
end

local function fitOneLine(p21, p22, p23) -- line: 206
    -- upvalues: lineWidth (copy)
    if p22 <= 0 or p23 <= 0 then
        return false
    end

    local n1 = 0

    for _, v6 in p21 do
        if v6.Visible then
            local v7 = lineWidth(v6, p23)

            if v7 == nil then
                for _, v8 in p21 do
                    v8.TextWrapped = true
                    v8.TextScaled = true
                end

                return true
            end

            n1 += v7
        end
    end

    local v12 = math.max(math.floor((math.min(p23, if n1 > 0 then p23 * (p22 * 0.96) / n1 else p23))), 12)

    for _, v13 in p21 do
        v13.TextSize = v12
    end

    return true
end

local function iconSlot(p24) -- line: 235
    local IconSlot = p24:FindFirstChild("IconSlot")

    if IconSlot ~= nil and IconSlot:IsA("Frame") then
        return IconSlot
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "IconSlot"
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
    UIAspectRatioConstraint.Parent = Frame
    Frame.Parent = p24

    return Frame
end

local function seatIcon(p25, p26, p27, p28) -- line: 254
    -- upvalues: iconSlot (copy)
    p28 = p28 or 1

    if p27 ~= nil and not (p27 < 2) then
        local UIAspectRatioConstraint = p26:FindFirstChildOfClass("UIAspectRatioConstraint")
        local v15 = if UIAspectRatioConstraint == nil then 1 else UIAspectRatioConstraint.AspectRatio
        local v16 = 1.125 * p28 / p27
        local v17 = iconSlot(p25)
        local UIAspectRatioConstraint2 = v17:FindFirstChildOfClass("UIAspectRatioConstraint")

        if UIAspectRatioConstraint2 ~= nil then
            UIAspectRatioConstraint2.AspectRatio = v15 * v16
        end

        v17.LayoutOrder = p26.LayoutOrder
        v17.Size = UDim2.fromScale(1, 1)
        v17.ZIndex = p26.ZIndex
        p26.Parent = v17
        p26.AnchorPoint = Vector2.new(0.5, 1)
        p26.Position = UDim2.fromScale(0.5, 1)
        p26.Size = UDim2.fromScale(1, v16)
    elseif p28 ~= 1 then
        p26.Size = UDim2.fromScale(p26.Size.X.Scale * p28, p26.Size.Y.Scale * p28)
    end
end

local function prefixLabel(p29, p30) -- line: 283
    local PreText = p29:FindFirstChild("PreText")

    if PreText ~= nil and PreText:IsA("TextLabel") then
        return PreText
    end

    local clone = p30:Clone()

    clone.Name = "PreText"
    clone.Parent = p29

    return clone
end

local function applyFont(p31, p32) -- line: 295
    if typeof(p32) == "Font" then
        p31.FontFace = p32
    else
        local new, Family, v18

        if typeof(p32) == "table" and typeof(p32.Family) == "string" then
            new = Font.new
            Family = p32.Family
            v18 = p32.Weight or Enum.FontWeight.Regular

            local ok, result = pcall(new, Family, v18)

            if ok then
                p31.FontFace = result
            end
        end
    end
end

local function speaksAsSammy(p33) -- line: 306
    local PreText = p33.PreText
    local Text = if PreText == nil then nil else PreText.Text

    return Text ~= nil and string.sub(Text, 1, 21) == "Mind Controlled Sammy"
end

local function settleText(p34, p35, p36, p37, p38) -- line: 312
    -- upvalues: plateRoom (copy), fitOneLine (copy)
    if p34.SingleLine then
        local t5 = {
            p37,
            p38
        }

        local function attempt() -- line: 321
            -- upvalues: p35 (copy), p36 (copy), t5 (copy), plateRoom (copy), fitOneLine (copy)
            local v19, v20 = plateRoom(p35, p36, t5)

            return (fitOneLine(t5, v19, v20))
        end

        local v21, v22 = plateRoom(p35, p36, t5)

        if not fitOneLine(t5, v21, v22) then
            task.delay(0, function() -- line: 326
                -- upvalues: p35 (copy), p36 (copy), t5 (copy), plateRoom (copy), fitOneLine (copy)
                if p35.Parent ~= nil then
                    local v23, v24 = plateRoom(p35, p36, t5)

                    fitOneLine(t5, v23, v24)
                end
            end)
        end
    elseif p34.WrapText then
        task.delay(0, function() -- line: 333
            -- upvalues: p35 (copy), p36 (copy), p37 (copy), plateRoom (copy)
            if p35.Parent == nil then
                return
            end

            local v25 = plateRoom(p35, p36, { p37 })
            local UISizeConstraint = Instance.new("UISizeConstraint")

            UISizeConstraint.MaxSize = Vector2.new(math.max(v25, 128), 1e999)
            UISizeConstraint.Parent = p37
        end)
    end
end

local function buildSammy(p39) -- line: 345
    -- upvalues: CorruptedAnnouncement (copy), playCue (copy)
    local v26, v27, v28 = CorruptedAnnouncement.Create(p39.Text, "Mind Controlled Sammy:")

    return {
        banner = v26,
        begin = function() -- begin | line: 349
            -- upvalues: p39 (copy), v27 (copy), playCue (copy)
            playCue(p39, p39.Color)
            v27()
        end,
        finish = v28
    }
end

local function buildPlate(p40) -- line: 357
    -- upvalues: TweenService (copy), CorruptedPlate (copy), RareSpawnText (copy), MsgNotif (copy), v1 (copy), playCue (copy), seatIcon (copy), applyFont (copy), settleText (copy)
    local clone = MsgNotif:Clone()
    local Backdrop = clone:FindFirstChild("Backdrop")
    local Plate = clone:FindFirstChild("Plate")
    local Body = Plate:FindFirstChild("Body")
    local PreText = Plate:FindFirstChild("PreText")

    if PreText == nil or not PreText:IsA("TextLabel") then
        PreText = Body:Clone()
        PreText.Name = "PreText"
        PreText.Parent = Plate
    end

    local v29 = p40.Color or Color3.new(1, 1, 1)
    local v30 = RareSpawnText.Parse(p40.Text)
    local v31, v32

    if v30 then
        Body.AutoLocalize = false
    end

    local Text = p40.Text
    local v33 = ("<stroke color=\"#%*\" thickness=\"%*\" joins=\"round\">%*</stroke>"):format((p40.StrokeColor or Color3.new()):ToHex(), 2, Text)

    Body.Text = if v29 ~= nil then ("<font color=\"#%*\">%*</font>"):format(v29:ToHex(), v33) else v33
    Body.TextColor3 = v29

    local UIStroke = Body:FindFirstChild("UIStroke")

    if UIStroke ~= nil and UIStroke:IsA("UIStroke") and p40.StrokeColor ~= nil then
        UIStroke.Color = p40.StrokeColor
    end

    local v34 = Body.LayoutOrder - 1

    PreText.LayoutOrder = math.max(v34, 0)
    PreText.TextColor3 = v29
    PreText.ZIndex = Body.ZIndex

    local PreText2 = p40.PreText
    local v35 = if PreText2 == nil or PreText2.Text == nil then "" else PreText2.Text
    local v36

    if PreText2 == nil or v35 == "" then
        v36 = ""
    else
        local Color = PreText2.Color

        v36 = ("<stroke color=\"#%*\" thickness=\"%*\" joins=\"round\">%*</stroke>"):format((PreText2.StrokeColor or Color3.new()):ToHex(), 2, v35)

        if Color ~= nil then
            v36 = ("<font color=\"#%*\">%*</font>"):format(Color:ToHex(), v36)
        end
    end

    PreText.Text = v36
    PreText.Visible = v35 ~= ""

    if p40.Size ~= nil then
        clone.Size = p40.Size
    end

    if p40.Corrupted == true then
        clone.Size = UDim2.fromScale(clone.Size.X.Scale, clone.Size.Y.Scale * 1.22)
        Plate.Size = UDim2.fromScale(Plate.Size.X.Scale, Plate.Size.Y.Scale / 1.22)
    end

    if p40.Gradient ~= nil then
        p40.Gradient:Clone().Parent = Body
    end

    if p40.Font ~= nil then
        applyFont(Body, p40.Font)
    end

    Backdrop.Visible = p40.ShowShadow == true

    if p40.SingleLine then
        for _, v37 in { Body, PreText } do
            v37.TextScaled = false
            v37.TextWrapped = false
        end
    end

    if p40.Image ~= nil then
        local Icon = Plate:FindFirstChild("Icon")

        if Icon ~= nil and Icon:IsA("ImageLabel") then
            Icon.Image = p40.Image
            Icon.Visible = true
            seatIcon(Plate, Icon, p40.IconLines, p40.IconScale)
        end
    end

    return {
        banner = clone,
        begin = function() -- begin | line: 424
            -- upvalues: p40 (copy), clone (copy), Backdrop (copy), Plate (copy), Body (copy), PreText (ref), v30 (copy), v31 (ref), v32 (ref), v29 (copy), TweenService (copy), CorruptedPlate (copy), RareSpawnText (copy), v1 (copy), playCue (copy), settleText (copy)
            playCue(p40, v29)
            settleText(p40, clone, Plate, Body, PreText)

            if p40.Corrupted == true then
                v32 = CorruptedPlate.Attach(clone, Plate)
            end

            if v30 then
                v31 = RareSpawnText.Localize(v30, Body, function(p41) -- line: 434
                    -- upvalues: p40 (copy), clone (copy), Plate (copy), Body (copy), PreText (ref), v29 (copy), settleText (copy)
                    if clone.Parent == nil then
                        return
                    end

                    local v38 = ("<stroke color=\"#%*\" thickness=\"%*\" joins=\"round\">%*</stroke>"):format((p40.StrokeColor or Color3.new()):ToHex(), 2, p41)

                    Body.Text = if v29 ~= nil then ("<font color=\"#%*\">%*</font>"):format(v29:ToHex(), v38) else v38
                    settleText(p40, clone, Plate, Body, PreText)
                end)
            end

            task.delay(0.8, function() -- line: 443
                -- upvalues: clone (copy), Backdrop (copy), TweenService (copy), v1 (copy)
                if clone.Parent ~= nil then
                    TweenService:Create(Backdrop, v1, {
                        ImageTransparency = 1
                    }):Play()
                end
            end)
        end,
        finish = function() -- finish | line: 449
            -- upvalues: v31 (ref), v32 (ref)
            if v31 then
                v31()
            end

            if v32 then
                v32()
            end
        end
    }
end

function t4.Show(p42) -- line: 462
    -- upvalues: Lanes (copy), validate (copy), buildSammy (copy), buildPlate (copy)
    validate(p42)

    local PreText = p42.PreText
    local Text = if PreText == nil then nil else PreText.Text
    local v39 = if Text ~= nil and string.sub(Text, 1, 21) == "Mind Controlled Sammy" then buildSammy(p42) else buildPlate(p42)
    local v40 = if p42.Unique == true then p42.Text else p42.UniqueKey

    Lanes.Schedule({
        Lane = p42.Lane or "Feed",
        Frame = v39.banner,
        Seconds = p42.Seconds,
        UniqueKey = v40,
        DelayInRound = p42.DelayInRound,
        OnShown = v39.begin,
        OnRetired = v39.finish
    })
end

return table.freeze(t4)
