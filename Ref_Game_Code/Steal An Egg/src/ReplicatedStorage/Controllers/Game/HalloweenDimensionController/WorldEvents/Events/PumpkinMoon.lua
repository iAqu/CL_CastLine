-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Audio = require(ReplicatedStorage.Shared.Audio)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local PumpkinDeposit = require(script.Parent.Parent.PumpkinDeposit)
local PumpkinHud = require(script.Parent.Parent.PumpkinHud)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)

require(ReplicatedStorage.Packages.Trove)

local TutorialBeam = require(ReplicatedStorage.Client.WorldFX.TutorialBeam)

require(script.Parent.Parent.Types)

local LocalPlayer = Players.LocalPlayer
local PumpkinPickup = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("HalloweenDimension"):WaitForChild("Sounds"):WaitForChild("PumpkinPickup")
local Attributes, PlayerAttributes = HalloweenDimension.Attributes, HalloweenDimension.PlayerAttributes
local v1 = Color3.fromRGB(255, 160, 50)
local v2 = Color3.fromRGB(80, 35, 5)

local function child(p1, p2, p3) -- line: 38
    local v3 = p1:FindFirstChild(p2)

    assert(v3 ~= nil and v3:IsA(p3), (("%* is missing %* %*"):format(p1:GetFullName(), p3, p2)))

    return v3
end

local function targetOf(p4, p5) -- line: 44
    local Target = p4:FindFirstChild("Target")

    if Target ~= nil and Target:IsA("Attachment") then
        return Target
    end

    local v6 = p5:Add(Instance.new("Attachment"))

    v6.Name = "LocalTarget"
    v6.Position = Vector3.new(0, -p4.Size.Y * 0.5, 0)
    v6.Parent = p4

    return v6
end

local function altarOf(p6, p7) -- line: 56
    -- upvalues: targetOf (copy)
    local Glow = p6:FindFirstChild("Glow")
    local Value = if Glow == nil or not Glow:IsA("ObjectValue") then nil else Glow.Value

    return {
        Target = targetOf(p6, p7),
        Plate = if Value == nil or not Value:IsA("BasePart") then nil else Value
    }
end

local function departure(p8) -- line: 65
    -- upvalues: PlayerAttributes (copy)
    local Attribute = p8:GetAttribute(PlayerAttributes.PumpkinDepositFrom)

    if typeof(Attribute) == "CFrame" then
        return Attribute
    end

    local Character = p8.Character
    local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart.CFrame * CFrame.new(0, 0, -5) else nil
end

local function toastDeposit(p9) -- line: 78
    -- upvalues: Toast (copy), v1 (copy), v2 (copy)
    Toast.Show({
        Lane = "Feed",
        Seconds = 2.5,
        Text = if p9 == 1 then "+1 Pumpkin Deposited!" else ("+%* Pumpkins Deposited!"):format(p9),
        Color = v1,
        StrokeColor = v2
    })
end

