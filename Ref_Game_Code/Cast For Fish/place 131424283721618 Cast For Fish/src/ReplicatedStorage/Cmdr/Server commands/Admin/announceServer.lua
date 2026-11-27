-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local TextService = game:GetService("TextService")
local AnnouncementHandler = require(ServerScriptService.Server.Services.AnnouncementHandler)

return function(p1, p2) -- line: 6
    -- upvalues: RunService (copy), TextService (copy), AnnouncementHandler (copy)
    local function v1() -- line: 7
        -- upvalues: p1 (copy), p2 (copy), TextService (copy)
        return TextService:FilterStringAsync(p2, p1.Executor.UserId):GetNonChatStringForBroadcastAsync()
    end

    local ok, result = pcall(v1)

    if not ok or type(result) ~= "string" then
        if not RunService:IsStudio() then
            warn("[announce] Text filtering failed:", result)

            return "Announcement could not be filtered."
        end

        result = tostring(p2)
    end

    AnnouncementHandler.Broadcast(p1.Executor.Name, p1.Executor.UserId, result)

    return "Created announcement."
end
