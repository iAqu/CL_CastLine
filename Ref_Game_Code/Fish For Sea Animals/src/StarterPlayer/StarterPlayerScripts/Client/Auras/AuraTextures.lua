-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function id(p1) -- line: 7
    return (("rbxassetid://%*"):format(p1))
end

local t2 = {
    GLOW = `rbxassetid://{1075864321}`,
    SOFT_GLOW = `rbxassetid://{4509687978}`,
    AURA = `rbxassetid://{14447188478}`,
    FLARE = `rbxassetid://{14684195806}`,
    RAYS = `rbxassetid://{1053548563}`,
    FLASH = `rbxassetid://{12761854004}`,
    SPARKLE = `rbxassetid://{1851669703}`,
    STAR = `rbxassetid://{14006783533}`,
    STAR4 = `rbxassetid://{1084970835}`,
    BIG_STAR = `rbxassetid://{4963436775}`,
    SHINE = `rbxassetid://{10598374841}`,
    THIN_SHINE = `rbxassetid://{139970869331432}`,
    TWINKLE = `rbxassetid://{16956515291}`,
    BURST = `rbxassetid://{6490035152}`,
    SPECS = `rbxassetid://{9997556038}`,
    SPECK = `rbxassetid://{8068783649}`,
    HEART = `rbxassetid://{241778280}`,
    PUFFY_HEART = `rbxassetid://{243134865}`,
    SKULL = `rbxassetid://{242223105}`,
    FIRE_SKULL = `rbxassetid://{254286130}`,
    GHOST = `rbxassetid://{242213983}`,
    BAT = `rbxassetid://{18356613650}`,
    SNOWFLAKE = `rbxassetid://{242837894}`,
    LEAF = `rbxassetid://{289092576}`,
    MAPLE = `rbxassetid://{915916073}`,
    FEATHER = `rbxassetid://{242842525}`,
    BUBBLE = `rbxassetid://{242214111}`,
    GEM = `rbxassetid://{871125127}`,
    CROWN = `rbxassetid://{90801442894167}`,
    COIN = `rbxassetid://{8581764815}`,
    CANDY = `rbxassetid://{116802131222258}`,
    PAW = `rbxassetid://{11677094284}`,
    NOTE = `rbxassetid://{122628207763270}`,
    SHARD = `rbxassetid://{12130244331}`,
    SPLASH_ICON = `rbxassetid://{243457340}`,
    MAGIC = `rbxassetid://{243728104}`,
    CANDY_STRIPED = `rbxassetid://{16009227210}`,
    CANDY_PURPLE = `rbxassetid://{77563503978277}`,
    LOLLIPOP = `rbxassetid://{7047566095}`,
    RED_LEAF = `rbxassetid://{13003836465}`,
    TEAL_STAR = `rbxassetid://{16017520341}`,
    PURPLE_STAR = `rbxassetid://{92911623228383}`,
    BLUE_STAR = `rbxassetid://{131679330853412}`,
    FIREBALL = `rbxassetid://{341300088}`,
    PLASMA = `rbxassetid://{528280825}`,
    SCIFI = `rbxassetid://{463021019}`,
    MAGIC_FIRE = `rbxassetid://{463023400}`,
    SSJ = `rbxassetid://{347730682}`,
    SMOKE = "rbxasset://textures/particles/smoke_main.dds",
    DARK_CLOUD = `rbxassetid://{10180479311}`,
    WISPS = `rbxassetid://{5872447086}`,
    CLOUD = `rbxassetid://{275871881}`,
    FIRE_SPECS = `rbxassetid://{11187840108}`,
    ARC = `rbxassetid://{14477910720}`,
    WIND_ARC = `rbxassetid://{16669803246}`,
    WIND_SWIRL = `rbxassetid://{12685367098}`,
    WIND = `rbxassetid://{16950679789}`,
    SPIN_LINES = `rbxassetid://{1084969997}`,
    CRESCENT = `rbxassetid://{8096189152}`,
    RING = "rbxasset://textures/particles/explosion01_shockwave_main.dds",
    SOFT_RING = `rbxassetid://{8271495905}`,
    THIN_RING = `rbxassetid://{17063107542}`,
    ELECTRIC_RING = `rbxassetid://{7150933366}`,
    FIRE = `rbxassetid://{16676455805}`,
    FIRE2 = `rbxassetid://{13818306392}`,
    FIRE3 = `rbxassetid://{16676544947}`,
    FIRE_BIG = `rbxassetid://{11395090403}`,
    ASH = `rbxassetid://{16955854038}`,
    GHOST_SMOKE = `rbxassetid://{16669188960}`,
    PUFF = `rbxassetid://{14595543880}`,
    WATER = `rbxassetid://{16664715772}`,
    DROPS = `rbxassetid://{16664772965}`,
    SPLASH = `rbxassetid://{17063077953}`,
    SHOCKWAVE = `rbxassetid://{16477162837}`,
    LIGHTNING = `rbxassetid://{16664675233}`,
    BOLT = `rbxassetid://{16676250078}`,
    BIG_BOLT = `rbxassetid://{13771290435}`,
    ENERGY = `rbxassetid://{15041986621}`,
    FLAME_EYE = `rbxassetid://{14163162698}`,
    HEARTS = `rbxassetid://{12758468376}`,
    STARS = `rbxassetid://{110324134347385}`,
    SPARKLES = `rbxassetid://{115317702570755}`,
    SPIN_STAR = `rbxassetid://{13580358178}`,
    FLARING_STAR = `rbxassetid://{117506898436985}`,
    PLUS_STARS = `rbxassetid://{84576566858602}`,
    BUBBLES = `rbxassetid://{16924362907}`,
    LEAVES = `rbxassetid://{96793444669610}`,
    SHARDS = `rbxassetid://{111860228388694}`,
    DRIP = `rbxassetid://{12757089364}`,
    FEATHERS = `rbxassetid://{11205713751}`,
    SPIN_COIN = `rbxassetid://{9147387925}`,
    SPIN_GEM = `rbxassetid://{16653219599}`,
    GEM_FLAME = `rbxassetid://{17277489248}`,
    ROCKS = `rbxassetid://{12111686783}`,
    SNOW_BITS = `rbxassetid://{97817549850353}`,
    ORB = `rbxassetid://{82013742937250}`,
    GLITCH = `rbxassetid://{101998103331334}`,
    GLITCH_LINES = `rbxassetid://{18414837210}`,
    RUNES = `rbxassetid://{10713705343}`
}

