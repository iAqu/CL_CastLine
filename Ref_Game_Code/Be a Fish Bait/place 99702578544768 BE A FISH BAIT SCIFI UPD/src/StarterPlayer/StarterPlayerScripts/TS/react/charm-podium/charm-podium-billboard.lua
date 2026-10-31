-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, ProximityPromptService, RunService = services.CollectionService, services.ProximityPromptService, services.RunService
local ensureCharmPodiumBillboardMount = RuntimeLib.import(script, script.Parent.Parent.Parent, "components", "charm-podium-component").ensureCharmPodiumBillboardMount
local charmPodiumPreviewTargetAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "charm-podium-preview-target-atom").charmPodiumPreviewTargetAtom
local events = RuntimeLib.import(script, script.Parent.Parent.Parent, "network").events
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes")
local charmTierConfigs, charmTierOrder, getCharmTierFlag, getCharmTierKey = v1.charmTierConfigs, v1.charmTierOrder, v1.getCharmTierFlag, v1.getCharmTierKey
local isCharmTierId = v1.isCharmTierId
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerCharms, selectPlayerRebirthCount = selectors.selectPlayerCharms, selectors.selectPlayerRebirthCount
local v2 = Color3.fromRGB(255, 255, 255)
local v3 = Color3.fromRGB(0, 0, 0)
local v4 = Color3.fromRGB(220, 220, 220)
local v5 = Vector2.new(390, 190)
local t1 = {
    Color3.fromRGB(84, 196, 255),
    Color3.fromRGB(75, 239, 222),
    Color3.fromRGB(193, 92, 255),
    Color3.fromRGB(255, 189, 71),
    (Color3.fromRGB(255, 82, 151))
}
local makeGradient, formatCash

