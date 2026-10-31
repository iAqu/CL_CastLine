-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState, useEffect, useRef = react.useState, react.useEffect, react.useRef
local useBinding = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useBinding
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useScaleBounce = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-scale-bounce").useScaleBounce
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local getTextSize = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "responsive-utils").getTextSize
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = RuntimeLib.import(script, script.Parent, "stats-utils")
local moneyGradient, powerGradient, rebirthGradient = v1.moneyGradient, v1.powerGradient, v1.rebirthGradient
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootSelector, useRootProducer = reflex.useRootSelector, reflex.useRootProducer
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-button").default
local selectPlayerRebirthCount = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerRebirthCount
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local powerValueHiddenAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "fishing-phase-atom").powerValueHiddenAtom
local utilizedPowerFractionAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utilized-power-atom").utilizedPowerFractionAtom
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "training-boost-atom")
local trainingSkillcheckHitCounterAtom, latestTrainingPowerFlyIdAtom, frenzyEndTimeAtom = v2.trainingSkillcheckHitCounterAtom, v2.latestTrainingPowerFlyIdAtom, v2.frenzyEndTimeAtom
local v3 = RuntimeLib.import(script, script.Parent.Parent, "training-skillcheck", "training-skillcheck.config")
local trainingDoubledGradient, defaultTrainingTuning = v3.trainingDoubledGradient, v3.defaultTrainingTuning
local v4 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "money-fly-atom")
local moneyHudFrozenAtom, moneyFlyBurstAtom, pendingMoneyAtom, removeMoneyBurst = v4.moneyHudFrozenAtom, v4.moneyFlyBurstAtom, v4.pendingMoneyAtom, v4.removeMoneyBurst
local n1 = 0

local function MoneyFeedbackItem(p1) -- line: 47
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), default (copy), abbreviate (copy)
    local amount, onRemove, textSize = p1.amount, p1.onRemove, p1.textSize
    local v5, v6 = useMotion(0)
    local v7, v8 = useMotion(1)

    useEffect(function() -- line: 53
        -- upvalues: onRemove (copy), v6 (copy), v8 (copy)
        v8:tween(1.12, {
            time = 0.075,
            style = Enum.EasingStyle.Quad,
            direction = Enum.EasingDirection.Out
        })

        local v9 = task.delay(0.075, function() -- line: 61
            -- upvalues: v8 (copy)
            v8:tween(1, {
                time = 0.175,
                style = Enum.EasingStyle.Quad,
                direction = Enum.EasingDirection.Out
            })
        end)
        local v10 = task.delay(2.5, function() -- line: 68
            -- upvalues: v6 (copy)
            v6:tween(1, {
                time = 0.5,
                style = Enum.EasingStyle.Linear,
                direction = Enum.EasingDirection.Out
            })
        end)
        local v11 = task.delay(3, function() -- line: 75
            -- upvalues: onRemove (copy)
            onRemove()
        end)

        return function() -- line: 78
            -- upvalues: v9 (copy), v10 (copy), v11 (copy)
            task.cancel(v9)
            task.cancel(v10)
            task.cancel(v11)
        end
    end, {})

    local v12 = ("%*%*$"):format(if amount >= 0 then "+" else "-", (abbreviate((math.abs(amount)))))

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiscale", {
        Scale = v7
    }), react.createElement(default, {
        color = Color3.fromRGB(100, 255, 100),
        overrideProps = {
            BackgroundTransparency = 1,
            TextXAlignment = "Left",
            ZIndex = 7,
            Size = UDim2.fromScale(1, 1),
            TextSize = textSize,
            TextTransparency = v5
        },
        strokeProps = {
            Transparency = v5
        },
        text = v12
    }))
end

local v13 = UDim2.fromScale(0.083, 0.62)