t1.T = t2

local t3 = {}

for _, v1 in {
        "FIRE",
        "FIRE2",
        "FIRE3",
        "FIRE_BIG",
        "ASH",
        "GHOST_SMOKE",
        "PUFF",
        "WATER",
        "DROPS",
        "SPLASH",
        "SHOCKWAVE",
        "LIGHTNING",
        "BOLT",
        "BIG_BOLT",
        "ENERGY",
        "FLAME_EYE",
        "HEARTS",
        "STARS",
        "SPARKLES",
        "SPIN_STAR",
        "FLARING_STAR",
        "PLUS_STARS",
        "BUBBLES",
        "LEAVES",
        "SHARDS",
        "DRIP",
        "FEATHERS",
        "SPIN_COIN",
        "SPIN_GEM",
        "GEM_FLAME",
        "RUNES",
        "GLITCH"
    } do
    t3[t2[v1]] = Enum.ParticleFlipbookLayout.Grid4x4
end

t3[t2.SNOW_BITS] = Enum.ParticleFlipbookLayout.Grid8x8
t3[t2.ORB] = Enum.ParticleFlipbookLayout.Grid8x8
t3[t2.ROCKS] = Enum.ParticleFlipbookLayout.Grid2x2

local t4 = {}

for _, v2 in { "CRESCENT", "FLASH", "RAYS", "SPECK", "SPIN_LINES", "STAR4", "WIND_SWIRL" } do
    t4[t2[v2]] = true
end

local t5 = {}

for _, v3 in {
        "HEART",
        "PUFFY_HEART",
        "SKULL",
        "FIRE_SKULL",
        "GHOST",
        "BAT",
        "SNOWFLAKE",
        "LEAF",
        "MAPLE",
        "FEATHER",
        "BUBBLE",
        "GEM",
        "CROWN",
        "COIN",
        "CANDY",
        "PAW",
        "NOTE",
        "SHARD",
        "CANDY_STRIPED",
        "CANDY_PURPLE",
        "LOLLIPOP",
        "RED_LEAF",
        "CRESCENT",
        "HEARTS",
        "LEAVES",
        "FEATHERS",
        "SPIN_COIN",
        "SPIN_GEM",
        "BUBBLES",
        "DRIP"
    } do
    t5[t2[v3]] = true
end

t1.GRID = t3
t1.ON_BLACK = t4
t1.ICON = t5

return t1
