-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function EmitOnce(p1) -- line: 20
    local TimeScale = p1.TimeScale

    if TimeScale <= 0 then
        return 0
    end

    local Rate = p1.Rate
    local EmitCount = p1:GetAttribute("EmitCount")

    if type(EmitCount) ~= "number" then
        EmitCount = Rate
    end

    local v1 = math.floor(EmitCount)
    local v2 = v1
    local v3 = EmitCount - v1

    if v3 > 0 and math.random() < v3 then
        v1 += 1
        v2 = v1
    end

    if v1 < 1 then
        return 0
    end

    local EmitDelay = p1:GetAttribute("EmitDelay")

    if type(EmitDelay) ~= "number" then
        EmitDelay = 0
    end

    if EmitDelay == 1e999 then
        return 0
    end

    local v4 = math.max(EmitDelay, 0)

    task.delay(v4, function() -- line: 51
        -- upvalues: p1 (copy), v2 (ref)
        p1:Emit(v2)
    end)

    return v4 + p1.Lifetime.Max / TimeScale
end

return EmitOnce
