-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local createContext, useContext, useEffect, useRef = react.createContext, react.useContext, react.useEffect, react.useRef
local useState = react.useState
local v1 = createContext(nil)

return {
    useTransition = function() -- useTransition | line: 12
        -- upvalues: useContext (copy), v1 (copy)
        local v2 = useContext(v1)

        if not v2 then
            error("[src/client/react/common/transition/transition.tsx:26]useTransition must be used within a Transition component")
        end

        v2.isUsedByConsumer.current = true

        return v2
    end,
    default = function(p1) -- Transition | line: 20
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), v1 (copy)
        local _ = {
            keepMounted = false
        }
        local v3 = useRef(false)
        local v5, v6 = useState(not p1.doEnterTransitionOnFirstMount and p1["in"])
        local v7 = useState(v5)
        local keepMounted = p1.keepMounted

        if keepMounted == nil then
            keepMounted = false
        end

        local v9, v10 = useState(if v5 then "entered" else "exited")
        local v11 = useRef(true)

        useEffect(function() -- line: 34
            -- upvalues: v3 (copy), v5 (copy), v10 (copy), v11 (copy)
            if v11.current then
                return nil
            end

            if v3.current then
                v10(v5 and "entering" or "exiting")
            else
                v10(v5 and "entered" or "exited")
            end
        end, { v5, keepMounted })
        useEffect(function() -- line: 44
            -- upvalues: v11 (copy)
            v11.current = false
        end, {})
        useEffect(function() -- line: 47
            -- upvalues: p1 (copy), v6 (copy)
            v6(p1["in"])
        end, { p1["in"] })

        local v12 = not not (keepMounted or v9 ~= "exited")

        return react.createElement(v1.Provider, {
            value = {
                ["in"] = v5,
                initialIsIn = v7,
                isUsedByConsumer = v3,
                status = v9,
                setStatus = v10
            }
        }, if v12 then p1.children else nil)
    end
}
