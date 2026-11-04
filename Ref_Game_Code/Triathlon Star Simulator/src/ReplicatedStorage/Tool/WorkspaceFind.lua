-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:58
-- Luau version 6, Types version 3
-- Time taken: 0.000546 seconds

return {
	RayCastToLand = function(arg1) -- Line 10, Named "RayCastToLand"
		local RaycastParams_new_result1 = RaycastParams.new()
		RaycastParams_new_result1.FilterType = Enum.RaycastFilterType.Whitelist
		RaycastParams_new_result1.FilterDescendantsInstances = {workspace:FindFirstChild("场景")}
		RaycastParams_new_result1.IgnoreWater = true
		local workspace_Raycast_result1 = workspace:Raycast(arg1, Vector3.new(0, -1000, 0), RaycastParams_new_result1)
		if workspace_Raycast_result1 then
			return workspace_Raycast_result1.Position
		end
		return nil
	end;
}