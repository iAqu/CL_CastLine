-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMhDGdldFRvZ2dsZVBhbgR0aWNrFnNldENhbWVyYU1vZGVUb2FzdE9wZW4Mc2V0VG9nZ2xlUGFuFHNldE1vdXNlSWNvbk92ZXJyaWRlLnJieGFzc2V0Oi8vdGV4dHVyZXMvQ3Vyc29ycy9Dcm9zc01vdXNlSWNvbi5wbmcYc2V0TW91c2VCZWhhdmlvck92ZXJyaWRlBEVudW0NTW91c2VCZWhhdmlvcgpMb2NrQ2VudGVyF3NldFJvdGF0aW9uVHlwZU92ZXJyaWRlDFJvdGF0aW9uVHlwZQ5DYW1lcmFSZWxhdGl2ZRByZXN0b3JlTW91c2VJY29uFHJlc3RvcmVNb3VzZUJlaGF2aW9yEE1vdmVtZW50UmVsYXRpdmUKZ2V0SG9sZFBhbhNMb2NrQ3VycmVudFBvc2l0aW9uE3Jlc3RvcmVSb3RhdGlvblR5cGUEZ2FtZQdQbGF5ZXJzCkdldFNlcnZpY2UQVXNlcklucHV0U2VydmljZQxVc2VyU2V0dGluZ3MQVXNlckdhbWVTZXR0aW5ncwdyZXF1aXJlBnNjcmlwdAZQYXJlbnQLQ2FtZXJhSW5wdXQMV2FpdEZvckNoaWxkCENhbWVyYVVJC0NhbWVyYVV0aWxzGXNldENhbWVyYU1vZGVUb2FzdEVuYWJsZWQAAgYBCAAABgMAAAUBAaYB+wEAAE0BAREAAAAAnwEBAg4ABQD7AgEA8QEDAAIAAACpAgEA3gICAPsCAQCaAgkAAQAAAKQDAgAAABBAnwMBAvsEAwAmAgMEjAMDAGADGgACAAAAUgIBAA4CCgCkBAIAAAAQQJ8EAQL7BQMAJgMEBYwEAwC3AwIABAAAAKkCAAGpAgEA+wMEAE0DA+cDAAAAUgQCAJ8DAgEOAQIAqQMAAN4DAgCkAwIAAAAQQJ8DAQLeAwMA3gEBAPsCBQDxABQAAgAAAA4ACwD7AgAATQICEQAAAACfAgEC3gIGAPsCAABNAgIFBAAAAKkDAQCfAgIBZQAHAPsCAgArAgUA+wIAAE0CAgUEAAAA+wMGAJ8CAgEOACYA+wIAAE0CAhEAAAAAnwIBAg4CEgD7AgcATQICvgUAAABvAwYAnwICAfsCBwBNAgLQBwAAAKQDCwAKJIDAnwICAfsCBwBNAgIpDAAAAKQDDwAONIDAnwICAWUASAD7AgcATQICuBAAAACfAgEB+wIHAE0CAiERAAAAnwIBAfsCBwBNAgIpDAAAAKQDDwAONIDAnwICAWUAOQD7AgAATQICEQAAAACfAgECDgISAPsCBwBNAgK+BQAAAG8DBgCfAgIB+wIHAE0CAtAHAAAApAMLAAokgMCfAgIB+wIHAE0CAikMAAAApAMTABI0gMCfAgIBZQAiAPsCAABNAgJkFAAAAJ8CAQIOAhEA+wIHAE0CArgQAAAAnwIBAfsCBwBNAgLQBwAAAKQDFgAVJIDAnwICAfsCBwBNAgIpDAAAAKQDEwASNIDAnwICAWUADAD7AgcATQICuBAAAACfAgEB+wIHAE0CAiERAAAAnwIBAfsCBwBNAgJrFwAAAJ8CAQHeAAUAggABABgDAQMCBAAAEEADAwMEAwUDBgMHAwgDCQMKBAokgMADCwMMAw0EDjSAwAMOAw8DEAQSNIDAAxEDEgQVJIDAAxMAFAABGAAAAAADAAAAAQADAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAIAAAAAAgEAAgAAAAEDAAABAQAAAAABAAAAAAABAAEAAAAABAEAAAAAAQAAAAABAAAAAAABAAAAAAAAAgAAAAEAAAABAAAAAAAAAwAAAAABAAAAAAEAAAAAAAEAAAAAAAACAAAAAAEAAAABAAAAAAABAAAAAAAAAwAAAAEAAAABAAAAAwEVAAAAAA0AAAECAEujAAAApAABAAAAAEBvAgIAvAAAFgMAAACfAAMCpAEBAAAAAEBvAwQAvAEBFgMAAACfAQMCpAIGAAAAUECfAgECbwQHALwCAhYDAAAAnwIDAqQDCQAAAIBApAQLAAAAoEBNBAQkDAAAAG8GDQC8BATTDgAAAJ8EAwCfAwACpAQJAAAAgECkBQsAAACgQE0FBSQMAAAAbwcPALwFBdMOAAAAnwUDAJ8EAAKkBQkAAACAQKQGCwAAAKBATQYGJAwAAABvCBAAvAYG0w4AAACfBgMAnwUAAqkGAACkBxIAAAAQQZ8HAQKpCAAAqQkAAKkKAABNCwSFEwAAAKkMAACfCwIB2QsAABIAAwASAQb/EgEI/xIBB/8SAAQAEgEK/xIBCf8SAAUAwQYAAIILAgAUAxQEAAAAQAMVAxYDFwMYBAAAUEADGQMaBAAAgEADGwQAAKBAAxwDHQMeAx8DIAMCBAAAEEEDIQEAAQABGAAAAAAAAAABAAAAAAABAAAAAAAAAgAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAgEAAAQBAQIAAAACAAAAAAAAAAAAAAEAAAAAAWxgj7QuEG01ROCVRsN5+IoceJjAXqTltQ==

