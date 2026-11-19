-- Temporary Rojo startup probe. Never ship this in StarterPlayerScripts.
if not game:GetService("RunService"):IsStudio() then
	return
end
local RS = game:GetService("ReplicatedStorage")
local Http = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local Effects = require(RS:WaitForChild("Modules"):WaitForChild("TrainingUIEffects"))
local counts = { reps = 0, levels = 0, clears = 0 }
local function report()
	player:SetAttribute("TrainingUIFeedbackVerification", Http:JSONEncode(counts))
end
local rep, levelUp, clear = Effects.Rep, Effects.LevelUp, Effects.Clear
function Effects:Rep(amount, root)
	rep(self, amount, root)
	counts.reps += 1
	counts.lastXp = amount
	counts.xpPopup = root and root:FindFirstChild("TrainingXpPopup") ~= nil
	report()
end
function Effects:LevelUp(weight, root)
	levelUp(self, weight, root)
	counts.levels += 1
	counts.lastWeight = weight
	counts.confetti = #self.gui.Effects:GetChildren()
	counts.levelPopup = root and root:FindFirstChild("TrainingLevelPopup") ~= nil
	counts.weightPopup = root and root:FindFirstChild("TrainingWeightPopup") ~= nil
	counts.levelText = root and root:FindFirstChild("TrainingWeightPopup") and root.TrainingWeightPopup.Text.Text
	report()
end
function Effects:Clear()
	clear(self)
	counts.clears += 1
	counts.remaining = 0
	for _ in pairs(self.objects) do
		counts.remaining += 1
	end
	report()
end
report()
