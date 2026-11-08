-- Prepare only QA data; game code continues to come from Rojo.
local h = game:GetService("HttpService")
local raw = h:GetAsync("http://127.0.0.1:18775/geometry-qa.json")
local previous = game.ReplicatedStorage:FindFirstChild("_FishGeometryQA")
if previous then
	previous:Destroy()
end
local folder = Instance.new("Folder")
folder.Name = "_FishGeometryQA"
folder:SetAttribute("ByteLength", #raw)
for offset = 1, #raw, 100000 do
	local chunk = Instance.new("StringValue")
	chunk.Name = string.format("%05d", math.floor(offset / 100000))
	chunk.Value = string.sub(raw, offset, offset + 99999)
	chunk.Parent = folder
end
folder.Parent = game.ReplicatedStorage
return { bytes = #raw, chunks = #folder:GetChildren() }
