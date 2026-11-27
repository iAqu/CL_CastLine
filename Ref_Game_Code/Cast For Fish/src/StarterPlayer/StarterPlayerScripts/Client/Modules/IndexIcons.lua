-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local FishModels = require(Shared.FishModels)
local FishIcons = require(script.Parent.FishIcons)
local v1 = Vector2.new(0.5, 0.5)
local v2 = Color3.new(1, 1, 1)
local v3 = Color3.new(0, 0, 0)
local t1 = {
    "rbxassetid://119681229878731",
    "rbxassetid://133073586858414",
    "rbxassetid://136663547100432",
    "rbxassetid://109578672806223",
    "rbxassetid://94263397537528",
    "rbxassetid://77314889373534",
    "rbxassetid://110784500909395",
    "rbxassetid://111729064073553",
    "rbxassetid://94854249016022",
    "rbxassetid://76241307728762",
    "rbxassetid://77269259032485"
}
local t2 = {
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
local t3 = {}
local v4 = false

local function indexOf(p1) -- line: 59
    -- upvalues: t2 (copy), t3 (copy)
    if next(t3) ~= nil then
        return t3[p1]
    end

    for v5, v6 in t2 do
        t3[v6] = v5
    end

    return t3[p1]
end

local t4 = {}

function t4.Cell(p2) -- line: 70
    -- upvalues: t1 (copy), t2 (copy), t3 (copy)
    if next(t3) == nil then
        for v7, v8 in t2 do
            t3[v8] = v7
        end
    end

    local v9 = t3[p2]

    if not v9 then
        return nil, nil
    end

    local v10 = v9 - 1
    local v11 = t1[v10 // 18 + 1]

    if not v11 then
        return nil, nil
    end

    local v12 = v10 % 18

    return v11, Vector2.new(v12 % 3 * 340, v12 // 3 * 170)
end

function t4.Has(p3) -- line: 84
    -- upvalues: FishIcons (copy), t4 (copy)
    if t4.Cell(p3) == nil then
        return FishIcons.Get(p3, 1) ~= nil
    end

    return true
end

function t4.Picture(p4, p5, p6) -- line: 88
    -- upvalues: FishModels (copy), FishIcons (copy), v1 (copy), v2 (copy), v3 (copy), t4 (copy)
    local v13, v14 = t4.Cell(p5)
    local v15 = if v13 then nil else FishIcons.Get(p5, 1)

    if not (v15 or v13 and v14) then
        return FishModels.Picture(p4, p5, 1, p6)
    end

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "IndexIcon"
    ImageLabel.BackgroundTransparency = 1

    if v15 then
        ImageLabel.Image = v15
    else
        ImageLabel.Image = v13
        ImageLabel.ImageRectOffset = v14
        ImageLabel.ImageRectSize = Vector2.new(340, 170)
    end

    if p6 then
        ImageLabel.ImageColor3 = v3
    else
        ImageLabel.ImageColor3 = v2
    end

    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.AnchorPoint = v1
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ZIndex = p4.ZIndex + 1
    ImageLabel.Parent = p4

    return ImageLabel
end

t4.Loaded = false

function t4.Preload() -- line: 116
    -- upvalues: ContentProvider (copy), t1 (copy), v4 (ref), t4 (copy)
    if v4 or #t1 == 0 then
        return
    end

    v4 = true

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "IndexIconCache"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = -100

    local t5 = {}

    for v16, v17 in t1 do
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Sheet" .. v16
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = v17
        ImageLabel.ImageTransparency = 0.99
        ImageLabel.Size = UDim2.fromOffset(2, 2)
        ImageLabel.Position = UDim2.fromOffset(0, 0)
        ImageLabel.Parent = ScreenGui
        table.insert(t5, ImageLabel)
    end

    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    task.spawn(function() -- line: 138
        -- upvalues: t5 (copy), ContentProvider (copy), t4 (copy)
        local function v18() -- line: 139
            -- upvalues: t5 (copy), ContentProvider (copy)
            ContentProvider:PreloadAsync(t5)
        end

        pcall(v18)
        t4.Loaded = true
    end)
end

return t4
