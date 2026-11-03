-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = script.Parent.Name
local v3 = (script.Parent:FindFirstChild("Animator", true) or script.Parent:WaitForChild("Humanoid"):WaitForChild("Animator")):LoadAnimation(ReplicatedStorage.Objects.EntitiesAnimations[v1])
v3.Looped = true
v3:Play()