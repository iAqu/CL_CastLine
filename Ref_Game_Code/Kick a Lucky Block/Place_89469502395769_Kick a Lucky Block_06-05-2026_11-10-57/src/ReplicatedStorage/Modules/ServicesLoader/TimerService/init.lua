-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
game:GetService("ReplicatedStorage")
local TimerClass = require(script.TimerClass)
local t = {
	Running = false,
	Timers = {},
	Connection = nil
}
function OnPreRender() --[[ OnPreRender | Line: 14 | Upvalues: t (copy) ]]
	local v1 = workspace:GetServerTimeNow()
	for k, v in pairs(t.Timers) do
		if v.Destroyed then
			t.Timers[k] = nil
		end
		if (not v.Requirement or v.Requirement()) and v:OnTick(v1) <= 0 then
			v:Destroy()
			t.Timers[k] = nil
		end
	end
	if not next(t.Timers) then
		t.StopTimer()
	end
end
function t.StartTimer() --[[ StartTimer | Line: 42 | Upvalues: t (copy), RunService (copy) ]]
	if not t.Running then
		t.Running = true
		t.Connection = RunService.PreRender:Connect(OnPreRender)
	end
end
function t.StopTimer() --[[ StopTimer | Line: 51 | Upvalues: t (copy) ]]
	if t.Running then
		t.Running = false
		t.Connection:Disconnect()
	end
end
function t.AddTimer(p1, p2, p3, p4, p5) --[[ AddTimer | Line: 60 | Upvalues: TimerClass (copy), t (copy) ]]
	local v1 = TimerClass.new(p1, p2, p3, p4, p5)
	t.Timers[p1] = v1
	t.StartTimer()
	return v1
end
return t