-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Parent = script.Parent
local ProgressBar = Parent:WaitForChild("ProgressBar")
local ProgressBar2 = ProgressBar:WaitForChild("ProgressBar")
local RingScoreLabel = Parent:WaitForChild("RingScoreHolder"):WaitForChild("RingScoreHolder"):WaitForChild("RingScoreLabel")
local v1 = Color3.fromRGB(85, 85, 85)
local v2 = Color3.fromRGB(71, 255, 0)
local v3 = UDim2.fromScale(1.03563285, 1.58552635)
local v4 = UDim2.fromScale(-0.470256448, 1.16447556)
local v5 = UDim2.fromScale(1.13319373, 1.7348907)
local v6 = UDim2.fromScale(-0.519036949, 1.16447568)
local v7 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local v8 = TweenInfo.new(0.34, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v9 = TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v10 = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local t1 = {
    {
        name = "Milestone1",
        value = 50
    },
    {
        name = "Milestone2",
        value = 150
    },
    {
        name = "Milestone3",
        value = 300
    }
}
local value = t1[#t1].value
local t2 = {}
local n1 = 0
local v11 = true

local function cancelTweens(p1) -- line: 64
    for v12, v13 in pairs(p1.tweens) do
        v13:Cancel()
        p1.tweens[v12] = nil
    end
end

local function play(p2, p3, p4, p5, p6) -- line: 72
    -- upvalues: TweenService (copy)
    local v14 = p2.tweens[p3]

    if v14 then
        v14:Cancel()
    end

    local tween = TweenService:Create(p4, p5, p6)

    p2.tweens[p3] = tween
    tween:Play()

    return tween
end

local function build() -- line: 83
    -- upvalues: ProgressBar (copy), t1 (copy), t2 (copy)
    for v15, v16 in ipairs(t1) do
        local v17 = ProgressBar:FindFirstChild(v16.name)

        if v17 then
            local ClaimButton = v17:FindFirstChild("ClaimButton")
            local ClaimedOverlay = ClaimButton and ClaimButton:FindFirstChild("ClaimedOverlay")

            t2[v15] = {
                state = nil,
                fillPoint = 0,
                value = v16.value,
                frame = v17,
                baseSize = v17.Size,
                button = ClaimButton,
                overlay = ClaimedOverlay,
                checkmark = ClaimedOverlay and ClaimedOverlay:FindFirstChild("CompletedCheckmark"),
                checkSize = ClaimedOverlay and ClaimedOverlay:FindFirstChild("CompletedCheckmark") and ClaimedOverlay.CompletedCheckmark.Size or nil,
                unlockedDecor = v17:FindFirstChild("UnlockedDecor"),
                lockedDecor = v17:FindFirstChild("NotUnlockedDecor"),
                tweens = {}
            }
        end
    end
end

local function measureFillPoints() -- line: 113
    -- upvalues: ProgressBar (copy), t2 (copy)
    local Y = ProgressBar.AbsolutePosition.Y
    local Y2 = ProgressBar.AbsoluteSize.Y

    if Y2 <= 0 then
        return false
    end

    for _, v18 in pairs(t2) do
        local frame = v18.frame

        v18.fillPoint = math.clamp((frame.AbsolutePosition.Y + frame.AbsoluteSize.Y * 0.5 - Y) / Y2, 0, 1)
    end

    return true
end

local function fillScaleFor(p7) -- line: 129
    -- upvalues: t2 (copy)
    local n2 = 0
    local n3 = 0

    for _, v20 in ipairs(t2) do
        if p7 <= v20.value then
            local v21 = v20.value - n2
            local v22 = v21 > 0 and (p7 - n2) / v21 or 1

            return n3 + (v20.fillPoint - n3) * v22
        end

        n2 = v20.value
        n3 = v20.fillPoint
    end

    return n3
end

local function setDecor(p8, p9) -- line: 144
    if p8.unlockedDecor then
        p8.unlockedDecor.Visible = p9
    end

    if p8.lockedDecor then
        p8.lockedDecor.Visible = not p9
    end
end

local function punch(p10) -- line: 153
    -- upvalues: TweenService (copy), v8 (copy)
    local baseSize = p10.baseSize

    p10.frame.Size = UDim2.new(baseSize.X.Scale, baseSize.X.Offset + 12, baseSize.Y.Scale, baseSize.Y.Offset + 8)

    local frame = p10.frame
    local t4 = {
        Size = baseSize
    }
    local punch = p10.tweens.punch

    if punch then
        punch:Cancel()
    end

    local tween = TweenService:Create(frame, v8, t4)

    p10.tweens.punch = tween
    tween:Play()
end

local function setState(p11, p12, p13) -- line: 163
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v9 (copy), v10 (copy), punch (copy)
    if p11.state == p12 then
        return
    end

    p11.state = p12

    for v23, v24 in pairs(p11.tweens) do
        v24:Cancel()
        p11.tweens[v23] = nil
    end

    local v25 = p12 ~= "Locked"
    local button, overlay, checkmark = p11.button, p11.overlay, p11.checkmark

    if p11.unlockedDecor then
        p11.unlockedDecor.Visible = v25
    end

    if p11.lockedDecor then
        p11.lockedDecor.Visible = not v25
    end

    p11.frame.Size = p11.baseSize

    if p13 then
        local frame = p11.frame
        local t5 = {
            BackgroundColor3 = v25 and v2 or v1
        }
        local bg = p11.tweens.bg

        if bg then
            bg:Cancel()
        end

        local tween = TweenService:Create(frame, v7, t5)

        p11.tweens.bg = tween
        tween:Play()
    else
        local frame = p11.frame
        local v26 = if v25 then v2 else nil

        frame.BackgroundColor3 = if not v25 or not v26 then v1 else v26
    end

    if button then
        button.Image = v25 and "rbxassetid://73951419137281" or "rbxassetid://111037630886814"

        local v27 = if v25 then v4 else nil

        button.Position = if not v25 or not v27 then v6 else v27

        local v28 = if v25 then v3 else nil

        button.Size = if not v25 or not v28 then v5 else v28
    end

    if overlay then
        overlay.Visible = p12 == "Claimed"
    end

    if p12 == "Locked" then
        if p13 then
            punch(p11)
        end
    elseif p12 == "Ready" then
        if p13 then
            punch(p11)
        end

        if button then
            button.Size = v3

            local t6 = {
                Size = UDim2.fromScale(v3.X.Scale * 1.07, v3.Y.Scale * 1.07)
            }
            local pulse = p11.tweens.pulse

            if pulse then
                pulse:Cancel()
            end

            local tween = TweenService:Create(button, v10, t6)

            p11.tweens.pulse = tween
            tween:Play()
        end
    elseif overlay then
        if p13 then
            overlay.ImageTransparency = 1

            local t7 = {
                ImageTransparency = 0.64
            }
            local overlay2 = p11.tweens.overlay

            if overlay2 then
                overlay2:Cancel()
            end

            local tween = TweenService:Create(overlay, v7, t7)

            p11.tweens.overlay = tween
            tween:Play()

            if checkmark then
                checkmark.ImageTransparency = 1
                checkmark.Size = UDim2.fromScale(p11.checkSize.X.Scale * 0.2, p11.checkSize.Y.Scale * 0.2)

                local t8 = {
                    ImageTransparency = 0,
                    Size = p11.checkSize
                }
                local check = p11.tweens.check

                if check then
                    check:Cancel()
                end

                local tween = TweenService:Create(checkmark, v9, t8)

                p11.tweens.check = tween
                tween:Play()
            end

            punch(p11)
        else
            overlay.ImageTransparency = 0.64

            if checkmark then
                checkmark.ImageTransparency = 0
                checkmark.Size = p11.checkSize
            end
        end
    end
end

local n4 = 0

local function applyValue(p14) -- line: 255
    -- upvalues: ProgressBar2 (copy), RingScoreLabel (copy), t2 (copy), fillScaleFor (copy), setState (copy), n4 (ref)
    n4 = p14
    ProgressBar2.Size = UDim2.new(1, 0, fillScaleFor(p14), 0)
    RingScoreLabel.Text = string.format("%d", p14 // 1)

    for _, v29 in ipairs(t2) do
        if v29.state == "Locked" and v29.value <= p14 then
            setState(v29, "Ready", true)
        end
    end
end

local function rampTo(p15, p16, p17) -- line: 269
    -- upvalues: RunService (copy), TweenService (copy), n1 (ref), n4 (ref), applyValue (copy)
    local v30 = n4
    local v31 = p16 - v30

    if v31 == 0 or p17 <= 0 then
        applyValue(p16)
    else
        local n5 = 0
        local thread = coroutine.running()
        local connection

        connection = RunService.Heartbeat:Connect(function(p18) -- line: 280
            -- upvalues: p15 (copy), p17 (copy), v30 (copy), v31 (copy), n5 (ref), thread (copy), connection (ref), TweenService (copy), n1 (ref), applyValue (copy)
            if p15 ~= n1 then
                connection:Disconnect()
                task.spawn(thread)

                return
            end

            n5 += p18

            local v33 = math.min(n5 / p17, 1)

            applyValue(v30 + v31 * TweenService:GetValue(v33, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))

            if v33 >= 1 then
                connection:Disconnect()
                task.spawn(thread)
            end
        end)
        coroutine.yield()
    end
end

local function resetAll() -- line: 300
    -- upvalues: v1 (copy), v5 (copy), v6 (copy), t2 (copy), applyValue (copy)
    for _, v34 in ipairs(t2) do
        v34.state = nil

        if v34.state ~= "Locked" then
            v34.state = "Locked"

            for v35, v36 in pairs(v34.tweens) do
                v36:Cancel()
                v34.tweens[v35] = nil
            end

            local button, overlay, _ = v34.button, v34.overlay, v34.checkmark

            if v34.unlockedDecor then
                v34.unlockedDecor.Visible = false
            end

            if v34.lockedDecor then
                v34.lockedDecor.Visible = true
            end

            v34.frame.Size = v34.baseSize
            v34.frame.BackgroundColor3 = v1

            if button then
                button.Image = "rbxassetid://111037630886814"
                button.Position = v6
                button.Size = v5
            end

            if overlay then
                overlay.Visible = false
            end
        end
    end

    applyValue(0)
end

local function stale(p19) -- line: 310
    -- upvalues: n1 (ref), v11 (ref)
    return not v11 or p19 ~= n1
end

local function pause(p20, p21) -- line: 315
    -- upvalues: n1 (ref), v11 (ref)
    task.wait(p21)

    return not (not v11 or p20 ~= n1)
end

local function runShowcase() -- line: 320
    -- upvalues: t1 (copy), value (copy), t2 (copy), n1 (ref), v11 (ref), setState (copy), rampTo (copy), resetAll (copy)
    n1 += 1

    local v37 = n1

    while true do
        if v11 and v37 == n1 then
            resetAll()
            task.wait(0.6)

            if not v11 or v37 ~= n1 then
                break
            end

            rampTo(v37, t1[1].value, 1.1)

            if v11 and v37 == n1 then
                task.wait(0.9)

                if v11 and v37 == n1 then
                    setState(t2[1], "Claimed", true)
                    task.wait(0.7)

                    if v11 and v37 == n1 then
                        rampTo(v37, t1[2].value, 1.5)

                        if v11 and v37 == n1 then
                            task.wait(2.4)

                            if v11 and v37 == n1 then
                                rampTo(v37, value * 0.78, 1.2)

                                if v11 and v37 == n1 then
                                    task.wait(1.8)

                                    if v11 and v37 == n1 then
                                        continue
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        return
    end
end

local function cleanup() -- line: 349
    -- upvalues: t2 (copy), n1 (ref), v11 (ref)
    v11 = false
    n1 += 1

    for _, v38 in ipairs(t2) do
        for v39, v40 in pairs(v38.tweens) do
            v40:Cancel()
            v38.tweens[v39] = nil
        end
    end
end

script.Destroying:Once(cleanup)
build()
task.spawn(function() -- line: 361
    -- upvalues: RunService (copy), v11 (ref), measureFillPoints (copy), runShowcase (copy)
    for _ = 1, 120 do
        if not v11 then
            return
        end

        if measureFillPoints() then
            runShowcase()

            return
        end

        RunService.Heartbeat:Wait()
    end

    warn("[MilestoneShowcase] ProgressBar never resolved a non-zero height.")
end)
