-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 6
    -- upvalues: t1 (copy)
    return (setmetatable({
        Guessed = true,
        Count = p1,
        Slots = table.create(p1, 0)
    }, t1))
end

function t1.Add(p2, p3) -- line: 10
    if p2.Guessed then
        for i = 1, p2.Count do
            if p2.Slots[i] == 0 then
                p2.Slots[i] = p3

                return
            end
        end
    end
end

function t1.Remove(p4, p5) -- line: 17
    for i = 1, p4.Count do
        if p4.Slots[i] == p5 then
            p4.Slots[i] = p4.Guessed and 0 or -1
        end
    end
end

function t1.Invalidate(p6) -- line: 25
    p6.Guessed = false

    for i = 1, p6.Count do
        p6.Slots[i] = -1
    end
end

function t1.Recover(p7, p8, p9) -- line: 30
    if p8 < 1 or p7.Count < p8 then
        return
    end

    if p7.Guessed and p7.Slots[p8] ~= p9 then
        p7:Invalidate()
    end

    p7:Remove(p9)
    p7.Slots[p8] = p9
end

return t1
