-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "screen", "hud", "rgl-reward-manager").default
local default2 = RuntimeLib.import(script, script.Parent, "screen", "hud", "pinata-boss-reward-manager").default
local default3 = RuntimeLib.import(script, script.Parent, "screen", "hud", "celebration-reward-manager").default
local default4 = RuntimeLib.import(script, script.Parent, "screen", "hud", "minigame-reward-manager").default
local default5 = RuntimeLib.import(script, script.Parent, "screen", "hud", "shard-reward-manager").default
local default6 = RuntimeLib.import(script, script.Parent, "screen", "aquarium-crate", "aquarium-crate-reward-manager").default
local default7 = RuntimeLib.import(script, script.Parent, "lucky-block", "lucky-block-reveal-manager").default

return {
    default = function(p1) -- RewardPresentationHost | line: 11
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), default5 (copy), default6 (copy), default7 (copy)
        local enabled = p1.enabled

        return react.createElement("screengui", {
            DisplayOrder = 2000,
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            Enabled = enabled,
            ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
            ZIndexBehavior = Enum.ZIndexBehavior.Global
        }, react.createElement(default6), react.createElement(default2), react.createElement(default), react.createElement(default3), react.createElement(default4), react.createElement(default7), react.createElement(default5))
    end
}
