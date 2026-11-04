local ReplicatedStorage=game:GetService("ReplicatedStorage")

local MapHelper=require(ReplicatedStorage.Config.MapHelper)
local NumberFormat=require(ReplicatedStorage.Source.Utils.NumberFormat)

local initDoorFolder=script.Parent

for k,v in pairs(initDoorFolder:GetChildren()) do
	if v:IsA("SurfaceGui") then
		v.Frame.money.Cost.Text=NumberFormat.AbbreviateNumber(MapHelper.GetMapPrice(v.Name),2)
	end
end