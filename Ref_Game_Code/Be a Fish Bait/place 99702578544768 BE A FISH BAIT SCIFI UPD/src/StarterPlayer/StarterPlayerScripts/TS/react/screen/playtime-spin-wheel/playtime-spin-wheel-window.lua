-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo, useRef, useState = react.useEffect, react.useMemo, react.useRef, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Debris, Players, ReplicatedStorage, RunService = services.Debris, services.Players, services.ReplicatedStorage, services.RunService
local SoundService, TweenService = services.SoundService, services.TweenService
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local useGlowPulse = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-glow-pulse").useGlowPulse
local useFreePurchaseModeEnabled = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-free-purchase-mode").useFreePurchaseModeEnabled
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "money-fly-atom")
local moneyHudFrozenAtom, pushMoneyBurst = v1.moneyHudFrozenAtom, v1.pushMoneyBurst
local showPlaytimeSpinWheelRewardReveal = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "playtime-spin-wheel-reward-atom").showPlaytimeSpinWheelRewardReveal
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local usePlaytimeSpinWheelSegments = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-playtime-spin-wheel-segments").usePlaytimeSpinWheelSegments
local useSpinWheelMotion = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-spin-wheel-motion").useSpinWheelMotion
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local fishDataByName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").fishDataByName
local getAquariumSkinData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins").getAquariumSkinData
local getTitleData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").getTitleData
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-spin-wheel-config")
local getTimeSkipMinutes, playtimeSpinWheelAssets, playtimeSpinWheelSfxIds = v2.getTimeSkipMinutes, v2.playtimeSpinWheelAssets, v2.playtimeSpinWheelSfxIds
local v3 = RuntimeLib.import(script, script.Parent, "playtime-spin-wheel-face")
local default5, getSliceIndexUnderPointer = v3.default, v3.getSliceIndexUnderPointer
local t1 = {
    "SpinWheel_Open",
    "SpinWheel_ButtonClick",
    "SpinWheel_Start",
    "SpinWheel_Tick",
    "SpinWheel_SpinLoop",
    "SpinWheel_Land",
    "SpinWheel_LandRare",
    "SpinWheel_RewardPop",
    "SpinWheel_NoSpins",
    "SpinWheel_Close"
}
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
})
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 70, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 30, 170))
})
local v6 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 165, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 107, 0))
})
local v7 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(239, 213, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(209, 153, 0))
})
local v8 = Color3.fromRGB(33, 33, 33)
local v9 = Color3.fromRGB(255, 230, 80)

local function playSound(p1, p2) -- line: 53
    local v10 = p1[p2]

    if not v10 then
        return nil
    end

    v10:Play()
end

local function stopSound(p3, p4) -- line: 62
    local v11 = p3[p4]

    if not v11 then
        return nil
    end

    v11:Stop()
end

local function named(p5) -- line: 71
    return function(p6) -- line: 72
        -- upvalues: p5 (copy)
        if p6 then
            p6.Name = p5
        end
    end
end

local function getPointerTickSoundTemplate(p7) -- line: 78
    -- upvalues: ReplicatedStorage (copy), SoundService (copy)
    local Sounds = ReplicatedStorage:FindFirstChild("Sounds")
    local v12 = if Sounds == nil then Sounds else Sounds:FindFirstChild("SFX")
    local v13 = if v12 ~= nil then v12 elseif Sounds == nil then Sounds else Sounds:FindFirstChild("sfx")

    if v13 ~= nil then
        v13 = v13:FindFirstChild(p7)
    end

    local v14

    if v13 ~= nil then
        v14 = v13
    else
        local v15 = if Sounds == nil then Sounds else Sounds:FindFirstChild(p7, true)

        v14 = if v15 ~= nil then v15 else ReplicatedStorage:FindFirstChild(p7, true) or SoundService:FindFirstChild(p7, true)
    end

    if if v14 == nil then v14 else v14:IsA("Sound") then
        if v14.SoundId == "" then
            warn((("[PlaytimeSpinWheel] Tick SFX \"%*\" exists, but its SoundId is empty"):format(p7)))
        end

        return v14
    end

    warn((("[PlaytimeSpinWheel] Missing tick SFX Sound named \"%*\" under ReplicatedStorage.Sounds.SFX or ReplicatedStorage.Sounds.sfx"):format(p7)))

    return nil
end

local function getPointerTickSoundParent() -- line: 122
    -- upvalues: Players (copy), SoundService (copy)
    return Players.LocalPlayer:FindFirstChildOfClass("PlayerGui") or SoundService
end

