-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    FishMode = "RemoteFunction",
    Cast = "RemoteFunction",
    Land = "RemoteFunction",
    CastDone = "RemoteEvent",
    Lift = "RemoteEvent",
    Notify = "RemoteEvent",
    Inventory = "RemoteEvent",
    HoldAnimal = "RemoteEvent",
    PlaceAnimal = "RemoteEvent",
    PickupAnimal = "RemoteEvent",
    SellAnimal = "RemoteEvent",
    SellAll = "RemoteEvent",
    SellPlaced = "RemoteEvent",
    TankFull = "RemoteEvent",
    SwapAnimal = "RemoteEvent",
    EquipBest = "RemoteEvent",
    Rebirth = "RemoteEvent",
    BuyRod = "RemoteEvent",
    UpgradePen = "RemoteEvent",
    UpgradeBarbell = "RemoteEvent",
    EquipRod = "RemoteEvent",
    BuyBait = "RemoteEvent",
    EquipBait = "RemoteEvent",
    Rep = "RemoteEvent",
    CastShow = "RemoteEvent",
    MiniGameScore = "RemoteEvent",
    MiniGameBoard = "RemoteFunction",
    Boost = "RemoteEvent",
    Admin = "RemoteEvent",
    Granted = "RemoteEvent",
    PromptRobux = "RemoteEvent",
    ClaimPlaytime = "RemoteEvent",
    ClaimFreeGift = "RemoteEvent",
    NeedCash = "RemoteEvent",
    GiftPass = "RemoteFunction",
    ShopTest = "RemoteEvent",
    Tutorial = "RemoteEvent",
    OfflineEarnings = "RemoteFunction",
    SendFeedback = "RemoteFunction",
    SendSurvey = "RemoteFunction",
    Trade = "RemoteEvent",
    SetSetting = "RemoteEvent",
    Boss = "RemoteEvent",
    ClaimIndex = "RemoteEvent",
    UsePotion = "RemoteEvent",
    World2Trip = "RemoteEvent",
    SubBoss = "RemoteEvent",
    Diag = "RemoteEvent"
}
local t2 = {}

if game:GetService("RunService"):IsServer() then
    local v1 = ReplicatedStorage:FindFirstChild("Remotes") or Instance.new("Folder")

    v1.Name = "Remotes"

    for v2, v3 in t1 do
        local v4 = v1:FindFirstChild(v2) or Instance.new(v3)

        v4.Name = v2
        v4.Parent = v1
        t2[v2] = v4
    end

    v1.Parent = ReplicatedStorage
else
    local Remotes = ReplicatedStorage:WaitForChild("Remotes")

    for v5 in t1 do
        t2[v5] = Remotes:WaitForChild(v5)
    end
end

return t2
