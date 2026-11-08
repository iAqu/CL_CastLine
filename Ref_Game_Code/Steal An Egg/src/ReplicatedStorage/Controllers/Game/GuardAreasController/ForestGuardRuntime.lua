-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local AreaEggSlotIdentity = require(ReplicatedStorage.Shared.Util.AreaEggSlotIdentity)
local AreaEggs = require(ReplicatedStorage.Shared.Types.AreaEggs)
local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
local t = require(ReplicatedStorage.Packages.t)

require(ReplicatedStorage.Shared.Globals.Constants)

local EggState = require(ReplicatedStorage.Client.EggState)
local GuardAreaGeometry = require(ReplicatedStorage.Shared.Util.GuardAreaGeometry)

require(ReplicatedStorage.Shared.Types.GuardAreas)

local Guards = require(ReplicatedStorage.Data.Guards)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local GuardComponent = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardComponent)

require(ReplicatedStorage.Shared.Modules.GuardAreas.Types.Interface)

local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}

t1.__index = t1
t1.__class = "ForestGuardRuntime"

local States = AreaEggs.States
local LocalPlayer = Players.LocalPlayer

local function suppressGuardVisuals(p1) -- line: 75
    local t2 = {}
    local t3 = {}

    for _, descendant in ipairs(p1:GetDescendants()) do
        if descendant:IsA("BasePart") then
            t3[descendant] = {
                CanCollide = descendant.CanCollide,
                CanQuery = descendant.CanQuery,
                CanTouch = descendant.CanTouch,
                LocalTransparencyModifier = descendant.LocalTransparencyModifier
            }
            descendant.LocalTransparencyModifier = 1
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("BillboardGui") then
            local Enabled = descendant.Enabled

            table.insert(t2, function() -- line: 106
                -- upvalues: descendant (copy), Enabled (copy)
                descendant.Enabled = Enabled
            end)
            descendant.Enabled = false
        end
    end

    return function() -- line: 110
        -- upvalues: t2 (copy), t3 (copy)
        for v2, v3 in pairs(t3) do
            v2.LocalTransparencyModifier = v3.LocalTransparencyModifier
            v2.CanCollide = v3.CanCollide
            v2.CanQuery = v3.CanQuery
            v2.CanTouch = v3.CanTouch
        end

        for _, v4 in ipairs(t2) do
            v4()
        end
    end
end

local function stageGuardForConstruction(p2, p3) -- line: 123
    -- upvalues: suppressGuardVisuals (copy)
    p2.Name = "ForestGuardStaging"

    local v5 = suppressGuardVisuals(p2)

    p2.Parent = p3

    return v5
end

