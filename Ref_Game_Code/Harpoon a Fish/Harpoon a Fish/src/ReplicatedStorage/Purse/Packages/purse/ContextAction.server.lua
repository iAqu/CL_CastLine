-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Original SourceAssetId: https://assetdelivery.roblox.com/v1/asset/?id=112061170330936

-- ! Source from the asset above; the game may have edited it since.

--[[
--!strict

const ContextActionService = game:GetService("ContextActionService")
const BackpackScript = require(script.Parent)

const ACTION_NAME = "BackpackToggle"

const function handleAction(actionName, inputState, _inputObject)
	if actionName == ACTION_NAME and inputState == Enum.UserInputState.Begin then
		if BackpackScript.OpenClose then
			BackpackScript.OpenClose()
		end
	end
end

ContextActionService:BindAction(ACTION_NAME, handleAction, false, Enum.KeyCode.Backquote)

]]

-- The Script is Empty