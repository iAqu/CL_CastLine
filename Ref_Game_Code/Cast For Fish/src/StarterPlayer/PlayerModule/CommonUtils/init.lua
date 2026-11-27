-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    _mocks = {}
}

function t1.mock(p1, p2) -- line: 16
    -- upvalues: t1 (copy)
    t1._mocks[p1] = p2
end

function t1.get(p3) -- line: 20
    -- upvalues: t1 (copy)
    if t1._mocks[p3] then
        return require(t1._mocks[p3])
    end

    if script:FindFirstChild(p3) then
        return require(script:FindFirstChild(p3))
    end

    assert(false, "Util does not exist: " .. p3)
end

return t1
