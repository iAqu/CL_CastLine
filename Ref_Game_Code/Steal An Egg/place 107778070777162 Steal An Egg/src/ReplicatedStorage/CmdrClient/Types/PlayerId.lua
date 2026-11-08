-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Util = require(script.Parent.Parent.Shared.Util)
local Players = game:GetService("Players")
local t1 = {}

local function getUserId(p1) -- line: 5
    -- upvalues: Players (copy), t1 (copy)
    if t1[p1] then
        return t1[p1]
    end

    if Players:FindFirstChild(p1) then
        t1[p1] = Players[p1].UserId

        return Players[p1].UserId
    end

    local GetUserIdFromNameAsync = Players.GetUserIdFromNameAsync
    local ok, result = pcall(GetUserIdFromNameAsync, Players, p1)

    if not ok then
        return nil
    end

    t1[p1] = result

    return result
end

local t2 = {
    DisplayName = "Full Player Name",
    Prefixes = "# integer",
    Transform = function(p2) -- Transform | line: 27
        -- upvalues: Util (copy), Players (copy)
        return p2, Util.MakeFuzzyFinder(Players:GetPlayers())(p2)
    end,
    ValidateOnce = function(p3) -- ValidateOnce | line: 33
        -- upvalues: Players (copy), t1 (copy)
        local result

        if t1[p3] then
            result = t1[p3]
        elseif Players:FindFirstChild(p3) then
            t1[p3] = Players[p3].UserId
            result = Players[p3].UserId
        else
            local GetUserIdFromNameAsync = Players.GetUserIdFromNameAsync
            local ok

            ok, result = pcall(GetUserIdFromNameAsync, Players, p3)

            if ok then
                t1[p3] = result
            else
                result = nil
            end
        end

        return result ~= nil, "No player with that name could be found."
    end,
    Autocomplete = function(_, p5) -- Autocomplete | line: 37
        -- upvalues: Util (copy)
        return Util.GetNames(p5)
    end,
    Parse = function(p6) -- Parse | line: 41
        -- upvalues: Players (copy), t1 (copy)
        if t1[p6] then
            return t1[p6]
        end

        if Players:FindFirstChild(p6) then
            t1[p6] = Players[p6].UserId

            return Players[p6].UserId
        end

        local GetUserIdFromNameAsync = Players.GetUserIdFromNameAsync
        local ok, result = pcall(GetUserIdFromNameAsync, Players, p6)

        if not ok then
            return nil
        end

        t1[p6] = result

        return result
    end
}

function t2.Default(p7) -- line: 45
    return p7.Name
end

t2.ArgumentOperatorAliases = {
    me = ".",
    all = "*",
    others = "**",
    random = "?"
}

return function(p8) -- line: 57
    -- upvalues: Util (copy), t2 (copy)
    p8:RegisterType("playerId", t2)
    p8:RegisterType("playerIds", Util.MakeListableType(t2, {
        Prefixes = "# integers"
    }))
end
