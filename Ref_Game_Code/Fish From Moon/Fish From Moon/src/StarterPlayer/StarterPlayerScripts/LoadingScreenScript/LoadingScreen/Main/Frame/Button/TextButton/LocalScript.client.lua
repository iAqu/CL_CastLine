local button = script.Parent

button.MouseButton1Click:Connect(function()
	button.Parent.Parent.Parent.Parent.Enabled = false
end)