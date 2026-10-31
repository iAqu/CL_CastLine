-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local InsertService = game:GetService("InsertService")
local Signal = require(script.util.Signal)

require(script.data.__typeHeader)

local instanceValues = require(script.data.instanceValues)
local ease = require(script.util.ease)
local lerper = require(script.util.lerper)

require(script.util.scaler)

local keyframeSearch = require(script.util.keyframeSearch)
local createInstanceProcess = require(script.helpers.createInstanceProcess)
local __VERSION = require(script.data.__VERSION)
local t1 = {}

t1.__index = t1

function t1._ApplyProperty(p1, p2, p3, p4) -- line: 57
    -- upvalues: instanceValues (copy)
    local TargetInstance = p2.TargetInstance

    if p2.isTargetPVI and (p3 == "CFrame" or p3 == "WorldPivot") then
        TargetInstance:PivotTo((if p2.isParentPVI then p2.Parent:GetPivot() else p1._Origin):ToWorldSpace(p4))
    elseif instanceValues[p3] then
        TargetInstance[p3] = p4 and p1._ProcessLookup[p4].TargetInstance
    else
        TargetInstance[p3] = p4
    end
end

function t1.PlayOnce(p5, p6) -- line: 81
    p5:Resume()
    p5.Completed:Once(function() -- line: 83
        -- upvalues: p5 (copy), p6 (copy)
        p5:Destroy(p6)
    end)
end

local function getAnimationValueAtTime(p7, p8) -- line: 92
    -- upvalues: ease (copy), lerper (copy), keyframeSearch (copy)
    local v1, v2, v3 = keyframeSearch.clampedBoundedBisect(p7, p8)
    local v4 = p7[v2]
    local v5 = p7[v3]

    return lerper[typeof(v4.value)](v4.value, v5.value, ease[v4.ease](v1))
end

function t1._RenderStatic(p9) -- line: 104
    for _, v6 in p9._ProcessOrder do
        local TargetInstance = v6.TargetInstance

        for v7, v8 in v6.properties.static do
            p9:_ApplyProperty(v6, v7, v8.value)
        end

        for v9, v10 in v6.attributes.static do
            TargetInstance:SetAttribute(v9, v10.value)
        end

        for v11, v12 in v6.tags.static do
            if v12.active then
                if not TargetInstance:HasTag(v11) then
                    TargetInstance:AddTag(v11)
                end
            elseif TargetInstance:HasTag(v11) then
                TargetInstance:RemoveTag(v11)
            end
        end
    end
end

function t1._RenderDynamic(p10) -- line: 138
    -- upvalues: keyframeSearch (copy), getAnimationValueAtTime (copy)
    local _PreviousTime, _Elapsed = p10._PreviousTime, p10._Elapsed

    for _, v13 in p10._ProcessOrder do
        local _, TargetInstance = v13.id, v13.TargetInstance

        for v14, v15 in v13.properties.dynamic do
            p10:_ApplyProperty(v13, v14, getAnimationValueAtTime(v15, _Elapsed))
        end

        for v16, v17 in v13.attributes.dynamic do
            TargetInstance:SetAttribute(v16, getAnimationValueAtTime(v17, _Elapsed))
        end

        for v18, v19 in v13.tags.dynamic do
            local _, v20 = keyframeSearch.clampedBoundedBisect(v19, _Elapsed)

            if v19[v20].active then
                if not TargetInstance:HasTag(v18) then
                    TargetInstance:AddTag(v18)
                end
            elseif TargetInstance:HasTag(v18) then
                TargetInstance:RemoveTag(v18)
            end
        end

        for v21, v22 in v13.methods do
            for _, v23 in (keyframeSearch.rangeSearch(v22, _PreviousTime, _Elapsed)) do
                TargetInstance[v21](TargetInstance, table.unpack(v22[v23].args))
            end
        end
    end

    for _, v25 in (keyframeSearch.rangeSearch(p10._Events, _PreviousTime, _Elapsed)) do
        for _, v26 in p10._Events[v25].units do
            if p10._EventListeners[v26.name] then
                p10._EventListeners[v26.name]:Fire(v26.arg)
            end
        end
    end
