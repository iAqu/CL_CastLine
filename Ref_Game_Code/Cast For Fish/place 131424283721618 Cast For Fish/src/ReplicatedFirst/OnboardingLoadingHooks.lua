-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    used = false,
    assetsLoaded = 0,
    assetsTotal = 0,
    appReadyAt = nil,
    closedAt = nil,
    skipped = false,
    timedOut = false
}

function t1.SetAssets(p1, p2) -- line: 13
    -- upvalues: t1 (copy)
    t1.used = true
    t1.assetsLoaded = math.floor(tonumber(p1) or 0)
    t1.assetsTotal = math.floor(tonumber(p2) or 0)
end

function t1.AppReady() -- line: 20
    -- upvalues: t1 (copy)
    t1.used = true
    t1.appReadyAt = t1.appReadyAt or os.clock()
end

function t1.Closed(p3) -- line: 26
    -- upvalues: t1 (copy)
    t1.used = true

    if t1.closedAt == nil then
        t1.closedAt = os.clock()

        if type(p3) == "table" then
            t1.skipped = p3.skipped == true
            t1.timedOut = p3.timedOut == true
        end
    end
end

return t1
