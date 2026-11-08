-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMNFnNldENhbWVyYU1vZGVUb2FzdE9wZW4Zc2V0Q2FtZXJhTW9kZVRvYXN0RW5hYmxlZAZhc3NlcnQQU2VuZE5vdGlmaWNhdGlvbgVUaXRsZRZDYW1lcmEgQ29udHJvbCBFbmFibGVkBFRleHQVUmlnaHQgY2xpY2sgdG8gdG9nZ2xlCER1cmF0aW9uB1NldENvcmUEZ2FtZQpTdGFydGVyR3VpCkdldFNlcnZpY2UAAwMBAgAABgMAAAUBAQ8rAAMA+wEAACsBAQCCAAEA+wEAACsBAgCpAQEA3gEAACsABQD7AQEATQEB5wAAAACpAgAAnwECAYIAAQABAwEACgIBGAAAAAEDAAEAAwEAAAAAAgsAAAAABQECAAAGAwAABQEBDfsCAAC7AQICpAEBAAAAAECfAQIBDgAGAPsBAQBvAwIA4gQJALwBAb8KAAAAnwEEAYIAAQALAwMEAAAAQAMEAwUDBgMHAwgDCQIAAAAAAAAIQAgDAwQAAAAFBgAAAAcIAAAAAwoAGAEBGAAAAAAAAgEAAAAAAAYZAAAAAAQAAAECABajAAAApAABAAAAAEBvAgIAvAAAFgMAAACfAAMCqQEAAP8CAgAAAAAA2QMAABIBAf8SAAIAMAMChQQAAADZAwEAEgEB/xIAAAAwAwLnBQAAAMEBAACCAgIABgMLBAAAAEADDAMNAwIDAQIAAQEAARgAAQAAAAAAAgIABAAAAAAOAAAAAA0AAQAAAAACb7zgiG4JzFFYQytZEgF0qh+k9/xdeIqJ

-- https://lua.expert/
local StarterGui = game:GetService("StarterGui")
local v1 = false
local t = {}

function t.setCameraModeToastEnabled(p1) --[[ setCameraModeToastEnabled | Line: 10 | Upvalues: v1 (ref), t (copy) ]]
	if not (p1 or v1) then
		return
	end

	if not v1 then
		v1 = true
	end

	if p1 then
		return
	end

	t.setCameraModeToastOpen(false)
end
function t.setCameraModeToastOpen(p1) --[[ setCameraModeToastOpen | Line: 24 | Upvalues: v1 (ref), StarterGui (copy) ]]
	assert(v1)

	if not p1 then
		return
	end

	StarterGui:SetCore("SendNotification", {
		Title = "Camera Control Enabled",
		Text = "Right click to toggle",
		Duration = 3
	})
end

return t