end

function t1.Pause(p11) -- line: 200
    if p11._Runner then
        p11._Runner:Disconnect()
        p11._Runner = nil
    end
end

function t1.Resume(p12) -- line: 206
    -- upvalues: RunService (copy)
    if p12._Runner then
        p12._Runner:Disconnect()
    end

    p12:_RenderStatic()
    p12._Runner = RunService.Heartbeat:Connect(function(p13) -- line: 212
        -- upvalues: p12 (copy)
        p12._Elapsed += p13 * p12.PlackbackSpeed

        if p12.Framerate == -1 or not (p12._Elapsed < p12._PreviousTime + p12.PlackbackSpeed / p12.Framerate) then
            if p12._Elapsed > p12._Length then
                p12._Elapsed = p12._Length
                p12:_RenderDynamic()

                if p12.Loops then
                    p12._Elapsed = p12._Elapsed - p12._Length
                    p12._PreviousTime = (-1e999)
                else
                    p12._Runner:Disconnect()
                    p12._Runner = nil
                    p12._Elapsed = 0
                    p12._PreviousTime = 0
                end

                p12.Completed:Fire()
            else
                p12:_RenderDynamic()
                p12._PreviousTime = p12._Elapsed
            end
        end
    end)
end

function t1.SetOrigin(p14, p15) -- line: 264
    -- upvalues: getAnimationValueAtTime (copy)
    p14._Origin = p15

    for _, v28 in p14._ProcessOrder do
        if v28.isTargetPVI then
            if v28.properties.static.CFrame then
                p14:_ApplyProperty(v28, "CFrame", v28.properties.static.CFrame.value)
            elseif v28.properties.static.WorldPivot then
                p14:_ApplyProperty(v28, "WorldPivot", v28.properties.static.WorldPivot.value)
            end

            if not p14._Runner then
                if v28.properties.dynamic.CFrame then
                    p14:_ApplyProperty(v28, "CFrame", getAnimationValueAtTime(v28.properties.dynamic.CFrame, p14._Elapsed))
                elseif v28.properties.dynamic.WorldPivot then
                    p14:_ApplyProperty(v28, "WorldPivot", getAnimationValueAtTime(v28.properties.dynamic.WorldPivot, p14._Elapsed))
                end
            end
        end
    end
end

function t1.SetTime(p16, p17) -- line: 306
    p16._PreviousTime = p17
    p16._Elapsed = p17
    p16:_RenderStatic()
    p16:_RenderDynamic()
end

function t1.GetEventReachedSignal(p18, p19) -- line: 313
    -- upvalues: Signal (copy)
    if not p18._EventListeners[p19] then
        p18._EventListeners[p19] = Signal.new()
    end

    return p18._EventListeners[p19]
end

function t1.GetRootInstance(p20) -- line: 319
    return table.clone(p20._RootInstance)
end

function t1.Destroy(p21, p22) -- line: 324
    p21:Pause()

    if not p22 then
        p21._RootInstance:Destroy()
    end

    if p21._Runner then
        p21._Runner:Disconnect()
    end

    for _, v29 in p21._EventListeners do
        v29:Destroy()
    end
end

