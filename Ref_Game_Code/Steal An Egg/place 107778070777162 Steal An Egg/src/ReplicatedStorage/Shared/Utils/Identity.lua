-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local UserService = game:GetService("UserService")
local t1 = {}
local t2 = {}

local function recordOf(p1) -- line: 22
    -- upvalues: t1 (copy)
    local v1 = t1[p1]

    if v1 == nil then
        v1 = {
            Portraits = {}
        }
        t1[p1] = v1
    end

    return v1
end

local function acceptName(p2, p3) -- line: 31
    if type(p3) == "string" and string.match(p3, "^[%w_]+$") ~= nil then
        p2.Name = p3
    end
end

local function acceptDisplayName(p4, p5) -- line: 37
    if type(p5) == "string" and p5 ~= "" then
        p4.DisplayName = p5
    end
end

local function learnNames(p6) -- line: 44
    -- upvalues: Players (copy), UserService (copy), t1 (copy)
    local v2 = t1[p6]

    if v2 == nil then
        v2 = {
            Portraits = {}
        }
        t1[p6] = v2
    end

    local PlayerByUserId = Players:GetPlayerByUserId(p6)

    if PlayerByUserId ~= nil then
        v2.Name = PlayerByUserId.Name
        v2.DisplayName = PlayerByUserId.DisplayName

        return v2
    end

    local v3 = UserService:GetUserInfosByUserIdsAsync({ p6 })[1]

    if v3 ~= nil then
        local Username = v3.Username

        if type(Username) == "string" and string.match(Username, "^[%w_]+$") ~= nil then
            v2.Name = Username
        end

        local DisplayName = v3.DisplayName

        if type(DisplayName) == "string" and DisplayName ~= "" then
            v2.DisplayName = DisplayName
        end
    end

    return v2
end

function t2.Name(p7) -- line: 60
    -- upvalues: t1 (copy), learnNames (copy)
    local v4 = t1[p7]
    local Name = if v4 == nil then nil else v4.Name

    if Name == nil then
        Name = learnNames(p7).Name
    end

    return Name or error((("user %* resolved to an unusable username"):format(p7)))
end

function t2.DisplayName(p8) -- line: 69
    -- upvalues: t1 (copy), learnNames (copy)
    local v5 = t1[p8]
    local DisplayName = if v5 == nil then nil else v5.DisplayName

    if DisplayName == nil then
        DisplayName = learnNames(p8).DisplayName
    end

    return DisplayName or error((("no display name is available for user %*"):format(p8)))
end

function t2.Thumbnail(p9, p10, p11) -- line: 78
    -- upvalues: Players (copy), t1 (copy)
    local v6 = t1[p9]

    if v6 == nil then
        v6 = {
            Portraits = {}
        }
        t1[p9] = v6
    end

    local Portraits = v6.Portraits
    local v7 = Portraits[p10]
    local v8 = if v7 == nil then nil else v7[p11]

    if v8 ~= nil then
        return v8
    end

    local UserThumbnailAsync, UserThumbnailAsync2 = Players:GetUserThumbnailAsync(p9, p10, p11)

    if type(UserThumbnailAsync) ~= "string" or string.match(UserThumbnailAsync, "^%a[%w+.-]*:") == nil then
        error((("thumbnail lookup for user %* returned no content uri"):format(p9)))
    end

    if UserThumbnailAsync2 == true then
        local v9 = v7

        if v7 == nil then
            v9 = {}
            Portraits[p10] = v9
        end

        v9[p11] = UserThumbnailAsync
    end

    return UserThumbnailAsync
end

return table.freeze(t2)
