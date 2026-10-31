-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelector
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerStat, selectPlayerAquarium = selectors.selectPlayerStat, selectors.selectPlayerAquarium
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils")
local tutorialSteps, tutorialTrainPowerTarget = v1.tutorialSteps, v1.tutorialTrainPowerTarget
local fishDataByName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").fishDataByName
local getLevelUpCost = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-utils").getLevelUpCost
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId
local selectEquippedInventoryItem = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectEquippedInventoryItem
local useTypewriterText = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-typewriter-text").useTypewriterText
local useTheme = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-theme").useTheme
local useSound = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-sound").useSound
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "faded-background").default
local fishingMovementLockedAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "fishing-phase-atom").fishingMovementLockedAtom
local GuiService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").GuiService
local t1 = {
    {
        delay = 0,
        endX = 0.26,
        endY = 0.22,
        size = 16,
        color = Color3.fromRGB(255, 60, 80)
    },
    {
        delay = 0.02,
        endX = 0.18,
        endY = 0.33,
        size = 10,
        color = Color3.fromRGB(255, 150, 40)
    },
    {
        delay = 0.04,
        endX = 0.36,
        endY = 0.36,
        size = 12,
        color = Color3.fromRGB(255, 210, 50)
    },
    {
        delay = 0.06,
        endX = 0.46,
        endY = 0.25,
        size = 9,
        color = Color3.fromRGB(255, 245, 120)
    },
    {
        delay = 0.08,
        endX = 0.31,
        endY = 0.57,
        size = 18,
        color = Color3.fromRGB(80, 255, 120)
    },
    {
        delay = 0.1,
        endX = 0.22,
        endY = 0.68,
        size = 13,
        color = Color3.fromRGB(110, 255, 210)
    },
    {
        delay = 0.12,
        endX = 0.42,
        endY = 0.7,
        size = 14,
        color = Color3.fromRGB(70, 190, 255)
    },
    {
        delay = 0.14,
        endX = 0.52,
        endY = 0.5,
        size = 11,
        color = Color3.fromRGB(70, 120, 255)
    },
    {
        delay = 0.16,
        endX = 0.2,
        endY = 0.47,
        size = 11,
        color = Color3.fromRGB(210, 100, 255)
    },
    {
        delay = 0.18,
        endX = 0.34,
        endY = 0.8,
        size = 15,
        color = Color3.fromRGB(255, 95, 210)
    },
    {
        delay = 0.2,
        endX = 0.38,
        endY = 0.18,
        size = 15,
        color = Color3.fromRGB(255, 120, 40)
    },
    {
        delay = 0.22,
        endX = 0.48,
        endY = 0.62,
        size = 8,
        color = Color3.fromRGB(255, 255, 255)
    },
    {
        delay = 0.24,
        endX = 0.14,
        endY = 0.2,
        size = 12,
        color = Color3.fromRGB(150, 255, 75)
    },
    {
        delay = 0.26,
        endX = 0.28,
        endY = 0.84,
        size = 9,
        color = Color3.fromRGB(120, 230, 255)
    },
    {
        delay = 0.28,
        endX = 0.55,
        endY = 0.34,
        size = 13,
        color = Color3.fromRGB(240, 90, 130)
    },
    {
        delay = 0.3,
        endX = 0.44,
        endY = 0.86,
        size = 10,
        color = Color3.fromRGB(255, 225, 80)
    },
    {
        delay = 0.05,
        endX = 0.4,
        endY = 0.52,
        size = 14,
        color = Color3.fromRGB(255, 60, 80)
    },
    {
        delay = 0.09,
        endX = 0.16,
        endY = 0.42,
        size = 11,
        color = Color3.fromRGB(80, 255, 120)
    },
    {
        delay = 0.13,
        endX = 0.5,
        endY = 0.76,
        size = 13,
        color = Color3.fromRGB(70, 190, 255)
    },
    {
        delay = 0.17,
        endX = 0.24,
        endY = 0.3,
        size = 12,
        color = Color3.fromRGB(255, 210, 50)
    },
    {
        delay = 0.21,
        endX = 0.46,
        endY = 0.44,
        size = 14,
        color = Color3.fromRGB(210, 100, 255)
    },
    {
        delay = 0.25,
        endX = 0.3,
        endY = 0.68,
        size = 10,
        color = Color3.fromRGB(255, 95, 210)
    },
    {
        delay = 0.29,
        endX = 0.52,
        endY = 0.24,
        size = 12,
        color = Color3.fromRGB(150, 255, 75)
    },
    {
        delay = 0.33,
        endX = 0.2,
        endY = 0.62,
        size = 11,
        color = Color3.fromRGB(255, 150, 40)
    },
    {
        delay = 0.07,
        endX = 0.42,
        endY = 0.28,
        size = 13,
        color = Color3.fromRGB(110, 255, 210)
    },
    {
        delay = 0.11,
        endX = 0.34,
        endY = 0.9,
        size = 12,
        color = Color3.fromRGB(70, 120, 255)
    },
    {
        delay = 0.15,
        endX = 0.12,
        endY = 0.54,
        size = 9,
        color = Color3.fromRGB(255, 245, 120)
    },
    {
        delay = 0.19,
        endX = 0.48,
        endY = 0.38,
        size = 14,
        color = Color3.fromRGB(240, 90, 130)
    }
}
local t2 = {
    {
        delay = 0,
        drift = 0.06,
        size = 14,
        spin = 540,
        startX = 0.04,
        color = Color3.fromRGB(255, 60, 80)
    },
    {
        delay = 0.08,
        drift = -0.07,
        size = 11,
        spin = -420,
        startX = 0.1,
        color = Color3.fromRGB(255, 210, 50)
    },
    {
        delay = 0.04,
        drift = 0.09,
        size = 15,
        spin = 600,
        startX = 0.16,
        color = Color3.fromRGB(80, 255, 120)
    },
    {
        delay = 0.16,
        drift = -0.05,
        size = 12,
        spin = -360,
        startX = 0.22,
        color = Color3.fromRGB(70, 190, 255)
    },
    {
        delay = 0.06,
        drift = 0.07,
        size = 10,
        spin = 480,
        startX = 0.28,
        color = Color3.fromRGB(210, 100, 255)
    },
    {
        delay = 0.12,
        drift = -0.08,
        size = 16,
        spin = -540,
        startX = 0.34,
        color = Color3.fromRGB(255, 150, 40)
    },
    {
        delay = 0.02,
        drift = 0.05,
        size = 14,
        spin = 420,
        startX = 0.4,
        color = Color3.fromRGB(110, 255, 210)
    },
    {
        delay = 0.18,
        drift = -0.06,
        size = 11,
        spin = -600,
        startX = 0.46,
        color = Color3.fromRGB(255, 95, 210)
    },
    {
        delay = 0.1,
        drift = 0.08,
        size = 12,
        spin = 360,
        startX = 0.52,
        color = Color3.fromRGB(150, 255, 75)
    },
    {
        delay = 0.14,
        drift = -0.09,
        size = 15,
        spin = -480,
        startX = 0.58,
        color = Color3.fromRGB(255, 245, 120)
    },
    {
        delay = 0.2,
        drift = 0.06,
        size = 10,
        spin = 540,
        startX = 0.64,
        color = Color3.fromRGB(70, 120, 255)
    },
    {
        delay = 0.24,
        drift = -0.07,
        size = 14,
        spin = -420,
        startX = 0.7,
        color = Color3.fromRGB(240, 90, 130)
    },
    {
        delay = 0.03,
        drift = 0.08,
        size = 12,
        spin = 520,
        startX = 0.76,
        color = Color3.fromRGB(255, 225, 80)
    },
    {
        delay = 0.11,
        drift = -0.06,
        size = 10,
        spin = -500,
        startX = 0.82,
        color = Color3.fromRGB(120, 230, 255)
    },
    {
        delay = 0.19,
        drift = 0.07,
        size = 14,
        spin = 460,
        startX = 0.88,
        color = Color3.fromRGB(255, 120, 40)
    },
    {
        delay = 0.27,
        drift = -0.04,
        size = 9,
        spin = -380,
        startX = 0.94,
        color = Color3.fromRGB(255, 255, 255)
    },
    {
        delay = 0.31,
        drift = -0.08,
        size = 11,
        spin = -560,
        startX = 0.07,
        color = Color3.fromRGB(255, 95, 210)
    },
    {
        delay = 0.22,
        drift = 0.06,
        size = 13,
        spin = 500,
        startX = 0.19,
        color = Color3.fromRGB(70, 190, 255)
    },
    {
        delay = 0.29,
        drift = -0.07,
        size = 12,
        spin = -460,
        startX = 0.31,
        color = Color3.fromRGB(80, 255, 120)
    },
    {
        delay = 0.25,
        drift = 0.08,
        size = 14,
        spin = 420,
        startX = 0.43,
        color = Color3.fromRGB(255, 210, 50)
    },
    {
        delay = 0.33,
        drift = -0.05,
        size = 10,
        spin = -520,
        startX = 0.55,
        color = Color3.fromRGB(210, 100, 255)
    },
    {
        delay = 0.28,
        drift = 0.06,
        size = 13,
        spin = 480,
        startX = 0.67,
        color = Color3.fromRGB(255, 150, 40)
    },
    {
        delay = 0.35,
        drift = -0.08,
        size = 12,
        spin = -440,
        startX = 0.79,
        color = Color3.fromRGB(150, 255, 75)
    },
    {
        delay = 0.3,
        drift = 0.07,
        size = 13,
        spin = 560,
        startX = 0.91,
        color = Color3.fromRGB(240, 90, 130)
    }
}