local function PowerFlyItem(p2) -- line: 112
    -- upvalues: Flamework (copy), react (copy), useState (copy), useEffect (copy), useRef (copy), subscribe (copy), useMotion (copy), default (copy), abbreviate (copy), images (copy), powerGradient (copy), trainingSkillcheckHitCounterAtom (copy), latestTrainingPowerFlyIdAtom (copy), frenzyEndTimeAtom (copy), trainingDoubledGradient (copy), defaultTrainingTuning (copy), v13 (copy)
    local amount, id, isFrenzy, onArrive = p2.amount, p2.id, p2.isFrenzy, p2.onArrive
    local onIntercepted, onRemove = p2.onIntercepted, p2.onRemove
    local v14 = id ~= nil
    local v15 = useState(function() -- line: 120
        -- upvalues: isFrenzy (copy), v14 (copy)
        if not v14 then
            return UDim2.fromScale(0.3 + math.random() * 0.4, 0.3 + math.random() * 0.4)
        end

        local v16 = if math.random() < 0.5 then 0.3 + math.random() * 0.15 else 0.55 + math.random() * 0.15
        local v17 = if isFrenzy then if math.random() < 0.5 then 0.25 + math.random() * 0.14 else 0.6 + math.random() * 0.14 elseif math.random() < 0.5 then 0.3 + math.random() * 0.15 else 0.55 + math.random() * 0.15

        return UDim2.fromScale(v16, v17)
    end)
    local v18 = useState(function() -- line: 133
        return math.random(-20, 20)
    end)
    local v20, v21 = useState(if isFrenzy then amount * 2 else amount)
    local v22, v23 = useState(isFrenzy == true)
    local v24, v25 = useMotion(v15)
    local v26, v27 = useMotion(0)
    local v28, v29 = useMotion(0)
    local v30 = if v14 then 0.6 else 0.5
    local v31 = useRef(true)
    local v32 = useRef(false)
    local v33 = useRef(nil)
    local v34 = useRef(nil)
    local v35 = useRef(onArrive)
    local v36 = useRef(onRemove)
    local v37 = useRef(onIntercepted)

    v35.current = onArrive
    v36.current = onRemove
    v37.current = onIntercepted

    local function v38() -- line: 154
        -- upvalues: v25 (copy), v27 (copy), v31 (copy), v35 (copy), v36 (copy), v13 (copy)
        v25:tween(v13, {
            time = 0.4,
            style = Enum.EasingStyle.Quad,
            direction = Enum.EasingDirection.In
        })
        task.delay(0.15000000000000002, function() -- line: 160
            -- upvalues: v27 (copy), v31 (copy)
            if not v31.current then
                return nil
            end

            v27:tween(1, {
                time = 0.25,
                style = Enum.EasingStyle.Linear
            })
        end)
        task.delay(0.4, function() -- line: 169
            -- upvalues: v31 (copy), v35 (copy)
            if not v31.current then
                return nil
            end

            v35.current()
        end)
        task.delay(0.45, function() -- line: 175
            -- upvalues: v31 (copy), v36 (copy)
            if not v31.current then
                return nil
            end

            v36.current()
        end)
    end

    local function v39() -- line: 182
        -- upvalues: amount (copy), v15 (copy), v21 (copy), v23 (copy), v25 (copy), v27 (copy), v29 (copy), v31 (copy), v32 (copy), v33 (copy), v37 (copy), v38 (copy)
        if v32.current then
            return nil
        end

        v32.current = true

        if v33.current ~= nil then
            task.cancel(v33.current)
            v33.current = nil
        end

        local current = v37.current

        if current ~= nil then
            current(amount)
        end

        v25:tween(v15, {
            time = 0.15,
            style = Enum.EasingStyle.Quad,
            direction = Enum.EasingDirection.In
        })
        v27:tween(1, {
            time = 0.12,
            style = Enum.EasingStyle.Linear
        })
        task.delay(0.22, function() -- line: 204
            -- upvalues: amount (copy), v21 (copy), v23 (copy), v31 (copy)
            if not v31.current then
                return nil
            end

            v21(amount * 2)
            v23(true)
        end)
        task.delay(0.14, function() -- line: 211
            -- upvalues: v27 (copy), v29 (copy), v31 (copy)
            if not v31.current then
                return nil
            end

            v27:tween(0, {
                time = 0.18,
                style = Enum.EasingStyle.Quad,
                direction = Enum.EasingDirection.Out
            })
            v29:set(0.7)
            v29:tween(1.5, {
                time = 0.15,
                style = Enum.EasingStyle.Back,
                direction = Enum.EasingDirection.Out
            })
            task.delay(0.15, function() -- line: 226
                -- upvalues: v29 (copy), v31 (copy)
                if not v31.current then
                    return nil
                end

                v29:tween(1.2, {
                    time = 0.2,
                    style = Enum.EasingStyle.Quad,
                    direction = Enum.EasingDirection.Out
                })
            end)
        end)
        task.delay(0.85, function() -- line: 237
            -- upvalues: v31 (copy), v38 (copy)
            if not v31.current then
                return nil
            end

            v38()
        end)
    end

    useEffect(function() -- line: 245
        -- upvalues: id (copy), isFrenzy (copy), onArrive (copy), onRemove (copy), v14 (copy), v25 (copy), v27 (copy), v29 (copy), v31 (copy), v32 (copy), v33 (copy), v34 (copy), v38 (copy), v39 (copy), v30 (copy), Flamework (copy), subscribe (copy), trainingSkillcheckHitCounterAtom (copy), latestTrainingPowerFlyIdAtom (copy), frenzyEndTimeAtom (copy), defaultTrainingTuning (copy), v13 (copy)
        v31.current = true
        v29:tween(1, {
            time = 0.2,
            style = Enum.EasingStyle.Back,
            direction = Enum.EasingDirection.Out
        })

        if v14 then
            if isFrenzy then
                local v40 = Flamework.resolveDependency("client/controllers/sound-controller@SoundController")
                local t1 = {
                    fn = function() -- fn | line: 257
                    end
                }

                t1.fn = function() -- line: 259
                    -- upvalues: v40 (copy), t1 (copy), v31 (copy), v34 (copy), frenzyEndTimeAtom (copy), defaultTrainingTuning (copy)
                    if not v31.current then
                        return nil
                    end

                    if frenzyEndTimeAtom() - os.clock() > defaultTrainingTuning.frenzyStopSoundLeadSeconds then
                        v40:playSoundPolyphonic("PopSound", 1, defaultTrainingTuning.popSoundVolume)
                        v40:playSoundPolyphonic("ThockyKeyboard", 1, 10, defaultTrainingTuning.thockyKeyboardStartTime)
                    end

                    v34.current = task.delay(0.3, function() -- line: 268
                        -- upvalues: t1 (copy)
                        return t1.fn()
                    end)
                end

                t1.fn()
                v33.current = task.delay(v30, function() -- line: 273
                    -- upvalues: v33 (copy), v38 (copy)
                    v33.current = nil
                    v38()
                end)

                return function() -- line: 331
                    -- upvalues: v31 (copy), v33 (copy), v34 (copy)
                    v31.current = false

                    if v33.current ~= nil then
                        task.cancel(v33.current)
                    end

                    if v34.current ~= nil then
                        task.cancel(v34.current)
                    end
                end
            end

            local v41 = subscribe(trainingSkillcheckHitCounterAtom, function() -- line: 278
                -- upvalues: id (copy), v31 (copy), v32 (copy), v39 (copy), latestTrainingPowerFlyIdAtom (copy)
                if not v31.current or v32.current or latestTrainingPowerFlyIdAtom() ~= id then
                    return nil
                end

                v39()
            end)

            v33.current = task.delay(v30, function() -- line: 290
                -- upvalues: v32 (copy), v33 (copy), v38 (copy)
                v33.current = nil

                if not v32.current then
                    v38()
                end
            end)

            return function() -- line: 296
                -- upvalues: v41 (copy), v31 (copy), v33 (copy)
                v31.current = false
                v41()

                if v33.current ~= nil then
                    task.cancel(v33.current)
                end
            end
        end

        local v42 = task.delay(v30, function() -- line: 305
            -- upvalues: v25 (copy), v13 (copy)
            v25:tween(v13, {
                time = 0.4,
                style = Enum.EasingStyle.Quad,
                direction = Enum.EasingDirection.In
            })
        end)
        local v43 = task.delay(v30 + 0.4 - 0.25, function() -- line: 312
            -- upvalues: v27 (copy)
            v27:tween(1, {
                time = 0.25,
                style = Enum.EasingStyle.Linear
            })
        end)
        local v44 = task.delay(v30 + 0.4, function() -- line: 318
            -- upvalues: onArrive (copy)
            onArrive()
        end)
        local v45 = task.delay(v30 + 0.4 + 0.05, function() -- line: 321
            -- upvalues: onRemove (copy)
            onRemove()
        end)

        return function() -- line: 324
            -- upvalues: v42 (copy), v43 (copy), v44 (copy), v45 (copy)
            task.cancel(v42)
            task.cancel(v43)
            task.cancel(v44)
            task.cancel(v45)
        end
    end, {})

    local v48 = math.clamp(math.log(math.max(v20, 1), 10) * 0.2 + 1, 1, 2.5)
    local v49 = if v22 then "doubled" else "normal"

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = v24,
        Rotation = v18,
        Size = UDim2.fromScale(v48 * 0.105, v48 * 0.048)
    }, react.createElement("uiscale", {
        Scale = v28
    }), react.createElement("uilistlayout", {
        FillDirection = "Horizontal",
        HorizontalAlignment = "Left",
        VerticalAlignment = "Center",
        Padding = UDim.new(0.035, 0)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        Image = images.strongArmIcon,
        ImageTransparency = v26,
        Size = UDim2.fromScale(0.18, 0.9)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement(default, {
        color = if v22 then trainingDoubledGradient else powerGradient,
        key = v49,
        overrideProps = {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 10,
            TextXAlignment = "Left",
            Size = UDim2.fromScale(0.77, 1),
            TextTransparency = v26
        },
        strokeProps = {
            Transparency = v26
        },
        text = ("+%* Power"):format((abbreviate(v20)))
    }))
end

local function StatDisplayPlusButton(p3) -- line: 386
    -- upvalues: react (copy), images (copy), default3 (copy)
    local color, layoutOrder, onClick = p3.color, p3.layoutOrder, p3.onClick

    return react.createElement(default3, {
        cornerRadius = 0.25,
        strokeThickness = 0.05,
        zIndex = 6,
        anchorPoint = Vector2.new(0.5, 0.5),
        backgroundColor = color,
        layoutOrder = layoutOrder,
        onClick = onClick,
        position = UDim2.fromScale(0.5, 0.6),
        size = UDim2.fromScale(0.7, 0.7),
        strokeColor = Color3.new(0, 0, 0)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 8,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.plusIcon,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.6, 0.6)
    }))
