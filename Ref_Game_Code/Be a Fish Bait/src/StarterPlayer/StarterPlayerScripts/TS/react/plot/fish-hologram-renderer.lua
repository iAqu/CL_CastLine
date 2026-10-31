-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect = react.useCallback, react.useEffect
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players, Workspace = services.CollectionService, services.Players, services.Workspace
local usePrefab = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "hooks", "use-prefab").usePrefab
local clientProducer = RuntimeLib.import(script, script.Parent.Parent.Parent, "reflex", "producer").clientProducer
local useRootSelectorCreator = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelectorCreator
local selectPlayerEquippedHologramSkin = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerEquippedHologramSkin
local getHologramSkinData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "hologram-skins").getHologramSkinData

return {
    default = function(p1) -- FishHologramRenderer | line: 18
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), CollectionService (copy), Players (copy), Workspace (copy), usePrefab (copy), clientProducer (copy), useRootSelectorCreator (copy), selectPlayerEquippedHologramSkin (copy), getHologramSkinData (copy)
        local ownerUserId, plotInstance = p1.ownerUserId, p1.plotInstance
        local v1 = tostring(Players.LocalPlayer.UserId) == tostring(ownerUserId)
        local v2 = useRootSelectorCreator(selectPlayerEquippedHologramSkin, (tostring(ownerUserId)))

        if v2 == nil then
            v2 = "Default"
        end

        local prefabInstance = usePrefab({
            getPrefabInstance = useCallback(function() -- line: 28
                -- upvalues: v2 (ref), getHologramSkinData (copy)
                return getHologramSkinData(v2).model
            end, { v2 }),
            onPrefabInstantiated = useCallback(function(p2) -- line: 31
                -- upvalues: ownerUserId (copy), plotInstance (copy), CollectionService (copy), Workspace (copy)
                p2:SetAttribute("ownerUserId", (tostring(ownerUserId)))
                CollectionService:AddTag(p2, "HologramBase")
                p2.Parent = Workspace

                local BoundingBox, BoundingBox2 = p2:GetBoundingBox()
                local Pivot = p2:GetPivot()
                local WorldCFrame = plotInstance.FishHologramPos.WorldCFrame
                local WorldCFramePosition = WorldCFrame.Position
                local v5 = BoundingBox.Position.Y - BoundingBox2.Y / 2
                local v6 = WorldCFramePosition.Y + (Pivot.Position.Y - v5)

                p2:PivotTo(CFrame.new(WorldCFramePosition.X, v6, WorldCFramePosition.Z) * WorldCFrame.Rotation)
            end, { ownerUserId, plotInstance }),
            parent = plotInstance
        }).prefabInstance

        useEffect(function() -- line: 53
            -- upvalues: prefabInstance (copy), v1 (copy), clientProducer (copy)
            if not (prefabInstance and v1) then
                return nil
            end

            local PrimaryPart = prefabInstance.PrimaryPart or prefabInstance:FindFirstChild("Particles") or prefabInstance:FindFirstChildWhichIsA("BasePart", true)

            if not PrimaryPart then
                return nil
            end

            local ProximityPrompt = Instance.new("ProximityPrompt")

            ProximityPrompt.ActionText = "Manage Fish Display"
            ProximityPrompt.ObjectText = ""
            ProximityPrompt.MaxActivationDistance = 12
            ProximityPrompt.HoldDuration = 0
            ProximityPrompt.RequiresLineOfSight = false
            ProximityPrompt.Parent = PrimaryPart

            local connection = ProximityPrompt.Triggered:Connect(function() -- line: 68
                -- upvalues: clientProducer (copy)
                clientProducer.windowOpened({
                    currentWindow = "fishDisplayMenu"
                })
            end)

            return function() -- line: 73
                -- upvalues: ProximityPrompt (copy), connection (copy)
                connection:Disconnect()
                ProximityPrompt:Destroy()
            end
        end, { v1, prefabInstance })

        return react.createElement(react.Fragment)
    end
}
