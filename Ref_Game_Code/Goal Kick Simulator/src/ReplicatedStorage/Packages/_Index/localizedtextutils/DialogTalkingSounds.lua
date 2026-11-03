-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:21
-- Luau version 6, Types version 3
-- Time taken: 0.003783 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local tbl_upvr = {{
	word = "oink";
	id = 277352870;
	basePitch = 2.5;
	volume = 0.5;
}, {
	word = "meow";
	id = 277352709;
	basePitch = 2.5;
	volume = 0.5;
}, {
	word = "moo";
	id = 277352774;
	basePitch = 2.5;
	volume = 0.5;
}, {
	word = "neigh";
	id = 277352807;
	basePitch = 2.5;
	volume = 0.5;
}, {
	word = "bark";
	id = 277352650;
	basePitch = 2.5;
	volume = 0.5;
}, {
	word = "baa";
	id = 277352609;
	basePitch = 2.5;
	volume = 0.5;
}, {
	word = "ribbet";
	id = 277352920;
	basePitch = 2.5;
	volume = 0.5;
}}
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "DialogTalkingSounds"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local SoundService_upvr = game:GetService("SoundService")
local RunService_upvr = game:GetService("RunService")
function setmetatable_result1_upvr.new(arg1) -- Line 81
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: tbl_upvr (readonly)
		[4]: SoundService_upvr (readonly)
		[5]: RunService_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_upvr)
	local var21 = arg1
	if not var21 then
		var21 = error("No voicePitchAdjustment")
	end
	setmetatable_result1_upvr_2._voicePitchAdjustment = var21
	setmetatable_result1_upvr_2._soundLookupMap = {}
	setmetatable_result1_upvr_2._soundToData = {}
	for _, v in pairs(tbl_upvr) do
		local Sound = Instance.new("Sound")
		Sound.Volume = v.volume
		Sound.Name = "TalkingSound_%s":format(tostring(v.word))
		Sound.SoundId = "rbxassetid://"..v.id
		Sound.Archivable = false
		Sound.Parent = SoundService_upvr
		setmetatable_result1_upvr_2._maid:GiveTask(Sound)
		setmetatable_result1_upvr_2._soundToData[Sound] = v
		local tbl = {}
		for i_2 in v.word:gmatch('.') do
			if not tbl[i_2] then
				tbl[i_2] = true
				if not setmetatable_result1_upvr_2._soundLookupMap[i_2] then
					setmetatable_result1_upvr_2._soundLookupMap[i_2] = {}
				end
				table.insert(setmetatable_result1_upvr_2._soundLookupMap[i_2], Sound)
			end
		end
	end
	setmetatable_result1_upvr_2._maid:GiveTask(RunService_upvr.Stepped:Connect(function() -- Line 117
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_updatePitch()
	end))
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.SetVolumeMultiplier(arg1, arg2) -- Line 124
	for i_3, v_2 in pairs(arg1._soundToData) do
		i_3.Volume = 0.1 * arg2 * v_2.volume
	end
end
function setmetatable_result1_upvr.EnumerateTextStep(arg1, arg2, arg3, arg4, arg5) -- Line 130
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local _ = arg5
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [32] 28. Error Block 7 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [32] 28. Error Block 7 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [4] 5. Error Block 11 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [32.8]
	if nil then
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [32.11]
		if nil then
			-- KONSTANTWARNING: GOTO [32] #28
		end
	else
	end
	-- KONSTANTERROR: [4] 5. Error Block 11 end (CF ANALYSIS FAILED)
end
local var1_result1_upvr = any_load_result1("RandomUtils")
function setmetatable_result1_upvr.Enumerate(arg1, arg2) -- Line 152
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local var38 = arg1._soundLookupMap[arg2:lower()]
	if not var38 then
		return false
	end
	if not var1_result1_upvr.choice(var38) then
		error("[DialogTalkingSounds.Enumerate] - Found option table with 0 entries for %q":format(tostring(arg2)))
	end
	return true
end
function setmetatable_result1_upvr._updatePitch(arg1) -- Line 169
	for i_4, v_3 in pairs(arg1._soundToData) do
		local var46
		if v_3.overridePitch then
			var46 = v_3.overridePitch
		else
			var46 = v_3.basePitch + arg1._voicePitchAdjustment
		end
		i_4.Pitch = var46 + 0.2 * math.noise(0.35234234, tick() * 10 % 100000)
	end
end
return setmetatable_result1_upvr