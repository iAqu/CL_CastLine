-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observability = require(ReplicatedStorage.UserGenerated.Observability)
local Codec = require(ReplicatedStorage.UserGenerated.Observability.Codec)
local Op = Observability.Op
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 65
    -- upvalues: t1 (copy)
    return (setmetatable({
        Destroyed = false,
        Registry = p1,
        Stream = p1.Stream,
        Clock = p1.Clock,
        ClassId = p1.ClassIndex.AnimationTrack,
        Props = p1.ClassProps.AnimationTrack or {},
        PropIds = p1.ClassPropsByName.AnimationTrack or {},
        Tracks = {},
        Animators = setmetatable({}, {
            __mode = "k"
        })
    }, t1))
end

function t1.Watch(p2, p3) -- line: 82
    if p2.ClassId == nil or p2.PropIds.TimePosition == nil or p2.Destroyed or p2.Animators[p3] then
        return
    end

    p2.Animators[p3] = p3.AnimationPlayed:Connect(function(p4) -- line: 90
        -- upvalues: p2 (copy), p3 (copy)
        p2:_started(p3, p4)
    end)

    for _, v1 in p3:GetPlayingAnimationTracks() do
        p2:_started(p3, v1)
    end
end

function t1._started(p5, p6, p7) -- line: 98
    local Parent = p6.Parent

    if not p5.Destroyed and not p5.Tracks[p7] and Parent ~= nil then
        local v2 = p5.Clock()
        local Animation = p7.Animation
        local t5 = {
            Id = nil,
            Ended = nil,
            Owner = Parent,
            AddAt = v2,
            AnimationId = if Animation then Animation.AnimationId else "",
            Priority = p7.Priority,
            Looped = p7.Looped,
            Speed = p7.Speed,
            Weight = p7.WeightCurrent,
            Position = p7.TimePosition,
            PositionTime = v2,
            PollTime = v2,
            Connections = {}
        }

        local function ended() -- line: 120
            -- upvalues: p5 (copy), t5 (copy)
            t5.Ended = t5.Ended or p5.Clock()
        end

        t5.Connections = {
            p7.Ended:Connect(ended),
            p7.Destroying:Connect(ended)
        }
        p5.Tracks[p7] = t5
    end
end

function t1._writeProp(p8, p9, p10, p11, p12, p13) -- line: 129
    -- upvalues: Codec (copy), Op (copy)
    local v4 = p8.PropIds[p10]

    if v4 == nil then
        return
    end

    local Stream = p8.Stream

    Stream:Time(p12)

    local W = Stream.W

    if p13 then
        W:u8(Op.PropLerp)
        Codec.varuint(W, p9)
        Codec.varuint(W, v4)
        W:u8((math.clamp(math.round(p13 / 10), 1, 255)))
    else
        W:u8(Op.Prop)
        Codec.varuint(W, p9)
        Codec.varuint(W, v4)
    end

    Codec.writeValue(W, p8.Registry.PropTypes[v4], p11)
    Stream:EndRecord()
end

