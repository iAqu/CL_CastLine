-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    {
        key = "Welcome",
        id = 1835518250214534,
        name = "Welcome to Cast For Fish",
        description = "You joined Cast For Fish. Grab a rod and start casting!"
    },
    {
        key = "FirstCatch",
        id = 2855663698771075,
        name = "First Catch",
        description = "Reel in your very first fish."
    },
    {
        key = "RainbowCatch",
        id = 37277178115652,
        name = "Rainbow Catch",
        description = "Catch a Rainbow fish."
    },
    {
        key = "DeepWaters",
        id = 4419584862580738,
        name = "Deep Waters",
        description = "Get strong enough to cast into zone 10."
    },
    {
        key = "WorldsEnd",
        id = 2508297075537381,
        name = "World's End",
        description = "Get strong enough to cast into the final zone."
    }
}
local t2 = {}

for _, v1 in ipairs(t1) do
    t2[v1.key] = v1
end

return {
    List = t1,
    ByKey = t2
}
