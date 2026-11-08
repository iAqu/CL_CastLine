-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Log = require(ReplicatedStorage.Packages.Log)

require(script.Parent.Types.Interface)

local v1 = Log.new()
local t1 = {}

local function clearSlot(p1) -- line: 47
    p1.Frame:Pause()
    p1.Frame.TimePosition = 0
    p1.Frame.Volume = 0
    p1.Frame.Visible = false
    p1.Frame.Video = ""
    p1.MediaIndex = nil
    p1.VideoUri = nil
end

local function assignSlot(p2, p3, p4) -- line: 57
    if p2.MediaIndex == p3 and p2.VideoUri == p4.Video then
        return
    end

    p2.Frame:Pause()
    p2.Frame.TimePosition = 0
    p2.Frame.Volume = 0
    p2.Frame.Visible = false
    p2.Frame.Video = ""
    p2.MediaIndex = nil
    p2.VideoUri = nil
    p2.MediaIndex = p3
    p2.VideoUri = p4.Video
    p2.Frame.Video = p4.Video
end

local function primeHiddenSlot(p5, p6, p7) -- line: 68
    -- upvalues: v1 (copy)
    if p5.MediaIndex ~= p6 or p5.VideoUri ~= p7.Video then
        p5.Frame:Pause()
        p5.Frame.TimePosition = 0
        p5.Frame.Volume = 0
        p5.Frame.Visible = false
        p5.Frame.Video = ""
        p5.MediaIndex = nil
        p5.VideoUri = nil
        p5.MediaIndex = p6
        p5.VideoUri = p7.Video
        p5.Frame.Video = p7.Video
    end

    p5.Frame.Visible = false
    p5.Frame.Volume = 0
    p5.Frame.TimePosition = 0

    local function v2() -- line: 74
        -- upvalues: p5 (copy)
        p5.Frame:Play()
        p5.Frame:Pause()
        p5.Frame.TimePosition = 0
    end

    local ok, result = pcall(v2)

    if ok then
        return true
    end

    v1:AtWarning():Log((("Failed to prime treadmill VideoFrame %*: %*"):format(p7.Video, result)))

    return false
end

local function createCloneSlot(p8, p9) -- line: 87
    local clone = p8:Clone()

    clone.Name = ("MainVideoPreload%*"):format(p9)
    clone.Visible = false
    clone.Video = ""
    clone.Volume = 0
    clone.TimePosition = 0
    clone.Parent = p8.Parent

    return {
        MediaIndex = nil,
        VideoUri = nil,
        Frame = clone
    }
end

