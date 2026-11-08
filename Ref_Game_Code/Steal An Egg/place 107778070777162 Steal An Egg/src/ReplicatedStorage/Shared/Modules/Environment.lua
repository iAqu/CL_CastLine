-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    [10563114921] = 107778070777162,
    [10650210095] = 135851379034158,
    [10737944401] = 121856883734174
}
local t2 = {
    [10563114921] = 133470009013038,
    [10650210095] = 117867539925583,
    [10737944401] = 99280404043876
}
local t3

local function inUniverse(p1) -- line: 36
    return game.GameId == p1
end

local function fillsRole(p2) -- line: 40
    -- upvalues: t3 (ref)
    local PlaceIds = t3.PlaceIds

    return PlaceIds ~= nil and PlaceIds[p2] == game.PlaceId
end

local function placesFor(p3) -- line: 45
    -- upvalues: t1 (copy), t2 (copy)
    local v1 = t1[p3]

    return if v1 ~= nil then {
        Default = v1,
        NewPlayerServer = t2[p3]
    } else nil
end

local GameId = game.GameId
local v2 = t1[GameId]

t3 = {
    PlaceIds = if v2 == nil then nil else {
        Default = v2,
        NewPlayerServer = t2[GameId]
    },
    GetPlaceIds = function() -- GetPlaceIds | line: 57
        -- upvalues: t3 (ref)
        return t3.PlaceIds
    end,
    IsDevPlace = function() -- IsDevPlace | line: 59
        return game.GameId == 10650210095
    end,
    IsTestPlace = function() -- IsTestPlace | line: 61
        return game.GameId == 10737944401
    end,
    IsDev3Place = function() -- IsDev3Place | line: 63
        return game.GameId == 10767176144
    end,
    IsRecordingPlace = function() -- IsRecordingPlace | line: 65
        return game.GameId == 10771290130
    end,
    IsQAPurchasesEnabled = function() -- IsQAPurchasesEnabled | line: 70
        -- upvalues: ReplicatedStorage (copy)
        if game.GameId == 10650210095 or game.GameId == 10737944401 or game.GameId == 10767176144 then
            return ReplicatedStorage:GetAttribute("QA_PURCHASES") == true
        end

        return false
    end,
    GetEnvironmentName = function() -- GetEnvironmentName | line: 79
        if game.GameId == 10563114921 then
            return "prod"
        end

        if game.GameId == 10737944401 then
            return "test"
        end

        return "dev"
    end,
    IsDefaultPlace = function() -- IsDefaultPlace | line: 89
        -- upvalues: t3 (ref)
        local PlaceIds = t3.PlaceIds

        return PlaceIds ~= nil and PlaceIds.Default == game.PlaceId
    end,
    IsNewPlayerServer = function() -- IsNewPlayerServer | line: 91
        -- upvalues: t3 (ref)
        local PlaceIds = t3.PlaceIds

        return PlaceIds ~= nil and PlaceIds.NewPlayerServer == game.PlaceId
    end
}

return t3
