-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Animals = require(ReplicatedStorage.Shared.Animals)
local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Hud = require(script.Parent.Parent.UI.Hud)
local Backpack = require(script.Parent.Parent.UI.Backpack)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1, v2

local function myFloor() -- line: 28
    -- upvalues: Config (copy), LocalPlayer (copy)
    local v3 = Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))

    return v3 and v3:FindFirstChild("Floor")
end

local function overFloor(p1, p2, p3) -- line: 33
    local v4 = p1.CFrame:PointToObjectSpace(p2)

    if not (math.abs(v4.X) <= p1.Size.X / 2 - p3) then
        return false
    end

    return math.abs(v4.Z) <= p1.Size.Z / 2 - p3
end

local function aimPoint(p4) -- line: 39
    -- upvalues: Config (copy), LocalPlayer (copy)
    local v5 = Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))
    local Floor = v5 and v5:FindFirstChild("Floor")

    if Floor and not (math.abs(p4.Direction.Y) < 0.001) then
        local v6 = (Floor.Position.Y + Floor.Size.Y / 2 - p4.Origin.Y) / p4.Direction.Y

        if v6 <= 0 or v6 > 500 then
            return nil
        end

        local v7 = p4.Origin + p4.Direction * v6
        local v8 = Floor.CFrame:PointToObjectSpace(v7)

        return if math.abs(v8.X) <= Floor.Size.X / 2 - 1 and math.abs(v8.Z) <= Floor.Size.Z / 2 - 1 then v7 else nil
    end

    return nil
end

local function usingGamepad() -- line: 53
    -- upvalues: UserInputService (copy)
    return UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil
end

local function padPoint() -- line: 58
    -- upvalues: Config (copy), LocalPlayer (copy)
    local v9 = Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))
    local Floor = v9 and v9:FindFirstChild("Floor")
    local v10 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if Floor and v10 then
        local Position = v10.Position
        local v11 = Floor.CFrame:PointToObjectSpace(Position)

        if math.abs(v11.X) <= Floor.Size.X / 2 - -6 and math.abs(v11.Z) <= Floor.Size.Z / 2 - -6 then
            local v12 = Floor.CFrame:PointToObjectSpace(v10.Position + v10.CFrame.LookVector * 6)
            local v13 = Floor.Size / 2 - Vector3.new(2, 0, 2)
            local v18 = Floor.CFrame:PointToWorldSpace((Vector3.new(math.clamp(v12.X, -v13.X, v13.X), 0, (math.clamp(v12.Z, -v13.Z, v13.Z)))))

            return (Vector3.new(v18.X, Floor.Position.Y + Floor.Size.Y / 2, v18.Z))
        end
    end

    return nil
end

