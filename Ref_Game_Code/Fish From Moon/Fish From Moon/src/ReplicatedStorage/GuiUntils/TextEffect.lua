local UITextEffect = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local player = game:GetService("Players").LocalPlayer

local TweenService = game:GetService("TweenService")

function UITextEffect.open(State,Amount)
	if State == "Materials" then
		local TempFolder = game:GetService("ReplicatedStorage").Assets.Gui.TextEffect
		local Temple = TempFolder:WaitForChild("Temple"):Clone()
		Temple.Rotation = math.random(-20,20)
		Temple.Position = UDim2.new(0.35,0,0.4,0)
		Temple.TextLabel.Text = "+"..Amount
		Temple.TextLabel.TextColor3=Color3.new(0.823529, 0.690196, 0.25098)
		Temple.Parent = player.PlayerGui:WaitForChild("EffectGui").Frame
		task.spawn(function()
			local fly =  TweenService:Create(Temple, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(0.34,0,0.13,0),
				Size = UDim2.new(0, 0, 0, 0)
			})
			fly:Play();
			fly.Completed:Connect(function()
				local powerUI = player.PlayerGui:WaitForChild("MainUi",5).MainHud.Top.Materials
				powerUI.Size=UDim2.fromScale(0.3,0.6)
				local oldSize=powerUI.Size
				local bigtween = TweenService:Create(
					powerUI,
					TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),
					{
						Size = UDim2.new(oldSize.X.Scale*1.2,0,oldSize.Y.Scale*1.2,0)
					}
				)
				bigtween:Play()
				bigtween.Completed:Connect(function()
					local smalltween = TweenService:Create(
						powerUI,
						TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),
						{
							Size = UDim2.new(oldSize.X.Scale,0,oldSize.Y.Scale,0)
						}
					)
					smalltween:Play()
					smalltween.Completed:Connect(function()
						Temple:Destroy()
					end)
				end)
			end)
		end)
	elseif State=="Weapons" then
		local TempFolder = game:GetService("ReplicatedStorage").Assets.Gui.TextEffect
		local Temple = TempFolder:WaitForChild("Temple"):Clone()
		Temple.Position = UDim2.new(0.48,0,0.15,0)
		Temple.Size = UDim2.new(0,0,0,0)
		Temple.TextLabel.Text = "+ "..Amount.." Fish"
		Temple.TextLabel.TextColor3=Color3.new(0.121569, 0.698039, 0.811765)
		Temple.Parent = player.PlayerGui:WaitForChild("EffectGui").Frame
		task.spawn(function()
			local fly =  TweenService:Create(Temple, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0.2, 0, 0.2, 0)
			})
			fly:Play();
			fly.Completed:Connect(function()
				local fly =  TweenService:Create(Temple, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Size = UDim2.new(0, 0, 0, 0)
				}):Play()
				local powerUI = player.PlayerGui:WaitForChild("MainUi",5).MainHud.Top.Materials
				powerUI.Size=UDim2.fromScale(0.3,0.6)
				local oldSize=powerUI.Size
				local bigtween = TweenService:Create(
					powerUI,
					TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),
					{
						Size = UDim2.new(oldSize.X.Scale*1.2,0,oldSize.Y.Scale*1.2,0)
					}
				)
				bigtween:Play()
				bigtween.Completed:Connect(function()
					local smalltween = TweenService:Create(
						powerUI,
						TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),
						{
							Size = UDim2.new(oldSize.X.Scale,0,oldSize.Y.Scale,0)
						}
					)
					smalltween:Play()
					smalltween.Completed:Connect(function()
						Temple:Destroy()
					end)
				end)
			end)
		end)
	elseif State=="Moneys" then
		local TempFolder = game:GetService("ReplicatedStorage").Assets.Gui.TextEffect
		local Temple = TempFolder:WaitForChild("Temple"):Clone()
		Temple.Rotation = 20
		Temple.Position = UDim2.new(0.65,0,0.2,0)
		Temple.TextLabel.Text = "+"..Amount
		Temple.TextLabel.TextColor3=Color3.new(0.286275, 0.713725, 0)
		Temple.Parent = player.PlayerGui:WaitForChild("EffectGui").Frame
		task.spawn(function()
			local fly =  TweenService:Create(Temple, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(0.65,0,0.15,0),
			})
			fly:Play();
			fly.Completed:Connect(function()
				local powerUI = player.PlayerGui:WaitForChild("MainUi",5).MainHud.Top.Moneys
				powerUI.Size=UDim2.fromScale(0.3,0.6)
				local oldSize=powerUI.Size
				local bigtween = TweenService:Create(
					powerUI,
					TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),
					{
						Size = UDim2.new(oldSize.X.Scale*1.2,0,oldSize.Y.Scale*1.2,0)
					}
				)
				bigtween:Play()
				bigtween.Completed:Connect(function()
					local smalltween = TweenService:Create(
						powerUI,
						TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),
						{
							Size = UDim2.new(oldSize.X.Scale,0,oldSize.Y.Scale,0)
						}
					)
					smalltween:Play()
					smalltween.Completed:Connect(function()
						Temple:Destroy()
					end)
				end)
			end)
		end)
	end
end

return UITextEffect