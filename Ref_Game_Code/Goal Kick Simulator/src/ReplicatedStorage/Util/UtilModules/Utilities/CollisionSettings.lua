-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:49
-- Luau version 6, Types version 3
-- Time taken: 0.001640 seconds

-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
if game:GetService("RunService"):IsClient() then
	return {}
end
local module = {
	Humanoids = {
		Humanoids = false;
	};
	InvisibleWalls = {
		Humanoids = false;
	};
	Balls = {
		Humanoids = false;
		InvisibleWalls = true;
		Balls = false;
	};
	InvisibleWallsBalls = {
		Balls = false;
		Humanoids = true;
		Default = true;
	};
}
for i in pairs(module) do
	game:GetService("PhysicsService"):RegisterCollisionGroup(i)
	local var29
end
for i_2, v in pairs(module) do
	for i_3, v_2 in pairs(v) do
		var29:CollisionGroupSetCollidable(i_2, i_3, v_2)
	end
end
return module