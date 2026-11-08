-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)

require(ReplicatedStorage.Packages.Trove)

local t1 = {
    "RUN!",
    "RUN!!",
    "R UN!",
    "RU N!",
    "RUN.",
    "R_N!",
    "RUN!"
}
local v1 = UDim2.fromScale(0.5, 0.125)
local v2 = UDim2.fromScale(0.55, 0.12)
local v3 = UDim2.fromScale(0.5, 0.5)
local v4 = Vector2.new(0.007, 0.01)
local v5 = Vector2.new(0.05, 0.025)
local v6 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v7 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v8 = Color3.fromRGB(8, 0, 4)
local v9 = Color3.fromRGB(255, 255, 255)
local v10 = Color3.fromRGB(14, 0, 6)
local t2 = {}

local function find(p1, p2, p3) -- line: 74
    local v11 = p1:FindFirstChild(p2)

    return if v11 ~= nil and v11:IsA(p3) then v11 else nil
end

local function bind(p4, p5) -- line: 79
    -- upvalues: v1 (copy)
    local Word, v12

    if p4 ~= nil then
        if p4:IsA("GuiObject") then
            Word = p4:FindFirstChild("Word")

            if Word ~= nil and not Word:IsA("GuiObject") then
                Word = nil
            end

            v12 = false
        else
            v12 = true
        end
    else
        v12 = true
    end

    if v12 then
        return nil
    end

    if Word ~= nil then
        local Main = Word:FindFirstChild("Main")

        if Main ~= nil and not Main:IsA("TextLabel") then
            Main = nil
        end

        local t3 = {}

        for i = 1, 3 do
            local v13 = Word:FindFirstChild((("Slice%*"):format(i)))

            if v13 == nil or not v13:IsA("GuiObject") then
                v13 = nil
            end

            local Text

            if v13 ~= nil then
                Text = v13:FindFirstChild("Text")

                if Text == nil or not Text:IsA("TextLabel") then
                    Text = nil
                end
            end

            if v13 ~= nil and Text ~= nil then
                table.insert(t3, {
                    Frame = v13,
                    Text = Text,
                    Stroke = Text:FindFirstChildOfClass("UIStroke")
                })
            end
        end

        local t5 = {
            Fit = 1,
            Root = p4
        }
        local Flash = p4:FindFirstChild("Flash")

        t5.Flash = if Flash == nil or not Flash:IsA("GuiObject") then nil else Flash

        local Slam = p4:FindFirstChild("Slam")

        t5.Slam = if Slam == nil or not Slam:IsA("ImageLabel") then nil else Slam
        t5.Word = Word

        local Punch = Word:FindFirstChild("Punch")

        t5.Punch = if Punch == nil or not Punch:IsA("UIScale") then nil else Punch
        t5.Main = Main
        t5.MainGradient = if Main == nil then nil else Main:FindFirstChildOfClass("UIGradient")
        t5.MainStroke = if Main == nil then nil else Main:FindFirstChildOfClass("UIStroke")

        local GhostRed = Word:FindFirstChild("GhostRed")

        t5.GhostRed = if GhostRed == nil or not GhostRed:IsA("TextLabel") then nil else GhostRed

        local GhostViolet = Word:FindFirstChild("GhostViolet")

        t5.GhostViolet = if GhostViolet == nil or not GhostViolet:IsA("TextLabel") then nil else GhostViolet
        t5.Slices = t3
        t5.Anchor = p5
        t5.Home = v1

        if t5.Flash ~= nil and t5.Slam ~= nil and t5.Punch ~= nil and Main ~= nil and t5.GhostRed ~= nil and t5.GhostViolet ~= nil then
            return t5
        end
    end

    return nil
end

local function easeOut(p6) -- line: 129
    return 1 - (1 - p6) ^ 3
end

local function easeOutBack(p7) -- line: 133
    local v14 = p7 - 1

    return v14 ^ 3 * 2.9 + 1 + v14 ^ 2 * 1.9
end

local function spread(p8, p9) -- line: 139
    return p8:NextNumber(-p9, p9)
end

local function setWordText(p10, p11) -- line: 143
    p10.Main.Text = p11
    p10.GhostRed.Text = p11
    p10.GhostViolet.Text = p11

    for _, v15 in p10.Slices do
        v15.Text.Text = p11
    end
end

local function hideSlices(p12) -- line: 152
    for _, v16 in p12.Slices do
        v16.Frame.Visible = false
    end
end

