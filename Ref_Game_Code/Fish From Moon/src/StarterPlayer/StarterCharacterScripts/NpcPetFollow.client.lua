local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local HolderRoot = game.Workspace:WaitForChild("Pet")

local IdleAnim = ReplicatedStorage.Assets.Animation:WaitForChild("Idle")
local RunAnim = ReplicatedStorage.Assets.Animation:WaitForChild("Run")

local animCache = {}

function followPlayer(character: Model, models)
	for i, model: Model in models do
		if not model:FindFirstChild("HumanoidRootPart") then
			continue
		end

		local animator: Animator = model:WaitForChild("Humanoid"):WaitForChild("Animator")
		if not animator.Parent then
			continue
		end
		if not animCache[animator] then
			animCache[animator] = {}
			animator.Destroying:Connect(function()
				animCache[animator] = nil
			end)
		end

		local idleAnim: ObjectValue = animator:FindFirstChild("Idle")
		if not idleAnim or not idleAnim.Value then
			idleAnim = idleAnim or Instance.new("ObjectValue")
			idleAnim.Name = "Idle"
			idleAnim.Value = animator:LoadAnimation(IdleAnim)
			idleAnim.Parent = animator
			idleAnim.Value:Play()
			animCache[animator][IdleAnim] = idleAnim.Value
		end

		local runAnim: ObjectValue = animator:FindFirstChild("Run")
		if not runAnim or not runAnim.Value then
			runAnim = runAnim or Instance.new("ObjectValue")
			runAnim.Name = "Run"
			runAnim.Value = animator:LoadAnimation(RunAnim)
			runAnim.Parent = animator
			animCache[animator][RunAnim] = runAnim.Value
		end
		local x = 8 * math.sin(i + 1.1)
		local z = 8 * math.cos(i + 1.1)

		local pivot = model.HumanoidRootPart.CFrame
		local nextPivot = CFrame.new((character.HumanoidRootPart.CFrame * CFrame.new(-x, (model.HumanoidRootPart.Size.Y - 2) * 1.5, -z)).Position)

		local mag = (pivot.Position - nextPivot.Position).Magnitude
		if mag > 2 then
			if not (runAnim.Value :: AnimationTrack).IsPlaying then
				runAnim.Value:Play()
			end
		else
			if (runAnim.Value :: AnimationTrack).IsPlaying then
				runAnim.Value:Stop()
			end
		end

		if mag < 2 then
			nextPivot *= character.HumanoidRootPart.CFrame.Rotation
		else 
			nextPivot *= CFrame.Angles(0, ({CFrame.lookAt(pivot.Position, nextPivot.Position).Rotation:ToOrientation()})[2], 0)
		end

		if model:GetAttribute("Teleport") then
			model:SetAttribute("Teleport", nil)
		else
			nextPivot = model.HumanoidRootPart.CFrame:Lerp(nextPivot, math.clamp(1 - (10 - mag) - .7, .08, .2))
		end

		model:PivotTo(nextPivot)	
	end
end 

game:GetService("RunService").RenderStepped:Connect(function()

	for _, player in Players:GetPlayers() do

		local character = player.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then
			return
		end
		local holder = HolderRoot:FindFirstChild(player.UserId)

		if not holder then
			return
		end
		followPlayer(character, holder:GetChildren())
	end
end)