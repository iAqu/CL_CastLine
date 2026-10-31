-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images")
local images2, fishImages = images.images, images.fishImages
local rarityColorGradients = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColorGradients
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "mutation-roll-utils")
local getMutationColorGradient, getMutationsPlainText, getMutationsRichText, getMutationsShadowText = v1.getMutationColorGradient, v1.getMutationsPlainText, v1.getMutationsRichText, v1.getMutationsShadowText
local getMutatedMoneyPerSecond = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-utils").getMutatedMoneyPerSecond
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName
local useLoopingGradientRotation = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "use-exclusive-gradient-rotation").useLoopingGradientRotation
local t1 = {
    common = Color3.fromRGB(200, 200, 200),
    uncommon = Color3.fromRGB(100, 255, 80),
    rare = Color3.fromRGB(110, 200, 255),
    epic = Color3.fromRGB(210, 100, 255),
    legendary = Color3.fromRGB(255, 230, 80),
    mythic = Color3.fromRGB(255, 70, 70),
    godly = Color3.fromRGB(255, 235, 130),
    secret = Color3.fromRGB(100, 100, 100),
    hacked = Color3.fromRGB(100, 255, 100),
    cosmic = Color3.fromRGB(255, 100, 255),
    extinct = Color3.fromRGB(205, 133, 63),
    kaijuwu = Color3.fromRGB(0, 255, 210),
    scifi = Color3.fromRGB(65, 184, 255),
    exclusive = Color3.fromRGB(255, 255, 255)
}
local bonusFish = fishImages.bonusFish

