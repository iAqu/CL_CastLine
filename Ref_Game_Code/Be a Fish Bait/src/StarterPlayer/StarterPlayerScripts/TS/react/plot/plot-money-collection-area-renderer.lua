-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useRef, useState = react.useCallback, react.useRef, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ReplicatedStorage, Workspace = services.ReplicatedStorage, services.Workspace
local usePrefab = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "hooks", "use-prefab").usePrefab
local useRootSelectorCreator = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelectorCreator
local selectPlayerAquariumUncollectedMoney = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerAquariumUncollectedMoney
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId

return {
    default = function(p1) -- PlotMoneyCollectionAreaRenderer | line: 19
        -- upvalues: react (copy), useCallback (copy), useRef (copy), useState (copy), createPortal (copy), ReplicatedStorage (copy), Workspace (copy), usePrefab (copy), useRootSelectorCreator (copy), selectPlayerAquariumUncollectedMoney (copy), default (copy), abbreviate (copy), localPlayerUserId (copy)
        local ownerUserId, plotInstance = p1.ownerUserId, p1.plotInstance
        local v1 = useRef(nil)
        local v2, v3 = useState(nil)
        local v4 = useRootSelectorCreator(selectPlayerAquariumUncollectedMoney, localPlayerUserId)

        usePrefab({
            getPrefabInstance = useCallback(function() -- line: 25
                -- upvalues: ReplicatedStorage (copy)
                local PlotStuff = ReplicatedStorage:FindFirstChild("PlotStuff")

                if PlotStuff ~= nil then
                    PlotStuff = PlotStuff:FindFirstChild("PlotMoneyCollectionArea")
                end

                return PlotStuff
            end, {}),
            onPrefabInstantiated = useCallback(function(p2) -- line: 32
                -- upvalues: ownerUserId (copy), plotInstance (copy), v1 (copy), v3 (copy), Workspace (copy)
                p2:SetAttribute("ownerUserId", (tostring(ownerUserId)))
                p2.Parent = Workspace

                local BoundingBox, BoundingBox2 = p2:GetBoundingBox()
                local Pivot = p2:GetPivot()
                local WorldCFrame = plotInstance.MoneyCollectionAreaPos.WorldCFrame
                local WorldCFramePosition = WorldCFrame.Position
                local v7 = BoundingBox.Position.Y - BoundingBox2.Y / 2
                local v8 = WorldCFramePosition.Y + (Pivot.Position.Y - v7)

                p2:PivotTo(CFrame.new(WorldCFramePosition.X, v8, WorldCFramePosition.Z) * (WorldCFrame.Rotation * CFrame.Angles(0, 0, 0)))
                v1.current = p2
                v3(p2.MoneyEarnedDisplay)
            end, { ownerUserId, plotInstance }),
            parent = plotInstance
        })

        if v2 then
            return react.createElement(react.Fragment, nil, createPortal(react.createElement("surfacegui", {
                AlwaysOnTop = true,
                Adornee = v2,
                CanvasSize = Vector2.new(400, 100),
                Face = Enum.NormalId.Front,
                SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
            }, react.createElement("frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }, react.createElement("uipadding", {
                PaddingBottom = UDim.new(0.2, 0),
                PaddingLeft = UDim.new(0.05, 0),
                PaddingRight = UDim.new(0.05, 0),
                PaddingTop = UDim.new(0.2, 0)
            }), react.createElement(default, {
                shadowYScale = 0.05,
                color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 213, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 140, 0))
                }),
                overrideProps = {
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    ZIndex = 100,
                    Size = UDim2.fromScale(1, 1),
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                text = ("$%*"):format((abbreviate(v4)))
            }))), v2))
        end

        return react.createElement(react.Fragment)
    end
}
