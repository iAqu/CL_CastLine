-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:07
-- Luau version 6, Types version 3
-- Time taken: 0.012144 seconds

local ReplicatedFirst_upvr_2 = game:GetService("ReplicatedFirst")
spawn(function() -- Line 3
	--[[ Upvalues[1]:
		[1]: ReplicatedFirst_upvr_2 (readonly)
	]]
	for _ = 1, 5 do
		ReplicatedFirst_upvr_2:RemoveDefaultLoadingScreen()
		wait(1)
	end
end)
local TweenService_upvr_2 = game:GetService("TweenService")
local ContentProvider_upvr_2 = game:GetService("ContentProvider")
local LocalPlayer_upvr_2 = game:GetService("Players").LocalPlayer
local PlayerGui_upvr = LocalPlayer_upvr_2:WaitForChild("PlayerGui")
local tbl_8 = {}
local any_GetPreloadTable_result1_upvr_2 = require(script.AnimationModule).GetPreloadTable()
local var121_upvw = 0
local var125_upvw
for i_2, v in ipairs({PlayerGui_upvr:WaitForChild("ScreenGui"):WaitForChild("Main"), PlayerGui_upvr:WaitForChild("ScreenGui"), game.ReplicatedStorage}) do
	if i_2 == 2 then
		var125_upvw = #tbl_8
	end
	for _, v_2 in pairs(v:GetDescendants()) do
		if v_2:IsA("ImageLabel") then
			table.insert(tbl_8, v_2.Image)
		end
		if v_2:IsA("MeshPart") then
			if v_2.TextureID ~= "" then
				table.insert(tbl_8, v_2.TextureID)
			end
			if v_2.MeshId ~= "" then
				table.insert(tbl_8, v_2.MeshId)
			end
		end
		if v:IsA("ParticleEmitter") then
			local Texture = v.Texture
			if Texture ~= "" then
				table.insert(tbl_8, Texture)
			end
		end
		if v:IsA("SpecialMesh") then
			local TextureId = v.TextureId
			if TextureId ~= "" then
				table.insert(tbl_8, TextureId)
			end
		end
		if v:IsA("Beam") then
			local Texture_6 = v.Texture
			if Texture_6 ~= "" then
				table.insert(tbl_8, Texture_6)
			end
		end
		if v:IsA("Trail") then
			local Texture_5 = v.Texture
			if Texture_5 ~= "" then
				table.insert(tbl_8, Texture_5)
			end
		end
		if v:IsA("Sound") then
			local SoundId_2 = v.SoundId
			if SoundId_2 ~= "" then
				table.insert(tbl_8, SoundId_2)
			end
		end
	end
