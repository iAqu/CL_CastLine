-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useRootSelectorCreator = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelectorCreator
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectEquippedItemType = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectEquippedItemType
local default = RuntimeLib.import(script, script.Parent, "slap-button").default

return {
    default = function(_) -- TouchGuiReplica | line: 9
        -- upvalues: react (copy), useRootSelectorCreator (copy), localPlayerUserId (copy), selectEquippedItemType (copy), default (copy)
        local v1 = useRootSelectorCreator(selectEquippedItemType, localPlayerUserId) == "slapWeapon"

        return react.createElement("screengui", {
            ResetOnSpawn = false
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, v1 and react.createElement(default)))
    end
}
