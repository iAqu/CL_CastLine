-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useRef, useState = react.useCallback, react.useRef, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ReplicatedStorage, Workspace = services.ReplicatedStorage, services.Workspace
local usePrefab = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "hooks", "use-prefab").usePrefab
local useRootSelectorCreator = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelectorCreator
local selectPlayerAquarium = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerAquarium
local default = RuntimeLib.import(script, script.Parent, "money-per-second-sign-surface-gui").default

return {
    default = function(p1) -- AquariumMoneyPerSecondSignRenderer | line: 16
        -- upvalues: react (copy), useCallback (copy), useRef (copy), useState (copy), ReplicatedStorage (copy), Workspace (copy), usePrefab (copy), useRootSelectorCreator (copy), selectPlayerAquarium (copy), default (copy)
        local ownerUserId, plotInstance = p1.ownerUserId, p1.plotInstance
        local v1 = useRef(nil)
        local v2, v3 = useState(nil)
        local v4 = useRootSelectorCreator(selectPlayerAquarium, (tostring(ownerUserId)))

        if v4 ~= nil then
            v4 = v4.moneyPerSecond
        end

        if v4 == nil then
            v4 = 0
        end

        usePrefab({
            getPrefabInstance = useCallback(function() -- line: 31
                -- upvalues: ReplicatedStorage (copy)
                local PlotStuff = ReplicatedStorage:FindFirstChild("PlotStuff")

                if PlotStuff ~= nil then
                    PlotStuff = PlotStuff:FindFirstChild("AquariumMoneyPerSecondSign")
                end

                return PlotStuff
            end, {}),
            onPrefabInstantiated = useCallback(function(p2) -- line: 38
                -- upvalues: ownerUserId (copy), plotInstance (copy), v1 (copy), v3 (copy), Workspace (copy)
                p2:SetAttribute("ownerUserId", (tostring(ownerUserId)))
                p2.Parent = Workspace

                local BoundingBox, BoundingBox2 = p2:GetBoundingBox()
                local Pivot = p2:GetPivot()
                local WorldCFrame = plotInstance.MoneyPerSecondSignPos.WorldCFrame
                local WorldCFramePosition = WorldCFrame.Position
                local v7 = BoundingBox.Position.Y - BoundingBox2.Y / 2
                local v8 = WorldCFramePosition.Y + (Pivot.Position.Y - v7)

                p2:PivotTo(CFrame.new(WorldCFramePosition.X, v8, WorldCFramePosition.Z) * WorldCFrame.Rotation)
                v1.current = p2
                v3(p2.BillboardPart)
            end, { ownerUserId, plotInstance }),
            parent = plotInstance
        })

        if v2 then
            return react.createElement(default, {
                adornPart = v2,
                moneyPerSecond = v4,
                signInstance = v2
            })
        end

        return react.createElement(react.Fragment)
    end
}
