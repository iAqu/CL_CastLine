-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

function _merge1(p1, p2, p3) -- line: 93
    if not p2.Left then
        p2.Left = p3

        return p2
    end

    p2.Right = _merge(p1, p2.Right, p3)

    if p2.Left.Npl < p2.Right.Npl then
        local Right, Left = p2.Right, p2.Left

        p2.Left = Right
        p2.Right = Left
    end

    p2.Npl = p2.Right.Npl + 1

    return p2
end

function _merge(p4, p5, p6) -- line: 112
    if not p5 then
        return p6
    end

    if not p6 then
        return p5
    end

    if p4(p5.Value, p6.Value) < 0 then
        return _merge1(p4, p5, p6)
    end

    return _merge1(p4, p6, p5)
end

local t1 = {}
local v1 = table.freeze({
    __index = t1
})

function t1.Merge(p7, p8) -- line: 131
    if p7.Root ~= p8.Root then
        p7.Root = _merge(p7.Comparator, p7.Root, p8.Root)
        p8.Root = nil
    end
end

function t1.Insert(p9, p10) -- line: 138
    p9.Root = _merge(p9.Comparator, {
        Npl = 0,
        Value = p10
    }, p9.Root)
end

function t1.Min(p11) -- line: 145
    assert(p11.Root)

    return p11.Root.Value
end

function t1.TryMin(p12) -- line: 150
    if p12.Root then
        return true, p12.Root.Value
    end

    return false, nil
end

function t1.Pop(p13) -- line: 157
    assert(p13.Root)

    local Value = p13.Root.Value

    p13.Root = _merge(p13.Comparator, p13.Root.Left, p13.Root.Right)

    return Value
end

function t1.TryPop(p14) -- line: 164
    if not p14.Root then
        return false, nil
    end

    local Value = p14.Root.Value

    p14.Root = _merge(p14.Comparator, p14.Root.Left, p14.Root.Right)

    return true, Value
end

function t1.PopFast(p15) -- line: 173
    p15.Root = _merge(p15.Comparator, p15.Root.Left, p15.Root.Right)
end

function t1.Empty(p16) -- line: 177
    return p16.Root == nil
end

function t1.Clear(p17) -- line: 181
    p17.Root = nil
end

table.freeze(t1)

local t2 = {
    Compare = function(p18, p19) -- Compare | line: 190
        if p18 < p19 then
            return -1
        end

        if p19 < p18 then
            return 1
        end

        return 0
    end,
    new = function(p20, _) -- new | line: 200
        -- upvalues: v1 (copy)
        assert(type(p20) == "function")

        return (setmetatable({
            Comparator = p20
        }, v1))
    end
}

return table.freeze(t2)
