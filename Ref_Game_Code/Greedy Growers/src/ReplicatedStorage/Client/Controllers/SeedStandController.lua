-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMSCUtuaXRTdGFydA1HZXRDb250cm9sbGVyClVJX01hbmFnZXIIS25pdEluaXQEZ2FtZQdQbGF5ZXJzCkdldFNlcnZpY2URUmVwbGljYXRlZFN0b3JhZ2UHcmVxdWlyZQhQYWNrYWdlcwRLbml0BE1haWQGU2hhcmVkBEluZm8KU2VlZENvbmZpZxBDcmVhdGVDb250cm9sbGVyBE5hbWUTU2VlZFN0YW5kQ29udHJvbGxlcgADAQEAAAAAAYIAAQAAAAwBARgADQAAAAADAQEAAAAI+wEAAE0BAdcAAAAAbwIBAJ8BAgIwAQDyAQAAAIIAAQACAwIDAwBvBAEYAAAAAAAAAAFwAAAAAAcAAAECADCjAAAApAABAAAAAEBvAgIAvAAAFgMAAACfAAMCpAEBAAAAAEBvAwQAvAEBFgMAAACfAQMCpAIGAAAAUEBNAwHmBwAAAE0DA3EIAAAAnwICAqQDBgAAAFBATQQB5gcAAABNBAR2CQAAAJ8DAgKkBAYAAABQQE0FARIKAAAATQUFegsAAABNBQVwDAAAAJ8EAgJNBQIPDQAAAOIGEACfBQICwAYRADAGBZkSAAAAwAYTABIAAgAwBgXGFAAAAIIFAgAVAwUEAAAAQAMGAwcDCAMJBAAAUEADCgMLAwwDDQMOAw8DEAMRAxIIAQ4PAAAABgADAQYBAwQCAAEBAAEYAAAAAAAAAAEAAAAAAAIAAAAAAAABAAAAAAAAAQAAAAAAAAAAAgAAAAQAAGMAAAAEAQAAAAACpuvaGm8bt98QBjnnM23tlNbzzW6UL7Ab

-- https://lua.expert/
game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

require(ReplicatedStorage.Packages.Maid)
require(ReplicatedStorage.Shared.Info.SeedConfig)

local v1 = Knit.CreateController({
	Name = "SeedStandController"
})

function v1.KnitStart(p1) --[[ KnitStart | Line: 12 ]] end
function v1.KnitInit(p1) --[[ KnitInit | Line: 111 | Upvalues: Knit (copy) ]]
	p1.UI_Manager = Knit.GetController("UI_Manager")
end

return v1