-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local v1 = RuntimeLib.import(script, script.Parent, "lucky-block-reward-visuals")
local formatLuckyBlockChancePercent, luckyBlockRewardVisuals = v1.formatLuckyBlockChancePercent, v1.luckyBlockRewardVisuals
local v2 = Color3.fromRGB(255, 255, 255)
local v3 = Color3.fromRGB(255, 210, 90)

return {
    default = function(p1) -- LuckyBlockRollItem | line: 16
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), Maid (copy), default (copy), formatLuckyBlockChancePercent (copy), luckyBlockRewardVisuals (copy), v2 (copy), v3 (copy)
        local v4 = luckyBlockRewardVisuals[p1.reward]
        local v5, v6 = useMotion(0)

        useEffect(function() -- line: 20
            -- upvalues: p1 (copy), v6 (copy), Maid (copy)
            if p1.isSettled then
                v6:spring(0, {
                    tension = 300,
                    friction = 20
                })

                return nil
            end

            v6:immediate(0)

            local v7 = Maid.new()

            v6:spring(-0.07, {
                tension = 800,
                friction = 25
            })

            local v8 = false

            v7:GiveTask(v6:onComplete(function() -- line: 35
                -- upvalues: v8 (ref), v6 (copy)
                if not v8 then
                    v8 = true
                    v6:spring(0, {
                        tension = 300,
                        friction = 20
                    })
                end
            end))

            return function() -- line: 44
                -- upvalues: v7 (copy)
                return v7:Destroy()
            end
        end, {
            p1.reward,
            p1.isSettled,
            v6
        })

        local v9, v10 = useMotion(1)

        useEffect(function() -- line: 51
            -- upvalues: p1 (copy), v10 (copy)
            if not p1.isSettled then
                v10:immediate(1)

                return nil
            end

            v10:immediate(1.25)
            v10:spring(1, {
                frequency = 0.5,
                damping = 0.4
            })
        end, {
            p1.isSettled,
            v10
        })

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = v9:map(function(p2) -- line: 66
                return UDim2.fromScale(p2, p2)
            end)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            Position = v5:map(function(p3) -- line: 71
                return UDim2.fromScale(0, p3)
            end),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.04, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Image = v4.image,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.6, 0.6)
        }), react.createElement(default, {
            shadowYScale = 0.07,
            color = v2,
            overrideProps = {
                LayoutOrder = 2,
                TextScaled = true,
                Size = UDim2.fromScale(1, 0.18),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            text = v4.label
        }), react.createElement(default, {
            shadowYScale = 0.07,
            color = if p1.isSettled then v3 else v2,
            overrideProps = {
                LayoutOrder = 3,
                TextScaled = true,
                Size = UDim2.fromScale(1, 0.16),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            text = formatLuckyBlockChancePercent(p1.chancePercent / 100)
        })))
    end
}
