-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")

local function trim(p1) -- line: 8
    return (string.gsub(p1, "^%s*(.-)%s*$", "%1"))
end

local function isValidToken(p2) -- line: 12
    if string.match(p2, "^#?%d+$") then
        return true
    end

    if string.match(p2, "^[%w_]+$") ~= nil and #p2 >= 3 then
        return #p2 <= 20
    end

    return false
end

local function matchOnline(p3) -- line: 22
    -- upvalues: Players (copy)
    local v1 = string.lower(p3)
    local t1 = {}

    for _, player in Players:GetPlayers() do
        if v1 == "" or string.sub(string.lower(player.Name), 1, #v1) == v1 then
            table.insert(t1, player)
        end
    end

    return t1
end

local t2 = {
    DisplayName = "Username or #UserId",
    Listable = true
}

function t2.Transform(p4) -- line: 39
    -- upvalues: matchOnline (copy)
    return string.gsub(p4, "^%s*(.-)%s*$", "%1"), (matchOnline((string.gsub(p4, "^%s*(.-)%s*$", "%1"))))
end

function t2.Validate(p5) -- line: 43
    if #p5 == 0 then
        return false, "Give a username, or a user id prefixed with #."
    end

    return not not (string.match(p5, "^#?%d+$") or string.match(p5, "^[%w_]+$") ~= nil and #p5 >= 3 and #p5 <= 20), (("\"%*\" is not a username or a #userid. Ids look like #3889785873."):format(p5))
end

function t2.Autocomplete(_, p7) -- line: 51
    local t3 = {}

    for _, v4 in p7 do
        table.insert(t3, v4.Name)
    end

    return t3
end

function t2.Parse(p8, p9) -- line: 59
    if #p9 ~= 1 or string.lower(p9[1].Name) ~= string.lower(p8) then
        return { p8 }
    end

    return { p9[1].Name }
end

function t2.Default(p10) -- line: 67
    return p10.Name
end

t2.ArgumentOperatorAliases = {
    me = ".",
    all = "*",
    others = "**"
}

return function(p11) -- line: 78
    -- upvalues: t2 (copy)
    p11:RegisterType("banTargets", t2)
end
