--# selene: allow(global_usage)
local http = game:GetService("HttpService")
local assets = game:GetService("AssetService")
local serialization = game:GetService("SerializationService")
local base = "http://127.0.0.1:18776/"
assert(game.PlaceId == 84106335829275 and game.CreatorId == 598797612, "Wrong development place")
local templates = game.ReplicatedStorage.Models.Fish
local processed = workspace.Fish_Processed
assert(#templates:GetChildren() == 112 and #processed:GetChildren() == 112, "Fish inventory changed")
assert(not (_G.RigV2Capture and not _G.RigV2Capture.done), "Capture already running")
local previous = _G.RigV2Capture
if previous and previous.fatal then
	previous = nil
end
local stamp = os.date("!%Y%m%d_%H%M%S")
local backups = game.ServerStorage.FishUpgradeBackups
local backup = if previous then backups:FindFirstChild(previous.backup:match("[^.]+$")) else Instance.new("Folder")
if not previous then
	backup.Name = "BeforeRigV2_" .. stamp
	backup.Parent = backups
end
local job = {
	done = false,
	captured = previous and previous.captured or 0,
	parts = previous and previous.parts or 0,
	errors = previous and table.clone(previous.errors) or {},
	backup = backup:GetFullName(),
}
_G.RigV2Capture = job
local function post(path, data)
	local raw = http:JSONEncode(data)
	if #raw <= 700000 then
		http:PostAsync(base .. path, raw, Enum.HttpContentType.ApplicationJson)
		return
	end
	local offset, chunks = 1, 0
	while offset <= #raw do
		local last = math.min(#raw, offset + 299999)
		while last < #raw and bit32.band(string.byte(raw, last + 1), 192) == 128 do
			last -= 1
		end
		chunks += 1
		local piece = http:JSONEncode({ chunk = string.sub(raw, offset, last) })
		http:PostAsync(base .. path .. (".chunk%03d.json"):format(chunks), piece, Enum.HttpContentType.ApplicationJson)
		offset = last + 1
		task.wait(0.1)
	end
	http:PostAsync(
		base .. path,
		http:JSONEncode({ chunkCount = chunks, bytes = #raw }),
		Enum.HttpContentType.ApplicationJson
	)
end
local function vector(v)
	return { v.X, v.Y, v.Z }
end
local function packAttrs(object)
	local result = {}
	for k, v in object:GetAttributes() do
		if typeof(v) == "Vector3" then
			result[k] = vector(v)
		elseif typeof(v) == "string" or typeof(v) == "number" or typeof(v) == "boolean" then
			result[k] = v
		end
	end
	return result
end
local function listParts(fish)
	local list = {}
	for _, item in fish:GetDescendants() do
		if item:IsA("MeshPart") and item.HasSkinnedMesh then
			table.insert(list, item)
		end
	end
	table.sort(list, function(a, b)
		if a == fish.PrimaryPart then
			return b ~= a
		end
		if b == fish.PrimaryPart then
			return false
		end
		return a:GetFullName() < b:GetFullName()
	end)
	return list
end
_G.RigV2ListParts = listParts
local function capturePart(part, primary, path)
	local mesh = assert(assets:CreateEditableMeshAsync(part.MeshContent), "Cannot read " .. part.MeshId)
	local ok, reason = xpcall(function()
		local vertices, uvs, normals, faces, weights, colors = {}, {}, {}, {}, {}, {}
		local vi, ui, ni, ci, bones = {}, {}, {}, {}, {}
		for _, id in mesh:GetBones() do
			bones[id] = mesh:GetBoneName(id)
		end
		for index, id in mesh:GetVertices() do
			vi[id] = index - 1
			vertices[index] = vector(mesh:GetPosition(id))
			local names = {}
			for _, bid in mesh:GetVertexBones(id) do
				table.insert(names, (assert(bones[bid], "Skin references an unknown bone")))
			end
			weights[index] = { names, mesh:GetVertexBoneWeights(id) }
			if index % 4096 == 0 then
				task.wait()
			end
		end
		for index, id in mesh:GetUVs() do
			ui[id] = index - 1
			local uv = mesh:GetUV(id)
			uvs[index] = { uv.X, 1 - uv.Y }
		end
		for index, id in mesh:GetNormals() do
			ni[id] = index - 1
			normals[index] = vector(mesh:GetNormal(id))
		end
		for index, id in mesh:GetColors() do
			ci[id] = index - 1
			local color = mesh:GetColor(id)
			colors[index] = { color.R, color.G, color.B, mesh:GetColorAlpha(id) }
		end
		for index, id in mesh:GetFaces() do
			local verts, uv, normal, color =
				mesh:GetFaceVertices(id), mesh:GetFaceUVs(id), mesh:GetFaceNormals(id), mesh:GetFaceColors(id)
			for i = 2, #verts - 1 do
				local a, b, c = 1, i, i + 1
				table.insert(faces, {
					vi[verts[a]],
					vi[verts[b]],
					vi[verts[c]],
					ui[uv[a]],
					ui[uv[b]],
					ui[uv[c]],
					ni[normal[a]],
					ni[normal[b]],
					ni[normal[c]],
					ci[color[a]],
					ci[color[b]],
					ci[color[c]],
				})
			end
			if index % 4096 == 0 then
				task.wait()
			end
		end
		post(path, {
			name = part.Name,
			mesh = part.MeshId,
			texture = part.TextureID,
			size = vector(part.Size),
			meshSize = vector(part.MeshSize),
			frame = { primary.CFrame:ToObjectSpace(part.CFrame):GetComponents() },
			color = { part.Color.R, part.Color.G, part.Color.B },
			material = part.Material.Name,
			transparency = part.Transparency,
			vertices = vertices,
			uvs = uvs,
			normals = normals,
			faces = faces,
			weights = weights,
			colors = colors,
		})
	end, debug.traceback)
	mesh:Destroy()
	assert(ok, reason)
end
task.spawn(function()
	local ok, reason = xpcall(function()
		local roots = {
			{ processed, "ProcessedBefore" },
			{ templates, "TemplatesBefore" },
			{ game.ServerStorage.FishAnimationSources, "AnimationSourcesBefore" },
			{ game.ReplicatedStorage.Animation.Fishing, "AnimationReferencesBefore" },
		}
		for _, entry in roots do
			if previous then
				break
			end
			local clone = assert(entry[1]:Clone())
			clone.Name, clone.Parent = entry[2], backup
			local data = serialization:SerializeInstancesAsync({ clone })
			local loaded = serialization:DeserializeInstancesAsync(data)
			assert(#loaded == 1 and #loaded[1]:GetDescendants() == #clone:GetDescendants(), "Backup readback differs")
			loaded[1]:Destroy()
			local response = http:RequestAsync({
				Url = base .. "studio/" .. entry[2] .. ".rbxm",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/octet-stream" },
				Body = buffer.tostring(data),
			})
			assert(response.Success, response.StatusMessage)
		end
		local names = {}
		for _, fish in templates:GetChildren() do
			assert(processed:FindFirstChild(fish.Name), "Missing paired model")
			table.insert(names, fish.Name)
		end
		table.sort(names)
		local pilots = {
			["Elder Fish"] = 1,
			Clownfish = 2,
			["Attacking Whale"] = 3,
			YaoYu_01_00 = 4,
			HaiGui_01_00 = 5,
			["Candy Jellyfish"] = 6,
		}
		local rows = {}
		for index, name in names do
			local fish = templates[name]
			local attrs = packAttrs(fish)
			local partList = listParts(fish)
			assert(partList[1] == fish.PrimaryPart, "Primary mesh missing " .. name)
			local otherParts = listParts(processed[name])
			assert(#otherParts == #partList, "Paired mesh count differs " .. name)
			local ids = {}
			for i, part in partList do
				assert(
					part.Name == otherParts[i].Name and part.MeshId == otherParts[i].MeshId,
					"Paired mesh differs " .. name
				)
				ids[i] = { name = part.Name, mesh = part.MeshId }
			end
			table.insert(rows, {
				name = name,
				key = string.format("Rig%03d", index),
				pilot = pilots[name],
				family = attrs.RaceFamily or attrs.NewFishFamily or attrs.RigVariant or "standard",
				bones = attrs.LogicalBoneCount,
				parts = ids,
				attributes = attrs,
			})
		end
		table.sort(rows, function(a, b)
			if (a.pilot or 7) ~= (b.pilot or 7) then
				return (a.pilot or 7) < (b.pilot or 7)
			end
			return a.key < b.key
		end)
		post("inventory.json", { rows = rows, stamp = stamp, backup = backup:GetFullName() })
		for _, row in rows do
			if previous and not previous.errors[row.name] then
				continue
			end
			job.current = row.name
			local readOk, readError = xpcall(function()
				local fish = templates[row.name]
				local primary = fish.PrimaryPart
				local originalBones, drip, clips = {}, {}, {}
				for _, d in primary:GetDescendants() do
					if d:IsA("Bone") then
						table.insert(originalBones, {
							name = d.Name,
							parent = if d.Parent:IsA("Bone") then d.Parent.Name else "",
							position = vector(primary.CFrame:PointToObjectSpace(d.WorldPosition)),
						})
					elseif d:IsA("Attachment") and d.Name:sub(1, 9) == "FishDrip_" then
						table.insert(
							drip,
							{ name = d.Name, position = vector(primary.CFrame:PointToObjectSpace(d.WorldPosition)) }
						)
					end
				end
				for _, a in fish.Animations:GetChildren() do
					if a:IsA("Animation") then
						clips[a.Name] = a.AnimationId
					end
				end
				for i, part in listParts(fish) do
					capturePart(part, primary, ("source/%s/part%03d.json"):format(row.key, i))
					job.parts += 1
				end
				local mouth = assert(primary:FindFirstChild("MouthAttachment"))
				post("source/" .. row.key .. "/rig.json", {
					row = row,
					originalBones = originalBones,
					drip = drip,
					animations = clips,
					mouth = vector(mouth.Position),
				})
			end, debug.traceback)
			if readOk then
				job.captured += 1
				job.errors[row.name] = nil
			else
				job.errors[row.name] = readError
			end
			post("capture-status.json", job)
		end
	end, debug.traceback)
	if not ok then
		job.fatal = reason
	end
	job.done = true
	post("capture-status.json", job)
end)
return { started = true, backup = backup:GetFullName() }
