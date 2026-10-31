-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "list-scrolling-frame").default
local usePlayers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "hooks", "use-players").usePlayers
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(218, 72, 240)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(157, 35, 201))
})

return {
    default = function(p1) -- StoreGiftRecipientPicker | line: 17
        -- upvalues: react (copy), useEffect (copy), useState (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), usePlayers (copy), localPlayerUserId (copy), images (copy), useTheme (copy), functions (copy), v1 (copy)
        local v2 = useTheme()
        local v3 = usePlayers()
        local t1 = {}

        local function v4(p2) -- line: 22
            -- upvalues: localPlayerUserId (copy)
            return tostring(p2.UserId) ~= localPlayerUserId
        end

        local n1 = 0

        for v5, v6 in v3 do
            local _ = v5 - 1

            if tostring(v6.UserId) ~= localPlayerUserId == true then
                n1 += 1
                t1[n1] = v6
            end
        end

        local v7, v8 = useState({})

        useEffect(function() -- line: 35
            -- upvalues: p1 (copy), v8 (copy), functions (copy)
            local v9 = false

            functions.getGiftRecipientsOwnership(p1.productId):andThen(function(p3) -- line: 37
                -- upvalues: v9 (ref), v8 (copy)
                if not v9 then
                    v8(p3)
                end
            end):catch(function() -- line: 41
            end)

            return function() -- line: 42
                -- upvalues: v9 (ref)
                v9 = true
            end
        end, { p1.productId })

        local v10

        if #t1 == 0 then
            v10 = react.createElement(default2, {
                text = "No other players in the server.",
                anchorPoint = Vector2.new(0.5, 0.5),
                color = Color3.fromRGB(220, 220, 220),
                overrideProps = {
                    TextScaled = true,
                    TextWrapped = true,
                    ZIndex = 204,
                    Size = UDim2.fromScale(0.85, 0.2)
                },
                position = UDim2.fromScale(0.5, 0.3),
                strokeProps = {
                    Thickness = 0.05
                }
            })
        else
            local v11 = table.create(#t1)

            local function v12(p4) -- line: 66
                -- upvalues: p1 (copy), v2 (copy), v7 (copy), react (copy), default2 (copy), default3 (copy), v1 (copy)
                local v14 = v7[tostring(p4.UserId)]

                if v14 == nil then
                    v14 = false
                end

                return react.createElement("frame", {
                    BorderSizePixel = 0,
                    ZIndex = 205,
                    BackgroundColor3 = Color3.fromRGB(10, 8, 12),
                    BackgroundTransparency = v14 and 0.4 or 0,
                    LayoutOrder = p4.UserId,
                    Size = UDim2.fromScale(0.97, 0.22),
                    key = tostring(p4.UserId)
                }, react.createElement("uicorner", {
                    CornerRadius = UDim.new(0.09, 0)
                }), react.createElement("uistroke", {
                    Thickness = 0.025,
                    Color = Color3.fromRGB(0, 0, 0),
                    StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
                }), react.createElement("imagelabel", {
                    BackgroundTransparency = 1,
                    ZIndex = 206,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(p4.UserId),
                    ImageTransparency = v14 and 0.5 or 0,
                    Position = UDim2.fromScale(0.025, 0.5),
                    ScaleType = Enum.ScaleType.Crop,
                    Size = UDim2.fromScale(0.2, 0.84)
                }, react.createElement("uiaspectratioconstraint", {
                    AspectRatio = 1,
                    DominantAxis = Enum.DominantAxis.Height
                }), react.createElement("uicorner", {
                    CornerRadius = UDim.new(0.12, 0)
                })), react.createElement(default2, {
                    anchorPoint = Vector2.new(0, 0),
                    color = Color3.new(1, 1, 1),
                    overrideProps = {
                        TextScaled = true,
                        ZIndex = 206,
                        Font = v2.textFont2,
                        Size = UDim2.fromScale(0.7, 0.42),
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        TextXAlignment = Enum.TextXAlignment.Left
                    },
                    position = UDim2.fromScale(0.25, 0.05),
                    strokeProps = {
                        Thickness = 0.05
                    },
                    text = p4.DisplayName
                }), if v14 then react.createElement(default2, {
                    text = "Already owns this",
                    anchorPoint = Vector2.new(0, 1),
                    color = Color3.fromRGB(220, 220, 220),
                    overrideProps = {
                        TextScaled = true,
                        ZIndex = 206,
                        Font = v2.textFont,
                        Size = UDim2.fromScale(0.7, 0.24),
                        TextXAlignment = Enum.TextXAlignment.Left
                    },
                    position = UDim2.fromScale(0.25, 0.7),
                    strokeProps = {
                        Thickness = 0.05
                    }
                }) else react.createElement(default3, {
                    cornerRadius = 0.12,
                    label = "Select",
                    zIndex = 206,
                    anchorPoint = Vector2.new(0, 1),
                    color = v1,
                    frameSize = UDim2.fromScale(0.36, 0.42),
                    onClick = function() -- onClick | line: 138
                        -- upvalues: p4 (copy), p1 (copy)
                        return p1.onSelect(p4)
                    end,
                    popoutColor = Color3.fromRGB(104, 25, 137),
                    position = UDim2.fromScale(0.25, 0.92)
                }))
            end

            for v20, v21 in t1 do
                v11[v20] = v12(v21, v20 - 1, t1)
            end

            v10 = react.createElement(default4, {
                itemPaddingScale = 0.025,
                scrollBarThickness = 5,
                zIndex = 204,
                anchorPoint = Vector2.new(0.5, 0),
                canvasHeightScale = math.max(1, #t1 * 0.25),
                position = UDim2.fromScale(0.5, 0),
                scrollBarColor = Color3.fromRGB(191, 55, 224),
                size = UDim2.fromScale(1, 1)
            }, v11)
        end

        return react.createElement("frame", {
            Active = true,
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            ZIndex = 100,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default, {
            aspectRatio = 0.82,
            bodyTransparency = 0.32,
            title = "",
            zIndexOffset = 200,
            bodyBg = Color3.fromRGB(20, 12, 24),
            closeButtonPosition = UDim2.fromScale(0.95, 0.5),
            headerBg = v1,
            headerNode = react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 221,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(0.025, 0.5),
                Size = UDim2.fromScale(0.8, 0.8)
            }, react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0.025, 0),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }), react.createElement("imagelabel", {
                BackgroundTransparency = 1,
                LayoutOrder = 0,
                ZIndex = 222,
                Image = images.giftBox,
                ScaleType = Enum.ScaleType.Fit,
                Size = UDim2.fromScale(0.16, 1)
            }, react.createElement("uiaspectratioconstraint", {
                AspectRatio = 1,
                DominantAxis = Enum.DominantAxis.Height
            })), react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 1,
                ZIndex = 222,
                Size = UDim2.fromScale(0.75, 0.9)
            }, react.createElement(default2, {
                text = "Select Player",
                anchorPoint = Vector2.new(0, 0.5),
                color = Color3.new(1, 1, 1),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 222,
                    Font = v2.textFont2,
                    Size = UDim2.fromScale(1, 1),
                    TextXAlignment = Enum.TextXAlignment.Left
                },
                position = UDim2.fromScale(0, 0.5),
                strokeProps = {
                    Thickness = 0.055
                }
            }))),
            onClose = p1.onClose,
            size = UDim2.fromScale(0.35, 0.58)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 203,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.54),
            Size = UDim2.fromScale(0.9, 0.82)
        }, v10)))
    end
}
