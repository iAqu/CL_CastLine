-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Animals = require(ReplicatedStorage.Shared.Animals)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Format = require(ReplicatedStorage.Shared.Format)
local Settings = require(script.Parent.Parent.UI.Settings)
local RarityText = require(script.Parent.Parent.UI.RarityText)
local Style = require(script.Parent.Parent.Shop.Style)
local Auras = require(script.Parent.Parent.Auras.Auras)
local t1 = {}
local v1 = Color3.fromRGB(120, 255, 90)
local LocalPlayer = Players.LocalPlayer
local t2 = {}

local function wanted(p1) -- line: 31
    -- upvalues: Settings (copy), LocalPlayer (copy)
    local v2 = p1 == LocalPlayer or Settings.get("OtherAnimals")

    return v2, v2 and Settings.get("AnimalFx")
end

local function makeLabel(p2, p3) -- line: 37
    -- upvalues: Config (copy), Format (copy), RarityText (copy), Style (copy), v1 (copy)
    local v3 = p2:GetExtentsSize().Y / 2
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "HeldLabel"
    BillboardGui.Adornee = p3
    BillboardGui.Size = UDim2.fromScale(9, 2.0999999999999996)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, v3 + 0.5 + 1.0499999999999998, 0)
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 70

    local v5 = Style.text(BillboardGui, p2:GetAttribute("DisplayName") or "", {
        Name = "AnimalName",
        StrokeThickness = 2.5,
        Size = UDim2.fromScale(1, 0.5476190476190477)
    })
    local v6 = Config.RarityByName[p2:GetAttribute("Rarity") or ""]

    if v6 then
        RarityText.apply(v5, v6)
    end

    Style.text(BillboardGui, Format.money(p2:GetAttribute("Income") or 0) .. "/s", {
        Name = "Rate",
        StrokeThickness = 2.5,
        Position = UDim2.fromScale(0, 0.5476190476190477),
        Size = UDim2.fromScale(1, 0.45238095238095233),
        TextColor3 = v1
    })
    BillboardGui.Parent = p2

    return BillboardGui
end

local function drop(p4) -- line: 67
    -- upvalues: Auras (copy), t2 (copy)
    local v7 = t2[p4]

    if not v7 then
        return
    end

    t2[p4] = nil

    if v7.label then
        v7.label:Destroy()
    end

    if v7.aura then
        Auras.destroy(v7.aura)
    end
end

local function refresh(p5, p6) -- line: 82
    -- upvalues: Animals (copy), AnimalModel (copy), Settings (copy), Auras (copy), LocalPlayer (copy), t2 (copy), makeLabel (copy)
    local v8 = t2[p5]

    if v8 then
        t2[p5] = nil

        if v8.label then
            v8.label:Destroy()
        end

        if v8.aura then
            Auras.destroy(v8.aura)
        end
    end

    local Parent = p5.Parent
    local v9 = AnimalModel.body(p5) or p5.PrimaryPart

    if not (v9 and Parent) then
        return
    end

    local v10 = p6 == LocalPlayer or Settings.get("OtherAnimals")
    local v11 = v10 and Settings.get("AnimalFx")
    local t3 = {
        owner = p6,
        body = v9,
        root = Parent:FindFirstChild("HumanoidRootPart")
    }

    if v10 then
        t3.label = makeLabel(p5, v9)
    end

    local v12 = Animals.get(p5:GetAttribute("Species") or "")

    if v11 and v12 then
        t3.aura = Auras.make(v12, p5, p5:GetAttribute("HeldSize") or 2.6)
    end

    t2[p5] = t3
end

local function watchCharacter(p7, p8) -- line: 101
    -- upvalues: Auras (copy), t2 (copy), refresh (copy)
    local function added(p9) -- line: 102
        -- upvalues: p7 (copy), refresh (copy)
        if p9.Name == "HeldAnimal" and p9:IsA("Model") then
            refresh(p9, p7)
        end
    end

    p8.ChildAdded:Connect(added)
    p8.ChildRemoved:Connect(function(p10) -- line: 108
        -- upvalues: Auras (copy), t2 (copy)
        if t2[p10] then
            local v13 = t2[p10]

            if not v13 then
                return
            end

            t2[p10] = nil

            if v13.label then
                v13.label:Destroy()
            end

            if v13.aura then
                Auras.destroy(v13.aura)
            end
        end
    end)

    for _, child in p8:GetChildren() do
        if child.Name == "HeldAnimal" and child:IsA("Model") then
            refresh(child, p7)
        end
    end
end

local function watchPlayer(p11) -- line: 118
    -- upvalues: watchCharacter (copy)
    p11.CharacterAdded:Connect(function(p12) -- line: 119
        -- upvalues: p11 (copy), watchCharacter (copy)
        watchCharacter(p11, p12)
    end)

    if p11.Character then
        watchCharacter(p11, p11.Character)
    end
end

function t1.init() -- line: 127
    -- upvalues: Players (copy), RunService (copy), Settings (copy), Auras (copy), t2 (copy), refresh (copy), watchCharacter (copy), watchPlayer (copy)
    Players.PlayerAdded:Connect(watchPlayer)

    for _, player in Players:GetPlayers() do
        player.CharacterAdded:Connect(function(p13) -- line: 119
            -- upvalues: player (copy), watchCharacter (copy)
            watchCharacter(player, p13)
        end)

        if player.Character then
            watchCharacter(player, player.Character)
        end
    end

    local function refreshAll() -- line: 132
        -- upvalues: t2 (copy), refresh (copy)
        for v14, v15 in t2 do
            refresh(v14, v15.owner)
        end
    end

    Settings.onChanged("OtherAnimals", refreshAll)
    Settings.onChanged("AnimalFx", refreshAll)
    RunService.RenderStepped:Connect(function() -- line: 140
        -- upvalues: Auras (copy), t2 (copy)
        local elapsed = os.clock()

        for v16, v17 in t2 do
            if v17.aura then
                if v16.Parent then
                    local v18 = if v17.root then -v17.root.CFrame.RightVector else nil

                    Auras.move(v17.aura, v17.body.Position, elapsed, v18)
                else
                    local v19 = t2[v16]

                    if v19 then
                        t2[v16] = nil

                        if v19.label then
                            v19.label:Destroy()
                        end

                        if v19.aura then
                            Auras.destroy(v19.aura)
                        end
                    end
                end
            end
        end
    end)
end

return t1
