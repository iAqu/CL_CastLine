local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishingMutationTrail = require(script.Parent.FishingMutationTrail)

local FishingCatchTrail = {}

local function create(state, now)
	state.fishTrailAttempted = true
	state.mutationTrail = FishingMutationTrail.new(state, now)
	if state.mutationTrail then return end
	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	local folder = vfx and vfx:FindFirstChild("Fish")
	local template = folder and folder:FindFirstChild("FishTrail")
	local source0 = template and template:FindFirstChild("Att0")
	local source1 = template and template:FindFirstChild("Att1")
	local sourceTrail = source0 and source0:FindFirstChild("Trail")
	if
		not (
			source0
			and source0:IsA("Attachment")
			and source0.Archivable
			and source1
			and source1:IsA("Attachment")
			and source1.Archivable
			and sourceTrail
			and sourceTrail:IsA("Trail")
			and sourceTrail.Archivable
		)
	then
		warn("FishingCatchTrail: VFX.Fish.FishTrail is missing or invalid; skipping fish trail")
		return
	end
	-- originals 只包含鱼体可见部件；在主部件局部坐标测量，兼容宽鳍与多网格鱼。
	local body = state.fish.PrimaryPart
	local minX, maxX = math.huge, -math.huge
	for part in pairs(state.originals) do
		local relative = body.CFrame:ToObjectSpace(part.CFrame)
		for _, x in ipairs({ -1, 1 }) do
			for _, y in ipairs({ -1, 1 }) do
				for _, z in ipairs({ -1, 1 }) do
					local point = relative:PointToWorldSpace(part.Size * Vector3.new(x, y, z) * 0.5)
					minX, maxX = math.min(minX, point.X), math.max(maxX, point.X)
				end
			end
		end
	end
	if minX >= maxX then
		warn("FishingCatchTrail: fish has no visible width; skipping fish trail")
		return
	end
	local att0, att1 = source0:Clone(), source1:Clone()
	local trail = att0.Trail
	trail.Enabled = false
	trail.Attachment0, trail.Attachment1 = att0, att1
	-- 缓存未发生出水形变时的边界；每帧显式更新，避免与 ScaleTo 重复缩放。
	state.fishTrail = {
		att0 = att0,
		att1 = att1,
		trail = trail,
		minX = minX / state.scale,
		maxX = maxX / state.scale,
	}
	att0.Position, att1.Position = Vector3.new(maxX, 0, 0), Vector3.new(minX, 0, 0)
	att0.Parent, att1.Parent = body, body
	trail:Clear()
end

function FishingCatchTrail.Update(state, now, rising, surfaced)
	if rising and surfaced and not state.fishTrailAttempted then
		create(state, now)
	end
	local effect = state.fishTrail
	if effect then
		effect.att0.Position = Vector3.new(effect.maxX * state.scale, 0, 0)
		effect.att1.Position = Vector3.new(effect.minX * state.scale, 0, 0)
		-- 展示阶段只关闭生成，让最后一段拖尾按模板寿命自然消散。
		effect.trail.Enabled = rising
	end
	if state.mutationTrail and not state.mutationTrail:Update(now, rising) then
		state.mutationTrail = nil
	end
end

function FishingCatchTrail.Destroy(state)
	if state.mutationTrail then
		state.mutationTrail:Destroy()
		state.mutationTrail = nil
	end
	local effect = state.fishTrail
	if effect then
		effect.trail.Enabled = false
		effect.trail:Clear()
		effect.att0:Destroy()
		effect.att1:Destroy()
		state.fishTrail = nil
	end
end

return FishingCatchTrail
