-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Products = require(Shared.Data.Products)
local EggModels = require(Shared.EggModels)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local HUD = require(script.Parent.HUD)
local HeldFish = require(script.Parent.HeldFish)
local Pad = require(script.Parent.Pad)
local t1 = {
    Key = nil,
    Placed = 0
}
local LocalPlayer = Players.LocalPlayer
local v1, v2, v3, v4, v5, v6
local n1 = 0

local function count(p1) -- line: 31
    -- upvalues: DataClient (copy)
    local n2 = 0

    for _, v7 in ipairs(DataClient.Get("Eggs") or {}) do
        if v7 == p1 then
            n2 += 1
        end
    end

    return n2
end

local function nameOf(p2) -- line: 41
    -- upvalues: Products (copy)
    for _, v8 in ipairs(Products.Crates) do
        if v8.key == p2 then
            return v8.name
        end
    end

    return "Egg"
end

local function ownWater() -- line: 50
    -- upvalues: LocalPlayer (copy)
    local v9 = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Plots")

    for _, v10 in ipairs(v9 and v9:GetChildren() or {}) do
        if v10:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            local Pond = v10:FindFirstChild("Pond")
            local Water = Pond and Pond:FindFirstChild("Water")

            return if Water and Water:IsA("BasePart") then Water else nil
        end
    end

    return nil
end

local function pointOnPond(p3) -- line: 63
    -- upvalues: ownWater (copy)
    local v11 = ownWater()
    local CurrentCamera = workspace.CurrentCamera

    if not v11 or not CurrentCamera then
        return nil
    end

    local v12 = CurrentCamera:ScreenPointToRay(p3.X, p3.Y)
    local v13 = v11.Position.Y + v11.Size.Y / 2

    if math.abs(v12.Direction.Y) < 1E-04 then
        return nil
    end

    local v14 = (v13 - v12.Origin.Y) / v12.Direction.Y

    if v14 <= 0 then
        return nil
    end

    local v15 = v12.Origin + v12.Direction * v14
    local v16 = v11.CFrame:PointToObjectSpace(v15)

    return if math.abs(v16.X) <= v11.Size.X / 2 + 2.5 and math.abs(v16.Z) <= v11.Size.Z / 2 + 2.5 then v15 else nil
end

local function shoulders(p4) -- line: 86
    local t2 = {}

    for _, v19 in ipairs({ "Right", "Left" }) do
        local v20 = p4:FindFirstChild(v19 .. "UpperArm")
        local v21 = v20 and v20:FindFirstChild(v19 .. "Shoulder")

        if v21 then
            table.insert(t2, {
                r15 = true,
                sign = 1,
                joint = v21
            })
        else
            local Torso = p4:FindFirstChild("Torso")
            local v22 = Torso and Torso:FindFirstChild(v19 .. " Shoulder")

            if v22 then
                table.insert(t2, {
                    r15 = false,
                    joint = v22,
                    sign = v19 == "Right" and 1 or -1
                })
            end
        end
    end

    return t2
end

local function refreshText() -- line: 104
    -- upvalues: UserInputService (copy), Products (copy), Pad (copy), t1 (copy), v3 (ref), v4 (ref), count (copy)
    if t1.Key then
        local v23 = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
        local v24 = v3
        local Key = t1.Key
        local v25 = false
        local v26

        for _, v27 in ipairs(Products.Crates) do
            if v27.key == Key then
                v26 = v27.name
                v25 = true
                break
            end
        end

        if not v25 then
            v26 = "Egg"
        end

        v24.Text = v26 .. "  x" .. count(t1.Key)

        local v28 = v4

        if Pad.Using() then
            v28.Text = "Place it in your pond!"
        elseif v23 then
            v28.Text = "Tap your pond to place it!"
        else
            v28.Text = "Click your pond to place it!"
        end
    end
end

function t1.Drop() -- line: 113
    -- upvalues: ContextActionService (copy), HUD (copy), t1 (copy), v2 (ref), v5 (ref), v6 (ref)
    if t1.Key then
        t1.Key = nil
        v6 = nil

        if v5 then
            v5:Destroy()
            v5 = nil
        end

        v2.Visible = false
        ContextActionService:UnbindAction("PlaceHeldEgg")
        HUD.RefreshPrompts()
    end