local function playPointerTickSound(p8) -- line: 125
    -- upvalues: Debris (copy), Players (copy), SoundService (copy)
    if not (if p8 == nil then p8 else p8:IsA("Sound")) then
        return nil
    end

    local clone = p8:Clone()

    clone.TimePosition = 0
    clone.Looped = false
    clone.Volume = math.max(p8.Volume, 0.65)
    clone.Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui") or SoundService

    local connection

    connection = clone.Ended:Connect(function() -- line: 139
        -- upvalues: clone (copy), connection (ref)
        connection:Disconnect()
        clone:Destroy()
    end)
    clone:Play()
    Debris:AddItem(clone, (math.max(3, clone.TimeLength + 1)))
end

local function WheelSfx(p9) -- line: 146
    -- upvalues: react (copy), useEffect (copy), useRef (copy), playtimeSpinWheelSfxIds (copy), t1 (copy)
    local v17 = useRef({})

    useEffect(function() -- line: 148
        -- upvalues: p9 (copy), v17 (copy)
        p9.onReady(v17.current)
    end, {})

    local v18 = table.create(#t1)

    local function v19(p10) -- line: 153
        -- upvalues: v17 (copy), react (copy), playtimeSpinWheelSfxIds (copy)
        return react.createElement("sound", {
            Volume = p10 == "SpinWheel_SpinLoop" and 0.35 or 0.75,
            key = p10,
            ref = function(p11) -- ref | line: 157
                -- upvalues: p10 (copy), v17 (copy), playtimeSpinWheelSfxIds (copy)
                if not p11 then
                    return nil
                end

                p11.Name = p10
                p11.SoundId = playtimeSpinWheelSfxIds[p10]
                p11.Looped = p10 == "SpinWheel_SpinLoop"
                v17.current[p10] = p11
            end
        })
    end

    for v20, v21 in t1 do
        v18[v20] = v19(v21, v20 - 1, t1)
    end

    return react.createElement("folder", {
        key = "SpinWheelSfx",
        ref = function(p12) -- ref | line: 177
            if p12 then
                p12.Name = "SpinWheelSfx"
            end
        end
    }, v18)
end

local function ChunkyLabel(p13) -- line: 184
    -- upvalues: react (copy), default3 (copy)
    local t3 = {
        color = p13.color or Color3.fromRGB(255, 255, 255)
    }
    local t4 = {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Font = Enum.Font.FredokaOne,
        Position = p13.position,
        Size = p13.size,
        TextScaled = p13.fontSize == nil,
        TextSize = p13.fontSize
    }
    local textWrapped = p13.textWrapped

    t4.TextWrapped = textWrapped == nil or textWrapped
    t4.ZIndex = p13.zIndex
    t3.overrideProps = t4
    t3.shadowYScale = 0.08
    t3.strokeProps = {
        Thickness = 0.15,
        Color = Color3.fromRGB(0, 0, 0),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }
    t3.text = p13.text

    return react.createElement(default3, t3)
end

local function getRewardScreenIcon(p14) -- line: 213
    -- upvalues: getAquariumSkinData (copy), playtimeSpinWheelAssets (copy)
    if p14.reward.kind == "title" then
        return playtimeSpinWheelAssets.CashIcon
    end

    if p14.reward.kind == "aquariumSkin" then
        local v22 = getAquariumSkinData(p14.reward.skinName)

        if v22 ~= nil then
            v22 = v22.imageId
        end

        if v22 == nil then
            v22 = playtimeSpinWheelAssets.CashIcon
        end

        return v22
    end

    if p14.rarity == "legendary" then
        return playtimeSpinWheelAssets.LegendaryMysteryIcon
    end

    if p14.rarity == "mythic" then
        return playtimeSpinWheelAssets.MythicMysteryIcon
    end

    if p14.rarity == "godly" then
        return playtimeSpinWheelAssets.GodlyMysteryIcon
    end

    if p14.reward.kind == "timeSkip" then
        return playtimeSpinWheelAssets.TimeSkipIcon
    end

    return playtimeSpinWheelAssets.CashIcon
end

local function getRewardScreenText(p15) -- line: 242
    -- upvalues: abbreviate (copy), fishDataByName (copy), getAquariumSkinData (copy), getTitleData (copy), getTimeSkipMinutes (copy)
    if p15.fishName == nil then
        if p15.cashAmount == nil or p15.replacementTimeSkipSeconds == nil then
            if p15.cashAmount ~= nil then
                return (("+%* CASH"):format((abbreviate(p15.cashAmount))))
            end

            if p15.titleId == nil then
                if p15.skinName == nil then
                    return "REWARD"
                end

                local v23 = getAquariumSkinData(p15.skinName)

                if v23 ~= nil then
                    v23 = v23.displayName
                end

                if v23 == nil then
                    v23 = p15.skinName
                end

                return (("%* Aquarium"):format(v23))
            end

            local v24 = getTitleData(p15.titleId)

            if v24 ~= nil then
                v24 = v24.displayName
            end

            if v24 == nil then
                v24 = p15.titleId
            end

            return v24
        end

        local v25 = getTimeSkipMinutes(p15.replacementTimeSkipSeconds)

        if v25 == nil then
            return (("+%* CASH"):format((abbreviate(p15.cashAmount))))
        end

        return (("%* MIN TIME SKIP"):format(v25))
    end

    local v26 = fishDataByName[p15.fishName]

    if v26 ~= nil then
        v26 = v26.displayName
    end

    if v26 == nil then
        v26 = p15.fishName
    end

    return v26
end

local function getRewardScreenTimeSkipReward(p16) -- line: 287
    -- upvalues: getTimeSkipMinutes (copy)
    if p16.cashAmount == nil then
        return nil
    end

    local replacementTimeSkipSeconds = p16.replacementTimeSkipSeconds

    if replacementTimeSkipSeconds == nil then
        replacementTimeSkipSeconds = if p16.segment.reward.kind == "timeSkip" then p16.segment.reward.seconds else nil
    end

    if replacementTimeSkipSeconds == nil then
        return nil
    end

    local v27 = getTimeSkipMinutes(replacementTimeSkipSeconds)

    return if v27 ~= nil then {
        cashAmount = p16.cashAmount,
        minutes = v27
    } else nil
end

local function getRewardScreenTitleReward(p17) -- line: 308
    -- upvalues: getTitleData (copy)
    if p17.titleId == nil then
        return nil
    end

    local v28 = getTitleData(p17.titleId)
    local t5 = {}
    local v29 = if v28 == nil then v28 else v28.animatedColor

    if v29 ~= nil then
        t5.color = v29
    else
        local v30 = if v28 == nil then v28 else v28.color

        t5.color = if v30 == nil then Color3.fromRGB(255, 255, 255) else v30
    end

    if v28 ~= nil then
        v28 = v28.displayName
    end

    t5.displayName = if v28 == nil then p17.titleId else v28

    return t5
end

local function SpinButton(p18) -- line: 343
    -- upvalues: react (copy), useMotion (copy), useGlowPulse (copy), default2 (copy), v8 (copy), v9 (copy), ChunkyLabel (copy)
    local v31, v32 = useMotion(1)
    local v33 = useGlowPulse():map(function(p19) -- line: 346
        -- upvalues: v8 (copy), v9 (copy)
        return v8:Lerp(v9, p19)
    end)
    local v34 = if p18.size.Y.Offset > 0 then p18.size.X.Offset / p18.size.Y.Offset else 1
    local v35 = if p18.bottomLabel == nil or not (#p18.bottomLabel >= 5) then 0.5 else 0.78

    local function v36() -- line: 351
        -- upvalues: v32 (copy)
        v32:tween(0.9, {
            time = 0.08,
            style = Enum.EasingStyle.Back
        })
        task.delay(0.08, function() -- line: 356
            -- upvalues: v32 (copy)
            return v32:spring(1, {
                damping = 0.58,
                frequency = 0.24
            })
        end)
    end

    local t6 = {
        BackgroundTransparency = 1
    }
    local yOffset = p18.yOffset

    if yOffset == nil then
        yOffset = 0
    end

    t6.Position = UDim2.fromOffset(0, yOffset)
    t6.Size = p18.size

    local name = p18.name

    t6.ref = function(p20) -- line: 72
        -- upvalues: name (copy)
        if p20 then
            p20.Name = name
        end
    end

    return react.createElement("frame", t6, react.createElement("uiaspectratioconstraint", {
        AspectRatio = v34,
        AspectType = Enum.AspectType.FitWithinMaxSize,
        DominantAxis = Enum.DominantAxis.Width
    }), react.createElement("uiscale", {
        Scale = v31
    }), react.createElement(default2, {
        cornerRadius = 0.1,
        isStudded = true,
        zIndex = 50,
        anchorPoint = Vector2.new(0, 0),
        color = p18.color,
        frameSize = UDim2.fromScale(1, 1),
        label = p18.label,
        onClick = function() -- onClick | line: 386
            -- upvalues: p18 (copy), v36 (copy)
            if p18.disabled then
                v36()

                return nil
            end

            p18.onClick()
        end,
        popoutColor = p18.popoutColor,
        position = UDim2.fromScale(0, 0),
        strokeColor = if not p18.hasGlow then nil else v33
    }), p18.bottomLabel ~= nil and react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 56,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.9),
        Size = UDim2.fromScale(v35, 0.34)
    }, react.createElement(ChunkyLabel, {
        textWrapped = false,
        zIndex = 56,
        color = p18.color,
        fontSize = p18.size.X.Offset <= 120 and 14 or 24,
        position = UDim2.fromScale(0.5, 0.4),
        size = UDim2.fromScale(1, 1),
        text = p18.bottomLabel
    })))
