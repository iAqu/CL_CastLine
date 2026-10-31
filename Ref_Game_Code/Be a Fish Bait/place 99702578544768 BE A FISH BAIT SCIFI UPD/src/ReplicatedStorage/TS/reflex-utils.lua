-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local atom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").atom
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t

return {
    reflexStateToAtom = function(p1, p2) -- reflexStateToAtom | line: 5
        -- upvalues: atom (copy)
        local v1 = atom(p2(p1:getState()))

        return {
            v1,
            (p1:subscribe(function(p3, p4) -- line: 7
                -- upvalues: p2 (copy), v1 (copy)
                local v2 = p2(p3)

                if v2 ~= p2(p4) then
                    v1(v2)
                end
            end))
        }
    end,
    isActionForOtherUsersToo = t.interface({
        allowedUserIds = t.array(t.number)
    }),
    isActionForAllUsers = t.interface({
        isForAllUsers = t.literal(true)
    }),
    isActionForServerOnly = t.interface({
        isForServerOnly = t.literal(true)
    })
}
