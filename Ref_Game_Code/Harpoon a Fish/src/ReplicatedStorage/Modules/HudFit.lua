-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local t1 = {
    ASPECT = 1.7777777777777777
}

t1.ACTIVE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled and not GuiService:IsTenFootInterface()

function t1.Factor(p1, p2) -- line: 18
    -- upvalues: t1 (copy)
    if not t1.ACTIVE or p1 <= 0 or p2 <= 0 then
        return 1
    end

    return (math.min(1, p1 / p2 / t1.ASPECT))
end

return t1
