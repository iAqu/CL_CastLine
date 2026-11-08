-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local t2 = {
    "rbxassetid://",
    "https://assetdelivery.roblox.com/v1/asset/?id=",
    "https://www.roblox.com/asset/?id=",
    "http://www.roblox.com/asset/?id="
}

local function wholePositive(p1) -- line: 14
    return if p1 > 0 and p1 < 1e999 and p1 % 1 == 0 then p1 else nil
end

local function digitsBehindHead(p2) -- line: 18
    -- upvalues: t2 (copy)
    for _, v1 in t2 do
        if string.sub(p2, 1, #v1) == v1 then
            local v4 = string.sub(p2, #v1 + 1)

            return if string.find(v4, "^%d+$") ~= nil then v4 else nil
        end
    end

    return nil
end

function t1.Parse(p3) -- line: 28
    -- upvalues: digitsBehindHead (copy)
    if type(p3) == "number" then
        if p3 > 0 and p3 < 1e999 and p3 % 1 == 0 then
            return p3
        end
    else
        local v5 = tonumber(p3)

        if v5 == nil then
            local v6 = digitsBehindHead(p3)

            v5 = if v6 ~= nil then tonumber(v6) else nil
        end

        if v5 ~= nil and v5 > 0 and v5 < 1e999 and v5 % 1 == 0 then
            return v5
        end
    end

    return nil
end

return table.freeze(t1)
