-- Service refs
local Players = game:GetService("Players")

-- Variables
local localPlayer = Players.LocalPlayer

local startTick = tick()

repeat
	task.wait()
until localPlayer.Character

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit.AddControllers(game:GetService("ReplicatedStorage").Source.Controller.BeforeLoad)

repeat
	task.wait()
until localPlayer:GetAttribute("Loaded")

Knit.AddControllers(game:GetService("ReplicatedStorage").Source.Controller.AfterLoad)
Knit.Start():catch(warn):await()

print("[CLIENT] Loaded: ", tick() - startTick)