local function showSlices(p13, p14, p15) -- line: 158
    for _, v17 in p13.Slices do
        local v18 = p14:NextNumber(0.1, 0.26)
        local v19 = p14:NextNumber(0, 1 - v18)
        local v20 = p15 * 0.07 + 0.03
        local v21 = p14:NextNumber(-v20, v20)

        v17.Frame.Size = UDim2.fromScale(1, v18)
        v17.Frame.Position = UDim2.fromScale(v21, v19)
        v17.Text.Size = UDim2.fromScale(1, 1 / v18)
        v17.Text.Position = UDim2.fromScale(0, -v19 / v18)
        v17.Frame.Visible = true
    end
end

local function anchorBox(p16) -- line: 171
    -- upvalues: v1 (copy), v2 (copy)
    local Anchor = p16.Anchor
    local AbsoluteSize = p16.Root.AbsoluteSize

    if Anchor == nil or AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return v1, v2
    end

    local AbsolutePosition = p16.Root.AbsolutePosition
    local v22 = Anchor.AbsolutePosition - AbsolutePosition
    local AbsoluteSize2 = Anchor.AbsoluteSize
    local v23 = AbsoluteSize2.Y * 0.7

    return UDim2.fromScale((v22.X + AbsoluteSize2.X / 2) / AbsoluteSize.X, (v22.Y + v23 / 2) / AbsoluteSize.Y), UDim2.fromScale(AbsoluteSize2.X / AbsoluteSize.X, v23 / AbsoluteSize.Y)
end

local function fitWord(p17) -- line: 188
    -- upvalues: anchorBox (copy)
    local v24, v25 = anchorBox(p17)

    p17.Home = v24
    p17.Word.Position = v24
    p17.Punch.Scale = 1
    p17.Word.Size = v25

    local v27 = math.max(p17.Word.AbsoluteSize.Y / 90, 1)

    p17.Fit = v27
    p17.Word.Size = UDim2.fromScale(v25.X.Scale / v27, v25.Y.Scale / v27)

    local v30 = math.max(math.floor(p17.Word.AbsoluteSize.Y * 0.95), 1)

    p17.Main.TextSize = v30
    p17.GhostRed.TextSize = v30
    p17.GhostViolet.TextSize = v30

    for _, v31 in p17.Slices do
        v31.Text.TextSize = v30
    end
end

local function applyStrokes(p18) -- line: 206
    local v33 = math.max(p18.Main.AbsoluteSize.Y * 0.03, 1)

    if p18.MainStroke ~= nil then
        p18.MainStroke.Thickness = v33
    end

    for _, v34 in p18.Slices do
        if v34.Stroke ~= nil then
            v34.Stroke.Thickness = v33
        end
    end
end

local function setWordTransparency(p19, p20) -- line: 218
    p19.Main.TextTransparency = p20

    if p19.MainStroke ~= nil then
        p19.MainStroke.Transparency = p20
    end

    p19.GhostRed.TextTransparency = p20 * 0.8 + 0.2
    p19.GhostViolet.TextTransparency = p20 * 0.8 + 0.2

    for _, v35 in p19.Slices do
        v35.Text.TextTransparency = p20

        if v35.Stroke ~= nil then
            v35.Stroke.Transparency = p20
        end
    end
end

local function impactFrame(p21, p22) -- line: 233
    -- upvalues: v8 (copy), v9 (copy)
    local Flash = p21.Flash

    if p22 then
        Flash.BackgroundColor3 = v8
    else
        Flash.BackgroundColor3 = v9
    end

    p21.Flash.BackgroundTransparency = 0

    local Main = p21.Main

    if p22 then
        Main.TextColor3 = v9
    else
        Main.TextColor3 = v8
    end

    if p21.MainGradient ~= nil then
        p21.MainGradient.Enabled = false
    end

    if p21.MainStroke ~= nil then
        p21.MainStroke.Transparency = 1
    end

    p21.GhostRed.Visible = false
    p21.GhostViolet.Visible = false
end

local function settleFrame(p23, p24) -- line: 247
    -- upvalues: v9 (copy), v10 (copy)
    p23.Flash.BackgroundColor3 = v9
    p23.Main.TextColor3 = v9

    if p23.MainGradient ~= nil then
        p23.MainGradient.Enabled = true
    end

    if p23.MainStroke ~= nil then
        p23.MainStroke.Color = v10
        p23.MainStroke.Transparency = 0
    end

    p23.GhostRed.Visible = not p24
    p23.GhostViolet.Visible = not p24
end

