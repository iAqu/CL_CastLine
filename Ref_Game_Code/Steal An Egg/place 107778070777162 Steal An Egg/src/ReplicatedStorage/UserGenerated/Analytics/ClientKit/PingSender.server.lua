-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Ping = script.Parent:WaitForChild("Ping")
local n1 = 0
local n2 = 0

local function SendPing() -- line: 27
    -- upvalues: Ping (copy), n2 (ref)
    n2 += 1
    Ping:FireServer(n2, workspace:GetServerTimeNow())
end

RunService.Heartbeat:Connect(function(p1) -- line: 31
    -- upvalues: Ping (copy), n1 (ref), n2 (ref)
    n1 += p1

    if not (n1 >= 1) then
        return
    end

    n1 %= 1
    n2 += 1
    Ping:FireServer(n2, workspace:GetServerTimeNow())
end)
task.spawn(SendPing)
