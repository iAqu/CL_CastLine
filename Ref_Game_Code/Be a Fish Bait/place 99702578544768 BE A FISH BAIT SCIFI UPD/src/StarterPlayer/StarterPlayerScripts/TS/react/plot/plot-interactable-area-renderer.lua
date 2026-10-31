-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback = react.useCallback
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ReplicatedStorage, Workspace = services.ReplicatedStorage, services.Workspace
local usePrefab = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "hooks", "use-prefab").usePrefab

return {
    default = function(p1) -- PlotInteractableAreaRenderer | line: 11
        -- upvalues: react (copy), useCallback (copy), ReplicatedStorage (copy), Workspace (copy), usePrefab (copy)
        local ownerUserId, plotInstance = p1.ownerUserId, p1.plotInstance

        usePrefab({
            getPrefabInstance = useCallback(function() -- line: 14
                -- upvalues: ReplicatedStorage (copy)
                local PlotStuff = ReplicatedStorage:FindFirstChild("PlotStuff")

                if PlotStuff ~= nil then
                    PlotStuff = PlotStuff:FindFirstChild("PlotInteractableArea")
                end

                return PlotStuff
            end, {}),
            onPrefabInstantiated = useCallback(function(p2) -- line: 21
                -- upvalues: ownerUserId (copy), plotInstance (copy), Workspace (copy)
                p2:SetAttribute("ownerUserId", (tostring(ownerUserId)))
                p2.Parent = Workspace

                local BoundingBox, BoundingBox2 = p2:GetBoundingBox()
                local Pivot = p2:GetPivot()
                local WorldCFrame = plotInstance.InteractableAreaPos.WorldCFrame
                local WorldCFramePosition = WorldCFrame.Position
                local v3 = BoundingBox.Position.Y - BoundingBox2.Y / 2
                local v4 = WorldCFramePosition.Y + (Pivot.Position.Y - v3)

                p2:PivotTo(CFrame.new(WorldCFramePosition.X, v4, WorldCFramePosition.Z) * (WorldCFrame.Rotation * CFrame.Angles(1.5707963267948966, 0, 0)))
            end, { ownerUserId, plotInstance }),
            parent = plotInstance
        })

        return react.createElement(react.Fragment)
    end
}
