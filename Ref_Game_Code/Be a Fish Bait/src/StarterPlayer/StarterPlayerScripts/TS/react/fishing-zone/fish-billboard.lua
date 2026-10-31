-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useMemo = react.useMemo
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "styled-text-label").default
local v1 = RuntimeLib.import(script, script.Parent.Parent, "common", "use-exclusive-gradient-rotation")
local exclusiveEditionGradient, exclusiveMpsMultiplierGradient, useExclusiveGradientRotation, useLoopingGradientRotation = v1.exclusiveEditionGradient, v1.exclusiveMpsMultiplierGradient, v1.useExclusiveGradientRotation, v1.useLoopingGradientRotation
local moneyGradient = RuntimeLib.import(script, script.Parent.Parent, "screen", "hud", "stats-utils").moneyGradient
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils")
local getRarityBorderColor, rarityColorGradients = v2.getRarityBorderColor, v2.rarityColorGradients
local getMutationColorGradient = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "mutation-roll-utils").getMutationColorGradient
local getFishMutationDisplayName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mutations").getFishMutationDisplayName
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useTheme = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-theme").useTheme
local t1 = {
    common = "Common",
    uncommon = "Uncommon",
    rare = "Rare",
    epic = "Epic",
    legendary = "Legendary",
    mythic = "Mythic",
    godly = "Godly",
    secret = "Secret",
    hacked = "Hacked",
    cosmic = "Cosmic",
    extinct = "Extinct",
    kaijuwu = "KaijUwU",
    scifi = "Scifi",
    exclusive = "Exclusive"
}
local t2 = {
    sm = 0.8,
    md = 1.4,
    lg = 2
}
local t3 = {
    sm = UDim2.fromOffset(240, 78),
    md = UDim2.fromOffset(340, 110),
    lg = UDim2.fromOffset(450, 144)
}
local t4 = {
    sm = UDim2.fromOffset(240, 96),
    md = UDim2.fromOffset(340, 132),
    lg = UDim2.fromOffset(450, 172)
}
local t5 = {
    Thickness = 0.125,
    StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
}

