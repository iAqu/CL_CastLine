-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local CreateParticleHost = require(script.Parent.CreateParticleHost)
local RenderStepped = require(script.Parent.RenderStepped)
local Easing = require(script.Parent.Easing)
local Emit = require(script.Parent.Emit)
local Net = require(ReplicatedStorage.Packages.Net)
local SkinCrates = require(ReplicatedStorage.SkinCrates)
local EmoteCrates = require(ReplicatedStorage.EmoteCrates)
local PetEggs = require(ReplicatedStorage.PetEggs)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local MathUtils = require(script.Parent.CrateAnimationHelpers.MathUtils)
local ModelUtils = require(script.Parent.CrateAnimationHelpers.ModelUtils)
local ItemModelUtils = require(script.Parent.CrateAnimationHelpers.ItemModelUtils)
local ParticleUtils = require(script.Parent.CrateAnimationHelpers.ParticleUtils)
local AnimationUtils = require(script.Parent.CrateAnimationHelpers.AnimationUtils)
local RollingAnimation = require(script.Parent.CrateAnimationHelpers.RollingAnimation)
local BillboardUtils = require(script.Parent.CrateAnimationHelpers.BillboardUtils)
local v1 = Net:RemoteEvent("CrateItemCollected")
local CrateItemBillboard = script:WaitForChild("CrateItemBillboard")
return {
	new = function(p1) --[[ new | Line: 53 | Upvalues: ReplicatedStorage (copy), ModelUtils (copy), CreateParticleHost (copy), ItemModelUtils (copy), ParticleUtils (copy), Emit (copy), AnimationUtils (copy), RenderStepped (copy), Easing (copy), MathUtils (copy), RollingAnimation (copy), BillboardUtils (copy), TweenService (copy), CrateItemBillboard (copy), SkinCrates (copy), EmoteCrates (copy), PetEggs (copy), Soundbook (copy), Players (copy), v1 (copy), ContentProvider (copy) ]]
		local Assets = p1.Assets
		local Settings = p1.Settings
		local ItemUtility = p1.ItemUtility
		local Debris = p1.Debris
		local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
		local Timings = Settings.Timings
		local Other = Settings.Other
		local PetVisualController = require(ReplicatedStorage.Controllers.PetVisualController)
		local v12 = ModelUtils.new({
			CreateParticleHost = CreateParticleHost,
			Assets = Assets,
			Settings = Settings
		})
		local v2 = ItemModelUtils.new({
			ItemUtility = ItemUtility,
			ModelDownloader = p1.ModelDownloader
		})
		local v3 = ParticleUtils.new({
			CreateParticleHost = CreateParticleHost,
			Emit = Emit,
			Assets = Assets,
			Debris = Debris
		})
		local v4 = AnimationUtils.new({
			RenderStepped = RenderStepped,
			Easing = Easing,
			Settings = Settings,
			activeEggs = p1.activeEggs,
			Bezier = MathUtils.Bezier,
			autoControlPoint = MathUtils.autoControlPoint
		})
		local v5 = RollingAnimation.new({
			RenderStepped = RenderStepped,
			Easing = Easing,
			getItemToShow = v2.getItemToShow,
			normalizeItemModel = v12.normalizeItemModel,
			ensurePrimaryPart = v12.ensurePrimaryPart,
			setModelBaseParts = v12.setModelBaseParts
		})
		local v6 = BillboardUtils.new({
			TweenService = TweenService,
			billboardTemplate = CrateItemBillboard
		})
		local createCaseModel = v12.createCaseModel
		local normalizeItemModel = v12.normalizeItemModel
		local ensurePrimaryPart = v12.ensurePrimaryPart
		local setModelBaseParts = v12.setModelBaseParts
		local getItemToShow = v2.getItemToShow
		local emitParticles = v3.emitParticles
		local Egg = Assets.Particles:FindFirstChild("Egg")
		local v7 = if Egg then Egg:FindFirstChild("EggCrack") else nil
		local scaleModelIn = v4.scaleModelIn
		local moveModelToOffset = v4.moveModelToOffset
		local bounceModel = v4.bounceModel
		local hopSpinModel = v4.hopSpinModel
		local shakeModel = v4.shakeModel
		local animateLid = v4.animateLid
		local applyLegendaryLight = v4.applyLegendaryLight
		local performRollingAnimation = v5.performRollingAnimation
		local getCrateItemChance = v6.getCrateItemChance
		local formatChanceText = v6.formatChanceText
		local createItemBillboard = v6.createItemBillboard
		local lookAtTarget = MathUtils.lookAtTarget
		local function getPlayerPrimaryPart(p1) --[[ getPlayerPrimaryPart | Line: 128 ]]
			local Character = p1.Character
			assert(Character)
			local PrimaryPart = Character.PrimaryPart
			assert(PrimaryPart)
			return PrimaryPart
		end
		local function emitEggCrack(p1) --[[ emitEggCrack | Line: 136 | Upvalues: v7 (copy), Debris (copy) ]]
			if not v7 then
				return
			end
			local v1 = v7:Clone()
			if v1:IsA("BasePart") then
				v1.Anchored = true
				v1.CanCollide = false
				v1.CanQuery = false
				v1.CanTouch = false
				v1.Transparency = 1
				v1.CFrame = CFrame.new(p1)
			end
			v1.Parent = workspace
			local v2 = 0
			for i, v in ipairs(v1:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					v.Enabled = false
					local v3 = v:GetAttribute("EmitCount")
					local v4 = if typeof(v3) == "number" then v3 else v.Rate
					local v5 = v:GetAttribute("EmitDelay")
					local v6 = if typeof(v5) == "number" then v5 else 0
					local v8 = math.max(v2, v6 + v.Lifetime.Max)
					if v6 > 0 then
						task.delay(v6, function() --[[ Line: 167 | Upvalues: v (copy), v4 (copy) ]]
							if not v.Parent then
								return
							end
							v:Emit(v4)
						end)
						v2 = v8
						continue
					end
					v:Emit(v4)
					v2 = v8
				end
			end
			Debris:AddItem(v1, (math.max(v2, 1)))
		end
		local function getCrateData(p1) --[[ getCrateData | Line: 180 | Upvalues: SkinCrates (ref), EmoteCrates (ref), PetEggs (ref) ]]
			local v1 = SkinCrates[p1]
			if v1 then
				return v1
			end
			local v2 = EmoteCrates[p1]
			if v2 then
				return v2
			end
			local v3 = PetEggs[p1]
			if v3 then
				return v3
			else
				return nil
			end
		end
		local function getIsEmoteCrate(p1) --[[ getIsEmoteCrate | Line: 199 ]]
			if not (p1 and p1.Items) then
				return false
			end
			local v1 = false
			for i, v in ipairs(p1.Items) do
				if v.Currency == "ItemReward" then
					if v.CurrencyRewardInfo[1] ~= "Emotes" then
						return false
					end
					v1 = true
				end
			end
			return v1
		end
		return {
			performAnimation = function(p1) --[[ performAnimation | Line: 220 | Upvalues: SkinCrates (ref), EmoteCrates (ref), PetEggs (ref), getIsEmoteCrate (copy), createCaseModel (copy), emitEggCrack (copy), Soundbook (ref), Timings (copy), ItemUtility (copy), TierUtility (copy), scaleModelIn (copy), moveModelToOffset (copy), lookAtTarget (copy), emitParticles (copy), hopSpinModel (copy), Other (copy), bounceModel (copy), shakeModel (copy), animateLid (copy), applyLegendaryLight (copy), Easing (ref), RenderStepped (ref), getItemToShow (copy), normalizeItemModel (copy), ensurePrimaryPart (copy), setModelBaseParts (copy), MathUtils (ref), Players (ref), v1 (ref), performRollingAnimation (copy), PetVisualController (copy), ContentProvider (ref), getCrateItemChance (copy), formatChanceText (copy), createItemBillboard (copy), TweenService (ref), Debris (copy) ]]
				local player = p1.player
				local position = p1.position
				local caseId = p1.caseId
				local v12 = SkinCrates[caseId]
				local v2
				if v12 then
					v2 = v12
				else
					local v3 = EmoteCrates[caseId]
					if v3 then
						v2 = v3
					else
						local v4 = PetEggs[caseId]
						v2 = if v4 then v4 else nil
					end
				end
				local v5 = if v2 then v2.Color else v2
				local v6 = getIsEmoteCrate(v2)
				local v7 = if p1.itemType == "Pets" then true else false
				local v8, v9 = createCaseModel(p1, v7)
				local PrimaryPart = v8.PrimaryPart
				assert(PrimaryPart)
				local v10 = false
				local t = {}
				local function stopEggShakeSounds() --[[ stopEggShakeSounds | Line: 236 | Upvalues: t (copy) ]]
					for i, v in ipairs(t) do
						if v.Parent then
							v:Stop()
							v:Destroy()
						end
					end
					table.clear(t)
				end
				local function playEggShake(p1) --[[ playEggShake | Line: 246 | Upvalues: emitEggCrack (ref), Soundbook (ref), PrimaryPart (copy), t (copy) ]]
					emitEggCrack(p1)
					table.insert(t, (Soundbook.Sounds["Egg Shake"]:Play(PrimaryPart)))
				end
				task.wait((p1.partyIndex - 1) * Timings.DelayPerCase)
				local v11 = ItemUtility.GetItemDataFromItemType(p1.itemType, p1.itemId)
				local v122 = TierUtility:GetTier(1)
				if v11 and (v11.Data and v11.Data.Tier) then
					v122 = TierUtility:GetTier(v11.Data.Tier)
				end
				local v14 = if v122 == nil then false elseif v122.Tier == 5 then true else false
				local legendaryEffectDuration = Timings.legendaryEffectDuration
				local Character = player.Character
				assert(Character)
				local PrimaryPart_2 = Character.PrimaryPart
				assert(PrimaryPart_2)
				local Position = PrimaryPart_2:GetPivot().Position
				if v6 then
					Soundbook.Sounds.EmoteCrate:Play(PrimaryPart_2)
				end
				if not v6 then
					Soundbook.Sounds.CrateSpawn:Play(PrimaryPart)
				end
				scaleModelIn(v8)
				moveModelToOffset(v8, p1.origin, position)
				v8:PivotTo(lookAtTarget(v8:GetPivot(), Position))
				emitParticles("Impact", position, Timings.ImpactParticleLifetime, false)
				if not v6 then
					Soundbook.Sounds.CrateLand:Play(PrimaryPart)
				end
				local v15 = v8:GetPivot()
				if v6 then
					hopSpinModel(v8, v15, 1, Other.BounceHeight * 1.15, Timings.BounceDuration * 1.1, 0.75)
					task.wait(0.15)
				else
					bounceModel(v8, v15)
					task.wait(Timings.DramaticPauseDuration)
					task.wait(0.1)
					local v16 = v8:GetPivot()
					if v7 then
						shakeModel(v8, p1, v16, playEggShake)
					else
						Soundbook.Sounds.CrateShake:Play(PrimaryPart)
						shakeModel(v8, p1, v16)
					end
				end
				if v9.Parent then
					v9:Destroy()
				end
				local v17 = v8:GetPivot()
				local Light = v8:WaitForChild("Light")
				local SurfaceLight = Light:FindFirstChildOfClass("SurfaceLight")
				assert(SurfaceLight)
				SurfaceLight.Enabled = true
				local Top = v8:FindFirstChild("Top")
				if Top then
					animateLid(Top, Timings.LidOpenDegrees)
				end
				if not v6 then
					Soundbook.Sounds.CrateOpen:Play(PrimaryPart)
					emitParticles("Open", PrimaryPart.Position, Timings.OpenParticleLifetime, true, v5)
				end
				if v14 then
					applyLegendaryLight(SurfaceLight, math.random(legendaryEffectDuration[1], legendaryEffectDuration[2]))
				end
				if v6 then
					local v18 = 1 + -0.6799999999999999 * Easing.ExpoInOut(0.8933333333333334)
					local Position_2 = PrimaryPart.Position
					local v19 = false
					local EmoteCrateShrinkHighlight = Instance.new("Highlight")
					EmoteCrateShrinkHighlight.Name = "EmoteCrateShrinkHighlight"
					EmoteCrateShrinkHighlight.Adornee = v8
					EmoteCrateShrinkHighlight.FillColor = Color3.new(255/255, 255/255, 255/255)
					EmoteCrateShrinkHighlight.FillTransparency = 1
					EmoteCrateShrinkHighlight.OutlineColor = Color3.new(255/255, 255/255, 255/255)
					EmoteCrateShrinkHighlight.OutlineTransparency = 1
					EmoteCrateShrinkHighlight.Parent = workspace
					RenderStepped(function(p1, p2) --[[ Line: 337 | Upvalues: v19 (ref), Position_2 (ref), PrimaryPart (copy), emitParticles (ref), Timings (ref), Soundbook (ref), Light (copy), v18 (copy), Easing (ref), v8 (copy), EmoteCrateShrinkHighlight (copy) ]]
						local v1 = math.max(0, p2)
						local v2 = math.clamp(v1 / 0.75, 0, 1)
						local v3 = math.clamp((v1 - 0.67) / 0.22, 0, 1)
						if v1 >= 0.67 and not v19 then
							v19 = true
							Position_2 = PrimaryPart.Position
							emitParticles("EmoteReveal", Position_2, Timings.OpenParticleLifetime)
							Soundbook.Sounds.CrateLand:Play(PrimaryPart)
							Light.Transparency = 1
						end
						v8:ScaleTo((math.max(0.0001, if v3 > 0 then v18 + (0.0001 - v18) * Easing.ExpoIn(v3) else 1 + -0.6799999999999999 * Easing.ExpoInOut(v2))))
						local v6 = math.clamp(1 - Easing.ExpoInOut(v2) * 0.88, 0, 1)
						if v3 > 0 then
							v6 = math.clamp(v3, 0, 1)
						end
						EmoteCrateShrinkHighlight.FillTransparency = v6
						if not (v3 > 0) then
							return
						end
						for i, v in ipairs(v8:GetDescendants()) do
							if v:IsA("BasePart") then
								v.Transparency = math.clamp(v3, 0, 1)
							end
						end
					end, 0.89, true):Wait()
					if not v19 then
						Position_2 = PrimaryPart.Position
						emitParticles("EmoteReveal", Position_2, Timings.OpenParticleLifetime)
						Soundbook.Sounds.CrateLand:Play(PrimaryPart)
						Light.Transparency = 1
					end
					EmoteCrateShrinkHighlight:Destroy()
					v8:Destroy()
					local v20 = getItemToShow(p1.itemType, p1.itemName, p1.itemId, p1.caseId, player.UserId)
					if not v20 then
						warn("Could not load emote reveal model for:", p1.itemType, p1.itemName)
					else
						local v21 = normalizeItemModel(v20)
						ensurePrimaryPart(v21)
						setModelBaseParts(v21)
						for i, v in ipairs(v21:GetDescendants()) do
							if v:IsA("BasePart") then
								v.Anchored = false
							end
						end
						local PrimaryPart_3 = v21.PrimaryPart
						assert(PrimaryPart_3)
						PrimaryPart_3.Anchored = true
						v21.Parent = workspace
						v21:PivotTo(CFrame.new(Position_2 + Vector3.new(0, 2.4, 0)))
						v21:PivotTo(lookAtTarget(v21:GetPivot(), Position))
						local v22 = v21:GetPivot()
						RenderStepped(function(p1, p2) --[[ Line: 408 | Upvalues: player (copy), MathUtils (ref), v22 (copy), v21 (copy), Easing (ref) ]]
							local Character = player.Character
							assert(Character)
							local PrimaryPart = Character.PrimaryPart
							assert(PrimaryPart)
							local Position = PrimaryPart:GetPivot().Position
							local v2 = CFrame.new(MathUtils.Bezier(v22.Position, MathUtils.autoControlPoint(v22.Position, Position), Position)(p2)) * v22.Rotation
							local v3 = Vector3.new(Position.X, v2.Y, Position.Z)
							v21:PivotTo(if (v2.Position - v3).Magnitude < 0.001 then v2 else CFrame.lookAt(v2.Position, v3))
							v21:ScaleTo((math.max(0.02, 1 - Easing.ExpoIn(p2) * 0.92)))
						end, (Timings.ItemFlyIntoPlayerDuration + 0.2) * 2.4, true):Wait()
						local LocalPlayer = Players.LocalPlayer
						if LocalPlayer and LocalPlayer == player then
							v1:FireServer(p1.itemType, p1.itemId)
						end
						v21:Destroy()
					end
				else
					local Y = v8:GetExtentsSize().Y
					Soundbook.Sounds.CrateItemRoll:Play(PrimaryPart)
					local v23, v24 = performRollingAnimation(p1, v17, Position, player.UserId, Y)
					local v25 = v23
					if not v25 then
						local v26 = getItemToShow(p1.itemType, p1.itemName, p1.itemId, p1.caseId, player.UserId)
						if not v26 then
							warn("Could not load item model for:", p1.itemType, p1.itemName)
							stopEggShakeSounds()
							v8:Destroy()
						else
							v25 = normalizeItemModel(v26)
							ensurePrimaryPart(v25)
							v25.Parent = workspace
							v25:PivotTo(v17)
						end
					end
					if v25 and v7 then
						local v27 = PetVisualController:GetPetAnimations()[p1.itemName]
						task.defer(function() --[[ Line: 460 | Upvalues: ContentProvider (ref), v27 (copy) ]]
							ContentProvider:PreloadAsync({ v27.Idle.Id })
						end)
						local Animation = Instance.new("Animation")
						Animation.AnimationId = v27.Idle.Id
						local v28 = v25.AnimationController.Animator:LoadAnimation(Animation)
						v28.Priority = v27.Idle.Priority
						v28.Looped = v27.Idle.Looped
						v28:Play()
						Animation:Destroy()
					end
					v25:PivotTo(lookAtTarget(v25:GetPivot(), Position))
					local v29 = v25:GetPivot()
					if v24 and v24 < v29.Position.Y then
						v29 = CFrame.new(v29.Position.X, v24, v29.Position.Z) * v29.Rotation
					end
					local v30 = Other.ItemLookAtPlayerFloatHeight * 0.4
					local v31 = getCrateItemChance(p1, p1.itemType, p1.itemName)
					local v32 = ("%* - %*"):format(v122.Name, (formatChanceText(v31)))
					local v33 = v122.TierColor.Keypoints[1].Value
					local v34 = createItemBillboard(v25, p1.itemName, v32, v33, v25:GetExtentsSize().Y / 2 + 1.5)
					local PrimaryPart_3 = v25.PrimaryPart
					assert(PrimaryPart_3)
					if v7 then
						Soundbook:RenderAt(if v31 and v31 <= 15 then "Egg Better Hatch" else "Egg Normal Hatch", PrimaryPart_3.Position)
					elseif v31 and v31 < 0.1 then
						Soundbook.Sounds.CrateItemRare:Play(PrimaryPart_3)
					else
						Soundbook.Sounds.CrateItemNormal:Play(PrimaryPart_3)
					end
					local Main = v25:FindFirstChild("Main")
					emitParticles("Reveal", if Main and Main:IsA("BasePart") then Main.Position else PrimaryPart_3.Position, Timings.OpenParticleLifetime, true, v33)
					if v7 then
						emitParticles("Explode", PrimaryPart.Position, Timings.OpenParticleLifetime, true, v33)
						stopEggShakeSounds()
						v8:Destroy()
						v10 = true
					end
					if v14 then
						RenderStepped(function(p1, p2) --[[ Line: 521 | Upvalues: SurfaceLight (copy) ]]
							SurfaceLight.Color = Color3.fromHSV(p2 / 1.5 % 1, 1, 1)
						end, math.random(legendaryEffectDuration[1], legendaryEffectDuration[2]))
					end
					RenderStepped(function(p1, p2) --[[ Line: 527 | Upvalues: Other (ref), v29 (ref), v30 (copy), player (copy), v25 (ref) ]]
						local v4 = v29 + Vector3.new(0, -math.abs((math.sin(4.71238898038469 * p2 * Other.ItemLookAtPlayerFloatRate))) * v30, 0)
						local Character = player.Character
						assert(Character)
						local PrimaryPart = Character.PrimaryPart
						assert(PrimaryPart)
						local Position = PrimaryPart:GetPivot().Position
						local v5 = Vector3.new(Position.X, v4.Y, Position.Z)
						v25:PivotTo(if (v4.Position - v5).Magnitude < 0.001 then v4 else CFrame.lookAt(v4.Position, v5))
					end, Timings.ItemLookAtPlayerDuration + 2, true):Wait()
					local Size = v34.Size
					TweenService:Create(v34, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
						Size = UDim2.new(Size.X.Scale * 0.15, Size.X.Offset * 0.15, Size.Y.Scale * 0.15, Size.Y.Offset * 0.15)
					}):Play()
					Debris:AddItem(v34, 0.2)
					local v37 = v25:GetPivot()
					RenderStepped(function(p1, p2) --[[ Line: 559 | Upvalues: player (copy), MathUtils (ref), v37 (copy), v25 (ref), Easing (ref) ]]
						local Character = player.Character
						assert(Character)
						local PrimaryPart = Character.PrimaryPart
						assert(PrimaryPart)
						local Position = PrimaryPart:GetPivot().Position
						local v2 = CFrame.new(MathUtils.Bezier(v37.Position, MathUtils.autoControlPoint(v37.Position, Position), Position)(p2)) * v37.Rotation
						local v3 = Vector3.new(Position.X, v2.Y, Position.Z)
						v25:PivotTo(if (v2.Position - v3).Magnitude < 0.001 then v2 else CFrame.lookAt(v2.Position, v3))
						v25:ScaleTo(1 - Easing.ExpoIn(p2))
					end, Timings.ItemFlyIntoPlayerDuration, true):Wait()
					local LocalPlayer = Players.LocalPlayer
					if LocalPlayer and LocalPlayer == player then
						v1:FireServer(p1.itemType, p1.itemId)
					end
					v25:Destroy()
					if not v10 then
						SurfaceLight.Enabled = false
						if Top and not v6 then
							animateLid(Top, -Timings.LidOpenDegrees)
						end
						emitParticles("Explode", PrimaryPart.Position, Timings.OpenParticleLifetime, true)
						Light.Transparency = 1
						RenderStepped(function(p1, p2) --[[ Line: 600 | Upvalues: v8 (copy) ]]
							local v1 = math.clamp(p2, 0, 1)
							local v2 = math.clamp(v1 / 0.35, 0, 1)
							local v3 = math.clamp((v1 - 0.35) / 0.65, 0, 1)
							v8:ScaleTo((math.max(0.0001, if v1 < 0.35 then v2 * 0.10000000000000009 + 1 or v3 * -1.0999 + 1.1 else v3 * -1.0999 + 1.1)))
							for i, v in ipairs(v8:GetChildren()) do
								if v:IsA("BasePart") then
									v.Transparency = math.clamp(v1, 0, 1)
								end
							end
						end, Timings.GrowScaleDuration, true):Wait()
						stopEggShakeSounds()
						v8:Destroy()
					end
				end
			end
		}
	end
}