-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local UserAbilitiesUserInterfaceD = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil").getUserFlag("UserAbilitiesUserInterfaceD")
local v1 = require(script.Parent:WaitForChild("AvatarAbilitiesInterface")).get(Players.LocalPlayer)

return {
    create = function(p1, p2, p3, p4, p5, p6, p7) -- create | line: 30
        -- upvalues: UserAbilitiesUserInterfaceD (copy), v1 (copy)
        local v2 = "rbxassetid://136780077406114"
        local v3 = "rbxassetid://76895455502876"
        local ButtonInvalidAssetId
        local v4 = false
        local v5 = false
        local v6

        if p3.ButtonAssetId then
            local ButtonAssetId = p3.ButtonAssetId

            v6 = ButtonAssetId
            v2 = ButtonAssetId
        else
            v6 = "rbxassetid://136780077406114"
        end

        if p3.ButtonPressedAssetId then
            v3 = p3.ButtonPressedAssetId
        end

        if p3.ButtonInvalidAssetId then
            ButtonInvalidAssetId = p3.ButtonInvalidAssetId
        end

        local ImageButton = Instance.new("ImageButton")

        ImageButton.Name = p2 .. "Button"
        ImageButton.Visible = false
        ImageButton.BackgroundTransparency = 1
        ImageButton.Image = v6
        ImageButton.Parent = p1.parentUIFrame

        for _, child in p4:GetChildren() do
            if string.find(child.Name, "Touch") and child:IsA("InputBinding") then
                child.UIButton = ImageButton
                break
            end
        end

        local function ResizeButton() -- line: 60
            -- upvalues: p1 (copy), p5 (copy), p6 (copy), ImageButton (copy)
            local small = math.min(p1.parentUIFrame.AbsoluteSize.x, p1.parentUIFrame.AbsoluteSize.y) <= 500 and p5.small or p5.large
            local v7 = small[1]
            local v8 = small[2]
            local v9 = small[3]
            local v10 = -v8 - v7

            ImageButton.Size = UDim2.new(0, v7, 0, v7)

            if p6 then
                ImageButton.Position = UDim2.new(1, v10, 0, v9)
            else
                local v11 = -v9 - v7

                ImageButton.Position = UDim2.new(1, v10, 1, v11)
            end
        end

        ResizeButton()

        local t2 = {}

        table.insert(t2, p1.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeButton))

        local function UpdateButtonState() -- line: 87
            -- upvalues: p1 (copy), p2 (copy), p4 (copy), p7 (copy), v2 (ref), v3 (ref), ButtonInvalidAssetId (ref), v4 (ref), v5 (ref), ImageButton (copy), UserAbilitiesUserInterfaceD (copy), v1 (copy)
            if ImageButton.Parent ~= nil then
                if UserAbilitiesUserInterfaceD then
                    local AbilityUIState = v1:GetAbilityUIState(p2)
                    local v12 = v4 or v5
                    local v13 = AbilityUIState == 0

                    ImageButton.Visible = p1.enabled and p4.Enabled and (p7 or not v13)

                    if ImageButton.Visible then
                        if AbilityUIState == 1 or v13 then
                            if ButtonInvalidAssetId then
                                ImageButton.Image = ButtonInvalidAssetId
                                ImageButton.ImageTransparency = 0
                            else
                                ImageButton.Image = v2
                                ImageButton.ImageTransparency = 0.6
                            end
                        else
                            if AbilityUIState == 3 or v12 then
                                ImageButton.Image = v3
                            else
                                ImageButton.Image = v2
                            end

                            ImageButton.ImageTransparency = 0
                        end
                    end
                else
                    local AbilityValid = v1:GetAbilityValid(p2)
                    local AbilityActive = v1:GetAbilityActive(p2)
                    local v14 = v4 or v5

                    ImageButton.Visible = p1.enabled and p4.Enabled

                    if ImageButton.Visible then
                        if AbilityActive or v14 and AbilityValid then
                            ImageButton.Image = v3
                            ImageButton.ImageTransparency = 0
                        elseif AbilityValid then
                            ImageButton.Image = v2
                            ImageButton.ImageTransparency = 0
                        elseif ButtonInvalidAssetId then
                            ImageButton.Image = ButtonInvalidAssetId
                            ImageButton.ImageTransparency = 0
                        else
                            ImageButton.Image = v2
                            ImageButton.ImageTransparency = 0.6
                        end
                    end
                end
            end
        end

        UpdateButtonState()

        local function FireSelectionActivation(p8) -- line: 141
            -- upvalues: p4 (copy)
            local SelectionActivateBinding = p4:FindFirstChild("SelectionActivateBinding")

            if not SelectionActivateBinding then
                SelectionActivateBinding = Instance.new("InputBinding")
                SelectionActivateBinding.Name = "SelectionActivateBinding"
                SelectionActivateBinding.Type = Enum.InputBindingType.Scriptable
                SelectionActivateBinding.Parent = p4
            end

            SelectionActivateBinding:Fire(p8)
        end

        ImageButton.MouseButton1Down:Connect(function() -- line: 152
            -- upvalues: v4 (ref), UpdateButtonState (copy)
            v4 = true
            UpdateButtonState()
        end)
        ImageButton.MouseButton1Up:Connect(function() -- line: 157
            -- upvalues: v4 (ref), UpdateButtonState (copy)
            v4 = false
            UpdateButtonState()
        end)
        ImageButton.MouseLeave:Connect(function() -- line: 162
            -- upvalues: v4 (ref), UpdateButtonState (copy)
            v4 = false
            UpdateButtonState()
        end)

        if UserAbilitiesUserInterfaceD then
            table.insert(t2, v1:GetAbilityUIStateChangedSignal(p2):Connect(UpdateButtonState))
        else
            table.insert(t2, v1:GetAbilityActiveChangedSignal(p2):Connect(UpdateButtonState))
            table.insert(t2, v1:GetAbilityValidChangedSignal(p2):Connect(UpdateButtonState))
        end

        table.insert(t2, p1.enabledChangedEvent.Event:Connect(UpdateButtonState))
        table.insert(t2, p4:GetPropertyChangedSignal("Enabled"):Connect(UpdateButtonState))
        ImageButton.Destroying:Connect(function() -- line: 185
            -- upvalues: t2 (copy)
            for _, v15 in t2 do
                v15:Disconnect()
            end

            table.clear(t2)
        end)

        local t3 = {
            instance = ImageButton
        }

        function t3.Destroy(_) -- line: 196
            -- upvalues: ImageButton (copy)
            ImageButton:Destroy()
        end

        function t3.SetSelectionPressed(_, p11) -- line: 200
            -- upvalues: p4 (copy), v5 (ref), UpdateButtonState (copy)
            if v5 == p11 then
                return
            end

            v5 = p11

            local SelectionActivateBinding = p4:FindFirstChild("SelectionActivateBinding")

            if not SelectionActivateBinding then
                SelectionActivateBinding = Instance.new("InputBinding")
                SelectionActivateBinding.Name = "SelectionActivateBinding"
                SelectionActivateBinding.Type = Enum.InputBindingType.Scriptable
                SelectionActivateBinding.Parent = p4
            end

            SelectionActivateBinding:Fire(p11)
            UpdateButtonState()
        end

        return t3
    end
}
