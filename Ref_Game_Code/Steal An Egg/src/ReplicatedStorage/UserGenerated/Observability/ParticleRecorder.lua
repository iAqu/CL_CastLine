-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

require(ReplicatedStorage.UserGenerated.Observability)

local Registry = require(ReplicatedStorage.UserGenerated.Observability.Registry)

local function qualityLevel() -- line: 49
    -- upvalues: UserInputService (copy)
    local function v1() -- line: 50
        return settings().Rendering.QualityLevel
    end

    local ok, result = pcall(v1)

    if ok and typeof(result) == "EnumItem" and result.Value >= 1 then
        return (math.min(result.Value, 21))
    end

    local function v2() -- line: 56
        return UserSettings():GetService("UserGameSettings").SavedQualityLevel
    end

    local ok2, result2 = pcall(v2)

    if ok2 and typeof(result2) == "EnumItem" and result2.Value >= 1 then
        return 21 - math.floor((10 - result2.Value) * 21 / 10)
    end

    if not UserInputService.TouchEnabled or UserInputService.KeyboardEnabled then
        return 17
    end

    return 7
end

local function emissionScale() -- line: 68
    -- upvalues: qualityLevel (copy)
    return (math.max(0.1, qualityLevel() / 21))
end

local function newWatch() -- line: 92
    return {
        Connections = {},
        Kids = {},
        Names = {}
    }
end

local function inPlayerCharacter(p1) -- line: 96
    -- upvalues: Players (copy)
    local Parent = p1.Parent

    while true do
        if not Parent or Parent == workspace then
            return false
        end

        if not (Parent:IsA("Model") and Players:GetPlayerFromCharacter(Parent)) then
            Parent = Parent.Parent
            continue
        end

        break
    end

    return true
end

local function isRecorded(p2) -- line: 107
    return p2.Forced or p2.Scoped and p2.Qualified
end

local t1 = {}

t1.__index = t1

function t1.new(p3, p4) -- line: 114
    -- upvalues: Registry (copy), qualityLevel (copy), t1 (copy)
    local v5 = p3 ~= nil and p3.Enabled == true
    local v6 = setmetatable({
        World = nil,
        Walking = nil,
        WalkIndex = 0,
        Destroyed = false,
        Clock = p4,
        Enabled = v5,
        Filter = if v5 then Registry.BuildFilter(p3) else nil,
        Entries = {},
        Emits = {},
        Pending = {},
        Watches = {},
        Characters = {},
        Connections = {}
    }, t1)

    local function v7() -- line: 134
        -- upvalues: v6 (copy), qualityLevel (copy)
        local UserGameSettings = UserSettings():GetService("UserGameSettings")

        table.insert(v6.Connections, UserGameSettings:GetPropertyChangedSignal("SavedQualityLevel"):Connect(function() -- line: 138
            -- upvalues: v6 (copy), qualityLevel (copy)
            if v6.World then
                v6.World:SetEmissionScale((math.max(0.1, qualityLevel() / 21)))
            end
        end))
    end

    pcall(v7)
    v6:_watchCharacters()

    if v5 then
        v6:_discover()
    end

    return v6
end

function t1._watchCharacters(p5) -- line: 153
    -- upvalues: Players (copy)
    local function added(p6) -- line: 154
        -- upvalues: p5 (copy)
        if not (p5.Destroyed or p5.Characters[p6]) then
            p5.Characters[p6] = p5:_scope(p6)
        end
    end

    local function removing(p7) -- line: 160
        -- upvalues: p5 (copy)
        local v10 = p5.Characters[p7]

        if v10 then
            p5.Characters[p7] = nil

            for _, v11 in v10.Connections do
                v11:Disconnect()
            end
        end
    end

    local function watchPlayer(p8) -- line: 170
        -- upvalues: p5 (copy), added (copy), removing (copy)
        table.insert(p5.Connections, p8.CharacterAdded:Connect(added))
        table.insert(p5.Connections, p8.CharacterRemoving:Connect(removing))

        if p8.Character then
            local Character = p8.Character

            if not p5.Destroyed then
                if p5.Characters[Character] then
                    return
                end

                p5.Characters[Character] = p5:_scope(Character)
            end
        end
    end

    table.insert(p5.Connections, Players.PlayerAdded:Connect(watchPlayer))

    for _, player in Players:GetPlayers() do
        table.insert(p5.Connections, player.CharacterAdded:Connect(added))
        table.insert(p5.Connections, player.CharacterRemoving:Connect(removing))

        if player.Character then
            local Character = player.Character

            if not p5.Destroyed and not p5.Characters[Character] then
                p5.Characters[Character] = p5:_scope(Character)
            end
        end
    end
end

