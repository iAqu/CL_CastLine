-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FormatTime = require(ReplicatedStorage.Functional.FormatTime)
local t = {
	Spawned = false
}
local HackedMachine = script.HackedMachine
function AnimateNeons(p1) --[[ AnimateNeons | Line: 22 ]]
	local t = {}
	for i, v in ipairs(p1) do
		local t2 = {
			Part = v,
			StartCFrame = v:GetAttribute("START_CFRAME"),
			MaximumSize = v:GetAttribute("MAX_SIZE")
		}
		t2.Speed = v:GetAttribute("SPEED") or 0.5 + math.random() * 1.5
		t2.BaseSize = v.Size
		t2.t = math.random() * math.pi * 2
		table.insert(t, t2)
	end
	task.spawn(function() --[[ Line: 37 | Upvalues: t (copy) ]]
		while true do
			local v1 = task.wait(0.05)
			for i, v in ipairs(t) do
				v.t = v.t + v1 * v.Speed * 0.1
				local v3 = 0.2 + (v.MaximumSize - 0.2) * ((math.sin(v.t) + 1) / 2)
				v.Part.Size = Vector3.new(v3, v.BaseSize.Y, v.BaseSize.Z)
				v.Part.CFrame = v.StartCFrame * CFrame.new((v3 - v.MaximumSize) / 2, 0, 0)
			end
		end
	end)
end
function HandleMonitor(p1) --[[ HandleMonitor | Line: 51 | Upvalues: RunService (copy), FormatTime (copy) ]]
	local LoadingPart = p1.LoadingPart
	local TimerPart = p1.TimerPart
	local v1 = 0
	RunService.PreRender:Connect(function(p1) --[[ Line: 58 | Upvalues: v1 (ref), LoadingPart (copy), TimerPart (copy), FormatTime (ref) ]]
		local v12 = tick()
		if not (v12 - v1 < 1) then
			v1 = v12
			local v2 = workspace:GetServerTimeNow() % 3600
			local v3 = v2 / 3600
			LoadingPart.SurfaceGui.Label.Text = ("%%%*"):format((string.format("%.1f", v3 * 100)))
			LoadingPart.SurfaceGui.Progress.Bar.Size = UDim2.fromScale(v3, 1)
			TimerPart.SurfaceGui.TextLabel.Text = ("Next Virus Injection In: %*"):format((FormatTime(3600 - v2)))
		end
	end)
end
function SpawnMachine() --[[ SpawnMachine | Line: 76 | Upvalues: t (copy), HackedMachine (copy) ]]
	if not t.Spawned then
		t.Spawned = true
		HackedMachine.Parent = workspace.Debris
		HandleMonitor(HackedMachine.Monitor.Monitor)
		AnimateNeons(HackedMachine.Neons:GetChildren())
	end
end
function Initialize() --[[ Initialize | Line: 91 ]]
	if workspace:GetServerTimeNow() >= 1777813800 then
		SpawnMachine()
	end
end
function t.Spawn(p1) --[[ Spawn | Line: 100 ]]
	SpawnMachine()
end
function t._init(p1) --[[ _init | Line: 106 ]]
	Initialize()
end
return t