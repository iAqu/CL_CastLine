-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    WINDOWS = {
        {
            from = 1795888800,
            to = 1795892400,
            luck = 2,
            serverLuck = true
        },
        {
            from = 1795892400,
            to = 1795899600,
            serverLuck = true
        }
    },
    Now = function() -- Now | line: 32
        return workspace:GetServerTimeNow() + (tonumber(workspace:GetAttribute("BoostEventOffset")) or 0)
    end
}

function t1.Active(p1) -- line: 36
    -- upvalues: t1 (copy)
    p1 = p1 or t1.Now()

    for _, v2 in ipairs(t1.WINDOWS) do
        if v2.from <= p1 and p1 < v2.to then
            return v2, p1
        end
    end

    return nil, p1
end

local function mul(p2) -- line: 43
    -- upvalues: t1 (copy)
    local v3 = t1.Active()

    return v3 and v3[p2] or 1
end

function t1.FatMul() -- line: 47
    -- upvalues: t1 (copy)
    local v4 = t1.Active()

    return v4 and v4.fat or 1
end

function t1.CashMul() -- line: 48
    -- upvalues: t1 (copy)
    local v5 = t1.Active()

    return v5 and v5.cash or 1
end

function t1.LuckMul() -- line: 49
    -- upvalues: t1 (copy)
    local v6 = t1.Active()

    return v6 and v6.luck or 1
end

function t1.Test(p3) -- line: 52
    -- upvalues: t1 (copy)
    if p3 == false then
        workspace:SetAttribute("BoostEventOffset", nil)

        return "boost event: real time"
    end

    local v7 = t1.WINDOWS[1]

    workspace:SetAttribute("BoostEventOffset", v7.from - (tonumber(p3) or 0) - workspace:GetServerTimeNow())

    return ("boost event: starts in %d s on this server (for %d min)"):format(tonumber(p3) or 0, (v7.to - v7.from) // 60)
end

return t1
