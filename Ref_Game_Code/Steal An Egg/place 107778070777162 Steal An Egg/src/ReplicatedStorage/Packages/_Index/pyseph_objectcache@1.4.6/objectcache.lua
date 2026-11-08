-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local QueueLock = require(ReplicatedStorage.Shared.Modules.QueueLock)
local v1 = require(ReplicatedStorage.Packages.Log).new()
local InvisibleRenderSpace = workspace:WaitForChild("World"):WaitForChild("InvisibleRenderSpace")
local v2 = InvisibleRenderSpace.Size * 0.5
local v3 = InvisibleRenderSpace.Position - v2
local v4 = InvisibleRenderSpace.Position + v2
local v5 = if Constants.IS_MOBILE then 0.006 else 0.004
local v6 = table.create(10000)
local v7 = table.create(10000)
local t1 = if Constants.IS_CLIENT then {} else nil
local v8 = false

local function UpdateMovement() -- line: 27
    -- upvalues: v6 (copy), v7 (copy), v8 (ref)
    while true do
        workspace:BulkMoveTo(v6, v7, Enum.BulkMoveMode.FireCFrameChanged)
        table.clear(v6)
        table.clear(v7)
        v8 = false
        coroutine.yield()
    end
end

local v9 = coroutine.create(UpdateMovement)
local t2 = {}

t2.__index = t2

local function randFloat(p1, p2) -- line: 60
    return math.random() * (p2 - p1) + p1
end

local function hiddenCFrame() -- line: 64
    -- upvalues: v3 (ref), v4 (ref)
    local new = CFrame.new
    local X = v3.X
    local X2 = v4.X
    local v10 = math.random() * (X2 - X) + X
    local Y = v3.Y
    local Y2 = v4.Y
    local v11 = math.random() * (Y2 - Y) + Y
    local Z = v3.Z
    local Z2 = v4.Z

    return new(v10, v11, math.random() * (Z2 - Z) + Z)
end

function t2._GetNew(p3, p4, p5) -- line: 72
    -- upvalues: v3 (ref), v4 (ref), v5 (copy)
    if p5 then
        warn((("ObjectCache: Cache retrieval exceeded preallocated amount! expanding by %*..."):format(p4)))
    end

    local _FreeObjects = p3._FreeObjects
    local v12 = #p3._FreeObjects
    local CacheHolder, _IsTemplateModel, _Template = p3.CacheHolder, p3._IsTemplateModel, p3._Template
    local v13 = table.create(p4)
    local v14 = table.create(p4)
    local elapsed = os.clock()

    for i = v12 + 1, v12 + p4 do
        local clone = _Template:Clone()
        local v15 = if _IsTemplateModel then clone.PrimaryPart else clone

        _FreeObjects[i] = v15
        p3._DesiredAnchored[v15] = v15.Anchored
        v15.Anchored = true
        clone.Parent = CacheHolder

        local v16 = i - v12

        v13[v16] = v15

        local new = CFrame.new
        local X = v3.X
        local X2 = v4.X
        local v17 = math.random() * (X2 - X) + X
        local Y = v3.Y
        local Y2 = v4.Y
        local v18 = math.random() * (Y2 - Y) + Y
        local Z = v3.Z
        local Z2 = v4.Z

        v14[v16] = new(v17, v18, math.random() * (Z2 - Z) + Z)

        if os.clock() - elapsed >= v5 then
            task.wait()
            elapsed = os.clock()
        end
    end

    workspace:BulkMoveTo(v13, v14, Enum.BulkMoveMode.FireCFrameChanged)

    return table.remove(_FreeObjects)
end

function t2.GetPart(p6, p7) -- line: 116
    -- upvalues: v1 (copy), v6 (copy), v7 (copy), v8 (ref), v9 (copy)
    local v19 = table.remove(p6._FreeObjects)
    local v20 = v19

    if not v19 then
        p6._ExpandMutex:WithLock(function() -- line: 119
            -- upvalues: p6 (copy), v20 (ref), v1 (copy)
            v1:AtTrace():Log("free objects at creation:", p6._FreeObjects, "SELF", p6)
            v20 = p6:_GetNew(p6._ExpandAmount, true)
            v1:AtTrace():Log("part found after expanding cache:", v20, "self:", p6)
        end)
    end

    assert(v20, "ObjectCache: failed to allocate part")
    p6._Objects[v20] = nil

    if p7 then
        table.insert(v6, v20)
        table.insert(v7, p7)

        if not v8 then
            v8 = true
            task.defer(v9)
        end
    end

    local v25 = p6._DesiredAnchored[v20]

    if v25 ~= nil then
        p6._DesiredAnchored[v20] = nil
        task.defer(function() -- line: 146
            -- upvalues: v20 (ref), v25 (copy)
            v20.Anchored = v25
        end)
    end

    return v20
end

function t2.ReturnPart(p8, p9) -- line: 154
    -- upvalues: v6 (copy), v7 (copy), v8 (ref), v9 (copy), hiddenCFrame (copy)
    if p8._Objects[p9] then
        return
    end

    p8._Objects[p9] = true
    p8._DesiredAnchored[p9] = p9.Anchored
    p9.Anchored = true
    table.insert(p8._FreeObjects, p9)
    table.insert(v6, p9)
    table.insert(v7, hiddenCFrame())

    if not v8 then
        v8 = true
        task.defer(v9)
    end
end

function t2.Update(_) -- line: 174
    -- upvalues: v9 (copy)
    task.spawn(v9)
end

