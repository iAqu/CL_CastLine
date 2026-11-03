-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServicesLoader = require(ReplicatedStorage.Modules.ServicesLoader)
local UILoader = require(ReplicatedStorage.Modules.UILoader)
local HandlerLoader = require(ReplicatedStorage.Modules.HandlerLoader)
local ControllerLoader = require(ReplicatedStorage.Modules.ControllerLoader)
local Component = require(ReplicatedStorage.Shared.Packages.Component)
ServicesLoader()
ControllerLoader()
HandlerLoader()
UILoader()
Component.Load(script.Components)