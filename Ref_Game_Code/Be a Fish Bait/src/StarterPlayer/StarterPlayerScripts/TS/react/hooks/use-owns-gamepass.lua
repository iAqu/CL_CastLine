-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useRootSelector = RuntimeLib.import(script, script.Parent, "reflex").useRootSelector
local selectPlayerOwnsGamepass = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerOwnsGamepass
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId

return {
    useOwnsGamepass = function(p1) -- useOwnsGamepass | line: 12
        -- upvalues: useRootSelector (copy), selectPlayerOwnsGamepass (copy), localPlayerUserId (copy)
        local v1 = useRootSelector(selectPlayerOwnsGamepass(localPlayerUserId, p1))

        if v1 == nil then
            v1 = false
        end

        return v1
    end
}
