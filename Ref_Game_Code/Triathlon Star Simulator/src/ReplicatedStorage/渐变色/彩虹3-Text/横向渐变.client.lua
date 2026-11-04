-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:39
-- Luau version 6, Types version 3
-- Time taken: 0.002061 seconds

local Parent_upvr = script.Parent
if Parent_upvr then
	local vector2_upvr = Vector2.new(-1, 0)
	local tbl_upvr = {Color3.fromHex("#ffeb6e"), Color3.fromHex("#fb75ff"), Color3.fromHex("#62f2f6")}
	Parent_upvr.Offset = vector2_upvr
	Parent_upvr.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl_upvr[#tbl_upvr]), ColorSequenceKeypoint.new(0.5, tbl_upvr[#tbl_upvr - 1]), ColorSequenceKeypoint.new(1, tbl_upvr[#tbl_upvr - 2])})
	local any_Create_result1_upvr = game:GetService("TweenService"):Create(Parent_upvr, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
		Offset = Vector2.new(1, 0);
	})
	local len_upvw = #tbl_upvr
	local var8_upvw = "down"
	local function animate_upvr() -- Line 25, Named "animate"
		--[[ Upvalues[7]:
			[1]: any_Create_result1_upvr (readonly)
			[2]: Parent_upvr (readonly)
			[3]: vector2_upvr (readonly)
			[4]: len_upvw (read and write)
			[5]: tbl_upvr (readonly)
			[6]: var8_upvw (read and write)
			[7]: animate_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 33 start (CF ANALYSIS FAILED)
		any_Create_result1_upvr:Play()
		any_Create_result1_upvr.Completed:Wait()
		Parent_upvr.Offset = vector2_upvr
		Parent_upvr.Rotation = 180
		if len_upvw == #tbl_upvr - 1 and var8_upvw == "down" then
			Parent_upvr.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Parent_upvr.Color.Keypoints[1].Value), ColorSequenceKeypoint.new(0.5, tbl_upvr[#tbl_upvr]), ColorSequenceKeypoint.new(1, tbl_upvr[1])})
			len_upvw = 1
			var8_upvw = "up"
			-- KONSTANTWARNING: GOTO [167] #127
		end
		-- KONSTANTERROR: [0] 1. Error Block 33 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [68] 52. Error Block 34 start (CF ANALYSIS FAILED)
		if len_upvw == #tbl_upvr and var8_upvw == "down" then
			Parent_upvr.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Parent_upvr.Color.Keypoints[1].Value), ColorSequenceKeypoint.new(0.5, tbl_upvr[1]), ColorSequenceKeypoint.new(1, tbl_upvr[2])})
			len_upvw = 2
			var8_upvw = "up"
		elseif len_upvw <= #tbl_upvr - 2 and var8_upvw == "down" then
			Parent_upvr.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Parent_upvr.Color.Keypoints[1].Value), ColorSequenceKeypoint.new(0.5, tbl_upvr[len_upvw + 1]), ColorSequenceKeypoint.new(1, tbl_upvr[len_upvw + 2])})
			len_upvw += 2
			var8_upvw = "up"
		end
		any_Create_result1_upvr:Play()
		any_Create_result1_upvr.Completed:Wait()
		Parent_upvr.Offset = vector2_upvr
		Parent_upvr.Rotation = 0
		if len_upvw == #tbl_upvr - 1 and var8_upvw == "up" then
			Parent_upvr.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl_upvr[1]), ColorSequenceKeypoint.new(0.5, tbl_upvr[#tbl_upvr]), ColorSequenceKeypoint.new(1, Parent_upvr.Color.Keypoints[3].Value)})
			len_upvw = 1
			var8_upvw = "down"
		elseif len_upvw == #tbl_upvr and var8_upvw == "up" then
			Parent_upvr.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl_upvr[2]), ColorSequenceKeypoint.new(0.5, tbl_upvr[1]), ColorSequenceKeypoint.new(1, Parent_upvr.Color.Keypoints[3].Value)})
			len_upvw = 2
			var8_upvw = "down"
		elseif len_upvw <= #tbl_upvr - 2 and var8_upvw == "up" then
			Parent_upvr.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl_upvr[len_upvw + 2]), ColorSequenceKeypoint.new(0.5, tbl_upvr[len_upvw + 1]), ColorSequenceKeypoint.new(1, Parent_upvr.Color.Keypoints[3].Value)})
			len_upvw += 2
			var8_upvw = "down"
		end
		animate_upvr()
		-- KONSTANTERROR: [68] 52. Error Block 34 end (CF ANALYSIS FAILED)
	end
	animate_upvr()
end