end
var125_upvw += #any_GetPreloadTable_result1_upvr_2
local function PreloadAss_upvr(arg1) -- Line 128, Named "PreloadAss"
	--[[ Upvalues[2]:
		[1]: ContentProvider_upvr_2 (readonly)
		[2]: var121_upvw (read and write)
	]]
	if not pcall(function() -- Line 130
		--[[ Upvalues[2]:
			[1]: ContentProvider_upvr_2 (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local tbl_10 = {}
		tbl_10[1] = arg1
		ContentProvider_upvr_2:PreloadAsync(tbl_10)
	end) then
		task.delay(2, function() -- Line 135
			--[[ Upvalues[2]:
				[1]: ContentProvider_upvr_2 (copied, readonly)
				[2]: arg1 (readonly)
			]]
			pcall(function() -- Line 136
				--[[ Upvalues[2]:
					[1]: ContentProvider_upvr_2 (copied, readonly)
					[2]: arg1 (copied, readonly)
				]]
				local tbl_3 = {}
				tbl_3[1] = arg1
				ContentProvider_upvr_2:PreloadAsync(tbl_3)
			end)
		end)
	else
		var121_upvw += 1
	end
end
local PreloadGui_upvw_2 = script.Parent.PreloadGui
local logo_upvr = PreloadGui_upvw_2.Frame.logo
local skipBtn_upvr = PreloadGui_upvw_2.skipBtn
local progressBar_upvr_2 = PreloadGui_upvw_2.progressBar
local percent_upvr = progressBar_upvr_2.percent
local loadingText_upvr_2 = PreloadGui_upvw_2.loadingText
local var149_upvw = false
local bg_upvr = PreloadGui_upvw_2.bg
local Debris_upvr_2 = game:GetService("Debris")
local function CloseUI_upvr() -- Line 189, Named "CloseUI"
	--[[ Upvalues[9]:
		[1]: var149_upvw (read and write)
		[2]: progressBar_upvr_2 (readonly)
		[3]: loadingText_upvr_2 (readonly)
		[4]: skipBtn_upvr (readonly)
		[5]: TweenService_upvr_2 (readonly)
		[6]: bg_upvr (readonly)
		[7]: logo_upvr (readonly)
		[8]: PreloadGui_upvw_2 (read and write)
		[9]: Debris_upvr_2 (readonly)
	]]
	var149_upvw = true
	progressBar_upvr_2.bar.Size = UDim2.new(1, 0, 1, 0)
	loadingText_upvr_2.Visible = false
	skipBtn_upvr.Visible = false
	progressBar_upvr_2.Visible = false
	wait(0.5)
	TweenService_upvr_2:Create(bg_upvr, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Transparency = 1;
	}):Play()
	local any_Create_result1_2 = TweenService_upvr_2:Create(logo_upvr, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		ImageTransparency = 1;
	})
	any_Create_result1_2.Completed:Connect(function() -- Line 209
		--[[ Upvalues[2]:
			[1]: PreloadGui_upvw_2 (copied, read and write)
			[2]: Debris_upvr_2 (copied, readonly)
		]]
		if PreloadGui_upvw_2 then
			PreloadGui_upvw_2.Enabled = false
			Debris_upvr_2:AddItem(PreloadGui_upvw_2, 0)
			PreloadGui_upvw_2 = nil
		end
	end)
	any_Create_result1_2:Play()
	delay(2, function() -- Line 220
		--[[ Upvalues[2]:
			[1]: PreloadGui_upvw_2 (copied, read and write)
			[2]: Debris_upvr_2 (copied, readonly)
		]]
		if PreloadGui_upvw_2 then
			PreloadGui_upvw_2.Enabled = false
			Debris_upvr_2:AddItem(PreloadGui_upvw_2, 0)
			PreloadGui_upvw_2 = nil
		end
	end)
end
local var157_upvw
local function Update_upvr(arg1) -- Line 231, Named "Update"
	--[[ Upvalues[9]:
		[1]: var121_upvw (read and write)
		[2]: var125_upvw (read and write)
		[3]: progressBar_upvr_2 (readonly)
		[4]: percent_upvr (readonly)
		[5]: LocalPlayer_upvr_2 (readonly)
		[6]: var157_upvw (read and write)
		[7]: CloseUI_upvr (readonly)
		[8]: var149_upvw (read and write)
		[9]: skipBtn_upvr (readonly)
	]]
	local clamped_3 = math.clamp(var121_upvw / var125_upvw, 0, 1)
	progressBar_upvr_2.bar.Size = UDim2.new(clamped_3, 0, 1, 0)
	if 0.1 < arg1 then
		percent_upvr.Visible = true
		percent_upvr.Text = math.round(clamped_3 * 100)..'%'
	end
	if clamped_3 == 1 and LocalPlayer_upvr_2:FindFirstChild("正在串流地图") and LocalPlayer_upvr_2:FindFirstChild("正在串流地图").Value == false then
		if var157_upvw then
			var157_upvw:Disconnect()
			var157_upvw = nil
		end
		CloseUI_upvr()
	end
	if 5 < arg1 and not var149_upvw then
		skipBtn_upvr.Visible = true
		if not var157_upvw then
			var157_upvw = skipBtn_upvr.MouseButton1Click:Connect(function() -- Line 267
				--[[ Upvalues[2]:
					[1]: var157_upvw (copied, read and write)
					[2]: CloseUI_upvr (copied, readonly)
				]]
				if var157_upvw then
					var157_upvw:Disconnect()
					var157_upvw = nil
				end
				CloseUI_upvr()
			end)
		end
	end
end
;(function() -- Line 156, Named "Init"
	--[[ Upvalues[7]:
		[1]: logo_upvr (readonly)
		[2]: percent_upvr (readonly)
		[3]: loadingText_upvr_2 (readonly)
		[4]: skipBtn_upvr (readonly)
		[5]: PreloadGui_upvw_2 (read and write)
		[6]: PlayerGui_upvr (readonly)
		[7]: TweenService_upvr_2 (readonly)
	]]
	logo_upvr.Size = UDim2.new(0.8, 0, 0.8, 0)
	percent_upvr.Text = "0%"
	loadingText_upvr_2.Size = UDim2.new(0.8, 0, 0.06, 0)
	skipBtn_upvr.Visible = false
	percent_upvr.Visible = false
	loadingText_upvr_2.Visible = false
	task.spawn(function() -- Line 168
		--[[ Upvalues[2]:
			[1]: loadingText_upvr_2 (copied, readonly)
			[2]: skipBtn_upvr (copied, readonly)
		]]
		local module_4 = require(game.ReplicatedStorage:WaitForChild("Tool"):WaitForChild("TranslationHelper"))
		module_4.SetText(loadingText_upvr_2, "加载中...")
		module_4.SetText(skipBtn_upvr.SkipText, "跳过")
		loadingText_upvr_2.Visible = true
	end)
	PreloadGui_upvw_2.Parent = PlayerGui_upvr
	PreloadGui_upvw_2.Enabled = true
	TweenService_upvr_2:Create(logo_upvr, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In, -1, true), {
		Size = UDim2.new(0.6, 0, 0.6, 0);
	}):Play()
	TweenService_upvr_2:Create(loadingText_upvr_2, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In, -1, true), {
		Size = UDim2.new(0.6400000000000001, 0, 0.048);
	}):Play()