local function CharmPodiumBillboardContent(p1) -- line: 44
    -- upvalues: react (copy), default (copy), default2 (copy), charmTierConfigs (copy), v2 (copy), v3 (copy), v4 (copy), t1 (copy), makeGradient (ref), formatCash (ref)
    local v6 = charmTierConfigs[p1.tierId]
    local v7 = t1[p1.tierId]
    local v8 = if p1.isUnlocked then makeGradient(v7:Lerp(v2, 0.18), v7:Lerp(v3, 0.28)) else makeGradient(Color3.fromRGB(125, 125, 135), Color3.fromRGB(66, 66, 76))
    local v9 = if not p1.isUnlocked then makeGradient(Color3.fromRGB(130, 130, 140), Color3.fromRGB(72, 72, 82)) elseif p1.hasPending then makeGradient(Color3.fromRGB(255, 190, 54), Color3.fromRGB(224, 107, 11)) else makeGradient(Color3.fromRGB(91, 255, 89), Color3.fromRGB(19, 185, 26))
    local v10 = ("REBIRTH %* / %*"):format(math.min(p1.rebirthCount, v6.rebirthRequirement), v6.rebirthRequirement)
    local v12 = math.clamp(p1.rebirthCount / v6.rebirthRequirement, 0, 1)
    local v13 = if p1.isUnlocked then ("REBIRTH %*"):format(v6.rebirthRequirement) else v10
    local v14 = if p1.hasPending then "FINISH YOUR CURRENT CHARM CHOICE"
        elseif not p1.isUnlocked then ("PROGRESS: %*"):format(v10)
        elseif p1.isFree then "FIRST ROLL FREE!"
        elseif p1.isLowerTier then ("LOWER TIER · %*"):format((formatCash(v6.cost)))
        else formatCash(v6.cost)
    local v15 = if p1.hasPending then "[E] RESOLVE ROLL"
        elseif not p1.isUnlocked then "REBIRTH REQUIRED"
        elseif p1.isLowerTier then "[E] VIEW / ROLL"
        else "[E] ROLL ATTRIBUTES"
    local createElement = react.createElement
    local t2 = {
        clipsDescendants = true,
        cornerRadius = 0.08,
        isStudded = true,
        isStuddedTransparency = 0.1,
        strokeThickness = 0.035,
        textureTransparency = 0.68,
        tileSize = 72,
        backgroundColor = if p1.isUnlocked then makeGradient(Color3.fromRGB(154, 70, 244), Color3.fromRGB(255, 135, 35)) else makeGradient(Color3.fromRGB(72, 72, 82), Color3.fromRGB(20, 20, 26)),
        size = UDim2.fromScale(1, 1),
        strokeColor = if p1.isUnlocked then v2 else Color3.fromRGB(176, 176, 184)
    }
    local createElement2 = react.createElement
    local t3 = {
        cornerRadius = 0.08,
        isStudded = true,
        isStuddedTransparency = 0.06,
        textureTransparency = 0.76,
        tileSize = 60,
        zIndex = 2,
        backgroundColor = v8,
        position = UDim2.fromScale(0, 0),
        size = UDim2.fromScale(1, p1.isCompact and 1 or 0.32)
    }
    local v16 = react.createElement(default2, {
        shadowYScale = 0.045,
        color = if p1.isUnlocked then v2 else v4,
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 3,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.04, p1.isCompact and 0.06 or 0.04),
            Size = UDim2.fromScale(0.92, p1.isCompact and 0.39 or 0.88)
        },
        strokeProps = {
            Thickness = 0.055
        },
        text = ("TIER %* · %*"):format(p1.tierId, v6.displayName)
    })
    local isCompact = p1.isCompact

    isCompact = isCompact and react.createElement(react.Fragment, nil, react.createElement(default2, {
        shadowYScale = 0.045,
        color = if p1.isUnlocked then Color3.fromRGB(255, 242, 133) else v4,
        overrideProps = {
            TextScaled = true,
            ZIndex = 3,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.1, 0.46),
            Size = UDim2.fromScale(0.8, 0.22)
        },
        strokeProps = {
            Thickness = 0.055
        },
        text = v13
    }), not p1.isUnlocked and react.createElement(default, {
        clipsDescendants = true,
        cornerRadius = 0.5,
        strokeThickness = 0.06,
        zIndex = 3,
        backgroundColor = Color3.fromRGB(18, 18, 23),
        position = UDim2.fromScale(0.1, 0.76),
        size = UDim2.fromScale(0.8, 0.11),
        strokeColor = Color3.fromRGB(225, 225, 230)
    }, react.createElement(default, {
        cornerRadius = 0.5,
        isStudded = true,
        textureTransparency = 0.75,
        tileSize = 36,
        zIndex = 4,
        backgroundColor = makeGradient(v7:Lerp(v2, 0.18), v7:Lerp(v3, 0.18)),
        position = UDim2.fromScale(0, 0),
        size = UDim2.fromScale(v12, 1)
    })))

    local v17 = createElement2(default, t3, v16, isCompact)
    local v18 = not p1.isCompact

    v18 = v18 and react.createElement(react.Fragment, nil, react.createElement(default2, {
        shadowYScale = 0.045,
        color = if p1.isUnlocked then v2 else v4,
        overrideProps = {
            TextScaled = true,
            ZIndex = 3,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.08, 0.34),
            Size = UDim2.fromScale(0.84, 0.16)
        },
        strokeProps = {
            Thickness = 0.055
        },
        text = v13
    }), react.createElement(default2, {
        shadowYScale = 0.045,
        color = if p1.isFree then Color3.fromRGB(255, 238, 91)
            elseif p1.isLowerTier then Color3.fromRGB(255, 181, 73)
            elseif p1.isUnlocked then v2
            else v4,
        overrideProps = {
            TextScaled = true,
            ZIndex = 3,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.08, 0.49),
            Size = UDim2.fromScale(0.84, 0.14)
        },
        strokeProps = {
            Thickness = 0.055
        },
        text = v14
    }), not p1.isUnlocked and react.createElement(default, {
        clipsDescendants = true,
        cornerRadius = 0.5,
        strokeThickness = 0.08,
        zIndex = 3,
        backgroundColor = Color3.fromRGB(18, 18, 23),
        position = UDim2.fromScale(0.09, 0.64),
        size = UDim2.fromScale(0.82, 0.08),
        strokeColor = Color3.fromRGB(225, 225, 230)
    }, react.createElement(default, {
        cornerRadius = 0.5,
        isStudded = true,
        textureTransparency = 0.75,
        tileSize = 36,
        zIndex = 4,
        backgroundColor = makeGradient(v7:Lerp(v2, 0.18), v7:Lerp(v3, 0.18)),
        position = UDim2.fromScale(0, 0),
        size = UDim2.fromScale(v12, 1)
    })), react.createElement(default, {
        cornerRadius = 0.13,
        isStudded = true,
        isStuddedTransparency = 0.04,
        strokeThickness = 0.045,
        textureTransparency = 0.7,
        tileSize = 54,
        zIndex = 3,
        backgroundColor = v9,
        position = UDim2.fromScale(0.08, 0.75),
        size = UDim2.fromScale(0.84, 0.2),
        strokeColor = v2
    }, react.createElement(default2, {
        shadowYScale = 0.045,
        color = if p1.isUnlocked then v2 else v4,
        overrideProps = {
            TextScaled = true,
            ZIndex = 4,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.04, 0.05),
            Size = UDim2.fromScale(0.92, 0.85)
        },
        strokeProps = {
            Thickness = 0.055
        },
        text = v15
    })))

    return createElement(default, t2, v17, v18)
