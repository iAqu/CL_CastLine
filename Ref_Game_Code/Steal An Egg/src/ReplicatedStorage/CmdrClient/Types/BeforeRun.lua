-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local t1 = {
    [1927880506] = true,
    [2790707588] = true
}

if RunService:IsServer() then
    local AdminPanelService = require(ServerScriptService.Controllers.AdminPanelService)

    return function(p1) -- line: 13
        -- upvalues: t1 (copy), AdminPanelService (copy)
        p1:RegisterHook("BeforeRun", function(p2) -- line: 14
            -- upvalues: t1 (copy), AdminPanelService (copy)
            local Executor, _ = p2.Executor, p2.Group

            if not t1[Executor.UserId] and AdminPanelService.IsAdmin(Executor) then
                return
            end

            return "You do not have permission to run this function."
        end)
    end
end

local Remotes = require(ReplicatedStorage.Shared.Remotes)

require(ReplicatedStorage.Shared.Globals.Constants)

local v1 = false

Remotes.StaffConsole.StaffVerdict.OnClientEvent:Connect(function(p3) -- line: 36
    -- upvalues: v1 (ref)
    v1 = p3
end)
Remotes.StaffConsole.ProbeStaffStatus:FireServer()

return function(p4) -- line: 40
    -- upvalues: t1 (copy), v1 (ref)
    p4:RegisterHook("BeforeRun", function(p5) -- line: 41
        -- upvalues: t1 (copy), v1 (ref)
        local Executor, _ = p5.Executor, p5.Group

        if not t1[Executor.UserId] and v1 then
            return
        end

        return "You do not have permission to run this function."
    end)
end
