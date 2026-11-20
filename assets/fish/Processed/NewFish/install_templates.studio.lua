--# selene: allow(global_usage)
-- Atomic batch admission after published-asset and Client gameplay validation.
assert(game.PlaceId == 84106335829275 and game.CreatorId == 598797612, "Wrong development place")
local h = game:GetService("HttpService")
local manifest = h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/source-manifest.json"))
local gameplay = h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/gameplay-validation.json"))
local regression = h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/regression-validation.json"))
local stage = assert(workspace:FindFirstChild("_FishNewFish_Staging"))
local processed = workspace.Fish_Processed
local templates = game.ReplicatedStorage.Models.Fish
local expected = #manifest.fish
local finalCount = manifest.existingProcessed + expected
assert(_G.NewFishValidationJob.done and _G.NewFishValidationJob.count == expected, "Asset audit incomplete")
assert(next(_G.NewFishValidationJob.errors) == nil, "Unresolved asset failure")
assert(gameplay.done and #gameplay.results == finalCount and #gameplay.errors == 0, "Gameplay audit incomplete")
for _, result in gameplay.results do
	assert(result.passed and result.framingPassed, "Gameplay/framing failure " .. result.name)
end
assert(
	regression.random.passed and regression.random.templates == finalCount and regression.drip.passed,
	"Regression audit incomplete"
)
assert(#stage:GetChildren() == expected, "Staging batch incomplete")
assert(#processed:GetChildren() == manifest.existingProcessed, "Processed directory changed during production")
assert(#templates:GetChildren() == manifest.existingTemplates, "Template directory changed during production")
assert(require(game.ReplicatedStorage.Modules.FishingConfig).Bite.FishName == nil, "Random pool is not enabled")
for _, spec in manifest.fish do
	local fish = assert(stage:FindFirstChild(spec.name), "Missing " .. spec.name)
	assert(
		not processed:FindFirstChild(spec.name) and not templates:FindFirstChild(spec.name),
		"Name collision " .. spec.name
	)
	assert(
		fish.PrimaryPart and fish.Animations and #fish.Animations:GetChildren() == 5,
		"Incomplete fish " .. spec.name
	)
	assert(_G.NewFishValidationJob.results[spec.name].passed, "Failed fish " .. spec.name)
end
local backup = Instance.new("Folder")
backup.Name = "BeforeNewFishMerge_" .. os.date("!%Y%m%d_%H%M%S")
backup.Parent = game.ServerStorage.FishUpgradeBackups
local function backupModels(source, name)
 local copy=Instance.new("Folder")
 copy.Name=name
 for key,value in source:GetAttributes() do
  copy:SetAttribute(key,value)
 end
 copy.Parent=backup
 for _,model in source:GetChildren() do
  model:Clone().Parent=copy
  task.wait()
 end
end
backupModels(processed,"ProcessedBefore")
backupModels(templates,"TemplatesBefore")
for _, spec in manifest.fish do
	local fish = stage[spec.name]
	fish:SetAttribute("ProcessingStatus", "Complete")
	fish.Parent = processed
	local template = fish:Clone()
	template.Parent = templates
 task.wait()
end
assert(#processed:GetChildren() == finalCount and #templates:GetChildren() == finalCount, "Merge count mismatch")
local result = {
	complete = true,
	newFish = expected,
	processed = finalCount,
	templates = finalCount,
	backup = backup:GetFullName(),
}
h:PostAsync("http://127.0.0.1:18775/installation.json", h:JSONEncode(result), Enum.HttpContentType.ApplicationJson)
return result