end

local function CharmPodiumBillboardForPodium(p2) -- line: 196
    -- upvalues: react (copy), useEffect (copy), createPortal (copy), RunService (copy), useRootSelector (copy), localPlayerUserId (copy), charmTierConfigs (copy), charmTierOrder (copy), getCharmTierFlag (copy), getCharmTierKey (copy), isCharmTierId (copy), selectPlayerCharms (copy), selectPlayerRebirthCount (copy), v5 (copy), CharmPodiumBillboardContent (copy)
    local podium, billboard = p2.podium, p2.billboard
    local v22 = useRootSelector(selectPlayerCharms(localPlayerUserId))
    local v23 = useRootSelector(selectPlayerRebirthCount(localPlayerUserId))
    local CharmTierId = podium:GetAttribute("CharmTierId")

    if type(CharmTierId) ~= "number" or not isCharmTierId(CharmTierId) then
        CharmTierId = nil
    end

    useEffect(function() -- line: 203
        -- upvalues: billboard (copy), RunService (copy), v5 (copy)
        billboard.Enabled = true

        local n1 = -1
        local n2 = -1

        local function v24() -- line: 207
            -- upvalues: n1 (ref), n2 (ref), billboard (copy), v5 (copy)
            local MaxDistance = billboard.MaxDistance
            local v28 = 1 - math.clamp((billboard.CurrentDistance - 12) / math.max(MaxDistance - 12, 1), 0, 1) * 0.44999999999999996
            local v30 = math.floor(v5.X * v28 + 0.5)
            local v32 = math.floor(v5.Y * v28 + 0.5)

            if v30 == n1 and v32 == n2 then
                return nil
            end

            n1 = v30
            n2 = v32
            billboard.Size = UDim2.fromOffset(v30, v32)
        end

        v24()

        local connection = RunService.RenderStepped:Connect(v24)

        return function() -- line: 222
            -- upvalues: connection (copy)
            return connection:Disconnect()
        end
    end, { billboard })
    useEffect(function() -- line: 226
        -- upvalues: billboard (copy)
        local CharmBillboardContainer = billboard:FindFirstChild("CharmBillboardContainer")

        if if CharmBillboardContainer == nil then CharmBillboardContainer else CharmBillboardContainer:IsA("GuiObject") then
            CharmBillboardContainer.Visible = false
        end
    end, { billboard })

    if CharmTierId == nil then
        return nil
    end

    local v33 = charmTierConfigs[CharmTierId].rebirthRequirement <= v23
    local v34 = if v22 == nil then v22 else v22.firstRollClaimedByTier

    if v34 == nil then
        v34 = { false, false, false, false, false }
    end

    local v35 = not getCharmTierFlag(v34, CharmTierId)
    local t11 = {}

    t11.hasPending = (if v22 == nil then v22 else v22.pendingCharmCandidate) ~= nil
    t11.isCompact = false
    t11.isFree = v35

    local v36 = v22 ~= nil

    if v36 then
        v36 = false

        for v37, v38 in charmTierOrder do
            local _ = v37 - 1

            if CharmTierId < v38 and v22.charmCoresByTier[getCharmTierKey(v38)] ~= nil then
                v36 = true
                break
            end

            v36 = false
        end
    end

    t11.isLowerTier = v36
    t11.isUnlocked = v33
    t11.rebirthCount = v23
    t11.tierId = CharmTierId

    return createPortal(react.createElement(CharmPodiumBillboardContent, t11), billboard)
