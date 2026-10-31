-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local generateCharmCandidate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes").generateCharmCandidate
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent, "charm-window").default

local function CharmWindowShowcase() -- line: 11
    -- upvalues: react (copy), useState (copy), default (copy), generateCharmCandidate (copy), default3 (copy)
    local v1, v2 = useState(true)
    local t1 = {
        "fomo",
        "premiumFomo",
        "pearlfinPup"
    }
    local t2 = {
        ["1"] = generateCharmCandidate(1, 0, 100, function() -- line: 15
            return 0.5
        end)
    }
    local fomo, fomo2 = useState("fomo")
    local pearlfinPup, pearlfinPup2 = useState("pearlfinPup")

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default, {
        enableCameraEffects = false,
        ["in"] = v1
    }, react.createElement(default3, {
        inventoryProps = {
            charmCoresByTier = t2,
            displayedCharmId = fomo,
            equippedAttributesCharmId = pearlfinPup,
            onEquipAttributes = pearlfinPup2,
            onEquipSkin = fomo2,
            onUnequipAttributes = function() -- onUnequipAttributes | line: 34
                -- upvalues: pearlfinPup2 (copy)
                return pearlfinPup2(nil)
            end,
            onUnequipSkin = function() -- onUnequipSkin | line: 37
                -- upvalues: fomo2 (copy)
                return fomo2(nil)
            end,
            ownedCharmIds = t1
        },
        onClose = function() -- onClose | line: 42
            -- upvalues: v2 (copy)
            return v2(false)
        end
    })))
end

return storyForScreenGui(react.createElement(default2, {
    initialState = {}
}, react.createElement(CharmWindowShowcase)))