local function reset(p25) -- line: 261
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v9 (copy), v10 (copy), setWordTransparency (copy)
    p25.Root.Visible = false
    p25.Flash.BackgroundTransparency = 1
    p25.Slam.ImageTransparency = 1
    p25.Punch.Scale = 1
    p25.Fit = 1
    p25.Home = v1
    p25.Word.Size = v2
    p25.Word.Position = v1
    p25.Word.Visible = true
    p25.GhostRed.Position = v3
    p25.GhostViolet.Position = v3
    p25.Main.Text = "RUN!"
    p25.GhostRed.Text = "RUN!"
    p25.GhostViolet.Text = "RUN!"

    for _, v36 in p25.Slices do
        v36.Text.Text = "RUN!"
    end

    setWordTransparency(p25, 0)
    p25.Flash.BackgroundColor3 = v9
    p25.Main.TextColor3 = v9

    if p25.MainGradient ~= nil then
        p25.MainGradient.Enabled = true
    end

    if p25.MainStroke ~= nil then
        p25.MainStroke.Color = v10
        p25.MainStroke.Transparency = 0
    end

    p25.GhostRed.Visible = true
    p25.GhostViolet.Visible = true

    for _, v37 in p25.Slices do
        v37.Frame.Visible = false
    end
end

local function punchCamera(p26, p27) -- line: 279
    -- upvalues: TweenService (copy), Workspace (copy), CameraShaker (copy), CameraShakerDriver (copy), v6 (copy), v7 (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return
    end

    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

    ColorCorrectionEffect.Name = "HalloweenRunHit"
    ColorCorrectionEffect.Saturation = -1
    ColorCorrectionEffect.Contrast = p27 and 0.3 or 0.9
    ColorCorrectionEffect.Brightness = 0.08
    ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 205, 205)
    ColorCorrectionEffect.Parent = CurrentCamera
    p26:Add(ColorCorrectionEffect)
    p26:Add(task.delay(0.1, function() -- line: 293
        -- upvalues: ColorCorrectionEffect (copy), TweenService (copy), v7 (copy)
        TweenService:Create(ColorCorrectionEffect, v7, {
            Saturation = 0,
            Contrast = 0,
            Brightness = 0,
            TintColor = Color3.new(1, 1, 1)
        }):Play()
    end))

    if p27 then
        return
    end

    local FieldOfView = CurrentCamera.FieldOfView

    CurrentCamera.FieldOfView = math.max(FieldOfView - 9, 20)

    local tween = TweenService:Create(CurrentCamera, v6, {
        FieldOfView = FieldOfView
    })

    tween:Play()
    p26:Add(function() -- line: 310
        -- upvalues: CurrentCamera (copy), FieldOfView (copy), tween (copy)
        if tween.PlaybackState == Enum.PlaybackState.Playing then
            tween:Cancel()
            CurrentCamera.FieldOfView = FieldOfView
        end
    end)

    local v39 = CameraShaker.new()

    CameraShakerDriver.Start(v39, Enum.RenderPriority.Last.Value)
    p26:Add(function() -- line: 319
        -- upvalues: v39 (copy), CameraShakerDriver (copy)
        CameraShakerDriver.Stop(v39)
    end)
    v39:ShakeOnce(6, 16, 0, 0.55, Vector3.new(0.35, 0.35, 0.35), (Vector3.new(2.5, 1.2, 3)))
    v39:ShakeOnce(1.1, 22, 0.05, 1.6, Vector3.new(0.1, 0.1, 0.1), (Vector3.new(0.8, 0.4, 1)))
end

