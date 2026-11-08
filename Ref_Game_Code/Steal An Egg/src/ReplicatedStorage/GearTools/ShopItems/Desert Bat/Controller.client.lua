-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Client = require(ReplicatedStorage.Shared.Modules.BatController.Client)
local Gears = require(ReplicatedStorage.Data.Gears)
local Parent = script.Parent
local GearName = Parent:GetAttribute("GearName")

assert(typeof(GearName) == "string", "Bat Tool requires a GearName attribute")

local v3 = assert(Gears.Directory[GearName].BatControllerData, (("%* requires BatControllerData"):format(GearName)))

Client.new(Parent, v3)
