local OWNER_USER_IDS = {
    4545231660,
    4556553540,   -- heixiaogu
    4853936210,   -- bubble10212
    7375628971,   -- littlesissi2021
    -- 7199074950,   -- May4th66
    7504877952,   -- May4th67
    5357818664,   -- LittleLambSusie
    4805502971,   -- treebearboy
    7199074950,   -- May4th66
    10305940897,  -- ALICE20210611a
    10311335740,  -- Emily20210611
    10938171089,  -- may4th62
    8727275519,
    -1,
    -2,
    -3,
}

local GM_USER_IDS = {
    -- 7199074950,   -- May4th66
    -- 313148740,    -- qw132456789
}

local GM_COMMANDS = {       -- gm limited commands
    "kick",
    "giveGamepass",
    "giveWin",
    "giveDiamond",
    "givePotion",
    "giveItem",
    "giveRandomItem",
    "givePet",
    "giveEgg",
    "giveAnimal",
    "giveFruit",
	"giveProp",
	"giveDecor",
    "adjustPlayerStrength",
    "adjustPlayerWin",
    "adjustPlayerDiamond",
    "removeLeaderboard"
}

return function (registry)
    -- return nil to allow the command to run
    registry:RegisterHook("BeforeRun", function(context)
        -- if context.Executor.UserId ~= 4545231660
        --     and context.Executor.UserId ~= 4556553540       -- heixiaogu
        --     and context.Executor.UserId ~= 4853936210       -- bubble10212
        --     and context.Executor.UserId ~= 7375628971       -- littlesissi2021
        --     and context.Executor.UserId ~= 7199074950       -- May4th66
        --     and context.Executor.UserId ~= 7504877952       -- May4th67
        --     and context.Executor.UserId ~= 5357818664       -- LittleLambSusie
        --     and context.Executor.UserId ~= 4805502971       -- treebearboy
        --     and context.Executor.UserId ~= -1               -- Local player 1
        --     and context.Executor.UserId ~= -2               -- Local player 2
        --     and context.Executor.UserId ~= -3               -- Local player 3
        --     and context.Executor.UserId ~= -4               -- Local player 4
        --     and context.Executor.UserId ~= -5               -- Local player 5
        if table.find(OWNER_USER_IDS, context.Executor.UserId) then
            return nil

        elseif table.find(GM_USER_IDS, context.Executor.UserId) then
            if table.find(GM_COMMANDS, context.Name) then
                return nil
            else
                return "You don't have permission to run this command!"
            end
        else
            return "You don't have permission to run this command!"
        end
    end)
end
