-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectShardPendingReward = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "shard-reward.selectors").selectShardPendingReward
local shardsData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "shards").shardsData
local v1 = UDim2.fromScale(0.5, 0.4)
local v2 = UDim2.fromScale(0.083, 0.545)
local t1 = {
    10, -10, 8, -8, 5, -5, 0
}

return {
    default = function() -- ShardRewardManager | line: 24
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useMotion (copy), default (copy), useRootProducer (copy), useRootSelector (copy), selectShardPendingReward (copy), shardsData (copy), v1 (copy), v2 (copy), t1 (copy)
        local v3 = useRootSelector(selectShardPendingReward)
        local v4 = useRootProducer()
        local v5, v6 = useState(nil)
        local v7 = useRef(nil)
        local v8, v9 = useMotion(1)
        local v10, v11 = useMotion(v1)
        local v12, v13 = useMotion(1)
        local v14, v15 = useMotion(0)

        useEffect(function() -- line: 33
            -- upvalues: v3 (copy), v4 (copy), v6 (copy), v7 (copy)
            if v3 == nil or v3.id == v7.current then
                return nil
            end

            v7.current = v3.id
            v6(v3)
            v4.shardRewardConsumed({
                id = v3.id
            })
        end, { v3, v4 })
        useEffect(function() -- line: 43
            -- upvalues: v5 (copy), v6 (copy), v9 (copy), v11 (copy), v13 (copy), v15 (copy), v1 (copy), v2 (copy), t1 (copy)
            if v5 == nil then
                return nil
            end

            v11:immediate(v1)
            v13:immediate(1)
            v15:immediate(0)
            v9:tween(0, {
                time = 0.4,
                style = Enum.EasingStyle.Quad,
                direction = Enum.EasingDirection.Out
            })

            local v16 = table.create(#t1)

            for v17, v18 in t1 do
                local v19 = v17 - 1

                v16[v17] = task.delay(0.4 + v19 * 0.06, function() -- line: 58
                    -- upvalues: v18 (copy), v15 (copy)
                    v15:tween(v18, {
                        time = 0.06,
                        style = Enum.EasingStyle.Quad,
                        direction = Enum.EasingDirection.Out
                    })
                end)
            end

            local v21 = #t1 * 0.06
            local v22 = task.delay(v21 + 0.4 + 0.3, function() -- line: 72
                -- upvalues: v11 (copy), v13 (copy), v2 (copy)
                v11:tween(v2, {
                    time = 0.35,
                    style = Enum.EasingStyle.Quad,
                    direction = Enum.EasingDirection.In
                })
                v13:tween(0.15, {
                    time = 0.35,
                    style = Enum.EasingStyle.Quad,
                    direction = Enum.EasingDirection.In
                })
            end)
            local v23 = task.delay(v21 + 0.4 + 0.3 + 0.35, function() -- line: 84
                -- upvalues: v6 (copy)
                v6(nil)
            end)

            return function() -- line: 87
                -- upvalues: v16 (copy), v22 (copy), v23 (copy)
                local function v24(p1) -- line: 89
                    return task.cancel(p1)
                end

                for v25, v26 in v16 do
                    local _ = v25 - 1

                    task.cancel(v26)
                end

                task.cancel(v22)
                task.cancel(v23)
            end
        end, { v5, v11, v13, v15, v9 })

        if v5 == nil then
            return nil
        end

        local v27 = shardsData[v5.shardType]

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 150,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = v10,
            Rotation = v14,
            Size = UDim2.fromOffset(180, 220)
        }, react.createElement("uiscale", {
            Scale = v12
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 150,
            AnchorPoint = Vector2.new(0.5, 0),
            Image = v27.image,
            ImageTransparency = v8,
            Position = UDim2.fromScale(0.5, 0),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromOffset(180, 180)
        }, react.createElement(default, {
            anchorPoint = Vector2.new(1, 1),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 152,
                Position = UDim2.fromScale(0.95, 0.95),
                Size = UDim2.fromOffset(70, 34),
                TextXAlignment = Enum.TextXAlignment.Right
            },
            strokeProps = {
                Thickness = 0.09,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = ("x%*"):format(v5.amount),
            textTransparency = v8
        })), react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 152,
                Position = UDim2.fromOffset(0, 188),
                Size = UDim2.fromOffset(220, 30)
            },
            position = UDim2.fromScale(0.5, 0),
            strokeProps = {
                Thickness = 0.09,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = v27.displayName,
            textTransparency = v8
        }))
    end
}
