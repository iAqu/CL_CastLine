-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "server-restart.selectors")
local selectRestartEndTimestamp, selectRestartCloseReason, selectRestartMessage = v1.selectRestartEndTimestamp, v1.selectRestartCloseReason, v1.selectRestartMessage
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-countdown").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 30))
})
local t1 = {
    "Server restarting",
    "Roblox maintenance",
    "Server shutting down",
    "Server restarting",
    "Server restarting",
    "Server restarting"
}

local function getLabel(p1, p2) -- line: 14
    -- upvalues: t1 (copy)
    if p2 ~= nil and p2 ~= "" then
        return p2
    end

    if p1 == nil then
        return "Server restarting"
    end

    local v3 = t1[p1 + 1]

    if v3 == nil then
        v3 = "Server restarting"
    end

    return v3
end

local function formatSeconds(p3) -- line: 27
    local v5 = math.floor(p3 / 60)
    local v6 = p3 % 60

    if v5 > 0 and v6 > 0 then
        return (("%*m %*s"):format(v5, v6))
    end

    if v5 > 0 then
        return (("%*m"):format(v5))
    end

    return (("%*s"):format(v6))
end

return {
    default = function() -- ServerRestartBanner | line: 38
        -- upvalues: react (copy), useRootSelector (copy), selectRestartEndTimestamp (copy), selectRestartCloseReason (copy), selectRestartMessage (copy), default (copy), default2 (copy), v2 (copy), t1 (copy)
        local v7 = useRootSelector(selectRestartEndTimestamp)
        local v8 = useRootSelector(selectRestartCloseReason)
        local v9 = useRootSelector(selectRestartMessage)
        local v10 = default(v7)
        local secondsLeft = v10.secondsLeft

        if not v10.isCountdownOngoing then
            return nil
        end

        local v11

        if v9 == nil or v9 == "" then
            if v8 ~= nil then
                v11 = t1[v8 + 1]

                if v11 == nil then
                    v11 = "Server restarting"
                end
            else
                v11 = "Server restarting"
            end
        else
            v11 = v9
        end

        return react.createElement(default2, {
            anchorPoint = Vector2.new(0.5, 0),
            color = v2,
            overrideProps = {
                TextScaled = true,
                ZIndex = 90,
                Position = UDim2.fromScale(0.5, 0.14),
                Size = UDim2.new(0.7, 0, 0, 72)
            },
            strokeProps = {
                Color = Color3.fromRGB(180, 80, 0)
            },
            text = secondsLeft:map(function(p4) -- line: 61
                -- upvalues: v11 (ref)
                local v13 = math.floor(p4 / 60)
                local v14 = p4 % 60
                local v15 = if v13 > 0 and v14 > 0 then ("%*m %*s"):format(v13, v14) elseif v13 > 0 then ("%*m"):format(v13) else ("%*s"):format(v14)

                return (("%* in %*"):format(v11, v15))
            end)
        })
    end
}
