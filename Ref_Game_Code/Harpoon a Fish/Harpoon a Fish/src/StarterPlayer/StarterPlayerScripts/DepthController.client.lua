-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local InputMode = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("InputMode"))
local t1 = {
    dir = 0,
    heldAt = 0,
    HOLD = 0.25,
    RATE = 0.12
}
local t2 = {
    [Enum.KeyCode.E] = -1,
    [Enum.KeyCode.Q] = 1
}
local LocalPlayer = Players.LocalPlayer
local DepthGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("DepthGui")
local Meter = DepthGui:WaitForChild("Meter")
local Pop = Meter:WaitForChild("Pop")
local Head = Meter:WaitForChild("Head")
local Marker = Meter:WaitForChild("Marker")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local HarpoonEnter = Remotes:WaitForChild("HarpoonEnter")
local HarpoonExit = Remotes:WaitForChild("HarpoonExit")
local HarpoonDepth = Remotes:WaitForChild("HarpoonDepth")
local _ = {
    FROM = 0.35,
    IN = 0.32,
    OUT = 0.2
}
local v1 = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)

Head:WaitForChild("Face").Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(LocalPlayer.UserId)

local TipGhost = Meter:WaitForChild("TipGhost")
local TipHand = Meter:WaitForChild("TipHand")
local TipText = Meter:WaitForChild("TipText")
local Pop2 = TipText:WaitForChild("Pop")
local clone = Head:Clone()

clone.Name = "Head"
clone.Active = false
clone.AnchorPoint = Vector2.new(0.5, 0.5)
clone.Position = UDim2.fromScale(0.5, 0.5)
clone.Size = UDim2.fromScale(1, 1)
clone.Parent = TipGhost

local t3 = {
    TOUCH = "Drag your character to change depth!",
    PC = "Use scroll wheel to change depth!",
    PAD = "Use the D-pad to change depth!",
    QUEST_TOUCH = "TAP AND DRAG YOUR CHARACTER TO CHANGE DEPTH!",
    QUEST_PC = "USE THE SCROLL WHEEL TO CHANGE DEPTH!",
    QUEST_PAD = "USE THE D-PAD TO CHANGE DEPTH!",
    GHOST = 0.55,
    PERIOD = 3.6,
    HAND_TIP = Vector2.new(0.29, 0.21),
    IN = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    OUT = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
}
local t4 = {}

for match in (Meter:GetAttribute("TickFracs") or ""):gmatch("[^,]+") do
    table.insert(t4, (tonumber(match)))
end

local v4 = Meter:GetAttribute("TickStep") or 300

