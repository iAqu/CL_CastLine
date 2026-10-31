-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useState = react.useCallback, react.useEffect, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local shake = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxutil", "shake")
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, ReplicatedStorage, SoundService, Workspace = services.Players, services.ReplicatedStorage, services.SoundService, services.Workspace
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "aquarium-crate-reward-atom")
local aquariumCrateRewardAtom, clearAquariumCrateReward = v1.aquariumCrateRewardAtom, v1.clearAquariumCrateReward
local cameraShakeEnabledAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "haptics").cameraShakeEnabledAtom
local network = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network")
local events, functions = network.events, network.functions
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local rewardPresentationQueue = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reward-presentation-queue").rewardPresentationQueue
local clientProducer = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "producer").clientProducer
local playClonedSound = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "vfx").playClonedSound
local getAquariumSkinData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins").getAquariumSkinData
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local selectPlayerPendingAquariumCrateReveals = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerPendingAquariumCrateReveals
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors
local default2 = RuntimeLib.import(script, script.Parent, "aquarium-crate-opening-screen").default
local v2 = tostring(Players.LocalPlayer.UserId)

local function getMusicSoundGroup() -- line: 35
    -- upvalues: ReplicatedStorage (copy), SoundService (copy)
    local v3 = SoundService:FindFirstChild("music", true) or ReplicatedStorage:FindFirstChild("music", true)

    if if v3 == nil then v3 else v3:IsA("SoundGroup") then
        return v3
    end

    local t1 = {}
    local v4 = #t1
    local Descendants = SoundService:GetDescendants()
    local v5 = #Descendants

    table.move(Descendants, 1, v5, v4 + 1, t1)

    local v6 = v4 + v5
    local Descendants2 = ReplicatedStorage:GetDescendants()

    table.move(Descendants2, 1, #Descendants2, v6 + 1, t1)

    local function v7(p1) -- line: 53
        return p1:IsA("SoundGroup") and string.lower(p1.Name) == "music"
    end

    for v8, v9 in t1 do
        local _ = v8 - 1

        if v7(v9) == true then
            return v9
        end
    end

    return nil
end

local function enqueueReveal(p2) -- line: 66
    -- upvalues: rewardPresentationQueue (copy), clientProducer (copy), v2 (copy)
    clientProducer.aquariumCratePitySynchronized({
        pityCount = p2.pityAfter,
        userId = v2
    })
    rewardPresentationQueue:enqueue({
        kind = "aquariumCrate",
        id = p2.purchaseId,
        reveal = p2
    })
end

local function getRevealPresentationTier(p3) -- line: 77
    local v10 = "rare"

    for _, v11 in p3.rewards do
        if v11.rarity == "mythic" then
            return "mythic"
        end

        if v11.rarity == "legendary" then
            v10 = "legendary"
        elseif v11.rarity == "epic" and v10 == "rare" then
            v10 = "epic"
        end
    end

    return v10
end

return {
    default = function() -- AquariumCrateRewardManager | line: 91
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useState (copy), subscribe (copy), shake (copy), Workspace (copy), aquariumCrateRewardAtom (copy), clearAquariumCrateReward (copy), cameraShakeEnabledAtom (copy), events (copy), functions (copy), default (copy), useRootSelector (copy), useScreenSizeState (copy), rewardPresentationQueue (copy), playClonedSound (copy), getAquariumSkinData (copy), images (copy), selectPlayerPendingAquariumCrateReveals (copy), rarityColors (copy), default2 (copy), v2 (copy), getMusicSoundGroup (copy), enqueueReveal (copy), getRevealPresentationTier (copy)
        local v12 = useRootSelector(selectPlayerPendingAquariumCrateReveals(v2))
        local v13 = useScreenSizeState()
        local v14, v15 = useState(aquariumCrateRewardAtom())
        local v16, v17 = useState(0)
        local opening, opening2 = useState("opening")
        local v18 = useCallback(function() -- line: 97
            -- upvalues: opening2 (copy)
            return opening2("reward")
        end, {})
        local v19 = useCallback(function() -- line: 100
            -- upvalues: shake (copy), Workspace (copy), cameraShakeEnabledAtom (copy), playClonedSound (copy)
            playClonedSound("AuraReveal")

            local CurrentCamera = Workspace.CurrentCamera

            if not (CurrentCamera and cameraShakeEnabledAtom()) then
                return nil
            end

            local v20 = shake.new()

            v20.Amplitude = 1.5
            v20.Frequency = 0.15
            v20.FadeInTime = 0
            v20.FadeOutTime = 0.6
            v20.SustainTime = 0.05
            v20.PositionInfluence = Vector3.new(0.3, 0.3, 0.3)
            v20.RotationInfluence = Vector3.new(0.1, 0.1, 0.1)
            v20:Start()
            v20:BindToRenderStep(shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p4, p5) -- line: 115
                -- upvalues: CurrentCamera (copy)
                local _CFrame = CurrentCamera.CFrame
                local v21 = CFrame.new(p4)
                local v22 = CFrame.fromEulerAnglesXYZ(p5.X, p5.Y, p5.Z)

                CurrentCamera.CFrame = _CFrame * v21 * v22
            end)
        end, {})

        useEffect(function() -- line: 122
            -- upvalues: v12 (copy), enqueueReveal (copy)
            for _, v23 in v12 do
                enqueueReveal(v23)
            end
        end, { v12 })
        useEffect(function() -- line: 127
            -- upvalues: events (copy), enqueueReveal (copy)
            local v24 = events.aquariumCrateRevealReady:connect(enqueueReveal)

            return function() -- line: 129
                -- upvalues: v24 (copy)
                return v24:Disconnect()
            end
        end, {})
        useEffect(function() -- line: 133
            -- upvalues: v15 (copy), v17 (copy), opening2 (copy), subscribe (copy), aquariumCrateRewardAtom (copy)
            return subscribe(aquariumCrateRewardAtom, function(p6) -- line: 134
                -- upvalues: v15 (copy), v17 (copy), opening2 (copy)
                v17(0)
                opening2("opening")
                v15(p6)
            end)
        end, {})
        useEffect(function() -- line: 140
            -- upvalues: v14 (copy), getMusicSoundGroup (copy)
            if v14 == nil then
                return nil
            end

            local v25 = getMusicSoundGroup()

            if v25 == nil then
                return nil
            end

            local Volume = v25.Volume

            v25.Volume = Volume * 0.28

            return function() -- line: 150
                -- upvalues: v25 (copy), Volume (copy)
                v25.Volume = Volume
            end
        end, { v14 })

        if v14 == nil then
            return nil
        end

        if opening == "opening" then
            return react.createElement(default2, {
                key = v14.purchaseId,
                onFinished = v18,
                seriesId = v14.seriesId,
                targetTier = getRevealPresentationTier(v14)
            })
        end

        local v26 = v14.rewards[v16 + 1]

        if v26 == nil then
            return nil
        end

        local v27 = getAquariumSkinData(v26.skinName)
        local v28 = #v14.rewards - 1 <= v16
        local duplicateShardsAwarded = v26.duplicateShardsAwarded

        if duplicateShardsAwarded == nil then
            duplicateShardsAwarded = 0
        end

        local v29 = v26.wasAlreadyOwned and duplicateShardsAwarded > 0
        local v30 = if v13 == "sm" or v13 == "md" then 0.78 else 1
        local t2 = {
            allowTapToAdvance = true,
            backdropTransparency = 0.12,
            circularRewardRay = true,
            iconImage = if v27 == nil then v27 else v27.imageId
        }

        t2.key = ("%*-%*"):format(v14.purchaseId, v16)

        t2.onFinished = function() -- line: 189
            -- upvalues: v14 (copy), v16 (copy), v17 (copy), v28 (copy), clearAquariumCrateReward (copy), functions (copy), rewardPresentationQueue (copy)
            if not v28 then
                v17(v16 + 1)

                return nil
            end

            local purchaseId = v14.purchaseId

            clearAquariumCrateReward(purchaseId)
            functions.acknowledgeAquariumCrateReveal(purchaseId)
            rewardPresentationQueue:presentationFinished(purchaseId)
        end

        t2.onReveal = v19
        t2.rewardBadgeText = string.upper(v26.rarity)
        t2.rewardRarity = v26.rarity
        t2.rewardRayColor = rarityColors[v26.rarity]

        if v27 ~= nil then
            v27 = v27.displayName
        end

        t2.rewardText = if v27 == nil then v26.skinName else v27

        local t3

        if v29 then
            t3 = {
                title = "DUPLICATE CONVERTED!",
                transitionText = "DUPLICATE → WILD SHARD",
                iconImage = images.universalShard,
                rewardRayColor = Color3.fromRGB(255, 232, 82)
            }
            t3.rewardText = ("+%* WILD SHARD%*"):format(duplicateShardsAwarded, duplicateShardsAwarded == 1 and "" or "S")
        end

        t2.secondaryReward = t3
        t2.showWhiteRewardRay = true
        t2.title = if v29 then "DUPLICATE SKIN!" elseif v26.rarity == "mythic" then "MYTHIC CHASE SKIN!" else "AQUARIUM SKIN!"
        t2.uiScale = v30
        t2.zIndex = 200

        return react.createElement(default, t2)
    end
}