return {
    default = function(p1) -- FishBillboard | line: 57
        -- upvalues: react (copy), useMemo (copy), createPortal (copy), default (copy), exclusiveEditionGradient (copy), exclusiveMpsMultiplierGradient (copy), useExclusiveGradientRotation (copy), useLoopingGradientRotation (copy), moneyGradient (copy), abbreviate (copy), getRarityBorderColor (copy), rarityColorGradients (copy), getMutationColorGradient (copy), getFishMutationDisplayName (copy), useScreenSizeState (copy), useTheme (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy)
        local adornee, exclusiveEditionLabel, exclusiveMpsMultiplier, isVisible = p1.adornee, p1.exclusiveEditionLabel, p1.exclusiveMpsMultiplier, p1.isVisible

        if isVisible == nil then
            isVisible = true
        end

        local level, model, moneyPerSecond, mutations = p1.level, p1.model, p1.moneyPerSecond, p1.mutations
        local name, rarity, exclusiveIndex, exclusiveTotalStock = p1.name, p1.rarity, p1.exclusiveIndex, p1.exclusiveTotalStock
        local v3 = useScreenSizeState()
        local v4 = t2[v3]
        local v5 = useExclusiveGradientRotation(rarity == "exclusive")
        local v6 = useMemo(function() -- line: 76
            -- upvalues: mutations (copy)
            return mutations or {}
        end, { mutations })
        local v7 = useLoopingGradientRotation(table.find(v6, "hoola3") ~= nil)
        local v8 = if model:FindFirstChild("__FishMouthAnchor", true) then Vector3.new(0, v4, 0) else Vector3.new(0, model:GetExtentsSize().Y / 2 + v4, 0)
        local v10 = #v6 > 0

        if exclusiveEditionLabel == nil then
            exclusiveEditionLabel = if exclusiveIndex == nil then nil elseif exclusiveTotalStock ~= nil then ("#%* / %*"):format(exclusiveIndex, exclusiveTotalStock) else ("#%*"):format(exclusiveIndex)
        end

        local v11 = exclusiveEditionLabel ~= nil
        local v12 = if v11 then t4[v3] else t3[v3]
        local v13 = useTheme()
        local v14 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })

        if v10 then
            local v15 = react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            })
            local v16 = table.create(#v6)

            local function v17(p2, p3) -- line: 108
                -- upvalues: v6 (copy), v7 (copy), react (copy), default (copy), getMutationColorGradient (copy), getFishMutationDisplayName (copy), t5 (copy)
                return react.createElement(react.Fragment, {
                    key = p2
                }, react.createElement(default, {
                    color = getMutationColorGradient(p2),
                    gradientRotation = if p2 == "hoola3" then v7 else nil,
                    overrideProps = {
                        AutomaticSize = Enum.AutomaticSize.X,
                        LayoutOrder = p3 * 2,
                        Size = UDim2.fromScale(0, 1),
                        TextXAlignment = Enum.TextXAlignment.Center
                    },
                    strokeProps = t5,
                    text = getFishMutationDisplayName(p2)
                }), p3 < #v6 - 1 and react.createElement(default, {
                    text = ", ",
                    color = Color3.new(1, 1, 1),
                    overrideProps = {
                        AutomaticSize = Enum.AutomaticSize.X,
                        LayoutOrder = p3 * 2 + 1,
                        Size = UDim2.fromScale(0, 1),
                        TextXAlignment = Enum.TextXAlignment.Center
                    },
                    strokeProps = t5
                }))
            end

            for v18, v19 in v6 do
                v16[v18] = v17(v19, v18 - 1, v6)
            end

            v10 = react.createElement("frame", {
                BackgroundTransparency = 1,
                LayoutOrder = 0,
                Size = UDim2.fromScale(1, 0.16)
            }, v15, v16)
        end

        if v11 then
            local t8 = {
                color = exclusiveEditionGradient,
                gradientRotation = v5,
                overrideProps = {
                    LayoutOrder = 1,
                    Font = v13.textFont2,
                    Size = UDim2.fromScale(1, 0.2),
                    TextXAlignment = Enum.TextXAlignment.Center
                }
            }
            local v20 = table.clone(t5)

            setmetatable(v20, nil)
            v20.Color = Color3.fromRGB(0, 0, 0)
            t8.strokeProps = v20
            t8.text = exclusiveEditionLabel
            v11 = react.createElement(default, t8)
        end

        local v21 = react.createElement(default, {
            color = Color3.new(1, 1, 1),
            overrideProps = {
                LayoutOrder = 2,
                Font = v13.textFont2,
                Size = UDim2.fromScale(1, 0.22),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = t5,
            text = name
        })
        local v22 = if exclusiveMpsMultiplier ~= nil then react.createElement(default, {
            color = exclusiveMpsMultiplierGradient,
            gradientRotation = v5,
            overrideProps = {
                LayoutOrder = 3,
                Font = v13.textFont2,
                Size = UDim2.fromScale(1, 0.2),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = t5,
            text = ("%*%% of best fish"):format((math.round(exclusiveMpsMultiplier * 100)))
        })
            elseif level ~= nil then react.createElement(default, {
                overrideProps = {
                    LayoutOrder = 3,
                    Font = v13.textFont2,
                    Size = UDim2.fromScale(1, 0.2),
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                strokeProps = t5,
                text = ("Level %*"):format(level)
            })
            else nil
        local t10 = {
            color = rarityColorGradients[rarity].color,
            gradientRotation = if rarity ~= "exclusive" then nil else v5,
            overrideProps = {
                LayoutOrder = 4,
                Font = v13.textFont2,
                Size = UDim2.fromScale(1, 0.2),
                TextXAlignment = Enum.TextXAlignment.Center
            }
        }
        local v24 = table.clone(t5)

        setmetatable(v24, nil)
        v24.Color = getRarityBorderColor(rarity)
        t10.strokeProps = v24
        t10.text = t1[rarity]

        return createPortal(react.createElement("billboardgui", {
            AlwaysOnTop = true,
            LightInfluence = 0,
            MaxDistance = 150,
            Enabled = isVisible,
            Size = v12,
            StudsOffsetWorldSpace = v8
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, v14, v10, v11, v21, v22, react.createElement(default, t10), react.createElement(default, {
            color = moneyGradient,
            overrideProps = {
                LayoutOrder = 5,
                Size = UDim2.fromScale(1, 0.2),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = t5,
            text = ("$%*/s"):format((abbreviate(moneyPerSecond)))
        }))), adornee)
    end
}
