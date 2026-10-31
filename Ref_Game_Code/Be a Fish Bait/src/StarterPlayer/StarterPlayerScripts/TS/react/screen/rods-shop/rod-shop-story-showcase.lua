-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default = RuntimeLib.import(script, script.Parent, "rod-shop-vfx").default
local default2 = RuntimeLib.import(script, script.Parent, "rod-skins").default
local default3 = RuntimeLib.import(script, script.Parent, "rods-shop").default
local t1 = {
    {
        description = "A confetti-and-smoke burst when your fish lands.",
        displayName = "FOMO Party",
        isOwned = false,
        vfxId = "PartyFishLandingVFX",
        imageId = images.reelbackVfxIcon
    }
}

return {
    default = function(p1) -- RodShopStoryShowcase | line: 17
        -- upvalues: react (copy), useState (copy), default (copy), default2 (copy), default3 (copy), t1 (copy)
        local v1, v2 = useState(p1.initialTab)
        local v3, v4 = useState(nil)

        if v1 == "skin" then
            return react.createElement(default2, {
                onClose = p1.onClose,
                onSelectTab = v2
            })
        end

        if v1 ~= "vfx" then
            return react.createElement(default3, {
                onClose = p1.onClose,
                onSelectTab = v2
            })
        end

        return react.createElement(default, {
            equippedVfxId = v3,
            onClose = p1.onClose,
            onEquip = v4,
            onSelectTab = v2,
            onUnequip = function() -- onUnequip | line: 32
                -- upvalues: v4 (copy)
                return v4(nil)
            end,
            vfxItems = t1
        })
    end
}