function t2.ExpandCache(p11, p12) -- line: 178
    assert(typeof(p12) ~= "number" or p12 >= 0, (("Invalid argument #1 to 'ObjectCache:ExpandCache' (positive number expected, got %*)"):format((typeof(p12)))))
    p11._ExpandMutex:WithLock(function() -- line: 184
        -- upvalues: p11 (copy), p12 (copy)
        p11:_GetNew(p12, false)
    end)

    return p11
end

function t2.SetExpandAmount(p13, p14) -- line: 190
    assert(typeof(p14) ~= "number" or p14 > 0, (("Invalid argument #1 to 'ObjectCache:SetExpandAmount' (positive number expected, got %*)"):format((typeof(p14)))))
    p13._ExpandAmount = p14

    return p13
end

function t2.IsInUse(p15, p16) -- line: 200
    return p15._Objects[p16] == nil
end

local function CollectFlush(p17, p18, p19) -- line: 204
    -- upvalues: v6 (copy), v7 (copy)
    debug.profilebegin("ObjectCache :: CollectFlush")

    for _, v30 in ipairs(p17._FreeObjects) do
        table.insert(v6, v30)

        local new = CFrame.new
        local X = p18.X
        local X2 = p19.X
        local v31 = math.random() * (X2 - X) + X
        local Y = p18.Y
        local Y2 = p19.Y
        local v32 = math.random() * (Y2 - Y) + Y
        local Z = p18.Z
        local Z2 = p19.Z

        table.insert(v7, new(v31, v32, math.random() * (Z2 - Z) + Z))
    end

    debug.profileend()
end

function t2.FlushToBounds(p20, p21, p22) -- line: 218
    -- upvalues: v8 (ref), v9 (copy), CollectFlush (copy)
    CollectFlush(p20, p21, p22)

    if not v8 then
        v8 = true
        task.defer(v9)
    end
end

function t2.Destroy(p23) -- line: 227
    -- upvalues: t1 (copy)
    debug.profilebegin("ObjectCache :: Destroy")

    if t1 then
        t1[p23] = nil
    end

    p23.CacheHolder:Destroy()
    debug.profileend()
end

local function GetCacheContainer() -- line: 238
    local Folder = Instance.new("Folder")

    Folder.Name = "ObjectCache"

    return Folder
end

return {
    new = function(p24, p25, p26) -- new | line: 246
        -- upvalues: QueueLock (copy), v3 (ref), v4 (ref), t2 (copy), t1 (copy), v5 (copy)
        local v34 = typeof(p24)

        assert(v34 == "Instance", (("Invalid argument #1 to 'ObjectCache.new' (BasePart expected, got %*)"):format(v34)))
        assert(p24:IsA("BasePart") or p24:IsA("Model"), (("Invalid argument #1 to 'ObjectCache.new' (BasePart or Model expected, got %*)"):format(p24.ClassName)))
        assert(p24.Archivable, "ObjectCache: Cannot use template object provided, as it has Archivable set to false.")

        if p24:IsA("Model") then
            assert(p24.PrimaryPart ~= nil, "Invalid Template provided to 'ObjectCache.new': Model has no PrimaryPart set!")
        end

        local v40 = typeof(p25)

        assert(p25 == nil or v40 == "number", (("Invalid argument #2 to 'ObjectCache.new' (number expected, got %*)"):format(v40)))
        assert(p25 == nil or p25 >= 0, (("Invalid argument #2 to 'ObjectCache.new' (positive number expected, got %*)"):format(p25)))

        local v45 = typeof(p26)

        assert(p26 == nil or v45 == "Instance", (("Invalid argument #3 to 'ObjectCache.new' (Instance expected, got %*)"):format(v45)))

        local v48 = p25 or 1
        local Folder = Instance.new("Folder")

        Folder.Name = "ObjectCache"

        local t4 = {}
        local v49 = table.create(v48)
        local t5 = {}
        local Model = p24:IsA("Model")
        local v50 = setmetatable({
            CacheHolder = Folder,
            _ExpandAmount = p25 or 1,
            _Template = p24,
            _FreeObjects = v49,
            _Objects = t4,
            _IsTemplateModel = Model,
            _PreallocatedAmount = v48,
            _DesiredAnchored = t5,
            _ExpandMutex = QueueLock.new()
        }, t2)

        if p26 then
            Folder.Parent = p26
        else
            Folder.Parent = workspace
        end

        local elapsed = os.clock()

        for i = 1, v48 do
            local clone = p24:Clone()
            local v51 = if Model then clone.PrimaryPart else clone

            v49[i] = v51
            t5[v51] = v51.Anchored
            v51.Anchored = true
            clone.Parent = Folder

            local new = CFrame.new
            local X = v3.X
            local X2 = v4.X
            local v52 = math.random() * (X2 - X) + X
            local Y = v3.Y
            local Y2 = v4.Y
            local v53 = math.random() * (Y2 - Y) + Y
            local Z = v3.Z
            local Z2 = v4.Z

            v51.CFrame = new(v52, v53, math.random() * (Z2 - Z) + Z)

            if os.clock() - elapsed >= v5 then
                task.wait()
                elapsed = os.clock()
            end
        end

        if t1 then
            t1[v50] = true
        end

        return v50
    end,
    SetInvisibleBounds = function(p27, p28) -- SetInvisibleBounds | line: 338
        -- upvalues: v3 (ref), v4 (ref)
        v3 = p27
        v4 = p28
    end,
    is = function(p29) -- is | line: 343
        -- upvalues: t2 (copy)
        if typeof(p29) == "table" then
            return getmetatable(p29) == t2
        end

        return false
    end,
    GetRandomHiddenCFrame = hiddenCFrame
}
