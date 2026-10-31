-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useLatest, useMotion = out.useLatest, out.useMotion
local useEffect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useEffect
local useTransition = RuntimeLib.import(script, script.Parent, "transition").useTransition

return {
    useTransitionMotionRaw = function(p1, p2, p3) -- useTransitionMotionRaw | line: 8
        -- upvalues: useLatest (copy), useMotion (copy), useEffect (copy), useTransition (copy)
        local v1 = if p2 == nil then {} else p2
        local v2 = if p3 == nil then {} else p3
        local v3 = useTransition()
        local v4, setStatus = v3["in"], v3.setStatus
        local v5, v6 = useMotion(p1)
        local v7 = useLatest(v1.onEnter)
        local v8 = useLatest(v1.onExit)
        local v9 = useLatest(v2.onEntered)
        local v10 = useLatest(v2.onExited)

        useEffect(function() -- line: 23
            -- upvalues: v4 (copy), setStatus (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy)
            if v4 then
                setStatus("entering")

                local v11 = v6:onComplete(function() -- line: 26
                    -- upvalues: setStatus (copy), v9 (copy)
                    setStatus("entered")

                    local current = v9.current

                    if current ~= nil then
                        current()
                    end
                end)
                local current = v7.current

                if current ~= nil then
                    current = current(v6)
                end

                return function() -- line: 38
                    -- upvalues: v11 (copy), current (ref)
                    v11()

                    if current ~= nil then
                        current()
                    end
                end
            end

            setStatus("exiting")

            local v12 = v6:onComplete(function() -- line: 47
                -- upvalues: setStatus (copy), v10 (copy)
                setStatus("exited")

                local current = v10.current

                if current ~= nil then
                    current()
                end
            end)
            local current = v8.current

            if current ~= nil then
                current = current(v6)
            end

            return function() -- line: 59
                -- upvalues: v12 (copy), current (ref)
                v12()

                if current ~= nil then
                    current()
                end
            end
        end, { v4, v6, v7, v9, v8, v10, setStatus })

        return { v5, v6 }
    end
}
