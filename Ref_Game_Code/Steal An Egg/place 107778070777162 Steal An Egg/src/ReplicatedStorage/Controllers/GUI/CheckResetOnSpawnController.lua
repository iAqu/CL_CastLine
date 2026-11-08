-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local StarterGui = game:GetService("StarterGui")
local t1 = {
    "OverlayUI",
    "ScreenGui",
    "ShiftLockButton"
}

return {
    Start = function() -- Start | line: 16
        -- upvalues: StarterGui (copy), t1 (copy)
        task.wait(3)

        for _, child in StarterGui:GetChildren() do
            if not table.find(t1, child.Name) and child:IsA("ScreenGui") and child.ResetOnSpawn then
                error("ScreenGui '" .. child.Name .. "' has ResetOnSpawn enabled, which is not allowed.")
            end
        end
    end
}
