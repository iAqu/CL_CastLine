-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useMemo = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useMemo
local useRootSelector = RuntimeLib.import(script, script.Parent, "reflex").useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local selectPlayerAquariumMoneyPerSecond = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerAquariumMoneyPerSecond
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-spin-wheel-config")
local getSpinWheelTimeSkipCash, getTimeSkipSeconds = v1.getSpinWheelTimeSkipCash, v1.getTimeSkipSeconds

local function getTimeskipRewardDisplay(p1, p2) -- line: 11
    -- upvalues: abbreviate (copy), getSpinWheelTimeSkipCash (copy), getTimeSkipSeconds (copy)
    local v2 = getTimeSkipSeconds(p1)
    local v3 = getSpinWheelTimeSkipCash(v2, p2)

    return {
        cashAmount = v3,
        cashText = ("+$%*"):format((abbreviate(v3))),
        minutes = p1,
        minutesText = ("%* MIN TIMESKIP"):format(p1),
        seconds = v2
    }
end

return {
    getTimeskipRewardDisplay = getTimeskipRewardDisplay,
    useTimeskipReward = function(p3) -- useTimeskipReward | line: 22
        -- upvalues: useMemo (copy), useRootSelector (copy), localPlayerUserId (copy), selectPlayerAquariumMoneyPerSecond (copy), getTimeskipRewardDisplay (copy)
        local v4 = useRootSelector(selectPlayerAquariumMoneyPerSecond(localPlayerUserId))

        return useMemo(function() -- line: 24
            -- upvalues: p3 (copy), v4 (copy), getTimeskipRewardDisplay (copy)
            return (getTimeskipRewardDisplay(p3, v4))
        end, { p3, v4 })
    end
}
