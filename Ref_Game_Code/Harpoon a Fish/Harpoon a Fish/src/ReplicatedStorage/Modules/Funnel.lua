-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TelemetryReport = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TelemetryReport")
local t1 = {}
local t2 = {}
local t3 = {}
local v1 = false

local function send(p1) -- line: 15
    -- upvalues: TelemetryReport (copy)
    TelemetryReport:FireServer("funnel", p1)
end

function t1.Report(p2) -- line: 19
    -- upvalues: TelemetryReport (copy), t2 (copy), t3 (copy), v1 (ref)
    if t2[p2] then
        return
    end

    t2[p2] = true

    if p2 == "loaded" then
        v1 = true
        TelemetryReport:FireServer("funnel", p2)

        for _, v2 in ipairs(t3) do
            TelemetryReport:FireServer("funnel", v2)
        end

        table.clear(t3)
    elseif v1 then
        TelemetryReport:FireServer("funnel", p2)
    else
        t3[#t3 + 1] = p2
    end
end

return t1
