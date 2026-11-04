-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:15
-- Luau version 6, Types version 3
-- Time taken: 0.001179 seconds

local LocalPlayer = game.Players.LocalPlayer
if LocalPlayer:WaitForChild("IsNewPlayer", math.huge).Value == true then
	require(game:GetService("ReplicatedStorage").Tool.AddListen).NumValueAdd(LocalPlayer:WaitForChild("GuideName", math.huge), function(arg1) -- Line 11
		if script.Parent.Name == arg1 then
			script.Parent.Visible = true
		else
			script.Parent.Visible = false
		end
	end)
else
	script.Parent:Destroy()
	return
end
if script.Parent then
	script.Parent.Position = UDim2.new(0.5, 0, 0, 0)
	game:GetService("TweenService"):Create(script.Parent, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, true), {
		Position = UDim2.new(0.5, 0, -0.3, 0);
	}):Play()
end