local function bindAltar(p10, p11, p12) -- line: 88
    -- upvalues: Players (copy), Audio (copy), PumpkinDeposit (copy), Toast (copy), TutorialBeam (copy), LocalPlayer (copy), PumpkinPickup (copy), Attributes (copy), PlayerAttributes (copy), v1 (copy), v2 (copy), altarOf (copy), departure (copy)
    local v8 = altarOf(p11, p12)
    local v9

    local function syncOpen() -- line: 92
        -- upvalues: p11 (copy), p12 (copy), v8 (copy), v9 (ref), PumpkinDeposit (copy), Attributes (copy)
        local v10 = p11:GetAttribute(Attributes.GateOpen) == true
        local v11 = v9

        if v10 ~= (v11 ~= nil) then
            if v11 ~= nil then
                v9 = nil
                p12:Remove(v11)
            else
                local v12 = p12:Extend()

                v9 = v12
                PumpkinDeposit.Beacon(v12, v8)
            end
        end
    end

    p12:Connect(p11:GetAttributeChangedSignal(Attributes.GateOpen), syncOpen)
    syncOpen()

    local v13 = true

    p12:Add(function() -- line: 111
        -- upvalues: v13 (ref)
        v13 = false
    end)

    local v14 = nil

    local function syncBeam(p13) -- line: 116
        -- upvalues: p12 (copy), v8 (copy), v13 (ref), v14 (ref), TutorialBeam (copy)
        local v15 = v14

        if p13 ~= (v15 ~= nil) then
            if v15 ~= nil then
                v14 = nil
                p12:Remove(v15)
            else
                local v16 = p12:Extend()

                v14 = v16
                task.spawn(function() -- line: 128
                    -- upvalues: v16 (copy), v8 (copy), v13 (ref), v14 (ref), TutorialBeam (copy)
                    local v17 = TutorialBeam.Attach(v8.Target.WorldPosition + Vector3.new(0, 2, 0))

                    if not v13 or v14 ~= v16 then
                        TutorialBeam.Destroy(v17)
                    else
                        v16:Add(function() -- line: 132
                            -- upvalues: v17 (copy), TutorialBeam (copy)
                            TutorialBeam.Destroy(v17)
                        end)
                    end
                end)
            end
        end
    end

    p12:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.PumpkinCarrying), function() -- line: 143
        -- upvalues: syncBeam (copy), Audio (copy), LocalPlayer (copy), PumpkinPickup (copy), PlayerAttributes (copy)
        local v18 = LocalPlayer:GetAttribute(PlayerAttributes.PumpkinCarrying) == true

        if v18 then
            Audio.Play(PumpkinPickup, script)
        end

        syncBeam(v18)
    end)
    syncBeam(LocalPlayer:GetAttribute(PlayerAttributes.PumpkinCarrying) == true)

    local t3 = {}

    local function count(p14) -- line: 154
        -- upvalues: PlayerAttributes (copy)
        local Attribute = p14:GetAttribute(PlayerAttributes.Pumpkins)

        return if type(Attribute) == "number" then Attribute else nil
    end

    local function watch(p15) -- line: 159
        -- upvalues: p10 (copy), p12 (copy), v8 (copy), t3 (copy), PumpkinDeposit (copy), Toast (copy), LocalPlayer (copy), PlayerAttributes (copy), v1 (copy), v2 (copy), departure (copy)
        if t3[p15] ~= nil then
            return
        end

        local v19 = p12:Extend()

        t3[p15] = v19

        local Attribute = p15:GetAttribute(PlayerAttributes.Pumpkins)
        local Attribute2 = if type(Attribute) == "number" then Attribute else nil

        v19:Connect(p15:GetAttributeChangedSignal(PlayerAttributes.Pumpkins), function() -- line: 166
            -- upvalues: p15 (copy), Attribute2 (ref), p10 (copy), p12 (copy), v8 (copy), PumpkinDeposit (copy), Toast (copy), LocalPlayer (copy), PlayerAttributes (copy), v1 (copy), v2 (copy), departure (copy)
            local Attribute = p15:GetAttribute(PlayerAttributes.Pumpkins)

            if type(Attribute) ~= "number" then
                Attribute = nil
            end

            local Attribute3 = Attribute2

            Attribute2 = Attribute

            if Attribute == nil or Attribute <= (Attribute3 or 0) then
                return
            end

            local v20 = Attribute - (Attribute3 or 0)
            local v21

            if p15 == LocalPlayer then
                v21 = function() -- line: 175
                    -- upvalues: v20 (copy), Toast (copy), v1 (copy), v2 (copy)
                    Toast.Show({
                        Lane = "Feed",
                        Seconds = 2.5,
                        Text = if v20 == 1 then "+1 Pumpkin Deposited!" else ("+%* Pumpkins Deposited!"):format(v20),
                        Color = v1,
                        StrokeColor = v2
                    })
                end
            end

            local v22 = departure(p15)

            if v22 ~= nil then
                PumpkinDeposit.Play(p12, v22, v8, p10:FindFirstChild("RunawayPumpkins"), v21)
            elseif v21 ~= nil then
                v21()
            end
        end)
    end

    for _, player in Players:GetPlayers() do
        watch(player)
    end

    p12:Connect(Players.PlayerAdded, watch)
    p12:Connect(Players.PlayerRemoving, function(p16) -- line: 192
        -- upvalues: p12 (copy), t3 (copy)
        local v23 = t3[p16]

        if v23 ~= nil then
            t3[p16] = nil
            p12:Remove(v23)
        end
    end)
end

local function bind(p17, p18) -- line: 201
    -- upvalues: PumpkinHud (copy), bindAltar (copy)
    local Altar = p17:FindFirstChild("Altar")

    assert(Altar ~= nil and Altar:IsA("Model"), (("%* is missing Model Altar"):format((p17:GetFullName()))))

    local PumpkinDeposit = Altar:FindFirstChild("PumpkinDeposit")

    if PumpkinDeposit == nil or not PumpkinDeposit:IsA("BasePart") then
        local v26 = p18:Extend()

        v26:Connect(Altar.ChildAdded, function(p19) -- line: 208
            -- upvalues: p17 (copy), p18 (copy), v26 (copy), bindAltar (copy)
            if p19.Name == "PumpkinDeposit" and p19:IsA("BasePart") then
                p18:Remove(v26)
                bindAltar(p17, p19, p18)
            end
        end)
    else
        bindAltar(p17, PumpkinDeposit, p18)
    end

    PumpkinHud.Bind(p18)
end

local t5 = {
    Preset = "HalloweenPumpkinMoon",
    Id = HalloweenDimension.WorldEvents.PumpkinMoon,
    MoonColor = Color3.fromRGB(255, 140, 30),
    Bind = bind
}

return table.freeze(t5)