-- https://lua.expert/
game:GetService("Players")
game:GetService("UserInputService")
UserSettings():GetService("UserGameSettings")

local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local CameraUI = require(script.Parent:WaitForChild("CameraUI"))
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local v1 = false
local v2 = tick()
local v3 = false
local v4 = false
local v5 = false

CameraUI.setCameraModeToastEnabled(false)

return function(p1) --[[ Line: 20 | Upvalues: CameraInput (copy), v1 (ref), v3 (ref), v2 (ref), CameraUI (copy), v5 (ref), v4 (ref), CameraUtils (copy) ]]
	local v12 = CameraInput.getTogglePan()

	if p1 and v12 ~= v1 then
		v3 = true
	end

	if v1 ~= v12 or tick() - v2 > 3 then
		CameraUI.setCameraModeToastOpen(if v12 then tick() - v2 < 3 else v12)

		if v12 then
			v3 = false
		end

		v2 = tick()
		v1 = v12
	end

	if p1 ~= v5 and p1 then
		v4 = CameraInput.getTogglePan()
		CameraInput.setTogglePan(true)
	elseif p1 ~= v5 and not v3 then
		CameraInput.setTogglePan(v4)
	end

	if p1 then
		if CameraInput.getTogglePan() then
			CameraUtils.setMouseIconOverride("rbxasset://textures/Cursors/CrossMouseIcon.png")
			CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
		else
			CameraUtils.restoreMouseIcon()
			CameraUtils.restoreMouseBehavior()
		end

		CameraUtils.setRotationTypeOverride(Enum.RotationType.CameraRelative)
	elseif CameraInput.getTogglePan() then
		CameraUtils.setMouseIconOverride("rbxasset://textures/Cursors/CrossMouseIcon.png")
		CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
		CameraUtils.setRotationTypeOverride(Enum.RotationType.MovementRelative)
	elseif CameraInput.getHoldPan() then
		CameraUtils.restoreMouseIcon()
		CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition)
		CameraUtils.setRotationTypeOverride(Enum.RotationType.MovementRelative)
	else
		CameraUtils.restoreMouseIcon()
		CameraUtils.restoreMouseBehavior()
		CameraUtils.restoreRotationType()
	end

	v5 = p1
end