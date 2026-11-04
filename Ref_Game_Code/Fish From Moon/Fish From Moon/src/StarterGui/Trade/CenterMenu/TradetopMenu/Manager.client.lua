local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes=ReplicatedStorage:WaitForChild("Remotes")

local screenGui=script.Parent
local frame=screenGui.Menu.Menu
local mesage=frame.TextLabel
local accept=frame.L
local exitButton=frame.R

local Trader

local MESSAGE_TEMPLATE=" has invited you to trade!"

local function DisplayGui(trader:Player)
	Trader=trader
	--screenGui.Size=UDim2.new(0.515, 0,0.54, 0)
	screenGui.Visible=true
	mesage.Text=trader.DisplayName..MESSAGE_TEMPLATE
end

accept.MouseButton1Click:Connect(function()
	Remotes.AcceptTradeRequest:FireServer(Trader.UserId)
	screenGui.Visible=false
end)

exitButton.MouseButton1Click:Connect(function()
	screenGui.Visible=false
end)

Remotes.TradeRequestReceived.OnClientEvent:Connect(DisplayGui)