local function TutorialConfetti() -- line: 368
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), t1 (copy), t2 (copy)
    local v2, v3 = useMotion(0)

    useEffect(function() -- line: 370
        -- upvalues: v3 (copy)
        v3:linear(1, {
            speed = 0.4
        })
    end, { v3 })

    local function v4(p1) -- line: 375
        -- upvalues: v2 (copy), react (copy), t1 (copy)
        local v5 = table.create(#t1)

        local function v6(p2, p3) -- line: 378
            -- upvalues: p1 (copy), v2 (copy), react (copy)
            local v7 = if p1 == "left" then 1 else -1
            local v8 = if p1 == "left" then -0.08 else 1.08
            local v9 = if p1 == "left" then p2.endX else 1 - p2.endX
            local v10 = v2:map(function(p4) -- line: 382
                -- upvalues: p2 (copy), v9 (copy), v8 (copy)
                local v12 = math.clamp((p4 - p2.delay) / 0.58, 0, 1)
                local v14 = 1 - math.pow(1 - v12, 3)
                local v16 = math.sin(v12 * 3.141592653589793) * 0.18

                return UDim2.fromScale(v8 + (v9 - v8) * v14, 0.62 + (p2.endY - 0.62) * v14 - v16)
            end)
            local v17 = v2:map(function(p5) -- line: 388
                -- upvalues: p2 (copy)
                if math.clamp((p5 - p2.delay) / 0.58, 0, 1) >= 0.98 then
                    return 1
                end

                return 0
            end)

            return react.createElement("frame", {
                BorderSizePixel = 0,
                ZIndex = 150,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = p2.color,
                BackgroundTransparency = v17,
                Position = v10,
                Rotation = v2:map(function(p6) -- line: 398
                    -- upvalues: p3 (copy), v7 (copy)
                    return v7 * (p6 * 720 + p3 * 28)
                end),
                Size = UDim2.fromOffset(p2.size, (math.max(6, p2.size * 0.55))),
                key = ("%*-%*"):format(p1, p3)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0, 3)
            }))
        end

        for v20, v21 in t1 do
            v5[v20] = v6(v21, v20 - 1, t1)
        end

        return v5
    end

    local v22 = table.create(#t2)

    local function v23(p7, p8) -- line: 416
        -- upvalues: v2 (copy), react (copy)
        local v24 = v2:map(function(p9) -- line: 417
            -- upvalues: p7 (copy)
            local v26 = math.clamp((p9 - p7.delay) / (1 - p7.delay), 0, 1)
            local v27 = v26 * v26
            local v29 = math.sin(v26 * 3.141592653589793 * 2) * p7.drift * 0.4

            return UDim2.fromScale(p7.startX + p7.drift * v27 + v29, v27 * 1.25 + -0.1)
        end)

        return react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 150,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = p7.color,
            BackgroundTransparency = v2:map(function(p10) -- line: 426
                -- upvalues: p7 (copy)
                local v31 = math.clamp((p10 - p7.delay) / (1 - p7.delay), 0, 1)

                if v31 > 0.88 then
                    return (v31 - 0.88) / 0.12
                end

                return 0
            end),
            Position = v24,
            Rotation = v2:map(function(p11) -- line: 432
                -- upvalues: p7 (copy)
                return p11 * p7.spin
            end),
            Size = UDim2.fromOffset(p7.size, (math.max(6, p7.size * 0.55))),
            key = ("top-%*"):format(p8)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 3)
        }))
    end

    for v33, v34 in t2 do
        v22[v33] = v23(v34, v33 - 1, t2)
    end

    return react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 149,
        Size = UDim2.fromScale(1, 1)
    }, v22, v4("left"), (v4("right")))
