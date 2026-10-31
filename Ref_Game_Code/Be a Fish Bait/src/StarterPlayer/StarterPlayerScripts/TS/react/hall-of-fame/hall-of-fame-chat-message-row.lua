-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useState = react.useCallback, react.useEffect, react.useState
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "styled-text-label").default
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootSelector, useRootSelectorCreator = reflex.useRootSelector, reflex.useRootSelectorCreator
local selectPlayerHasLikedHallOfFameMessage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerHasLikedHallOfFameMessage
local selectHallOfFameMessageLikeCount = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "hall-of-fame-likes.selectors").selectHallOfFameMessageLikeCount
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network").functions
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId

return {
    default = function(p1) -- HallOfFameChatMessageRow | line: 20
        -- upvalues: RuntimeLib (copy), react (copy), useCallback (copy), useEffect (copy), useState (copy), Players (copy), default (copy), useRootSelector (copy), useRootSelectorCreator (copy), selectPlayerHasLikedHallOfFameMessage (copy), selectHallOfFameMessageLikeCount (copy), images (copy), functions (copy), localPlayerUserId (copy)
        local message, rowHeight = p1.message, p1.rowHeight
        local id, displayName, text, userId = message.id, message.displayName, message.text, message.userId
        local v1, v2 = useState("http://www.roblox.com/asset/?id=75046617156863")
        local v3, v4 = useState(false)
        local v5 = rowHeight * 0.7
        local v6 = rowHeight * 0.5
        local v7 = -(v5 + v6 + 16)
        local v8 = useRootSelector(selectHallOfFameMessageLikeCount(id))
        local v9 = useRootSelectorCreator(selectPlayerHasLikedHallOfFameMessage, localPlayerUserId, id)

        useEffect(function() -- line: 38
            -- upvalues: userId (copy), v2 (copy), Players (copy)
            if userId <= 0 then
                return nil
            end

            local v10 = task.spawn(function() -- line: 42
                -- upvalues: userId (copy), v2 (copy), Players (copy)
                local UserThumbnailAsync, UserThumbnailAsync2 = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)

                if UserThumbnailAsync2 then
                    v2(UserThumbnailAsync)
                end
            end)

            return function() -- line: 48
                -- upvalues: v10 (copy)
                return task.cancel(v10)
            end
        end, { userId })

        local v11 = useCallback(function() -- line: 52
            -- upvalues: id (copy), v3 (copy), v4 (copy), v9 (copy), RuntimeLib (copy), functions (copy)
            if v9 or v3 then
                return nil
            end

            v4(true)
            task.spawn(RuntimeLib.async(function() -- line: 57
                -- upvalues: id (copy), v4 (copy), RuntimeLib (copy), functions (copy)
                RuntimeLib.await(functions.likeHallOfFameMessage(id))
                v4(false)
            end))
        end, { v9, v3, id })

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, rowHeight)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 8),
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Image = v1,
            Size = UDim2.fromOffset(v5, v5)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, v7, 1, 0)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default, {
            overrideProps = {
                BackgroundTransparency = 1,
                TextScaled = true,
                Size = UDim2.new(1, 0, 0, rowHeight * 0.35),
                TextColor3 = Color3.fromRGB(120, 200, 255),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            strokeProps = {
                Thickness = 1
            },
            text = displayName
        }), react.createElement(default, {
            overrideProps = {
                BackgroundTransparency = 1,
                TextScaled = true,
                TextWrapped = true,
                Size = UDim2.new(1, 0, 0, rowHeight * 0.6),
                TextColor3 = Color3.new(1, 1, 1),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top
            },
            strokeProps = {
                Thickness = 1
            },
            text = text
        })), react.createElement("imagebutton", {
            BackgroundTransparency = 1,
            Active = not v9,
            AutoButtonColor = not v9,
            Event = {
                Activated = v11
            },
            Image = images.thumbsUpIcon,
            ImageColor3 = if v9 then Color3.fromRGB(90, 255, 130) else Color3.fromRGB(200, 200, 200),
            Size = UDim2.fromOffset(v6, v6)
        }, react.createElement(default, {
            overrideProps = {
                BackgroundTransparency = 1,
                TextScaled = true,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 1),
                Size = UDim2.fromOffset(rowHeight, rowHeight * 0.3),
                TextColor3 = Color3.new(1, 1, 1)
            },
            strokeProps = {
                Thickness = 1
            },
            text = tostring(v8)
        })))
    end
}
