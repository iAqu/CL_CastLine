-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMkDHNldG1ldGF0YWJsZQlDb25zdHJ1Y3QDbmV3Bl90cm92ZQVfaW5mbwlfY2FsbGJhY2sJQ29tcGxldGVkC0Vhc2luZ1N0eWxlD0Vhc2luZ0RpcmVjdGlvbghHZXRWYWx1ZQ1SZW5kZXJTdGVwcGVkBFdhaXQEdGljawRUaW1lBlJlc3VsdARGaXJlBXBjYWxsBkZhaWxlZAVlcnJvcgR0YXNrBXNwYXduA0FkZARQbGF5BUNsZWFuBkNhbmNlbAdEZXN0cm95BGdhbWURUmVwbGljYXRlZFN0b3JhZ2UKR2V0U2VydmljZQpSdW5TZXJ2aWNlDFR3ZWVuU2VydmljZQhQYWNrYWdlcwdyZXF1aXJlBVRyb3ZlBlNpZ25hbAdfX2luZGV4AAkHAgEAAAcEAAAFAgcFDv8DAAAAAAAA+wQAAJ49AwMEAAAApAIBAAAAAECfAgMCUgUAAFIGAQC8AwI+AgAAAJ8DBAGCAgIAAwMBBAAAAEADAgAMAwEYAAAAAAAAAAABAAAAAAINAAAAAAQDAgAACAUAAAUDBAcFEfsDAABNAwPvAAAAAJ8DAQIwAwDFAQAAADABACgCAAAAMAIAbAMAAAD7AwEATQMD7wAAAACfAwECMAMAGAQAAACCAAEABQMDAwQDBQMGAwcAGAIBGAAAAAAAAAEAAQACAAAAAAABGQAAAAAHAgEAAAcEAAAFAgQCDvsCAABSBAEATQUAKAAAAABNBQVpAQAAAE0GACgAAAAATQYGLwIAAAC8AgLzAwAAAJ8CBQCCAgAABAMFAwgDCQMKACAKARgAAAAAAAAAAAAAAAAAACEAAAAABgADAAAAPfsAAABNAABsAAAAAPsBAACMAwAAvAEB8wEAAACfAQMAnwAAAfsAAQBNAADPAgAAALwAAPcDAAAAnwACAaQBBQAAAEBAnwEBAvsCAgAmAAEC+wIAAE0CAigGAAAATQICSgcAAADsAQACjAIBAH0CCwABAAAA+wIAAE0CAmwAAAAA+wMAAIwFAQC8AwPzAQAAAJ8DAwCfAgABZQAKAPsCAABNAgJsAAAAAPsDAABSBQEAvAMD8wEAAACfAwMAnwIAAUgA2P/7AAAATQAAGAgAAAD7AgAATQICDgkAAABNAgIYCAAAALwAAN0KAAAAnwADAYIAAQALAwYDCgMLAwwDDQQAAEBAAwUDDgMHAw8DEAAoAAEYAAAAAAAAAAAAAwAAAAAAAgAAAAABAAAAAAACAAABAAAAAAAAAAABAgAAAAAAAAAA9g4AAAAAAAAAAAAAASkAAAAABwACAAAAHKQAAQAAAABAnwABAqQBAwAAACBA2QIAABICAAASAgEAEgAAAJ8BAgMrARAA+wMAAE0DAxgEAAAA+wUAAE0FBQ4FAAAATQUFrgYAAABSBgIAvAMD3QcAAACfAwQBpAMJAAAAgEBSBAIAnwMCAYIAAQAKAw0EAAAAQAMRBAAAIEADBwMPAxIDEAMTBAAAgEABAyUAARgAAAACAAAAAAAAFAEAAAAAAAAAAAAAAAEAAAACJgAAAAAFAQEAAAAMTQEAxQAAAACkAwMAAAgQgNkEAAASAAAAEgIAAJ8DAgC8AQFfBAAAAJ8BAAGCAAEABQMEAxQDFQQACBCAAxYBBCQXARgAAAAAAAAAAAAAABwlAAAAAAMBAAAAAAZNAQDFAAAAALwBAU8BAAAAnwECAYIAAQACAwQDGABDGQEYAAAAAAABRAAAAAADAQAAAAAGTQEAxQAAAAC8AQFQAQAAAJ8BAgGCAAEAAgMEAxoARxoBGAAAAAAAAUgAAAAACAAAAQIAPqMAAACkAAEAAAAAQG8CAgC8AAAWAwAAAJ8AAwKkAQEAAAAAQG8DBAC8AQEWAwAAAJ8BAwKkAgEAAAAAQG8EBQC8AgIWAwAAAJ8CAwJNAwDmBgAAAKQECAAAAHBATQUDmwkAAACfBAICpAUIAAAAcEBNBgMfCgAAAJ8FAgL/BgQAAAAAADAGBm4LAAAAwAcMABIABgAwBwbvDQAAAOIHEAAwBwYOEQAAAMAHEgASAAQAEgAFADAHBj4TAAAAwAcUABIAAgAwBwbzFQAAAMAHFgASAAEAMAcG7hcAAADABxgAMAcGoRkAAADABxoAMAcGUBsAAACCBgIAHAMbBAAAAEADHAMdAx4DHwMgAyEEAABwQAMiAyMDJAYAAwMDBwMSCAIODgAAAA8PAAAAAw8GAQMCBgIDCgYFAxcGBgMZBgcDGgYAAQIFBgcBAAEYAAAAAAAAAAEAAAAAAAEAAAAAAAIAAQAAAAABAAAAAAIAAQACAAAABwAABQAAAAAIAAAABAAAAB8AAAQAAAQBAAAAAAi/ORCdnUabzRunqHwbCvGEzyEH6Y39epw=

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)
local t = {}

t.__index = t
function t.new(p1, p2) --[[ new | Line: 12 | Upvalues: t (copy) ]]
	local v2 = setmetatable({}, t)

	v2:Construct(p1, p2)

	return v2
end
t.Result = {
	Completed = "Completed",
	Failed = "Failed"
}
function t.Construct(p1, p2, p3) --[[ Construct | Line: 24 | Upvalues: Trove (copy), Signal (copy) ]]
	p1._trove = Trove.new()
	p1._info = p2
	p1._callback = p3
	p1.Completed = Signal.new()
end
function t.GetValue(p1, p2) --[[ GetValue | Line: 32 | Upvalues: TweenService (copy) ]]
	return TweenService:GetValue(p2, p1._info.EasingStyle, p1._info.EasingDirection)
end
function t.Play(p1) --[[ Play | Line: 36 | Upvalues: RunService (copy) ]]
	p1._trove:Add(task.spawn(function() --[[ Line: 37 | Upvalues: p1 (copy), RunService (ref) ]]
		local v1 = tick()
		local ok, result = pcall(function() --[[ Line: 40 | Upvalues: p1 (ref), RunService (ref), v1 (copy) ]]
			p1._callback(p1:GetValue(0))

			while true do
				RunService.RenderStepped:Wait()

				local v12 = (tick() - v1) / p1._info.Time

				if v12 >= 1 then
					break
				end

				p1._callback(p1:GetValue(v12))
			end

			p1._callback(p1:GetValue(1))
			p1.Completed:Fire(p1.Result.Completed)
		end)

		if ok then
			return
		end

		p1.Completed:Fire(p1.Result.Failed, result)
		error(result)
	end))
end
function t.Cancel(p1) --[[ Cancel | Line: 67 ]]
	p1._trove:Clean()
end
function t.Destroy(p1) --[[ Destroy | Line: 71 ]]
	p1._trove:Destroy()
end

return t