end

local function getStaticText(p12) -- line: 455
    -- upvalues: tutorialSteps (copy)
    if p12 == tutorialSteps.walkToDock then
        return "Walk to dock"
    end

    if p12 == tutorialSteps.catchAFish then
        return "Catch a fish"
    end

    if p12 == tutorialSteps.addFishToAquarium then
        return "Add fish to aquarium"
    end

    if p12 == tutorialSteps.equipBestFish then
        return "Equip best fish"
    end

    if p12 == tutorialSteps.levelUpFish then
        return "Level up your fish"
    end

    if p12 == tutorialSteps.closeAquarium then
        return "Close aquarium"
    end

    if p12 == tutorialSteps.goToWeightsShop then
        return "Buy a training weight"
    end

    if p12 == tutorialSteps.endWeightTraining then
        return "Exit training"
    end

    if p12 == tutorialSteps.tutorialEnded then
        return "Tutorial complete!"
    end

    return ""
end

return {
    default = function() -- TutorialText | line: 487
        -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), useMotion (copy), useRootSelector (copy), selectTutorialStep (copy), selectPlayerStat (copy), selectPlayerAquarium (copy), tutorialSteps (copy), tutorialTrainPowerTarget (copy), fishDataByName (copy), getLevelUpCost (copy), localPlayerUserId (copy), selectEquippedInventoryItem (copy), useTypewriterText (copy), useTheme (copy), useSound (copy), default (copy), default2 (copy), fishingMovementLockedAtom (copy), GuiService (copy), TutorialConfetti (copy), getStaticText (copy)
        local v35 = useTheme()
        local v36 = useRootSelector(selectTutorialStep)
        local v37 = useRootSelector(selectPlayerStat(localPlayerUserId, "power"))

        if v37 == nil then
            v37 = 0
        end

        local v38 = useRootSelector(selectPlayerStat(localPlayerUserId, "money"))

        if v38 == nil then
            v38 = 0
        end

        local v39 = useRootSelector(selectPlayerAquarium(localPlayerUserId))
        local playSound = useSound("SkillCheckSuccess").playSound
        local v40, v41 = useState(fishingMovementLockedAtom())

        useEffect(function() -- line: 504
            -- upvalues: v41 (copy), subscribe (copy), fishingMovementLockedAtom (copy)
            return subscribe(fishingMovementLockedAtom, v41)
        end, {})

        local v42, v43 = useMotion(0)
        local v44 = v36 == tutorialSteps.trainPower
        local v45 = v36 == tutorialSteps.collectMoney
        local v46 = v36 == tutorialSteps.tutorialEnded
        local v47 = v36 == tutorialSteps.endWeightTraining
        local v48 = useRootSelector(selectEquippedInventoryItem(localPlayerUserId))

        if v48 ~= nil then
            v48 = v48.itemType
        end

        local v49 = v48 == "trainingWeight"
        local v51 = useTypewriterText((getStaticText(v36)))
        local t5 = {
            current = v36
        }

        if v46 and t5.current ~= v36 then
            v43:set(0)
        end

        react.useEffect(function() -- line: 527
            -- upvalues: playSound (copy), v43 (copy), v46 (copy)
            if not v46 then
                v43:set(0)

                return
            end

            playSound()
            v43:set(0)
            task.delay(5, function() -- line: 531
                -- upvalues: v43 (copy)
                v43:tween(1, {
                    time = 1,
                    style = Enum.EasingStyle.Quad
                })
            end)
        end, { v46, playSound })

        if v36 == tutorialSteps.none or v36 == tutorialSteps.completed or v36 == tutorialSteps.catchAFish and v40 or v47 and not v49 then
            return react.createElement(react.Fragment)
        end

        local n1 = 0
        local v52

        if v45 then
            if v39 ~= nil then
                for _, v53 in v39.fishItems do
                    local v54 = fishDataByName[v53.fishSpecies]

                    n1 = if v54 == nil or v54.moneyPerSecond == nil then 0 else getLevelUpCost(v54.moneyPerSecond, v53.level)
                    break
                end
            end

            v52 = n1 > 0 and n1 <= v38
        else
            v52 = v45
        end

        if v44 then
            v51 = ("Train to %* power (%*/%*)"):format(tutorialTrainPowerTarget, math.min(v37, tutorialTrainPowerTarget), tutorialTrainPowerTarget)
        elseif v52 then
            v51 = "Upgrade fish"
        elseif v45 then
            v51 = ("Collect $%*/$%*"):format(math.min(v38, n1), n1)
        end

        if v51 == "" and not v44 and not v45 then
            return react.createElement(react.Fragment)
        end

        local v55 = v46 and react.createElement(TutorialConfetti)
        local t6 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0)
        }

        t6.Position = UDim2.fromScale(0.5, 0.1) + UDim2.fromOffset(0, GuiService:GetGuiInset().Y)
        t6.Size = UDim2.fromScale(0.55, 0.07)
        t6.ZIndex = v47 and 201 or 0

        return react.createElement(react.Fragment, nil, v55, react.createElement("frame", t6, react.createElement(default2, {
            backgroundTransparency = 0.4,
            zIndex = v47 and 201 or 1
        }), react.createElement(default, {
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = v35.textFont2,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.95, 0.85),
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = v47 and 202 or 2
            },
            strokeProps = {
                Thickness = 0.06
            },
            text = v51,
            textTransparency = if not v46 then 0 else v42
        })))
    end
}
