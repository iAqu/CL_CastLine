-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:26
-- Luau version 6, Types version 3
-- Time taken: 0.001675 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("GuiThemeService")
local module = {
	observeSurfaceColor = function(arg1) -- Line 12, Named "observeSurfaceColor"
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr_2 (readonly)
		]]
		return arg1:GetService(var1_result1_upvr_2):ObserveColor("surface")
	end;
}
local var1_result1_upvr = any_load_result1("Blend")
function module.createThemeButton(arg1, arg2, arg3) -- Line 18
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	assert(arg1, "No maid")
	assert(arg2, "No serviceBag")
	assert(arg3, "No target")
	local service_upvr = arg2:GetService(var1_result1_upvr_2)
	local tbl = {}
	tbl.Parent = arg3
	tbl.Text = var1_result1_upvr.Computed(service_upvr:GetPreferredThemeNameValue(), function(arg1_2) -- Line 27
		if arg1_2 == "Dark" then
			return "🌚"
		end
		if arg1_2 == "Light" then
			return "🌞"
		end
		return arg1_2
	end)
	tbl.Size = UDim2.new(0, 40, 0, 40)
	tbl.Position = UDim2.new(1, -10, 0, 10)
	tbl.AnchorPoint = Vector2.new(1, 0)
	tbl.ZIndex = 1000
	tbl.TextSize = 30
	tbl.Font = service_upvr:ObserveFont("font")
	tbl.AutoButtonColor = true
	tbl[var1_result1_upvr.OnEvent("Activated")] = function() -- Line 43
		--[[ Upvalues[1]:
			[1]: service_upvr (readonly)
		]]
		if service_upvr:GetPreferredThemeName() == "Light" then
			service_upvr:SetPreferredThemeName("Dark")
		else
			service_upvr:SetPreferredThemeName("Light")
		end
	end
	tbl[var1_result1_upvr.Children] = {var1_result1_upvr.New("UICorner")({
		CornerRadius = UDim.new(0.5, 0);
	}), var1_result1_upvr.New("UIStroke")({
		Color = Color3.new(0.4, 0.4, 0.4);
		Thickness = 4;
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
	})}
	arg1:GiveTask(var1_result1_upvr.New("TextButton")(tbl):Subscribe())
end
return module