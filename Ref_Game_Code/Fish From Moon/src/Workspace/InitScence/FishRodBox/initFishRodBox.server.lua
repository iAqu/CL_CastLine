local ReplicatedStorage=game:GetService("ReplicatedStorage")

local FishRoadPoolHelper=require(ReplicatedStorage.Config.FishRoadPoolHelper)
local NumberFormat=require(ReplicatedStorage.Source.Utils.NumberFormat)

local initDoorFolder=script.Parent

for k,v in pairs(initDoorFolder:GetChildren()) do
	if v:IsA("SurfaceGui") then
		v.Frame.price.Text=NumberFormat.AbbreviateNumber(FishRoadPoolHelper.GetFishRoadPoolInfo(v.Name).prince,2)
	end
end