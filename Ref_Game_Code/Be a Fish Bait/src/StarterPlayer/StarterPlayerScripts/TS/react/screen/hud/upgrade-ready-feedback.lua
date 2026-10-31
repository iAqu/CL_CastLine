-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local memo, useEffect, useRef, useState = react.memo, react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, GuiService = services.CollectionService, services.GuiService
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerStat, selectPlayerAquariumLevel = selectors.selectPlayerStat, selectors.selectPlayerAquariumLevel
local mountFishPreviewItemNameAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "mount-fish-preview-atom").mountFishPreviewItemNameAtom
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local aquariums = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquariums")
local allAquariumData, getAquariumData = aquariums.allAquariumData, aquariums.getAquariumData
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "faded-background").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "tutorial", "tutorial-beam").default
local v1 = false

local function getUpgradeSignAttachment() -- line: 38
    -- upvalues: CollectionService (copy), localPlayerUserId (copy)
    for _, v2 in CollectionService:GetTagged("AquariumUpgradeSign") do
        if v2:GetAttribute("ownerUserId") == localPlayerUserId and v2:IsA("Model") then
            local BillboardPart = v2:FindFirstChild("BillboardPart")

            if BillboardPart ~= nil and BillboardPart:IsA("BasePart") then
                local UpgradeBeamAnchor = BillboardPart:FindFirstChild("UpgradeBeamAnchor")

                if UpgradeBeamAnchor ~= nil and UpgradeBeamAnchor:IsA("Attachment") then
                    return UpgradeBeamAnchor
                end

                local Attachment = Instance.new("Attachment")

                Attachment.Name = "UpgradeBeamAnchor"
                Attachment.Position = Vector3.new(0, -4, 0)
                Attachment.Parent = BillboardPart

                return Attachment
            end
        end
    end

    return nil
end

return {
    default = memo(function() -- UpgradeReadyFeedback | line: 57
        -- upvalues: subscribe (copy), react (copy), useEffect (copy), useRef (copy), useState (copy), useMotion (copy), CollectionService (copy), GuiService (copy), useRootSelector (copy), selectTutorialStep (copy), selectPlayerStat (copy), selectPlayerAquariumLevel (copy), mountFishPreviewItemNameAtom (copy), tutorialSteps (copy), allAquariumData (copy), getAquariumData (copy), localPlayerUserId (copy), useTheme (copy), default (copy), default2 (copy), default3 (copy), v1 (ref), getUpgradeSignAttachment (copy)
        local v3 = useTheme()
        local v4 = useRootSelector(selectTutorialStep)
        local v5 = useRootSelector(selectPlayerStat(localPlayerUserId, "money"))

        if v5 == nil then
            v5 = 0
        end

        local v6 = useRootSelector(selectPlayerAquariumLevel(localPlayerUserId))
        local v7 = tutorialSteps.completed <= v4
        local v8 = getAquariumData(v6)
        local v9 = not (#allAquariumData <= v6)

        if v9 then
            v9 = v8.upgradeCost > 0 and v8.upgradeCost <= v5
        end

        local v10 = v6 == 1 and v8.upgradeCost == 1E+05
        local v11, v12 = useState(false)
        local v13, v14 = useState(false)
        local v15, v16 = useMotion(0)
        local v17 = useRef(v9)

        local function v18() -- line: 76
            -- upvalues: v12 (copy), v14 (copy), v16 (copy), v10 (copy), v1 (ref)
            v12(true)

            if v10 and not v1 then
                v1 = true
                v14(true)
            end

            v16:set(0)
            task.delay(2, function() -- line: 83
                -- upvalues: v12 (copy), v16 (copy)
                v16:tween(1, {
                    time = 1,
                    style = Enum.EasingStyle.Quad
                })
                task.delay(1, function() -- line: 88
                    -- upvalues: v12 (copy)
                    return v12(false)
                end)
            end)
        end

        useEffect(function() -- line: 94
            -- upvalues: v9 (ref), v18 (copy), v7 (copy)
            if not v7 or not v9 then
                return nil
            end

            local v19 = task.delay(10, function() -- line: 101
                -- upvalues: v9 (ref), v18 (copy)
                if v9 then
                    v18()
                end
            end)

            return function() -- line: 107
                -- upvalues: v19 (copy)
                return task.cancel(v19)
            end
        end, { v9, v10, v7 })
        useEffect(function() -- line: 112
            -- upvalues: v9 (ref), v14 (copy), v17 (copy), v18 (copy), v10 (copy), v7 (copy)
            if not v7 then
                v17.current = v9

                return nil
            end

            local current = v17.current

            v17.current = v9

            if v9 and not current then
                v18()
            end

            if not (v9 and v10) then
                v14(false)
            end
        end, { v9, v10, v7 })

        local v20, v21 = useState(nil)
        local v22, v23 = useState(mountFishPreviewItemNameAtom())

        useEffect(function() -- line: 129
            -- upvalues: v23 (copy), subscribe (copy), mountFishPreviewItemNameAtom (copy)
            return subscribe(mountFishPreviewItemNameAtom, v23)
        end, {})

        local v24 = v22 ~= nil

        useEffect(function() -- line: 133
            -- upvalues: v13 (copy), v21 (copy), v24 (copy), CollectionService (copy), getUpgradeSignAttachment (copy)
            if not v13 or v24 then
                v21(nil)

                return nil
            end

            local v25 = getUpgradeSignAttachment()

            v21(v25)

            if v25 ~= nil then
                return nil
            end

            local connection

            connection = CollectionService:GetInstanceAddedSignal("AquariumUpgradeSign"):Connect(function() -- line: 145
                -- upvalues: connection (ref), v21 (copy), getUpgradeSignAttachment (copy)
                local v26 = getUpgradeSignAttachment()

                if v26 == nil then
                    return
                end

                v21(v26)
                connection:Disconnect()
            end)

            return function() -- line: 152
                -- upvalues: connection (ref)
                return connection:Disconnect()
            end
        end, { v13, v24 })

        if not v7 then
            return react.createElement(react.Fragment)
        end

        local v27 = if type(v15) == "number" then 0.4 + v15 * 0.6 else v15:map(function(p1) -- line: 161
            return 0.4 + p1 * 0.6
        end)

        if v11 then
            local t1 = {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0)
            }

            t1.Position = UDim2.fromScale(0.5, 0.1) + UDim2.fromOffset(0, GuiService:GetGuiInset().Y)
            t1.Size = UDim2.fromScale(0.55, 0.07)
            v11 = react.createElement("frame", t1, react.createElement(default2, {
                zIndex = 1,
                backgroundTransparency = v27
            }), react.createElement(default, {
                text = "You can upgrade aquarium!",
                color = Color3.new(1, 1, 1),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 2,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Font = v3.textFont2,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(0.95, 0.85),
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                strokeProps = {
                    Thickness = 0.06
                },
                textTransparency = v15
            }))
        end

        return react.createElement(react.Fragment, nil, v11, v20 ~= nil and react.createElement(default3, {
            targetAttachment = v20
        }))
    end)
}
