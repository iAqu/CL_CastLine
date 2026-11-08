-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local AntiCheatService = require(ServerScriptService.Controllers.AntiCheatService)
local Audio = require(ReplicatedStorage.Shared.Audio)

require(ReplicatedStorage.Shared.Globals.Constants)

local GameplayToolGuard = require(ServerScriptService.Library.Tools.Internal.GameplayToolGuard)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local t1 = {
    ScaleTo = function(p1, p2) -- ScaleTo | line: 40
        local Model = Instance.new("Model")

        p1.Parent = Model
        Model.PrimaryPart = p1
        Model:ScaleTo(p2)
        p1.Parent = nil
        Model:Destroy()
    end
}

function t1.Install(p3, p4) -- line: 49
    -- upvalues: Players (copy), ReplicatedStorage (copy), AntiCheatService (copy), Audio (copy), GameplayToolGuard (copy), Remotes (copy), t1 (copy)
    local Owner = p3:GetAttribute("Owner")
    local v1 = false
    local t2 = {}
    local connection
    local Hitbox = p3:WaitForChild("Hitbox")

    assert(Hitbox:IsA("BasePart"), "Trap Hitbox must be a BasePart")
    p3.CanTouch = true
    Hitbox.CanTouch = true

    local function createTrapBillboard(p5) -- line: 64
        local BillboardGui = Instance.new("BillboardGui")

        BillboardGui.Name = "TrapBillboard"
        BillboardGui.Size = UDim2.fromScale(6, 3)
        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
        BillboardGui.AlwaysOnTop = true
        BillboardGui.MaxDistance = 50

        local Frame = Instance.new("Frame")

        Frame.Size = UDim2.fromScale(1, 1)
        Frame.BackgroundTransparency = 1
        Frame.Parent = BillboardGui

        local TextLabel = Instance.new("TextLabel")

        TextLabel.Size = UDim2.fromScale(1, 0.4)
        TextLabel.Position = UDim2.new(0, 0, 0, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = "TRAPPED"
        TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        TextLabel.TextScaled = true
        TextLabel.Font = Enum.Font.SourceSansBold
        TextLabel.Parent = Frame

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = 2.5
        UIStroke.Parent = TextLabel

        local TextLabel2 = Instance.new("TextLabel")

        TextLabel2.Size = UDim2.fromScale(1, 0.5)
        TextLabel2.Position = UDim2.fromScale(0, 0.5)
        TextLabel2.BackgroundTransparency = 1
        TextLabel2.Text = tostring(7) .. "s"
        TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel2.TextScaled = true
        TextLabel2.Font = Enum.Font.SourceSansBold
        TextLabel2.Parent = Frame

        local UIStroke2 = Instance.new("UIStroke")

        UIStroke2.Thickness = 2.5
        UIStroke2.Parent = TextLabel2

        local Head = p5:FindFirstChild("Head")

        if Head then
            BillboardGui.Parent = Head
        else
            if not p5.PrimaryPart then
                BillboardGui:Destroy()

                return nil
            end

            BillboardGui.Parent = p5.PrimaryPart
        end

        task.spawn(function() -- line: 115
            -- upvalues: BillboardGui (copy), TextLabel2 (copy)
            for i = 7, 1, -1 do
                if not BillboardGui or not BillboardGui.Parent then
                    break
                end

                TextLabel2.Text = tostring(i) .. "s"
                task.wait(1)
            end

            if BillboardGui and BillboardGui.Parent then
                BillboardGui:Destroy()
            end
        end)

        return BillboardGui
    end

    local function getModelHeight(p6) -- line: 132
        if p6:FindFirstChild("HumanoidRootPart") or p6.PrimaryPart then
            local _, BoundingBox = p6:GetBoundingBox()

            return BoundingBox.Y / 2
        end

        error("HumanoidRootPart or PrimaryPart not found")

        return 2
    end

    local function getCharacterFromPart(p7) -- line: 143
        while true do
            if not p7 or p7 == workspace then
                return nil
            end

            if not (p7:IsA("Model") and p7:FindFirstChildOfClass("Humanoid")) then
                p7 = p7.Parent
                continue
            end

            break
        end

        return p7
    end

    local function positionCloseModel(p8) -- line: 158
        -- upvalues: p3 (copy)
        if p8:IsA("BasePart") then
            p8.CFrame = p3.CFrame * CFrame.Angles(-1.5707963267948966, 0, 0)
            p8.Anchored = true
        else
            if p8:IsA("PVInstance") then
                p8:PivotTo(p3.CFrame)
            end

            for _, descendant in p8:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                end
            end
        end
    end

    local function releaseTrappedCharacter(p9) -- line: 176
        -- upvalues: t2 (copy)
        local v3 = t2[p9]

        if not v3 then
            return
        end

        t2[p9] = nil

        local carrierConnection = v3.carrierConnection

        if carrierConnection then
            carrierConnection:Disconnect()
        end

        local trapStateConnection = v3.trapStateConnection

        if trapStateConnection then
            trapStateConnection:Disconnect()
        end

        local billboard = v3.billboard

        if billboard and billboard.Parent then
            billboard:Destroy()
        end

        local rootPart = v3.rootPart

        if rootPart and rootPart.Parent then
            rootPart.Anchored = v3.originalRootAnchored
        end

        local humanoid = v3.humanoid

        if humanoid then
            humanoid.JumpHeight = v3.originalJumpHeight
            humanoid.AutoRotate = v3.originalAutoRotate
            humanoid.PlatformStand = false
        end

        if p9 and p9.Parent then
            p9:SetAttribute("IsTrapped", nil)
        end
    end

    local function notifyTrapOwner(p10) -- line: 218
        -- upvalues: Owner (copy), Players (copy), Remotes (copy)
        if typeof(Owner) == "string" then
            local v4 = Players:FindFirstChild(Owner)

            if v4 and v4:IsA("Player") then
                Remotes.Alerts.Raise:FireClient(v4, {
                    Type = "Toast",
                    Lane = "Feed",
                    Seconds = 2,
                    Text = ("You <font color=\"#00FF00\">trapped</font> %*!"):format(p10.DisplayName),
                    Color = Color3.new(1, 1, 1)
                })
            end
        end
    end

    local function freezeCharacter(p11, p12) -- line: 237
        -- upvalues: t2 (copy), createTrapBillboard (copy), releaseTrappedCharacter (copy), notifyTrapOwner (copy), Players (copy), AntiCheatService (copy), Audio (copy), GameplayToolGuard (copy)
        if t2[p11] or p11:GetAttribute("IsTrapped") then
            return false
        end

        local Humanoid = p11:FindFirstChildOfClass("Humanoid")
        local v5 = p11:FindFirstChild("HumanoidRootPart") or p11.PrimaryPart

        if not (Humanoid and v5 and v5:IsA("BasePart")) then
            return false
        end

        local v6

        if p11:FindFirstChild("HumanoidRootPart") or p11.PrimaryPart then
            local _, BoundingBox = p11:GetBoundingBox()

            v6 = BoundingBox.Y / 2
        else
            v6 = 2
            error("HumanoidRootPart or PrimaryPart not found")
        end

        local v7 = p12 + Vector3.new(0, v6, 0)
        local PlayerFromCharacter = Players:GetPlayerFromCharacter(p11)

        if not (PlayerFromCharacter and GameplayToolGuard.DropHeldEggFromPlayerHit(PlayerFromCharacter)) then
            return false
        end

        local v8 = CFrame.new(v7)

        if not AntiCheatService.TeleportCharacter(PlayerFromCharacter, v8) then
            return false
        end

        local Anchored = v5.Anchored
        local JumpHeight, AutoRotate = Humanoid.JumpHeight, Humanoid.AutoRotate

        v5.Anchored = true
        Humanoid:UnequipTools()
        Humanoid.JumpHeight = 0
        Humanoid.AutoRotate = false
        Humanoid.PlatformStand = true
        p11:SetAttribute("IsTrapped", true)
        notifyTrapOwner(PlayerFromCharacter)

        local t3 = {
            character = p11,
            humanoid = Humanoid,
            rootPart = v5,
            originalRootAnchored = Anchored,
            originalJumpHeight = JumpHeight,
            originalAutoRotate = AutoRotate
        }

        t2[p11] = t3
        t3.billboard = createTrapBillboard(p11)
        Audio.Play(9091607929, v5.CFrame, {
            Volume = 1.3,
            MaxDistance = 70,
            PlaybackSpeed = { 0.9, 1.1 }
        })
        t3.carrierConnection = p11:GetAttributeChangedSignal("CarrierUserId"):Connect(function() -- line: 295
            -- upvalues: p11 (copy), releaseTrappedCharacter (copy)
            if p11:GetAttribute("CarrierUserId") ~= nil then
                releaseTrappedCharacter(p11)
            end
        end)
        t3.trapStateConnection = p11:GetAttributeChangedSignal("IsTrapped"):Connect(function() -- line: 304
            -- upvalues: p11 (copy), releaseTrappedCharacter (copy)
            if p11:GetAttribute("IsTrapped") ~= true then
                releaseTrappedCharacter(p11)
            end
        end)
        task.delay(7, function() -- line: 310
            -- upvalues: p11 (copy), t3 (copy), t2 (copy), releaseTrappedCharacter (copy)
            if t2[p11] == t3 then
                releaseTrappedCharacter(p11)
            end
        end)

        return true
    end

    local function activateTrap(p13) -- line: 321
        -- upvalues: p3 (copy), p4 (copy), v1 (ref), connection (ref), Hitbox (copy), positionCloseModel (copy), freezeCharacter (copy), ReplicatedStorage (copy), t1 (copy)
        if v1 or not p3.Parent or not freezeCharacter(p13, Hitbox.Position - Vector3.new(0, 1, 0) * (Hitbox.Size.Y / 2)) then
            return
        end

        v1 = true
        p3:SetAttribute("TrapActive", true)

        if connection then
            connection:Disconnect()
            connection = nil
        end

        local clone = ReplicatedStorage.Assets.Extra.ClosedTrap:Clone()

        if p4 ~= 1 then
            t1.ScaleTo(clone, p4)
        end

        positionCloseModel(clone)
        clone.Parent = p3
        p3.Transparency = 1
        p3.CanCollide = false
        p3.CanTouch = false
        task.delay(7.5, function() -- line: 350
            -- upvalues: clone (copy), p3 (copy)
            if clone and clone.Parent then
                clone:Destroy()
            end

            if p3 and p3.Parent then
                p3:Destroy()
            end
        end)
    end

    local function onTouched(p14) -- line: 361
        -- upvalues: p3 (copy), Owner (copy), v1 (ref), getCharacterFromPart (copy), activateTrap (copy), Players (copy), GameplayToolGuard (copy)
        if not v1 and p3.Parent and p14 and not p14:IsDescendantOf(p3) then
            local v10 = getCharacterFromPart(p14)

            if v10 then
                local PlayerFromCharacter = Players:GetPlayerFromCharacter(v10)

                if not PlayerFromCharacter or PlayerFromCharacter.Name ~= Owner then
                    local v11 = if PlayerFromCharacter then GameplayToolGuard.IsPlayerInGameplayArea(PlayerFromCharacter) else nil

                    if PlayerFromCharacter and v11 and GameplayToolGuard.IsHoldingEgg(PlayerFromCharacter) then
                        local Humanoid = v10:FindFirstChildOfClass("Humanoid")

                        if Humanoid and not (Humanoid.Health <= 0) then
                            activateTrap(v10)
                        end
                    end
                end
            end
        end
    end

    connection = Hitbox.Touched:Connect(onTouched)
end

return t1
