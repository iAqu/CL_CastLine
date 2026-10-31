-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local atom = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").atom
local n1 = 0
local v1 = atom({})
local v2 = atom(0)
local v3 = atom(false)

return {
    pushMoneyBurst = function(p1) -- pushMoneyBurst | line: 12
        -- upvalues: n1 (ref), v1 (copy)
        local t1 = {}
        local v4 = n1

        n1 += 1
        t1.id = v4
        t1.amount = p1
        v1(function(p2) -- line: 20
            -- upvalues: t1 (copy)
            local t2 = {}
            local v5 = #t2
            local v6 = #p2

            table.move(p2, 1, v6, v5 + 1, t2)
            t2[v5 + v6 + 1] = t1

            return t2
        end)
    end,
    removeMoneyBurst = function(p3) -- removeMoneyBurst | line: 31
        -- upvalues: v1 (copy)
        v1(function(p4) -- line: 32
            -- upvalues: p3 (copy)
            local t3 = {}
            local n2 = 0

            for v7, v8 in p4 do
                local _ = v7 - 1

                if v8.id ~= p3 == true then
                    n2 += 1
                    t3[n2] = v8
                end
            end

            return t3
        end)
    end,
    moneyFlyBurstAtom = v1,
    pendingMoneyAtom = v2,
    moneyHudFrozenAtom = v3
}