end

local function CharmPodiumBillboardManager() -- line: 285
    -- upvalues: react (copy), useEffect (copy), useState (copy), CollectionService (copy), RunService (copy), ensureCharmPodiumBillboardMount (copy), CharmPodiumBillboardForPodium (copy)
    local v39, v40 = useState({})

    useEffect(function() -- line: 287
        -- upvalues: v40 (copy), CollectionService (copy), RunService (copy), ensureCharmPodiumBillboardMount (copy)
        local connection

        local function v41() -- line: 289
            -- upvalues: v40 (copy), CollectionService (copy), ensureCharmPodiumBillboardMount (copy)
            local t12 = {}
            local v42 = false

            for _, v43 in CollectionService:GetTagged("CharmPodium") do
                if v43:IsA("Model") then
                    local v44 = ensureCharmPodiumBillboardMount(v43)

                    if v44 ~= nil then
                        table.insert(t12, {
                            billboard = v44,
                            podium = v43
                        })
                    else
                        v42 = true
                    end
                end
            end

            v40(t12)

            return v42
        end

        local function v45() -- line: 310
            -- upvalues: connection (ref), v41 (copy), RunService (copy)
            if not v41() or connection ~= nil then
                return nil
            end

            connection = RunService.Heartbeat:Connect(function() -- line: 314
                -- upvalues: connection (ref), v41 (copy)
                if v41() then
                    return nil
                end

                local connection2 = connection

                if connection2 ~= nil then
                    connection2:Disconnect()
                end

                connection = nil
            end)
        end

        if v41() and connection == nil then
            connection = RunService.Heartbeat:Connect(function() -- line: 314
                -- upvalues: connection (ref), v41 (copy)
                if v41() then
                    return nil
                end

                local connection2 = connection

                if connection2 ~= nil then
                    connection2:Disconnect()
                end

                connection = nil
            end)
        end

        local connection2 = CollectionService:GetInstanceAddedSignal("CharmPodium"):Connect(v45)
        local connection3 = CollectionService:GetInstanceRemovedSignal("CharmPodium"):Connect(v45)

        return function() -- line: 328
            -- upvalues: connection (ref), connection2 (copy), connection3 (copy)
            connection2:Disconnect()
            connection3:Disconnect()

            local connection4 = connection

            if connection4 ~= nil then
                connection4:Disconnect()
            end
        end
    end, {})

    local v46 = table.create(#v39)

    local function v47(p3) -- line: 339
        -- upvalues: react (copy), CharmPodiumBillboardForPodium (copy)
        return react.createElement(CharmPodiumBillboardForPodium, {
            billboard = p3.billboard,
            key = tostring(p3.podium),
            podium = p3.podium
        })
    end

    for v48, v49 in v39 do
        local _ = v48 - 1

        v46[v48] = react.createElement(CharmPodiumBillboardForPodium, {
            billboard = v49.billboard,
            key = tostring(v49.podium),
            podium = v49.podium
        })
    end

    return react.createElement(react.Fragment, nil, v46)
end

local function CharmPodiumInteractionManager() -- line: 359
    -- upvalues: useEffect (copy), CollectionService (copy), ProximityPromptService (copy), ensureCharmPodiumBillboardMount (copy), charmPodiumPreviewTargetAtom (copy), events (copy), useRootProducer (copy), useRootSelector (copy), localPlayerUserId (copy), charmTierConfigs (copy), isCharmTierId (copy), selectPlayerRebirthCount (copy)
    local v50 = useRootProducer()
    local v51 = useRootSelector(selectPlayerRebirthCount(localPlayerUserId))

    useEffect(function() -- line: 362
        -- upvalues: v50 (copy), v51 (copy), CollectionService (copy), ProximityPromptService (copy), ensureCharmPodiumBillboardMount (copy), charmPodiumPreviewTargetAtom (copy), events (copy), charmTierConfigs (copy), isCharmTierId (copy)
        local function v52(p4) -- line: 363
            -- upvalues: v51 (copy), CollectionService (copy), ensureCharmPodiumBillboardMount (copy), charmTierConfigs (copy), isCharmTierId (copy)
            if not (p4:IsA("Model") and CollectionService:HasTag(p4, "CharmPodium")) then
                return nil
            end

            local CharmTierId = p4:GetAttribute("CharmTierId")

            if type(CharmTierId) ~= "number" or not isCharmTierId(CharmTierId) then
                return nil
            end

            ensureCharmPodiumBillboardMount(p4)

            local v53 = p4:FindFirstChildWhichIsA("ProximityPrompt", true)

            if not v53 then
                return nil
            end

            local v54 = v51 >= charmTierConfigs[CharmTierId].rebirthRequirement

            v53.Enabled = v54
            v53.ActionText = v54 and "Roll Attributes" or "Rebirth Required"
        end

        for _, v55 in CollectionService:GetTagged("CharmPodium") do
            v52(v55)
        end

        local connection = CollectionService:GetInstanceAddedSignal("CharmPodium"):Connect(v52)
        local connection2 = ProximityPromptService.PromptTriggered:Connect(function(p5) -- line: 390
            -- upvalues: v50 (copy), v51 (copy), CollectionService (copy), charmPodiumPreviewTargetAtom (copy), events (copy), charmTierConfigs (copy), isCharmTierId (copy)
            local Model = p5:FindFirstAncestorWhichIsA("Model")

            if not (Model and CollectionService:HasTag(Model, "CharmPodium")) then
                return nil
            end

            local CharmTierId = Model:GetAttribute("CharmTierId")

            if type(CharmTierId) ~= "number" or not isCharmTierId(CharmTierId) or v51 < charmTierConfigs[CharmTierId].rebirthRequirement then
                return nil
            end

            events.analyticsCharmPodiumViewed:fire(CharmTierId)
            charmPodiumPreviewTargetAtom(Model)
            v50.windowOpened({
                currentWindow = "charmAttributes",
                charmTierId = CharmTierId
            })
        end)

        return function() -- line: 409
            -- upvalues: connection (copy), connection2 (copy)
            connection:Disconnect()
            connection2:Disconnect()
        end
    end, { v50, v51 })

    return nil
end

function makeGradient(p6, p7) -- line: 416
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, p6),
        ColorSequenceKeypoint.new(1, p7)
    })
end

function formatCash(p8) -- line: 419
    if p8 >= 1E+09 then
        return (`{ p8 / 1E+09 }B CASH`)
    end

    return (`{ p8 / 1E+06 }M CASH`)
end

return {
    CharmPodiumBillboardContent = CharmPodiumBillboardContent,
    default = CharmPodiumBillboardManager,
    CharmPodiumInteractionManager = CharmPodiumInteractionManager
}