function t2.Play(p28, p29, p30) -- line: 330
    -- upvalues: GuiService (copy), RunService (copy), t1 (copy), v3 (copy), v4 (copy), v5 (copy), v8 (copy), v9 (copy), v10 (copy), bind (copy), spread (copy), showSlices (copy), fitWord (copy), applyStrokes (copy), reset (copy), punchCamera (copy)
    local v40 = bind(p28, p30)

    if v40 == nil then
        return false
    end

    local v41 = p29:Extend()
    local ReducedMotionEnabled = GuiService.ReducedMotionEnabled
    local v42 = Random.new()

    reset(v40)
    v41:Add(function() -- line: 340
        -- upvalues: v40 (copy), reset (copy)
        reset(v40)
    end)
    v40.Root.Visible = true
    fitWord(v40)
    applyStrokes(v40)
    punchCamera(v41, ReducedMotionEnabled)

    if ReducedMotionEnabled then
        v40.Flash.BackgroundColor3 = v9
        v40.Main.TextColor3 = v9

        if v40.MainGradient ~= nil then
            v40.MainGradient.Enabled = true
        end

        if v40.MainStroke ~= nil then
            v40.MainStroke.Color = v10
            v40.MainStroke.Transparency = 0
        end

        v40.GhostRed.Visible = false
        v40.GhostViolet.Visible = false
        v40.Flash.BackgroundTransparency = 0.6
    else
        v40.Flash.BackgroundColor3 = v8
        v40.Flash.BackgroundTransparency = 0
        v40.Main.TextColor3 = v9

        if v40.MainGradient ~= nil then
            v40.MainGradient.Enabled = false
        end

        if v40.MainStroke ~= nil then
            v40.MainStroke.Transparency = 1
        end

        v40.GhostRed.Visible = false
        v40.GhostViolet.Visible = false
    end

    local elapsed = os.clock()
    local n1 = 0
    local n2 = 0
    local v43 = v42:NextNumber(0.2, 0.35)
    local n3 = 0

    v41:Connect(RunService.RenderStepped, function(p31) -- line: 359
        -- upvalues: v40 (copy), ReducedMotionEnabled (copy), v42 (copy), elapsed (copy), n1 (ref), n2 (ref), v43 (ref), n3 (ref), t1 (copy), v3 (copy), v4 (copy), v5 (copy), v8 (copy), v9 (copy), v10 (copy), spread (copy), showSlices (copy)
        local v44 = os.clock() - elapsed

        if not ReducedMotionEnabled and n3 == 0 and v44 >= 0.05 then
            n3 = 1
            v40.Flash.BackgroundColor3 = v9
            v40.Flash.BackgroundTransparency = 0
            v40.Main.TextColor3 = v8

            if v40.MainGradient ~= nil then
                v40.MainGradient.Enabled = false
            end

            if v40.MainStroke ~= nil then
                v40.MainStroke.Transparency = 1
            end

            v40.GhostRed.Visible = false
            v40.GhostViolet.Visible = false
        end

        if n3 < 2 and (if ReducedMotionEnabled then 0 else 0.1) <= v44 then
            n3 = 2
            v40.Flash.BackgroundColor3 = v9
            v40.Main.TextColor3 = v9

            if v40.MainGradient ~= nil then
                v40.MainGradient.Enabled = true
            end

            if v40.MainStroke ~= nil then
                v40.MainStroke.Color = v10
                v40.MainStroke.Transparency = 0
            end

            v40.GhostRed.Visible = not ReducedMotionEnabled
            v40.GhostViolet.Visible = not ReducedMotionEnabled
        end

        local v47 = math.max(v44 - 0.1, 0)

        if n3 == 2 then
            local v48 = if ReducedMotionEnabled then 0.6 else 0.45
            local v50 = 1 - (1 - math.clamp(v47 / 0.35, 0, 1)) ^ 3

            v40.Flash.BackgroundTransparency = v48 + (1 - v48) * v50
        end

        v40.Slam.ImageTransparency = 1 - (1 - math.clamp(v47 / 1.1, 0, 1)) ^ 3

        local v52 = if ReducedMotionEnabled then 1.15 else 2.3
        local v54 = math.clamp(v47 / 0.18, 0, 1)
        local Punch, Fit = v40.Punch, v40.Fit
        local v55 = 1 - v52
        local v56 = v54 - 1

        Punch.Scale = Fit * (v52 + v55 * (v56 ^ 3 * 2.9 + 1 + v56 ^ 2 * 1.9))

        if not ReducedMotionEnabled then
            n1 += p31

            if not (n1 < 0.03333333333333333) then
                n1 = 0

                local v58 = (1 - math.clamp(v44 / 1.6, 0, 1)) * 0.65 + 0.35
                local Word, Home = v40.Word, v40.Home
                local fromScale = UDim2.fromScale
                local v59 = v4.X * v58

                Word.Position = Home + fromScale(v42:NextNumber(-v59, v59), spread(v42, v4.Y * v58))

                local v60 = v42:NextNumber(0.3, 1) * v5.X * v58
                local v61 = v5.Y * v58
                local v62 = v42:NextNumber(-v61, v61)

                v40.GhostRed.Position = v3 + UDim2.fromScale(-v60, v62)
                v40.GhostViolet.Position = v3 + UDim2.fromScale(v60, -v62)

                if v43 <= v44 then
                    n2 = v44 + v42:NextNumber(0.06, 0.12)
                    v43 = n2 + v42:NextNumber(0.14, 0.34)
                end

                if v44 < n2 then
                    showSlices(v40, v42, v58)

                    local v64 = t1[v42:NextInteger(1, #t1)]

                    v40.Main.Text = v64
                    v40.GhostRed.Text = v64
                    v40.GhostViolet.Text = v64

                    for _, v65 in v40.Slices do
                        v65.Text.Text = v64
                    end

                    v40.Main.TextTransparency = v42:NextNumber() < 0.3 and 0.45 or 0
                else
                    for _, v66 in v40.Slices do
                        v66.Frame.Visible = false
                    end

                    v40.Main.Text = "RUN!"
                    v40.GhostRed.Text = "RUN!"
                    v40.GhostViolet.Text = "RUN!"

                    for _, v67 in v40.Slices do
                        v67.Text.Text = "RUN!"
                    end

                    v40.Main.TextTransparency = 0
                end
            end
        end
    end)

    return true
end

return t2
