-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local getRarityColor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").getRarityColor
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "shiny-overlay").default
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local getMutationColor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "mutation-roll-utils").getMutationColor
local getFishMutationDisplayName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mutations").getFishMutationDisplayName
local t1 = {
    sm = 6,
    md = 10,
    lg = 14
}

return {
    default = function(p1) -- Tooltip | line: 20
        -- upvalues: react (copy), useContext (copy), default (copy), getRarityColor (copy), ThemeContext (copy), useScreenSizeState (copy), default2 (copy), abbreviate (copy), getMutationColor (copy), getFishMutationDisplayName (copy), t1 (copy)
        local v1 = useContext(ThemeContext)
        local v3 = t1[useScreenSizeState()]
        local v4 = getRarityColor(p1.rarity)
        local zIndex = p1.zIndex

        if zIndex == nil then
            zIndex = 10000
        end

        local v5 = p1.exclusiveEditionLabel ~= nil
        local t2 = {}

        if p1.moneyPerSecond ~= nil then
            table.insert(t2, {
                text = ("+%*$/s"):format((abbreviate(p1.moneyPerSecond))),
                color = Color3.fromRGB(255, 220, 50)
            })
        end

        if p1.powerCap ~= nil then
            table.insert(t2, {
                text = ("Power Cap: %*"):format((abbreviate(p1.powerCap))),
                color = Color3.fromRGB(255, 160, 50)
            })
        end

        for _, v6 in p1.mutations or {} do
            table.insert(t2, {
                text = getFishMutationDisplayName(v6),
                color = getMutationColor(v6)
            })
        end

        local v7 = #t2
        local v8 = v7 * 0.2 + 0.7 + (if v5 then 0.18 else 0)
        local v9 = if v7 == 0 then if v5 then 0.52 else 0.88
            elseif v7 == 1 then if v5 then 0.3 else 0.4
            elseif v7 ~= 2 then 0.19
            elseif v5 then 0.22
            else 0.28
        local v10 = if v7 == 0 then 0
            elseif v7 == 1 then 0.4
            elseif v7 == 2 then 0.28
            else 0.21
        local v11 = if v5 then 0.26 elseif v7 == 0 then 0.5 else 0.05
        local v12 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.1, 0)
        })
        local v13 = react.createElement(default2, {
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            zIndex = zIndex + 3
        })
        local v14 = react.createElement("uigradient", {
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(196, 196, 196))
            })
        })
        local v15 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.08, 0)
        })
        local v16 = p1.exclusiveEditionLabel ~= nil and react.createElement(default, {
            hasStroke = true,
            overrideProps = {
                TextScaled = true,
                AnchorPoint = Vector2.new(0.5, 0),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(0.5, 0.03),
                Size = UDim2.fromScale(0.9, 0.22),
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = zIndex + 5
            },
            strokeProps = {
                Thickness = 0.06,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = p1.exclusiveEditionLabel,
            textColor3 = Color3.new(1, 1, 1)
        }, react.createElement("uigradient", {
            Rotation = 0,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 245, 90)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(80, 255, 150)),
                ColorSequenceKeypoint.new(0.55, Color3.fromRGB(60, 210, 255)),
                ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 105, 230)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            })
        }))
        local v17 = react.createElement(default, {
            hasStroke = true,
            overrideProps = {
                TextScaled = true,
                AnchorPoint = Vector2.new(0.5, (v7 ~= 0 or v5) and 0 or 0.5),
                Position = UDim2.fromScale(0.5, v11),
                Size = UDim2.fromScale(0.9, v9),
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = zIndex + 4
            },
            strokeProps = {
                Thickness = 0.05,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = p1.itemName,
            textColor3 = Color3.new(1, 1, 1)
        }, react.createElement("uigradient", {
            Rotation = 90,
            Color = v4
        }))
        local v18 = table.create(#t2)

        local function v19(p2, p3) -- line: 117
            -- upvalues: v1 (copy), zIndex (ref), v7 (copy), v10 (copy), react (copy), default (copy)
            local v20 = 0.95 - (v7 - 1 - p3) * (v10 + 0.03)

            return react.createElement(default, {
                hasStroke = true,
                key = p2.text,
                overrideProps = {
                    TextScaled = true,
                    AnchorPoint = Vector2.new(0.5, 1),
                    Font = v1.textFont2,
                    Position = UDim2.fromScale(0.5, v20),
                    Size = UDim2.fromScale(0.9, v10),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = zIndex + 4
                },
                strokeProps = {
                    Thickness = 0.05,
                    Color = Color3.fromRGB(0, 0, 0)
                },
                text = p2.text,
                textColor3 = p2.color
            })
        end

        for v21, v22 in t2 do
            v18[v21] = v19(v22, v21 - 1, t2)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = p1.anchorPoint or Vector2.new(0.5, 1),
            Position = p1.position or UDim2.new(0.5, 0, 0, -6),
            Size = p1.size or UDim2.fromScale(1.6, v8),
            ZIndex = zIndex
        }, react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0, 0.2),
            Size = UDim2.fromScale(1, 0.88),
            ZIndex = zIndex + 1
        }, v12, react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.49),
            Size = UDim2.fromScale(0.94, 0.84),
            ZIndex = zIndex + 2
        }, v13, v14, v15, v16, v17, v18)), react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Rotation = 45,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(12, 12, 18),
            Position = UDim2.fromScale(0.5, 1.08),
            Size = UDim2.fromOffset(v3, v3),
            ZIndex = zIndex
        }))
    end
}
