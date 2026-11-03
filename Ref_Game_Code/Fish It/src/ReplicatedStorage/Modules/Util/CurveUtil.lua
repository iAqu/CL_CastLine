-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Debris = game:GetService("Debris")
game:GetService("Workspace")
game:GetService("ReplicatedStorage")
local v1 = CFrame.Angles(0, 0, 0)
local v2 = CFrame.Angles(0.2617993877991494, 0, 0)
local v3 = CFrame.Angles(-1.0471975511965976, 0, 0)
local function makePoint(p1, p2, p3) --[[ makePoint | Line: 23 | Upvalues: Debris (copy) ]]
	local CurveParts = workspace:FindFirstChild("CurveParts")
	if not CurveParts then
		local CurveParts_2 = Instance.new("Folder")
		CurveParts_2.Name = "CurveParts"
		CurveParts_2.Parent = workspace
		CurveParts = CurveParts_2
	end
	local Part = Instance.new("Part")
	Part.Size = Vector3.new(0.4, 0.4, 0.4)
	Part.Name = p2
	Part.Anchored = true
	Part.CFrame = p1
	Part.CanCollide = false
	Part.CanTouch = false
	Part.CanQuery = false
	Part.BrickColor = if p3 then p3 else BrickColor.Red()
	Part.Parent = CurveParts
	Debris:AddItem(Part, 3)
end
local function Map(p1, p2, p3, p4, p5) --[[ Map | Line: 44 ]]
	if p3 == p2 then
		warn("Range of zero")
	else
		return (p1 - p2) * (p5 - p4) / (p3 - p2) + p4
	end
end
return {
	Bezier = function(p1, p2, p3, p4) --[[ bezier | Line: 54 ]]
		return p2:Lerp(p3, p1):Lerp(p3:Lerp(p4, p1), p1)
	end,
	GetCurveBetween = function(p1) --[[ getCurveBetween | Line: 61 | Upvalues: v1 (copy), v2 (copy), Map (copy), v3 (copy), makePoint (copy) ]]
		local start = p1.start
		local finish = p1.finish
		local v12 = p1.numPoints or 50
		local visiualize = p1.visiualize
		local withRotation = p1.withRotation
		local v22 = p1.yRotation or CFrame.Angles(0, 0, 0)
		if not (start and finish) then
			return warn("Missing start/end of the curve")
		end
		local t = {}
		local v32 = (start + finish) / 2
		local v5 = p1.middle or Vector3.new(v32.X, p1.curveHeight, v32.Z)
		for i = 1, v12 do
			local v6
			local v7 = i / v12
			local v8 = start:Lerp(v5, v7):Lerp(v5:Lerp(finish, v7), v7)
			v6 = if v7 <= 0.5 then v1:Lerp(v2, Map(v7, 0, 0.5, 0, 1)) else v2:Lerp(v3, Map(v7, 0.5, 1, 0, 1))
			local v11 = CFrame.new(v8) * v22
			local v122 = withRotation and v11 * v6 or v11
			if visiualize then
				makePoint(v122, if i == 1 then "Start" elseif i == v12 then "End" else i, i == 1 and BrickColor.Blue() or (i == v12 and BrickColor.Green() or nil))
			end
			table.insert(t, v122)
		end
		return t
	end
}