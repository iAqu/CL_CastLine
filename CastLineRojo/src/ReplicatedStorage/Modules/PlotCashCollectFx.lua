local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local GuiAnimationUtil = require(ReplicatedStorage.Modules.GuiAnimationUtil)
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)

local PlotCashCollectFx = {}

local CASH_PART_COUNT_MIN = 3
local CASH_PART_COUNT_MAX = 5
local SCATTER_DURATION = 0.18
local SCATTER_RADIUS = 4
local ABSORB_SPEED = 320
local ABSORB_DURATION_MIN = 0.08
local ABSORB_DURATION_MAX = 0.22
local CASH_GAIN_DURATION = 0.55
local CLEANUP_SECONDS = 5
local MONEY_ATTACH_LIFETIME = 2

local random = Random.new()
local warnedMissingCashPart = false

local function getCashParent(): Instance
	return Workspace:FindFirstChild("Debris") or Workspace
end

local function getPetVfxAsset(name: string): Instance?
	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	local petVfx = vfx and vfx:FindFirstChild("PetVFX")
	return petVfx and petVfx:FindFirstChild(name)
end

local function getCollectSound(name: string): Sound?
	local sounds = ReplicatedStorage:FindFirstChild("Sound")
	local collectCash = sounds and sounds:FindFirstChild("CollectCash")
	local sound = collectCash and collectCash:FindFirstChild(name)
	return if sound and sound:IsA("Sound") then sound else nil
end

local function getCoinSound(): Sound?
	local sounds = ReplicatedStorage:FindFirstChild("Sound")
	local others = sounds and sounds:FindFirstChild("Others")
	local getCoin = others and others:FindFirstChild("Get_Coin")
	if getCoin and getCoin:IsA("Sound") then
		return getCoin
	end
	local gui = sounds and sounds:FindFirstChild("Gui")
	local getCoins = gui and gui:FindFirstChild("Get_Coins")
	return if getCoins and getCoins:IsA("Sound") then getCoins else nil
end

local function emitParticles(instance: Instance)
	if instance:IsA("ParticleEmitter") then
		instance.LockedToPart = true
		instance:Emit(instance:GetAttribute("EmitCount") or 1)
	end
	for _, descendant in ipairs(instance:GetDescendants()) do
		if descendant:IsA("ParticleEmitter") then
			descendant.LockedToPart = true
			descendant:Emit(descendant:GetAttribute("EmitCount") or 1)
		end
	end
end

local function playArrivalEffects(rootPart: BasePart, amount: number, skipCashGain: boolean?)
	local moneyAttachAsset = getPetVfxAsset("MoneyAttach")
	if moneyAttachAsset then
		local moneyAttach = moneyAttachAsset:Clone()
		if moneyAttach:IsA("Attachment") then
			moneyAttach.Position = Vector3.zero
			moneyAttach.Orientation = Vector3.zero
		end
		moneyAttach.Parent = rootPart
		emitParticles(moneyAttach)
		Debris:AddItem(moneyAttach, MONEY_ATTACH_LIFETIME)
	end

	local cashCollect = getCollectSound("CashCollect")
	if cashCollect then
		SoundHelper.PlaySound(cashCollect, rootPart, nil, 3, true)
	end
	local getCoin = getCoinSound()
	if getCoin then
		SoundHelper.PlaySound(getCoin, rootPart, nil, 3, true)
	end
	if not skipCashGain then
		GuiAnimationUtil.PlayCharacterCashGain(Players.LocalPlayer.Character, amount, CASH_GAIN_DURATION)
	end
end

local function quadraticBezier(alpha: number, startPoint: Vector3, controlPoint: Vector3, endPoint: Vector3): Vector3
	local inverse = 1 - alpha
	return inverse * inverse * startPoint + 2 * inverse * alpha * controlPoint + alpha * alpha * endPoint
end

local function prepareCashPart(template: BasePart, position: Vector3): BasePart
	local cashPart = template:Clone()
	cashPart.Anchored = true
	cashPart.CanCollide = false
	cashPart.CanTouch = false
	cashPart.CanQuery = false
	cashPart.CFrame = CFrame.new(position)
	cashPart.Parent = getCashParent()
	Debris:AddItem(cashPart, CLEANUP_SECONDS)
	return cashPart