end

function t1.Place(p5) -- line: 129
    -- upvalues: Remotes (copy), UIKit (copy), t1 (copy)
    local Key = t1.Key

    if not Key then
        return
    end

    t1.Placed += 1
    UIKit.sound("Splash")
    task.spawn(function() -- line: 136
        -- upvalues: p5 (copy), Key (copy), Remotes (copy)
        local function v29() -- line: 137
            -- upvalues: p5 (copy), Key (copy), Remotes (copy)
            if p5 then
                Remotes.PlaceEgg:InvokeServer(Key, p5.X, p5.Z)
            else
                Remotes.PlaceEgg:InvokeServer(Key)
            end
        end

        pcall(v29)
    end)
end

function t1.Show(p6) -- line: 147
    -- upvalues: UserInputService (copy), ContextActionService (copy), Products (copy), EggModels (copy), UIKit (copy), HUD (copy), HeldFish (copy), Pad (copy), t1 (copy), LocalPlayer (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), n1 (ref), count (copy), shoulders (copy)
    local v30 = t1.Key == p6

    t1.Drop()

    if v30 or count(p6) == 0 then
        return
    end

    HeldFish.Drop()

    local Character = LocalPlayer.Character

    if Character and Character:FindFirstChild("HumanoidRootPart") then
        v5 = EggModels.Build(p6, CFrame.new(), 0.32)
        v5.Parent = workspace
        v6 = shoulders(Character)
        t1.Key = p6
        n1 = os.clock()

        if t1.Key then
            local v32 = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
            local v33 = v3
            local Key = t1.Key
            local v34 = false
            local v35

            for _, v36 in ipairs(Products.Crates) do
                if v36.key == Key then
                    v35 = v36.name
                    v34 = true
                    break
                end
            end

            if not v34 then
                v35 = "Egg"
            end

            v33.Text = v35 .. "  x" .. count(t1.Key)

            local v37 = v4

            if Pad.Using() then
                v37.Text = "Place it in your pond!"
            elseif v32 then
                v37.Text = "Tap your pond to place it!"
            else
                v37.Text = "Click your pond to place it!"
            end
        end

        v2.Visible = true
        UIKit.pop(v2, 0.7)
        ContextActionService:BindAction("PlaceHeldEgg", function(_, p8) -- line: 166
            -- upvalues: t1 (copy)
            if p8 == Enum.UserInputState.Begin then
                t1.Place()
            end

            return Enum.ContextActionResult.Sink
        end, false, Enum.KeyCode.E, Enum.KeyCode.ButtonX)
        HUD.RefreshPrompts()
    end
end

function t1.Blocked() -- line: 175
    -- upvalues: UIKit (copy)
    if not UIKit.anyWindowOpen() then
        return false
    end

    local MyFish = UIKit.Windows.MyFish

    return not (MyFish and MyFish.IsOpen)
end

