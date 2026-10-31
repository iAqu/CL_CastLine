-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local charm = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm")
local atom, effect = charm.atom, charm.effect

return {
    getChildAtom = function(p1, p2, p3) -- getChildAtom | line: 6
        -- upvalues: RuntimeLib (copy), atom (copy), effect (copy)
        local v1 = atom(nil)
        local v2 = RuntimeLib.Promise.resolve()
        local v3 = RuntimeLib.async(function(p4) -- line: 9
            -- upvalues: p2 (copy), p3 (copy)
            local v4 = p4:WaitForChild(p2, 15)

            if if v4 == nil then v4 else v4:IsA(p3) then
                return v4
            end

            warn("[src/shared/atom-utils.ts:15]", (("Could not find %* of class %* for %*"):format(p2, p3, (p4:GetFullName()))))

            return nil
        end)

        return {
            childAtom = v1,
            cleanup = effect(function() -- line: 21
                -- upvalues: p1 (copy), p2 (copy), p3 (copy), v1 (copy), v2 (ref), v3 (copy)
                local v5 = p1()

                v2:cancel()

                if not v5 then
                    return nil
                end

                local connection = v5.ChildAdded:Connect(function(p5) -- line: 27
                    -- upvalues: p2 (copy), p3 (copy), v1 (copy)
                    if p5.Name == p2 and p5:IsA(p3) then
                        v1(p5)
                    end
                end)

                v2 = v3(v5):andThen(function(p6) -- line: 32
                    -- upvalues: v1 (copy)
                    v1(p6)
                end)

                return function() -- line: 35
                    -- upvalues: connection (copy)
                    connection:Disconnect()
                end
            end)
        }
    end
}