return {
    default = function(p1) -- FishRollItem | line: 45
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useMotion (copy), default (copy), images2 (copy), rarityColorGradients (copy), useTheme (copy), abbreviate (copy), Maid (copy), getMutationColorGradient (copy), getMutationsPlainText (copy), getMutationsRichText (copy), getMutationsShadowText (copy), getMutatedMoneyPerSecond (copy), getExclusiveFishConfigByFishName (copy), useLoopingGradientRotation (copy), t1 (copy), bonusFish (copy)
        local anchorPoint, rollingFishData, rollingIsBonus = p1.anchorPoint, p1.rollingFishData, p1.rollingIsBonus

        if rollingIsBonus == nil then
            rollingIsBonus = false
        end

        local finalFishData, finalIsBonus = p1.finalFishData, p1.finalIsBonus

        if finalIsBonus == nil then
            finalIsBonus = false
        end

        local finalIsJackpot = p1.finalIsJackpot

        if finalIsJackpot == nil then
            finalIsJackpot = false
        end

        local finalMutations, position, showRarity = p1.finalMutations, p1.position, p1.showRarity

        if showRarity == nil then
            showRarity = true
        end

        local size = p1.size
        local v2 = size

        if size == nil then
            v2 = UDim2.fromScale(0.075, 0.15)
        end

        local transparency, rollingMutations, zIndex = p1.transparency, p1.rollingMutations, p1.zIndex

        if zIndex == nil then
            zIndex = 1
        end

        local v3 = useTheme()
        local v4 = useRef(false)
        local v5 = useRef({
            isBonus = false,
            isJackpot = false,
            mutations = {}
        })
        local v6 = finalFishData ~= nil or finalIsBonus or finalIsJackpot
        local t2, v7

        if v6 and not v4.current then
            v4.current = true
            t2 = {
                fishData = finalFishData,
                isBonus = finalIsBonus,
                isJackpot = finalIsJackpot
            }
            v7 = finalMutations or {}
            t2.mutations = v7
            v5.current = t2
        end

        if v4.current then
            rollingIsBonus = v5.current.isBonus
        end

        local v8 = if v4.current then v5.current.isJackpot else false

        if v4.current then
            rollingFishData = v5.current.fishData
        end

        local v9 = if v4.current then v5.current.mutations else rollingMutations or {}
        local v10 = #v9 > 0
        local v11 = #v9 > 1
        local v13 = useLoopingGradientRotation(#v9 == 1 and v9[1] == "hoola3")
        local v14 = getMutationsPlainText(v9)
        local v15 = getMutationsShadowText(v9)

        if v11 then
            v14 = getMutationsRichText(v9)
        end

        local v16 = if showRarity then 0.73 else 0.765
        local v17 = if not v10 then 0.91 elseif showRarity then 0.97 else 0.9
        local v18 = if rollingFishData ~= nil and getExclusiveFishConfigByFishName(rollingFishData.name) ~= nil then 0 elseif rollingFishData == nil then 0 else getMutatedMoneyPerSecond(rollingFishData.moneyPerSecond, 1, v9)
        local v19 = useRef(360)
        local v20, v21 = useMotion(0)
        local v22 = v20:map(function(p2) -- line: 112
            return p2 % 360
        end)

        useEffect(function() -- line: 115
            -- upvalues: v19 (copy), v21 (copy)
            v21:linear(v19.current, {
                speed = 60
            })

            return (v21:onComplete(function() -- line: 119
                -- upvalues: v19 (copy), v21 (copy)
                v19.current += 360
                v21:linear(v19.current, {
                    speed = 60
                })
            end))
        end, { v21 })

        local v23, v24 = useMotion(0)
        local v25, v26 = useMotion(0.65)

        useEffect(function() -- line: 129
            -- upvalues: v6 (copy), v26 (copy)
            if not v6 then
                return nil
            end

            v26:spring(1, {
                frequency = 0.5,
                damping = 0.4
            })
        end, { v6, v26 })
        useEffect(function() -- line: 138
            -- upvalues: v6 (copy), v24 (copy), Maid (copy)
            if v6 then
                v24:spring(0, {
                    tension = 300,
                    friction = 20
                })

                return nil
            end

            v24:immediate(0)

            local v27 = Maid.new()

            v24:spring(-0.07, {
                tension = 800,
                friction = 25
            })

            local v28 = false

            v27:GiveTask(v24:onComplete(function() -- line: 154
                -- upvalues: v28 (ref), v24 (copy)
                if not v28 then
                    v28 = true
                    v24:spring(0, {
                        tension = 300,
                        friction = 20
                    })
                end
            end))

            return function() -- line: 163
                -- upvalues: v27 (copy)
                return v27:Destroy()
            end
        end, { rollingFishData, rollingIsBonus, v24, v6 })

        local v29 = if v8 then Color3.fromRGB(50, 150, 255)
            elseif rollingIsBonus then Color3.fromRGB(255, 230, 0)
            elseif rollingFishData == nil then Color3.fromRGB(200, 200, 200)
            else t1[rollingFishData.rarity]
        local v30 = rollingIsBonus or v8
        local v31

        if v8 then
            v31 = images2.jackpot
        elseif rollingIsBonus then
            v31 = bonusFish
        else
            v31 = if rollingFishData ~= nil then rollingFishData.imageId else rollingFishData

            if v31 == nil then
                v31 = ""
            end
        end

        local createElement = react.createElement
        local t3 = {
            BackgroundTransparency = 1,
            AnchorPoint = anchorPoint,
            Position = position,
            Size = v25:map(function(p3) -- line: 203
                -- upvalues: v2 (ref)
                return UDim2.new(v2.X.Scale * p3, v2.X.Offset, v2.Y.Scale * p3, v2.Y.Offset)
            end),
            ZIndex = zIndex
        }
        local createElement2 = react.createElement
        local t4 = {
            BackgroundTransparency = 1,
            Position = v23:map(function(p4) -- line: 209
                return UDim2.fromScale(0, p4)
            end),
            Size = UDim2.fromScale(1, 1)
        }
        local v32 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images2.shineBackground,
            ImageColor3 = v29,
            ImageTransparency = transparency,
            Position = UDim2.fromScale(0.5, 0.6),
            Rotation = v22,
            Size = UDim2.fromScale(2, 2),
            ZIndex = zIndex
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }))
        local v33 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ScaleType = "Fit",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = v31,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = transparency,
            Position = UDim2.fromScale(0.5, v30 and 0.62 or 0.5),
            Size = if v30 then UDim2.fromScale(1.2, 1.2) else UDim2.fromScale(0.8, 0.8),
            ZIndex = zIndex + 1
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }))
        local v34 = not v30 and rollingFishData ~= nil and react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                Size = UDim2.fromScale(2, 0.13),
                ZIndex = zIndex + 2,
                Font = v3.textFont2
            },
            position = UDim2.fromScale(0.5, 0.64),
            text = rollingFishData.displayName,
            textTransparency = transparency
        })
        local createElement4, default2, t6, v35, v36

        if v10 then
            local v37 = not v30

            if v37 then
                if rollingFishData ~= nil then
                    createElement4 = react.createElement
                    default2 = default
                    t6 = {
                        anchorPoint = Vector2.new(0.5, 0)
                    }
                    v35 = if v11 then Color3.fromRGB(255, 255, 255) else getMutationColorGradient(v9[1])
                    t6.color = v35

                    local v38 = if not v11 then v9[1] == "hoola3" else nil

                    if v11 or not v38 then
                        v13 = nil
                    end

                    t6.gradientRotation = v13
                    t6.overrideProps = {
                        TextScaled = true,
                        Size = UDim2.fromScale(2, 0.16),
                        ZIndex = zIndex + 2,
                        Font = v3.textFont2,
                        RichText = v11
                    }
                    t6.position = UDim2.fromScale(0.5, v16)

                    if not v11 then
                        v15 = nil
                    end

                    t6.shadowText = v15
                    t6.strokeProps = {
                        Color = Color3.fromRGB(0, 0, 0)
                    }
                    t6.text = v14
                    t6.textTransparency = transparency
                    v36 = createElement4(default2, t6)
                else
                    v36 = false
                end
            else
                v36 = v37
            end
        else
            v36 = v10
        end

        local createElement5, default3, t7, fromScale, v39, v40

        if showRarity then
            local v41 = not v30

            if v41 then
                if rollingFishData ~= nil then
                    createElement5 = react.createElement
                    default3 = default
                    t7 = {
                        anchorPoint = Vector2.new(0.5, 0),
                        color = rarityColorGradients[rollingFishData.rarity].color,
                        overrideProps = {
                            TextScaled = true,
                            ZIndex = 3,
                            Size = UDim2.fromScale(2, 0.18),
                            Font = v3.textFont2
                        }
                    }
                    fromScale = UDim2.fromScale
                    v39 = if v10 then 0.84 else 0.77
                    t7.position = fromScale(0.5, v39)
                    t7.strokeProps = {
                        Color = rarityColorGradients[rollingFishData.rarity].borderColor
                    }
                    t7.text = string.upper(rollingFishData.rarity)
                    t7.textTransparency = transparency
                    v40 = createElement5(default3, t7)
                else
                    v40 = false
                end
            else
                v40 = v41
            end
        else
            v40 = showRarity
        end

        local v42 = not v30 and rollingFishData ~= nil and react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0),
            color = Color3.fromRGB(100, 220, 80),
            overrideProps = {
                TextScaled = true,
                Size = UDim2.fromScale(2, 0.18),
                ZIndex = zIndex + 2,
                Font = v3.textFont2
            },
            position = UDim2.fromScale(0.5, v17),
            text = ("$%*/s"):format((abbreviate(v18))),
            textTransparency = transparency
        })

        return createElement("frame", t3, createElement2("frame", t4, v32, v33, v34, v36, v40, v42))
    end
}
