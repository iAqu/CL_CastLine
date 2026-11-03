-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
require(ReplicatedStorage.Shared.Data.Attributes)
local SpeedData = require(ReplicatedStorage.Shared.Data.SpeedData)
local LocalPlayer = game:GetService("Players").LocalPlayer
local t = {
	Level = 0,
	DidInit = false,
	InSlowMode = false,
	Multiplier = 1,
	EndTime = nil,
	CurrentSpeed = SpeedData.BASE_SPEED,
	MaxSpeed = SpeedData.BASE_SPEED,
	LevelChanged = Signal.new(),
	SpeedChanged = Signal.new(),
	MaxChanged = Signal.new(),
	SlowChanged = Signal.new(),
	MultiplierChanged = Signal.new()
}
function OnSpeedUpdate(p1) --[[ OnSpeedUpdate | Line: 34 | Upvalues: t (copy), SpeedData (copy) ]]
	if p1 ~= t.Level then
		t.Level = p1
		t.LevelChanged:Fire(p1)
		local v1 = SpeedData:GetSpeedFromLevel(p1)
		t.MaxSpeed = v1
		if not t.InSlowMode then
			t.CurrentSpeed = v1
			t.SpeedChanged:Fire(v1)
		end
		t.MaxChanged:Fire(v1)
		if not t.DidInit then
			t.DidInit = true
		end
	end
end
function OnMultiplierUpdate(p1, p2) --[[ OnMultiplierUpdate | Line: 55 | Upvalues: t (copy) ]]
	t.Multiplier = p1 or 1
	t.EndTime = p2
	t.SpeedChanged:Fire()
	t.MultiplierChanged:Fire()
end
function t.RequestUpgrade(p1, p2) --[[ RequestUpgrade | Line: 70 | Upvalues: Network (copy) ]]
	Network.FireServer("SPEED_UPGRADE", p2)
end
function t.SlowMode(p1, p2) --[[ SlowMode | Line: 74 | Upvalues: SpeedData (copy) ]]
	p1.InSlowMode = p2
	p1.CurrentSpeed = p2 and SpeedData.LOBBY_SPEED or p1.MaxSpeed
	p1.SpeedChanged:Fire(p1.CurrentSpeed)
	p1.SlowChanged:Fire(p2)
end
function t._init() --[[ _init | Line: 83 | Upvalues: Network (copy) ]]
	Network.OnClientEvent("SPEED_UPDATE"):Connect(OnSpeedUpdate)
	Network.OnClientEvent("SPEED_MULTIPLIER"):Connect(OnMultiplierUpdate)
end
return t