-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = {}

local function greedyChild(p1) --[[ greedyChild | Line: 8 | Upvalues: ReplicatedStorage (copy) ]]
	local Assets = ReplicatedStorage:FindFirstChild("Assets")
	local v1 = if Assets then Assets:FindFirstChild("Greedy") else Assets

	return if v1 then v1:FindFirstChild(p1) else v1
end

function t.getPetFolder() --[[ getPetFolder | Line: 14 | Upvalues: ReplicatedStorage (copy) ]]
	local Assets = ReplicatedStorage:FindFirstChild("Assets")
	local v1 = if Assets then Assets:FindFirstChild("Greedy") else Assets

	return v1 and v1:FindFirstChild("Pets")
end
function t.getEggFolder() --[[ getEggFolder | Line: 18 | Upvalues: ReplicatedStorage (copy) ]]
	local Assets = ReplicatedStorage:FindFirstChild("Assets")
	local v1 = if Assets then Assets:FindFirstChild("Greedy") else Assets

	return v1 and v1:FindFirstChild("Eggs")
end
function t.resolvePet(p1) --[[ resolvePet | Line: 22 | Upvalues: t (copy) ]]
	local v1 = t.getPetFolder()
	local v2 = if v1 then if p1 then v1:FindFirstChild(p1) else p1 else v1

	return if v2 and (v2:IsA("Model") and v2) then v2 else nil
end
function t.resolveEgg(p1) --[[ resolveEgg | Line: 28 | Upvalues: t (copy) ]]
	local v1 = t.getEggFolder()
	local v2 = if v1 then if p1 then v1:FindFirstChild(p1) else p1 else v1

	return if v2 and (v2:IsA("Model") and v2) then v2 else nil
end
function t.resolveRig(p1) --[[ resolveRig | Line: 35 | Upvalues: ReplicatedStorage (copy) ]]
	local Assets = ReplicatedStorage:FindFirstChild("Assets")
	local v1 = if Assets then Assets:FindFirstChild("Greedy") else Assets
	local v2 = v1 and v1:FindFirstChild("PetRigs")
	local v3 = if v2 then if p1 then v2:FindFirstChild(p1) else p1 else v2

	return if v3 and (v3:IsA("Model") and v3) then v3 else nil
end
function t.resolveTemplate(p1, p2) --[[ resolveTemplate | Line: 42 | Upvalues: t (copy) ]]
	if p1 == "Egg" then
		return t.resolveEgg(p2)
	end

	if p1 == "Pet" then
		return t.resolvePet(p2)
	end

	return nil
end
function t.resolveDirt() --[[ resolveDirt | Line: 49 | Upvalues: ReplicatedStorage (copy) ]]
	local Assets = ReplicatedStorage:FindFirstChild("Assets")
	local v1 = if Assets then Assets:FindFirstChild("Greedy") else Assets
	local v2 = v1 and v1:FindFirstChild("PetDirt")

	return if v2 and (v2:IsA("Model") and v2) then v2 else nil
end

return t