local function fracForDepth(p1) -- line: 116
    -- upvalues: t4 (copy), v4 (copy)
    if #t4 == 0 then
        return 0
    end

    local v6 = math.clamp(p1, 0, v4 * (#t4 - 1)) / v4
    local v9 = math.clamp(math.floor(v6) + 1, 1, #t4 - 1)
    local v10 = v6 - (v9 - 1)

    return t4[v9] + (t4[v9 + 1] - t4[v9]) * v10
end

local v11 = Meter:GetAttribute("HeadMinY") or 0.14
local v12 = Meter:GetAttribute("HeadMaxY") or 0.9

local function headFrac(p2) -- line: 127
    -- upvalues: t4 (copy), v11 (copy), v12 (copy)
    if #t4 < 2 then
        return v11
    end

    local v13 = (p2 - t4[1]) / (t4[#t4] - t4[1])

    return v11 + (v12 - v11) * math.clamp(v13, 0, 1)
end

local function setDepth(p3) -- line: 133
    -- upvalues: Head (copy), Marker (copy), t4 (copy), v4 (copy), v11 (copy), v12 (copy)
    local v14

    if #t4 == 0 then
        v14 = 0
    else
        local v16 = math.clamp(p3, 0, v4 * (#t4 - 1)) / v4
        local v19 = math.clamp(math.floor(v16) + 1, 1, #t4 - 1)
        local v20 = v16 - (v19 - 1)

        v14 = t4[v19] + (t4[v19 + 1] - t4[v19]) * v20
    end

    Marker.Position = UDim2.fromScale(Marker.Position.X.Scale, v14)

    local fromScale = UDim2.fromScale
    local Scale = Head.Position.X.Scale
    local v21

    if #t4 < 2 then
        v21 = v11
    else
        local v22 = (v14 - t4[1]) / (t4[#t4] - t4[1])

        v21 = v11 + (v12 - v11) * math.clamp(v22, 0, 1)
    end

    Head.Position = fromScale(Scale, v21)
end

local v24 = v4 * math.max(0, #t4 - 1)

local function depthForFrac(p4) -- line: 141
    -- upvalues: t4 (copy), v4 (copy), v24 (copy)
    if #t4 < 2 or p4 <= t4[1] then
        return 0
    end

    if t4[#t4] <= p4 then
        return v24
    end

    for i = 1, #t4 - 1 do
        if p4 <= t4[i + 1] then
            return v4 * (i - 1 + (p4 - t4[i]) / (t4[i + 1] - t4[i]))
        end
    end

    return 0
end

local Scale = Meter.Position.Y.Scale
local Scale2 = Meter.Size.Y.Scale

local function layout() -- line: 169
    -- upvalues: GuiService (copy), Meter (copy), Scale (copy), Scale2 (copy)
    local GuiInset = GuiService:GetGuiInset()
    local MeterPosition, Size = Meter.Position, Meter.Size

    Meter.Position = UDim2.new(MeterPosition.X.Scale, MeterPosition.X.Offset, Scale, GuiInset.Y / 2)
    Meter.Size = UDim2.new(Size.X.Scale, Size.X.Offset, Scale2, -GuiInset.Y)
end

layout()
DepthGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(layout)

local function v25() -- line: 177
    -- upvalues: GuiService (copy), layout (copy)
    GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(layout)
end

pcall(v25)

local v26 = false
local v27

local function show() -- line: 183
    -- upvalues: TweenService (copy), DepthGui (copy), Pop (copy), Head (copy), Marker (copy), v1 (copy), t4 (copy), v4 (copy), v11 (copy), v12 (copy), v26 (ref)
    if v26 then
        return
    end

    v26 = true

    local v28

    if #t4 == 0 then
        v28 = 0
    else
        local v30 = math.clamp(0, 0, v4 * (#t4 - 1)) / v4
        local v33 = math.clamp(math.floor(v30) + 1, 1, #t4 - 1)
        local v34 = v30 - (v33 - 1)

        v28 = t4[v33] + (t4[v33 + 1] - t4[v33]) * v34
    end

    Marker.Position = UDim2.fromScale(Marker.Position.X.Scale, v28)

    local fromScale = UDim2.fromScale
    local Scale = Head.Position.X.Scale
    local v35

    if #t4 < 2 then
        v35 = v11
    else
        local v36 = (v28 - t4[1]) / (t4[#t4] - t4[1])

        v35 = v11 + (v12 - v11) * math.clamp(v36, 0, 1)
    end

    Head.Position = fromScale(Scale, v35)
    Pop.Scale = 0.35
    DepthGui.Enabled = true
    TweenService:Create(Pop, v1, {
        Scale = 1
    }):Play()
end

local function hide() -- line: 192
    -- upvalues: TweenService (copy), DepthGui (copy), Pop (copy), v2 (copy), v26 (ref), v27 (ref)
    if not v26 then
        return
    end

    v26 = false
    v27(true)

    local tween = TweenService:Create(Pop, v2, {
        Scale = 0.35
    })

    tween.Completed:Once(function() -- line: 197
        -- upvalues: DepthGui (copy), v26 (ref)
        if not v26 then
            DepthGui.Enabled = false
        end
    end)
    tween:Play()
end

local v37 = false
local n1 = 0
local v38 = false
local v39 = nil

local function onTouch() -- line: 206
    -- upvalues: UserInputService (copy)
    return UserInputService:GetLastInputType() == Enum.UserInputType.Touch
end

local v40 = false

local function dressTip() -- line: 208
    -- upvalues: UserInputService (copy), InputMode (copy), TipHand (copy), TipText (copy), t3 (copy), v37 (ref), v40 (ref)
    if v40 then
        TipText.Text = InputMode.Pad() and t3.QUEST_PAD or UserInputService:GetLastInputType() == Enum.UserInputType.Touch and t3.QUEST_TOUCH or t3.QUEST_PC
    else
        local v41, v42, v43

        if InputMode.Pad() then
            local PAD = t3.PAD

            if PAD then
                v42 = PAD
                v43 = true
            else
                v41 = UserInputService:GetLastInputType() == Enum.UserInputType.Touch
                v43 = false
            end
        else
            v41 = UserInputService:GetLastInputType() == Enum.UserInputType.Touch
            v43 = false
        end

        if not v43 then
            local TOUCH = if v41 then t3.TOUCH else nil

            v42 = if not v41 or not TOUCH then t3.PC else TOUCH
        end

        TipText.Text = v42
    end

    TipHand.Visible = v37 and UserInputService:GetLastInputType() == Enum.UserInputType.Touch and not InputMode.Pad()
end

local function showTip() -- line: 216
    -- upvalues: TweenService (copy), TipGhost (copy), TipHand (copy), TipText (copy), Pop2 (copy), t3 (copy), v37 (ref), n1 (ref), v39 (ref), dressTip (copy)
    if v37 then
        return
    end

    local elapsed = os.clock()

    v37 = true
    n1 = elapsed
    v39 = nil
    TipGhost.GroupTransparency = 1
    TipHand.ImageTransparency = 1
    Pop2.Scale = 0
    TipGhost.Visible = true
    TipText.Visible = true
    dressTip()
    TweenService:Create(TipGhost, t3.IN, {
        GroupTransparency = t3.GHOST
    }):Play()
    TweenService:Create(TipHand, t3.IN, {
        ImageTransparency = 0
    }):Play()
    TweenService:Create(Pop2, t3.IN, {
        Scale = 1
    }):Play()
end

v27 = function(p5) -- line: 228
    -- upvalues: TweenService (copy), TipGhost (copy), TipHand (copy), TipText (copy), Pop2 (copy), t3 (copy), v37 (ref)
    if not v37 then
        return
    end

    v37 = false

    if p5 then
        TipGhost.Visible = false
        TipHand.Visible = false
        TipText.Visible = false
    else
        TweenService:Create(TipGhost, t3.OUT, {
            GroupTransparency = 1
        }):Play()
        TweenService:Create(TipHand, t3.OUT, {
            ImageTransparency = 1
        }):Play()

        local tween = TweenService:Create(Pop2, t3.OUT, {
            Scale = 0
        })

        tween.Completed:Once(function() -- line: 238
            -- upvalues: TipGhost (copy), TipHand (copy), TipText (copy), v37 (ref)
            if v37 then
                return
            end

            TipGhost.Visible = false
            TipHand.Visible = false
            TipText.Visible = false
        end)
        tween:Play()
    end
end

UserInputService.LastInputTypeChanged:Connect(function() -- line: 243
    -- upvalues: v37 (ref), dressTip (copy)
    if v37 then
        dressTip()
    end
end)
InputMode.Changed:Connect(function() -- line: 244
    -- upvalues: v37 (ref), dressTip (copy)
    if v37 then
        dressTip()
    end
end)

local function drawTip() -- line: 248
    -- upvalues: Meter (copy), Head (copy), TipGhost (copy), TipHand (copy), TipText (copy), t3 (copy), v11 (copy), v12 (copy), n1 (ref), v39 (ref)
    local Scale = Head.Position.Y.Scale
    local v45 = (v11 + v12) / 2
    local v46 = (v12 - v11) / 2

    if not v39 then
        v39 = math.asin((math.clamp((Scale - v45) / math.max(v46, 0.001), -1, 1)))
    end

    local v50 = v39
    local v51 = v45 + v46 * math.sin(v50 + (os.clock() - n1) * 2 * 3.141592653589793 / t3.PERIOD)

    TipGhost.Position = UDim2.fromScale(Head.Position.X.Scale, v51)
    TipText.Position = UDim2.fromScale(TipText.Position.X.Scale, Scale)

    local AbsoluteSize = Meter.AbsoluteSize
    local AbsoluteSize2 = TipHand.AbsoluteSize

    if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then
        TipHand.Position = UDim2.fromScale(Head.Position.X.Scale + t3.HAND_TIP.X * AbsoluteSize2.X / AbsoluteSize.X, v51 + t3.HAND_TIP.Y * AbsoluteSize2.Y / AbsoluteSize.Y)
    end
end

local DepthTipDone = Remotes:WaitForChild("DepthTipDone")

local function learnedDepth() -- line: 262
    -- upvalues: LocalPlayer (copy), v27 (ref), v38 (ref), DepthTipDone (copy)
    if v38 or LocalPlayer:GetAttribute("DepthTip") ~= true then
        return
    end

    v38 = true
    DepthTipDone:FireServer()
    v27()
end

LocalPlayer:GetAttributeChangedSignal("DepthTip"):Connect(function() -- line: 268
    -- upvalues: LocalPlayer (copy), v27 (ref), v38 (ref)
    if LocalPlayer:GetAttribute("DepthTip") == true then
        v38 = false
    else
        v27()
    end
end)

local v52 = nil
local n2 = 0
local n3 = 0
local t5 = {}

t5[1] = 0

local v53
local n4 = 0
local v54 = false
local v55
local n5 = 0
local t6 = {}

t6[1] = 0

local t7 = {}

t7[1] = 1

local v56

Head.Active = true
Marker.Active = true

local TelemetryReport = Remotes:WaitForChild("TelemetryReport")
local n6 = 0
local v57 = false
local DepthBands = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("DepthBands"))
local Zones = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Zones"))

local function setTarget(p6) -- line: 343
    -- upvalues: Head (copy), Marker (copy), HarpoonExit (copy), t4 (copy), v4 (copy), v11 (copy), v12 (copy), v52 (ref), n2 (ref), n3 (ref), t5 (copy), v54 (ref), v56 (ref), DepthBands (copy)
    v56 = DepthBands.Snap((math.clamp(p6, math.min(n3, n2), n2)))
    t5[1] = v56

    local v62 = t5[1]
    local v63

    if #t4 == 0 then
        v63 = 0
    else
        local v65 = math.clamp(v62, 0, v4 * (#t4 - 1)) / v4
        local v68 = math.clamp(math.floor(v65) + 1, 1, #t4 - 1)
        local v69 = v65 - (v68 - 1)

        v63 = t4[v68] + (t4[v68 + 1] - t4[v68]) * v69
    end

    Marker.Position = UDim2.fromScale(Marker.Position.X.Scale, v63)

    local fromScale = UDim2.fromScale
    local Scale = Head.Position.X.Scale
    local v70

    if #t4 < 2 then
        v70 = v11
    else
        local v71 = (v63 - t4[1]) / (t4[#t4] - t4[1])

        v70 = v11 + (v12 - v11) * math.clamp(v71, 0, 1)
    end

    Head.Position = fromScale(Scale, v70)

    if v52 then
        local v72 = v52

        v72:SetAttribute("DepthGoalLocal", -v56)
    end

    if t5[1] <= 0 and not v54 then
        v54 = true
        HarpoonExit:FireServer()
    end
end

UserInputService.InputChanged:Connect(function(p7, p8) -- line: 360
    -- upvalues: LocalPlayer (copy), Meter (copy), HarpoonDepth (copy), v24 (copy), depthForFrac (copy), v26 (ref), v27 (ref), v38 (ref), DepthTipDone (copy), v52 (ref), n2 (ref), t5 (copy), v53 (ref), n4 (ref), v55 (ref), n5 (ref), t6 (copy), t7 (copy), TelemetryReport (copy), n6 (ref), v57 (ref), setTarget (copy)
    local v73 = v26 and v52 ~= nil and v52:GetAttribute("Arrived") == true and not LocalPlayer:GetAttribute("Cinematic") and LocalPlayer:GetAttribute("TurkeyRun") == nil

    if v73 then
        if p7.UserInputType == Enum.UserInputType.MouseWheel then
            if not p8 then
                setTarget(t5[1] - p7.Position.Z * 0.04 * v24)

                local elapsed = os.clock()

                if not (elapsed - n4 < 0.06666666666666667) and t5[1] ~= v53 then
                    v53 = t5[1]
                    n4 = elapsed
                    HarpoonDepth:FireServer(t5[1])
                end

                if not v38 and LocalPlayer:GetAttribute("DepthTip") == true then
                    v38 = true
                    DepthTipDone:FireServer()
                    v27()
                end

                n6 += 1

                local v75 = n6

                task.delay(0.6, function() -- line: 318
                    -- upvalues: v75 (copy), n2 (ref), t5 (copy), TelemetryReport (copy), n6 (ref)
                    if n6 ~= v75 then
                        return
                    end

                    TelemetryReport:FireServer("depth", "wheel", t5[1], n2)
                end)
            end
        elseif p7 == v55 then
            local Y = Meter.AbsoluteSize.Y

            if not (Y <= 0) then
                setTarget((depthForFrac(t6[1] + t7[1] * (p7.Position.Y - n5) / Y)))

                local elapsed = os.clock()

                if not (elapsed - n4 < 0.06666666666666667) and t5[1] ~= v53 then
                    v53 = t5[1]
                    n4 = elapsed
                    HarpoonDepth:FireServer(t5[1])
                end

                if math.abs(p7.Position.Y - n5) > 4 then
                    if not v38 and LocalPlayer:GetAttribute("DepthTip") == true then
                        v38 = true
                        DepthTipDone:FireServer()
                        v27()
                    end

                    v57 = true
                end
            end
        end
    end
end)
Head.InputBegan:Connect(function(p9) -- line: 400
    -- upvalues: LocalPlayer (copy), t4 (copy), v4 (copy), v11 (copy), v12 (copy), v26 (ref), v52 (ref), t5 (copy), v55 (ref), n5 (ref), t6 (copy), t7 (copy), v57 (ref)
    local v82 = (#t4 >= 2 and t4[#t4] - t4[1] or 1) / math.max(v12 - v11, 0.001)
    local v83 = v26 and v52 ~= nil and v52:GetAttribute("Arrived") == true and not LocalPlayer:GetAttribute("Cinematic") and LocalPlayer:GetAttribute("TurkeyRun") == nil

    if v83 then
        if v55 then
            return
        end

        if p9.UserInputType == Enum.UserInputType.Touch or p9.UserInputType == Enum.UserInputType.MouseButton1 then
            v55 = p9
            n5 = p9.Position.Y

            local v84 = t5[1]
            local v85

            if #t4 == 0 then
                v85 = 0
            else
                local v87 = math.clamp(v84, 0, v4 * (#t4 - 1)) / v4
                local v90 = math.clamp(math.floor(v87) + 1, 1, #t4 - 1)
                local v91 = v87 - (v90 - 1)

                v85 = t4[v90] + (t4[v90 + 1] - t4[v90]) * v91
            end

            t6[1] = v85
            t7[1] = v82
            v57 = false
        end
    end
end)
Marker.InputBegan:Connect(function(p10) -- line: 404
    -- upvalues: LocalPlayer (copy), t4 (copy), v4 (copy), v26 (ref), v52 (ref), t5 (copy), v55 (ref), n5 (ref), t6 (copy), t7 (copy), v57 (ref)
    local v94 = v26 and v52 ~= nil and v52:GetAttribute("Arrived") == true and not LocalPlayer:GetAttribute("Cinematic") and LocalPlayer:GetAttribute("TurkeyRun") == nil

    if v94 then
        if v55 then
            return
        end

        if p10.UserInputType == Enum.UserInputType.Touch or p10.UserInputType == Enum.UserInputType.MouseButton1 then
            v55 = p10
            n5 = p10.Position.Y

            local v95 = t5[1]
            local v96

            if #t4 == 0 then
                v96 = 0
            else
                local v98 = math.clamp(v95, 0, v4 * (#t4 - 1)) / v4
                local v101 = math.clamp(math.floor(v98) + 1, 1, #t4 - 1)
                local v102 = v98 - (v101 - 1)

                v96 = t4[v101] + (t4[v101 + 1] - t4[v101]) * v102
            end

            t6[1] = v96
            t7[1] = 1
            v57 = false
        end
    end
end)
UserInputService.InputEnded:Connect(function(p11) -- line: 406
    -- upvalues: HarpoonDepth (copy), n2 (ref), t5 (copy), v53 (ref), n4 (ref), v55 (ref), TelemetryReport (copy), v57 (ref)
    if p11 ~= v55 then
        return
    end

    v55 = nil

    local elapsed = os.clock()

    v53 = t5[1]
    n4 = elapsed
    HarpoonDepth:FireServer(t5[1])

    if not v57 then
        return
    end

    TelemetryReport:FireServer("depth", "drag", t5[1], n2)
end)
UserInputService.InputBegan:Connect(function(p12, p13) -- line: 414
    -- upvalues: t1 (copy), t2 (copy), LocalPlayer (copy), HarpoonDepth (copy), v24 (copy), v26 (ref), v27 (ref), v38 (ref), DepthTipDone (copy), v52 (ref), t5 (copy), v53 (ref), n4 (ref), setTarget (copy)
    local v108 = p12.KeyCode == Enum.KeyCode.DPadUp or p12.KeyCode == Enum.KeyCode.DPadDown
    local v109 = t2[p12.KeyCode]

    if not (v108 or v109 and not p13) then
        return
    end

    local v110 = v26 and v52 ~= nil and v52:GetAttribute("Arrived") == true and not LocalPlayer:GetAttribute("Cinematic") and LocalPlayer:GetAttribute("TurkeyRun") == nil

    if not v110 then
        return
    end

    if v108 then
        v109 = if p12.KeyCode == Enum.KeyCode.DPadDown then 1 else -1
    end

    t1.dir = v109

    local KeyCode = p12.KeyCode
    local v111 = if v108 then "pad" else "keys"

    t1.key = KeyCode
    t1.by = v111
    t1.heldAt = os.clock()
    setTarget(t5[1] + t1.dir * 0.04 * v24)

    local elapsed = os.clock()

    if not (elapsed - n4 < 0.06666666666666667) and t5[1] ~= v53 then
        v53 = t5[1]
        n4 = elapsed
        HarpoonDepth:FireServer(t5[1])
    end

    if v38 or LocalPlayer:GetAttribute("DepthTip") ~= true then
        return
    end

    v38 = true
    DepthTipDone:FireServer()
    v27()
end)
UserInputService.InputEnded:Connect(function(p14) -- line: 426
    -- upvalues: t1 (copy), t2 (copy), LocalPlayer (copy), HarpoonDepth (copy), v26 (ref), v52 (ref), n2 (ref), t5 (copy), v53 (ref), n4 (ref), TelemetryReport (copy)
    if p14.KeyCode ~= Enum.KeyCode.DPadUp and p14.KeyCode ~= Enum.KeyCode.DPadDown and not t2[p14.KeyCode] then
        return
    end

    local v113, v114

    if t1.dir == 0 then
        v114 = true
    elseif p14.KeyCode == t1.key then
        t1.dir = 0
        v113 = v26

        if v113 then
            v113 = v52 ~= nil and v52:GetAttribute("Arrived") == true and not LocalPlayer:GetAttribute("Cinematic") and LocalPlayer:GetAttribute("TurkeyRun") == nil
        end

        v114 = false
    else
        v114 = true
    end

    if not v114 and v113 then
        local elapsed = os.clock()

        v53 = t5[1]
        n4 = elapsed
        HarpoonDepth:FireServer(t5[1])
        TelemetryReport:FireServer("depth", t1.by or "pad", t5[1], n2)
    end
end)

local function questTipWanted() -- line: 450
    -- upvalues: LocalPlayer (copy), v52 (ref), n2 (ref), t5 (copy), DepthBands (copy), Zones (copy)
    local QuestHuntZones = LocalPlayer:GetAttribute("QuestHuntZones")

    if type(QuestHuntZones) ~= "string" then
        return false
    end

    local v119 = v52
    local v120

    if v119 and v52.Parent then
        local SurfaceY = v52:GetAttribute("SurfaceY")

        if type(SurfaceY) == "number" then
            v120 = math.max(0, SurfaceY - v52:GetPivot().Position.Y)
        end
    end

    local v125 = math.clamp(math.floor((v120 or t5[1]) / Zones.DEPTH) + 1, 1, #Zones.NAMES)
    local MaxDepth = v52 and v52:GetAttribute("MaxDepth") or n2
    local v126 = false

    for match in QuestHuntZones:gmatch("%d+") do
        local v127 = tonumber(match)

        if v127 == v125 then
            return false
        end

        if DepthBands.Band(v127) <= MaxDepth then
            v126 = true
        end
    end

    return v126
end

RunService.RenderStepped:Connect(function(p15) -- line: 464
    -- upvalues: t1 (copy), LocalPlayer (copy), Head (copy), Marker (copy), HarpoonDepth (copy), t4 (copy), v4 (copy), v11 (copy), v12 (copy), v24 (copy), v26 (ref), v27 (ref), v37 (ref), v38 (ref), v40 (ref), dressTip (copy), showTip (copy), drawTip (copy), v52 (ref), t5 (copy), v53 (ref), n4 (ref), v55 (ref), v56 (ref), setTarget (copy), questTipWanted (copy)
    if not v26 then
        return
    end

    if t1.dir ~= 0 then
        local v128 = v26 and v52 ~= nil and v52:GetAttribute("Arrived") == true and not LocalPlayer:GetAttribute("Cinematic") and LocalPlayer:GetAttribute("TurkeyRun") == nil

        if v128 and os.clock() - t1.heldAt > t1.HOLD then
            setTarget(t5[1] + t1.dir * t1.RATE * v24 * math.min(p15, 0.05))

            local elapsed = os.clock()

            if not (elapsed - n4 < 0.06666666666666667) and t5[1] ~= v53 then
                v53 = t5[1]
                n4 = elapsed
                HarpoonDepth:FireServer(t5[1])
            end
        end
    end

    local v130 = LocalPlayer:GetAttribute("DepthTip") == true and not v38
    local v131 = not v130 and questTipWanted()
    local v132 = v131

    if v130 or v131 then
        v132 = v26

        if v132 then
            v132 = v52 ~= nil and v52:GetAttribute("Arrived") == true and not LocalPlayer:GetAttribute("Cinematic") and LocalPlayer:GetAttribute("TurkeyRun") == nil
        end
    end

    if v131 ~= v40 then
        v40 = v131

        if v37 then
            dressTip()
        end
    end

    if not v132 or v37 then
        if v37 and not v132 then
            v27()
        end
    else
        showTip()
    end

    if v37 then
        drawTip()
    end

    local v133 = v52
    local v134

    if v133 and v52.Parent then
        local SurfaceY = v52:GetAttribute("SurfaceY")

        if type(SurfaceY) == "number" then
            v134 = math.max(0, SurfaceY - v52:GetPivot().Position.Y)
        end
    end

    if not v134 then
        return
    end

    if v56 then
        if v55 ~= nil then
            return
        end

        local v136 = v56
        local DepthGoal = v52:GetAttribute("DepthGoal")
        local PoseDy = v52:GetAttribute("PoseDy")
        local v137 = if type(DepthGoal) == "number" then math.abs(DepthGoal + v136) < 0.01 or type(PoseDy) == "number" and math.abs(PoseDy + v136) < 0.01 else type(PoseDy) == "number" and math.abs(PoseDy + v136) < 0.01

        if not v137 then
            if os.clock() - n4 >= 0.2 then
                local elapsed = os.clock()

                v53 = t5[1]
                n4 = elapsed
                HarpoonDepth:FireServer(t5[1])
            end

            return
        end

        if not (math.abs(v134 - v56) < 0.5) then
            return
        end

        v56 = nil
        v52:SetAttribute("DepthGoalLocal", nil)
    end

    if math.abs(v134 - t5[1]) > 0.01 then
        t5[1] = v134

        local v144

        if #t4 == 0 then
            v144 = 0
        else
            local v146 = math.clamp(v134, 0, v4 * (#t4 - 1)) / v4
            local v149 = math.clamp(math.floor(v146) + 1, 1, #t4 - 1)
            local v150 = v146 - (v149 - 1)

            v144 = t4[v149] + (t4[v149 + 1] - t4[v149]) * v150
        end

        Marker.Position = UDim2.fromScale(Marker.Position.X.Scale, v144)

        local fromScale = UDim2.fromScale
        local Scale = Head.Position.X.Scale
        local v151

        if #t4 < 2 then
            v151 = v11
        else
            local v152 = (v144 - t4[1]) / (t4[#t4] - t4[1])

            v151 = v11 + (v12 - v11) * math.clamp(v152, 0, 1)
        end

        Head.Position = fromScale(Scale, v151)
    end
end)

local connection

HarpoonEnter.OnClientEvent:Connect(function(p16) -- line: 509
    -- upvalues: LocalPlayer (copy), show (copy), v52 (ref), n2 (ref), n3 (ref), t5 (copy), v53 (ref), v54 (ref), v55 (ref), v56 (ref), connection (ref)
    if LocalPlayer:GetAttribute("TitanRiding") then
        return
    end

    v52 = p16
    n2 = p16 and p16:GetAttribute("MaxDepth") or 0
    n3 = p16 and p16:GetAttribute("MinDepth") or 0
    t5[1] = 0
    v54 = false
    v53 = nil
    v55 = nil
    v56 = nil

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if p16 then
        connection = p16:GetAttributeChangedSignal("MaxDepth"):Connect(function() -- line: 519
            -- upvalues: p16 (copy), v52 (ref), n2 (ref), n3 (ref), v55 (ref), v56 (ref)
            if v52 ~= p16 then
                return
            end

            n2 = p16:GetAttribute("MaxDepth") or n2
            n3 = p16:GetAttribute("MinDepth") or n3

            if v56 then
                p16:SetAttribute("DepthGoalLocal", nil)
            end

            v55 = nil
            v56 = nil
        end)
    end

    show()
end)
HarpoonExit.OnClientEvent:Connect(function() -- line: 529
    -- upvalues: t1 (copy), hide (copy), v52 (ref), v55 (ref), v56 (ref)
    if v52 then
        v52:SetAttribute("DepthGoalLocal", nil)
    end

    v52 = nil
    v55 = nil
    v56 = nil
    t1.dir = 0
    hide()
end)
LocalPlayer:GetAttributeChangedSignal("TitanRiding"):Connect(function() -- line: 538
    -- upvalues: t1 (copy), LocalPlayer (copy), hide (copy), v52 (ref), v55 (ref), v56 (ref)
    if not LocalPlayer:GetAttribute("TitanRiding") then
        return
    end

    if v52 then
        v52:SetAttribute("DepthGoalLocal", nil)
    end

    v52 = nil
    v55 = nil
    v56 = nil
    t1.dir = 0
    hide()
end)
LocalPlayer:GetAttributeChangedSignal("Cinematic"):Connect(function() -- line: 548
    -- upvalues: t1 (copy), LocalPlayer (copy), v52 (ref), v55 (ref), v56 (ref)
    if not LocalPlayer:GetAttribute("Cinematic") then
        return
    end

    if v52 and v56 then
        v52:SetAttribute("DepthGoalLocal", nil)
    end

    v55 = nil
    v56 = nil
    t1.dir = 0
end)
DepthGui.Enabled = false
