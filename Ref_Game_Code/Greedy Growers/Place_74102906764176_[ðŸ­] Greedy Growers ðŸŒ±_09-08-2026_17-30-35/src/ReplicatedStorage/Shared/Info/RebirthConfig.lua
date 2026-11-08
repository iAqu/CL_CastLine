-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMXBUNvc3RzB0dldENvc3QLRmVydGlsaXplcnMKcmViaXJ0aFJlcQVsZXZlbARjb3N0DWZlcnRpbGl6ZXJLZXkKZmVydGlsaXplcgdHZXROZXh0BHR5cGUFdGFibGUIdG9udW1iZXIEbWF0aAVmbG9vcghNYXhMZXZlbA5BcHBseU92ZXJyaWRlcwRnYW1lEVJlcGxpY2F0ZWRTdG9yYWdlCkdldFNlcnZpY2UHcmVxdWlyZQZTaGFyZWQESW5mbxBGZXJ0aWxpemVyQ29uZmlnAAQDAQEAAAYDAAAFAQIF+wIAAE0CAsgAAAAAhwECAIIBAgABAwEAGgIBGAAAAAAAGwAAAAALAQIAAAYDAAAFAQIkkAIAAZUBAgD7AwAATQMDyAIAAACHAgMBKwICAMYDAACCAwIAxgMAAMYEAAD7BQEATQUF1wMAAADGBgAAxgcAAGQFBwBNCgmOBAAAAJoKBAABAAAAUgMIAFIECQBlAAIAbgX4/wIAAADiBQkAMAEFjQUAAAAwAgVDBgAAADADBSYHAAAAMAQF3AgAAACCBQIACgIAAAAAAADwPwIAAAAAAAAAAAMBAwMDBAMFAwYDBwMIBQQFBgcIACAJARgAAAEAAAABAAACAAEAAAAAAAEAAAABAAH9AAcAAAAAAAAAAAAhAAAAAAsBAQAAADa7KAADUgIAAKQBAQAAAABAnwECAvABAgACAAAAggABAFIBAADGAgAAxgMAAGQBGAC7PgQDUgcEAKQGBAAAADBAnwYCArs+BQNSCAUApAcEAAAAMECfBwICDgYNAA4HDACMCAAAfQgKAAcAAAD7CAAATQgIyAUAAAC7DAYDUgoGAKQJCAAAHGCAnwkCAmoHCAluAef/AgAAAIwBAAD7AgAATQICyAUAAADGAwAAxgQAAGQCAwBgAQIABQAAAFIBBQBuAvz/AQAAAPsCAAAwAQLKCQAAAIIAAQAKAwoEAAAAQAMLAwwEAAAwQAMBAw0DDgQAHGCAAw8AMRABGAAAAAAAAAAAAQAAAAEAAAAAAQAAAAABAAAAAAEAAAAAAAAAAPwACAEAAAAAAAEAAP8AAwAAATIAAAAABQAAAQIAMaMAAACkAAEAAAAAQG8CAgC8AAAWAwAAAJ8AAwKkAQUAAABAQE0CABIGAAAATQICegcAAABNAgJwCAAAAJ8BAgL/AgQAAAAAAP8DAAAFAAAAjAT0AfYEAwBvBAkA9gQDAW8ECgD2BAMCbwQLAPYEAwNvBAwA9gQDBDADAsgNAAAAjAMFADADAsoOAAAAwAMPABIAAgAwAwL/EAAAAMADEQASAAIAEgABADADAlESAAAAwAMTABIAAgAwAwKGFAAAAIICAgAVAxEEAAAAQAMSAxMDFAQAAEBAAxUDFgMXAgAAAACAhA5BAgAAAACE15dBAgAAACBfoBJCAgAAkB7EvNZCAwEDDwYAAwIGAQMJBgIDEAMAAQIBAAEYAAkAAAAAAAEAAAAAAAAAAAIAAwABAAEAAQABAAEA+wAIAAACAAAABgAAAAARAAAAEQEAAAAAA/+eLuzFq+CiGCp993TuOe6PhjmYzVpE7Q==

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FertilizerConfig = require(ReplicatedStorage.Shared.Info.FertilizerConfig)
local t = {
	Costs = {
		500,
		250000,
		100000000,
		20000000000,
		100000000000000
	},
	MaxLevel = 5
}

function t.GetCost(p1) --[[ GetCost | Line: 26 | Upvalues: t (copy) ]]
	return t.Costs[p1]
end
function t.GetNext(p1) --[[ GetNext | Line: 32 | Upvalues: t (copy), FertilizerConfig (copy) ]]
	local v1 = (p1 or 0) + 1
	local v2 = t.Costs[v1]

	if not v2 then
		return nil
	end

	local v3 = nil
	local v4 = nil

	for v5, v6 in FertilizerConfig.Fertilizers do
		if v6.rebirthReq == v1 then
			v3 = v5
			v4 = v6

			break
		end
	end

	return {
		level = v1,
		cost = v2,
		fertilizerKey = v3,
		fertilizer = v4
	}
end
function t.ApplyOverrides(p1) --[[ ApplyOverrides | Line: 49 | Upvalues: t (copy) ]]
	if type(p1) ~= "table" then
		return
	end

	for v1, v2 in p1 do
		local v3 = tonumber(v1)
		local v4 = tonumber(v2)

		if v3 and (v4 and v4 >= 0) then
			t.Costs[math.floor(v3)] = v4
		end
	end

	local v5 = 0

	for v6 in t.Costs do
		if v5 < v6 then
			v5 = v6
		end
	end

	t.MaxLevel = v5
end

return t