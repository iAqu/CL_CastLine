-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local t1

local function getPickaxeCooldown(p1) -- line: 17
    -- upvalues: t1 (ref)
    local v1 = t1[p1]

    if v1 ~= nil then
        v1 = v1.cooldown
    end

    if v1 == nil then
        v1 = 0.5
    end

    return v1
end

local function getPickaxeDamage(p2) -- line: 36
    -- upvalues: t1 (ref)
    local v2 = t1[p2]

    if v2 ~= nil then
        v2 = v2.damage
    end

    if v2 == nil then
        v2 = 1
    end

    return v2
end

local function getPickaxeGemChance(p3) -- line: 55
    -- upvalues: t1 (ref)
    local v3 = t1[p3]

    if v3 ~= nil then
        v3 = v3.gemChance
    end

    if v3 == nil then
        v3 = 1
    end

    return v3
end

local t2 = {
    cooldown = 0.5,
    damage = 1,
    imageId = "rbxassetid://127677127432766",
    name = "pickaxe"
}
local Pickaxes = ReplicatedStorage:FindFirstChild("Pickaxes")

t2.model = if Pickaxes ~= nil then Pickaxes:FindFirstChild("Pickaxe") else Pickaxes
t2.title = "Pickaxe"
t2.deletable = false
t2.gemChance = 1
t2.canMineRarity = "common"

local t3 = {
    "pickaxe",
    t2
}
local t4 = {
    cooldown = 0.5,
    damage = 5,
    imageId = "rbxassetid://134715634503771",
    name = "AdvancedPickaxe"
}
local Pickaxes2 = ReplicatedStorage:FindFirstChild("Pickaxes")

t4.model = if Pickaxes2 ~= nil then Pickaxes2:FindFirstChild("AdvancedPickaxe") else Pickaxes2
t4.title = "Advanced Pickaxe"
t4.deletable = false
t4.gemChance = 2
t4.canMineRarity = "rare"

local t5 = {
    "AdvancedPickaxe",
    t4
}
local t6 = {
    cooldown = 0.45,
    damage = 12.5,
    imageId = "rbxassetid://93187148166869",
    name = "MechaPickaxe"
}
local Pickaxes3 = ReplicatedStorage:FindFirstChild("Pickaxes")

t6.model = if Pickaxes3 ~= nil then Pickaxes3:FindFirstChild("MechaPickaxe") else Pickaxes3
t6.title = "Mecha Pickaxe"
t6.deletable = false
t6.gemChance = 3
t6.canMineRarity = "rare"

local t7 = {
    "MechaPickaxe",
    t6
}
local t8 = {
    cooldown = 0.45,
    damage = 25,
    imageId = "rbxassetid://109106732141789",
    name = "RainbowPickaxe"
}
local Pickaxes4 = ReplicatedStorage:FindFirstChild("Pickaxes")

t8.model = if Pickaxes4 ~= nil then Pickaxes4:FindFirstChild("RainbowPickaxe") else Pickaxes4
t8.title = "Rainbow Pickaxe"
t8.deletable = false
t8.gemChance = 20
t8.canMineRarity = "epic"

local t9 = {
    "RainbowPickaxe",
    t8
}
local t10 = {
    cooldown = 0.4,
    damage = 42.5,
    imageId = "rbxassetid://115175654960526",
    name = "ElectricPickaxe"
}
local Pickaxes5 = ReplicatedStorage:FindFirstChild("Pickaxes")

t10.model = if Pickaxes5 ~= nil then Pickaxes5:FindFirstChild("ElectricPickaxe") else Pickaxes5
t10.title = "Electric Pickaxe"
t10.deletable = false
t10.gemChance = 75
t10.canMineRarity = "legendary"

local t11 = {
    "ElectricPickaxe",
    t10
}
local t12 = {
    cooldown = 0.4,
    damage = 75,
    imageId = "rbxassetid://78280680409514",
    name = "Drill-Axe"
}
local Pickaxes6 = ReplicatedStorage:FindFirstChild("Pickaxes")

t12.model = if Pickaxes6 ~= nil then Pickaxes6:FindFirstChild("Drill-Axe") else Pickaxes6
t12.title = "Drill-Axe"
t12.deletable = false
t12.gemChance = 200
t12.canMineRarity = "mythic"

local t13 = {
    "Drill-Axe",
    t12
}
local t14 = {
    cooldown = 0.3,
    damage = 90,
    imageId = "rbxassetid://140193173377345",
    name = "AngelPickaxe"
}
local Pickaxes7 = ReplicatedStorage:FindFirstChild("Pickaxes")

t14.model = if Pickaxes7 ~= nil then Pickaxes7:FindFirstChild("AngelPickaxe") else Pickaxes7
t14.title = "Angel Pickaxe"
t14.deletable = false
t14.gemChance = 250
t14.canMineRarity = "mythic"

local t15 = {
    "AngelPickaxe",
    t14
}
local t16 = {
    cooldown = 0.5,
    damage = 160,
    imageId = "rbxassetid://127086212591258",
    name = "EvilPickaxe"
}
local Pickaxes8 = ReplicatedStorage:FindFirstChild("Pickaxes")

t16.model = if Pickaxes8 ~= nil then Pickaxes8:FindFirstChild("EvilPickaxe") else Pickaxes8
t16.title = "Evil Pickaxe"
t16.deletable = false
t16.gemChance = 300
t16.canMineRarity = "mythic"

local t17 = {
    "EvilPickaxe",
    t16
}
local t18 = {
    cooldown = 0.25,
    damage = 40,
    imageId = "rbxassetid://100930232542438",
    name = "goldPickaxe"
}
local Pickaxes9 = ReplicatedStorage:FindFirstChild("Pickaxes")

t18.model = if Pickaxes9 ~= nil then Pickaxes9:FindFirstChild("GoldPickaxe") else Pickaxes9
t18.title = "Gold Pickaxe"
t18.deletable = false
t18.gemChance = 0
t18.canMineRarity = "epic"

local t19 = {
    "goldPickaxe",
    t18
}
local t20 = {
    cooldown = 0.25,
    damage = 64,
    imageId = "rbxassetid://111498068749551",
    name = "zeusPickaxe"
}
local Pickaxes10 = ReplicatedStorage:FindFirstChild("Pickaxes")

t20.model = if Pickaxes10 ~= nil then Pickaxes10:FindFirstChild("ZeusPickaxe") else Pickaxes10
t20.title = "Zeus Pickaxe"
t20.deletable = false
t20.gemChance = 200
t20.canMineRarity = "legendary"

local t21 = {}

for _, v4 in {
        t3,
        t5,
        t7,
        t9,
        t11,
        t13,
        t15,
        t17,
        t19,
        { "zeusPickaxe", t20 }
    } do
    t21[v4[1]] = v4[2]
end

t1 = t21

return {
    pickaxeHitDelay = 0.4,
    pickaxeHitboxSize = Vector3.new(9, 15, 9),
    goldPickaxeName = "goldPickaxe",
    zeusPickaxeName = "zeusPickaxe",
    zeusPickaxeDescription = "Ultimate pickaxe from Zeus himself, deals 64 damage and has a 0.25 second cooldown.",
    defaultPickaxeCooldown = 0.5,
    getPickaxeCooldown = getPickaxeCooldown,
    getPickaxeDamage = getPickaxeDamage,
    getPickaxeGemChance = getPickaxeGemChance,
    pickaxes = t1
}
