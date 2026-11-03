-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:28
-- Luau version 6, Types version 3
-- Time taken: 0.003352 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	any_new_result1_upvr.Active = true
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink()
	task.spawn(function() -- Line 10
		--[[ Upvalues[4]:
			[1]: Util_upvr (copied, readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: any_GetLink_result1_upvr (readonly)
			[4]: arg1 (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		repeat
			local var7
			task.wait()
		until Util_upvr.Windows
		local GameEvents_upvr = Util_upvr.ReplicatedStorage:WaitForChild("GameEvents")
		if not any_new_result1_upvr.Active then
		else
			local var9_upvw
			var7 = any_new_result1_upvr
			var7.ClickAccept = arg1.Container.Polar.Confirm.MouseButton1Down:Connect(function() -- Line 21
				--[[ Upvalues[5]:
					[1]: Util_upvr (copied, readonly)
					[2]: var9_upvw (read and write)
					[3]: GameEvents_upvr (readonly)
					[4]: any_GetLink_result1_upvr (copied, readonly)
					[5]: arg1 (copied, readonly)
				]]
				-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
				local var12
				if var12 then
					var12 = GameEvents_upvr:GetAttribute("GettingPlayers")
					var9_upvw = var12
					local function INLINED_2() -- Internal function, doesn't exist in bytecode
						var12 = false
						return 0 < any_GetLink_result1_upvr.Rebirth
					end
					if any_GetLink_result1_upvr.Zones.City or INLINED_2() then
						var12 = GameEvents_upvr:GetAttribute("GettingPlayers")
					end
					if not var12 or var9_upvw == var12 then
					end
					arg1.Visible = false
				end
			end)
			var7 = any_new_result1_upvr
			var7.ClickIgnore = arg1.Container.Polar.Ignore.MouseButton1Down:Connect(function() -- Line 27
				--[[ Upvalues[4]:
					[1]: var9_upvw (read and write)
					[2]: GameEvents_upvr (readonly)
					[3]: any_GetLink_result1_upvr (copied, readonly)
					[4]: arg1 (copied, readonly)
				]]
				-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
				var9_upvw = GameEvents_upvr:GetAttribute("GettingPlayers")
				local var14
				local function INLINED_3() -- Internal function, doesn't exist in bytecode
					var14 = false
					return 0 < any_GetLink_result1_upvr.Rebirth
				end
				if any_GetLink_result1_upvr.Zones.City or INLINED_3() then
					var14 = GameEvents_upvr:GetAttribute("GettingPlayers")
				end
				if not var14 or var9_upvw == var14 then
				end
				arg1.Visible = false
			end)
			var7 = any_new_result1_upvr
			var7.AttributeChanged = GameEvents_upvr:GetAttributeChangedSignal("GettingPlayers"):Connect(function() -- Line 16, Named "Update"
				--[[ Upvalues[4]:
					[1]: any_GetLink_result1_upvr (copied, readonly)
					[2]: GameEvents_upvr (readonly)
					[3]: arg1 (copied, readonly)
					[4]: var9_upvw (read and write)
				]]
				-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
				local var10
				local function INLINED() -- Internal function, doesn't exist in bytecode
					var10 = false
					return 0 < any_GetLink_result1_upvr.Rebirth
				end
				if any_GetLink_result1_upvr.Zones.City or INLINED() then
					var10 = GameEvents_upvr:GetAttribute("GettingPlayers")
				end
				if not var10 or var9_upvw == var10 then
				end
				arg1.Visible = false
			end)
			local function INLINED_4() -- Internal function, doesn't exist in bytecode
				var7 = false
				return 0 < any_GetLink_result1_upvr.Rebirth
			end
			if any_GetLink_result1_upvr.Zones.City or INLINED_4() then
				var7 = GameEvents_upvr:GetAttribute("GettingPlayers")
			end
			if not var7 or var9_upvw == var7 then
			end
			arg1.Visible = false
		end
	end)
	return any_new_result1_upvr
end
return module