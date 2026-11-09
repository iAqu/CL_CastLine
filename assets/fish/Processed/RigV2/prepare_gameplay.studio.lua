-- Run on the Play Server; the fixture exists only for this test session.
local storage = game.ReplicatedStorage
local http = game.HttpService
local encoding = game:GetService("EncodingService")
local folder = Instance.new("Folder")
folder.Name = "_FishGeometryQA"
local bytes, chunks = 0, 0
local stage = assert(workspace:FindFirstChild("_RigV2Stage"), "No staged fish")
for _, fish in stage:GetChildren() do
	local key = fish:GetAttribute("RigV2Key")
	local raw = http:GetAsync("http://127.0.0.1:18776/gameplay/" .. key .. ".json")
	local packed = encoding:CompressBuffer(buffer.fromstring(raw), Enum.CompressionAlgorithm.Zstd, 3)
	local encoded = buffer.tostring(encoding:Base64Encode(packed))
	local row = Instance.new("Folder")
	row.Name = fish.Name
	row:SetAttribute("ByteLength", #encoded)
	for offset = 1, #encoded, 100000 do
		local part = Instance.new("StringValue")
		part.Name = ("%06d"):format(math.floor(offset / 100000))
		part.Value = encoded:sub(offset, offset + 99999)
		part.Parent = row
		chunks += 1
	end
	bytes += #encoded
	row.Parent = folder
	task.wait()
end
folder:SetAttribute("CompressedPerFish", true)
folder:SetAttribute("FishCount", #stage:GetChildren())
folder.Parent = storage
return { bytes = bytes, chunks = chunks }
