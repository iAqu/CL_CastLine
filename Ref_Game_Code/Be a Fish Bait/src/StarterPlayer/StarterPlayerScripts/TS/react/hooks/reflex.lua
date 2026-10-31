-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-reflex")

return {
    useRootProducer = v1.useProducer,
    useRootSelector = v1.useSelector,
    useRootSelectorCreator = v1.useSelectorCreator
}
