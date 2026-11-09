--# selene: allow(global_usage)
local assets = game:GetService("AssetService")
local encoding = game:GetService("EncodingService")
local http = game:GetService("HttpService")
local base = "http://127.0.0.1:18776/"
local ids = {}
for _, part in game.ReplicatedStorage.Models.Fish:GetDescendants() do
	if part:IsA("MeshPart") then
		local id = tonumber(part.TextureID:match("%d+$"))
		if id then
			ids[id] = true
		end
	end
end
local job = { done = false, results = {}, errors = {} }
_G.RigV2Textures = job
local function post(path, data)
	http:PostAsync(base .. path, http:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
end
task.spawn(function()
	for id in ids do
		local ok, data = pcall(function()
			local editable =
				assert(assets:CreateEditableImageAsync(Content.fromAssetId(id)), "Editable image unavailable")
			local size = editable.Size
			local raw = editable:ReadPixelsBuffer(Vector2.zero, size)
			editable:Destroy()
			local total = buffer.len(raw)
			local n = 0
			for offset = 0, total - 1, 480000 do
				local piece = buffer.create(math.min(480000, total - offset))
				buffer.copy(piece, 0, raw, offset, buffer.len(piece))
				n += 1
				post(
					("texture-data/%d-%03d.json"):format(id, n),
					{ rgba = buffer.tostring(encoding:Base64Encode(piece)) }
				)
				task.wait()
			end
			local record = { width = size.X, height = size.Y, chunks = n }
			post(("texture-data/%d.json"):format(id), record)
			return record
		end)
		if ok then
			job.results[tostring(id)] = data
		else
			job.errors[tostring(id)] = data
		end
	end
	job.done = true
	post("texture-status.json", job)
end)
return "Started lossless source texture capture"
