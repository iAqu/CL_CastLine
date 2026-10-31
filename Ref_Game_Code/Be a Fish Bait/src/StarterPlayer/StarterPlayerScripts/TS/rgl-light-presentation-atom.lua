-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").atom(nil)

return {
    presentRglLight = function(p1) -- presentRglLight | line: 5
        -- upvalues: v1 (copy)
        local v2 = v1()

        if v2 ~= nil then
            v2 = v2.sequence
        end

        if v2 == nil then
            v2 = 0
        end

        v1({
            light = p1,
            sequence = v2 + 1
        })
    end,
    clearRglLightPresentation = function() -- clearRglLightPresentation | line: 20
        -- upvalues: v1 (copy)
        v1(nil)
    end,
    rglLightPresentationAtom = v1
}
