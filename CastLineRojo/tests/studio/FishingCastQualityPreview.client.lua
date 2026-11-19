-- Execute on Studio Client. Only clones runtime UI; never changes the authored templates.
local progress = 0.97
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Config = require(RS.Modules.FishingConfig)
local Feedback = require(RS.Modules.FishingCastFeedback)
local gui = Players.LocalPlayer:WaitForChild("PlayerGui")
for _,name in {"CastQualityMeterPreview","CastQualityPopupPreview"} do
 local old=gui:FindFirstChild(name); if old then old:Destroy() end
end
local meterGui=game.StarterGui.CastMeterGui:Clone()
meterGui.Name="CastQualityMeterPreview"; meterGui.Enabled=true; meterGui.DisplayOrder=10000; meterGui.Parent=gui
local popupGui=Instance.new("ScreenGui")
popupGui.Name="CastQualityPopupPreview"; popupGui.DisplayOrder=10001; popupGui.IgnoreGuiInset=true; popupGui.Parent=gui
local popup=game.StarterGui.FishingSequenceGui.PowerPopup:Clone()
popup.Parent=popupGui
local holder=meterGui.Meter
holder.Visible=true
holder.Bar.Marker.Position=UDim2.fromScale(.5,1-progress)
holder.Bar.Marker.MultLabel.Visible=false
local owner={meter={gui=meterGui,holder=holder,marker=holder.Bar.Marker,prompt=holder.Prompt},
 popup=popup,popupStroke=popup.UIStroke,popupScale=popup.UIScale,originals={},createdScales={}}
function owner:_save(instance,props)
 for _,p in props do table.insert(self.originals,{instance=instance,property=p,value=instance[p]}) end
end
function owner:_scale(instance)
 local scale=instance:FindFirstChildOfClass("UIScale")
 if scale then self:_save(scale,{"Scale"}) else scale=Instance.new("UIScale"); scale.Parent=instance; table.insert(self.createdScales,scale) end
 return scale
end
local RunService=game:GetService("RunService")
RunService.RenderStepped:Wait(); RunService.RenderStepped:Wait()
Feedback.Show(owner,Config.GetCastRating(progress),100)
local samples={}
for _,elapsed in {0,.3,.899,1.05,1.19,1.21,1.49,1.51} do
 Feedback.Update(owner,100+elapsed)
 table.insert(samples,{elapsed=elapsed,meter=meterGui.Enabled,popup=popup.Visible,fade=popup.TextTransparency})
end
-- Freeze a visible frame for screenshot review after checking the actual production time line.
Feedback.Show(owner,Config.GetCastRating(progress),100)
Feedback.Update(owner,100.3)
RunService.RenderStepped:Wait(); RunService.RenderStepped:Wait()
local viewport=workspace.CurrentCamera.ViewportSize
local inside=popup.AbsolutePosition.X>=0 and popup.AbsolutePosition.Y>=0
 and popup.AbsolutePosition.X+popup.AbsoluteSize.X<=viewport.X
 and popup.AbsolutePosition.Y+popup.AbsoluteSize.Y<=viewport.Y
return {rating=popup.Text,inside=inside,viewport={viewport.X,viewport.Y},
 gradient=owner.meterFeedback.gradient and #owner.meterFeedback.gradient.Color.Keypoints or 0,samples=samples}
