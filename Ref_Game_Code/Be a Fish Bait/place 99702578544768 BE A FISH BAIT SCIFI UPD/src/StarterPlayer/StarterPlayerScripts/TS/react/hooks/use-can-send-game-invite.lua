-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local SocialService, Players = services.SocialService, services.Players

return {
    useCanSendGameInvite = function() -- useCanSendGameInvite | line: 9
        -- upvalues: useEffect (copy), useState (copy), SocialService (copy), Players (copy)
        local v1, v2 = useState(false)

        useEffect(function() -- line: 11
            -- upvalues: v2 (copy), SocialService (copy), Players (copy)
            local v3 = task.spawn(function() -- line: 12
                -- upvalues: v2 (copy), SocialService (copy), Players (copy)
                v2((SocialService:CanSendGameInviteAsync(Players.LocalPlayer)))
            end)

            return function() -- line: 16
                -- upvalues: v3 (copy)
                return task.cancel(v3)
            end
        end, {})

        return v1
    end
}
