-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TagConfiguration = require(script:WaitForChild("TagConfiguration"))
local createTagEffect = require(script:WaitForChild("createTagEffect"))
local validation = require(script:WaitForChild("validation"))
return {
	configure = function() --[[ configure | Line: 7 | Upvalues: TagConfiguration (copy) ]]
		return TagConfiguration.new()
	end,
	createTagEffect = createTagEffect,
	validation = {
		verifyInstanceClass = validation.verifyInstanceClass
	}
}