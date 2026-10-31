-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local PolicyService, Players = services.PolicyService, services.Players

return {
    useDiscordLinkAllowed = function() -- useDiscordLinkAllowed | line: 12
        return true
    end,
    usePaidItemsAllowed = function() -- usePaidItemsAllowed | line: 28
        -- upvalues: useEffect (copy), useState (copy), PolicyService (copy), Players (copy)
        local v1, v2 = useState(false)

        useEffect(function() -- line: 30
            -- upvalues: v2 (copy), PolicyService (copy), Players (copy)
            local v3 = task.spawn(function() -- line: 31
                -- upvalues: v2 (copy), PolicyService (copy), Players (copy)
                if not PolicyService:GetPolicyInfoForPlayerAsync(Players.LocalPlayer).ArePaidRandomItemsRestricted then
                    v2(true)
                end
            end)

            return function() -- line: 37
                -- upvalues: v3 (copy)
                task.cancel(v3)
            end
        end, {})

        return v1
    end
}
