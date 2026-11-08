-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ObserveUITag = require(ReplicatedStorage.Client.ObserveUITag)

require(ReplicatedStorage.Packages.Trove)

local t1 = {}
local t2 = {}
local connection

local function DrawFrame(p1, p2) -- line: 34
    local Image = p1.Image
    local ImageRectSize = Image.ImageRectSize

    Image.ImageRectOffset = Vector2.new(ImageRectSize.X * (p2 % p1.Columns), ImageRectSize.Y * (p2 // p1.Columns))
end

local function StepSprites(p3) -- line: 41
    -- upvalues: t1 (copy), connection (ref)
    for v1 in t1 do
        v1.Remaining -= p3

        if not (v1.Remaining > 0) then
            if v1.NextFrame >= v1.FrameCount then
                if v1.Loops then
                    v1.NextFrame = 0
                    v1.Remaining = 0
                else
                    v1.IsFinished = true
                    t1[v1] = nil
                end
            else
                local NextFrame, Image = v1.NextFrame, v1.Image
                local ImageRectSize = Image.ImageRectSize

                Image.ImageRectOffset = Vector2.new(ImageRectSize.X * (NextFrame % v1.Columns), ImageRectSize.Y * (NextFrame // v1.Columns))
                v1.NextFrame += 1
                v1.Remaining = v1.SecondsPerFrame
            end
        end
    end

    if next(t1) ~= nil or connection == nil then
        return
    end

    connection:Disconnect()
    connection = nil
end

local function CreateSprite(p4) -- line: 69
    local Cells = p4:GetAttribute("Cells")
    local FPS = p4:GetAttribute("FPS")

    if typeof(Cells) == "Vector2" and not (Cells.X < 1) and not (Cells.Y < 1) and Cells.X % 1 == 0 and Cells.Y % 1 == 0 then
        local t3, v2

        if type(FPS) == "number" and FPS > 0 and FPS ~= 1e999 then
            t3 = {
                NextFrame = 0,
                Remaining = 0,
                IsFinished = false,
                Image = p4,
                Columns = Cells.X,
                FrameCount = Cells.X * Cells.Y,
                SecondsPerFrame = 1 / FPS
            }
            v2 = p4:GetAttribute("Loop") ~= false
            t3.Loops = v2

            return t3
        end

        warn((("%* needs a positive FPS to play its sprite sheet"):format((p4:GetFullName()))))

        return nil
    end

    warn((("%* needs a whole number Cells grid to play its sprite sheet"):format((p4:GetFullName()))))

    return nil
end

local function GetSprite(p5, p6) -- line: 98
    -- upvalues: t1 (copy), t2 (copy), CreateSprite (copy)
    local v3 = t2[p5]

    if v3 ~= nil then
        return v3
    end

    local v4 = CreateSprite(p5)

    if v4 == nil then
        return nil
    end

    t2[p5] = v4
    p6:Add(function() -- line: 108
        -- upvalues: p5 (copy), v4 (copy), t1 (copy), t2 (copy)
        t2[p5] = nil
        t1[v4] = nil
    end)

    return v4
end

local function StartSprite(p7, p8, p9) -- line: 115
    -- upvalues: RunService (copy), t1 (copy), t2 (copy), connection (ref), StepSprites (copy), CreateSprite (copy)
    local v5 = t2[p7]

    if v5 == nil then
        local v6 = CreateSprite(p7)

        if v6 ~= nil then
            t2[p7] = v6
            p9:Add(function() -- line: 108
                -- upvalues: p7 (copy), v6 (copy), t1 (copy), t2 (copy)
                t2[p7] = nil
                t1[v6] = nil
            end)
            v5 = v6
        else
            v5 = nil
        end
    end

    if v5 == nil or v5.IsFinished then
        return
    end

    t1[v5] = true

    if connection == nil then
        connection = RunService.Heartbeat:Connect(StepSprites)
    end

    p8:Add(function() -- line: 124
        -- upvalues: v5 (ref), t1 (copy)
        t1[v5] = nil
    end)
end

ObserveUITag("PlaySprite", function(p10, p11, p12) -- PlaySprite | line: 129
    -- upvalues: StartSprite (copy)
    if p10:IsA("ImageLabel") then
        StartSprite(p10, p11, p12)
    else
        warn((("PlaySprite tag on %* needs an ImageLabel"):format((p10:GetFullName()))))
    end
end)

return nil
