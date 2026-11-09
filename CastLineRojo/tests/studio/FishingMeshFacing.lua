-- Studio Edit：与原 OBJ 的真实几何标志点比对，防止 FBX 轴转换造成头尾颠倒。
-- 标志点来自 /Users/gx/Downloads/fish/1.obj，已居中并按各轴包围盒尺寸归一化。
local storage = game:GetService("ReplicatedStorage")
local stage = workspace:FindFirstChild("_RigV2Stage")
local model = (stage and stage:FindFirstChild("Elder Fish")) or storage.Models.Fish["Elder Fish"]
local body = model.PrimaryPart
local expanded = model:GetAttribute("RigVersion") == 2
local mesh = game:GetService("AssetService"):CreateEditableMeshAsync(body.MeshContent)
assert(mesh, "Cannot read the uploaded fish mesh for asset validation")
local ok, result = xpcall(function()
	local landmarks = {
		Vector3.new(0, -0.1344837, -0.5), -- 真实鱼嘴，必须在 -Z。
		Vector3.new(0, 0.1663366, 0.5), -- 尾鳍末端，必须在 +Z。
		Vector3.new(-0.1122449, -0.0498727, -0.4459914),
		Vector3.new(0.101069, 0.0909194, 0.1574547),
		Vector3.new(-0.1793003, 0.0068175, -0.3649849),
		Vector3.new(0.1856171, -0.2808204, -0.0075797),
		Vector3.new(-0.0612245, 0.3185856, -0.1205069),
		Vector3.new(-0.4154519, -0.0847808, -0.1555142),
		Vector3.new(0.1676385, -0.0948232, -0.389938),
		Vector3.new(-0.1933916, -0.4399434, -0.2236273),
		Vector3.new(0.1569485, -0.0420368, -0.3923343),
		Vector3.new(0, 0.5, -0.0545817),
		Vector3.new(0.0408163, 0.032645, 0.348458),
		Vector3.new(-0.0422741, -0.1121358, 0.3189727),
	}
	if body:GetAttribute("EyeDiameterScale") == 2 then
		-- These two original landmarks belong to the intentionally enlarged right eye.
		-- Canonical replacements are recorded in assets/fish/ElderFish/eyes2x/validation.json.
		landmarks[9] = Vector3.new(0.19171833, -0.12942005, -0.37735078)
		landmarks[11] = Vector3.new(0.17035008, -0.02384738, -0.38214300)
	end
	local vertices = mesh:GetVertices()
	local boneOrder = if expanded
		then {
			"FishBody",
			"SpineFront",
			"SpineFrontFlex",
			"SpineMid",
			"SpineRear",
			"TailBase",
			"TailMid",
			"FishTail",
			"TailFinBase",
			"TailFinTip",
		}
		else { "FishBody", "SpineFront", "SpineMid", "TailBase", "FishTail" }
	assert(#mesh:GetBones() == #boneOrder, "Unexpected skinned bone count")
	local ids, order, parent = {}, {}, body
	for index, name in ipairs(boneOrder) do
		ids[index] = mesh:GetBoneByName(name)
		order[ids[index]] = index
		assert(mesh:GetBoneParent(ids[index]) == (ids[index - 1] or 0), "Mesh skeleton hierarchy changed")
		local bone = parent:FindFirstChild(name)
		assert(bone and bone:IsA("Bone"), "Studio bone hierarchy differs from skin")
		local bind = mesh:GetBoneCFrame(ids[index])
		local expected = CFrame.new(bind.Position * body.Size / body.MeshSize) * bind.Rotation
		assert(
			body.CFrame:ToObjectSpace(bone.WorldCFrame):FuzzyEq(expected, 0.001),
			"Instance bind pose differs from mesh: " .. name
		)
		parent = bone
	end
	for _, id in ipairs(vertices) do
		local weights, bones = mesh:GetVertexBoneWeights(id), mesh:GetVertexBones(id)
		local total, first, last, count = 0, #boneOrder + 1, 0, 0
		for index, weight in ipairs(weights) do
			assert(weight >= 0 and weight <= 1, "Invalid skin weight")
			total += weight
			if weight > 0.00001 then
				assert(order[bones[index]], "Vertex references a legacy bone")
				count += 1
				first, last = math.min(first, order[bones[index]]), math.max(last, order[bones[index]])
			end
		end
		assert(
			math.abs(total - 1) < 0.00001 and count <= (if expanded then 4 else 2) and (expanded or last - first <= 1),
			"Skin weights are not normalized/adjacent"
		)
	end
	local nearest, maximum = {}, 0
	for index, expected in ipairs(landmarks) do
		local distance = math.huge
		for _, id in ipairs(vertices) do
			local delta = (mesh:GetPosition(id) / body.MeshSize - expected).Magnitude
			if delta < distance then
				distance, nearest[index] = delta, id
			end
		end
		assert(distance < 0.0005, "Fish mesh facing changed: source landmark " .. index .. " error " .. distance)
		maximum = math.max(maximum, distance)
	end
	local tailIds = { [mesh:GetBoneByName("FishTail")] = true }
	if expanded then
		tailIds[mesh:GetBoneByName("TailFinBase")] = true
		tailIds[mesh:GetBoneByName("TailFinTip")] = true
	end
	local function tailWeight(vertex)
		local total = 0
		local weights = mesh:GetVertexBoneWeights(vertex)
		for index, bone in ipairs(mesh:GetVertexBones(vertex)) do
			if tailIds[bone] then
				total += weights[index]
			end
		end
		return total
	end
	assert(tailWeight(nearest[1]) < 0.00001, "Tail bone moves the actual mouth")
	local headWeights = mesh:GetVertexBoneWeights(nearest[1])
	for index, id in ipairs(mesh:GetVertexBones(nearest[1])) do
		assert(id == ids[1] or headWeights[index] < 0.00001, "An active spine bone moves the actual mouth")
	end
	assert(tailWeight(nearest[2]) > 0.99, "Tail bone does not move the actual tail")
	return {
		passed = true,
		landmarks = #landmarks,
		maximumNormalizedError = maximum,
		checks = "source geometry facing, published hierarchy, normalized weights, fixed real mouth, weighted real tail",
	}
end, debug.traceback)
mesh:Destroy()
assert(ok, result)
return result
