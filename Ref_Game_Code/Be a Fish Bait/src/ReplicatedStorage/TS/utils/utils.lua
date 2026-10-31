-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local services = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, RunService = services.HttpService, services.RunService
local GameId, PlaceId, JobId = game.GameId, game.PlaceId, game.JobId

return {
    groupId = 5157041,
    isStudioOrStaging = function() -- isStudioOrStaging | line: 12
        -- upvalues: RunService (copy), PlaceId (copy)
        local v1 = RunService:IsStudio()

        if not v1 then
            v1 = PlaceId == 99214115918108 or PlaceId == 132203657268466
        end

        return v1
    end,
    areSetsEqual = function(p1, p2) -- areSetsEqual | line: 15
        local n1 = 0

        for _ in p1 do
            n1 += 1
        end

        local n2 = 0

        for _ in p2 do
            n2 += 1
        end

        local v2 = n1 == n2

        if v2 then
            local t1 = {}
            local v3 = #t1

            for v4 in p1 do
                v3 += 1
                t1[v3] = v4
            end

            v2 = true

            for v5, v6 in t1 do
                local _ = v5 - 1

                if p2[v6] == nil then
                    v2 = false
                    break
                end

                v2 = true
            end
        end

        return v2
    end,
    calculatePlayerWalkspeed = function(p3) -- calculatePlayerWalkspeed | line: 54
        local baseWalkspeed, speedStat, maxWalkspeed, walkspeedPerSpeedStat = p3.baseWalkspeed, p3.speedStat, p3.maxWalkspeed, p3.walkspeedPerSpeedStat
        local speedRevealPercentage = p3.speedRevealPercentage

        return baseWalkspeed + math.min(speedStat * walkspeedPerSpeedStat, maxWalkspeed - baseWalkspeed) * speedRevealPercentage
    end,
    generateUniqueId = function() -- generateUniqueId | line: 62
        -- upvalues: HttpService (copy)
        return HttpService:GenerateGUID(false)
    end,
    titleCase = function(p4) -- titleCase | line: 65
        local v9 = string.split(p4, " ")
        local v10 = table.create(#v9)

        local function v11(p5) -- line: 69
            return string.upper((string.sub(p5, 1, 1))) .. string.sub(p5, 2)
        end

        for v12, v13 in v9 do
            local _ = v12 - 1

            v10[v12] = v11(v13)
        end

        return table.concat(v10, " ")
    end,
    roundToNicestNumber = function(p6) -- roundToNicestNumber | line: 78
        local v15 = math.floor((math.log10(p6)))

        if v15 <= 2 then
            return (math.floor(p6))
        end

        local v17 = math.pow(10, v15 - 2)

        return math.floor(p6 / v17) * v17
    end,
    addToMap = function(p7, p8, p9) -- addToMap | line: 86
        local v19 = p7[p8]

        if v19 == nil then
            v19 = 0
        end

        p7[p8] = v19 + p9
    end,
    addMapValues = function(p10, p11) -- addMapValues | line: 99
        for v20, v21 in p11 do
            local v22 = p10[v20]

            if v22 == nil then
                v22 = 0
            end

            p10[v20] = v22 + v21
        end
    end,
    getTimeOnMidnight = function(p12) -- getTimeOnMidnight | line: 104
        return math.floor(p12 / 86400) * 86400
    end,
    noYield = function(p13) -- noYield | line: 107
        for _, _ in function() -- line: 108
                -- upvalues: p13 (copy)
                p13()
            end do
            break
        end
    end,
    selectFromWeightages = function(p14, p15) -- selectFromWeightages | line: 114
        table.sort(p14, function(p16, p17) -- line: 115
            return p16.weightage > p17.weightage
        end)

        local function v24(p18, p19) -- line: 121
            return p18 + p19.weightage
        end

        local n3 = 0

        for i = 1, #p14 do
            local v26 = p14[i]
            local _ = i - 1

            n3 += v26.weightage
        end

        local v27 = p15:NextNumber(0, n3)

        for _, v28 in p14 do
            v27 -= v28.weightage

            if v27 < 0 then
                return v28
            end
        end

        return p14[1]
    end,
    mapToArray = function(p20) -- mapToArray | line: 139
        local t2 = {}

        for _, v29 in p20 do
            table.insert(t2, v29)
        end

        return t2
    end,
    moveModelCentered = function(p21, p22) -- moveModelCentered | line: 152
        p21:PivotTo(p22 * (p21:GetBoundingBox():Inverse() * p21:GetPivot()))
    end,
    gameId = GameId,
    placeId = PlaceId,
    jobId = JobId
}
