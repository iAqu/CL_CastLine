-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:18
-- Luau version 6, Types version 3
-- Time taken: 0.008330 seconds

local RunService_upvr = game:GetService("RunService")
local module_upvr = {
	DEBUG_MODE = true;
	WATER_FLOOR_LEVEL = 0;
	MINIMAP = {
		RENDERRANGE = 30;
	};
	BATTLEPASSINFO = {
		SeasonStart = 1695060000;
		SeasonDuration = 1209600;
	};
	DEFAULT_WALKSPEED = 18;
	MATCH = {
		DEFAULT = {
			INVULNERABLE_LENGTH = 1;
			LENGTH = 90;
			LENGTH_ADDED_UPON_KILL = 20;
		};
	};
	ZONECURRENCY = {
		Stadium = "StadiumCoins";
	};
}
local tbl_7 = {}
local tbl_4 = {
	Priority = 2;
	Moderator = true;
}
local function Check(arg1) -- Line 38
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	local var10
	if var10 then
		var10 = true
		return var10
	end
	if 254 > arg1:GetRankInGroup(5173746) then
		var10 = false
	else
		var10 = true
	end
	return var10
end
tbl_4.Check = Check
tbl_4.Tag = {
	TagText = "Dev";
	TagColor = Color3.fromRGB(255, 204, 77);
}
tbl_4.ChatColor = Color3.fromRGB(255, 215, 0)
tbl_7.Developer = tbl_4
local tbl_8 = {
	SpecialTag = true;
}
local function Check(arg1) -- Line 52
	local var13
	if arg1:GetRankInGroup(5173746) ~= 10 then
		var13 = false
	else
		var13 = true
	end
	return var13
end
tbl_8.Check = Check
tbl_8.Tag = {
	TagText = "Tester";
	TagColor = Color3.fromRGB(80, 120, 255);
}
tbl_7.Tester = tbl_8
local tbl_5 = {
	Moderator = true;
}
local function Check(arg1) -- Line 62
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	local var16
	if var16 then
		var16 = true
		return var16
	end
	if 252 > arg1:GetRankInGroup(5173746) then
		var16 = false
	else
		var16 = true
	end
	return var16
end
tbl_5.Check = Check
tbl_5.SpecialTag = true
tbl_5.Tag = {
	TagText = "Mod";
	TagColor = Color3.fromRGB(77, 204, 255);
}
tbl_5.ChatColor = Color3.fromRGB(0, 215, 255)
tbl_7.Moderator = tbl_5
local tbl = {
	Priority = 1;
}
local function Check(arg1) -- Line 77
	local var19
	if arg1.UserId ~= game.PrivateServerOwnerId then
		var19 = false
	else
		var19 = true
	end
	return var19
end
tbl.Check = Check
tbl.Tag = {
	TagText = "Op";
	TagColor = Color3.fromRGB(255, 17, 0);
}
tbl.ChatColor = Color3.fromRGB(255, 127, 127)
tbl_7.PrivateServerOperator = tbl
local tbl_3 = {}
local function Check(arg1) -- Line 88
	return arg1:GetAttribute("VIP")
end
tbl_3.Check = Check
tbl_3.SpecialTag = true
tbl_3.Tag = {
	TagText = "VIP";
	TagColor = Color3.fromRGB(255, 255, 0);
}
tbl_3.ChatColor = Color3.fromRGB(200, 200, 127)
tbl_7.VIP = tbl_3
local tbl_2 = {}
local function Check(arg1) -- Line 99
	local var24
	if arg1:GetRankInGroup(5173746) ~= 1 then
		var24 = false
	else
		var24 = true
	end
	return var24
