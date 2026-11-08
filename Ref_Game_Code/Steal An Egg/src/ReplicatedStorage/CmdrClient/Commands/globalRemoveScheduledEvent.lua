-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

return {
    Name = "globalRemoveScheduledEvent",
    Description = "Schedules an event in all servers",
    Group = "Moderator",
    Args = {
        function(p1) -- line: 10
            -- upvalues: RunService (copy), ServerScriptService (copy)
            local v1 = if RunService:IsServer() then require(ServerScriptService.Controllers.AdminAbuseService).GetScheduledEvents() else require(game:GetService("ReplicatedStorage").Shared.Remotes).LiveEvents.FetchScheduled:InvokeServer()
            local t2 = {}

            for v2 in v1 do
                table.insert(t2, v2)
            end

            return {
                Name = "ScheduledEventKey",
                Type = p1.Cmdr.Util.MakeEnumType("scheduleEventKey", t2)
            }
        end
    }
}