end

return {
    PowerFlyItem = PowerFlyItem,
    default = function(p4) -- StatDisplay | line: 413
        -- upvalues: react (copy), useState (copy), useEffect (copy), useRef (copy), useBinding (copy), RunService (copy), subscribe (copy), default (copy), default2 (copy), useScaleBounce (copy), useScreenSizeState (copy), getTextSize (copy), abbreviate (copy), images (copy), moneyGradient (copy), powerGradient (copy), rebirthGradient (copy), useRootSelector (copy), useRootProducer (copy), default3 (copy), selectPlayerRebirthCount (copy), localPlayerUserId (copy), powerValueHiddenAtom (copy), utilizedPowerFractionAtom (copy), moneyHudFrozenAtom (copy), moneyFlyBurstAtom (copy), pendingMoneyAtom (copy), removeMoneyBurst (copy), n1 (ref), MoneyFeedbackItem (copy), StatDisplayPlusButton (copy)
        local money, power, onPowerAdded, powerBounceTrigger = p4.money, p4.power, p4.onPowerAdded, p4.powerBounceTrigger

        if powerBounceTrigger == nil then
            powerBounceTrigger = 0
        end

        local powerCap, variant = p4.powerCap, p4.variant

        if variant == nil then
            variant = "default"
        end

        local v53 = variant == "celebration"
        local v54 = useRootSelector(selectPlayerRebirthCount(localPlayerUserId))
        local v55 = useRootProducer()

        local function v56() -- line: 429
            -- upvalues: v55 (copy)
            return v55.windowToggled({
                currentWindow = "exclusiveShop"
            })
        end

        local function v57() -- line: 434
            -- upvalues: v55 (copy)
            return v55.windowToggled({
                currentWindow = "setPower"
            })
        end

        local v58 = useScreenSizeState()
        local v59, v60 = useState({})
        local v61, v62 = useState(0)
        local v63 = useRef(nil)
        local v64 = useRef(nil)
        local v65 = useScaleBounce(v61)
        local v66 = useScaleBounce(powerBounceTrigger)
        local v67, v68 = useBinding((("%*$"):format((abbreviate(money)))))
        local v69 = useRef(money)

        v69.current = money

        local v70 = useRef(nil)
        local v71 = useRef(money)

        useEffect(function() -- line: 451
            -- upvalues: v68 (copy), v69 (copy), v70 (copy), v71 (copy), RunService (copy), abbreviate (copy), moneyHudFrozenAtom (copy), pendingMoneyAtom (copy)
            local connection = RunService.Heartbeat:Connect(function() -- line: 452
                -- upvalues: v68 (copy), v69 (copy), v70 (copy), v71 (copy), abbreviate (copy), moneyHudFrozenAtom (copy), pendingMoneyAtom (copy)
                local v72 = pendingMoneyAtom()
                local v73 = moneyHudFrozenAtom()
                local v75 = math.max(0, v69.current - v72)

                if v73 then
                    v75 = v71.current
                elseif v72 > 0 then
                    v75 = math.max(v75, v71.current)
                end

                local current = v70.current

                if not current or v75 ~= current.to then
                    v70.current = {
                        from = v71.current,
                        to = v75,
                        startTime = os.clock()
                    }
                end

                local current2 = v70.current
                local v78 = 1 - math.pow(1 - math.min((os.clock() - current2.startTime) / 0.3, 1), 3)
                local v80 = math.floor(current2.from + (current2.to - current2.from) * v78)

                v71.current = v80
                v68((("%*$"):format((abbreviate(v80)))))
            end)

            return function() -- line: 474
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, {})

        local v81 = useRef({})

        useEffect(function() -- line: 479
            -- upvalues: v60 (copy), v62 (copy), v81 (copy), subscribe (copy), moneyFlyBurstAtom (copy), removeMoneyBurst (copy), n1 (ref)
            return subscribe(moneyFlyBurstAtom, function(p5) -- line: 480
                -- upvalues: v60 (copy), v62 (copy), v81 (copy), removeMoneyBurst (copy), n1 (ref)
                local v82 = false

                for _, v83 in p5 do
                    if v81.current[v83.id] == nil then
                        v81.current[v83.id] = true

                        local v84 = n1

                        n1 += 1
                        v60(function(p6) -- line: 492
                            -- upvalues: v83 (copy), v84 (copy)
                            local t4 = {}
                            local v85 = #t4
                            local v86 = #p6

                            table.move(p6, 1, v86, v85 + 1, t4)
                            t4[v85 + v86 + 1] = {
                                id = v84,
                                amount = v83.amount
                            }

                            return t4
                        end)
                        removeMoneyBurst(v83.id)
                        v82 = true
                        v81.current[v83.id] = nil
                    end
                end

                if v82 then
                    v62(function(p7) -- line: 512
                        return p7 + 1
                    end)
                end
            end)
        end, {})
        useEffect(function() -- line: 518
            -- upvalues: money (copy), v60 (copy), v62 (copy), v63 (copy), moneyHudFrozenAtom (copy), pendingMoneyAtom (copy), n1 (ref)
            if v63.current ~= nil and v63.current ~= money then
                local v87 = money - v63.current

                if v87 > 0 and pendingMoneyAtom() <= 0 and not moneyHudFrozenAtom() then
                    local v88 = n1

                    n1 += 1
                    v60(function(p8) -- line: 525
                        -- upvalues: v87 (copy), v88 (copy)
                        local t5 = {}
                        local v89 = #t5
                        local v90 = #p8

                        table.move(p8, 1, v90, v89 + 1, t5)
                        t5[v89 + v90 + 1] = {
                            id = v88,
                            amount = v87
                        }

                        return t5
                    end)
                    v62(function(p9) -- line: 537
                        return p9 + 1
                    end)
                elseif v87 < 0 then
                    local v91 = n1

                    n1 += 1
                    v60(function(p10) -- line: 544
                        -- upvalues: v87 (copy), v91 (copy)
                        local t6 = {}
                        local v92 = #t6
                        local v93 = #p10

                        table.move(p10, 1, v93, v92 + 1, t6)
                        t6[v92 + v93 + 1] = {
                            id = v91,
                            amount = v87
                        }

                        return t6
                    end)
                end
            end

            v63.current = money
        end, { money })
        useEffect(function() -- line: 560
            -- upvalues: power (copy), onPowerAdded (copy), v64 (copy)
            if v64.current ~= nil and v64.current ~= power then
                local v94 = power - v64.current

                if v94 > 0 and onPowerAdded ~= nil then
                    onPowerAdded(v94)
                end
            end

            v64.current = power
        end, { power })

        local function v95(p11) -- line: 572
            -- upvalues: v60 (copy)
            v60(function(p12) -- line: 573
                -- upvalues: p11 (copy)
                local t7 = {}
                local n2 = 0

                for v96, v97 in p12 do
                    local _ = v96 - 1

                    if v97.id ~= p11 == true then
                        n2 += 1
                        t7[n2] = v97
                    end
                end

                return t7
            end)
        end

        getTextSize(v58, "lg")

        local xmd = getTextSize(v58, "xmd")
        local v98 = xmd + 4
        local v99, v100 = useState(powerValueHiddenAtom())

        useEffect(function() -- line: 594
            -- upvalues: v100 (copy), subscribe (copy), powerValueHiddenAtom (copy)
            return subscribe(powerValueHiddenAtom, v100)
        end, {})

        local v101, v102 = useState(utilizedPowerFractionAtom())

        useEffect(function() -- line: 598
            -- upvalues: v102 (copy), subscribe (copy), utilizedPowerFractionAtom (copy)
            return subscribe(utilizedPowerFractionAtom, v102)
        end, {})

        local v103 = react.createElement("uilistlayout", {
            FillDirection = "Vertical",
            HorizontalAlignment = "Left",
            SortOrder = "LayoutOrder",
            VerticalAlignment = "Bottom"
        })
        local v104 = table.create(#v59)

        local function v105(p13, p14) -- line: 609
            -- upvalues: v95 (copy), xmd (copy), v98 (copy), react (copy), MoneyFeedbackItem (copy)
            return react.createElement("frame", {
                BackgroundTransparency = 1,
                LayoutOrder = p14,
                Size = UDim2.new(1, 0, 0, v98),
                key = tostring(p13.id)
            }, react.createElement(MoneyFeedbackItem, {
                amount = p13.amount,
                onRemove = function() -- onRemove | line: 617
                    -- upvalues: p13 (copy), v95 (copy)
                    return v95(p13.id)
                end,
                textSize = xmd
            }))
        end

        for v106, v107 in v59 do
            v104[v106] = v105(v107, v106 - 1, v59)
        end

        local createElement = react.createElement
        local t10 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.03, 0.65),
            Size = UDim2.fromScale(0.24, 0.24)
        }
        local v108 = react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.new(1, 0, 0, #v59 * v98)
        }, v103, v104)
        local createElement2 = react.createElement
        local t11 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1)
        }
        local v109 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top
        })
        local v110 = not v53

        if v110 then
            local createElement, Fragment = react.createElement, react.Fragment
            local v111 = react.createElement("frame", {
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Size = UDim2.fromScale(1, 0.22)
            }, react.createElement("uiscale", {
                Scale = v65
            }), react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Padding = UDim.new(0.03, 0),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }), react.createElement(default, {
                color = moneyGradient,
                overrideProps = {
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    TextXAlignment = "Left",
                    ZIndex = 6,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2.fromScale(0, 1)
                },
                text = v67
            }), react.createElement(StatDisplayPlusButton, {
                layoutOrder = 2,
                color = Color3.fromRGB(0, 208, 42),
                onClick = v56
            }))
            local createElement2 = react.createElement
            local t12 = {
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                Size = UDim2.fromScale(1, 0.22)
            }
            local v112 = react.createElement("uiscale", {
                Scale = v66
            })
            local v113 = react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Padding = UDim.new(0.03, 0),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            })
            local createElement3 = react.createElement
            local t13 = {
                color = powerGradient,
                overrideProps = {
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    TextXAlignment = "Left",
                    ZIndex = 6,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2.fromScale(0, 1),
                    TextTransparency = v99 and 1 or 0
                },
                strokeProps = {
                    Transparency = v99 and 1 or 0
                }
            }
            local v115 = math.floor(power * v101)

            t13.text = if power <= v115 then ("Power: %*"):format((abbreviate(power))) else ("Power: %* (%*)"):format(abbreviate(power), (abbreviate(v115)))
            v110 = createElement(Fragment, nil, v111, createElement2("frame", t12, v112, v113, createElement3(default, t13), react.createElement(default3, {
                cornerRadius = 0.25,
                layoutOrder = 2,
                strokeThickness = 0.05,
                zIndex = 6,
                anchorPoint = Vector2.new(0.5, 0.5),
                backgroundColor = Color3.fromRGB(200, 75, 0),
                onClick = v57,
                position = UDim2.fromScale(0.5, 0.6),
                size = UDim2.fromScale(0.7, 0.7),
                strokeColor = Color3.new(0, 0, 0)
            }, react.createElement("uiaspectratioconstraint", {
                AspectRatio = 1
            }), react.createElement("textlabel", {
                BackgroundTransparency = 1,
                Text = "✏️",
                TextScaled = true,
                ZIndex = 8,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBold,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.8, 0.8)
            }))), powerCap ~= nil and powerCap ~= 1e999 and powerCap <= power and react.createElement("frame", {
                BackgroundTransparency = 1,
                LayoutOrder = 3,
                ZIndex = 6,
                Size = UDim2.fromScale(0.95, 0.12)
            }, react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Padding = UDim.new(0.01, 0),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }), react.createElement("imagelabel", {
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                ZIndex = 7,
                Image = images.lockIcon,
                Size = UDim2.fromScale(1, 1)
            }, react.createElement("uiaspectratioconstraint", {
                AspectRatio = 1
            })), react.createElement(default2, {
                shadowYScale = 0.08,
                color = Color3.fromRGB(255, 210, 60),
                overrideProps = {
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    TextScaled = true,
                    ZIndex = 7,
                    Size = UDim2.fromScale(0.88, 1),
                    TextXAlignment = Enum.TextXAlignment.Left
                },
                strokeProps = {
                    Thickness = 0.06
                },
                text = ("capped to %* by rod"):format((abbreviate(powerCap)))
            })))
        end

        return createElement("frame", t10, v108, createElement2("frame", t11, v109, v110, not v53 and react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 4,
            Size = UDim2.fromScale(1, 0.22)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 0,
            ZIndex = 6,
            Image = images.rebirthIcon,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement(default, {
            text = "Rebirth:",
            color = rebirthGradient,
            overrideProps = {
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                TextXAlignment = "Left",
                ZIndex = 6,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.fromScale(0, 1)
            }
        }), react.createElement(default, {
            color = rebirthGradient,
            overrideProps = {
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                TextXAlignment = "Left",
                ZIndex = 6,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.fromScale(0, 1)
            },
            text = tostring(v54)
        }))))
    end
}