function t1.Init() -- line: 183
    -- upvalues: RunService (copy), UserInputService (copy), Products (copy), UIKit (copy), DataClient (copy), HUD (copy), HeldFish (copy), Pad (copy), t1 (copy), LocalPlayer (copy), v1 (ref), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), n1 (ref), count (copy), pointOnPond (copy), refreshText (copy)
    v1 = UIKit.screenGui("HeldEgg", 6)
    v2 = UIKit.frame(v1, {
        Name = "Panel",
        Transparency = 1,
        Size = UDim2.fromOffset(620, 120),
        Position = UDim2.new(0.5, 0, 1, -128),
        AnchorPoint = Vector2.new(0.5, 1)
    })
    v3 = UIKit.text(v2, {
        Name = "Name",
        Text = "",
        TextSize = 40,
        Stroke = 5,
        Size = UDim2.new(1, 0, 0, 44),
        Color = UIKit.Colors.Gold
    })

    local v38 = UIKit.frame(v2, {
        Name = "Hint",
        Transparency = 0.25,
        Corner = 31,
        Stroke = 5,
        Size = UDim2.fromOffset(560, 62),
        Position = UDim2.new(0.5, 0, 1, 0),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = UIKit.Colors.Dark
    })

    v4 = UIKit.text(v38, {
        Name = "Label",
        Text = "",
        TextSize = 34,
        Stroke = 4,
        Size = UDim2.new(1, -24, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        Color = Color3.fromRGB(255, 225, 60)
    })
    Pad.IconBeside(v4, Enum.KeyCode.ButtonX, 48)
    Pad.Changed:Connect(refreshText)
    v2.Visible = false
    HUD.OnHotbarEgg = t1.Show

    HUD.HeldEggKey = function() -- line: 194
        -- upvalues: t1 (copy)
        return t1.Key
    end

    local OnHotbar = HUD.OnHotbar

    HUD.OnHotbar = function(p9) -- line: 199
        -- upvalues: OnHotbar (copy), t1 (copy)
        t1.Drop()

        if OnHotbar then
            OnHotbar(p9)
        end
    end

    DataClient.Observe("Eggs", function() -- line: 205
        -- upvalues: UserInputService (copy), Products (copy), Pad (copy), t1 (copy), v3 (ref), v4 (ref), count (copy)
        if t1.Key then
            if count(t1.Key) == 0 then
                t1.Drop()
            elseif t1.Key then
                local v39 = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
                local v40 = v3
                local Key = t1.Key
                local v41 = false
                local v42

                for _, v43 in ipairs(Products.Crates) do
                    if v43.key == Key then
                        v42 = v43.name
                        v41 = true
                        break
                    end
                end

                if not v41 then
                    v42 = "Egg"
                end

                v40.Text = v42 .. "  x" .. count(t1.Key)

                local v44 = v4

                if Pad.Using() then
                    v44.Text = "Place it in your pond!"
                elseif v39 then
                    v44.Text = "Tap your pond to place it!"
                else
                    v44.Text = "Click your pond to place it!"
                end
            end
        end
    end)
    LocalPlayer.CharacterAdded:Connect(t1.Drop)

    local function tryPlace(p10) -- line: 216
        -- upvalues: t1 (copy), n1 (ref), pointOnPond (copy)
        if t1.Key and not (os.clock() - n1 < 0.3 or t1.Blocked()) then
            local v45 = pointOnPond(p10)

            if v45 then
                t1.Place(v45)
            end
        end
    end

    UserInputService.InputBegan:Connect(function(p11, p12) -- line: 225
        -- upvalues: t1 (copy), n1 (ref), pointOnPond (copy)
        if p12 or p11.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        local Position = p11.Position

        if t1.Key and not (os.clock() - n1 < 0.3) then
            if t1.Blocked() then
                return
            end

            local v46 = pointOnPond(Position)

            if v46 then
                t1.Place(v46)
            end
        end
    end)
    UserInputService.TouchTapInWorld:Connect(function(p13, p14) -- line: 230
        -- upvalues: t1 (copy), n1 (ref), pointOnPond (copy)
        if p14 or not t1.Key or os.clock() - n1 < 0.3 or t1.Blocked() then
            return
        end

        local v47 = pointOnPond(p13)

        if v47 then
            t1.Place(v47)
        end
    end)
    RunService.Stepped:Connect(function() -- line: 236
        -- upvalues: t1 (copy), v6 (ref)
        if t1.Key and v6 then
            for _, v48 in ipairs(v6) do
                if v48.joint.Parent then
                    local joint = v48.joint

                    if v48.r15 then
                        joint.Transform = CFrame.Angles(1.4311699866353502, 0, 0)
                    else
                        joint.Transform = CFrame.Angles(0, 0, v48.sign * 1.4311699866353502)
                    end
                end
            end
        end
    end)
    RunService.RenderStepped:Connect(function() -- line: 246
        -- upvalues: UIKit (copy), HUD (copy), HeldFish (copy), t1 (copy), LocalPlayer (copy), v2 (ref), v5 (ref)
        if t1.Key then
            local Character = LocalPlayer.Character
            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart and HUD.GetMode() == "normal" and not HeldFish.Uid then
                v2.Visible = not UIKit.anyWindowOpen()

                if v5 then
                    v5:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, math.sin(os.clock() * 2.2) * 0.08 + -0.9, -2.6))
                end

                return
            end

            t1.Drop()
        end
    end)
end

return t1
