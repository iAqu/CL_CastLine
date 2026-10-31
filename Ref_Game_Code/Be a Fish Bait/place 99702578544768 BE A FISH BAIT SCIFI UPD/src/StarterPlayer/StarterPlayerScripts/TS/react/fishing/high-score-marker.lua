-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelector
local selectPlayerStat = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerStat
local selectHighScoreShown = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors").selectHighScoreShown
local highScoreMarkerPartAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "controllers", "high-score-marker-controller").highScoreMarkerPartAtom
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-theme").useTheme
local v1 = tostring(Players.LocalPlayer.UserId)
local t1 = {
    Thickness = 0.125,
    StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
}

return {
    default = function() -- HighScoreMarker | line: 26
        -- upvalues: react (copy), useEffect (copy), useState (copy), createPortal (copy), subscribe (copy), Workspace (copy), useRootSelector (copy), selectPlayerStat (copy), selectHighScoreShown (copy), highScoreMarkerPartAtom (copy), default (copy), useTheme (copy), v1 (copy), t1 (copy)
        local v2, v3 = useState(highScoreMarkerPartAtom())
        local v4 = useRootSelector(selectPlayerStat(v1, "highScoreDistance"))
        local v5 = useRootSelector(selectHighScoreShown(v1))
        local v6 = useTheme()

        useEffect(function() -- line: 31
            -- upvalues: v3 (copy), subscribe (copy), highScoreMarkerPartAtom (copy)
            return subscribe(highScoreMarkerPartAtom, v3)
        end, {})

        if v2 == nil or v4 == nil or v4 == 0 or v5 == false then
            return react.createElement(react.Fragment)
        end

        local CFramePosition, LookVector = v2.CFrame.Position, v2.CFrame.LookVector
        local Unit = Vector3.new(LookVector.X, 0, LookVector.Z).Unit
        local v7 = CFrame.lookAt(CFramePosition, CFramePosition + Unit) * CFrame.new(0, 93, 0)

        return createPortal(react.createElement("part", {
            Anchored = true,
            CanCollide = false,
            CanQuery = false,
            CanTouch = false,
            CastShadow = false,
            Size = Vector3.new(200, 60, 2),
            Transparency = 1,
            key = "TEST",
            CFrame = v7
        }, react.createElement("surfacegui", {
            AlwaysOnTop = false,
            LightInfluence = 0,
            PixelsPerStud = 1,
            Face = Enum.NormalId.Front,
            SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default, {
            text = "High Score",
            color = Color3.new(1, 1, 0),
            overrideProps = {
                LayoutOrder = 0,
                TextScaled = true,
                Font = v6.textFont2,
                Size = UDim2.fromScale(1, 0.45),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = t1
        }), react.createElement(default, {
            color = Color3.new(1, 1, 1),
            overrideProps = {
                LayoutOrder = 1,
                TextScaled = true,
                Font = v6.textFont2,
                Size = UDim2.fromScale(1, 0.45),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = t1,
            text = ("%* studs"):format((math.floor(v4)))
        })))), Workspace)
    end
}