function t1.new(p4) -- line: 134
    -- upvalues: Workspace (copy), t (copy), GuardAreaGeometry (copy), Guards (copy), Player (copy), Remotes (copy), GuardComponent (copy), Trove (copy), t1 (copy), LocalPlayer (copy), suppressGuardVisuals (copy)
    t.strict(t.instanceIsA("Model"))(p4)
    assert(p4.Name == "Forest", "ForestGuardRuntime requires area Forest")

    local Guard, Bounds = p4.Guard, p4.Bounds

    assert(p4:IsDescendantOf(Workspace), "Forest area must be in Workspace before guard construction")
    assert(Guard.Parent == p4, "Forest authored guard must belong to its area before guard construction")

    local clone = Guard:Clone()
    local self = setmetatable({}, t1)

    self._areaModel = p4
    self._authoredGuard = Guard
    self._clientEggFolder = nil
    self._droppedModelByUid = {}
    self._droppedTroveByUid = {}
    self._guardModel = clone
    self._hiddenRestore = nil
    self._registeredDroppedUids = {}
    self._registeredStolenUids = {}
    self._trove = Trove.new()
    self._wake = nil

    local t5 = {
        ServerOwnsPhysics = false,
        Attack = function(p5) -- Attack | line: 164
            -- upvalues: Remotes (copy), LocalPlayer (copy)
            if p5.Player == LocalPlayer and p5.EggUid ~= nil then
                local t6 = {
                    EggUid = p5.EggUid,
                    GuardCFrame = p5.GuardRoot.CFrame
                }

                Remotes.GuardPatrol.ForestStrike:FireServer(t6)
            end
        end,
        Wake = function(p6) -- Wake | line: 175
            -- upvalues: self (copy)
            local _wake = self._wake

            if _wake ~= nil then
                _wake(p6)
            end
        end
    }
    local v10, v11

    local function v12() -- line: 184
        -- upvalues: p4 (copy), Guard (copy), Bounds (copy), clone (copy), t5 (copy), v10 (ref), v11 (ref), Workspace (copy), GuardAreaGeometry (copy), Guards (copy), Player (copy), GuardComponent (copy), LocalPlayer (copy), suppressGuardVisuals (copy)
        clone.Name = "ForestGuardStaging"

        local v13 = suppressGuardVisuals(clone)

        clone.Parent = p4
        v10 = v13
        v11 = GuardComponent.new("Forest", clone, Bounds, Workspace.World.Areas.Ground, Guards.Directory.Forest, function(p7) -- line: 192
            -- upvalues: Workspace (copy), GuardAreaGeometry (copy), Player (copy), LocalPlayer (copy)
            if p7 ~= LocalPlayer then
                return false
            end

            local v14 = Player.FindRootPart(LocalPlayer)

            return v14 ~= nil and (GuardAreaGeometry.IsPastLine(Workspace.World.Areas.SeparationLine, v14.Position))
        end, t5)
        assert(p4:IsDescendantOf(Workspace), "Forest area was removed during guard construction")
        assert(Guard.Parent == p4, "Forest authored guard was removed during guard construction")
    end

    local function v17(p8) -- line: 207
        return debug.traceback(tostring(p8), 2)
    end

    local v18, v19 = xpcall(v12, v17)

    if not v18 then
        if v11 ~= nil then
            v11:Destroy()
        end

        clone:Destroy()
        self._trove:Destroy()
        error(v19, 0)
    end

    self._component = assert(v11, "Forest shared guard component did not initialize")

    local v22 = assert(v10, "Forest guard staging did not initialize")

    self._trove:Add(clone)
    self._trove:Add(function() -- line: 220
        -- upvalues: Guard (copy)
        if Guard.Parent ~= nil then
            Guard.Name = "Guard"
        end
    end)
    Guard.Name = "ForestGuardAuthored"
    clone.Name = "Guard"

    for _, descendant in ipairs(Guard:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local LocalTransparencyModifier = descendant.LocalTransparencyModifier

            self._trove:Add(function() -- line: 231
                -- upvalues: descendant (copy), LocalTransparencyModifier (copy)
                if descendant.Parent ~= nil then
                    descendant.LocalTransparencyModifier = LocalTransparencyModifier
                end
            end)
            descendant.LocalTransparencyModifier = 1
        elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("BillboardGui") then
            local Enabled = descendant.Enabled

            self._trove:Add(function() -- line: 245
                -- upvalues: descendant (copy), Enabled (copy)
                if descendant.Parent ~= nil then
                    descendant.Enabled = Enabled
                end
            end)
            descendant.Enabled = false
        end
    end

    v22()
    self._trove:Add(Guard:GetAttributeChangedSignal("Hidden"):Connect(function() -- line: 258
        -- upvalues: self (copy)
        self:_applyHidden()
    end))
    self:_applyHidden()

    return self
end

function t1._isOwnedForestRecord(_, p10) -- line: 269
    -- upvalues: AreaEggSlotIdentity (copy), LocalPlayer (copy)
    if p10.AreaId == "Forest" then
        return AreaEggSlotIdentity.FirstAreaOwnerUserId(p10.Uid) == LocalPlayer.UserId
    end

    return false
end

function t1:_clearStolen(p12) -- line: 277
    if self._registeredStolenUids[p12] == true then
        self._registeredStolenUids[p12] = nil
        self._component:ClearStolenEgg(p12)
    end
end

function t1:_registerStolen(p14, p15) -- line: 285
    -- upvalues: AssetItems (copy), LocalPlayer (copy)
    if self._registeredStolenUids[p14] == true then
        return
    end

    for v23 in pairs(self._registeredStolenUids) do
        self:_clearStolen(v23)
    end

    self._registeredStolenUids[p14] = true
    self._component:RegisterStolenEgg(LocalPlayer, p14, AssetItems.RarityRankForCategory(p15))
end

function t1:_clearDropped(p17) -- line: 304
    local v24 = self._droppedTroveByUid[p17]

    if v24 ~= nil then
        self._droppedTroveByUid[p17] = nil
        v24:Destroy()
    end

    self._droppedModelByUid[p17] = nil

    if self._registeredDroppedUids[p17] == true then
        self._registeredDroppedUids[p17] = nil
        self._component:ClearDroppedEgg(p17)
    end
end

function t1:_tryRegisterDropped(p19) -- line: 318
    -- upvalues: AreaEggSlotIdentity (copy), AssetItems (copy), EggState (copy), GuardAreaGeometry (copy), Trove (copy), States (copy)
    if self._registeredDroppedUids[p19.Uid] == true then
        return
    end

    local _areaModel = self._areaModel

    if GuardAreaGeometry.IsWithinFootprint(_areaModel.Bounds, p19.BoundsCFrame.Position) then
        local _clientEggFolder = self._clientEggFolder

        if _clientEggFolder ~= nil then
            local v25 = _clientEggFolder:FindFirstChild(p19.Uid)

            if v25 ~= nil then
                assert(v25:IsA("Model"), (("%*.%* must be a Model"):format(_clientEggFolder:GetFullName(), p19.Uid)))

                local EggSpotBottom = AreaEggSlotIdentity.NestFor(self._areaModel, p19.NestId).EggSpotBottom

                if self._component:RegisterDroppedEgg({
                    EggUid = p19.Uid,
                    Model = v25,
                    DroppedPosition = p19.BottomCFrame.Position,
                    NestBottomCFrame = EggSpotBottom.CFrame,
                    Priority = AssetItems.RarityRankForCategory(p19.AssetCategory)
                }) then
                    self._registeredDroppedUids[p19.Uid] = true
                    self._droppedModelByUid[p19.Uid] = v25

                    local v27 = Trove.new()

                    self._droppedTroveByUid[p19.Uid] = v27
                    v27:Connect(v25.AncestryChanged, function(_, p21) -- line: 355
                        -- upvalues: self (copy), p19 (copy), v25 (copy), EggState (copy), States (copy)
                        if p21 ~= nil or self._droppedModelByUid[p19.Uid] ~= v25 then
                            return
                        end

                        self:_clearDropped(p19.Uid)

                        local v28 = EggState.ReadFieldEgg(p19.Uid)

                        if v28 ~= nil and v28.State == States.Dropped then
                            self:_tryRegisterDropped(v28)
                        end
                    end)
                end
            end
        end
    end
end

function t1:_syncRecord(p23) -- line: 367
    -- upvalues: States (copy), LocalPlayer (copy)
    if self:_isOwnedForestRecord(p23) then
        if p23.State ~= States.Carried or p23.CarrierUserId ~= LocalPlayer.UserId then
            self:_clearStolen(p23.Uid)

            if p23.State == States.Dropped then
                self:_tryRegisterDropped(p23)
            else
                self:_clearDropped(p23.Uid)
            end
        else
            self:_clearDropped(p23.Uid)
            self:_registerStolen(p23.Uid, p23.AssetCategory)
        end
    end
end

function t1:_syncSnapshot(p25) -- line: 385
    local t7 = {}

    for _, v29 in ipairs(p25.Records) do
        if self:_isOwnedForestRecord(v29) then
            t7[v29.Uid] = true
            self:_syncRecord(v29)
        end
    end

    for v30 in pairs(self._registeredStolenUids) do
        if t7[v30] ~= true then
            self:_clearStolen(v30)
        end
    end

    for v31 in pairs(self._registeredDroppedUids) do
        if t7[v31] ~= true then
            self:_clearDropped(v31)
        end
    end
end

function t1:_handleRetrievalEvent(p27) -- line: 408
    -- upvalues: Remotes (copy)
    if p27.Kind == "Attached" then
        local v32 = self._droppedModelByUid[p27.EggUid]

        if v32 ~= nil then
            local v33 = v32:FindFirstChild("CarryAreaEgg", true)

            if v33 ~= nil then
                assert(v33:IsA("ProximityPrompt"), (("%* must be a ProximityPrompt"):format((v33:GetFullName()))))
                v33:Destroy()
            end
        end

        local t8 = {
            Kind = "Attached",
            EggUid = p27.EggUid
        }

        Remotes.GuardPatrol.ForestHandoff:FireServer(t8)
    else
        local t9 = {
            Kind = "Deposited",
            EggUid = p27.EggUid
        }

        self._registeredDroppedUids[p27.EggUid] = nil
        self._droppedModelByUid[p27.EggUid] = nil

        local v35 = self._droppedTroveByUid[p27.EggUid]

        if v35 ~= nil then
            self._droppedTroveByUid[p27.EggUid] = nil
            v35:Destroy()
        end

        Remotes.GuardPatrol.ForestHandoff:FireServer(t9)
    end
end

function t1:_applyHidden() -- line: 445
    -- upvalues: suppressGuardVisuals (copy)
    local v36 = self._authoredGuard:GetAttribute("Hidden") == true

    self._guardModel:SetAttribute("Hidden", v36 or nil)

    local _hiddenRestore = self._hiddenRestore

    if v36 then
        if _hiddenRestore == nil then
            self._hiddenRestore = suppressGuardVisuals(self._guardModel)
        end
    elseif _hiddenRestore ~= nil then
        self._hiddenRestore = nil
        _hiddenRestore()
    end
end

function t1:GetGuardModel() -- line: 467
    return self._guardModel
end

function t1:SetWakeHandler(p31) -- line: 469
    -- upvalues: t (copy)
    t.strict(t.callback)(p31)
    self._wake = p31
end

function t1:SetEnabled(p33) -- line: 477
    -- upvalues: t (copy)
    t.strict(t.boolean)(p33)
    self._component:SetEnabled(p33)
end

function t1:Start() -- line: 482
    -- upvalues: RunService (copy), Workspace (copy), EggState (copy)
    self._trove:Add(EggState.FieldRefreshed:Connect(function(p35) -- line: 485
        -- upvalues: self (copy)
        self:_syncSnapshot(p35)
    end))
    self._trove:Add(EggState.FieldShifted:Connect(function(p36) -- line: 489
        -- upvalues: self (copy)
        self:_syncRecord(p36)
    end))
    self._trove:Add(EggState.FieldGone:Connect(function(p37) -- line: 491
        -- upvalues: self (copy)
        self:_clearStolen(p37)
        self:_clearDropped(p37)
    end))
    self._trove:Add(EggState.CarryChanged:Connect(function(p38) -- line: 495
        -- upvalues: self (copy)
        if p38.IsCarrying and p38.Uid ~= nil and p38.AssetCategory ~= nil and p38.AreaId == "Forest" then
            self:_registerStolen(p38.Uid, p38.AssetCategory)
        else
            for v37 in pairs(self._registeredStolenUids) do
                self:_clearStolen(v37)
            end
        end
    end))
    task.spawn(function() -- line: 510
        -- upvalues: self (copy), Workspace (copy), EggState (copy)
        local AreaEggSlotsClient = Workspace:WaitForChild("AreaEggSlotsClient")

        assert(AreaEggSlotsClient:IsA("Folder"), "Workspace.AreaEggSlotsClient must be a Folder")

        if self._guardModel.Parent == nil then
            return
        end

        self._clientEggFolder = AreaEggSlotsClient
        self._trove:Connect(AreaEggSlotsClient.ChildAdded, function(p39) -- line: 517
            -- upvalues: AreaEggSlotsClient (copy), self (copy), EggState (copy)
            if self._clientEggFolder == AreaEggSlotsClient and p39.Parent == AreaEggSlotsClient then
                local v38 = EggState.ReadFieldEgg(p39.Name)

                if v38 ~= nil then
                    self:_syncRecord(v38)
                end
            end
        end)
        self:_syncSnapshot(EggState.ReadFieldEggs())
    end)

    local n1 = 0

    self._trove:Connect(RunService.Heartbeat, function(p40) -- line: 530
        -- upvalues: self (copy), n1 (ref)
        n1 += p40

        if n1 < 0.03 then
            return
        end

        n1 = 0

        local v39 = self._component:Step(os.clock())

        if v39 ~= nil then
            self:_handleRetrievalEvent(v39)
        end
    end)
    self:_syncSnapshot(EggState.ReadFieldEggs())
end

function t1:Destroy() -- line: 544
    self._clientEggFolder = nil

    for v40 in pairs(self._registeredDroppedUids) do
        self:_clearDropped(v40)
    end

    for _, v41 in pairs(self._droppedTroveByUid) do
        if v41 ~= nil then
            v41:Destroy()
        end
    end

    self._component:Destroy()
    self._trove:Destroy()
    table.clear(self._registeredDroppedUids)
    table.clear(self._registeredStolenUids)
    table.clear(self._droppedModelByUid)
    table.clear(self._droppedTroveByUid)
end

return t1