function t1.new(p10) -- line: 107
    -- upvalues: primeHiddenSlot (copy)
    p10.Looped = false

    local t2 = {
        {
            MediaIndex = nil,
            VideoUri = nil,
            Frame = p10
        }
    }
    local v3
    local v4 = false
    local clone = p10:Clone()

    clone.Name = `MainVideoPreload{2}`
    clone.Visible = false
    clone.Video = ""
    clone.Volume = 0
    clone.TimePosition = 0
    clone.Parent = p10.Parent
    table.insert(t2, {
        MediaIndex = nil,
        VideoUri = nil,
        Frame = clone
    })

    local clone2 = p10:Clone()

    clone2.Name = `MainVideoPreload{3}`
    clone2.Visible = false
    clone2.Video = ""
    clone2.Volume = 0
    clone2.TimePosition = 0
    clone2.Parent = p10.Parent
    table.insert(t2, {
        MediaIndex = nil,
        VideoUri = nil,
        Frame = clone2
    })

    local function findSlotByMediaIndex(p11) -- line: 124
        -- upvalues: t2 (copy)
        for _, v5 in t2 do
            if v5.MediaIndex == p11 then
                return v5
            end
        end

        return nil
    end

    local function acquireInactiveSlot(p12) -- line: 134
        -- upvalues: t2 (copy), v3 (ref)
        local v6 = false
        local v7

        for _, v8 in t2 do
            if v8.MediaIndex == p12 then
                v7 = v8
                v6 = true
                break
            end
        end

        if not v6 then
            v7 = nil
        end

        if v7 ~= nil then
            return v7
        end

        for _, v9 in t2 do
            if v9 ~= v3 and v9.MediaIndex == nil then
                return v9
            end
        end

        for _, v10 in t2 do
            if v10 ~= v3 then
                v10.Frame:Pause()
                v10.Frame.TimePosition = 0
                v10.Frame.Volume = 0
                v10.Frame.Visible = false
                v10.Frame.Video = ""
                v10.MediaIndex = nil
                v10.VideoUri = nil

                return v10
            end
        end

        error("Treadmill VideoFrame pool has no inactive slot available")
    end

    local function getActiveFrame() -- line: 156
        -- upvalues: p10 (copy), v3 (ref)
        local v11 = v3

        if v11 == nil then
            return p10
        end

        return v11.Frame
    end

    local function clearActive() -- line: 165
        -- upvalues: v3 (ref)
        local v12 = v3

        v3 = nil

        if v12 == nil then
            return
        end

        v12.Frame:Pause()
        v12.Frame.TimePosition = 0
        v12.Frame.Volume = 0
        v12.Frame.Visible = false
        v12.Frame.Video = ""
        v12.MediaIndex = nil
        v12.VideoUri = nil
    end

    local function preload(p13) -- line: 175
        -- upvalues: t2 (copy), v3 (ref), v4 (ref), acquireInactiveSlot (copy), primeHiddenSlot (copy)
        if v4 then
            return
        end

        local t5 = {}
        local v13 = if v3 == nil then 3 else 2
        local n1 = 0

        for _, v14 in ipairs(p13) do
            if v13 <= n1 then
                break
            end

            t5[v14.MediaIndex] = v14.MediaEntry
            n1 += 1
        end

        for _, v15 in t2 do
            if v15 ~= v3 and v15.MediaIndex ~= nil and t5[v15.MediaIndex] == nil then
                v15.Frame:Pause()
                v15.Frame.TimePosition = 0
                v15.Frame.Volume = 0
                v15.Frame.Visible = false
                v15.Frame.Video = ""
                v15.MediaIndex = nil
                v15.VideoUri = nil
            end
        end

        for _, v16 in ipairs(p13) do
            if t5[v16.MediaIndex] == nil then
                break
            end

            task.spawn(function() -- line: 207
                -- upvalues: v16 (copy), v4 (ref), acquireInactiveSlot (copy), primeHiddenSlot (copy)
                if not v4 then
                    primeHiddenSlot(acquireInactiveSlot(v16.MediaIndex), v16.MediaIndex, v16.MediaEntry)
                end
            end)
        end
    end

    return {
        Activate = function(p14, p15) -- activate | line: 218
            -- upvalues: p10 (copy), t2 (copy), v3 (ref), v4 (ref), acquireInactiveSlot (copy)
            if v4 then
                return p10
            end

            local v18 = false
            local v19

            for _, v20 in t2 do
                if v20.MediaIndex == p14 then
                    v19 = v20
                    v18 = true
                    break
                end
            end

            if not v18 then
                v19 = nil
            end

            local v21 = v19 or acquireInactiveSlot(p14)

            if v21.MediaIndex ~= p14 or v21.VideoUri ~= p15.Video then
                v21.Frame:Pause()
                v21.Frame.TimePosition = 0
                v21.Frame.Volume = 0
                v21.Frame.Visible = false
                v21.Frame.Video = ""
                v21.MediaIndex = nil
                v21.VideoUri = nil
                v21.MediaIndex = p14
                v21.VideoUri = p15.Video
                v21.Frame.Video = p15.Video
            end

            for _, v22 in t2 do
                v22.Frame.Visible = v22 == v21

                if v22 ~= v21 then
                    v22.Frame:Pause()
                    v22.Frame.Volume = 0
                    v22.Frame.TimePosition = 0
                end
            end

            v3 = v21
            v21.Frame.Volume = p15.Volume or 1
            v21.Frame.TimePosition = 0

            return v21.Frame
        end,
        ClearActive = clearActive,
        ClearAll = function() -- clearAll | line: 241
            -- upvalues: t2 (copy), v3 (ref)
            v3 = nil

            for _, v23 in t2 do
                v23.Frame:Pause()
                v23.Frame.TimePosition = 0
                v23.Frame.Volume = 0
                v23.Frame.Visible = false
                v23.Frame.Video = ""
                v23.MediaIndex = nil
                v23.VideoUri = nil
            end
        end,
        Destroy = function() -- destroy | line: 248
            -- upvalues: t2 (copy), v3 (ref), v4 (ref)
            v4 = true
            v3 = nil

            for _, v24 in t2 do
                v24.Frame:Pause()
                v24.Frame.TimePosition = 0
                v24.Frame.Volume = 0
                v24.Frame.Visible = false
                v24.Frame.Video = ""
                v24.MediaIndex = nil
                v24.VideoUri = nil
            end

            for i = 2, #t2 do
                t2[i].Frame:Destroy()
            end
        end,
        GetActiveFrame = getActiveFrame,
        Preload = preload
    }
end

return t1
