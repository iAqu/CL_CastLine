-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Shared.Types.AssetItem)

local Directory = require(ReplicatedStorage.Data.Assets).Directory
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)

require(ReplicatedStorage.Shared.Types.FuseMachine)

local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}

t1.__index = t1
t1.__class = "FuseMachineSelectedSlot"

function t1.new(p1, p2, p3, p4) -- line: 35
    -- upvalues: Directory (copy), ButtonFX (copy), Trove (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self._slot = p1
    self._trove = Trove.new()
    self._uid = p2

    local Full = p1.Full

    p1.Empty.Visible = false
    Full.Visible = true
    self._trove:Add(function() -- line: 49
        -- upvalues: p1 (copy), Full (copy)
        Full.Visible = false
        p1.Empty.Visible = true
    end)

    local v2 = Directory[p3.Category]

    assert(v2 ~= nil, (("Missing asset config %*"):format(p3.Category)))

    local Name = Full:FindFirstChild("Name")

    assert(Name ~= nil and Name:IsA("TextLabel"), "Fuse input Full.Name must be a TextLabel")
    Name.Text = v2.DisplayName

    local Pet = Full.Pet

    assert(Pet:IsA("ImageLabel"), "Fuse input Full.Pet must be an ImageLabel")
    Pet.Image = v2.Icon or ""
    self:_applyMutation(p3)
    self:_applyRarity(p3)

    local Add = Full.Add

    assert(Add:IsA("ImageButton"), "Fuse input Full.Add must be an ImageButton")
    self._trove:Add(Add.Activated:Connect(function() -- line: 70
        -- upvalues: p2 (copy), p4 (copy)
        p4(p2)
    end))
    ButtonFX(Add, 1.08)

    return self
end

function t1:_applyMutation(p6) -- line: 80
    -- upvalues: Mutations (copy)
    local v6 = p6.BaseMutation or p6.Mutations[1]

    if v6 ~= nil and v6 ~= Mutations.NO_MUTATION then
        local Name = self._slot.Full:FindFirstChild("Name")

        assert(Name ~= nil and Name:IsA("TextLabel"), "Fuse input Full.Name must be a TextLabel")

        local v8 = Mutations.Get(v6)

        Name.Text = ("%* %*"):format(Mutations.LabelOf(v6), Name.Text)

        if v8 then
            Name.TextColor3 = v8.Tint
        end
    end
end

function t1:_applyRarity(p8) -- line: 98
    -- upvalues: Directory (copy)
    local Rarity = self._slot.Full.Rarity

    assert(Rarity:IsA("TextLabel"), "Fuse input Full.Rarity must be a TextLabel")

    local v9 = Directory[p8.Category]

    assert(v9 ~= nil, (("Missing asset config %*"):format(p8.Category)))

    for _, child in ipairs(Rarity:GetChildren()) do
        if child:IsA("UIGradient") then
            child:Destroy()
        end
    end

    Rarity.Text = v9.Rarity.DisplayName
    Rarity.TextColor3 = v9.Rarity.Color

    if v9.Rarity.RarityGradient then
        v9.Rarity.RarityGradient:Clone().Parent = Rarity
    end
end

function t1:GetUid() -- line: 122
    return self._uid
end

function t1:Destroy() -- line: 124
    self._trove:Destroy()
end

return t1
