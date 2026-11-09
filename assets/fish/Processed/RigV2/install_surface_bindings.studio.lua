-- Adds exact surface weights to staged models; particle timing and appearance remain unchanged.
local http, assets = game:GetService("HttpService"), game:GetService("AssetService")
local stage = assert(workspace:FindFirstChild("_RigV2Stage"), "No staged fish")
local base = "http://127.0.0.1:18776/"
local filter = ...
local result = { fish = 0, points = 0, errors = {} }
for _, fish in stage:GetChildren() do
	if filter and not filter[fish.Name] then
		continue
	end
	if fish:GetAttribute("RigV2SurfacePrepared") == true then
		result.fish += 1
		result.points += 24
		continue
	end
	local ok, reason = xpcall(function()
		local key = fish:GetAttribute("RigV2Key")
		local data = http:JSONDecode(http:GetAsync(base .. "drip-bindings/" .. key .. ".json"))
		local body = fish.PrimaryPart
		fish:SetAttribute("RigV2SurfaceScale", fish:GetScale())
		local count = 0
		local lookup = {}
		for name, binding in data do
			local part = fish:FindFirstChild(binding.sourcePart, true)
			assert(part and part:IsA("MeshPart"), "Drip mesh missing")
			lookup[part] = lookup[part] or {}
			table.insert(lookup[part], { name = name, binding = binding })
		end
		for part, points in lookup do
			local mesh = assert(assets:CreateEditableMeshAsync(part.MeshContent), "Drip mesh unreadable")
			local meshOK, meshError = xpcall(function()
				local vertices = mesh:GetVertices()
				for _, entry in points do
					local point = assert(body:FindFirstChild(entry.name, true), "Drip point missing")
					local expected = {}
					for _, w in entry.binding.influences do
						expected[w.name] = w.weight
					end
					local position = Vector3.new(table.unpack(entry.binding.position))
					local tolerance = math.max(0.0002, part.MeshSize.Magnitude * 0.00002)
					local function matching(id)
						if not id or (mesh:GetPosition(id) - position).Magnitude > tolerance then
							return nil
						end
						local ids, values = mesh:GetVertexBones(id), mesh:GetVertexBoneWeights(id)
						local encoded, actual, total = {}, {}, 0
						for i, boneId in ids do
							local weight = values[i]
							if weight > 0 then
								local name = mesh:GetBoneName(boneId)
								actual[name] = (actual[name] or 0) + weight
								total += weight
							end
						end
						for name, w in expected do
							if math.abs((actual[name] or 0) - w) > 0.009 then
								return nil
							end
						end
						for name, w in actual do
							if math.abs((expected[name] or 0) - w) > 0.009 then
								return nil
							end
							table.insert(encoded, name .. ":" .. w)
						end
						if math.abs(total - 1) > 0.001 then
							return nil
						end
						table.sort(encoded)
						return encoded
					end
					local encoded = matching(vertices[entry.binding.sourceVertex + 1])
					if not encoded then
						-- Publication can reorder stable vertex IDs when the skin changes.
						for _, candidate in vertices do
							encoded = matching(candidate)
							if encoded then
								break
							end
						end
					end
					assert(encoded, "No matching published vertex for " .. entry.name)
					point:SetAttribute("RigV2SurfaceBind", body.CFrame:ToObjectSpace(point.WorldCFrame))
					point:SetAttribute("RigV2SurfaceWeights", table.concat(encoded, ";"))
					count += 1
				end
			end, debug.traceback)
			mesh:Destroy()
			assert(meshOK, meshError)
			task.wait()
		end
		assert(count == 24, "Surface point count differs")
		fish:SetAttribute("RigV2SurfacePrepared", true)
		result.points += count
	end, debug.traceback)
	if ok then
		result.fish += 1
	else
		result.errors[fish.Name] = reason
	end
end
http:PostAsync(
	base .. (if filter then "surface-installation-preview.json" else "surface-installation.json"),
	http:JSONEncode(result),
	Enum.HttpContentType.ApplicationJson
)
return result
