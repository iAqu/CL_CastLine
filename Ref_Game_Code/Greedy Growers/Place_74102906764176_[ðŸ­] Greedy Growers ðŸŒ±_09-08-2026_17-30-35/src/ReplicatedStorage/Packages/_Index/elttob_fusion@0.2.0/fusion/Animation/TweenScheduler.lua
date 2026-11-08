-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMjA2FkZAZyZW1vdmUCb3MFY2xvY2sFcGFpcnMWX2N1cnJlbnRUd2VlblN0YXJ0VGltZRVfY3VycmVudFR3ZWVuRHVyYXRpb24RX2N1cnJlbnRUd2VlbkluZm8IUmV2ZXJzZXMKX3ByZXZWYWx1ZQ1fY3VycmVudFZhbHVlCl9uZXh0VmFsdWUTX2N1cnJlbnRseUFuaW1hdGluZw91cGRhdGVBbGxUd2VlbnMEZ2FtZQpSdW5TZXJ2aWNlCkdldFNlcnZpY2UGc2NyaXB0BlBhcmVudAdyZXF1aXJlBVR5cGVzCUFuaW1hdGlvbghsZXJwVHlwZQ1nZXRUd2VlblJhdGlvDERlcGVuZGVuY2llcwl1cGRhdGVBbGwGX19tb2RlAWsMc2V0bWV0YXRhYmxlFl9fRnVzaW9uVHdlZW5TY2hlZHVsZXIERW51bQ5SZW5kZXJQcmlvcml0eQVGaXJzdAVWYWx1ZRBCaW5kVG9SZW5kZXJTdGVwAAQDAQEAAAAE+wEAAKkCAQBqAgEAggABAAAAHQEBGAAAAAEeAAAAAAMBAQAAAAT7AQAAxgIAAGoCAQCCAAEAAAAkAgEYAAAAASUAAAAADAAFAAAAQKQAAgAABACAnwABAqQBBAAAADBA+wIAAJ8BAgQXATUATQcE5gUAAAAmBgAHTQcEpwYAAABgBxsABgAAAE0HBEwHAAAATQcHlQgAAAAOBwUATQcEugkAAAAwBwSzCgAAAGUABABNBwTjCwAAADAHBLMKAAAAqQcAADAHBD8MAAAA+wcBAFIIBACfBwIB+wcCAE0HB0kNAAAAUggEAJ8HAgFlABQA+wcDAE0IBEwHAAAAUgkGAJ8HAwL7CAQATQkEugkAAABNCgTjCwAAAFILBwCfCAQCMAgEswoAAACpCQEAMAkEPwwAAAD7CQEAUgoEAJ8JAgFuAcr/AQAAAIIAAQAOAwMDBAQABACAAwUEAAAwQAMGAwcDCAMJAwoDCwMMAw0DAgArDgEYAAAAAgAAAAABAAACAAAAAQAAAAABAAAAAAIAAAACAAABAAABAAAAAAACAAAAAAEAAAAAAAABAAEAAAEAAO8AFCwAAAAADwAAAQIAS6MAAACkAAEAAAAAQG8CAgC8AAAWAwAAAJ8AAwKkAQUAAABAQE0BASQGAAAATQEBJAYAAACkAggAAABwQE0DAe8JAAAAnwICAqQDCAAAAHBATQQBMwoAAABNBAQFCwAAAJ8DAgKkBAgAAABwQE0FATMKAAAATQUF3AwAAACfBAICpAUIAAAAcEBNBgHsDQAAAE0GBnIOAAAAnwUCAv8GAgAAAAAA4gcRAP8IAAAAAAAAnj0IBQcAAABSCggAUgsHAKQJEwAAACBBnwkDAcAJFAASAAgAMAkGvxUAAADACRYAEgAIADAJBkkXAAAAwAkYABIACAASAAUAEgAGABIABAASAAMAbwwZAKQNHQAcbKDBTQ0N7B4AAABSDgkAvAoAbx8AAACfCgUBggYCACADDwQAAABAAxADEQMSBAAAQEADEwMUBAAAcEADFQMWAxcDGAMZAxoDGwMcCAEPEAAAAAMdBAAAIEEGAAMBBgEDAgYCAx4DHwMgAyEEHGygwQMiAyMDAAECAQABGAAGAAAAAAACAAAAAAABAAAAAAEAAAAAAAABAAAAAAAAAQAAAAAAAAIABQMAAQAAAAAAAAUAAAAHAAAABwAAAAAAGgEAAAAB/QAABgEAAAAAAxlNt+PrxpiMckYcAObUO/BpVaCXK4nd4g==

-- https://lua.expert/
local RunService = game:GetService("RunService")
local v1 = script.Parent.Parent

require(v1.Types)

local lerpType = require(v1.Animation.lerpType)
local getTweenRatio = require(v1.Animation.getTweenRatio)
local updateAll = require(v1.Dependencies.updateAll)
local t = {}
local t2 = {}

setmetatable(t2, {
	__mode = "k"
})
function t.add(p1) --[[ add | Line: 29 | Upvalues: t2 (copy) ]]
	t2[p1] = true
end
function t.remove(p1) --[[ remove | Line: 36 | Upvalues: t2 (copy) ]]
	t2[p1] = nil
end

local function updateAllTweens() --[[ updateAllTweens | Line: 43 | Upvalues: t2 (copy), updateAll (copy), t (copy), getTweenRatio (copy), lerpType (copy) ]]
	local v1 = os.clock()

	for k in pairs(t2) do
		local v2 = v1 - k._currentTweenStartTime

		if k._currentTweenDuration < v2 then
			if k._currentTweenInfo.Reverses then
				k._currentValue = k._prevValue
			else
				k._currentValue = k._nextValue
			end

			k._currentlyAnimating = false
			updateAll(k)
			t.remove(k)

			continue
		end

		k._currentValue = lerpType(k._prevValue, k._nextValue, (getTweenRatio(k._currentTweenInfo, v2)))
		k._currentlyAnimating = true
		updateAll(k)
	end
end

RunService:BindToRenderStep("__FusionTweenScheduler", Enum.RenderPriority.First.Value, updateAllTweens)

return t