-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMNBE5hbWUKTG9hZGluZ19JRAxHZXRBdHRyaWJ1dGUFYWRkZWQHRGVzdHJveQlHZXRUYWdnZWQWR2V0SW5zdGFuY2VBZGRlZFNpZ25hbAdDb25uZWN0GEdldEluc3RhbmNlUmVtb3ZlZFNpZ25hbAZMaXN0ZW4EZ2FtZRFDb2xsZWN0aW9uU2VydmljZQpHZXRTZXJ2aWNlAAQEAQQAAAYDAAAFAQcZ+wEAAA4BBgBNAQC6AAAAAPsCAADxAQIAAgAAAIIAAQD7AQEADgEJAG8DAQC8AQASAgAAAJ8BAwIOAQMA+wIBAPEBAgACAAAAggABAPsBAgBSAgAAnwECAvsCAwBqAQIAggABAAMDAQMCAwMAFgQBGAAAAAAAAAAAAQABAAAAAQAAAAACAAABAAEXAAAAAAQBAwAABgMAAAUBBxz7AQAADgEGAE0BALoAAAAA+wIAAPEBAgACAAAAggABAPsBAQAOAQkAbwMBALwBABICAAAAnwEDAg4BAwD7AgEA8QECAAIAAACCAAEA+wICAIcBAgAOAQUA+wICAIcBAgC8AQFQAwAAAJ8BAgGCAAEABAMBAwIDAwMFACYAARgAAAAAAAAAAAEAAQAAAAEAAAAAAwAAAQAAAAACJwAAAAAPBQEAAAoHAAAFBQQDAwMPOP8FAAAAAAAA2QYAABIAAgASAAMAEgAEABIABQD7BwAAUgkBALwHBwUAAAAAnwcDBGQHEwAOAgUATQwLugEAAADxDAIAAgAAAGUADQAOAwgAbw4CALwMCxIDAAAAnwwDAg4MBwDxDAIAAwAAAGUABABSDAQAUg0LAJ8MAgJqDAULbgfs/wIAAAD7BwAAUgkBALwHB14EAAAAnwcDAlIJBgC8BwfHBQAAAJ8HAwH7BwAAUgkBALwHB9wGAAAAnwcDAtkJAQASAAIAEgADABIABQC8BwfHBQAAAJ8HAwGCAAEABwMGAwEDAgMDAwcDCAMJAgABEwoBGAAAAgAAAAAKAAAAAAD3AAAAAAABAQAAAAEAAAACAAABAwAEAAAAAAAAAAACAAAAAAAAAAAAAAALFAAAAAAEAAABAgAOowAAAP8AAQAAAAAApAEBAAAAAEBvAwIAvAEBFgMAAACfAQMCwAIEABIAAQAwAgCnBQAAAIIAAgAGAwsEAAAAQAMMAw0GAgMKAQIBAAEYAAQAAwAAAAAACwAAACEBAAAAAAPWyVEnK7mT4kD5RYifxlfDptFGU+QNOyY=

-- https://lua.expert/
local t = {}
local CollectionService = game:GetService("CollectionService")

function t.Listen(p1, p2, p3, p4, p5) --[[ Listen | Line: 19 | Upvalues: CollectionService (copy) ]]
	local t = {}

	local function added(p1) --[[ added | Line: 22 | Upvalues: p3 (copy), p4 (copy), p5 (copy), t (copy) ]]
		if p3 and p1.Name ~= p3 then
			return
		end

		if p4 then
			local v1 = p1:GetAttribute("Loading_ID")

			if not v1 or v1 ~= p4 then
				return
			end
		end

		t[p1] = p5(p1)
	end

	for v1, v2 in CollectionService:GetTagged(p2) do
		if not p3 or v2.Name == p3 then
			if p4 then
				local v3 = v2:GetAttribute("Loading_ID")

				if v3 and v3 == p4 then
					t[v2] = p5(v2)
				end
			else
				t[v2] = p5(v2)
			end
		end
	end

	CollectionService:GetInstanceAddedSignal(p2):Connect(added)
	CollectionService:GetInstanceRemovedSignal(p2):Connect(function(p1) --[[ Line: 38 | Upvalues: p3 (copy), p4 (copy), t (copy) ]]
		if p3 and p1.Name ~= p3 then
			return
		end

		if p4 then
			local v1 = p1:GetAttribute("Loading_ID")

			if not v1 or v1 ~= p4 then
				return
			end
		end

		if not t[p1] then
			return
		end

		t[p1]:Destroy()
	end)
end

return t