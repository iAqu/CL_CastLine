-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local function easeArc(p1) --[[ easeArc | Line: 8 ]]
	return 1 - math.cos(p1 * math.pi / 2)
end
return {
	new = function(p1) --[[ new | Line: 12 ]]
		local RenderStepped = p1.RenderStepped
		local Easing = p1.Easing
		local Settings = p1.Settings
		local activeEggs = p1.activeEggs
		local Bezier = p1.Bezier
		local autoControlPoint = p1.autoControlPoint
		local Timings = Settings.Timings
		local Other = Settings.Other
		local function scaleModelIn(p1) --[[ scaleModelIn | Line: 22 | Upvalues: RenderStepped (copy), Easing (copy), Timings (copy) ]]
			RenderStepped(function(p12, p2) --[[ Line: 23 | Upvalues: p1 (copy), Easing (ref) ]]
				p1:ScaleTo(Easing.ExpoInOut(p2))
			end, Timings.UpscaleDuration, true)
			p1:ScaleTo(1)
		end
		local function moveModelToOffset(p1, p2, p3) --[[ moveModelToOffset | Line: 29 | Upvalues: autoControlPoint (copy), Bezier (copy), RenderStepped (copy), Timings (copy) ]]
			local v2 = p3 + Vector3.new(0, p1:GetExtentsSize().Y / 2, 0)
			local v3 = Bezier(p2, autoControlPoint(p2, v2), v2)
			RenderStepped(function(p12, p2) --[[ Line: 34 | Upvalues: p1 (copy), v3 (copy) ]]
				local v1 = 1 - math.cos(p2 * math.pi / 2)
				p1:PivotTo(CFrame.new(v3(v1)) * p1:GetPivot().Rotation)
			end, Timings.MoveDuration, true):Wait()
			p1:PivotTo(CFrame.new(v2) * p1:GetPivot().Rotation)
		end
		local function bounceModel(p1, p2) --[[ bounceModel | Line: 42 | Upvalues: RenderStepped (copy), Easing (copy), Other (copy), Timings (copy) ]]
			RenderStepped(function(p12, p22) --[[ Line: 43 | Upvalues: Easing (ref), p1 (copy), p2 (copy), Other (ref) ]]
				local v1 = 1 - Easing.BounceOut(p22)
				p1:PivotTo(p2 + Vector3.new(0, Other.BounceHeight, 0) * v1)
			end, Timings.BounceDuration, true):Wait()
			p1:PivotTo(p2)
		end
		local function hopSpinModel(p1, p2, p3, p4, p5, p6) --[[ hopSpinModel | Line: 51 | Upvalues: Timings (copy), Other (copy), RenderStepped (copy), Easing (copy) ]]
			local v1 = p3 or 1
			local v2 = if p5 then p5 else Timings.BounceDuration
			local v3 = p4 or Other.BounceHeight * 1.05
			local v4 = p6 or 0
			if v4 > 0 then
				task.wait(v4)
			end
			RenderStepped(function(p12, p22) --[[ Line: 66 | Upvalues: Easing (ref), v1 (copy), v3 (copy), p1 (copy), p2 (copy) ]]
				local v2 = math.rad(360 * v1 * Easing.ExpoInOut(p22))
				local v32 = math.sin(p22 * math.pi) * v3
				p1:PivotTo(p2 * CFrame.Angles(0, v2, 0) + Vector3.new(0, v32, 0))
			end, v2, true):Wait()
			p1:PivotTo(p2)
		end
		local function computeShakePause(p1) --[[ computeShakePause | Line: 76 | Upvalues: activeEggs (copy), Timings (copy) ]]
			local tbl = {}
			local sum = 0
			for k in pairs(activeEggs) do
				if p1 ~= k and not (k.completed or p1.priority <= k.priority) then
					tbl[k.priority] = true
				end
			end
			for k in pairs(tbl) do
				sum = sum + Timings.PauseDuration
			end
			return sum
		end
		return {
			scaleModelIn = scaleModelIn,
			moveModelToOffset = moveModelToOffset,
			bounceModel = bounceModel,
			hopSpinModel = hopSpinModel,
			computeShakePause = computeShakePause,
			shakeModel = function(p1, p2, p3, p4) --[[ shakeModel | Line: 94 | Upvalues: Timings (copy), Other (copy), RenderStepped (copy), computeShakePause (copy), Easing (copy) ]]
				local v1 = Timings.ShakePreDuration * 1.35
				local v2 = Timings.ShakePostDuration * 1.35
				local v3 = v1 + v2
				local v4 = 0
				local BounceHeight = Other.BounceHeight
				local ShakePitchMagnitude = Other.ShakePitchMagnitude
				local ShakePitchA = Other.ShakePitchA
				local ShakePitchB = Other.ShakePitchB
				local v5 = -1
				RenderStepped(function(p12, p22) --[[ Line: 107 | Upvalues: computeShakePause (ref), p2 (copy), v4 (ref), v3 (copy), v1 (copy), v2 (copy), Easing (ref), ShakePitchMagnitude (copy), ShakePitchA (copy), ShakePitchB (copy), BounceHeight (copy), p1 (copy), p3 (copy), p4 (copy), v5 (ref) ]]
					v4 = math.max(v4, (computeShakePause(p2)))
					if v3 + v4 <= p22 then
						return true
					end
					local v32 = p22 / v3
					local v42 = math.clamp(v32, 0, 1.5)
					local v6 = math.clamp(p22 / v1, 0, 1)
					local v10 = 1 - Easing.QuadOut((math.clamp((p22 - (v3 - v2)) / math.max(v2, 0.001), 0, 1)))
					local v11 = Easing.QuadOut(v6) * v10
					local v122 = v32 * 0.7
					local v13 = ShakePitchMagnitude * 1.4
					local v18 = math.rad(v13 * math.sin(6.283185307179586 * (v122 * (v42 * ShakePitchA) * ShakePitchB)) * v11)
					local v20 = math.rad(v13 * 0.7 * math.sin(6.283185307179586 * (v122 * (v42 * (ShakePitchA + 0.4)) * (ShakePitchB + 2))) * v11)
					local v222 = math.rad(v13 * 0.4 * math.cos(6.283185307179586 * (v122 * (v42 * (ShakePitchA + 0.9)) * (ShakePitchB + 4))) * v11)
					local v23 = BounceHeight * 0.28 * math.sin(6.283185307179586 * v122 * 4) * v11
					local v24 = BounceHeight * 0.16 * math.cos(6.283185307179586 * v122 * 5) * v11
					local v25 = BounceHeight * 0.12 * math.sin(6.283185307179586 * v122 * 3.5) * v11
					p1:PivotTo(p3 * CFrame.fromOrientation(v18, v20, v222) + Vector3.new(v24, v23, v25))
					if not (p4 and v11 > 0.12) then
						return false
					end
					local v26 = math.floor(p22 / 0.45)
					if not (v5 < v26) then
						return false
					end
					v5 = v26
					p4(p1:GetPivot().Position)
					return false
				end):Wait()
				p1:PivotTo(p3)
			end,
			animateLid = function(p1, p2) --[[ animateLid | Line: 157 | Upvalues: RenderStepped (copy), Timings (copy) ]]
				RenderStepped(function(p12) --[[ Line: 158 | Upvalues: Timings (ref), p2 (copy), p1 (copy) ]]
					local v2 = math.rad(p12 / Timings.OpenTime * p2)
					if p1:IsA("BasePart") then
						local v3 = p1.CFrame
						local v4 = v3 * CFrame.new(p1.PivotOffset.Position)
						local v5 = v4:Inverse() * v3
						p1.CFrame = v4 * CFrame.Angles(v2, 0, 0) * v5
					else
						p1:PivotTo(p1:GetPivot() * CFrame.Angles(v2, 0, 0))
					end
				end, Timings.OpenTime):Wait()
			end,
			applyLegendaryLight = function(p1, p2) --[[ applyLegendaryLight | Line: 176 | Upvalues: RenderStepped (copy) ]]
				RenderStepped(function(p12, p2) --[[ Line: 177 | Upvalues: p1 (copy) ]]
					p1.Color = Color3.fromHSV(p2 / 1.5 % 1, 1, 1)
				end, p2):Wait()
			end
		}
	end
}