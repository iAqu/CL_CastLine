-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "styled-text-label").default
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelector
local selectPlayerPlotLikes = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerPlotLikes
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

return {
    default = function(p1) -- PlotLikesBoardGui | line: 14
        -- upvalues: react (copy), useEffect (copy), useState (copy), createPortal (copy), Players (copy), default (copy), useRootSelector (copy), selectPlayerPlotLikes (copy), images (copy)
        local boardPart, boardInstance, ownerUserId = p1.boardPart, p1.boardInstance, p1.ownerUserId
        local v2 = useRootSelector(selectPlayerPlotLikes((tostring(ownerUserId))))
        local v3, v4 = useState(nil)
        local v5, v6 = useState(nil)

        useEffect(function() -- line: 23
            -- upvalues: ownerUserId (copy), v4 (copy), v6 (copy), Players (copy)
            if ownerUserId > -10 and ownerUserId < 0 then
                v4(nil)
                v6((("Test Player %*"):format(ownerUserId)))

                return nil
            end

            if ownerUserId > 0 then
                local v7 = task.spawn(function() -- line: 30
                    -- upvalues: ownerUserId (copy), v4 (copy), v6 (copy), Players (copy)
                    v4((Players:GetUserThumbnailAsync(ownerUserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)))
                    v6((Players:GetNameFromUserIdAsync(ownerUserId)))
                end)

                return function() -- line: 36
                    -- upvalues: v7 (copy)
                    return task.cancel(v7)
                end
            end
        end, { ownerUserId })

        if v5 == nil then
            v5 = "Unknown"
        end

        local v8 = ("%*'s Plot"):format(v5)
        local v9 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.03, 0),
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v10 = react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0.55, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0.02, 0),
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default, {
            overrideProps = {
                BackgroundTransparency = 1,
                TextScaled = true,
                TextWrapped = true,
                Size = UDim2.fromScale(1, 0.28),
                TextColor3 = Color3.new(1, 1, 1),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center
            },
            strokeProps = {
                Thickness = 1,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = v8
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0.25)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0.02, 0),
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            Image = images.thumbsUpIcon,
            Size = UDim2.fromScale(0.25, 0.9)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement(default, {
            overrideProps = {
                BackgroundTransparency = 1,
                TextScaled = true,
                Size = UDim2.fromScale(0.6, 0.9),
                TextColor3 = Color3.new(1, 1, 1),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center
            },
            strokeProps = {
                Thickness = 1
            },
            text = tostring(v2)
        })))
        local v11 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0.02, 0),
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local t1 = {
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        }

        t1.Image = if v3 == nil then "" else v3
        t1.Size = UDim2.fromScale(0.85, 0.85)

        return createPortal(react.createElement("surfacegui", {
            LightInfluence = 0,
            PixelsPerStud = 20,
            ResetOnSpawn = false,
            Adornee = boardPart,
            Face = Enum.NormalId.Left,
            SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, v9, v10, react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0.4, 1)
        }, v11, react.createElement("imagelabel", t1, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }))))), boardInstance)
    end
}
