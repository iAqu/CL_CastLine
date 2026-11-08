-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local AreaEggs = require(ReplicatedStorage.Shared.Types.AreaEggs)
local AssetRoster = require(ReplicatedStorage.Client.AssetRoster)
local Assets = require(ReplicatedStorage.Data.Assets)
local BaseUpgrade
local EggState = require(ReplicatedStorage.Client.EggState)
local Signal = require(ReplicatedStorage.Packages.Signal)
local GuardAreaGeometry = require(ReplicatedStorage.Shared.Util.GuardAreaGeometry)
local Player = require(ReplicatedStorage.Shared.Player)
local PlotState = require(ReplicatedStorage.Client.PlotState)
local Save = require(ReplicatedStorage.Shared.Save)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}

t1.__index = t1
t1.__class = "MilestoneAdapter"

local LocalPlayer = Players.LocalPlayer
local Main

local function getBackpackController(p1) -- line: 52
    -- upvalues: ReplicatedStorage (copy), Main (ref)
    if Main == nil and not p1._backpackRequested then
        p1._backpackRequested = true
        task.spawn(function() -- line: 55
            -- upvalues: p1 (copy), ReplicatedStorage (copy), Main (ref)
            local Main2 = require(ReplicatedStorage.Controllers.GUI.BackpackController.Main)

            if p1._destroyed then
                return
            end

            Main = Main2
            p1:_fireChanged()
        end)
    end

    return Main
end

local World = Workspace.World

assert(World:IsA("Folder"), "Workspace.World must be a Folder")

local Areas = World.Areas

assert(Areas:IsA("Folder"), "Workspace.World.Areas must be a Folder")

local SeparationLine = Areas.SeparationLine

assert(SeparationLine:IsA("BasePart"), "Workspace.World.Areas.SeparationLine must be a BasePart")

