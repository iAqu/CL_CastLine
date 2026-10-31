local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)

local CharacterUtil = {}

function CharacterUtil.TeleportTo(character: Model, cframe: CFrame)
	local currentCamera = Workspace.CurrentCamera
	currentCamera.CameraType = Enum.CameraType.Scriptable
	local cameraOffsetCFrame = cframe:toObjectSpace(currentCamera.CFrame)
	character:PivotTo(cframe)
	currentCamera.CFrame = cframe * cameraOffsetCFrame
	currentCamera.CameraType = Enum.CameraType.Custom

	if not character.PrimaryPart then warn("PrimaryPart not found"); return end

	character.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
	character.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
end

function CharacterUtil.SetColorToBlack(model: Model)
	for i, v in pairs(model:GetDescendants()) do
		if v:IsA("BasePart") then
			v.BrickColor = BrickColor.new("Really black")
		end
        if v:IsA("MeshPart") then
            v.TextureID = ""
        end
        if v:IsA("UnionOperation") then
            v.UsePartColor = true
		end
        if v:IsA("Pants") or v:IsA("Shirt") or v:IsA("Decal") then
            v.Color3 = Color3.new(0, 0, 0)
        end
        if v:IsA("SpecialMesh") then
            v.VertexColor = Vector3.new(0, 0, 0)
        end
	end
end

function CharacterUtil.HideNeonChildPart(model: Model)
	for i, v in pairs(model:GetDescendants()) do
		if v:IsA("BasePart") and v.Material == Enum.Material.Neon then
			v.Transparency = 1
		end
	end
end

function CharacterUtil.GetHrpHeight(character: Model)
	local humanoid = character:WaitForChild("Humanoid")
	if not humanoid then warn("Humanoid not found") return end
	local hrpHeight = (0.5 * character.HumanoidRootPart.Size.Y) + humanoid.HipHeight      -- https://create.roblox.com/docs/reference/engine/classes/Humanoid#HipHeight
	return hrpHeight
end

--[[ 体型系统已禁用：勿统一改 Humanoid 比例
function CharacterUtil.ScaleCharacter(character: Model, scale: number)
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.HeadScale.Value = scale
	humanoid.BodyHeightScale.Value = scale
	humanoid.BodyWidthScale.Value = scale
	humanoid.BodyDepthScale.Value = scale
end
]]

-- no fall down and upright
function CharacterUtil.MakeCharacterStable(character: Model)
	LogHelper.Print("MakeCharacterStable", character)

	if not character:FindFirstChild("HumanoidRootPart") then warn("HumanoidRootPart not found") return end
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then warn("Humanoid not found") return end

	humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)

	if character.HumanoidRootPart:FindFirstChild("StableBodyGyro") then
		character.HumanoidRootPart.StableBodyGyro:Destroy()
	end
	local bodyGyro = Instance.new("BodyGyro")
	bodyGyro.Name = "StableBodyGyro"
	bodyGyro.Parent = character.HumanoidRootPart
	bodyGyro.MaxTorque = Vector3.new(math.huge, 0, math.huge)
end

return CharacterUtil