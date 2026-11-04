-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:52
-- Luau version 6, Types version 3
-- Time taken: 0.001380 seconds

local module = {}
local function _(arg1) -- Line 8, Named "InitStage"
	if not arg1:FindFirstChild("SkillStage") then
		local NumberValue_3 = Instance.new("NumberValue", arg1)
		NumberValue_3.Name = "SkillStage"
		NumberValue_3.Value = 0
	end
end
function module.ChargeStageOn(arg1) -- Line 19
	if not arg1:FindFirstChild("SkillStage") then
		local NumberValue_2 = Instance.new("NumberValue", arg1)
		NumberValue_2.Name = "SkillStage"
		NumberValue_2.Value = 0
	end
	local SkillStage_3 = arg1:FindFirstChild("SkillStage")
	if SkillStage_3 then
		SkillStage_3.Value = 1
	end
end
function module.PlayStageOn(arg1) -- Line 30
	if not arg1:FindFirstChild("SkillStage") then
		local NumberValue_4 = Instance.new("NumberValue", arg1)
		NumberValue_4.Name = "SkillStage"
		NumberValue_4.Value = 0
	end
	local SkillStage_4 = arg1:FindFirstChild("SkillStage")
	if SkillStage_4 then
		SkillStage_4.Value = 2
	end
end
function module.ResetStage(arg1) -- Line 41
	if not arg1:FindFirstChild("SkillStage") then
		local NumberValue_5 = Instance.new("NumberValue", arg1)
		NumberValue_5.Name = "SkillStage"
		NumberValue_5.Value = 0
	end
	local SkillStage_2 = arg1:FindFirstChild("SkillStage")
	if SkillStage_2 then
		SkillStage_2.Value = 0
	end
end
function module.GetStage(arg1) -- Line 52
	if not arg1:FindFirstChild("SkillStage") then
		local NumberValue = Instance.new("NumberValue", arg1)
		NumberValue.Name = "SkillStage"
		NumberValue.Value = 0
	end
	local SkillStage = arg1:FindFirstChild("SkillStage")
	if SkillStage then
		return SkillStage.Value
	end
	return nil
end
return module