end

export type PlayOptions = {
	skipCashGain: boolean?,
}

function PlotCashCollectFx.Play(cashPool: Instance?, amount: number, options: PlayOptions?)
	if not cashPool or amount < 1 then
		return
	end
	local skipCashGain = options and options.skipCashGain == true
	local guiPart = cashPool:FindFirstChild("GuiPart")
	local character = Players.LocalPlayer.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	if not guiPart or not guiPart:IsA("BasePart") or not rootPart or not rootPart:IsA("BasePart") then
		return
	end

	local whoosh = getCollectSound("Whoosh")
	if whoosh then
		SoundHelper.PlaySound(whoosh, guiPart, nil, 3, true)
	end

	local template = getPetVfxAsset("CashPart")
	if not template or not template:IsA("BasePart") then
		if not warnedMissingCashPart then
			warnedMissingCashPart = true
			warn("PlotCashCollectFx: ReplicatedStorage.VFX.PetVFX.CashPart must be a BasePart")
		end
		playArrivalEffects(rootPart, amount, skipCashGain)
		return
	end

	local origin = guiPart.Position + Vector3.new(0, guiPart.Size.Y * 0.5 + 0.25, 0)
	local cashParts = {}
	local paths = {}
	for _ = 1, random:NextInteger(CASH_PART_COUNT_MIN, CASH_PART_COUNT_MAX) do
		local angle = random:NextNumber(0, math.pi * 2)
		local radius = random:NextNumber(SCATTER_RADIUS * 0.45, SCATTER_RADIUS)
		local scatterPoint = origin + Vector3.new(
			math.cos(angle) * radius,
			random:NextNumber(1.5, 3.5),
			math.sin(angle) * radius
		)
		local cashPart = prepareCashPart(template, origin)
		table.insert(cashParts, cashPart)
		table.insert(paths, {
			scatterPoint = scatterPoint,
			controlPoint = (scatterPoint + rootPart.Position) * 0.5
				+ Vector3.new(random:NextNumber(-3, 3), random:NextNumber(2, 5), random:NextNumber(-3, 3)),
		})
	end

	local startedAt = os.clock()
	local connection: RBXScriptConnection?
	local finished = false
	local function finish()
		if finished then
			return
		end
		finished = true
		if connection then
			connection:Disconnect()
		end
		for _, cashPart in ipairs(cashParts) do
			if cashPart.Parent then
				cashPart:Destroy()
			end
		end
		if rootPart.Parent then
			playArrivalEffects(rootPart, amount, skipCashGain)
		end
	end

	connection = RunService.RenderStepped:Connect(function()
		if not rootPart.Parent then
			finish()
			return
		end
		local elapsed = os.clock() - startedAt
		local remaining = 0
		for index, cashPart in ipairs(cashParts) do
			if not cashPart.Parent then
				continue
			end
			local path = paths[index]
			local position: Vector3
			if elapsed < SCATTER_DURATION then
				local alpha = math.clamp(elapsed / SCATTER_DURATION, 0, 1)
				local eased = 1 - (1 - alpha) * (1 - alpha)
				position = origin:Lerp(path.scatterPoint, eased)
			else
				local distance = (path.scatterPoint - rootPart.Position).Magnitude
				local duration = math.clamp(distance / ABSORB_SPEED, ABSORB_DURATION_MIN, ABSORB_DURATION_MAX)
				local alpha = math.clamp((elapsed - SCATTER_DURATION) / duration, 0, 1)
				position = quadraticBezier(alpha, path.scatterPoint, path.controlPoint, rootPart.Position)
				if alpha >= 1 then
					cashPart:Destroy()
					continue
				end
			end
			cashPart.CFrame = CFrame.new(position) * CFrame.Angles(0, elapsed * 8 + index, elapsed * 5)
			remaining += 1
		end
		if remaining == 0 or elapsed >= CLEANUP_SECONDS then
			finish()
		end
	end)
end

return PlotCashCollectFx
