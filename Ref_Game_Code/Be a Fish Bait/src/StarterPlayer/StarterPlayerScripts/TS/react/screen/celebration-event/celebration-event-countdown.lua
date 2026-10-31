-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-countdown").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local celebrationEventShopEndTimestamp = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-event-shop-config").celebrationEventShopEndTimestamp

local function formatCelebrationTimeLeft(p1) -- line: 8
    local v2 = math.max(0, (math.floor(p1)))
    local v4 = math.floor(v2 / 86400)
    local v6 = math.floor(v2 % 86400 / 3600)
    local v8 = math.floor(v2 % 3600 / 60)

    return string.format("%02d:%02d:%02d", v4, v6, v8)
end

return {
    default = function(p2) -- CelebrationEventCountdown | line: 15
        -- upvalues: react (copy), default (copy), default2 (copy), useTheme (copy), celebrationEventShopEndTimestamp (copy)
        local color = p2.color

        if color == nil then
            color = Color3.fromRGB(255, 246, 164)
        end

        local includeLabel = p2.includeLabel
        local v9 = includeLabel

        if includeLabel == nil then
            v9 = true
        end

        local position = p2.position

        if position == nil then
            position = UDim2.fromScale(0.5, 0.5)
        end

        local size = p2.size

        if size == nil then
            size = UDim2.fromScale(1, 1)
        end

        local zIndex = p2.zIndex

        if zIndex == nil then
            zIndex = 5
        end

        local v10 = useTheme()
        local v11 = default2(celebrationEventShopEndTimestamp).secondsLeft:map(function(p3) -- line: 39
            -- upvalues: v9 (ref)
            local v13 = math.max(0, (math.floor(p3)))
            local v15 = math.floor(v13 / 86400)
            local v17 = math.floor(v13 % 86400 / 3600)
            local v19 = math.floor(v13 % 3600 / 60)
            local v20 = string.format("%02d:%02d:%02d", v15, v17, v19)

            if v9 then
                return (("ENDS IN: %*"):format(v20))
            end

            return v20
        end)

        return react.createElement(default, {
            shadowYScale = 0.06,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = color,
            overrideProps = {
                TextScaled = true,
                TextWrapped = false,
                Font = v10.textFont2,
                Size = size,
                ZIndex = zIndex
            },
            popoutColor = Color3.fromRGB(70, 35, 10),
            position = position,
            strokeProps = {
                Thickness = 0.1,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = v11
        })
    end
}