end
tbl_2.Check = Check
tbl_2.Tag = {
	TagText = "FAN";
	TagColor = Color3.fromRGB(180, 200, 0);
}
tbl_2.SpecialTag = true
tbl_7.FAN = tbl_2
tbl_7.Influencer = {
	Check = function(arg1) -- Line 109, Named "Check"
		local var27
		if arg1:GetRankInGroup(5173746) ~= 3 then
			var27 = false
		else
			var27 = true
		end
		return var27
	end;
	SpecialTag = true;
	Tag = {
		TagText = "Influencer";
		TagColor = Color3.fromRGB(255, 17, 0);
	};
	ChatColor = Color3.fromRGB(255, 127, 127);
}
module_upvr.OPERATOR_SETTINGS = tbl_7
module_upvr.HUMANOID_CONFIG = {
	PLAYER = {
		WALKSPEED = 12;
		RUNNING = 24;
		JUMPPOWER = 50;
	};
}
module_upvr.DEFAULT_INVENTORY = {
	EquipItem = {
		Greatblade = {
			Primary = "2_bca";
		};
		TwoSwordStyle = {
			Primary = "1_abc";
			Secondary = "3_abc";
		};
	};
	Items = {
		["1_abc"] = {
			Name = "Yoru";
		};
		["2_bca"] = {
			Name = "Yoru";
		};
		["3_abc"] = {
			Name = "Yoru";
		};
	};
	Slots = {
		HeadTop = "N/A";
		HeadFront = "N/A";
		Shirt = "N/A";
		Pants = "N/A";
		Boots = "N/A";
		Front = "N/A";
		Back = "N/A";
		RightHand = "N/A";
		LeftHand = "N/A";
	};
	Appearance = {
		HeadTop = "N/A";
		HeadFront = "N/A";
		Shirt = "N/A";
		Pants = "N/A";
		Boots = "N/A";
		Front = "N/A";
		Back = "N/A";
		RightHand = "N/A";
		LeftHand = "N/A";
	};
}
module_upvr.SHOOT_PARAMS = {
	RayCheck = function(arg1) -- Line 172, Named "RayCheck"
		local Name = arg1.Name
		if arg1.Parent:FindFirstChild("Humanoid") or arg1.Parent.Parent:FindFirstChild("Humanoid") then
			return false
		end
		local var45 = false
		if arg1.CanCollide == false then
			var45 = false
			if Name ~= "Collision" then
				if Name == "Shield" then
					var45 = false
				else
					var45 = true
				end
			end
		end
		return var45
	end;
	RayCheck_Explosion = function(arg1) -- Line 179, Named "RayCheck_Explosion"
		local Ship = workspace:FindFirstChild("Ship")
		if Ship and arg1:IsDescendantOf(Ship) then
			return true
		end
		if arg1.Parent:FindFirstChild("Humanoid") or arg1.Parent.Parent:FindFirstChild("Humanoid") then
			return true
		end
		local var47 = true
		if arg1.CanCollide ~= false then
			if 0.45 >= arg1.Transparency then
				var47 = false
			else
				var47 = true
			end
		end
		return var47
	end;
}
module_upvr.SHOOT_PARAMS.ExplosionRayParams = RaycastParams.new()
module_upvr.SHOOT_PARAMS.ExplosionRayParams.FilterType = Enum.RaycastFilterType.Blacklist
module_upvr.SHOOT_PARAMS.ExplosionRayParams.FilterDescendantsInstances = {workspace:FindFirstChild("Ignore"), workspace:FindFirstChild("Vehicles")}
module_upvr.SHOOT_PARAMS.RayParams = RaycastParams.new()
module_upvr.SHOOT_PARAMS.RayParams.FilterType = Enum.RaycastFilterType.Blacklist
module_upvr.SHOOT_PARAMS.RayParams.FilterDescendantsInstances = {workspace:FindFirstChild("Ignore")}
function module_upvr.NEW_SHOOT_PARAMS(arg1) -- Line 205
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local RaycastParams_new_result1 = RaycastParams.new()
	RaycastParams_new_result1.FilterType = Enum.RaycastFilterType.Blacklist
	local tbl_6 = {table.unpack(module_upvr.SHOOT_PARAMS.RayParams.FilterDescendantsInstances)}
	for _, v in pairs(arg1) do
		table.insert(tbl_6, v)
	end
	RaycastParams_new_result1.FilterDescendantsInstances = tbl_6
	return RaycastParams_new_result1
end
module_upvr.RAY_DEFAULTS = {
	Projectile = {
		Params = module_upvr.SHOOT_PARAMS.RayParams;
		Check = module_upvr.SHOOT_PARAMS.RayCheck;
	};
	Explosion = {
		Params = module_upvr.SHOOT_PARAMS.ExplosionRayParams;
		Check = module_upvr.SHOOT_PARAMS.RayCheck_Explosion;
	};
	Statics = {
		Params = RaycastParams.new();
		Check = module_upvr.SHOOT_PARAMS.RayCheck_Explosion;
	};
}
module_upvr.RANK_TITLES = {"Noob", "Starter", "Beginner", "Intermediate", "Advanced", "Expert", "Master", "Legend", "Ultimate", "Champion", "SUPER", "BOSS", "SUPERHUMAN", "GOD"}
module_upvr.RAY_DEFAULTS.Statics.Params.FilterType = Enum.RaycastFilterType.Blacklist
module_upvr.RAY_DEFAULTS.Statics.Params.FilterDescendantsInstances = {workspace:FindFirstChild("Ignore"), workspace:FindFirstChild("Vehicles"), workspace:FindFirstChild("Entity")}
module_upvr.WATER_LEVEL = 0
return module_upvr