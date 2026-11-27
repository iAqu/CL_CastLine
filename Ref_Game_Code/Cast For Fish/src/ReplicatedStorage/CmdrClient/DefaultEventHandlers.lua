-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local StarterGui = game:GetService("StarterGui")
local Window = require(script.Parent.CmdrInterface.Window)

return function(p1) -- line: 4
    -- upvalues: StarterGui (copy), Window (copy)
    p1:HandleEvent("Message", function(p2) -- line: 5
        -- upvalues: StarterGui (copy)
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = ("[Announcement] %s"):format(p2),
            Color = Color3.fromRGB(249, 217, 56)
        })
    end)
    p1:HandleEvent("AddLine", function(...) -- line: 12
        -- upvalues: Window (copy)
        Window:AddLine(...)
    end)
end
