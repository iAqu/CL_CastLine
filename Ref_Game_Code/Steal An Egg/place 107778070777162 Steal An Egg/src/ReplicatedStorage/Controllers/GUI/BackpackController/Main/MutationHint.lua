-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Save = require(ReplicatedStorage.Shared.Save)
local Trove = require(ReplicatedStorage.Packages.Trove)

return function(p1, p2) -- line: 9
    -- upvalues: Players (copy), UserInputService (copy), Workspace (copy), Save (copy), Trove (copy)
    local LocalPlayer = Players.LocalPlayer
    local v1 = Trove.new()
    local v2 = Trove.new()

    v1:Add(v2)

    local v3
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "MutationHint"
    TextLabel.AnchorPoint = Vector2.new(0.5, 1)
    TextLabel.Position = UDim2.new(0.5, 0, 0, -8)
    TextLabel.Size = UDim2.new(1, 0, 0, 52.5)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    TextLabel.TextStrokeTransparency = 0.25
    TextLabel.Text = "Click on an egg to apply the mutation"
    TextLabel.TextSize = 25
    TextLabel.TextScaled = true
    TextLabel.TextWrapped = false
    TextLabel.Active = false
    TextLabel.ZIndex = 10
    TextLabel.Visible = false

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 25
    UITextSizeConstraint.Parent = TextLabel
    TextLabel.Parent = p1
    v1:Add(TextLabel)

    local v4 = Trove.new()

    v1:Add(v4)

    local function updateLayout() -- line: 41
        -- upvalues: p1 (copy), TextLabel (copy), UITextSizeConstraint (copy), UserInputService (copy), Workspace (copy)
        local CurrentCamera = Workspace.CurrentCamera
        local ViewportSize, v5, TouchEnabled, v6

        if not CurrentCamera or p1.Size.X.Offset <= 0 or p1.AbsoluteSize.X <= 0 then
            return
        else
            ViewportSize = CurrentCamera.ViewportSize
            v5 = p1.AbsoluteSize.X / p1.Size.X.Offset
            TouchEnabled = UserInputService.TouchEnabled
            v6 = if TouchEnabled then math.min(ViewportSize.X, ViewportSize.Y) * 0.052 else ViewportSize.Y * 0.03148148148148148
        end

        local v8 = math.max(v6, 14)
        local v9 = ViewportSize.X * (if TouchEnabled then 0.76 else 0.7)
        local v10 = v8 / v5

        TextLabel.Size = UDim2.fromOffset(v9 / v5, v10 * 1.3)
        TextLabel.Position = UDim2.new(0.5, 0, 0, -math.max(8, ViewportSize.Y * 0.012) / v5)
        UITextSizeConstraint.MinTextSize = 1
        UITextSizeConstraint.MaxTextSize = math.max(1, (math.floor(v10 + 0.5)))
        TextLabel.TextSize = UITextSizeConstraint.MaxTextSize
    end

    local function bindCamera() -- line: 62
        -- upvalues: v4 (copy), updateLayout (copy), Workspace (copy)
        v4:Clean()

        local CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera then
            v4:Connect(CurrentCamera:GetPropertyChangedSignal("ViewportSize"), updateLayout)
        end

        updateLayout()
    end

    v1:Connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), bindCamera)
    v1:Connect(p1:GetPropertyChangedSignal("AbsoluteSize"), updateLayout)
    v1:Connect(UserInputService:GetPropertyChangedSignal("TouchEnabled"), updateLayout)
    v4:Clean()

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera then
        v4:Connect(CurrentCamera:GetPropertyChangedSignal("ViewportSize"), updateLayout)
    end

    updateLayout()

    local function refresh() -- line: 75
        -- upvalues: p2 (copy), v3 (ref), TextLabel (copy), Save (copy)
        TextLabel.Visible = false
        TextLabel.Text = "Click on an egg to apply the mutation"

        local v14 = Save.Peek()

        if not p2.Visible and v3 and v14 ~= nil and v14.BossMastery and not v14.BossMastery.HasUsedMutationConsumable then
            local Humanoid = v3:FindFirstChildOfClass("Humanoid")

            if Humanoid and not (Humanoid.Health <= 0) then
                for _, child in v3:GetChildren() do
                    if child:IsA("Tool") and child:GetAttribute("ItemType") == "MutationConsumable" then
                        local v15 = child:GetAttribute("MutationId") or "Boss"

                        if v15 == "Boss" or v15 == "Scrambled" or v15 == "Nitro" or v15 == "Spectral" then
                            TextLabel.Visible = true

                            return
                        end
                    end
                end
            end
        end
    end

    local function bindCharacter(p3) -- line: 100
        -- upvalues: v2 (copy), v3 (ref), refresh (copy)
        v2:Clean()
        v3 = p3

        if p3 then
            local function watchChild(p4) -- line: 104
                -- upvalues: v2 (copy), refresh (copy)
                if p4:IsA("Humanoid") then
                    v2:Connect(p4.Died, refresh)
                end
            end

            for _, child in p3:GetChildren() do
                if child:IsA("Humanoid") then
                    v2:Connect(child.Died, refresh)
                end
            end

            v2:Connect(p3.ChildAdded, function(p5) -- line: 112
                -- upvalues: v2 (copy), refresh (copy)
                if p5:IsA("Humanoid") then
                    v2:Connect(p5.Died, refresh)
                end

                refresh()
            end)
            v2:Connect(p3.ChildRemoved, refresh)
        end

        refresh()
    end

    v1:Connect(LocalPlayer.CharacterAdded, bindCharacter)
    v1:Connect(LocalPlayer.CharacterRemoving, function() -- line: 122
        -- upvalues: v2 (copy), v3 (ref), refresh (copy)
        v2:Clean()
        v3 = nil
        refresh()
    end)
    v1:Connect(p2:GetPropertyChangedSignal("Visible"), refresh)
    v1:Add(task.spawn(function() -- line: 126
        -- upvalues: refresh (copy), Save (copy)
        if Save.Await() ~= nil then
            refresh()
        end
    end))
    v1:Add(Save.WatchFields("BossMastery", refresh))
    v1:Connect(p1.Destroying, function() -- line: 132
        -- upvalues: v1 (copy)
        v1:Destroy()
    end)
    bindCharacter(LocalPlayer.Character)
end
