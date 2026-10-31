-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animals, v1
local n1 = 0
local BindableEvent = Instance.new("BindableEvent")

return {
    Changed = BindableEvent.Event,
    Get = function(p1) -- Get | line: 28
        -- upvalues: ReplicatedStorage (copy), Animals (ref), v1 (ref)
        if v1 then
            local v2 = v1
            local ok, result = pcall(v2, p1)

            if ok and result then
                return result
            end
        end

        if not (Animals and Animals.Parent) then
            Animals = ReplicatedStorage:FindFirstChild("Animals")
        end

        return Animals and Animals:FindFirstChild(p1) or nil
    end,
    SetOverride = function(p2) -- SetOverride | line: 40
        -- upvalues: v1 (ref), n1 (ref), BindableEvent (copy)
        if p2 == v1 then
            return
        end

        v1 = p2
        n1 += 1
        BindableEvent:Fire()
    end,
    HasOverride = function() -- HasOverride | line: 47
        -- upvalues: v1 (ref)
        return v1 ~= nil
    end,
    Version = function() -- Version | line: 51
        -- upvalues: n1 (ref)
        return n1
    end
}
