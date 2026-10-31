-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local usePlayers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "hooks", "use-players").usePlayers
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local listenForCharacter = RuntimeLib.import(script, script.Parent.Parent.Parent, "character-utils").listenForCharacter

return {
    useCharacter = function(p1) -- useCharacter | line: 10
        -- upvalues: useEffect (copy), useState (copy), listenForCharacter (copy)
        local v1, v2 = useState(p1.Character)

        useEffect(function() -- line: 12
            -- upvalues: p1 (copy), v2 (copy), listenForCharacter (copy)
            return listenForCharacter(p1, v2)
        end, { p1 })

        return v1
    end,
    useCharacterByUserId = function(p2) -- useCharacterByUserId | line: 25
        -- upvalues: useEffect (copy), useState (copy), Players (copy), Maid (copy), listenForCharacter (copy)
        local v3, v4 = useState(function() -- line: 26
            -- upvalues: p2 (copy), Players (copy)
            local PlayerByUserId = Players:GetPlayerByUserId(p2)

            if PlayerByUserId ~= nil then
                PlayerByUserId = PlayerByUserId.Character
            end

            return PlayerByUserId
        end)

        useEffect(function() -- line: 34
            -- upvalues: p2 (copy), v4 (copy), Players (copy), Maid (copy), listenForCharacter (copy)
            local v5 = Maid.new()
            local PlayerByUserId = Players:GetPlayerByUserId(p2)

            if PlayerByUserId then
                v4(PlayerByUserId.Character)
                v5:GiveTask((listenForCharacter(PlayerByUserId, v4)))
            else
                v4(nil)
            end

            v5:GiveTask((Players.PlayerAdded:Connect(function(p3) -- line: 52
                -- upvalues: v5 (copy), p2 (copy), v4 (copy), listenForCharacter (copy)
                if p3.UserId ~= p2 then
                    return
                end

                v4(p3.Character)
                v5:GiveTask((listenForCharacter(p3, v4)))
            end)))
            v5:GiveTask((Players.PlayerRemoving:Connect(function(p4) -- line: 59
                -- upvalues: p2 (copy), v4 (copy)
                if p4.UserId == p2 then
                    v4(nil)
                end
            end)))

            return function() -- line: 65
                -- upvalues: v5 (copy)
                v5:Destroy()
            end
        end, { p2 })

        return v3
    end,
    useCharacters = function() -- useCharacters | line: 71
        -- upvalues: useEffect (copy), useState (copy), usePlayers (copy), Maid (copy)
        local v7 = usePlayers()
        local v8, v9 = useState({})

        useEffect(function() -- line: 74
            -- upvalues: v7 (copy), v9 (copy), Maid (copy)
            local v10 = Maid.new()

            for _, v11 in v7 do
                local connection = v11.CharacterAdded:Connect(function(p5) -- line: 77
                    -- upvalues: v9 (copy)
                    v9(function(p6) -- line: 78
                        -- upvalues: p5 (copy)
                        local t1 = {}
                        local v12 = #t1
                        local v13 = #p6

                        table.move(p6, 1, v13, v12 + 1, t1)
                        t1[v12 + v13 + 1] = p5

                        return t1
                    end)
                end)
                local connection2 = v11.CharacterRemoving:Connect(function(p7) -- line: 88
                    -- upvalues: v9 (copy)
                    v9(function(p8) -- line: 89
                        -- upvalues: p7 (copy)
                        local t2 = {}
                        local n1 = 0

                        for v14, v15 in p8 do
                            local _ = v14 - 1

                            if v15 ~= p7 == true then
                                n1 += 1
                                t2[n1] = v15
                            end
                        end

                        return t2
                    end)
                end)

                v10:GiveTask(connection)
                v10:GiveTask(connection2)
            end

            local t3 = {}

            local function v16(p9) -- line: 111
                return p9.Character
            end

            local n2 = 0

            for v17, v18 in v7 do
                local _ = v17 - 1
                local Character = v18.Character

                if Character ~= nil then
                    n2 += 1
                    t3[n2] = Character
                end
            end

            v9(t3)

            return function() -- line: 125
                -- upvalues: v10 (copy)
                v10:Destroy()
            end
        end, { v7 })

        return v8
    end
}
