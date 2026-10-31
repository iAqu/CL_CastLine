--!nocheck

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CmdrClient = ReplicatedStorage:WaitForChild("CmdrClient")

local Cmdr = require(CmdrClient)

Cmdr:SetActivationKeys({ Enum.KeyCode.F2 })