function t1._inScope(p9, p10) -- line: 185
    -- upvalues: inPlayerCharacter (copy)
    if not p10:IsDescendantOf(workspace) then
        return false
    end

    if inPlayerCharacter(p10) then
        return true
    end

    if not p9.Enabled then
        return false
    end

    local Filter = p9.Filter

    if not Filter then
        return true
    end

    local t3 = {}
    local v12 = p10

    while v12 and v12 ~= workspace do
        table.insert(t3, v12.Name)
        v12 = v12.Parent
    end

    local v13 = #t3
    local v14 = Filter

    for i = v13, 1, -1 do
        v14 = v14.Children[t3[i]]

        if v14 == nil then
            return not Filter.Include
        end

        if v14.Marked then
            return Filter.Include
        end
    end

    return not Filter.Include
end

function t1._qualifies(_, p12) -- line: 219
    return p12.Enabled and p12.Rate > 0
end

function t1._update(p13, p14) -- line: 224
    local v15 = p13.Entries[p14]
    local Forced

    if not v15 or p13.Destroyed then
        return
    else
        Forced = v15.Forced or v15.Scoped and v15.Qualified
    end

    if v15.Forced and not p14:IsDescendantOf(workspace) then
        v15.Forced = false
    end

    v15.Scoped = p13:_inScope(p14)

    if v15.Scoped and not v15.Qualified then
        if p13:_qualifies(p14) then
            v15.Qualified = true
        elseif not v15.Waiting then
            local function changed() -- line: 238
                -- upvalues: p13 (copy), p14 (copy)
                p13:_update(p14)
            end

            v15.Waiting = {
                p14:GetPropertyChangedSignal("Enabled"):Connect(changed),
                p14:GetPropertyChangedSignal("Rate"):Connect(changed)
            }
        end
    end

    if v15.Waiting and (v15.Qualified or not v15.Scoped) then
        for _, v17 in v15.Waiting do
            v17:Disconnect()
        end

        v15.Waiting = nil
    end

    if not v15.Scoped then
        v15.Qualified = false
    end

    local Forced2 = v15.Forced or v15.Scoped and v15.Qualified
    local World = p13.World

    if Forced2 then
        if World then
            World:AddParticle(p14)
        end
    elseif Forced and World then
        World:RemoveParticle(p14)
    end

    if not v15.Scoped and not v15.Forced then
        v15.Moved:Disconnect()
        p13.Entries[p14] = nil
    end
end

function t1._entry(p15, p16) -- line: 275
    local v18 = p15.Entries[p16]

    if v18 then
        return v18
    end

    local t4 = {
        Scoped = false,
        Forced = false,
        Qualified = false,
        Waiting = nil,
        Moved = p16.AncestryChanged:Connect(function() -- line: 284
            -- upvalues: p15 (copy), p16 (copy)
            p15:_update(p16)
        end)
    }

    p15.Entries[p16] = t4

    return t4
end

function t1._consider(p17, p18) -- line: 293
    if not p17.Destroyed and p18:IsA("ParticleEmitter") and not p17.Entries[p18] and p17:_inScope(p18) then
        p17:_entry(p18)
        p17:_update(p18)
    end
end

function t1._recheckAll(p19) -- line: 305
    local t5 = {}

    for v19 in p19.Entries do
        table.insert(t5, v19)
    end

    for _, v20 in t5 do
        p19:_update(v20)
    end
end

function t1._scope(p20, p21) -- line: 316
    -- upvalues: newWatch (copy)
    local v21 = newWatch()

    table.insert(v21.Connections, p21.DescendantAdded:Connect(function(p22) -- line: 320
        -- upvalues: p20 (copy)
        p20:_consider(p22)
    end))
    p20:_consider(p21)
    table.insert(p20.Pending, p21)

    return v21
end

function t1._closeWatch(p23, p24) -- line: 329
    local v23 = p23.Watches[p24]

    if not v23 then
        return
    end

    p23.Watches[p24] = nil

    for _, v24 in v23.Connections do
        v24:Disconnect()
    end

    for _, v25 in v23.Names do
        v25:Disconnect()
    end

    for v26 in v23.Kids do
        p23:_closeWatch(v26)
    end
end

