-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GetPoint = require(ReplicatedStorage.Shared.Functional.GetPoint)
local CashPart = ReplicatedStorage.Objects.VFX.CashPart
local ObjectPool = require(ReplicatedStorage.Shared.Packages.ObjectPool)
local v1 = Random.new()
local v2 = ObjectPool.new(ReplicatedStorage.Objects.VFX.CashPart)
function PlaySound() --[[ PlaySound | Line: 25 | Upvalues: SoundService (copy), v1 (copy) ]]
	local v12 = SoundService.Effects.CashCollect:Clone()
	v12:WaitForChild("PitchShiftSoundEffect").Octave = v1:NextNumber(0.9, 1.1)
	v12.Parent = workspace
	v12:Resume()
	v12.Ended:Once(function() --[[ Line: 31 | Upvalues: v12 (copy) ]]
		v12:Destroy()
	end)
end
function HidePart(p1) --[[ HidePart | Line: 36 ]]
	p1.BillboardGui.Enabled = false
	p1.Trail.Enabled = false
end
return function(p1, p2) --[[ Line: 43 | Upvalues: v1 (copy), v2 (copy), RunService (copy), TweenService (copy), SoundService (copy), GetPoint (copy) ]]
	if p1 and p1.PrimaryPart and p2 then
		local v12 = v1:NextInteger(5, 10)
		local Position = p2.Position
		local t = {}
		local t2 = {}
		for i = 1, v12 do
			local v22 = v1:NextNumber(0, 6.283185307179586)
			local v7 = Vector3.new(Position.X + math.sin(v22) * 7, Position.Y, Position.Z + math.cos(v22) * 7)
			local v8 = workspace:Raycast(v7, Vector3.new(0, -10, 0))
			if v8 then
				v7 = v8.Position
			end
			local v9 = v7 - Position
			t[i] = { Position, Position + v9.Unit * v9.Magnitude / 2 + Vector3.new(0, v9.Magnitude, 0), v7 }
			local v11 = v2:Get()
			local v122 = v11:FindFirstChild("Trail") or v11:WaitForChild("Trail");
			(v11:FindFirstChildOfClass("BillboardGui") or v11:WaitForChild("BillboardGui")).Enabled = true
			v122.Enabled = true
			v11.Position = Position
			local v14 = t[i]
			v14[3] = v14[3] + Vector3.new(0, v11.Size.Y / 2, 0)
			t2[i] = v11
			v11.Parent = workspace.Debris
		end
		local function CleanUp() --[[ CleanUp | Line: 93 | Upvalues: t2 (copy), v2 (ref) ]]
			for i, v in ipairs(t2) do
				v2:Free(v, HidePart)
			end
		end
		local function ToPlayer() --[[ ToPlayer | Line: 99 | Upvalues: RunService (ref), p1 (copy), t2 (copy), v2 (ref), TweenService (ref), v12 (copy), t (copy) ]]
			local v1 = nil
			local v22 = 0
			v1 = RunService.PreRender:Connect(function(p12) --[[ Line: 103 | Upvalues: p1 (ref), v1 (ref), t2 (ref), v2 (ref), v22 (ref), TweenService (ref), v12 (ref), t (ref) ]]
				if p1 then
					v22 = v22 + p12
					local v23 = math.clamp(v22 / 0.3333333333333333, 0, 1)
					if v23 == 1 then
						v1:Disconnect()
						for i, v in ipairs(t2) do
							v2:Free(v, HidePart)
						end
						PlaySound()
					else
						local v3 = TweenService:GetValue(v23, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
						for i = 1, v12 do
							local v4 = t2[i]
							local v5 = t[i]
							if v5 and v4 then
								v4.Position = v5[3]:Lerp(p1.PrimaryPart.Position, v3)
							end
						end
					end
				else
					v1:Disconnect()
					for i, v in ipairs(t2) do
						v2:Free(v, HidePart)
					end
				end
			end)
		end
		local function StartBezier() --[[ StartBezier | Line: 137 | Upvalues: SoundService (ref), RunService (ref), p1 (copy), t2 (copy), v2 (ref), TweenService (ref), v12 (copy), t (copy), GetPoint (ref) ]]
			local v1 = nil
			local v22 = 0
			SoundService.Effects.Whoosh:Play()
			v1 = RunService.PreRender:Connect(function(p12) --[[ Line: 143 | Upvalues: v22 (ref), v1 (ref), RunService (ref), p1 (ref), t2 (ref), v2 (ref), TweenService (ref), v12 (ref), t (ref), GetPoint (ref) ]]
				v22 = v22 + p12
				local v23 = math.clamp(v22 / 0.5, 0, 1)
				if v23 == 1 then
					v1:Disconnect()
					local v3 = nil
					local v4 = 0
					v3 = RunService.PreRender:Connect(function(p12) --[[ Line: 103 | Upvalues: p1 (ref), v3 (ref), t2 (ref), v2 (ref), v4 (ref), TweenService (ref), v12 (ref), t (ref) ]]
						if p1 then
							v4 = v4 + p12
							local v22 = math.clamp(v4 / 0.3333333333333333, 0, 1)
							if v22 == 1 then
								v3:Disconnect()
								for i, v in ipairs(t2) do
									v2:Free(v, HidePart)
								end
								PlaySound()
							else
								local v32 = TweenService:GetValue(v22, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
								for i = 1, v12 do
									local v42 = t2[i]
									local v5 = t[i]
									if v5 and v42 then
										v42.Position = v5[3]:Lerp(p1.PrimaryPart.Position, v32)
									end
								end
							end
						else
							v3:Disconnect()
							for i, v in ipairs(t2) do
								v2:Free(v, HidePart)
							end
						end
					end)
				else
					local v5 = TweenService:GetValue(v23, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
					for i = 1, v12 do
						local v6 = t2[i]
						local v7 = t[i]
						if v7 and v6 then
							v6.Position = GetPoint(v5, v7)
						end
					end
				end
			end)
		end
		local function Start() --[[ Start | Line: 169 | Upvalues: SoundService (ref), RunService (ref), p1 (copy), t2 (copy), v2 (ref), TweenService (ref), v12 (copy), t (copy), GetPoint (ref) ]]
			local v1 = nil
			local v22 = 0
			SoundService.Effects.Whoosh:Play()
			v1 = RunService.PreRender:Connect(function(p12) --[[ Line: 143 | Upvalues: v22 (ref), v1 (ref), RunService (ref), p1 (ref), t2 (ref), v2 (ref), TweenService (ref), v12 (ref), t (ref), GetPoint (ref) ]]
				v22 = v22 + p12
				local v23 = math.clamp(v22 / 0.5, 0, 1)
				if v23 == 1 then
					v1:Disconnect()
					local v3 = nil
					local v4 = 0
					v3 = RunService.PreRender:Connect(function(p12) --[[ Line: 103 | Upvalues: p1 (ref), v3 (ref), t2 (ref), v2 (ref), v4 (ref), TweenService (ref), v12 (ref), t (ref) ]]
						if p1 then
							v4 = v4 + p12
							local v22 = math.clamp(v4 / 0.3333333333333333, 0, 1)
							if v22 == 1 then
								v3:Disconnect()
								for i, v in ipairs(t2) do
									v2:Free(v, HidePart)
								end
								PlaySound()
							else
								local v32 = TweenService:GetValue(v22, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
								for i = 1, v12 do
									local v42 = t2[i]
									local v5 = t[i]
									if v5 and v42 then
										v42.Position = v5[3]:Lerp(p1.PrimaryPart.Position, v32)
									end
								end
							end
						else
							v3:Disconnect()
							for i, v in ipairs(t2) do
								v2:Free(v, HidePart)
							end
						end
					end)
				else
					local v5 = TweenService:GetValue(v23, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
					for i = 1, v12 do
						local v6 = t2[i]
						local v7 = t[i]
						if v7 and v6 then
							v6.Position = GetPoint(v5, v7)
						end
					end
				end
			end)
		end
		local v17 = nil
		local v18 = 0
		SoundService.Effects.Whoosh:Play()
		v17 = RunService.PreRender:Connect(function(p12) --[[ Line: 143 | Upvalues: v18 (ref), v17 (ref), RunService (ref), p1 (copy), t2 (copy), v2 (ref), TweenService (ref), v12 (copy), t (copy), GetPoint (ref) ]]
			v18 = v18 + p12
			local v22 = math.clamp(v18 / 0.5, 0, 1)
			if v22 == 1 then
				v17:Disconnect()
				local v3 = nil
				local v4 = 0
				v3 = RunService.PreRender:Connect(function(p12) --[[ Line: 103 | Upvalues: p1 (ref), v3 (ref), t2 (ref), v2 (ref), v4 (ref), TweenService (ref), v12 (ref), t (ref) ]]
					if p1 then
						v4 = v4 + p12
						local v22 = math.clamp(v4 / 0.3333333333333333, 0, 1)
						if v22 == 1 then
							v3:Disconnect()
							for i, v in ipairs(t2) do
								v2:Free(v, HidePart)
							end
							PlaySound()
						else
							local v32 = TweenService:GetValue(v22, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
							for i = 1, v12 do
								local v42 = t2[i]
								local v5 = t[i]
								if v5 and v42 then
									v42.Position = v5[3]:Lerp(p1.PrimaryPart.Position, v32)
								end
							end
						end
					else
						v3:Disconnect()
						for i, v in ipairs(t2) do
							v2:Free(v, HidePart)
						end
					end
				end)
			else
				local v5 = TweenService:GetValue(v22, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
				for i = 1, v12 do
					local v6 = t2[i]
					local v7 = t[i]
					if v7 and v6 then
						v6.Position = GetPoint(v5, v7)
					end
				end
			end
		end)
	end
end