end

local function CloseButton(p21) -- line: 414
    -- upvalues: react (copy), default (copy), ChunkyLabel (copy)
    local createElement = react.createElement
    local t10 = {
        BackgroundTransparency = 1,
        ZIndex = 60,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.9, p21.isMd and 0.1 or 0.1),
        Size = if p21.isMd then UDim2.fromOffset(54, 54) else UDim2.fromOffset(66, 66)
    }
    local v41 = "CloseButton"

    t10.ref = function(p22) -- line: 72
        -- upvalues: v41 (copy)
        if p22 then
            p22.Name = v41
        end
    end

    return createElement("frame", t10, react.createElement(default, {
        cornerRadius = 0.18,
        strokeThickness = 0.09,
        zIndex = 60,
        backgroundColor = ColorSequence.new({
            ColorSequenceKeypoint.new(0, if p21.disabled then Color3.fromRGB(148, 64, 64) else Color3.fromRGB(255, 85, 95)),
            ColorSequenceKeypoint.new(1, if p21.disabled then Color3.fromRGB(97, 30, 30) else Color3.fromRGB(196, 0, 23))
        }),
        onClick = function() -- onClick | line: 425
            -- upvalues: p21 (copy)
            if not p21.disabled then
                p21.onClick()
            end
        end,
        size = UDim2.fromScale(1, 1),
        strokeColor = Color3.fromRGB(0, 0, 0)
    }, react.createElement(ChunkyLabel, {
        text = "X",
        zIndex = 64,
        position = UDim2.fromScale(0.5, 0.48),
        size = UDim2.fromScale(0.7, 0.72)
    })))
