-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	new = function(p1) --[[ new | Line: 1 ]]
		local CreateParticleHost = p1.CreateParticleHost
		local Assets = p1.Assets
		local Settings = p1.Settings
		local function setModelBaseParts(p1) --[[ setModelBaseParts | Line: 6 ]]
			for i, v in ipairs(p1:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
					v.CanQuery = true
					v.CanTouch = true
					v.CastShadow = false
				end
			end
		end
		local function addCaseTrail(p1) --[[ addCaseTrail | Line: 18 | Upvalues: Assets (copy), Settings (copy) ]]
			local PrimaryPart = p1.PrimaryPart
			assert(PrimaryPart)
			local Bottom = Instance.new("Attachment")
			Bottom.Name = "Bottom"
			Bottom.Position = Vector3.new(0, -PrimaryPart.Size.Y / 2, 0)
			Bottom.Parent = PrimaryPart
			local Top = Instance.new("Attachment")
			Top.Name = "Top"
			Top.Position = Vector3.new(0, PrimaryPart.Size.Y / 2, 0)
			Top.Parent = PrimaryPart
			local v3 = Assets.Trail:Clone()
			v3.Attachment0 = Bottom
			v3.Attachment1 = Top
			v3.Lifetime = Settings.Timings.TrailLifetime
			v3.Parent = PrimaryPart
			return v3
		end
		local function getCreateToShow(p1, p2) --[[ getCreateToShow | Line: 41 | Upvalues: Assets (copy) ]]
			local v1 = nil
			if p2 then
				local Eggs = Assets:FindFirstChild("Eggs")
				if Eggs then
					v1 = Eggs:FindFirstChild(p1)
				end
				if not v1 and Eggs then
					v1 = Eggs:FindFirstChild("Egg")
				end
			end
			if not v1 then
				v1 = Assets.Cases:FindFirstChild(p1)
			end
			if not v1 then
				v1 = Assets.Cases:FindFirstChild("Valentine Emotes") or (Assets.Cases:FindFirstChild("Valentine Crate") or (Assets.Cases:FindFirstChild("Mystery Crate") or Assets.Cases:GetChildren()[1]))
			end
			assert(v1)
			return v1:Clone()
		end
		return {
			setModelBaseParts = setModelBaseParts,
			addCaseTrail = addCaseTrail,
			createCaseModel = function(p1, p2) --[[ createCaseModel | Line: 69 | Upvalues: getCreateToShow (copy), setModelBaseParts (copy), addCaseTrail (copy) ]]
				local v1 = getCreateToShow(p1.caseId, p2)
				if not v1.PrimaryPart then
					local Main = v1:FindFirstChild("Main")
					if Main and Main:IsA("BasePart") then
						v1.PrimaryPart = Main
					else
						local v2 = v1:FindFirstChildWhichIsA("BasePart", true)
						if v2 then
							v1.PrimaryPart = v2
						end
					end
				end
				if not v1:FindFirstChild("Light") then
					local Light = Instance.new("Part")
					Light.Name = "Light"
					Light.Size = Vector3.new(1, 1, 1)
					Light.Transparency = 1
					Light.Anchored = true
					Light.CanCollide = false
					Light.CanQuery = false
					Light.CanTouch = false
					Light.CFrame = v1:GetPivot()
					Light.Parent = v1
					local SurfaceLight = Instance.new("SurfaceLight")
					SurfaceLight.Enabled = false
					SurfaceLight.Parent = Light
				end
				v1:SetAttribute("Target", p1.position)
				v1:PivotTo(CFrame.new(p1.origin))
				setModelBaseParts(v1)
				local v3 = addCaseTrail(v1)
				v1:ScaleTo(0.001)
				v1.Parent = workspace
				return v1, v3
			end,
			normalizeItemModel = function(p1) --[[ normalizeItemModel | Line: 109 | Upvalues: CreateParticleHost (copy) ]]
				if p1:IsA("ParticleEmitter") then
					local Model = Instance.new("Model")
					local v1 = CreateParticleHost(CFrame.new())
					v1.Size = Vector3.new(1, 1, 1)
					v1.Parent = Model
					p1.Parent = v1
					Model.PrimaryPart = v1
					return Model
				else
					return p1
				end
			end,
			ensurePrimaryPart = function(p1) --[[ ensurePrimaryPart | Line: 122 ]]
				if p1.PrimaryPart then
					return
				end
				local Handle = p1:FindFirstChild("Handle")
				if Handle and Handle:IsA("BasePart") then
					p1.PrimaryPart = Handle
					return
				end
				local Main = p1:FindFirstChild("Main")
				if Main and Main:IsA("BasePart") then
					p1.PrimaryPart = Main
					return
				end
				local v1 = p1:FindFirstChildWhichIsA("BasePart", true)
				if not v1 then
					return
				end
				p1.PrimaryPart = v1
			end
		}
	end
}