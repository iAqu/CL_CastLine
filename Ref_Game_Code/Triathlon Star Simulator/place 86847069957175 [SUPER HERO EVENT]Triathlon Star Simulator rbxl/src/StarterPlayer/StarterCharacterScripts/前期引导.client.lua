-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:31:23
-- Luau version 6, Types version 3
-- Time taken: 0.002402 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer_upvr = game.Players.LocalPlayer
local GuideName_upvr = LocalPlayer_upvr:WaitForChild("GuideName", math.huge)
local var4_upvw
local var5_upvw
local tbl_upvr = {
	["训练引导"] = 1;
	["调速度引导"] = 1;
	["比赛引导"] = 1;
	["抽装备引导"] = 1;
	["去抽宠物引导"] = 1;
	["宠物引导"] = 1;
}
local tbl_upvr_2 = {
	["训练引导"] = 1;
	["调速度引导"] = 1;
	["比赛引导"] = 1;
	["抽装备引导"] = 1;
	["去抽宠物引导"] = 1;
	["宠物引导"] = 1;
}
local InsMgr_upvr = require(ReplicatedStorage.Tool.InsMgr)
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
local Debris_upvr = game:GetService("Debris")
local function clearGuide_upvr() -- Line 50, Named "clearGuide"
	--[[ Upvalues[6]:
		[1]: InsMgr_upvr (readonly)
		[2]: tbl_upvr_2 (readonly)
		[3]: RemoteEvent_upvr (readonly)
		[4]: Debris_upvr (readonly)
		[5]: var5_upvw (read and write)
		[6]: var4_upvw (read and write)
	]]
	local any_GetIns_result1 = InsMgr_upvr.GetIns("引导线文件夹", "Folder", workspace)
	for _, v in pairs(any_GetIns_result1:GetChildren()) do
		if tbl_upvr_2[v.Name] then
			RemoteEvent_upvr:FireServer("完成引导", v.Name)
		end
		Debris_upvr:AddItem(v, 0)
	end
	if var5_upvw then
		var5_upvw:Disconnect()
		var5_upvw = nil
	end
	if var4_upvw then
		var4_upvw:Disconnect()
		var4_upvw = nil
	end
	return any_GetIns_result1
end
local _____________upvr = ReplicatedStorage.ModelRes["引导箭头"]
local GuidePos_upvr = LocalPlayer_upvr:WaitForChild("GuidePos", math.huge)
local HumanModule_upvr = require(ReplicatedStorage.Tool.HumanModule)
local RunService_upvr = game:GetService("RunService")
local 获取距离_upvr = require(ReplicatedStorage.Tool["获取距离"])
local var22_upvw = 0
local function refresh_upvr() -- Line 74, Named "refresh"
	--[[ Upvalues[12]:
		[1]: GuideName_upvr (readonly)
		[2]: clearGuide_upvr (readonly)
		[3]: tbl_upvr (readonly)
		[4]: _____________upvr (readonly)
		[5]: GuidePos_upvr (readonly)
		[6]: HumanModule_upvr (readonly)
		[7]: LocalPlayer_upvr (readonly)
		[8]: var5_upvw (read and write)
		[9]: RunService_upvr (readonly)
		[10]: 获取距离_upvr (readonly)
		[11]: var4_upvw (read and write)
		[12]: var22_upvw (read and write)
	]]
	local var23
	if GuideName_upvr.Value == "" then
		clearGuide_upvr()
	else
		if not tbl_upvr[GuideName_upvr.Value] then return end
		local clone_upvr = _____________upvr:Clone()
		clone_upvr.Parent = clearGuide_upvr()
		var23 = GuideName_upvr
		local Value = var23.Value
		var23 = true
		local any_GetHumanoidRootPart_result1_2_upvr = HumanModule_upvr.GetHumanoidRootPart(LocalPlayer_upvr)
		if not any_GetHumanoidRootPart_result1_2_upvr then return end
		if var23 == nil then
			var23 = true
		end
		if Value then
			clone_upvr.Name = Value
		end
		var5_upvw = RunService_upvr.Heartbeat:Connect(function(arg1) -- Line 108
			--[[ Upvalues[4]:
				[1]: any_GetHumanoidRootPart_result1_2_upvr (readonly)
				[2]: 获取距离_upvr (copied, readonly)
				[3]: GuidePos_upvr (copied, readonly)
				[4]: clone_upvr (readonly)
			]]
			local Position = any_GetHumanoidRootPart_result1_2_upvr:GetPivot().Position
			local var29 = 7 / 获取距离_upvr.GetDistanceXZ(GuidePos_upvr.Value.Position, Position)
			clone_upvr:PivotTo(CFrame.new(Vector3.new(Position.X + (GuidePos_upvr.Value.X - Position.X) * var29, Position.Y, Position.Z + (GuidePos_upvr.Value.Z - Position.Z) * var29), GuidePos_upvr.Value.Position))
		end)
		if var23 == nil or var23 then
			var4_upvw = RunService_upvr.Heartbeat:Connect(function(arg1) -- Line 119
				--[[ Upvalues[6]:
					[1]: var22_upvw (copied, read and write)
					[2]: HumanModule_upvr (copied, readonly)
					[3]: LocalPlayer_upvr (copied, readonly)
					[4]: 获取距离_upvr (copied, readonly)
					[5]: GuidePos_upvr (copied, readonly)
					[6]: clearGuide_upvr (copied, readonly)
				]]
				var22_upvw += arg1
				if 0 < var22_upvw then
					var22_upvw = 0
					local any_GetHumanoidRootPart_result1 = HumanModule_upvr.GetHumanoidRootPart(LocalPlayer_upvr)
					local var32
					if any_GetHumanoidRootPart_result1 and 获取距离_upvr.GetDistance(any_GetHumanoidRootPart_result1.Position, GuidePos_upvr.Value.Position) < 10 then
						var32 = true
					else
						var32 = false
					end
					if var32 then
						clearGuide_upvr()
					end
				end
			end)
		end
	end
end
if LocalPlayer_upvr:WaitForChild("IsNewPlayer", math.huge).Value == true then
	require(ReplicatedStorage.Tool.AddListen).NumValueAdd(GuideName_upvr, function(arg1) -- Line 141
		--[[ Upvalues[1]:
			[1]: refresh_upvr (readonly)
		]]
		refresh_upvr()
	end)
else
	script:Destroy()
end