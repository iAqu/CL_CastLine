-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3, p4) -- line: 24
    -- upvalues: t1 (copy)
    local track = p1:LoadAnimation(p2)
    local track2 = p1:LoadAnimation(p2)

    track.Looped = true
    track2.Looped = true

    return (setmetatable({
        _index = 1,
        _speed = 1,
        _playing = false,
        Track = track,
        _tracks = { track, track2 },
        _end = p3,
        _fade = p4 or 0.45
    }, t1))
end

function t1.Play(p5, p6) -- line: 45
    p5._playing = true
    p5.Track:Play(p6 or 0)
    p5.Track:AdjustSpeed(p5._speed)
end

function t1.Stop(p7, p8) -- line: 51
    p7._playing = false

    for _, v1 in p7._tracks do
        v1:Stop(p8 or 0.2)
    end
end

function t1.SetSpeed(p9, p10) -- line: 58
    if p10 == p9._speed then
        return
    end

    p9._speed = p10

    for _, v2 in p9._tracks do
        if v2.IsPlaying then
            v2:AdjustSpeed(p10)
        end
    end
end

function t1.Seek(p11, p12) -- line: 70
    p11.Track.TimePosition = p12 % p11._end
end

function t1.Step(p13, p14) -- line: 74
    local Track = p13.Track

    if not p14 or not p13._playing or not Track.IsPlaying or Track.TimePosition < p13._end - p13._fade * p13._speed then
        return
    end

    p13._index = 3 - p13._index

    local v3 = p13._tracks[p13._index]

    v3:Play(p13._fade)
    v3.TimePosition = 0
    v3:AdjustSpeed(p13._speed)
    Track:Stop(p13._fade)
    p13.Track = v3
end

return t1
