-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    List = {
        {
            Key = "KeepFishing",
            Name = "Keep Fishing",
            Detail = "Stay on the dock, catches go to your bag",
            Default = false
        },
        {
            Key = "Music",
            Name = "Music & Ambience",
            Detail = "The background sounds",
            Default = true
        },
        {
            Key = "Sfx",
            Name = "Sound Effects",
            Detail = "Clicks, splashes and pops",
            Default = true
        },
        {
            Key = "OtherAnimals",
            Name = "Other Players' Animals",
            Detail = "Turn off if your device lags",
            Default = true
        },
        {
            Key = "MyAnimals",
            Name = "Your Animals",
            Detail = "Show your own animals on your plot",
            Default = true
        },
        {
            Key = "AnimalFx",
            Name = "Animal Effects",
            Detail = "Sparkles, glows and auras",
            Default = true
        },
        {
            Key = "Shake",
            Name = "Camera Shake",
            Detail = "Shakes on casts, bites, hits and level ups",
            Default = true
        },
        {
            Key = "TradeRequests",
            Name = "Trade Requests",
            Detail = "Let other players ask you to trade",
            Default = true
        }
    },
    ByKey = {}
}

for _, v1 in t1.List do
    t1.ByKey[v1.Key] = v1
end

function t1.attribute(p1) -- line: 27
    return "Setting_" .. p1
end

function t1.get(p2, p3) -- line: 32
    -- upvalues: t1 (copy)
    local Attribute = p2:GetAttribute(t1.attribute(p3))

    if Attribute ~= nil then
        return Attribute == true
    end

    local v2 = t1.ByKey[p3]

    if v2 == nil then
        return true
    end

    return v2.Default
end

return t1
