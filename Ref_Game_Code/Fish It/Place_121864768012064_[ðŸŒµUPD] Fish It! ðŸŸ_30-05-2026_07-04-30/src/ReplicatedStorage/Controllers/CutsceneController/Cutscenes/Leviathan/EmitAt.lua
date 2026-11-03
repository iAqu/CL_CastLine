-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local function emit(p1) --[[ emit | Line: 1 ]]
	if not p1 then
		return
	end
	if not (p1 and p1:IsA("ParticleEmitter")) then
		return
	end
	local v1 = p1:GetAttribute("EmitCount") or 1
	local v2 = p1:GetAttribute("EmitDelay")
	if v2 and (typeof(v2) == "number" and v2 > 0) then
		task.delay(v2, p1.Emit, p1, v1)
	else
		p1:Emit(v1)
	end
end
return {
	[243] = function() --[[ Line: 16 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.Leviathan.BodyMesh.FirstSplash:GetChildren()) do
			emit(v)
		end
	end,
	[430] = function() --[[ Line: 21 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.Leviathan.BodyMesh.Attachment:GetChildren()) do
			emit(v)
		end
	end,
	[663] = function() --[[ Line: 26 | Upvalues: emit (copy) ]]
		local t = {
			"shard1",
			"shard2",
			"shard3",
			"shard4",
			"shard5",
			"shard6",
			"line1",
			"fire1",
			"fire2",
			"fire3",
			"fire4",
			"fire5"
		}
		for i, v in ipairs(workspace.CutsceneStuff.Leviathan.BodyMesh.Big:GetDescendants()) do
			if table.find(t, v.Name) then
				emit(v)
			end
		end
	end,
	[664] = function() --[[ Line: 34 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.Leviathan.BodyMesh.Big:GetChildren()) do
			emit(v)
		end
	end,
	[712] = function() --[[ Line: 39 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.LightningStrike1:GetChildren()) do
			emit(v)
		end
	end,
	[777] = function() --[[ Line: 44 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.LightningStrike2:GetChildren()) do
			emit(v)
		end
	end,
	[808] = function() --[[ Line: 49 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.LightningStrike3:GetChildren()) do
			emit(v)
		end
	end,
	[811] = function() --[[ Line: 54 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.Leviathan.BodyMesh.Root["Spine.001"].Thing:GetChildren()) do
			emit(v)
		end
	end,
	[819] = function() --[[ Line: 59 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.Leviathan.BodyMesh.Root.Tongue.Attachment:GetChildren()) do
			emit(v)
		end
	end,
	[823] = function() --[[ Line: 64 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.Leviathan.BodyMesh.Root.Tongue.Attachment:GetChildren()) do
			emit(v)
		end
	end,
	[844] = function() --[[ Line: 69 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.Leviathan.BodyMesh.Root.Tongue.Attachment:GetChildren()) do
			emit(v)
		end
	end,
	[860] = function() --[[ Line: 74 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.Leviathan.BodyMesh.Root.Tongue.Attachment:GetChildren()) do
			emit(v)
		end
	end,
	[879] = function() --[[ Line: 79 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.Leviathan.BodyMesh.Root.Tongue.Attachment:GetChildren()) do
			emit(v)
		end
	end,
	[887] = function() --[[ Line: 84 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.Leviathan.BodyMesh.Root.Tongue.Attachment:GetChildren()) do
			emit(v)
		end
	end,
	[894] = function() --[[ Line: 89 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.LightningStrike4:GetChildren()) do
			emit(v)
		end
	end,
	[963] = function() --[[ Line: 94 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.Leviathan.BodyMesh.SecondSplash:GetChildren()) do
			emit(v)
		end
	end,
	[1129] = function() --[[ Line: 99 | Upvalues: emit (copy) ]]
		local t = {
			"shard1",
			"shard2",
			"shard3",
			"shard4",
			"shard5",
			"shard6",
			"line1",
			"fire1",
			"fire2",
			"fire3",
			"fire4",
			"fire5"
		}
		for i, v in ipairs(workspace.CutsceneStuff["Small Boat"].Visual.Tertiary.SsssPLASH:GetDescendants()) do
			if table.find(t, v.Name) then
				emit(v)
			end
		end
	end,
	[1134] = function() --[[ Line: 107 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff["Small Boat"].Visual.Tertiary.SsssPLASH:GetChildren()) do
			emit(v)
		end
	end,
	[1209] = function() --[[ Line: 112 | Upvalues: emit (copy) ]]
		for i, v in ipairs(workspace.CutsceneStuff.Leviathan.BodyMesh.Root.Tongue.Bite:GetChildren()) do
			emit(v)
		end
	end
}