function t1._add(p14, p15, p16) -- line: 152
    -- upvalues: Codec (copy)
    local Registry = p14.Registry
    local v7 = Registry:Resolve(p16.Owner, p16.AddAt)

    if v7 == nil then
        return false
    end

    local v8 = Registry:Allocate(p15, v7)

    p16.Id = v8

    local v9 = Registry:AddTime(p16.AddAt)

    p16.Position += (v9 - p16.PositionTime) / 1000 * p16.Speed
    p16.PositionTime = v9
    p16.PollTime = v9

    local t6 = {
        AnimationId = p16.AnimationId,
        Priority = p16.Priority,
        Looped = p16.Looped,
        Speed = p16.Speed,
        WeightCurrent = p16.Weight,
        TimePosition = p16.Position
    }
    local W = p14.Stream.W

    Registry.Copies:WriteHead(W, v8, v7, p14.ClassId, p15.Name, false)
    W:u16(#p14.Props)

    for _, v10 in p14.Props do
        Codec.varuint(W, v10.Id)
        Codec.writeValue(W, v10.Type, t6[v10.Name])
    end

    p14.Stream:EndRecord()

    return true
end

function t1._poll(p17, p18, p19, p20) -- line: 186
    local Id = p19.Id
    local Priority = p18.Priority

    if Priority ~= p19.Priority then
        p19.Priority = Priority
        p17:_writeProp(Id, "Priority", Priority, p20)
    end

    local Speed, Looped, TimePosition, Length = p18.Speed, p18.Looped, p18.TimePosition, p18.Length
    local v11

    if Looped == p19.Looped then
        v11 = false
    else
        p19.Looped = Looped
        v11 = true
        p17:_writeProp(Id, "Looped", Looped, p20)
    end

    if math.abs(Speed - p19.Speed) > 0.001 then
        v11 = true
        p17:_writeProp(Id, "Speed", Speed, p20)
    end

    if not v11 then
        local v13 = p19.Position + (p20 - p19.PositionTime) / 1000 * p19.Speed
        local v14 = TimePosition - v13

        if Length > 0 then
            if Looped then
                v14 = (v14 + Length / 2) % Length - Length / 2
            elseif Length <= v13 and Length - 0.05 <= TimePosition then
                v14 = 0
            end
        end

        v11 = math.abs(v14) > 0.05
    end

    p19.Speed = Speed

    if v11 then
        p19.Position = TimePosition
        p19.PositionTime = p20
        p17:_writeProp(Id, "TimePosition", TimePosition, p20)
    end

    local WeightCurrent = p18.WeightCurrent
    local v15 = WeightCurrent == 0 or WeightCurrent == 1

    if math.abs(WeightCurrent - p19.Weight) > 0.02 or v15 and WeightCurrent ~= p19.Weight then
        p19.Weight = WeightCurrent

        local v17 = p20 - p19.PollTime

        if not (v17 > 0 and v17 <= 300) then
            v17 = nil
        end

        p17:_writeProp(Id, "WeightCurrent", WeightCurrent, p20, v17)
    end

    p19.PollTime = p20
end

function t1._forget(p21, p22, p23) -- line: 238
    for _, v18 in p23.Connections do
        v18:Disconnect()
    end

    p21.Tracks[p22] = nil

    if p23.Id then
        p21.Registry:Free(p22)
    end
end

function t1.Flush(p24) -- line: 250
    -- upvalues: Codec (copy), Op (copy)
    local v19 = p24.Clock()
    local Ids = p24.Registry.Ids

    for v20, v21 in p24.Tracks do
        local Id = v21.Id

        if Id and Ids[v21.Owner] == nil then
            p24.Registry:Free(v20)
            v21.Id = nil
            v21.AddAt = v19
            v21.Position = v20.TimePosition
            Id = nil
            v21.PositionTime = v19
        end

        if not v21.Ended and not v21.Owner:IsDescendantOf(game) or not v21.Ended and not v20.IsPlaying and v20.WeightCurrent <= 0 then
            v21.Ended = v19
        end

        if v21.Ended then
            if Id then
                local Stream = p24.Stream

                Stream:Time((math.max(v21.Ended, v21.PollTime)))

                local W = Stream.W

                W:u8(Op.Remove)
                Codec.varuint(W, Id)
                Stream:EndRecord()
            end

            p24:_forget(v20, v21)
        elseif Id then
            p24:_poll(v20, v21, v19)
        elseif not p24:_add(v20, v21) then
            v21.AddAt = v19
            v21.Position = v20.TimePosition
            v21.PositionTime = v19
        end
    end
end

function t1.Destroy(p25) -- line: 293
    p25.Destroyed = true

    for _, v22 in p25.Animators do
        v22:Disconnect()
    end

    table.clear(p25.Animators)

    for _, v23 in p25.Tracks do
        for _, v24 in v23.Connections do
            v24:Disconnect()
        end
    end

    table.clear(p25.Tracks)
end

return t1
