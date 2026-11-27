-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local StarterGui = game:GetService("StarterGui")
local v1 = false
local t1 = {}

function t1.setCameraModeToastEnabled(p1) -- line: 10
    -- upvalues: v1 (ref), t1 (copy)
    if p1 or v1 then
        v1 = v1 or true

        if not p1 then
            t1.setCameraModeToastOpen(false)
        end
    end
end

function t1.setCameraModeToastOpen(p2) -- line: 24
    -- upvalues: StarterGui (copy), v1 (ref)
    assert(v1)

    if p2 then
        StarterGui:SetCore("SendNotification", {
            Title = "Camera Control Enabled",
            Text = "Right click to toggle",
            Duration = 3
        })
    end
end

return t1
