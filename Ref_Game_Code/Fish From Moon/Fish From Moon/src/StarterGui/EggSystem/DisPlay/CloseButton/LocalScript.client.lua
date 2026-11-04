script.Parent.MouseButton1Click:Connect(function() 
	
	if script.Parent.Parent.Visible then
		require(game:GetService("ReplicatedStorage").GuiUtils.Luck).closePreview()
	end	
	
end)