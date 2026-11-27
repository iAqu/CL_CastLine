-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local FishModels = require(Shared.FishModels)
local v1 = Vector2.new(0.5, 0.5)
local t1 = {
    ["kitsune:1"] = "rbxassetid://75517171705140",
    ["daruma_puffer:1"] = "rbxassetid://81354234035379",
    ["shogun_koi:1"] = "rbxassetid://77320768965805",
    ["origami_ray:1"] = "rbxassetid://103029419841774",
    ["raijin_catfish:1"] = "rbxassetid://137300709875821",
    ["floating_shrine:1"] = "rbxassetid://115372364673572",
    ["stingray:4"] = "rbxassetid://89360073600117",
    ["parrotfish:4"] = "rbxassetid://113867784901099",
    ["anglerfish:4"] = "rbxassetid://80377693487250",
    ["goblin_shark:4"] = "rbxassetid://124029040370108",
    ["leviathan:4"] = "rbxassetid://110925019653875",
    ["pufferfish:2"] = "rbxassetid://130606050186519",
    ["turkey_trout:1"] = "rbxassetid://127430956716260",
    ["cranberry_koi:1"] = "rbxassetid://127044732340627",
    ["stuffing_snapper:1"] = "rbxassetid://92364280343723",
    ["pumpkin_pike:1"] = "rbxassetid://93362491913341",
    ["gravy_grouper:1"] = "rbxassetid://102925586173436",
    ["golden_gobbler:1"] = "rbxassetid://95017195479094"
}
local t2 = {
    "rbxassetid://132263423961282",
    "rbxassetid://123076901928698",
    "rbxassetid://110409660430907",
    "rbxassetid://139661932527348",
    "rbxassetid://103549456260520",
    "rbxassetid://75853835997951",
    "rbxassetid://136596301720050",
    "rbxassetid://78131450003867",
    "rbxassetid://127352180090510",
    "rbxassetid://87593955922306",
    "rbxassetid://111763333368548",
    "rbxassetid://111427710767476",
    "rbxassetid://133322698889088",
    "rbxassetid://100586850329899",
    "rbxassetid://94184887323830",
    "rbxassetid://79544395269518",
    "rbxassetid://83755650037932",
    "rbxassetid://109511839542214",
    "rbxassetid://132913661709567",
    "rbxassetid://87437265603667",
    "rbxassetid://99423484292418",
    "rbxassetid://100807551525255",
    "rbxassetid://118253110036411",
    "rbxassetid://72172722628953",
    "rbxassetid://88086424444173",
    "rbxassetid://94125830108745",
    "rbxassetid://86499004387115",
    "rbxassetid://132609883404619",
    "rbxassetid://83850406340083",
    "rbxassetid://99690280735808",
    "rbxassetid://96188587135400",
    "rbxassetid://126415480487868",
    "rbxassetid://93381543791222",
    "rbxassetid://132547503473913",
    "rbxassetid://99837951227520",
    "rbxassetid://91676066173097",
    "rbxassetid://138442304931214"
}
local t3 = {
    "abyss_angler",
    "abyssal_maw",
    "amethyst_shark",
    "ammonite",
    "amphora_crab",
    "anchor_eel",
    "angelfish",
    "anglerfish",
    "anomalocaris",
    "arcade_puffer",
    "archelon",
    "argus",
    "astro_axolotl",
    "atlas_whale",
    "barnacle_bass",
    "barracuda",
    "barrel_crab",
    "bluegill",
    "bluescreen_titan",
    "bog_titan",
    "boombox_crab",
    "brazen_bull",
    "brimstone_batfish",
    "butterflyfish",
    "buzzsaw_shark",
    "cannon_whale",
    "cerberus_shark",
    "chandelier_jelly",
    "charybdis",
    "cherub_koi",
    "chrono_colossus",
    "cinder_crab",
    "clownfish",
    "coelacanth",
    "coffin_whale",
    "cog_minnow",
    "coin_guppy",
    "comet_eel",
    "corrupt_kraken",
    "cursor_shark",
    "cyclone_squid",
    "daruma_puffer",
    "dread_squid",
    "drone_ray",
    "dunkleosteus",
    "eclipse_manta",
    "ember_tetra",
    "error_crab",
    "eyeball_fry",
    "firefly_jelly",
    "floating_shrine",
    "flounder",
    "frond_stag",
    "frost_eel",
    "galaxy_angler",
    "galaxy_moth",
    "gale_nautilus",
    "gasmask_puffer",
    "gearjaw_shark",
    "gem_snail",
    "geode_golem",
    "geode_puffer",
    "ghost_galleon",
    "ghost_ray",
    "giant_squid",
    "gilded_ray",
    "glacier_mammoth",
    "glacier_pike",
    "gnasher",
    "goblin_shark",
    "grove_manatee",
    "gulper_eel",
    "hammerhead",
    "handcrab",
    "hazmat_ray",
    "helios_wheel",
    "helmet_octopus",
    "hollow_eel",
    "holo_jelly",
    "icefin",
    "inferno_drake",
    "kelp_weaver",
    "khaos",
    "kitsune",
    "kraken",
    "kronos",
    "lag_ray",
    "lanternfish",
    "laser_marlin",
    "laurel_seahorse",
    "lava_colossus",
    "leafback_cod",
    "led_tetra",
    "leviathan",
    "lily_toadfish",
    "lionfish",
    "loading_whale",
    "lunar_whale",
    "lyre_ray",
    "maelstrom",
    "magma_eel",
    "mangrove_hydra",
    "marble_shark",
    "mask_ray",
    "mecha_shark",
    "medusa_jelly",
    "megalodon",
    "meltdown_toad",
    "minnow",
    "missing_texture",
    "moray_eel",
    "mosasaur",
    "moss_ray",
    "mudskipper",
    "mutant_gator",
    "narwhal",
    "nebula_ray",
    "neon_kirin",
    "null_entity",
    "obsidian_shark",
    "ooze_eel",
    "origami_ray",
    "parrotfish",
    "pegafin",
    "pendulum_ray",
    "periscope_pike",
    "phoenix_ray",
    "piston_shrimp",
    "pixel_guppy",
    "plesiosaur",
    "pocketwatch_turtle",
    "polygon_puffer",
    "prism_whale",
    "pufferfish",
    "puppeteer",
    "quartz_eel",
    "raijin_catfish",
    "reaper_marlin",
    "rgb_axolotl",
    "ribcage_shark",
    "rootsnapper",
    "rustjaw",
    "saturn_puffer",
    "saucer_flounder",
    "sea_dragon",
    "sea_scorpion",
    "seahorse",
    "seraphion",
    "shardfin",
    "shogun_koi",
    "skull_isopod",
    "sludge_guppy",
    "snow_skate",
    "solar_shark",
    "sparkfin",
    "spinosaur",
    "squall_ray",
    "stardust_guppy",
    "starlet",
    "statue_eel",
    "stilt_horror",
    "stingray",
    "stitch_eel",
    "storm_sovereign",
    "sunken_sphinx",
    "swamp_gar",
    "swordfish",
    "tempest_shark",
    "temple_guardian",
    "the_sleepless",
    "thornpike",
    "three_eyed_carp",
    "thunder_eel",
    "tidefather",
    "tidewood_ancient",
    "torpedo_penguin",
    "treasure_mimic",
    "trench_stalker",
    "trident_marlin",
    "trilobite",
    "trojan_seahorse",
    "tsunami_whale",
    "tusk_walrus",
    "urchin_knight",
    "venus_maw",
    "viperfish",
    "voidling",
    "widow_squid",
    "windup_tuna",
    "wireframe_eel"
}
local t4 = {}