return {
    loadAnimation = function(p23, p24, p25) -- line: 347
        -- upvalues: Signal (copy), createInstanceProcess (copy), __VERSION (copy), t1 (copy)
        if p23._version ~= __VERSION then
            error((("Incorrect Visulie data version: %*, expected %*"):format(p23._version, __VERSION)))
        end

        if not p25 then
            error("No root instance provided to load!")
        end

        local t3 = {}
        local t4 = {}

        local function loadInstance(p26, p27, p28) -- line: 358
            -- upvalues: p23 (copy), t3 (copy), t4 (copy), loadInstance (copy), createInstanceProcess (copy)
            if p27 and not p26.ghosted then
                local v30 = createInstanceProcess(p26.id, p27, p28, p23)

                t3[p26.id] = v30
                table.insert(t4, v30)

                for _, v31 in p26.children do
                    loadInstance(v31, p27:FindFirstChild(v31.name), p27)
                end
            end
        end

        loadInstance(p23.rootInit, p25)

        local v32 = setmetatable({
            _Elapsed = 0,
            _PreviousTime = 0,
            Framerate = -1,
            PlackbackSpeed = 1,
            Loops = false,
            _RootInstance = p25,
            _ParentContainer = p25.Parent or workspace,
            _ProcessLookup = t3,
            _ProcessOrder = t4,
            _Length = p23.length,
            _Origin = p24 or CFrame.identity,
            _Events = p23.events,
            _EventListeners = {},
            Completed = Signal.new()
        }, t1)

        v32._RootDestroyedListener = p25.Destroying:Once(function() -- line: 401
            -- upvalues: v32 (copy)
            v32:Destroy(true)
        end)

        return v32
    end,
    new = function(p29, p30, p31) -- line: 411
        -- upvalues: InsertService (copy), Signal (copy), createInstanceProcess (copy), __VERSION (copy), t1 (copy)
        if p29._version ~= __VERSION then
            error((("Incorrect Visulie data version: %*, expected %*"):format(p29._version, __VERSION)))
        end

        if p29.loadType ~= "Atomic" then
            error(((".new() can only be used with \"Atomic\" animations. Current loadType: \"%*\""):format(p29.loadType)))
        end

        if p29.rootInit.ghosted then
            error("The root instance cannot be ghosted!")
        end

        local t6 = {}
        local t7 = {}

        local function initInstance(p32, p33) -- line: 425
            -- upvalues: p29 (copy), t6 (copy), t7 (copy), initInstance (copy), InsertService (copy), createInstanceProcess (copy)
            if p32.ghosted then
                return
            end

            local v33 = if p32.class == "MeshPart" then InsertService:CreateMeshPartAsync(p32.meshId, p32.collisionFidelity, p32.renderFidelity) else Instance.new(p32.class)

            v33.Name = p32.name

            local v34 = createInstanceProcess(p32.id, v33, p33, p29)

            t6[p32.id] = v34
            table.insert(t7, v34)

            for _, v35 in p32.children do
                initInstance(v35, v33)
            end

            return v33
        end

        local v36 = initInstance(p29.rootInit)

        table.freeze(t7)
        table.freeze(t6)

        local v37 = setmetatable({
            _Elapsed = 0,
            _PreviousTime = 0,
            Framerate = -1,
            PlackbackSpeed = 1,
            Loops = false,
            _RootInstance = v36,
            _ParentContainer = p31 or workspace,
            _ProcessLookup = t6,
            _ProcessOrder = t7,
            _Length = p29.length,
            _Origin = p30 or CFrame.identity,
            _Events = p29.events,
            _EventListeners = {},
            Completed = Signal.new()
        }, t1)

        v37._RootDestroyedListener = v36.Destroying:Once(function() -- line: 484
            -- upvalues: v37 (copy)
            v37:Destroy(true)
        end)

        for _, v38 in t7 do
            for v39, v40 in v38.properties.static do
                if v39 == "CFrame" then
                    task.defer(function() -- line: 496
                        -- upvalues: v37 (copy), v38 (copy), v39 (copy), v40 (copy)
                        v37:_ApplyProperty(v38, v39, v40.value)
                    end)
                else
                    v37:_ApplyProperty(v38, v39, v40.value)
                end
            end

            for v41, v42 in v38.properties.dynamic do
                v37:_ApplyProperty(v38, v41, v42[1].value)
            end

            v38.TargetInstance.Parent = v38.Parent or v37._ParentContainer
        end

        return v37
    end
}