end

return {
    default = function(p23) -- PlaytimeSpinWheelWindow | line: 441
        -- upvalues: react (copy), useEffect (copy), useMemo (copy), useRef (copy), useState (copy), RunService (copy), TweenService (copy), useMotion (copy), useFreePurchaseModeEnabled (copy), moneyHudFrozenAtom (copy), pushMoneyBurst (copy), showPlaytimeSpinWheelRewardReveal (copy), default4 (copy), useScreenSizeState (copy), useSound (copy), usePlaytimeSpinWheelSegments (copy), useSpinWheelMotion (copy), default5 (copy), getSliceIndexUnderPointer (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), getPointerTickSoundTemplate (copy), playPointerTickSound (copy), WheelSfx (copy), ChunkyLabel (copy), getRewardScreenIcon (copy), getRewardScreenText (copy), getRewardScreenTimeSkipReward (copy), getRewardScreenTitleReward (copy), SpinButton (copy), CloseButton (copy)
        local v42 = useScreenSizeState()
        local v43 = v42 == "sm" or v42 == "md"
        local playSound = useSound("SkillCheckSuccess").playSound
        local v44 = useFreePurchaseModeEnabled()
        local v45 = usePlaytimeSpinWheelSegments()
        local v46 = p23.segmentsOverride or v45
        local v47, v48 = useState(v46)
        local v49, v50 = useState(false)
        local v51, v52 = useState(nil)
        local v53, v54 = useState(false)
        local v55, v56 = useState({})
        local v57, v58 = useState(0)
        local v59 = useMemo(function() -- line: 455
            return Instance.new("NumberValue")
        end, {})
        local v60, v61 = useMotion(1)
        local v62, v63 = useMotion(0.92)
        local v64 = useSpinWheelMotion(1.2)
        local wheelScale, wheelScaleMotion, pointerScale, pointerRotation = v64.wheelScale, v64.wheelScaleMotion, v64.pointerScale, v64.pointerRotation
        local pointerRotationMotion = v64.pointerRotationMotion
        local v65, v66 = useMotion(0)
        local v67 = useRef(1)
        local v68 = useRef(0)
        local v69 = useRef(1)
        local v70 = useRef(0)
        local v71 = useRef(false)
        local v72 = useRef(false)
        local v73 = useRef(true)
        local v74 = useRef(nil)
        local v75 = useRef(nil)
        local v76 = if v43 then UDim2.fromScale(0.92, 0.92) else UDim2.fromScale(0.55, 0.9)
        local v77 = if v43 then UDim2.fromScale(0.85, 0.72) else UDim2.fromScale(0.82, 0.78)
        local v78 = if v43 then 0.38 else 0.41
        local v79 = if v43 then 0.77 else 0.78
        local v80 = UDim2.new(0.95, 0, 0, if v43 then 70 else 108)
        local v81 = if v49 then "SPINNING" else ("SPIN (%*)"):format(p23.spinCount)
        local v82 = v51 ~= nil and v51.segment.rarity ~= "common"

        useEffect(function() -- line: 483
            -- upvalues: v46 (copy), v48 (copy), v49 (copy), v51 (copy)
            if v49 or v51 ~= nil then
                return nil
            end

            v48(v46)
        end, { v49, v46, v51 })

        local function v83(p24) -- line: 504
            -- upvalues: showPlaytimeSpinWheelRewardReveal (copy), getRewardScreenIcon (copy), getRewardScreenText (copy), getRewardScreenTimeSkipReward (copy), getRewardScreenTitleReward (copy)
            showPlaytimeSpinWheelRewardReveal({
                cashAmount = p24.cashAmount,
                iconImage = getRewardScreenIcon(p24.segment),
                rewardText = getRewardScreenText(p24),
                showIcon = p24.titleId == nil,
                timeSkipReward = getRewardScreenTimeSkipReward(p24),
                title = p24.segment.rarity == "common" and "YOU WON!" or "RARE REWARD!",
                titleReward = getRewardScreenTitleReward(p24)
            })
        end

        local function v84(p25) -- line: 515
            -- upvalues: pointerRotationMotion (copy), v67 (copy)
            v67.current *= -1

            local v85 = if p25 < 0.35 then 14 elseif p25 < 0.68 then 9 else 5

            pointerRotationMotion:tween(v67.current * v85, {
                time = p25 < 0.68 and 0.045 or 0.065,
                style = Enum.EasingStyle.Quad,
                direction = Enum.EasingDirection.Out
            })
            task.delay(p25 < 0.68 and 0.045 or 0.065, function() -- line: 523
                -- upvalues: p25 (copy), pointerRotationMotion (copy)
                pointerRotationMotion:tween(0, {
                    time = p25 < 0.68 and 0.12 or 0.17,
                    style = Enum.EasingStyle.Back,
                    direction = Enum.EasingDirection.Out
                })
            end)
        end

        useEffect(function() -- line: 531
            -- upvalues: v55 (copy), v61 (copy), v63 (copy)
            v61:tween(0.38, {
                time = 0.18,
                style = Enum.EasingStyle.Quad
            })
            v63:spring(1, {
                damping = 0.7,
                frequency = 0.18
            })

            local SpinWheel_Open = v55.SpinWheel_Open

            if SpinWheel_Open then
                SpinWheel_Open:Play()
            end
        end, { v55 })
        useEffect(function() -- line: 542
            -- upvalues: v71 (copy), v72 (copy), v73 (copy), v75 (copy), v83 (copy), moneyHudFrozenAtom (copy)
            v73.current = true

            return function() -- line: 544
                -- upvalues: v71 (copy), v72 (copy), v73 (copy), v75 (copy), v83 (copy), moneyHudFrozenAtom (copy)
                v73.current = false

                if v72.current and v75.current ~= nil then
                    v83(v75.current)

                    return nil
                end

                if v71.current and not v72.current then
                    v71.current = false
                    moneyHudFrozenAtom(false)
                end
            end
        end, {})
        useEffect(function() -- line: 556
            -- upvalues: v57 (copy), v58 (copy), v59 (copy)
            v59.Value = v57

            local connection = v59.Changed:Connect(function(p26) -- line: 558
                -- upvalues: v58 (copy)
                v58(p26)
            end)

            return function() -- line: 562
                -- upvalues: connection (copy), v59 (copy)
                connection:Disconnect()
                v59:Destroy()
            end
        end, {})
        useEffect(function() -- line: 567
            -- upvalues: v49 (copy), v59 (copy), RunService (copy)
            if v49 then
                return nil
            end

            local connection = RunService.Heartbeat:Connect(function(p27) -- line: 571
                -- upvalues: v59 (copy)
                v59.Value += 12 * p27
            end)

            return function() -- line: 574
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v49 })
        useEffect(function() -- line: 578
            -- upvalues: v49 (copy), v59 (copy), pointerRotationMotion (copy), v68 (copy), v69 (copy), v70 (copy), v84 (copy), RunService (copy), getSliceIndexUnderPointer (copy), getPointerTickSoundTemplate (copy), playPointerTickSound (copy)
            if not v49 then
                return nil
            end

            local v87 = getSliceIndexUnderPointer(v59.Value)
            local connection = RunService.RenderStepped:Connect(function() -- line: 583
                -- upvalues: v87 (ref), v59 (copy), v68 (copy), v69 (copy), v70 (copy), v84 (copy), getSliceIndexUnderPointer (copy), getPointerTickSoundTemplate (copy), playPointerTickSound (copy)
                local v88 = getSliceIndexUnderPointer(v59.Value)

                if v88 == v87 then
                    return nil
                end

                v87 = v88

                local elapsed = os.clock()

                if elapsed - v70.current < 0.035 then
                    return nil
                end

                v70.current = elapsed

                local v90 = math.clamp((elapsed - v68.current) / v69.current, 0, 1)

                playPointerTickSound((getPointerTickSoundTemplate(v90 >= 0.68 and "Wheel Spin 18 (SFX)" or "Wheel Spin 22 (SFX)")))
                v84(v90)
            end)

            return function() -- line: 599
                -- upvalues: connection (copy), pointerRotationMotion (copy)
                connection:Disconnect()
                pointerRotationMotion:tween(0, {
                    time = 0.08,
                    style = Enum.EasingStyle.Quad
                })
            end
        end, { v49 })

        local function v92() -- line: 607
            -- upvalues: p23 (copy), v49 (copy), v55 (copy), v61 (copy), v63 (copy)
            if v49 then
                return nil
            end

            local SpinWheel_Close = v55.SpinWheel_Close

            if SpinWheel_Close then
                SpinWheel_Close:Play()
            end

            v61:tween(1, {
                time = 0.12,
                style = Enum.EasingStyle.Quad
            })
            v63:tween(0.94, {
                time = 0.12,
                style = Enum.EasingStyle.Quad
            })
            task.delay(0.13, p23.onClose)
        end

        local function v93() -- line: 622
            -- upvalues: v54 (copy), v55 (copy), v66 (copy)
            local SpinWheel_NoSpins = v55.SpinWheel_NoSpins

            if SpinWheel_NoSpins then
                SpinWheel_NoSpins:Play()
            end

            v54(true)
            v66:tween(-12, {
                time = 0.05
            })
            task.delay(0.05, function() -- line: 628
                -- upvalues: v66 (copy)
                return v66:tween(12, {
                    time = 0.08
                })
            end)
            task.delay(0.13, function() -- line: 633
                -- upvalues: v66 (copy)
                return v66:tween(0, {
                    time = 0.08
                })
            end)
            task.delay(1, function() -- line: 638
                -- upvalues: v54 (copy)
                return v54(false)
            end)
        end

        local function v94() -- line: 642
            -- upvalues: p23 (copy), v49 (copy), v50 (copy), v52 (copy), v55 (copy), v58 (copy), v59 (copy), wheelScaleMotion (copy), pointerRotationMotion (copy), v66 (copy), v68 (copy), v69 (copy), v70 (copy), v71 (copy), v72 (copy), v73 (copy), v74 (copy), v75 (copy), v83 (copy), v93 (copy), TweenService (copy), moneyHudFrozenAtom (copy)
            if v49 then
                return nil
            end

            if p23.spinCount <= 0 then
                v93()

                return nil
            end

            local SpinWheel_ButtonClick = v55.SpinWheel_ButtonClick

            if SpinWheel_ButtonClick then
                SpinWheel_ButtonClick:Play()
            end

            local SpinWheel_Start = v55.SpinWheel_Start

            if SpinWheel_Start then
                SpinWheel_Start:Play()
            end

            local SpinWheel_SpinLoop = v55.SpinWheel_SpinLoop

            if SpinWheel_SpinLoop then
                SpinWheel_SpinLoop:Play()
            end

            v52(nil)
            v50(true)
            v75.current = nil
            v71.current = true
            moneyHudFrozenAtom(true)
            p23.onSpinRequested():andThen(function(p28) -- line: 658
                -- upvalues: v50 (copy), v52 (copy), v55 (copy), v58 (copy), v59 (copy), wheelScaleMotion (copy), pointerRotationMotion (copy), v66 (copy), v68 (copy), v69 (copy), v70 (copy), v71 (copy), v72 (copy), v73 (copy), v74 (copy), v75 (copy), v83 (copy), TweenService (copy), moneyHudFrozenAtom (copy)
                if p28 then
                    if p28.cashAmount ~= nil then
                        v72.current = true
                    elseif v71.current then
                        v71.current = false
                        v72.current = false
                        moneyHudFrozenAtom(false)
                    end

                    local segment = p28.segment
                    local v95 = 4.2 + math.random() * 1

                    if v73.current then
                        local Value = v59.Value
                        local v96 = (Value % 360 + 360) % 360
                        local v97 = ((-segment.centerAngle % 360 + 360) % 360 - v96 + 360) % 360
                        local v98 = Value + math.random(5, 8) * 360 + v97

                        v68.current = os.clock()
                        v69.current = v95
                        v70.current = 0
                        v74.current = task.delay(v95 + 0.1, function() -- line: 687
                            -- upvalues: p28 (copy), v73 (copy), v74 (copy), v83 (copy)
                            v74.current = nil

                            if not v73.current then
                                v83(p28)
                            end
                        end)

                        local v100 = TweenService:Create(v59, TweenInfo.new(v95, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Value = v98
                        })

                        wheelScaleMotion:tween(1.2539999999999998, {
                            time = 0.16,
                            style = Enum.EasingStyle.Back
                        })
                        v100:Play()
                        v100.Completed:Once(function() -- line: 701
                            -- upvalues: p28 (copy), segment (copy), v98 (copy), v50 (copy), v52 (copy), v55 (copy), v58 (copy), wheelScaleMotion (copy), pointerRotationMotion (copy), v66 (copy), v73 (copy), v74 (copy), v75 (copy), v83 (copy)
                            if v74.current ~= nil then
                                task.cancel(v74.current)
                                v74.current = nil
                            end

                            if not v73.current then
                                v83(p28)

                                return nil
                            end

                            local SpinWheel_SpinLoop = v55.SpinWheel_SpinLoop

                            if SpinWheel_SpinLoop then
                                SpinWheel_SpinLoop:Stop()
                            end

                            local v102 = v55[if segment.rarity == "common" then "SpinWheel_Land" else "SpinWheel_LandRare"]

                            if v102 then
                                v102:Play()
                            end

                            local SpinWheel_RewardPop = v55.SpinWheel_RewardPop

                            if SpinWheel_RewardPop then
                                SpinWheel_RewardPop:Play()
                            end

                            v58(v98)
                            v75.current = p28
                            v52(p28)
                            v50(false)
                            pointerRotationMotion:tween(0, {
                                time = 0.08,
                                style = Enum.EasingStyle.Quad
                            })
                            wheelScaleMotion:spring(1.2, {
                                damping = 0.65,
                                frequency = 0.2
                            })
                            v66:tween(-8, {
                                time = 0.04
                            })
                            task.delay(0.04, function() -- line: 728
                                -- upvalues: v66 (copy)
                                return v66:tween(8, {
                                    time = 0.06
                                })
                            end)
                            task.delay(0.1, function() -- line: 733
                                -- upvalues: v66 (copy)
                                return v66:tween(0, {
                                    time = 0.08
                                })
                            end)
                        end)

                        return
                    end

                    v74.current = task.delay(v95, function() -- line: 673
                        -- upvalues: p28 (copy), v74 (copy), v83 (copy)
                        v74.current = nil
                        v83(p28)
                    end)
                else
                    local SpinWheel_SpinLoop = v55.SpinWheel_SpinLoop

                    if SpinWheel_SpinLoop then
                        SpinWheel_SpinLoop:Stop()
                    end

                    v50(false)

                    if v71.current then
                        v71.current = false
                        v72.current = false
                        moneyHudFrozenAtom(false)
                    end
                end

                return nil
            end):catch(function() -- line: 739
                -- upvalues: v50 (copy), v55 (copy), v71 (copy), v72 (copy), moneyHudFrozenAtom (copy)
                local SpinWheel_SpinLoop = v55.SpinWheel_SpinLoop

                if SpinWheel_SpinLoop then
                    SpinWheel_SpinLoop:Stop()
                end

                v50(false)

                if v71.current then
                    v71.current = false
                    v72.current = false
                    moneyHudFrozenAtom(false)
                end
            end)
        end

        local function v103() -- line: 745
            -- upvalues: playSound (copy), v51 (copy), v71 (copy), v72 (copy), moneyHudFrozenAtom (copy), pushMoneyBurst (copy)
            playSound()

            local v104 = v51

            if v51 ~= nil then
                v104 = v51.cashAmount
            end

            if v71.current then
                v71.current = false
                v72.current = false
                moneyHudFrozenAtom(false)

                if v104 ~= nil and v104 > 0 then
                    pushMoneyBurst(v104)
                end
            end
        end

        local function v105() -- line: 753
            -- upvalues: p23 (copy), v49 (copy), v55 (copy)
            if v49 then
                return nil
            end

            local SpinWheel_ButtonClick = v55.SpinWheel_ButtonClick

            if SpinWheel_ButtonClick then
                SpinWheel_ButtonClick:Play()
            end

            p23.onBuyOneSpinRequested()
        end

        local function v106() -- line: 761
            -- upvalues: p23 (copy), v49 (copy), v55 (copy)
            if v49 then
                return nil
            end

            local SpinWheel_ButtonClick = v55.SpinWheel_ButtonClick

            if SpinWheel_ButtonClick then
                SpinWheel_ButtonClick:Play()
            end

            p23.onBuyFiveSpinsRequested()
        end

        local createElement = react.createElement
        local t15 = {
            BackgroundTransparency = 1,
            ZIndex = 1,
            Size = UDim2.fromScale(1, 1)
        }
        local v107 = react.createElement(WheelSfx, {
            onReady = v56
        })
        local v108 = react.createElement
        local t16 = {
            BorderSizePixel = 0,
            ZIndex = 1,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = v60,
            Size = UDim2.fromScale(1, 1)
        }
        local v109 = "Overlay"

        t16.ref = function(p29) -- line: 72
            -- upvalues: v109 (copy)
            if p29 then
                p29.Name = v109
            end
        end

        v108 = v108("frame", t16)

        local createElement2 = react.createElement
        local t17 = {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = v65:map(function(p30) -- line: 785
                return UDim2.new(0.5, p30, 0.56, 0)
            end),
            Size = v76
        }
        local v110 = "ModalRoot"

        t17.ref = function(p31) -- line: 72
            -- upvalues: v110 (copy)
            if p31 then
                p31.Name = v110
            end
        end

        local v111 = react.createElement("uiscale", {
            Scale = v62
        })
        local v112 = react.createElement(default5, {
            isSmall = v43,
            pointerRotation = pointerRotation,
            pointerScale = pointerScale,
            position = UDim2.fromScale(0.5, v78),
            rotation = v57,
            segments = v47,
            size = v77,
            totalMps = p23.totalMps,
            wheelScale = wheelScale
        })
        local v113 = not v49 and react.createElement(CloseButton, {
            disabled = false,
            isMd = v43,
            onClick = v92
        })
        local createElement3 = react.createElement
        local t18 = {
            BackgroundTransparency = 1,
            ZIndex = 45,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, v79),
            Size = v80
        }
        local v114 = "BottomButtonRow"

        t18.ref = function(p32) -- line: 72
            -- upvalues: v114 (copy)
            if p32 then
                p32.Name = v114
            end
        end

        local v115 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, v43 and 8 or 14),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v117 = react.createElement
        local v118 = {
            label = "+1 SPIN",
            name = "BuyOneSpinButton",
            bottomLabel = v44 and "FREE" or "R$10",
            color = v6,
            disabled = v49,
            onClick = v105,
            popoutColor = Color3.fromRGB(115, 41, 0)
        }

        if v43 then
            v118.size = UDim2.fromOffset(114, 51)
        else
            v118.size = UDim2.fromOffset(170, 68)
        end

        v117 = v117(SpinButton, v118)

        local v116 = react.createElement(SpinButton, {
            name = "SpinButton",
            color = if p23.spinCount > 0 then v4 else v7,
            disabled = v49,
            hasGlow = p23.spinCount > 0,
            label = v81,
            onClick = v94,
            popoutColor = if p23.spinCount > 0 then Color3.fromRGB(10, 120, 10) else Color3.fromRGB(150, 110, 0),
            size = if v43 then UDim2.fromOffset(142, 56) else UDim2.fromOffset(210, 76)
        })

        createElement2 = createElement2("frame", t17, v111, v112, v113, createElement3("frame", t18, v115, v117, v116, react.createElement(SpinButton, {
            label = "+5 SPINS",
            name = "BuyFiveSpinButton",
            bottomLabel = v44 and "FREE" or "R$39",
            color = v5,
            disabled = v49,
            onClick = v106,
            popoutColor = Color3.fromRGB(80, 20, 130),
            size = if v43 then UDim2.fromOffset(114, 51) else UDim2.fromOffset(170, 68)
        })), v53 and react.createElement(ChunkyLabel, {
            text = "NO SPINS AVAILABLE",
            zIndex = 75,
            color = Color3.fromRGB(255, 72, 72),
            position = UDim2.fromScale(0.5, 0.84),
            size = UDim2.fromScale(0.7, 0.07)
        }), false)

        return createElement("frame", t15, v107, v108, createElement2, v51 ~= nil and react.createElement(default4, {
            zIndex = 200,
            iconImage = getRewardScreenIcon(v51.segment),
            onFinished = function() -- onFinished | line: 864
                -- upvalues: v52 (copy)
                return v52(nil)
            end,
            onReveal = v103,
            rewardText = getRewardScreenText(v51),
            showIcon = v51.titleId == nil,
            timeSkipReward = getRewardScreenTimeSkipReward(v51),
            title = v82 and "RARE REWARD!" or "YOU WON!",
            titleReward = getRewardScreenTitleReward(v51),
            uiScale = v43 and 0.78 or 1
        }))
    end
}
