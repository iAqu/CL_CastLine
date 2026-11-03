-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:30
-- Luau version 6, Types version 3
-- Time taken: 0.037604 seconds

local abs_upvr = math.abs
local floor_upvr = math.floor
local GetComponents_upvr = CFrame.new().GetComponents
return {
	new3D = function(arg1) -- Line 11, Named "new3D"
		--[[ Upvalues[3]:
			[1]: floor_upvr (readonly)
			[2]: abs_upvr (readonly)
			[3]: GetComponents_upvr (readonly)
		]]
		local module_upvr = {}
		local tbl_8_upvw = {}
		local tbl_6_upvw = {}
		local var8_upvr = arg1.GridSize or 50
		local var9_upvw = (arg1.SpanY or 1500) / var8_upvr
		local var10_upvw = (arg1.SpanZ or 5000) / var8_upvr
		local var11_upvr = var10_upvw * 2
		local var12_upvr = (arg1.SpanX or 5000) / var8_upvr + var9_upvw * 2
		local function GetHash(arg1_2, arg2, arg3) -- Line 33
			--[[ Upvalues[6]:
				[1]: var8_upvr (readonly)
				[2]: floor_upvr (copied, readonly)
				[3]: var12_upvr (readonly)
				[4]: var9_upvw (read and write)
				[5]: var11_upvr (readonly)
				[6]: var10_upvw (read and write)
			]]
			return floor_upvr(arg1_2 / var8_upvr) + var12_upvr * (floor_upvr(arg2 / var8_upvr) + var9_upvw + var11_upvr * (floor_upvr(arg3 / var8_upvr) + var10_upvw))
		end
		local function GetHashWOSize(arg1_3, arg2, arg3) -- Line 37
			--[[ Upvalues[4]:
				[1]: var12_upvr (readonly)
				[2]: var9_upvw (read and write)
				[3]: var11_upvr (readonly)
				[4]: var10_upvw (read and write)
			]]
			return arg1_3 - arg1_3 % 1 + var12_upvr * (arg2 - arg2 % 1 + var9_upvw + var11_upvr * (arg3 - arg3 % 1 + var10_upvw))
		end
		module_upvr.HG = GetHash
		local function CheckHash(arg1_4, arg2, arg3) -- Line 44
			--[[ Upvalues[8]:
				[1]: var8_upvr (readonly)
				[2]: floor_upvr (copied, readonly)
				[3]: var12_upvr (readonly)
				[4]: var9_upvw (read and write)
				[5]: var11_upvr (readonly)
				[6]: var10_upvw (read and write)
				[7]: tbl_8_upvw (read and write)
				[8]: tbl_6_upvw (read and write)
			]]
			local var13 = floor_upvr(arg1_4 / var8_upvr) + var12_upvr * (floor_upvr(arg2 / var8_upvr) + var9_upvw + var11_upvr * (floor_upvr(arg3 / var8_upvr) + var10_upvw))
			local var14 = not tbl_8_upvw[var13]
			if var14 then
				var14 = not tbl_6_upvw[var13]
			end
			return var14
		end
		local function CheckHash(arg1_5, arg2, arg3) -- Line 49
			--[[ Upvalues[8]:
				[1]: var8_upvr (readonly)
				[2]: floor_upvr (copied, readonly)
				[3]: var12_upvr (readonly)
				[4]: var9_upvw (read and write)
				[5]: var11_upvr (readonly)
				[6]: var10_upvw (read and write)
				[7]: tbl_8_upvw (read and write)
				[8]: tbl_6_upvw (read and write)
			]]
			local var15 = floor_upvr(arg1_5 / var8_upvr) + var12_upvr * (floor_upvr(arg2 / var8_upvr) + var9_upvw + var11_upvr * (floor_upvr(arg3 / var8_upvr) + var10_upvw))
			local var16 = not tbl_8_upvw[var15]
			if var16 then
				var16 = not tbl_6_upvw[var15]
			end
			return var16
		end
		module_upvr.CheckHash = CheckHash
		local function CheckHashWOSize(arg1_6, arg2, arg3) -- Line 54
			--[[ Upvalues[6]:
				[1]: var12_upvr (readonly)
				[2]: var9_upvw (read and write)
				[3]: var11_upvr (readonly)
				[4]: var10_upvw (read and write)
				[5]: tbl_8_upvw (read and write)
				[6]: tbl_6_upvw (read and write)
			]]
			local var17 = arg1_6 - arg1_6 % 1 + var12_upvr * (arg2 - arg2 % 1 + var9_upvw + var11_upvr * (arg3 - arg3 % 1 + var10_upvw))
			local var18 = not tbl_8_upvw[var17]
			if var18 then
				var18 = not tbl_6_upvw[var17]
			end
			return var18
		end
		local function StaticHashClear() -- Line 60
			--[[ Upvalues[1]:
				[1]: tbl_8_upvw (read and write)
			]]
			tbl_8_upvw = {}
		end
		module_upvr.StaticHashClear = StaticHashClear
		local function DynamicHashClear() -- Line 64
			--[[ Upvalues[1]:
				[1]: tbl_6_upvw (read and write)
			]]
			tbl_6_upvw = {}
		end
		module_upvr.DynamicHashClear = DynamicHashClear
		local function Bresenham3D_upvr(arg1_7, arg2, arg3, arg4, arg5, arg6) -- Line 68, Named "Bresenham3D"
			--[[ Upvalues[7]:
				[1]: var12_upvr (readonly)
				[2]: var9_upvw (read and write)
				[3]: var11_upvr (readonly)
				[4]: var10_upvw (read and write)
				[5]: tbl_8_upvw (read and write)
				[6]: tbl_6_upvw (read and write)
				[7]: abs_upvr (copied, readonly)
			]]
			-- KONSTANTERROR: Failed to generate AST for function `Bresenham3D`:
assertion failed!
Traceback:
K
K
K
K
K
K
K
K
K
K
K
K
K
K
K
K
K
K
K
K
K
K
K
K
K

		end
		local function LineCheck(arg1_8, arg2) -- Line 141
			--[[ Upvalues[2]:
				[1]: var8_upvr (readonly)
				[2]: Bresenham3D_upvr (readonly)
			]]
			local x_3 = arg1_8.x
			local y_4 = arg1_8.y
			local z_5 = arg1_8.z
			local var62 = x_3 / var8_upvr
			local var63 = y_4 / var8_upvr
			local var64 = z_5 / var8_upvr
			local var65 = (x_3 + arg2.x) / var8_upvr
			local var66 = (y_4 + arg2.y) / var8_upvr
			local var67 = (z_5 + arg2.z) / var8_upvr
			return Bresenham3D_upvr(var62 - var62 % 1, var63 - var63 % 1, var64 - var64 % 1, var65 - var65 % 1, var66 - var66 % 1, var67 - var67 % 1)
		end
		module_upvr.LineCheck = LineCheck
		local function AABB(arg1_9) -- Line 152
			--[[ Upvalues[2]:
				[1]: GetComponents_upvr (copied, readonly)
				[2]: abs_upvr (copied, readonly)
			]]
			local Size_3 = arg1_9.Size
			local x_6 = Size_3.x
			local y_8 = Size_3.y
			local z_2 = Size_3.z
			local var3_result1_5, var3_result2, var3_result3_5, var3_result4_5, var3_result5_4, var3_result6_6, var3_result7_2, var3_result8_2, GetComponents_upvr_result9, var3_result10_3, var3_result11_3, GetComponents_upvr_result12 = GetComponents_upvr(arg1_9.CFrame)
			local var84 = 0.5 * (abs_upvr(var3_result4_5) * x_6 + abs_upvr(var3_result5_4) * y_8 + abs_upvr(var3_result6_6) * z_2)
			local var85 = 0.5 * (abs_upvr(var3_result7_2) * x_6 + abs_upvr(var3_result8_2) * y_8 + abs_upvr(GetComponents_upvr_result9) * z_2)
			local var86 = 0.5 * (abs_upvr(var3_result10_3) * x_6 + abs_upvr(var3_result11_3) * y_8 + abs_upvr(GetComponents_upvr_result12) * z_2)
			return var3_result1_5 - var84, var3_result2 - var85, var3_result3_5 - var86, var3_result1_5 + var84, var3_result2 + var85, var3_result3_5 + var86
		end
		local function AABB2(arg1_10, arg2) -- Line 164
			--[[ Upvalues[2]:
				[1]: GetComponents_upvr (copied, readonly)
				[2]: abs_upvr (copied, readonly)
			]]
			local x_8 = arg2.x
			local y_3 = arg2.y
			local z_6 = arg2.z
			local var3_result1_4, var3_result2_5, var3_result3_4, var3_result4_6, var3_result5_2, var3_result6_5, GetComponents_upvr_result7, var3_result8, var3_result9_4, var3_result10_2, var3_result11_4, var3_result12_3 = GetComponents_upvr(arg1_10)
			local var102 = 0.5 * (abs_upvr(var3_result4_6) * x_8 + abs_upvr(var3_result5_2) * y_3 + abs_upvr(var3_result6_5) * z_6)
			local var103 = 0.5 * (abs_upvr(GetComponents_upvr_result7) * x_8 + abs_upvr(var3_result8) * y_3 + abs_upvr(var3_result9_4) * z_6)
			local var104 = 0.5 * (abs_upvr(var3_result10_2) * x_8 + abs_upvr(var3_result11_4) * y_3 + abs_upvr(var3_result12_3) * z_6)
			return var3_result1_4 - var102, var3_result2_5 - var103, var3_result3_4 - var104, var3_result1_4 + var102, var3_result2_5 + var103, var3_result3_4 + var104
		end
		local tick_result1_upvw_3 = tick()
		local function StaticHashAdd(arg1_11) -- Line 178
			--[[ Upvalues[9]:
				[1]: AABB (readonly)
				[2]: var8_upvr (readonly)
				[3]: tbl_8_upvw (read and write)
				[4]: floor_upvr (copied, readonly)
				[5]: var12_upvr (readonly)
				[6]: var9_upvw (read and write)
				[7]: var11_upvr (readonly)
				[8]: var10_upvw (read and write)
				[9]: tick_result1_upvw_3 (read and write)
			]]
			local AABB_result1_3, AABB_result2_2, AABB_result3_5, AABB_result4_2, AABB_result5, AABB_result6 = AABB(arg1_11)
			for _ = AABB_result1_3 - AABB_result1_3 % 1, AABB_result4_2, var8_upvr do
				for i_2 = AABB_result2_2 - AABB_result2_2 % 1, AABB_result5, var8_upvr do
					for i_3 = AABB_result3_5 - AABB_result3_5 % 1, AABB_result6, var8_upvr do
						tbl_8_upvw[floor_upvr(_ / var8_upvr) + var12_upvr * (floor_upvr(i_2 / var8_upvr) + var9_upvw + var11_upvr * (floor_upvr(i_3 / var8_upvr) + var10_upvw))] = true
					end
					if 0.8 < tick() - tick_result1_upvw_3 then
						task.wait()
						tick_result1_upvw_3 = tick()
					end
				end
			end
		end
		module_upvr.StaticHashAdd = StaticHashAdd
		local function DynamicHashAdd(arg1_12) -- Line 195
			--[[ Upvalues[9]:
				[1]: AABB (readonly)
				[2]: var8_upvr (readonly)
				[3]: tbl_6_upvw (read and write)
				[4]: floor_upvr (copied, readonly)
				[5]: var12_upvr (readonly)
				[6]: var9_upvw (read and write)
				[7]: var11_upvr (readonly)
				[8]: var10_upvw (read and write)
				[9]: tick_result1_upvw_3 (read and write)
			]]
			local AABB_result1, AABB_result2, AABB_result3_3, AABB_result4_4, AABB_result5_2, AABB_result6_4 = AABB(arg1_12)
			for _ = AABB_result1 - AABB_result1 % 1, AABB_result4_4, var8_upvr do
				for i_5 = AABB_result2 - AABB_result2 % 1, AABB_result5_2, var8_upvr do
					for i_6 = AABB_result3_3 - AABB_result3_3 % 1, AABB_result6_4, var8_upvr do
						tbl_6_upvw[floor_upvr(_ / var8_upvr) + var12_upvr * (floor_upvr(i_5 / var8_upvr) + var9_upvw + var11_upvr * (floor_upvr(i_6 / var8_upvr) + var10_upvw))] = true
					end
					if 0.8 < tick() - tick_result1_upvw_3 then
						task.wait()
						tick_result1_upvw_3 = tick()
					end
				end
			end
		end
		module_upvr.DynamicHashAdd = DynamicHashAdd
		local function AddModel(arg1_13, arg2) -- Line 212
			--[[ Upvalues[1]:
				[1]: module_upvr (readonly)
			]]
			if arg2 then
				if arg1_13:IsA("BasePart") then
					module_upvr.StaticHashAdd(arg1_13)
				end
				for _, v in pairs(arg1_13:GetDescendants()) do
					if v:IsA("BasePart") then
						module_upvr.StaticHashAdd(v)
					end
				end
			else
				if arg1_13:IsA("BasePart") then
					module_upvr.DynamicHashAdd(arg1_13)
				end
				for _, v_15 in pairs(arg1_13:GetDescendants()) do
					if v_15:IsA("BasePart") then
						module_upvr.DynamicHashAdd(v_15)
					end
				end
			end
		end
		module_upvr.AddModel = AddModel
		return module_upvr
	end;
	new2D = function(arg1) -- Line 237, Named "new2D"
		--[[ Upvalues[3]:
			[1]: floor_upvr (readonly)
			[2]: GetComponents_upvr (readonly)
			[3]: abs_upvr (readonly)
		]]
		local module_upvr_2 = {}
		local tbl_7_upvw = {}
		local tbl_2_upvw = {}
		local var137_upvr = arg1.GridSize or 50
		local var138_upvw = (arg1.SpanY or 5000) / var137_upvr
		local var139_upvr = (arg1.SpanX or 5000) / var137_upvr + var138_upvw * 2
		local function GetHash(arg1_14, arg2) -- Line 256
			--[[ Upvalues[4]:
				[1]: var137_upvr (readonly)
				[2]: floor_upvr (copied, readonly)
				[3]: var139_upvr (readonly)
				[4]: var138_upvw (read and write)
			]]
			return floor_upvr(arg1_14 / var137_upvr) + var139_upvr * (floor_upvr(arg2 / var137_upvr) + var138_upvw)
		end
		local function _(arg1_15, arg2) -- Line 260, Named "GetHashWOSize"
			--[[ Upvalues[2]:
				[1]: var139_upvr (readonly)
				[2]: var138_upvw (read and write)
			]]
			return arg1_15 - arg1_15 % 1 + var139_upvr * (arg2 - arg2 % 1 + var138_upvw)
		end
		module_upvr_2.HG = GetHash
		local function CheckHash(arg1_16, arg2) -- Line 267
			--[[ Upvalues[6]:
				[1]: var137_upvr (readonly)
				[2]: floor_upvr (copied, readonly)
				[3]: var139_upvr (readonly)
				[4]: var138_upvw (read and write)
				[5]: tbl_7_upvw (read and write)
				[6]: tbl_2_upvw (read and write)
			]]
			local var140 = floor_upvr(arg1_16 / var137_upvr) + var139_upvr * (floor_upvr(arg2 / var137_upvr) + var138_upvw)
			local var141 = not tbl_7_upvw[var140]
			if var141 then
				var141 = not tbl_2_upvw[var140]
			end
			return var141
		end
		local function CheckHash(arg1_17, arg2) -- Line 272
			--[[ Upvalues[6]:
				[1]: var137_upvr (readonly)
				[2]: floor_upvr (copied, readonly)
				[3]: var139_upvr (readonly)
				[4]: var138_upvw (read and write)
				[5]: tbl_7_upvw (read and write)
				[6]: tbl_2_upvw (read and write)
			]]
			local var142 = floor_upvr(arg1_17 / var137_upvr) + var139_upvr * (floor_upvr(arg2 / var137_upvr) + var138_upvw)
			local var143 = not tbl_7_upvw[var142]
			if var143 then
				var143 = not tbl_2_upvw[var142]
			end
			return var143
		end
		module_upvr_2.CheckHash = CheckHash
		local function _(arg1_18, arg2) -- Line 277, Named "CheckHashWOSize"
			--[[ Upvalues[4]:
				[1]: var139_upvr (readonly)
				[2]: var138_upvw (read and write)
				[3]: tbl_7_upvw (read and write)
				[4]: tbl_2_upvw (read and write)
			]]
			local var144 = arg1_18 - arg1_18 % 1 + var139_upvr * (arg2 - arg2 % 1 + var138_upvw)
			local var145 = not tbl_7_upvw[var144]
			if var145 then
				var145 = not tbl_2_upvw[var144]
			end
			return var145
		end
		local function StaticHashClear() -- Line 283
			--[[ Upvalues[1]:
				[1]: tbl_7_upvw (read and write)
			]]
			tbl_7_upvw = {}
		end
		module_upvr_2.StaticHashClear = StaticHashClear
		function module_upvr_2.DynamicHashClear() -- Line 287
			--[[ Upvalues[1]:
				[1]: tbl_2_upvw (read and write)
			]]
			tbl_2_upvw = {}
		end
		local function LineCheck(arg1_19, arg2) -- Line 291
			--[[ Upvalues[1]:
				[1]: var137_upvr (readonly)
			]]
			local x_4 = arg1_19.x
			local y_6 = arg1_19.y
			local var148 = x_4 / var137_upvr
			local var149 = y_6 / var137_upvr
			local var150 = (x_4 + arg2.x) / var137_upvr
			local var151 = (y_6 + arg2.y) / var137_upvr
			return Bresenham2D(var148 - var148 % 1, var149 - var149 % 1, var150 - var150 % 1, var151 - var151 % 1)
		end
		module_upvr_2.LineCheck = LineCheck
		local function AABB(arg1_20) -- Line 302
			--[[ Upvalues[2]:
				[1]: GetComponents_upvr (copied, readonly)
				[2]: abs_upvr (copied, readonly)
			]]
			local Size = arg1_20.Size
			local x_2 = Size.x
			local y = Size.y
			local z = Size.z
			local var3_result1, GetComponents_upvr_result2, GetComponents_upvr_result3, var3_result4_4, GetComponents_upvr_result5, var3_result6, var3_result7_3, GetComponents_upvr_result8_3, var3_result9_2, var3_result10_5, var3_result11_6, var3_result12_2 = GetComponents_upvr(arg1_20.CFrame)
			local var168 = 0.5 * (abs_upvr(var3_result4_4) * x_2 + abs_upvr(GetComponents_upvr_result5) * y + abs_upvr(var3_result6) * z)
			local var169 = 0.5 * (abs_upvr(var3_result7_3) * x_2 + abs_upvr(GetComponents_upvr_result8_3) * y + abs_upvr(var3_result9_2) * z)
			local var170 = 0.5 * (abs_upvr(var3_result10_5) * x_2 + abs_upvr(var3_result11_6) * y + abs_upvr(var3_result12_2) * z)
			return var3_result1 - var168, GetComponents_upvr_result2 - var169, GetComponents_upvr_result3 - var170, var3_result1 + var168, GetComponents_upvr_result2 + var169, GetComponents_upvr_result3 + var170
		end
		local function AABB2(arg1_21, arg2) -- Line 314
			--[[ Upvalues[2]:
				[1]: GetComponents_upvr (copied, readonly)
				[2]: abs_upvr (copied, readonly)
			]]
			local x_5 = arg2.x
			local y_2 = arg2.y
			local z_3 = arg2.z
			local var3_result1_6, var3_result2_4, var3_result3_2, var3_result4_2, var3_result5_5, var3_result6_3, GetComponents_upvr_result7_2, GetComponents_upvr_result8, GetComponents_upvr_result9_2, var3_result10_6, var3_result11_5, GetComponents_upvr_result12_2 = GetComponents_upvr(arg1_21)
			local var186 = 0.5 * (abs_upvr(var3_result4_2) * x_5 + abs_upvr(var3_result5_5) * y_2 + abs_upvr(var3_result6_3) * z_3)
			local var187 = 0.5 * (abs_upvr(GetComponents_upvr_result7_2) * x_5 + abs_upvr(GetComponents_upvr_result8) * y_2 + abs_upvr(GetComponents_upvr_result9_2) * z_3)
			local var188 = 0.5 * (abs_upvr(var3_result10_6) * x_5 + abs_upvr(var3_result11_5) * y_2 + abs_upvr(GetComponents_upvr_result12_2) * z_3)
			return var3_result1_6 - var186, var3_result2_4 - var187, var3_result3_2 - var188, var3_result1_6 + var186, var3_result2_4 + var187, var3_result3_2 + var188
		end
		local tick_result1_upvw_2 = tick()
		local function StaticHashAdd(arg1_22) -- Line 328
			--[[ Upvalues[7]:
				[1]: AABB (readonly)
				[2]: var137_upvr (readonly)
				[3]: tbl_7_upvw (read and write)
				[4]: floor_upvr (copied, readonly)
				[5]: var139_upvr (readonly)
				[6]: var138_upvw (read and write)
				[7]: tick_result1_upvw_2 (read and write)
			]]
			local AABB_result1_4, _, AABB_result3_2, AABB_result4_3, _, AABB_result6_2 = AABB(arg1_22)
			for i_8 = AABB_result1_4 - AABB_result1_4 % 1, AABB_result4_3, var137_upvr do
				for i_9 = AABB_result3_2 - AABB_result3_2 % 1, AABB_result6_2, var137_upvr do
					tbl_7_upvw[floor_upvr(i_8 / var137_upvr) + var139_upvr * (floor_upvr(i_9 / var137_upvr) + var138_upvw)] = true
					if 0.8 < tick() - tick_result1_upvw_2 then
						task.wait()
						tick_result1_upvw_2 = tick()
					end
				end
			end
		end
		module_upvr_2.StaticHashAdd = StaticHashAdd
		function module_upvr_2.DynamicHashAdd(arg1_23) -- Line 342
			--[[ Upvalues[7]:
				[1]: AABB (readonly)
				[2]: var137_upvr (readonly)
				[3]: tbl_2_upvw (read and write)
				[4]: floor_upvr (copied, readonly)
				[5]: var139_upvr (readonly)
				[6]: var138_upvw (read and write)
				[7]: tick_result1_upvw_2 (read and write)
			]]
			local AABB_result1_2, _, AABB_result3_4, AABB_result4, _, AABB_result6_3 = AABB(arg1_23)
			for i_10 = AABB_result1_2 - AABB_result1_2 % 1, AABB_result4, var137_upvr do
				for i_11 = AABB_result3_4 - AABB_result3_4 % 1, AABB_result6_3, var137_upvr do
					tbl_2_upvw[floor_upvr(i_10 / var137_upvr) + var139_upvr * (floor_upvr(i_11 / var137_upvr) + var138_upvw)] = true
					if 0.8 < tick() - tick_result1_upvw_2 then
						task.wait()
						tick_result1_upvw_2 = tick()
					end
				end
			end
		end
		local function AddModel(arg1_24, arg2) -- Line 356
			--[[ Upvalues[1]:
				[1]: module_upvr_2 (readonly)
			]]
			if arg2 then
				if arg1_24:IsA("BasePart") then
					module_upvr_2.StaticHashAdd(arg1_24)
				end
				for _, v_2 in pairs(arg1_24:GetDescendants()) do
					if v_2:IsA("BasePart") then
						module_upvr_2.StaticHashAdd(v_2)
					end
				end
			else
				if arg1_24:IsA("BasePart") then
					module_upvr_2.DynamicHashAdd(arg1_24)
				end
				for _, v_16 in pairs(arg1_24:GetDescendants()) do
					if v_16:IsA("BasePart") then
						module_upvr_2.DynamicHashAdd(v_16)
					end
				end
			end
		end
		module_upvr_2.AddModel = AddModel
		return module_upvr_2
	end;
	new2DTabular = function(arg1) -- Line 381, Named "new2DTabular"
		--[[ Upvalues[3]:
			[1]: floor_upvr (readonly)
			[2]: GetComponents_upvr (readonly)
			[3]: abs_upvr (readonly)
		]]
		local module_3_upvr = {}
		local tbl_upvw = {}
		local var218_upvw = arg1.SpanY or 100000
		local var219_upvr = arg1.GridSize or 50
		module_3_upvr.HashTable = tbl_upvw
		local function _(arg1_26, arg2) -- Line 400, Named "GetHash2"
			--[[ Upvalues[3]:
				[1]: var219_upvr (readonly)
				[2]: floor_upvr (copied, readonly)
				[3]: var218_upvw (read and write)
			]]
			return floor_upvr(arg1_26 / var219_upvr), floor_upvr(arg2 / var219_upvr) * var218_upvw
		end
		function module_3_upvr.HG(arg1_25, arg2) -- Line 396, Named "GetHash"
			--[[ Upvalues[3]:
				[1]: var219_upvr (readonly)
				[2]: floor_upvr (copied, readonly)
				[3]: var218_upvw (read and write)
			]]
			return floor_upvr(arg1_25 / var219_upvr) + floor_upvr(arg2 / var219_upvr) * var218_upvw
		end
		function module_3_upvr.CheckHash(arg1_27, arg2) -- Line 407
			--[[ Upvalues[4]:
				[1]: tbl_upvw (read and write)
				[2]: var219_upvr (readonly)
				[3]: floor_upvr (copied, readonly)
				[4]: var218_upvw (read and write)
			]]
			return tbl_upvw[floor_upvr(arg1_27 / var219_upvr) + floor_upvr(arg2 / var219_upvr) * var218_upvw]
		end
		function module_3_upvr.StaticHashClear() -- Line 411
			--[[ Upvalues[1]:
				[1]: tbl_upvw (read and write)
			]]
			tbl_upvw = {}
		end
		function module_3_upvr.LineCheck(arg1_28, arg2) -- Line 415
			--[[ Upvalues[1]:
				[1]: var219_upvr (readonly)
			]]
			local x_7 = arg1_28.x
			local y_5 = arg1_28.y
			local var222 = x_7 / var219_upvr
			local var223 = y_5 / var219_upvr
			local var224 = (x_7 + arg2.x) / var219_upvr
			local var225 = (y_5 + arg2.y) / var219_upvr
			return Bresenham2D(var222 - var222 % 1, var223 - var223 % 1, var224 - var224 % 1, var225 - var225 % 1)
		end
		local function AABB_upvr(arg1_29) -- Line 426, Named "AABB"
			--[[ Upvalues[2]:
				[1]: GetComponents_upvr (copied, readonly)
				[2]: abs_upvr (copied, readonly)
			]]
			local Size_2 = arg1_29.Size
			local x_9 = Size_2.x
			local y_7 = Size_2.y
			local z_7 = Size_2.z
			local var3_result1_2, var3_result2_3, var3_result3_3, var3_result4_3, var3_result5, var3_result6_2, var3_result7_4, GetComponents_upvr_result8_2, var3_result9_3, var3_result10, var3_result11, var3_result12 = GetComponents_upvr(arg1_29.CFrame)
			local var242 = 0.5 * (abs_upvr(var3_result4_3) * x_9 + abs_upvr(var3_result5) * y_7 + abs_upvr(var3_result6_2) * z_7)
			local var243 = 0.5 * (abs_upvr(var3_result7_4) * x_9 + abs_upvr(GetComponents_upvr_result8_2) * y_7 + abs_upvr(var3_result9_3) * z_7)
			local var244 = 0.5 * (abs_upvr(var3_result10) * x_9 + abs_upvr(var3_result11) * y_7 + abs_upvr(var3_result12) * z_7)
			return var3_result1_2 - var242, var3_result2_3 - var243, var3_result3_3 - var244, var3_result1_2 + var242, var3_result2_3 + var243, var3_result3_3 + var244
		end
		local function _(arg1_30, arg2) -- Line 438, Named "AABB2"
			--[[ Upvalues[2]:
				[1]: GetComponents_upvr (copied, readonly)
				[2]: abs_upvr (copied, readonly)
			]]
			local x = arg2.x
			local y_9 = arg2.y
			local z_4 = arg2.z
			local var3_result1_3, var3_result2_2, var3_result3, var3_result4, var3_result5_3, var3_result6_4, var3_result7, var3_result8_3, var3_result9, var3_result10_4, var3_result11_2, var3_result12_4 = GetComponents_upvr(arg1_30)
			local var260 = 0.5 * (abs_upvr(var3_result4) * x + abs_upvr(var3_result5_3) * y_9 + abs_upvr(var3_result6_4) * z_4)
			local var261 = 0.5 * (abs_upvr(var3_result7) * x + abs_upvr(var3_result8_3) * y_9 + abs_upvr(var3_result9) * z_4)
			local var262 = 0.5 * (abs_upvr(var3_result10_4) * x + abs_upvr(var3_result11_2) * y_9 + abs_upvr(var3_result12_4) * z_4)
			return var3_result1_3 - var260, var3_result2_2 - var261, var3_result3 - var262, var3_result1_3 + var260, var3_result2_2 + var261, var3_result3 + var262
		end
		local tick_result1_upvw = tick()
		function module_3_upvr.ResetStik() -- Line 454
			--[[ Upvalues[1]:
				[1]: tick_result1_upvw (read and write)
			]]
			tick_result1_upvw = tick()
		end
		function module_3_upvr.StaticHashAdd(arg1_31) -- Line 458
			--[[ Upvalues[6]:
				[1]: AABB_upvr (readonly)
				[2]: var219_upvr (readonly)
				[3]: floor_upvr (copied, readonly)
				[4]: var218_upvw (read and write)
				[5]: tbl_upvw (read and write)
				[6]: tick_result1_upvw (read and write)
			]]
			local AABB_upvr_result1_6, _, AABB_upvr_result3, AABB_upvr_result4_6, _, AABB_upvr_result6_7 = AABB_upvr(arg1_31)
			for i_13 = AABB_upvr_result1_6 - AABB_upvr_result1_6 % 1, AABB_upvr_result4_6 + var219_upvr, var219_upvr do
				for i_14 = AABB_upvr_result3 - AABB_upvr_result3 % 1, AABB_upvr_result6_7 + var219_upvr, var219_upvr do
					local var272 = floor_upvr(i_13 / var219_upvr) + floor_upvr(i_14 / var219_upvr) * var218_upvw
					local var273 = tbl_upvw[var272]
					if var273 then
						table.insert(var273, arg1_31)
					else
						local tbl_5 = {}
						tbl_5[1] = arg1_31
						tbl_upvw[var272] = tbl_5
					end
					if 0.1 < tick() - tick_result1_upvw then
						task.wait()
						tick_result1_upvw = tick()
					end
				end
			end
		end
		function module_3_upvr.StaticHashAddValue(arg1_32, arg2) -- Line 480
			--[[ Upvalues[5]:
				[1]: AABB_upvr (readonly)
				[2]: var219_upvr (readonly)
				[3]: floor_upvr (copied, readonly)
				[4]: var218_upvw (read and write)
				[5]: tbl_upvw (read and write)
			]]
			local AABB_upvr_result1_4, _, AABB_upvr_result3_3, AABB_upvr_result4, _, AABB_upvr_result6_4 = AABB_upvr(arg1_32)
			for i_15 = AABB_upvr_result1_4 - AABB_upvr_result1_4 % 1, AABB_upvr_result4 + var219_upvr, var219_upvr do
				for i_16 = AABB_upvr_result3_3 - AABB_upvr_result3_3 % 1, AABB_upvr_result6_4 + var219_upvr, var219_upvr do
					local var283 = floor_upvr(i_15 / var219_upvr) + floor_upvr(i_16 / var219_upvr) * var218_upvw
					local var284 = tbl_upvw[var283]
					if var284 then
						table.insert(var284, arg2)
					else
						local tbl_3 = {}
						tbl_3[1] = arg2
						tbl_upvw[var283] = tbl_3
					end
				end
			end
		end
		function module_3_upvr.StaticHashRemoveValue(arg1_33, arg2) -- Line 498
			--[[ Upvalues[5]:
				[1]: AABB_upvr (readonly)
				[2]: var219_upvr (readonly)
				[3]: floor_upvr (copied, readonly)
				[4]: var218_upvw (read and write)
				[5]: tbl_upvw (read and write)
			]]
			local AABB_upvr_result1, _, AABB_upvr_result3_2, AABB_upvr_result4_5, _, AABB_upvr_result6_6 = AABB_upvr(arg1_33)
			for i_17 = AABB_upvr_result1 - AABB_upvr_result1 % 1, AABB_upvr_result4_5 + var219_upvr, var219_upvr do
				for i_18 = AABB_upvr_result3_2 - AABB_upvr_result3_2 % 1, AABB_upvr_result6_6 + var219_upvr, var219_upvr do
					local var304 = tbl_upvw[floor_upvr(i_17 / var219_upvr) + floor_upvr(i_18 / var219_upvr) * var218_upvw]
					if var304 then
						local table_find_result1_6 = table.find(var304, arg2)
						if table_find_result1_6 then
							table.remove(var304, table_find_result1_6)
						end
					end
				end
			end
		end
		function module_3_upvr.StaticHashAddValueLarge(arg1_34, arg2) -- Line 517
			--[[ Upvalues[5]:
				[1]: AABB_upvr (readonly)
				[2]: var219_upvr (readonly)
				[3]: floor_upvr (copied, readonly)
				[4]: var218_upvw (read and write)
				[5]: tbl_upvw (read and write)
			]]
			local AABB_upvr_result1_7, _, AABB_upvr_result3_4, AABB_upvr_result4_4, _, AABB_upvr_result6_5 = AABB_upvr(arg1_34)
			local var314 = AABB_upvr_result1_7 - var219_upvr
			local var315 = AABB_upvr_result3_4 - var219_upvr
			for i_19 = var314 - var314 % 1, AABB_upvr_result4_4 + var219_upvr, var219_upvr do
				for i_20 = var315 - var315 % 1, AABB_upvr_result6_5 + var219_upvr, var219_upvr do
					local var316 = floor_upvr(i_19 / var219_upvr) + floor_upvr(i_20 / var219_upvr) * var218_upvw
					local var317 = tbl_upvw[var316]
					if var317 then
						table.insert(var317, arg2)
					else
						local tbl = {}
						tbl[1] = arg2
						tbl_upvw[var316] = tbl
					end
				end
			end
		end
		function module_3_upvr.StaticHashRemoveValueLarge(arg1_35, arg2) -- Line 537
			--[[ Upvalues[5]:
				[1]: AABB_upvr (readonly)
				[2]: var219_upvr (readonly)
				[3]: floor_upvr (copied, readonly)
				[4]: var218_upvw (read and write)
				[5]: tbl_upvw (read and write)
			]]
			local AABB_upvr_result1_2, _, AABB_upvr_result3_5, AABB_upvr_result4_2, _, AABB_upvr_result6_2 = AABB_upvr(arg1_35)
			local var339 = AABB_upvr_result1_2 - var219_upvr
			local var340 = AABB_upvr_result3_5 - var219_upvr
			for i_21 = var339 - var339 % 1, AABB_upvr_result4_2 + var219_upvr, var219_upvr do
				for i_22 = var340 - var340 % 1, AABB_upvr_result6_2 + var219_upvr, var219_upvr do
					local var341 = tbl_upvw[floor_upvr(i_21 / var219_upvr) + floor_upvr(i_22 / var219_upvr) * var218_upvw]
					if var341 then
						local table_find_result1 = table.find(var341, arg2)
						if table_find_result1 then
							table.remove(var341, table_find_result1)
						end
					end
				end
			end
		end
		function module_3_upvr.AddModel(arg1_36) -- Line 558
			--[[ Upvalues[1]:
				[1]: module_3_upvr (readonly)
			]]
			if arg1_36:IsA("BasePart") then
				module_3_upvr.StaticHashAdd(arg1_36)
			end
			for _, v_3 in pairs(arg1_36:GetDescendants()) do
				if v_3:IsA("BasePart") then
					module_3_upvr.StaticHashAdd(v_3)
				end
			end
		end
		function module_3_upvr.AddPoint(arg1_37, arg2) -- Line 569
			--[[ Upvalues[4]:
				[1]: var219_upvr (readonly)
				[2]: floor_upvr (copied, readonly)
				[3]: var218_upvw (read and write)
				[4]: tbl_upvw (read and write)
			]]
			local var348 = floor_upvr(arg2.X / var219_upvr) + floor_upvr(arg2.Z / var219_upvr) * var218_upvw
			local var349 = tbl_upvw[var348]
			if var349 then
				table.insert(var349, arg1_37)
			else
				local tbl_4 = {}
				tbl_4[1] = arg1_37
				tbl_upvw[var348] = tbl_4
			end
		end
		function module_3_upvr.RemovePoint(arg1_38, arg2) -- Line 579
			--[[ Upvalues[4]:
				[1]: var219_upvr (readonly)
				[2]: floor_upvr (copied, readonly)
				[3]: var218_upvw (read and write)
				[4]: tbl_upvw (read and write)
			]]
			local var353 = tbl_upvw[floor_upvr(arg2.X / var219_upvr) + floor_upvr(arg2.Z / var219_upvr) * var218_upvw]
			if var353 then
				local table_find_result1_5 = table.find(var353, arg1_38)
				if table_find_result1_5 then
					table.remove(var353, table_find_result1_5)
					return true
				end
			end
			return false
		end
		local function _(arg1_39, arg2) -- Line 592, Named "Aggragate"
			if arg2 then
				for _, v_4 in ipairs(arg2) do
					table.insert(arg1_39, v_4)
				end
			end
		end
		function module_3_upvr.CheckNeighbors(arg1_40) -- Line 600
			--[[ Upvalues[4]:
				[1]: var219_upvr (readonly)
				[2]: floor_upvr (copied, readonly)
				[3]: var218_upvw (read and write)
				[4]: tbl_upvw (read and write)
			]]
			local var396 = floor_upvr(arg1_40.X / var219_upvr) + floor_upvr(arg1_40.Z / var219_upvr) * var218_upvw
			local module = {}
			local var398 = tbl_upvw[var396]
			if var398 then
				for _, v_5 in ipairs(var398) do
					table.insert(module, v_5)
				end
			end
			local var402 = tbl_upvw[var396 + 1]
			if var402 then
				for _, v_6 in ipairs(var402) do
					table.insert(module, v_6)
				end
			end
			local var406 = tbl_upvw[var396 - 1]
			if var406 then
				for _, v_7 in ipairs(var406) do
					table.insert(module, v_7)
				end
			end
			local var410 = tbl_upvw[var396 + var218_upvw]
			if var410 then
				for _, v_8 in ipairs(var410) do
					table.insert(module, v_8)
				end
			end
			local var414 = tbl_upvw[var396 - var218_upvw]
			if var414 then
				for _, v_9 in ipairs(var414) do
					table.insert(module, v_9)
				end
			end
			local var418 = tbl_upvw[var396 + 1 + var218_upvw]
			if var418 then
				for _, v_10 in ipairs(var418) do
					table.insert(module, v_10)
				end
			end
			local var422 = tbl_upvw[var396 - 1 - var218_upvw]
			if var422 then
				for _, v_11 in ipairs(var422) do
					table.insert(module, v_11)
				end
			end
			local var426 = tbl_upvw[var396 - 1 + var218_upvw]
			if var426 then
				for _, v_12 in ipairs(var426) do
					table.insert(module, v_12)
				end
			end
			local var430 = tbl_upvw[var396 + 1 - var218_upvw]
			if var430 then
				for _, v_13 in ipairs(var430) do
					table.insert(module, v_13)
				end
			end
			return module
		end
		local function Sorter_upvr(arg1_41, arg2) -- Line 619, Named "Sorter"
			local var434
			if arg1_41.Distance >= arg2.Distance then
				var434 = false
			else
				var434 = true
			end
			return var434
		end
		function module_3_upvr.GetObjectsAround(arg1_42, arg2) -- Line 623
			--[[ Upvalues[2]:
				[1]: module_3_upvr (readonly)
				[2]: Sorter_upvr (readonly)
			]]
			local module_2 = {}
			for _, v_14 in ipairs(module_3_upvr.CheckNeighbors(arg1_42)) do
				local magnitude = (v_14.Position - arg1_42).magnitude
				if magnitude <= arg2 then
					table.insert(module_2, {
						Object = v_14;
						Distance = magnitude;
					})
				end
			end
			table.sort(module_2, Sorter_upvr)
			return module_2
		end
		function module_3_upvr.AddPointNeighbors(arg1_43, arg2) -- Line 639
			--[[ Upvalues[2]:
				[1]: module_3_upvr (readonly)
				[2]: var219_upvr (readonly)
			]]
			module_3_upvr.AddPoint(arg1_43, arg2)
			module_3_upvr.AddPoint(arg1_43, arg2 + Vector3.new(var219_upvr, 0, 0))
			module_3_upvr.AddPoint(arg1_43, arg2 + Vector3.new(-var219_upvr, 0, 0))
			module_3_upvr.AddPoint(arg1_43, arg2 + Vector3.new(0, 0, var219_upvr))
			module_3_upvr.AddPoint(arg1_43, arg2 + Vector3.new(0, 0, -var219_upvr))
			module_3_upvr.AddPoint(arg1_43, arg2 + Vector3.new(var219_upvr, 0, var219_upvr))
			module_3_upvr.AddPoint(arg1_43, arg2 + Vector3.new(var219_upvr, 0, -var219_upvr))
			module_3_upvr.AddPoint(arg1_43, arg2 + Vector3.new(-var219_upvr, 0, var219_upvr))
			module_3_upvr.AddPoint(arg1_43, arg2 + Vector3.new(-var219_upvr, 0, -var219_upvr))
		end
		return module_3_upvr
	end;
}