-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.Services.MutationService)
local v1 = require("../../Shared/Data/Tags")
require(ReplicatedStorage.Shared.Data.EntitiesData)
require(ReplicatedStorage.Shared.Data.MutationData)
require("../ServicesLoader/TimerService")
local LoadIdleAnimations = require(ReplicatedStorage.Shared.Functional.LoadIdleAnimations)
local SetupBrainrotGui = require(ReplicatedStorage.Shared.Functional.SetupBrainrotGui)
local v2 = require("../../Shared/Packages/Trove")
local v3 = require("../../Shared/Packages/Observers")
require(ReplicatedStorage.Shared.Packages.Signal)
local t = {}
function ObserveNewEntity(p1) --[[ ObserveNewEntity | Line: 25 | Upvalues: v2 (copy), SetupBrainrotGui (copy), LoadIdleAnimations (copy) ]]
	local v1 = v2.new()
	local v22 = SetupBrainrotGui(p1, nil, true, nil)
	if v22 then
		v1:Add(v22)
	end
	local v3 = LoadIdleAnimations(p1)
	if v3 then
		v1:Add(v3)
	end
	return function() --[[ Line: 39 | Upvalues: v1 (copy) ]]
		v1:Clean()
	end
end
function t._init() --[[ _init | Line: 46 | Upvalues: v3 (copy), v1 (copy) ]]
	v3.observeTag(v1.Entity, ObserveNewEntity, { workspace.Entities, workspace.Debris })
end
return t