local function iconKey(p1, p2) -- line: 80
    return p1 .. ":" .. tostring(p2 or 1)
end

local function indexOf(p3) -- line: 84
    -- upvalues: t3 (copy), t4 (copy)
    if next(t4) ~= nil then
        return t4[p3]
    end

    for v3, v4 in t3 do
        t4[v4] = v3
    end

    return t4[p3]
end

local function image(p4, p5, p6) -- line: 93
    -- upvalues: v1 (copy)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "FishIcon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = p5
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.AnchorPoint = v1
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Size = UDim2.fromScale(p6, p6)
    ImageLabel.ZIndex = p4.ZIndex + 1
    ImageLabel.Parent = p4

    return ImageLabel
end

local t5 = {}

function t5.Get(p7, p8) -- line: 109
    -- upvalues: t1 (copy)
    return t1[p7 .. ":" .. tostring(p8 or 1)]
end

function t5.Cell(p9, p10) -- line: 113
    -- upvalues: t2 (copy), t3 (copy), t4 (copy)
    if next(t4) == nil then
        for v6, v7 in t3 do
            t4[v7] = v6
        end
    end

    local v8 = t4[p9]

    p10 = p10 or 1

    if not v8 or p10 < 1 or p10 > 7 or p10 % 1 ~= 0 then
        return nil, nil
    end

    local v10 = (v8 - 1) * 7 + (p10 - 1)
    local v11 = t2[v10 // 36 + 1]
    local v12 = v10 % 36

    if v11 then
        return v11, Vector2.new(v12 % 6 * 170, v12 // 6 * 170)
    end

    return nil, nil
end

function t5.Picture(p11, p12, p13, p14) -- line: 128
    -- upvalues: FishModels (copy), image (copy), t5 (copy)
    p14 = p14 or 1

    local v14 = t5.Get(p12, p13)

    if v14 then
        return (image(p11, v14, p14))
    end

    local v15, v16 = t5.Cell(p12, p13)

    if not v15 or not v16 then
        return FishModels.Picture(p11, p12, p13 or 1, false)
    end

    local v17 = image(p11, v15, p14)

    v17.ImageRectOffset = v16
    v17.ImageRectSize = Vector2.new(170, 170)

    return v17
end

return t5
