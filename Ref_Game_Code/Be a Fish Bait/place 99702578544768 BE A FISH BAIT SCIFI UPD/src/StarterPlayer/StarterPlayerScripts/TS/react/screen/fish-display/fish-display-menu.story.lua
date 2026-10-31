-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local fishImages = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").fishImages
local default2 = RuntimeLib.import(script, script.Parent, "fish-display-menu").default
local t1 = {
    {
        skinName = "Default",
        displayName = "Default",
        imageId = "rbxassetid://0",
        rarity = "common"
    },
    {
        skinName = "Cake",
        displayName = "Cake",
        imageId = "rbxassetid://0",
        rarity = "rare"
    }
}
local t2 = {
    {
        fishId = "mock-0",
        fishName = "Verdantus",
        rarity = "extinct",
        level = 70,
        moneyPerSecond = 950000,
        offlineEarningPerSec = 9500,
        mutation = "Normal",
        imageId = fishImages.Verdantus
    },
    {
        fishId = "mock-1",
        fishName = "Leviathan",
        rarity = "cosmic",
        level = 60,
        moneyPerSecond = 5000,
        offlineEarningPerSec = 50,
        mutation = "Normal",
        imageId = fishImages.leviathan
    },
    {
        fishId = "mock-2",
        fishName = "Abyss Whale",
        rarity = "hacked",
        level = 58,
        moneyPerSecond = 4000,
        offlineEarningPerSec = 40,
        mutation = "Normal",
        imageId = fishImages.abyssWhale
    },
    {
        fishId = "mock-3",
        fishName = "Angler Fish",
        rarity = "secret",
        level = 55,
        moneyPerSecond = 3000,
        offlineEarningPerSec = 30,
        mutation = "Normal",
        imageId = fishImages.anglerFish
    },
    {
        fishId = "mock-4",
        fishName = "Frost Tooth",
        rarity = "godly",
        level = 52,
        moneyPerSecond = 2000,
        offlineEarningPerSec = 20,
        mutation = "Normal",
        imageId = fishImages.frostTooth
    },
    {
        fishId = "mock-5",
        fishName = "Berrywhal",
        rarity = "mythic",
        level = 50,
        moneyPerSecond = 1000,
        offlineEarningPerSec = 10,
        mutation = "Normal",
        imageId = fishImages.berrywhal
    },
    {
        fishId = "inv-6",
        fishName = "Whale Shark",
        rarity = "legendary",
        level = 45,
        moneyPerSecond = 420,
        offlineEarningPerSec = 4.2,
        mutation = "Normal",
        imageId = fishImages.whaleShark
    },
    {
        fishId = "inv-7",
        fishName = "Orca",
        rarity = "epic",
        level = 30,
        moneyPerSecond = 120,
        offlineEarningPerSec = 1.2,
        mutation = "Normal",
        imageId = fishImages.orca
    },
    {
        fishId = "inv-8",
        fishName = "Noob Fish",
        rarity = "rare",
        level = 22,
        moneyPerSecond = 35,
        offlineEarningPerSec = 0.35,
        mutation = "Normal",
        imageId = fishImages.noobFish
    },
    {
        fishId = "inv-10",
        fishName = "Sun Fish",
        rarity = "common",
        level = 8,
        moneyPerSecond = 6,
        offlineEarningPerSec = 0.06,
        mutation = "Normal",
        imageId = fishImages.sunFish
    }
}

local function FishDisplayMenuShowcase() -- line: 112
    -- upvalues: react (copy), useState (copy), default2 (copy), t1 (copy), t2 (copy)
    local v1, v2 = useState(true)
    local v3, v4 = useState("mock-1")
    local Default, Default2 = useState("Default")
    local v5 = table.create(#t1)

    for v6, v7 in t1 do
        local _ = v6 - 1
        local v8 = table.clone(v7)

        setmetatable(v8, nil)
        v8.isActive = v7.skinName == Default
        v5[v6] = v8
    end

    local createElement = react.createElement
    local t3 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v9 = not v1

    v9 = v9 and react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "Open Fish Display",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(50, 120, 200),
        Event = {
            Activated = function() -- Activated | line: 137
                -- upvalues: v2 (copy)
                return v2(true)
            end
        },
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(220, 50),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.1, 0)
    }))
    v1 = v1 and react.createElement(default2, {
        fish = t2,
        hologramSkins = v5,
        onClose = function() -- onClose | line: 152
            -- upvalues: v2 (copy)
            return v2(false)
        end,
        onEquipHologramSkin = Default2,
        onSelectFish = function(p1) -- onSelectFish | line: 156
            -- upvalues: v4 (copy)
            return v4(function(p2) -- line: 157
                -- upvalues: p1 (copy)
                return if p2 ~= p1 then p1 else nil
            end)
        end,
        selectedFishId = v3
    })

    return createElement("frame", t3, v9, v1)
end

return storyForScreenGui(react.createElement(default, {
    initialState = {}
}, react.createElement(FishDisplayMenuShowcase)), {
    zIndexBehavior = Enum.ZIndexBehavior.Sibling
})
