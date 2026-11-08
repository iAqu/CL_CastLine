-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local Touch, Keyboard = Enum.UserInputType.Touch, Enum.UserInputType.Keyboard
local t1
local t2 = {}

t1 = {
    Current = "MouseKeyboard",
    Observe = function(p1) -- Observe | line: 83
        -- upvalues: t1 (ref), t2 (copy)
        if table.find(t2, p1) then
            error("function already subscribed", 2)
        end

        table.insert(t2, p1)
        task.spawn(p1, t1.Current)

        return function() -- line: 91
            -- upvalues: p1 (copy), t2 (copy)
            local v1 = table.find(t2, p1)

            if not v1 then
                return
            end

            local v2 = #t2

            t2[v1] = t2[v2]
            t2[v2] = nil
        end
    end
}

local function SetPreferred(p2) -- line: 101
    -- upvalues: t1 (ref), t2 (copy)
    if p2 == t1.Current then
        return
    end

    t1.Current = p2

    for _, v3 in t2 do
        task.spawn(v3, p2)
    end
end

local function DeterminePreferred(p3) -- line: 112
    -- upvalues: Touch (copy), Keyboard (copy), SetPreferred (copy)
    if p3 == Touch then
        SetPreferred("Touch")
    else
        if p3 ~= Keyboard and string.sub(p3.Name, 1, 5) ~= "Mouse" then
            if string.sub(p3.Name, 1, 7) == "Gamepad" then
                SetPreferred("Gamepad")
            end

            return
        end

        SetPreferred("MouseKeyboard")
    end
end

local LastInputType = UserInputService:GetLastInputType()

if LastInputType == Touch then
    SetPreferred("Touch")
else
    local v4 = LastInputType == Keyboard
    local v5 = if not v4 then string.sub(LastInputType.Name, 1, 5) == "Mouse" else nil

    if v4 or v5 then
        SetPreferred("MouseKeyboard")
    elseif string.sub(LastInputType.Name, 1, 7) == "Gamepad" then
        SetPreferred("Gamepad")
    end
end

UserInputService.LastInputTypeChanged:Connect(DeterminePreferred)

return t1
