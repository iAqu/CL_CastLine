-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)

return function(p1) -- line: 8
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("GuiObject"))(p1)

    local UIScale = p1:FindFirstChildWhichIsA("UIScale")

    if UIScale then
        return UIScale
    end

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Parent = p1

    return UIScale2
end
