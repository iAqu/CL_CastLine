-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect = react.useCallback, react.useEffect
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local usePlayers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "hooks", "use-players").usePlayers
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelectorCreator = reflex.useRootProducer, reflex.useRootSelectorCreator
local selectEquippedItemType = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectEquippedItemType
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId

local function PlayerGiftPrompt(p1) -- line: 14
    -- upvalues: useEffect (copy), Players (copy), useRootSelectorCreator (copy), selectEquippedItemType (copy), localPlayerUserId (copy)
    local player, onPromptTriggered = p1.player, p1.onPromptTriggered
    local v1 = useRootSelectorCreator(selectEquippedItemType, localPlayerUserId)
    local v2 = v1 ~= nil and v1 ~= "pickaxe" and v1 ~= "lavaBucket"

    useEffect(function() -- line: 20
        -- upvalues: player (copy), onPromptTriggered (copy), v2 (copy), Players (copy)
        if not v2 then
            return nil
        end

        local Character = player.Character

        if not Character then
            return nil
        end

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            return nil
        end

        local ProximityPrompt = Instance.new("ProximityPrompt")

        ProximityPrompt.Name = "GiftPrompt"
        ProximityPrompt.ActionText = "Gift Item"
        ProximityPrompt.ObjectText = player.DisplayName
        ProximityPrompt.MaxActivationDistance = 8
        ProximityPrompt.HoldDuration = 0.5
        ProximityPrompt.RequiresLineOfSight = false
        ProximityPrompt.GamepadKeyCode = Enum.KeyCode.ButtonA
        ProximityPrompt.Parent = HumanoidRootPart

        local connection = ProximityPrompt.Triggered:Connect(function(p2) -- line: 44
            -- upvalues: player (copy), onPromptTriggered (copy), Players (copy)
            if p2 ~= Players.LocalPlayer then
                return nil
            end

            onPromptTriggered((tostring(player.UserId)))
        end)
        local connection2 = player.CharacterAdded:Connect(function(_) -- line: 51
            -- upvalues: ProximityPrompt (copy)
            ProximityPrompt:Destroy()
        end)

        return function() -- line: 55
            -- upvalues: ProximityPrompt (copy), connection (copy), connection2 (copy)
            connection:Disconnect()
            connection2:Disconnect()
            ProximityPrompt:Destroy()
        end
    end, { v2, player, onPromptTriggered })

    return nil
end

return {
    default = function(_) -- GiftItemProximityPromptManager | line: 69
        -- upvalues: react (copy), useCallback (copy), usePlayers (copy), useRootProducer (copy), localPlayerUserId (copy), PlayerGiftPrompt (copy)
        local v3 = useRootProducer()
        local v4 = usePlayers()
        local v5 = useCallback(function(p5) -- line: 72
            -- upvalues: v3 (copy)
            v3.giftTargetSelected({
                targetPlayerUserId = p5
            })
            v3.windowOpened({
                currentWindow = "giftConfirmation"
            })
        end, { v3 })
        local t1 = {}

        local function v6(p6) -- line: 83
            -- upvalues: localPlayerUserId (copy)
            return tostring(p6.UserId) ~= localPlayerUserId
        end

        local n1 = 0

        for v7, v8 in v4 do
            local _ = v7 - 1

            if tostring(v8.UserId) ~= localPlayerUserId == true then
                n1 += 1
                t1[n1] = v8
            end
        end

        local v9 = table.create(#t1)

        for v10, v11 in t1 do
            local _ = v10 - 1

            v9[v10] = react.createElement(PlayerGiftPrompt, {
                key = tostring(v11.UserId),
                onPromptTriggered = v5,
                player = v11
            })
        end

        return react.createElement(react.Fragment, nil, v9)
    end
}