end)()
local var161_upvw
local var162_upvw = 0
var161_upvw = game["Run Service"].Heartbeat:Connect(function(arg1) -- Line 289
	--[[ Upvalues[4]:
		[1]: var149_upvw (read and write)
		[2]: var161_upvw (read and write)
		[3]: Update_upvr (readonly)
		[4]: var162_upvw (read and write)
	]]
	if var149_upvw and var161_upvw then
		var161_upvw:Disconnect()
		var161_upvw = nil
	else
		Update_upvr(var162_upvw)
		var162_upvw += arg1
	end
end)
for _, v_3_upvr in pairs(tbl_8) do
	if 0 <= 10 then
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		task.spawn(function() -- Line 311
			--[[ Upvalues[2]:
				[1]: PreloadAss_upvr (readonly)
				[2]: v_3_upvr (readonly)
			]]
			PreloadAss_upvr(v_3_upvr)
		end)
	else
		PreloadAss_upvr(v_3_upvr)
		task.wait()
	end
end
task.spawn(function() -- Line 324
	--[[ Upvalues[3]:
		[1]: any_GetPreloadTable_result1_upvr_2 (readonly)
		[2]: ContentProvider_upvr_2 (readonly)
		[3]: var121_upvw (read and write)
	]]
	local tbl_7 = {}
	for _, v_4 in pairs(any_GetPreloadTable_result1_upvr_2) do
		local Animation_2 = Instance.new("Animation")
		Animation_2.Parent = game.ReplicatedStorage
		Animation_2.AnimationId = v_4
		table.insert(tbl_7, Animation_2)
	end
	for _, v_5_upvr in pairs(tbl_7) do
		local function Load_upvr() -- Line 336, Named "Load"
			--[[ Upvalues[3]:
				[1]: v_5_upvr (readonly)
				[2]: ContentProvider_upvr_2 (copied, readonly)
				[3]: var121_upvw (copied, read and write)
			]]
			local function var184_upvr() -- Line 337
				--[[ Upvalues[1]:
					[1]: v_5_upvr (copied, readonly)
				]]
				game.Debris:AddItem(v_5_upvr, 0)
			end
			local pcall_result1, _ = pcall(function() -- Line 341
				--[[ Upvalues[3]:
					[1]: ContentProvider_upvr_2 (copied, readonly)
					[2]: v_5_upvr (copied, readonly)
					[3]: var184_upvr (readonly)
				]]
				return ContentProvider_upvr_2:PreloadAsync({v_5_upvr}, var184_upvr)
			end)
			if pcall_result1 then
				var121_upvw += 1
			else
				task.delay(0.5, function() -- Line 348
					--[[ Upvalues[4]:
						[1]: ContentProvider_upvr_2 (copied, readonly)
						[2]: v_5_upvr (copied, readonly)
						[3]: var184_upvr (readonly)
						[4]: var121_upvw (copied, read and write)
					]]
					local _, _ = pcall(function() -- Line 349
						--[[ Upvalues[3]:
							[1]: ContentProvider_upvr_2 (copied, readonly)
							[2]: v_5_upvr (copied, readonly)
							[3]: var184_upvr (copied, readonly)
						]]
						return ContentProvider_upvr_2:PreloadAsync({v_5_upvr}, var184_upvr)
					end)
					var121_upvw += 1
				end)
			end
		end
		if 0 <= 10 then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			task.spawn(function() -- Line 363
				--[[ Upvalues[1]:
					[1]: Load_upvr (readonly)
				]]
				Load_upvr()
			end)
		else
			task.wait()
			Load_upvr()
		end
	end
end)