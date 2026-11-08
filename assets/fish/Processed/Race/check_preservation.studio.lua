local h = game:GetService("HttpService")
local function fingerprint(folder)
	local records = {}
	for _, item in folder:GetDescendants() do
		local row = { item:GetFullName():sub(#folder:GetFullName() + 2), item.ClassName }
		if item:IsA("Model") then
			table.insert(row, item:GetScale())
			table.insert(row, item.PrimaryPart and item.PrimaryPart.Name or "")
		elseif item:IsA("BasePart") then
			for _, value in
				{
					item.Size.X,
					item.Size.Y,
					item.Size.Z,
					item.Color.R,
					item.Color.G,
					item.Color.B,
					item.Transparency,
					item.Reflectance,
				}
			do
				table.insert(row, value)
			end
			for _, value in { item.CFrame:GetComponents() } do
				table.insert(row, value)
			end
			table.insert(row, item.Material.Name)
			if item:IsA("MeshPart") then
				table.insert(row, item.MeshId)
				table.insert(row, item.TextureID)
			end
		elseif item:IsA("Attachment") then
			for _, value in { item.CFrame:GetComponents() } do
				table.insert(row, value)
			end
		elseif item:IsA("Animation") then
			table.insert(row, item.AnimationId)
		end
		table.insert(records, h:JSONEncode(row))
	end
	table.sort(records)
	return table.concat(records, "\n")
end
local backup = game.ServerStorage.FishUpgradeBackups.BeforeRace_20261104_095404
local result = { passed = true, folders = {} }
for _, pair in
	{
		{ workspace["race的鱼"], backup.RaceOriginals },
		{ workspace.Fish_Processed, backup.ProcessedBefore },
		{ game.ReplicatedStorage.Models.Fish, backup.TemplatesBefore },
	}
do
	local current = Instance.new("Folder")
	for _, old in pair[2]:GetChildren() do
		assert(pair[1]:FindFirstChild(old.Name), "Missing original " .. old.Name)
		pair[1][old.Name]:Clone().Parent = current
	end
	assert(fingerprint(current) == fingerprint(pair[2]), "Original resource changed " .. pair[1]:GetFullName())
	current:Destroy()
	table.insert(result.folders, { folder = pair[1]:GetFullName(), unchangedFish = #pair[2]:GetChildren() })
end
h:PostAsync(
	"http://127.0.0.1:18775/preservation-validation.json",
	h:JSONEncode(result),
	Enum.HttpContentType.ApplicationJson
)
return result
