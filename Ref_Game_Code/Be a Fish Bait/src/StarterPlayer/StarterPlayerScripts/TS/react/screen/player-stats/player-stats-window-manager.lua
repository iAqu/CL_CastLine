-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo, useState = react.useEffect, react.useMemo, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquariumFishItems, selectPlayerAquariumMoneyPerSecond, selectPlayerGamepasses, selectPlayerInventory = selectors.selectPlayerAquariumFishItems, selectors.selectPlayerAquariumMoneyPerSecond, selectors.selectPlayerGamepasses, selectors.selectPlayerInventory
local selectPlayerActiveCharmCore, selectPlayerMetadata, selectPlayerShowcaseFish, selectPlayerStat = selectors.selectPlayerActiveCharmCore, selectors.selectPlayerMetadata, selectors.selectPlayerShowcaseFish, selectors.selectPlayerStat
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "exclusive-fish-utils")
local getAquariumFishEffectiveMoneyPerSecond, showcaseFishToMpsInput = v1.getAquariumFishEffectiveMoneyPerSecond, v1.showcaseFishToMpsInput
local getTimeToAddToPlaytime = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "metadata-utils").getTimeToAddToPlaytime
local default = RuntimeLib.import(script, script.Parent, "player-stats-window").default

local function formatPlaytime(p1) -- line: 30
    local v3 = math.max(0, (math.floor(p1)))
    local v5 = math.floor(v3 / 3600)
    local v7 = math.floor(v3 % 3600 / 60)
    local v8 = v3 % 60

    if v5 > 0 then
        return (("%*h %*m"):format(v5, v7))
    end

    if v7 > 0 then
        return (("%*m %*s"):format(v7, v8))
    end

    return (("%*s"):format(v8))
end

local t1 = {
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
}

local function formatDateJoined(p2) -- line: 44
    -- upvalues: t1 (copy)
    if p2 == nil or p2 <= 0 then
        return "Unknown"
    end

    local v9 = DateTime.fromUnixTimestamp(p2):ToUniversalTime()

    return (("%* %* %*"):format(v9.Day, t1[v9.Month], v9.Year))
end

return {
    default = function() -- PlayerStatsWindowManager | line: 51
        -- upvalues: react (copy), useEffect (copy), useMemo (copy), useState (copy), Players (copy), Workspace (copy), useRootProducer (copy), useRootSelector (copy), localPlayerUserId (copy), abbreviate (copy), selectPlayerAquariumFishItems (copy), selectPlayerAquariumMoneyPerSecond (copy), selectPlayerGamepasses (copy), selectPlayerInventory (copy), selectPlayerActiveCharmCore (copy), selectPlayerMetadata (copy), selectPlayerShowcaseFish (copy), selectPlayerStat (copy), getAquariumFishEffectiveMoneyPerSecond (copy), showcaseFishToMpsInput (copy), getTimeToAddToPlaytime (copy), default (copy), t1 (copy)
        local v10 = useRootProducer()
        local v11 = useRootSelector(selectPlayerMetadata(localPlayerUserId))
        local v12 = useRootSelector(selectPlayerInventory(localPlayerUserId))
        local v13 = useRootSelector(selectPlayerAquariumFishItems(localPlayerUserId))
        local v14 = useRootSelector(selectPlayerAquariumMoneyPerSecond(localPlayerUserId))
        local v15 = useRootSelector(selectPlayerGamepasses(localPlayerUserId))
        local v17 = showcaseFishToMpsInput((useRootSelector(selectPlayerShowcaseFish(localPlayerUserId))))
        local v18 = useRootSelector(selectPlayerStat(localPlayerUserId, "power"))

        if v18 == nil then
            v18 = 0
        end

        local v19 = useRootSelector(selectPlayerActiveCharmCore(localPlayerUserId))
        local v20, v21 = useState(Workspace:GetServerTimeNow())

        useEffect(function() -- line: 67
            -- upvalues: v21 (copy), Workspace (copy)
            local v22 = task.spawn(function() -- line: 68
                -- upvalues: v21 (copy), Workspace (copy)
                while true do
                    task.wait(1)
                    v21(Workspace:GetServerTimeNow())
                end
            end)

            return function() -- line: 74
                -- upvalues: v22 (copy)
                return task.cancel(v22)
            end
        end, {})

        local v31 = useMemo(function() -- line: 78
            -- upvalues: v11 (copy), v12 (copy), v13 (copy), v15 (copy), v17 (copy), v20 (copy), getAquariumFishEffectiveMoneyPerSecond (copy)
            local t2 = {}

            if v13 then
                for v24, v25 in v13 do
                    t2[v24] = v25
                end
            end

            if v12 then
                for v26, v27 in v12 do
                    if v27.itemType == "fish" then
                        t2[v26] = {
                            fishId = v27.itemId,
                            fishSpecies = v27.itemName,
                            level = v27.level,
                            mutations = v27.mutations
                        }
                    end
                end
            end

            if v17 ~= nil then
                t2[v17.fishId] = v17
            end

            local n1 = 0

            for _, v28 in t2 do
                local v29 = v11

                if v11 ~= nil then
                    v29 = v11.preLogoutBuff
                end

                n1 = math.max(n1, getAquariumFishEffectiveMoneyPerSecond(v28, t2, v15, v29, v20, v12))
            end

            return n1
        end, {
            v13,
            v15,
            v12,
            if v11 == nil then v11 else v11.preLogoutBuff,
            v20,
            v17
        })
        local v32 = if v11 then v11.playtime + getTimeToAddToPlaytime(v20, v11.timeJoined, v11.timeLastSaved) else 0
        local t3 = {
            bestFishMps = abbreviate(v31),
            charmCore = if v19 == nil then "None" else ("Tier %* · %* lines"):format(v19.tierId, #v19.affixes + 1)
        }
        local v33 = if v11 == nil then v11 else v11.timeFirstJoined

        if v33 == nil or v33 <= 0 then
            t3.dateJoined = "Unknown"
        else
            local v34 = DateTime.fromUnixTimestamp(v33):ToUniversalTime()

            t3.dateJoined = ("%* %* %*"):format(v34.Day, t1[v34.Month], v34.Year)
        end

        local v35 = if v11 == nil then v11 else v11.totalFishCaught

        t3.fishesCaught = if v35 == nil then 0 else v35

        t3.onClose = function() -- line: 138
            -- upvalues: v10 (copy)
            return v10.windowClosed({})
        end

        local v37 = math.max(0, (math.floor(v32)))
        local v39 = math.floor(v37 / 3600)
        local v41 = math.floor(v37 % 3600 / 60)
        local v42 = v37 % 60

        t3.playtime = if v39 > 0 then ("%*h %*m"):format(v39, v41) elseif v41 > 0 then ("%*m %*s"):format(v41, v42) else ("%*s"):format(v42)
        t3.power = abbreviate(v18)
        t3.totalMps = abbreviate(v14)
        t3.username = Players.LocalPlayer.Name

        return react.createElement(default, t3)
    end
}
