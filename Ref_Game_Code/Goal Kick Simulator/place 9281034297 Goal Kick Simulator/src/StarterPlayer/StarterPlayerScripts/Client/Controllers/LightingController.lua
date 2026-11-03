-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:55
-- Luau version 6, Types version 3
-- Time taken: 0.006938 seconds

local module_upvr = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local Lighting_upvr = game:GetService("Lighting")
local tbl_upvr = {"Atmosphere", "Sky", "SunRaysEffect", "BloomEffect", "ColorCorrectionEffect", "DepthOfFieldEffect"}
local tbl_upvr_2 = {
	SunRaysEffect = {
		Intensity = 0;
		Spread = false;
	};
	BloomEffect = {
		Intensity = 0;
		Size = false;
		Threshold = false;
	};
	ColorCorrectionEffect = {
		Brightness = 0;
		Contrast = 0;
		Saturation = 0;
		TintColor = false;
	};
	DepthOfFieldEffect = {
		FarIntensity = 0;
		FocusDistance = 0;
		InFocusRadius = 0;
		NearIntensity = 0;
	};
	Sky = {
		StarCount = 0;
		MoonAngularSize = 0;
		SunAngularSize = 0;
		MoonTextureId = true;
		SunTextureId = true;
		SkyboxBk = true;
		SkyboxDn = true;
		SkyboxFt = true;
		SkyboxLf = true;
		SkyboxRt = true;
		SkyboxUp = true;
	};
	Atmosphere = {
		Density = 0;
		Offset = 0;
	};
}
local tbl_upvr_4 = {
	SunRaysEffect = true;
	BloomEffect = true;
	ColorCorrectionEffect = true;
	DepthOfFieldEffect = true;
}
local function FindEnabledLighting_upvr(arg1) -- Line 67, Named "FindEnabledLighting"
	--[[ Upvalues[2]:
		[1]: Lighting_upvr (readonly)
		[2]: tbl_upvr_4 (readonly)
	]]
	local instance_3 = Lighting_upvr:FindFirstChildOfClass(arg1)
	if instance_3 then
		if tbl_upvr_4[arg1] and not instance_3.Enabled then
			for _, v in pairs(Lighting_upvr:GetChildren()) do
				if v:IsA(arg1) and v.Enabled then
					return v
				end
			end
			return
		end
		return instance_3
	end
end
local var19_upvw
local TweenService_upvr = game:GetService("TweenService")
function module_upvr.TweenLoad(arg1, arg2, arg3, arg4, arg5) -- Line 83
	--[[ Upvalues[7]:
		[1]: var19_upvw (read and write)
		[2]: tbl_upvr (readonly)
		[3]: FindEnabledLighting_upvr (readonly)
		[4]: tbl_upvr_2 (readonly)
		[5]: TweenService_upvr (readonly)
		[6]: Lighting_upvr (readonly)
		[7]: Util_upvr (readonly)
	]]
	local var37 = arg3 or 1
	local var38 = arg4
	if not var38 then
		var38 = Enum.EasingStyle.Linear
	end
	var38 = arg5
	local var39 = var38
	if not var39 then
		var39 = Enum.EasingDirection.Out
	end
	if var19_upvw then
		var19_upvw:Disconnect()
		var19_upvw = nil
	end
	local tbl_upvr_3 = {}
	for _, v_2 in pairs(tbl_upvr) do
		local instance_2 = arg2:FindFirstChildOfClass(v_2)
		local FindEnabledLighting_upvr_result1 = FindEnabledLighting_upvr(v_2)
		if instance_2 then
			if FindEnabledLighting_upvr_result1 then
				for i_3, v_3 in pairs(tbl_upvr_2[v_2]) do
					if v_3 == true then
						FindEnabledLighting_upvr_result1[i_3] = instance_2[i_3]
					else
						({})[i_3] = instance_2[i_3]
					end
				end
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				TweenService_upvr:Create(FindEnabledLighting_upvr_result1, TweenInfo.new(var37, var38, var39, 0, false, 0), {}):Play()
			else
				local any = Instance.new(v_2)
				local var50 = tbl_upvr_2[v_2]
				if var50 then
					for i_4, v_4 in pairs(var50) do
						if typeof(v_4) == "number" then
							any[i_4] = v_4
							;({})[i_4] = instance_2[i_4]
						elseif v_4 == true then
							any[i_4] = instance_2[i_4]
						else
							-- KONSTANTERROR: Expression was reused, decompilation is incorrect
							;({})[i_4] = instance_2[i_4]
						end
					end
				end
				any.Parent = Lighting_upvr
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x3)
				TweenService_upvr:Create(any, TweenInfo.new(var37, var38, var39, 0, false, 0), {}):Play()
			end
		elseif FindEnabledLighting_upvr_result1 then
			for i_7, v_7 in pairs(tbl_upvr_2[v_2]) do
				if v_7 == true then
					FindEnabledLighting_upvr_result1[i_7] = ""
				elseif typeof(v_7) == "number" then
					({})[i_7] = v_7
				end
			end
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x3)
			TweenService_upvr:Create(FindEnabledLighting_upvr_result1, TweenInfo.new(var37, var38, var39, 0, false, 0), {}):Play()
			tbl_upvr_3[#tbl_upvr_3 + 1] = FindEnabledLighting_upvr_result1
		end
	end
	local class_Clouds_4 = arg2:FindFirstChildOfClass("Clouds")
	local class_Clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
	if class_Clouds then
		if class_Clouds_4 then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x2)
			TweenService_upvr:Create(class_Clouds, TweenInfo.new(var37, var38, var39, 0, false, 0), {
				Cover = class_Clouds_4.Cover;
				Density = class_Clouds_4.Density;
				Color = class_Clouds_4.Color;
			}):Play()
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x2)
			TweenService_upvr:Create(class_Clouds, TweenInfo.new(var37, var38, var39, 0, false, 0), {
				Cover = 0;
			}):Play()
			tbl_upvr_3[#tbl_upvr_3 + 1] = class_Clouds
		end
	elseif class_Clouds_4 then
		local Clouds = Instance.new("Clouds")
		Clouds.Cover = 0
		Clouds.Density = 0
		Clouds.Color = class_Clouds_4.Color
		Clouds.Parent = workspace.Terrain
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x2)
		TweenService_upvr:Create(Clouds, TweenInfo.new(var37, var38, var39, 0, false, 0), {
			Cover = class_Clouds_4.Cover;
			Density = class_Clouds_4.Density;
		}):Play()
	end
	var19_upvw = Util_upvr.Thread.Delay(var37, function() -- Line 175
		--[[ Upvalues[2]:
			[1]: tbl_upvr_3 (readonly)
			[2]: var19_upvw (copied, read and write)
		]]
		for _, v_5 in pairs(tbl_upvr_3) do
			v_5:Destroy()
		end
		var19_upvw = nil
	end)
	Lighting_upvr.ClockTime = arg2:GetAttribute("ClockTime")
	Lighting_upvr.GeographicLatitude = arg2:GetAttribute("GeographicLatitude")
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x2)
	TweenService_upvr:Create(Lighting_upvr, TweenInfo.new(var37, var38, var39, 0, false, 0), {
		Ambient = arg2:GetAttribute("Ambient");
		Brightness = arg2:GetAttribute("Brightness");
		ColorShift_Bottom = arg2:GetAttribute("ColorShift_Bottom");
		ColorShift_Top = arg2:GetAttribute("ColorShift_Top");
		EnvironmentDiffuseScale = arg2:GetAttribute("EnvironmentDiffuseScale");
		EnvironmentSpecularScale = arg2:GetAttribute("EnvironmentSpecularScale");
		GlobalShadows = arg2:GetAttribute("GlobalShadows");
		OutdoorAmbient = arg2:GetAttribute("OutdoorAmbient");
		ShadowSoftness = arg2:GetAttribute("ShadowSoftness");
		ExposureCompensation = arg2:GetAttribute("ExposureCompensation");
	}):Play()
