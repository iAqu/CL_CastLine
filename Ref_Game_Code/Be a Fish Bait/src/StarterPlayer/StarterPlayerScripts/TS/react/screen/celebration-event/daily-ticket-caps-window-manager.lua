-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local default = RuntimeLib.import(script, script.Parent, "daily-ticket-caps-window").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local ticketSourceCaps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "ticket-sources").ticketSourceCaps
local selectPlayerTicketCapProgress = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerTicketCapProgress
local dailyRewardCooldownSeconds = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "daily-rewards-utils").dailyRewardCooldownSeconds

local function getNextDailyResetTimestamp(p1) -- line: 16
    -- upvalues: dailyRewardCooldownSeconds (copy)
    local v1 = DateTime.fromUnixTimestamp(p1):ToUniversalTime()

    return DateTime.fromUniversalTime(v1.Year, v1.Month, v1.Day, 0, 0, 0).UnixTimestamp + dailyRewardCooldownSeconds
end

local function buildEntry(p2, p3, p4, p5, p6, p7) -- line: 23
    local v2 = if p3 == nil then 0 else p3

    if p7 ~= nil then
        if not (v2 < p7) then
            v2 = math.max(0, v2 - p7)
        end
    elseif p4 ~= nil and p4 <= p6 then
        v2 = 0
    end

    return {
        cap = p5,
        earned = math.min(v2, p5),
        label = p2
    }
end

return {
    default = function() -- DailyTicketCapsWindowManager | line: 36
        -- upvalues: react (copy), useEffect (copy), useState (copy), Workspace (copy), default (copy), useRootProducer (copy), useRootSelector (copy), localPlayerUserId (copy), ticketSourceCaps (copy), selectPlayerTicketCapProgress (copy), dailyRewardCooldownSeconds (copy), buildEntry (copy)
        local v4 = useRootProducer()
        local v5, v6 = useState(0)
        local v7, v8 = useState(nil)
        local v9 = useRootSelector(selectPlayerTicketCapProgress(localPlayerUserId, "TicketRain"))
        local v10 = useRootSelector(selectPlayerTicketCapProgress(localPlayerUserId, "Fishing"))
        local v11 = useRootSelector(selectPlayerTicketCapProgress(localPlayerUserId, "PinataBash"))
        local v12 = useRootSelector(selectPlayerTicketCapProgress(localPlayerUserId, "Minigame:rgl"))
        local v13 = useRootSelector(selectPlayerTicketCapProgress(localPlayerUserId, "Minigame:obby"))
        local v14 = useRootSelector(selectPlayerTicketCapProgress(localPlayerUserId, "Minigame:catchSticks"))

        useEffect(function() -- line: 46
            -- upvalues: v6 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), Workspace (copy), dailyRewardCooldownSeconds (copy)
            local ServerTimeNow = Workspace:GetServerTimeNow()
            local v16 = DateTime.fromUnixTimestamp(ServerTimeNow):ToUniversalTime()
            local v17 = DateTime.fromUniversalTime(v16.Year, v16.Month, v16.Day, 0, 0, 0).UnixTimestamp + dailyRewardCooldownSeconds
            local v18 = task.delay(v17 - ServerTimeNow + 0.1, function() -- line: 49
                -- upvalues: v6 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy)
                local v19 = v14

                if v14 ~= nil then
                    v19 = v14.earnedSinceReset
                end

                if v19 == nil then
                    v19 = 0
                end

                local t1 = {
                    catchSticks = v19
                }
                local v20 = v10

                if v10 ~= nil then
                    v20 = v10.earnedSinceReset
                end

                t1.fishing = if v20 == nil then 0 else v20

                local v21 = v13

                if v13 ~= nil then
                    v21 = v13.earnedSinceReset
                end

                t1.obby = if v21 == nil then 0 else v21

                local v22 = v11

                if v11 ~= nil then
                    v22 = v11.earnedSinceReset
                end

                t1.pinataBash = if v22 == nil then 0 else v22

                local v23 = v12

                if v12 ~= nil then
                    v23 = v12.earnedSinceReset
                end

                t1.rgl = if v23 == nil then 0 else v23

                local v24 = v9

                if v9 ~= nil then
                    v24 = v9.earnedSinceReset
                end

                t1.ticketRain = if v24 == nil then 0 else v24
                v8(t1)
                v6(function(p8) -- line: 112
                    return p8 + 1
                end)
            end)

            return function() -- line: 116
                -- upvalues: v18 (copy)
                return task.cancel(v18)
            end
        end, {
            if v14 == nil then v14 else v14.earnedSinceReset,
            if v10 == nil then v10 else v10.earnedSinceReset,
            if v13 == nil then v13 else v13.earnedSinceReset,
            if v11 == nil then v11 else v11.earnedSinceReset,
            v5,
            if v12 == nil then v12 else v12.earnedSinceReset,
            if v9 == nil then v9 else v9.earnedSinceReset
        })

        local ServerTimeNow = Workspace:GetServerTimeNow()
        local v34 = buildEntry("Ticket Rain", if v9 == nil then v9 else v9.earnedSinceReset, if v9 == nil then v9 else v9.resetsAt, ticketSourceCaps.TicketRain, ServerTimeNow, if v7 == nil then v7 else v7.ticketRain)
        local v38 = buildEntry("Fishing", if v10 == nil then v10 else v10.earnedSinceReset, if v10 == nil then v10 else v10.resetsAt, ticketSourceCaps.Fishing, ServerTimeNow, if v7 == nil then v7 else v7.fishing)
        local v42 = buildEntry("Pinata Bash", if v11 == nil then v11 else v11.earnedSinceReset, if v11 == nil then v11 else v11.resetsAt, ticketSourceCaps.PinataBash, ServerTimeNow, if v7 == nil then v7 else v7.pinataBash)
        local v47 = buildEntry("Red Light Green Light", if v12 == nil then v12 else v12.earnedSinceReset, if v12 == nil then v12 else v12.resetsAt, ticketSourceCaps["Minigame:rgl"], ServerTimeNow, if v7 == nil then v7 else v7.rgl)
        local v52 = buildEntry("FOMObby", if v13 == nil then v13 else v13.earnedSinceReset, if v13 == nil then v13 else v13.resetsAt, ticketSourceCaps["Minigame:obby"], ServerTimeNow, if v7 == nil then v7 else v7.obby)
        local v53 = if v14 == nil then v14 else v14.earnedSinceReset
        local v54 = if v14 == nil then v14 else v14.resetsAt
        local v55 = ticketSourceCaps["Minigame:catchSticks"]

        if v7 ~= nil then
            v7 = v7.catchSticks
        end

        local t2 = {
            v34,
            v38,
            v42,
            v47,
            v52,
            (buildEntry("Reaction Sticks", v53, v54, v55, ServerTimeNow, v7))
        }

        return react.createElement(default, {
            entries = t2,
            onClose = function() -- onClose | line: 232
                -- upvalues: v4 (copy)
                return v4.windowClosed({})
            end
        })
    end
}
