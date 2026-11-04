-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:31
-- Luau version 6, Types version 3
-- Time taken: 0.001769 seconds

local module = {}
local tbl_upvr_2 = {}
local _ = {"rbxassetid://75733197878452", "rbxassetid://114692362876648", "rbxassetid://130844097192240", "rbxassetid://79070659850421", "rbxassetid://130239227193131", "rbxassetid://116736468683065", "rbxassetid://98445433008664", "rbxassetid://76147145917917", "rbxassetid://133736869164035", "rbxassetid://104496382642733", "rbxassetid://115108260047123", "rbxassetid://123282378961038", "rbxassetid://81719617256277"}
function module.StopSequence(arg1, arg2) -- Line 24
	--[[ Upvalues[1]:
		[1]: tbl_upvr_2 (readonly)
	]]
	if tbl_upvr_2[arg2] then
		tbl_upvr_2[arg2].connection:Disconnect()
		tbl_upvr_2[arg2] = nil
	end
end
local tbl_upvr = {}
function module.PreloadImages(arg1, arg2) -- Line 32
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if not arg2 or #arg2 == 0 then
		warn("Invalid image sequence passed to PreloadImages.")
	else
		local tbl = {}
		for _, v in ipairs(arg2) do
			if not tbl_upvr[v] then
				table.insert(tbl, v)
			end
		end
		if 0 < #tbl then
			game:GetService("ContentProvider"):PreloadAsync(tbl)
			for _, v_2 in ipairs(tbl) do
				tbl_upvr[v_2] = true
			end
		end
	end
end
function module.PlaySequence(arg1, arg2, arg3, arg4, arg5) -- Line 58
	--[[ Upvalues[1]:
		[1]: tbl_upvr_2 (readonly)
	]]
	if not arg2 or not arg3 or #arg3 == 0 or not arg4 then
		warn("Invalid arguments passed to PlaySequence.")
	else
		arg1:StopSequence(arg2)
		local var17_upvw = 0
		local var18_upvw = 1
		tbl_upvr_2[arg2] = {
			connection = game:GetService("RunService").Heartbeat:Connect(function(arg1_2) -- Line 74
				--[[ Upvalues[7]:
					[1]: var17_upvw (read and write)
					[2]: arg4 (readonly)
					[3]: arg2 (readonly)
					[4]: arg3 (readonly)
					[5]: var18_upvw (read and write)
					[6]: arg5 (readonly)
					[7]: arg1 (readonly)
				]]
				var17_upvw += arg1_2
				if arg4 <= var17_upvw then
					var17_upvw -= arg4
					arg2.Image = arg3[var18_upvw]
					var18_upvw += 1
					if #arg3 < var18_upvw then
						if arg5 then
							var18_upvw = 1
						else
							arg1:StopSequence(arg2)
						end
					end
				end
			end);
		}
	end
end
return module