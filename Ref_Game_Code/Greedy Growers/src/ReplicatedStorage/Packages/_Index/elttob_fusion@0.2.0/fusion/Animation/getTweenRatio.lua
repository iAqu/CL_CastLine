-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMLCURlbGF5VGltZQRUaW1lCFJldmVyc2VzC1JlcGVhdENvdW50C0Vhc2luZ1N0eWxlD0Vhc2luZ0RpcmVjdGlvbghHZXRWYWx1ZQ1nZXRUd2VlblJhdGlvBGdhbWUMVHdlZW5TZXJ2aWNlCkdldFNlcnZpY2UAAhACAQAABwQAAAUCBwIpTQIAWwAAAABNAwBKAQAAAE0EAJUCAAAAjAYBAE0HAFADAAAAQwUGB00GAGkEAAAATQcALwUAAABDCAIDDgQBAEMICAMJCQgFfQkDAAEAAACMCQEAggkCAM8JAQh9CQMAAgAAAIwKAACCCgIAJgsJAuwKCwOMCwEAYAsCAAoAAAD1CgYK+wsAAFINCgBSDgYAUg8HALwLC/MHAAAAnwsFAoILAgAIAwEDAgMDAwQDBQMGAgAAAAAAAABAAwcACggBGAAAAQABAAEAAAABAAEAAgEBAwAAAQADAgABAAMAAQAAAQMAAAAAAAABCwAAAAADAAABAgAKowAAAKQAAQAAAABAbwICALwAABYDAAAAnwADAsABBAASAAAAggECAAUDCQQAAABAAwoDCwYAAQABAAEYAAcAAAAAAAIAIAEAAAAAAabpoFozlS5nnw+bOZGO/J7W8bculC3KWw==

-- https://lua.expert/
local TweenService = game:GetService("TweenService")

return function(p1, p2) --[[ getTweenRatio | Line: 10 | Upvalues: TweenService (copy) ]]
	local DelayTime = p1.DelayTime
	local Time = p1.Time
	local sum = DelayTime + Time

	if p1.Reverses then
		sum = sum + Time
	end

	if sum * (1 + p1.RepeatCount) <= p2 then
		return 1
	end

	local v2 = p2 % sum

	if v2 <= DelayTime then
		return 0
	end

	local sum2 = (v2 - DelayTime) / Time

	if sum2 > 1 then
		sum2 = 2 - sum2
	end

	return TweenService:GetValue(sum2, p1.EasingStyle, p1.EasingDirection)
end