local function carried() -- line: 70
    -- upvalues: Animals (copy), Backpack (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Holding = Character and Character:GetAttribute("Holding")
    local v20 = Holding and Backpack.entry(Holding)

    return v20, v20 and Animals.get(v20.Id)
end

local function setHint(p5) -- line: 77
    -- upvalues: Hud (copy), v2 (ref)
    if p5 ~= v2 then
        v2 = p5
        Hud.setHint(p5)
    end
end

local function makeRing() -- line: 84
    local Part = Instance.new("Part")

    Part.Name = "PlaceRing"
    Part.Shape = Enum.PartType.Cylinder
    Part.Size = Vector3.new(0.12, 5, 5)
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Color = Color3.fromRGB(120, 255, 140)
    Part.Transparency = 0.35

    return Part
end

local function place(p6) -- line: 100
    -- upvalues: Animals (copy), Remotes (copy), Backpack (copy), UIUtil (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Holding = Character and Character:GetAttribute("Holding")
    local v21 = Holding and Backpack.entry(Holding)

    if v21 then
        Animals.get(v21.Id)

        if p6 then
            Remotes.PlaceAnimal:FireServer(v21.Uid, p6)
        else
            UIUtil.toast("Click on your plot to place it!", "error")
        end
    end
end

function t1.init() -- line: 112
    -- upvalues: ContextActionService (copy), GuiService (copy), RunService (copy), UserInputService (copy), Animals (copy), Config (copy), Remotes (copy), Hud (copy), Backpack (copy), UIUtil (copy), LocalPlayer (copy), v1 (ref), v2 (ref), aimPoint (copy), padPoint (copy), makeRing (copy)
    v1 = makeRing()
    RunService.Heartbeat:Connect(function() -- line: 115
        -- upvalues: UserInputService (copy), Animals (copy), Config (copy), Hud (copy), Backpack (copy), LocalPlayer (copy), v1 (ref), v2 (ref), aimPoint (copy), padPoint (copy)
        local Character = LocalPlayer.Character
        local Holding = Character and Character:GetAttribute("Holding")
        local v22 = Holding and Backpack.entry(Holding)
        local v23 = v22 and Animals.get(v22.Id)
        local v24 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if v22 and v24 then
            local v25 = Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))
            local Floor = v25 and v25:FindFirstChild("Floor")
            local v26 = false

            if Floor ~= nil then
                local Position = v24.Position
                local v27 = Floor.CFrame:PointToObjectSpace(Position)

                v26 = math.abs(v27.X) <= Floor.Size.X / 2 - -6 and math.abs(v27.Z) <= Floor.Size.Z / 2 - -6
            end

            local v28 = UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil
            local v29 = if not v26 then ("Take %* to your plot to place it!"):format(v23.Name) elseif v28 then ("Press R2 to place %*!"):format(v23.Name) else nil

            if v29 ~= v2 then
                v2 = v29
                Hud.setHint(v29)
            end

            local v30

            if v28 then
                v30 = padPoint()
            elseif UserInputService.MouseEnabled then
                local MouseLocation = UserInputService:GetMouseLocation()

                v30 = aimPoint(workspace.CurrentCamera:ViewportPointToRay(MouseLocation.X, MouseLocation.Y))
            end

            if v30 then
                local v32 = math.sin(os.clock() * 6) * 0.08 + 1

                v1.Size = Vector3.new(0.12, v32 * 5, v32 * 5)
                v1.CFrame = CFrame.new(v30 + Vector3.new(0, 0.08, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
                v1.Parent = workspace
            else
                v1.Parent = nil
            end
        else
            v1.Parent = nil

            if v2 and v2 ~= nil then
                v2 = nil
                Hud.setHint(nil)
            end
        end
    end)
    UserInputService.InputBegan:Connect(function(p7, p8) -- line: 147
        -- upvalues: UserInputService (copy), Animals (copy), Remotes (copy), Backpack (copy), UIUtil (copy), LocalPlayer (copy), aimPoint (copy)
        if not p8 and p7.UserInputType == Enum.UserInputType.MouseButton1 then
            local MouseLocation = UserInputService:GetMouseLocation()
            local v38 = aimPoint(workspace.CurrentCamera:ViewportPointToRay(MouseLocation.X, MouseLocation.Y))
            local Character = LocalPlayer.Character
            local Holding = Character and Character:GetAttribute("Holding")
            local v39 = Holding and Backpack.entry(Holding)

            if not v39 then
                return
            end

            Animals.get(v39.Id)

            if v38 then
                Remotes.PlaceAnimal:FireServer(v39.Uid, v38)
            else
                UIUtil.toast("Click on your plot to place it!", "error")
            end
        end
    end)
    UserInputService.TouchTapInWorld:Connect(function(p9, p10) -- line: 159
        -- upvalues: Animals (copy), Remotes (copy), Backpack (copy), UIUtil (copy), LocalPlayer (copy), aimPoint (copy)
        if p10 then
            return
        end

        local v40 = aimPoint(workspace.CurrentCamera:ScreenPointToRay(p9.X, p9.Y))
        local Character = LocalPlayer.Character
        local Holding = Character and Character:GetAttribute("Holding")
        local v41 = Holding and Backpack.entry(Holding)

        if not v41 then
            return
        end

        Animals.get(v41.Id)

        if v40 then
            Remotes.PlaceAnimal:FireServer(v41.Uid, v40)
        else
            UIUtil.toast("Click on your plot to place it!", "error")
        end
    end)
    ContextActionService:BindActionAtPriority("PlaceAnimal", function(_, p12) -- line: 166
        -- upvalues: GuiService (copy), Animals (copy), Remotes (copy), Backpack (copy), LocalPlayer (copy), padPoint (copy)
        local Holding, v42

        if p12 == Enum.UserInputState.Begin then
            local v43 = not GuiService.SelectedObject

            if v43 then
                local Character = LocalPlayer.Character

                Holding = Character and Character:GetAttribute("Holding")
                v42 = Holding and Backpack.entry(Holding)

                if v42 then
                    Animals.get(v42.Id)
                    v42 = padPoint()
                end
            else
                v42 = v43
            end
        else
            v42 = false
        end

        if not v42 then
            return Enum.ContextActionResult.Pass
        end

        local Character = LocalPlayer.Character
        local Holding2 = Character and Character:GetAttribute("Holding")
        local v44 = Holding2 and Backpack.entry(Holding2)

        if v44 then
            Animals.get(v44.Id)
            Remotes.PlaceAnimal:FireServer(v44.Uid, v42)
        end

        return Enum.ContextActionResult.Sink
    end, false, Enum.ContextActionPriority.High.Value + 1, Enum.KeyCode.ButtonR2)
end

return t1
