-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Promise = require(ReplicatedStorage.Packages.Promise)

return function(p1, p2, p3, p4) -- line: 8
    -- upvalues: Promise (copy)
    local v1 = p2 or 5

    assert(v1 >= 1 and v1 % 1 == 0, "retry attempts must be a positive integer")
    assert(p3 == nil == (p4 == nil), "retry delay range needs both minimum and maximum")

    if p3 and p4 then
        assert(p3 >= 0 and p3 <= p4, "invalid retry delay range")
    end

    return Promise.new(function(p5, p6) -- line: 24
        -- upvalues: p1 (copy), p3 (copy), p4 (copy), v1 (copy)
        local v5 = Random.new()
        local v6

        for i = 1, v1 do
            if i > 1 then
                local v7 = 2 ^ (i - 2)

                if p3 and p4 then
                    v7 = v5:NextNumber(p3 * v7, p4 * v7)
                end

                task.wait(v7)
            end

            local v8 = table.pack(pcall(p1))

            if v8[1] then
                p5(table.unpack(v8, 2, v8.n))

                return
            end

            v6 = v8[2]
        end

        p6((("gave up after %* attempts; last failure: %*"):format(v1, v6)))
    end)
end
