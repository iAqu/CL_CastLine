-- Edit-time authoring only. Standard meshes share the Elder Fish motion curves.
return function(data, variant, partCount)
	local assets = game:GetService("AssetService")
	local sourceRoot = game.ServerStorage:FindFirstChild("FishAnimationSources")
	local root = sourceRoot:FindFirstChild("Processed") or Instance.new("Folder")
	root.Name, root.Parent = "Processed", sourceRoot
	local sources = Instance.new("Folder"); sources.Name, sources.Parent = variant, root
	local library = game.ReplicatedStorage.Animation.Fishing:FindFirstChild("ProcessedVariants") or Instance.new("Folder")
	library.Name, library.Parent = "ProcessedVariants", game.ReplicatedStorage.Animation.Fishing
	assert(not library:FindFirstChild(variant), "Variant already published")
	local folder = Instance.new("Folder"); folder.Name = variant
	local boneNames = table.clone(data.bones)
	local parents = {-1,0,1,2,3}
	if variant == "longtail" then
		table.insert(boneNames,"TailExtra1"); table.insert(boneNames,"TailExtra2")
		table.insert(parents,4); table.insert(parents,5)
	elseif variant == "fins" then
		table.insert(boneNames,"FinLeft"); table.insert(boneNames,"FinRight")
		table.insert(parents,2); table.insert(parents,2)
	end
	local results = {}
	for _,name in {"SwimLoop","StruggleLeft","StruggleRight","LiftFlop","ShowcaseFlop"} do
		local clip = data.clips[name]
		local sequence = Instance.new("KeyframeSequence")
		sequence.Name, sequence.Loop, sequence.Priority = name, clip.loop, Enum.AnimationPriority.Action
		sequence.Parent = sources
		for frameIndex,frame in clip.frames do
			local key = Instance.new("Keyframe"); key.Time, key.Parent = frame.time, sequence
			for partIndex=1,partCount do
				local rootPose=Instance.new("Pose")
				rootPose.Name = if partIndex==1 then "polySurface5" else string.format("FishMesh%02d",partIndex)
				rootPose.Weight, rootPose.Parent = 0,key
				local poses={}
				for index,bone in boneNames do
					local pose=Instance.new("Pose");pose.Name=bone
					if index<=5 then
						local matrix=frame.rotationMatrices and frame.rotationMatrices[bone]
						if matrix then pose.CFrame=CFrame.new(0,0,0,table.unpack(matrix))
						else local r=frame.rotations[bone];pose.CFrame=CFrame.Angles(math.rad(r[1]),math.rad(r[2]),math.rad(r[3])) end
						if variant~="standard" then pose.CFrame=CFrame.identity:Lerp(pose.CFrame,.7) end
					else
						local phase=frame.time/clip.duration
						local envelope=if clip.loop then 1 else math.sin(math.pi*phase)
						local angle=math.rad(if variant=="fins" then 8 else 14)*math.sin(2*math.pi*phase-(index-6)*.7)*envelope
						pose.CFrame=if variant=="fins" then CFrame.Angles(0,0,angle*(if index==6 then -1 else 1)) else CFrame.Angles(0,angle,0)
					end
					pose.EasingStyle=Enum.PoseEasingStyle[clip.interpolation or "Cubic"]
					pose.EasingDirection=Enum.PoseEasingDirection.InOut
					pose.Parent=poses[parents[index]+1] or rootPose;poses[index]=pose
				end
			end
			if frameIndex%5==0 then task.wait() end
		end
		local status,id=assets:CreateAssetAsync(sequence,Enum.AssetType.Animation,{
			CreatorId=game.CreatorId,CreatorType=Enum.AssetCreatorType.Group,
			Name="CastLine "..variant.." "..name,Description="Elder Fish motion adapted to all mesh layers and special fish fins/tails.",
		})
		assert(status==Enum.CreateAssetResult.Success,tostring(status)..":"..tostring(id))
		local animation=Instance.new("Animation");animation.Name=name;animation.AnimationId="rbxassetid://"..id
		animation:SetAttribute("Duration",clip.duration);animation.Parent=folder
		results[name]=id
		task.wait()
	end
	folder.Parent=library
	return {variant=variant,parts=partCount,animations=results}
end