end
function module_upvr.QuickLoad(arg1, arg2) -- Line 200
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: Lighting_upvr (readonly)
	]]
	for _, v_6 in pairs(tbl_upvr) do
		local instance_4 = arg2:FindFirstChildOfClass(v_6)
		local instance = Lighting_upvr:FindFirstChildOfClass(v_6)
		if instance_4 then
			local clone = instance_4:Clone()
			if instance then
				clone.Name = instance.Name
				instance:Destroy()
			end
			clone.Parent = Lighting_upvr
		elseif instance then
			instance:Destroy()
		end
	end
	local class_Clouds_3 = arg2:FindFirstChildOfClass("Clouds")
	local class_Clouds_2 = workspace.Terrain:FindFirstChildOfClass("Clouds")
	if class_Clouds_2 then
		class_Clouds_2:Destroy()
	end
	if class_Clouds_3 then
		class_Clouds_3:Clone().Parent = workspace.Terrain
	end
	Lighting_upvr.Ambient = arg2:GetAttribute("Ambient")
	Lighting_upvr.Brightness = arg2:GetAttribute("Brightness")
	Lighting_upvr.ColorShift_Bottom = arg2:GetAttribute("ColorShift_Bottom")
	Lighting_upvr.ColorShift_Top = arg2:GetAttribute("ColorShift_Top")
	Lighting_upvr.EnvironmentDiffuseScale = arg2:GetAttribute("EnvironmentDiffuseScale")
	Lighting_upvr.EnvironmentSpecularScale = arg2:GetAttribute("EnvironmentSpecularScale")
	Lighting_upvr.GlobalShadows = arg2:GetAttribute("GlobalShadows")
	Lighting_upvr.OutdoorAmbient = arg2:GetAttribute("OutdoorAmbient")
	Lighting_upvr.ShadowSoftness = arg2:GetAttribute("ShadowSoftness")
	Lighting_upvr.ClockTime = arg2:GetAttribute("ClockTime")
	Lighting_upvr.GeographicLatitude = arg2:GetAttribute("GeographicLatitude")
	Lighting_upvr.ExposureCompensation = arg2:GetAttribute("ExposureCompensation")
end
function module_upvr.TweenLoadFromLightingName(arg1, arg2, ...) -- Line 244
	--[[ Upvalues[2]:
		[1]: Lighting_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local SOME_2 = Lighting_upvr.LightingSettings:FindFirstChild(arg2)
	if SOME_2 then
		return module_upvr:TweenLoad(SOME_2, ...)
	end
	warn("No lighting settings found for "..arg2)
	return module_upvr:ResumeDefault(...)
end
function module_upvr.QuickLoadFromLightingName(arg1, arg2) -- Line 254
	--[[ Upvalues[2]:
		[1]: Lighting_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local SOME = Lighting_upvr.LightingSettings:FindFirstChild(arg2)
	if SOME then
		return module_upvr:QuickLoad(SOME)
	end
end
function module_upvr.SetDefault(arg1, arg2) -- Line 261
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr.Default = arg2
	module_upvr:QuickLoad(arg2)
end
function module_upvr.ResumeDefault(arg1, arg2, ...) -- Line 266
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if module_upvr.Default then
		if arg2 or 0 < arg2 then
			module_upvr:TweenLoad(module_upvr.Default, arg2, ...)
			return
		end
		module_upvr:QuickLoad(module_upvr.Default)
	end
end
Util_upvr.LightingController = module_upvr
return module_upvr