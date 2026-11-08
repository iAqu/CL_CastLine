-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local t1 = {}
local self = setmetatable({}, {
    __mode = "k"
})

return {
    Mark = function(p1, p2, p3) -- Mark | line: 9
        -- upvalues: RunService (copy), Workspace (copy), t1 (copy), self (copy)
        if not RunService:IsStudio() and Workspace:GetAttribute("TraceOnboarding") ~= true then
            return
        end

        local v2

        if p2 then
            if self[p2] == nil then
                self[p2] = {}
            end

            v2 = self[p2]
        else
            v2 = t1
        end

        if not v2[p1] then
            v2[p1] = true

            local v3 = if RunService:IsServer() then "Server" else "Client"
            local v4 = if p3 then string.format(" duration=%.3fs", p3) else ""

            print(string.format("[OnboardingTiming][%s] %s serverTime=%.3f%s", v3, p1, Workspace:GetServerTimeNow(), v4))
        end
    end
}