function t1.new() -- line: 78
    -- upvalues: EggState (copy), Signal (copy), Trove (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self.Changed = Signal.new()
    self._areaEggCarryState = EggState.ReadCarryState()
    self._destroyed = false
    self._backpackRequested = false
    self._hatchedEgg = false
    self._hadPlacedPet = false
    self._knownEggCount = nil
    self._treadmillIntroFinished = false
    self._trove = Trove.new()
    self:_bindObservers()

    return self
end

function t1:_fireChanged() -- line: 100
    self.Changed:Fire()
end

function t1._getSaveData(_) -- line: 102
    -- upvalues: Save (copy)
    return Save.Peek()
end

function t1._getEquippedTool(_, p5) -- line: 104
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character ~= nil then
        for _, child in ipairs(Character:GetChildren()) do
            if child:IsA("Tool") and child:GetAttribute("ItemType") == p5 then
                return child
            end
        end
    end

    return nil
end

local function countUnplacedEggs(p6) -- line: 117
    if p6 == nil then
        return 0
    end

    local n1 = 0

    for _, v2 in pairs(p6.EggInventory) do
        if v2.Placement == nil then
            n1 += 1
        end
    end

    return n1
end

local function getPlacedEggCount(p7) -- line: 131
    if p7 == nil then
        return 0
    end

    local n2 = 0

    for _, v3 in pairs(p7.EggInventory) do
        if v3.Placement ~= nil then
            n2 += 1
        end
    end

    return n2
end

local function getTotalEggCount(p8) -- line: 145
    if p8 == nil then
        return 0
    end

    local n3 = 0

    for _ in pairs(p8.EggInventory) do
        n3 += 1
    end

    return n3
end

local function getEggGrowthTime(p9) -- line: 157
    -- upvalues: Assets (copy)
    local v4 = Assets.Directory[p9]

    assert(v4 ~= nil, (("Missing asset config for %*"):format(p9)))

    return v4.Egg.GrowthTime
end

function t1:_getLowestHatchTimeEggUid() -- line: 163
    -- upvalues: Assets (copy)
    local v7 = self:_getSaveData()

    if v7 == nil then
        return nil
    end

    local n4 = 1e999
    local v8

    for v9, v10 in pairs(v7.EggInventory) do
        if v10.Placement == nil then
            local AssetCategory = v10.AssetCategory
            local v11 = Assets.Directory[AssetCategory]

            assert(v11 ~= nil, (("Missing asset config for %*"):format(AssetCategory)))

            local GrowthTime = v11.Egg.GrowthTime

            if GrowthTime < n4 then
                n4 = GrowthTime
                v8 = v9
            end
        end
    end

    return v8
end

function t1:_bindCharacterTools(p12) -- line: 185
    if p12 == nil then
        return
    end

    self._trove:Connect(p12.ChildAdded, function(p13) -- line: 190
        -- upvalues: self (copy)
        if p13:IsA("Tool") then
            self:_fireChanged()
        end
    end)
    self._trove:Connect(p12.ChildRemoved, function(p14) -- line: 195
        -- upvalues: self (copy)
        if p14:IsA("Tool") then
            self:_fireChanged()
        end
    end)
end

function t1:_bindObservers() -- line: 202
    -- upvalues: ReplicatedStorage (copy), AssetRoster (copy), BaseUpgrade (ref), EggState (copy), PlotState (copy), Save (copy), LocalPlayer (copy)
    local function refreshEggCount() -- line: 203
        -- upvalues: self (copy)
        local v14 = self:_getSaveData()

        if v14 ~= nil and not self._destroyed then
            local n5 = 0

            if v14 ~= nil then
                for _ in pairs(v14.EggInventory) do
                    n5 += 1
                end
            end

            if self._knownEggCount ~= nil and n5 < self._knownEggCount then
                self._hatchedEgg = true
            end

            self._knownEggCount = n5
            self:_fireChanged()
        end
    end

    self._trove:Add(Save.Loaded:Connect(refreshEggCount))
    self._trove:Add(Save.Watch("EggInventory"):Connect(refreshEggCount))

    local v15 = self:_getSaveData()

    if v15 ~= nil and not self._destroyed then
        local n6 = 0

        if v15 ~= nil then
            for _ in pairs(v15.EggInventory) do
                n6 += 1
            end
        end

        if self._knownEggCount ~= nil and n6 < self._knownEggCount then
            self._hatchedEgg = true
        end

        self._knownEggCount = n6
        self:_fireChanged()
    end

    self._trove:Add(Save.Watch("Inventory"):Connect(function() -- line: 216
        -- upvalues: self (copy)
        self:_fireChanged()
    end))
    self._trove:Add(Save.Watch("Money"):Connect(function() -- line: 217
        -- upvalues: self (copy)
        self:_fireChanged()
    end))
    self._trove:Add(Save.Watch("BaseUpgradeLevel"):Connect(function() -- line: 218
        -- upvalues: self (copy)
        self:_fireChanged()
    end))
    self._trove:Add(PlotState.LocalPlotChanged:Connect(function() -- line: 219
        -- upvalues: self (copy)
        self:_fireChanged()
    end))
    self._trove:Add(AssetRoster.SnapshotRefreshed:Connect(function() -- line: 220
        -- upvalues: self (copy), AssetRoster (copy), LocalPlayer (copy)
        local v16 = next(AssetRoster.ReadOwnerPen(LocalPlayer.UserId)) ~= nil

        if v16 ~= self._hadPlacedPet then
            self._hadPlacedPet = v16
            self:_fireChanged()
        end
    end))
    task.spawn(function() -- line: 228
        -- upvalues: self (copy), ReplicatedStorage (copy), BaseUpgrade (ref)
        local BaseUpgrade2 = require(ReplicatedStorage.Client.BaseUpgrade)

        if self._destroyed then
            return
        end

        BaseUpgrade = BaseUpgrade2

        local Transition = BaseUpgrade2.Transition

        self._trove:Add(Transition.Completed:Connect(function() -- line: 233
            -- upvalues: self (copy)
            self:_fireChanged()
        end))
        self:_fireChanged()
    end)
    task.spawn(function() -- line: 236
        -- upvalues: self (copy), ReplicatedStorage (copy)
        local PlacedEggRenderer = require(ReplicatedStorage.Shared.Eggs.PlacedEggRenderer)

        if not self._destroyed then
            self._trove:Add(PlacedEggRenderer.LocalEggHatchStarted:Connect(function() -- line: 239
                -- upvalues: self (copy)
                self._hatchedEgg = true
                self:_fireChanged()
            end))
        end
    end)
    self._trove:Add(EggState.OwnerRefreshed:Connect(function(p16) -- line: 244
        -- upvalues: self (copy), LocalPlayer (copy)
        if p16 == LocalPlayer.UserId then
            self:_fireChanged()
        end
    end))
    self._trove:Add(EggState.CarryChanged:Connect(function(p17) -- line: 249
        -- upvalues: self (copy)
        self._areaEggCarryState = p17
        self:_fireChanged()
    end))
    self._trove:Add(EggState.FieldRefreshed:Connect(function() -- line: 253
        -- upvalues: self (copy)
        self:_fireChanged()
    end))
    self._trove:Add(EggState.FieldShifted:Connect(function() -- line: 254
        -- upvalues: self (copy)
        self:_fireChanged()
    end))
    self._trove:Add(EggState.FieldGone:Connect(function() -- line: 255
        -- upvalues: self (copy)
        self:_fireChanged()
    end))

    local v17

    local function bindBackpack(p18) -- line: 257
        -- upvalues: self (copy), v17 (ref)
        if not p18:IsA("Backpack") or p18 == v17 or self._destroyed then
            return
        end

        v17 = p18
        self._trove:Connect(p18.ChildAdded, function() -- line: 260
            -- upvalues: self (copy)
            self:_fireChanged()
        end)
        self._trove:Connect(p18.ChildRemoved, function() -- line: 261
            -- upvalues: self (copy)
            self:_fireChanged()
        end)
        self:_fireChanged()
    end

    self._trove:Connect(LocalPlayer.ChildAdded, bindBackpack)

    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

    if Backpack then
        bindBackpack(Backpack)
    end

    self._trove:Connect(LocalPlayer.CharacterAdded, function(p19) -- line: 267
        -- upvalues: self (copy)
        self:_bindCharacterTools(p19)
        self:_fireChanged()
    end)
    self:_bindCharacterTools(LocalPlayer.Character)
    self._hadPlacedPet = next(AssetRoster.ReadOwnerPen(LocalPlayer.UserId)) ~= nil
end

function t1:HasStolenFirstEgg() -- line: 279
    local v18 = self:_getSaveData()
    local n7 = 0

    if v18 ~= nil then
        for _, v19 in pairs(v18.EggInventory) do
            if v19.Placement == nil then
                n7 += 1
            end
        end
    end

    if n7 > 0 then
        return true
    end

    local v20 = self:_getSaveData()
    local n8 = 0

    if v20 ~= nil then
        for _, v21 in pairs(v20.EggInventory) do
            if v21.Placement ~= nil then
                n8 += 1
            end
        end
    end

    return n8 > 0
end

function t1:IsCarryingAreaEgg() -- line: 283
    local _areaEggCarryState = self._areaEggCarryState

    return _areaEggCarryState ~= nil and _areaEggCarryState.IsCarrying
end

function t1.HasReturnedToPen(_) -- line: 288
    -- upvalues: Player (copy), PlotState (copy)
    local v22 = Player.FindRootPart()
    local v23 = PlotState.ResolvePlot()

    if v22 == nil or v23 == nil then
        return false
    end

    if PlotState.ContainsLocalPoint(v22.Position) then
        return true
    end

    local PetArea = v23.PetArea
    local v24 = PetArea.CFrame:PointToObjectSpace(v22.Position)
    local v25 = PetArea.Size * 0.5
    local v32 = Vector3.new(math.clamp(v24.X, -v25.X, v25.X), math.clamp(v24.Y, -v25.Y, v25.Y), (math.clamp(v24.Z, -v25.Z, v25.Z)))
    local v33 = PetArea.CFrame:PointToWorldSpace(v32)

    return (v22.Position - v33).Magnitude <= 18
end

function t1:HasEquippedEgg() -- line: 311
    return self:_getEquippedTool("AssetEgg") ~= nil
end

function t1:HasPlacedEgg() -- line: 315
    local v34 = self:_getSaveData()
    local n9 = 0

    if v34 ~= nil then
        for _, v35 in pairs(v34.EggInventory) do
            if v35.Placement ~= nil then
                n9 += 1
            end
        end
    end

    return n9 > 0
end

function t1.HasHatchableEgg(_) -- line: 319
    -- upvalues: EggState (copy), LocalPlayer (copy)
    for v36 in pairs(EggState.ReadOwnerEggs(LocalPlayer.UserId)) do
        if EggState.IsReadyToHatch(v36) then
            return true
        end
    end

    return false
end

function t1:HasHatchedEgg() -- line: 328
    return self._hatchedEgg
end

function t1:HasPlacedPet() -- line: 330
    return self._hadPlacedPet
end

function t1:HasPetInInventory() -- line: 332
    if self:_getEquippedTool("Asset") ~= nil then
        return true
    end

    local v37 = self:_getSaveData()

    return v37 ~= nil and next(v37.Inventory) ~= nil
end

function t1.IsLocalPlayerInGameplay(_) -- line: 341
    -- upvalues: GuardAreaGeometry (copy), Player (copy), SeparationLine (copy)
    local v38 = Player.FindRootPart()

    return v38 ~= nil and (GuardAreaGeometry.IsPastLine(SeparationLine, v38.Position))
end

function t1.GetClosestAreaEggTarget(_) -- line: 346
    -- upvalues: AreaEggs (copy), EggState (copy), Player (copy)
    local v39 = Player.FindRootPart()
    local v40 = if v39 then v39.Position else Vector3.new(0, 0, 0)
    local n10 = 1e999
    local Position

    for _, v41 in ipairs(EggState.ReadFieldEggs().Records) do
        if v41.State == AreaEggs.States.Slot and string.find(v41.Uid, "FirstAreaEgg_", 1, true) == 1 then
            local Magnitude = (v41.BottomCFrame.Position - v40).Magnitude

            if Magnitude < n10 then
                n10 = Magnitude
                Position = v41.BottomCFrame.Position
            end
        end
    end

    return Position
end

function t1.GetGameplayExitTarget(_) -- line: 367
    -- upvalues: Player (copy), SeparationLine (copy)
    local v42 = SeparationLine.Position + Vector3.new(0, 3, 0) - SeparationLine.CFrame.LookVector.Unit * 1
    local v43 = Player.FindRootPart()

    if v43 == nil then
        return v42
    end

    return (Vector3.new(v42.X, v42.Y, v43.Position.Z))
end

function t1.GetGameplayEntryTarget(_) -- line: 375
    -- upvalues: SeparationLine (copy)
    return SeparationLine.Position + Vector3.new(0, 3, 0) + SeparationLine.CFrame.LookVector.Unit * 1
end

function t1.GetPlotSpawnTarget(_) -- line: 381
    -- upvalues: PlotState (copy)
    local v44 = PlotState.ResolvePlot()

    if v44 == nil then
        return nil
    end

    local RespawnPointCFrame = v44.RespawnPointCFrame

    if RespawnPointCFrame then
        return RespawnPointCFrame.Position
    end

    return v44.CenterPoint.Position
end

function t1.GetEggPlacementBillboardCFrame(_) -- line: 390
    -- upvalues: Player (copy), PlotState (copy)
    local v45 = PlotState.ResolvePlot()
    local v46 = Player.FindRootPart()

    if v45 == nil or v46 == nil or v45.RespawnPointCFrame == nil then
        return nil
    end

    local PetArea, RespawnPointCFrame = v45.PetArea, v45.RespawnPointCFrame
    local v47 = PetArea.CFrame:PointToObjectSpace(v46.Position)
    local v48 = PetArea.Size * 0.5
    local v53 = Vector3.new(math.clamp(v47.X, -v48.X, v48.X), v48.Y, (math.clamp(v47.Z, -v48.Z, v48.Z)))
    local v54 = PetArea.CFrame:PointToWorldSpace(v53)
    local v55 = RespawnPointCFrame + RespawnPointCFrame.LookVector * 13

    return CFrame.new(v55.Position.X, v54.Y, v55.Position.Z)
end

function t1.GetNearestHatchableEggTarget(_) -- line: 411
    -- upvalues: EggState (copy), Player (copy), PlotState (copy), LocalPlayer (copy)
    local v56 = Player.FindRootPart()
    local v57 = if v56 then v56.Position else Vector3.new(0, 0, 0)
    local n11 = 1e999
    local Position

    for v58, v59 in pairs(EggState.ReadOwnerEggs(LocalPlayer.UserId)) do
        if v59.Placement ~= nil and EggState.IsReadyToHatch(v58) then
            local v60 = PlotState.ResolvePlot()

            if v60 ~= nil then
                local Position2 = (v60.CenterPoint.CFrame * v59.Placement.LocalCFrame).Position
                local Magnitude = (Position2 - v57).Magnitude

                if Magnitude < n11 then
                    n11 = Magnitude
                    Position = Position2
                end
            end
        end
    end

    return Position
end

function t1:GetEggHotbarTarget() -- line: 435
    -- upvalues: ReplicatedStorage (copy), Main (ref)
    local v61 = self:_getLowestHatchTimeEggUid()
    local Main2

    if v61 then
        if Main == nil and not self._backpackRequested then
            self._backpackRequested = true
            task.spawn(function() -- line: 55
                -- upvalues: self (copy), ReplicatedStorage (copy), Main (ref)
                local Main2 = require(ReplicatedStorage.Controllers.GUI.BackpackController.Main)

                if self._destroyed then
                    return
                end

                Main = Main2
                self:_fireChanged()
            end)
        end

        Main2 = Main
    end

    return if Main2 then Main2:GetEggSlotFrame(v61) else nil
end

function t1:ForceBestEggIntoHotbar() -- line: 441
    -- upvalues: ReplicatedStorage (copy), Main (ref)
    local v62 = self:_getLowestHatchTimeEggUid()
    local Main2

    if v62 then
        if Main == nil and not self._backpackRequested then
            self._backpackRequested = true
            task.spawn(function() -- line: 55
                -- upvalues: self (copy), ReplicatedStorage (copy), Main (ref)
                local Main2 = require(ReplicatedStorage.Controllers.GUI.BackpackController.Main)

                if self._destroyed then
                    return
                end

                Main = Main2
                self:_fireChanged()
            end)
        end

        Main2 = Main
    end

    return if Main2 then Main2:ForceEggIntoTutorialHotbar(v62) else nil
end

function t1:HasPetToolEquipped() -- line: 447
    return self:_getEquippedTool("Asset") ~= nil
end

function t1:CanAffordFirstBaseExpansion() -- line: 451
    -- upvalues: BaseUpgrade (ref)
    local v63 = self:_getSaveData()

    if v63 ~= nil and BaseUpgrade ~= nil and v63.BaseUpgradeLevel == 0 then
        return (BaseUpgrade.IsNextTierAffordable(v63))
    end

    return false
end

function t1:HasFinishedFirstBaseExpansion() -- line: 456
    -- upvalues: BaseUpgrade (ref)
    local v64 = self:_getSaveData()

    if v64 == nil then
        return false
    end

    if v64.BaseUpgradeLevel > 0 then
        return BaseUpgrade ~= nil and not BaseUpgrade.Transition.IsPlaying()
    end

    return false
end

function t1.GetPlotUpgradeSignTarget(_) -- line: 464
    -- upvalues: PlotState (copy)
    local v65 = PlotState.ResolvePlot()

    if v65 == nil then
        return nil
    end

    local PlotUpgrade = v65.PlotFolder:FindFirstChild("PlotUpgrade")

    if PlotUpgrade == nil or not PlotUpgrade:IsA("Model") then
        return nil
    end

    local Sign = PlotUpgrade:FindFirstChild("Sign")

    return if Sign ~= nil and Sign:IsA("BasePart") then Sign else nil
end

function t1:HasFinishedTreadmillIntro() -- line: 478
    return self._treadmillIntroFinished
end

function t1:MarkTreadmillIntroFinished() -- line: 482
    if not self._treadmillIntroFinished then
        self._treadmillIntroFinished = true
        self:_fireChanged()
    end
end

function t1:Destroy() -- line: 490
    self._destroyed = true
    self._trove:Destroy()
    self.Changed:Destroy()
end

return t1