function t1._watchPath(p25, p26, p27) -- line: 348
    -- upvalues: newWatch (copy)
    if next(p27.Children) == nil then
        return
    end

    local v27 = newWatch()

    p25.Watches[p26] = v27

    local function check(p28) -- line: 354
        -- upvalues: p25 (copy), p27 (copy), v27 (copy)
        if v27.Kids[p28] then
            v27.Kids[p28] = nil
            p25:_closeWatch(p28)
            p25:_recheckAll()
        end

        local v28 = p27.Children[p28.Name]

        if v28 == nil or p25.Destroyed then
            return
        end

        v27.Kids[p28] = true

        if v28.Marked then
            p25.Watches[p28] = p25:_scope(p28)
        else
            p25:_watchPath(p28, v28)
        end
    end

    table.insert(v27.Connections, p26.ChildAdded:Connect(function(p29) -- line: 373
        -- upvalues: v27 (copy), check (copy)
        if v27.Names[p29] then
            return
        end

        v27.Names[p29] = p29:GetPropertyChangedSignal("Name"):Connect(function() -- line: 377
            -- upvalues: p29 (copy), check (copy)
            check(p29)
        end)
        check(p29)
    end))
    table.insert(v27.Connections, p26.ChildRemoved:Connect(function(p30) -- line: 385
        -- upvalues: p25 (copy), v27 (copy)
        local v31 = v27.Names[p30]

        if v31 then
            v31:Disconnect()
            v27.Names[p30] = nil
        end

        if v27.Kids[p30] then
            v27.Kids[p30] = nil
            p25:_closeWatch(p30)
        end
    end))

    for _, child in p26:GetChildren() do
        v27.Names[child] = child:GetPropertyChangedSignal("Name"):Connect(function() -- line: 398
            -- upvalues: check (copy), child (copy)
            check(child)
        end)
        check(child)
    end
end

function t1._discover(p31) -- line: 405
    local Filter = p31.Filter

    if Filter and Filter.Include then
        p31:_watchPath(workspace, Filter)

        return
    end

    table.insert(p31.Connections, workspace.DescendantAdded:Connect(function(p32) -- line: 414
        -- upvalues: p31 (copy)
        p31:_consider(p32)
    end))

    for _, child in workspace:GetChildren() do
        table.insert(p31.Pending, child)
    end
end

function t1._walk(p33, p34) -- line: 425
    while true do
        if os.clock() < p34 then
            local Walking = p33.Walking

            if Walking then
                local v33 = p33.WalkIndex
                local v34 = #Walking

                while v33 < v34 and os.clock() < p34 do
                    v33 += 1

                    local v36 = Walking[v33]

                    if v36:IsA("ParticleEmitter") then
                        p33:_consider(v36)
                    end
                end

                p33.WalkIndex = v33

                if v33 < v34 then
                    break
                end

                p33.Walking = nil
            end

            local v37 = table.remove(p33.Pending)

            if v37 == nil then
                return
            end

            if v37.Parent ~= nil then
                p33:_consider(v37)
                p33.Walking = v37:GetDescendants()
                p33.WalkIndex = 0
            end

            continue
        end

        return
    end
end

function t1.Emit(p35, p36, p37) -- line: 457
    if not p35.Destroyed and not (#p35.Emits >= 1024) then
        table.insert(p35.Emits, {
            Emitter = p36,
            Count = p37,
            T = p35.Clock()
        })
    end
end

function t1.Bind(p38, p39) -- line: 465
    -- upvalues: qualityLevel (copy)
    p38.World = p39
    p39:SetEmissionScale((math.max(0.1, qualityLevel() / 21)))

    for v39, v40 in p38.Entries do
        if v40.Forced or v40.Scoped and v40.Qualified then
            p39:AddParticle(v39)
        end
    end
end

function t1.Unbind(p40) -- line: 476
    p40.World = nil
end

function t1.Flush(p41) -- line: 482
    if p41.Destroyed then
        return
    end

    p41:_walk(os.clock() + 5E-04)

    local World = p41.World

    if not World or #p41.Emits == 0 then
        return
    end

    local Emits = p41.Emits

    p41.Emits = {}

    for _, v41 in Emits do
        local Emitter = v41.Emitter

        if Emitter.Parent ~= nil then
            World:WriteEmit(Emitter, v41.Count, v41.T)

            if World.Particles[Emitter] then
                local v42 = p41:_entry(Emitter)

                if not v42.Forced then
                    v42.Forced = true
                    p41:_update(Emitter)
                end
            end
        end
    end
end

function t1.Destroy(p42) -- line: 510
    p42.Destroyed = true
    p42.World = nil

    for _, v43 in p42.Connections do
        v43:Disconnect()
    end

    table.clear(p42.Connections)

    for v44 in p42.Watches do
        p42:_closeWatch(v44)
    end

    for _, v45 in p42.Characters do
        for _, v46 in v45.Connections do
            v46:Disconnect()
        end
    end

    table.clear(p42.Characters)

    for _, v47 in p42.Entries do
        v47.Moved:Disconnect()

        if v47.Waiting then
            for _, v48 in v47.Waiting do
                v48:Disconnect()
            end
        end
    end

    table.clear(p42.Entries)
    table.clear(p42.Emits)
    table.clear(p42.Pending)
    p42.Walking = nil
end

return t1
