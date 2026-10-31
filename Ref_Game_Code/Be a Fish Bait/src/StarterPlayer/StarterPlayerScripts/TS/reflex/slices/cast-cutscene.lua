-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper

return {
    castCutsceneSlice = createProducer({
        animationEnded = false,
        miniRigEndCFrame = nil
    }, {
        castCutsceneAnimationEnded = produceWrapper(function(p1, _) -- line: 10
            p1.animationEnded = true
        end),
        castCutsceneMiniRigEndSet = produceWrapper(function(p3, p4) -- line: 13
            p3.miniRigEndCFrame = p4.cframe
        end),
        castCutsceneIsPerfectSet = produceWrapper(function(p5, _) -- line: 16
            p5.animationEnded = false
        end)
    })
}
