-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(game.ReplicatedStorage.UserGenerated.IO.Crypto.Hash)

local function Derive(p1, p2) -- line: 46
    local BlockSize = p1.BlockSize
    local v1 = if BlockSize < buffer.len(p2) then p1.DigestBuffer(p2) else p2
    local v2 = buffer.create(BlockSize)

    buffer.copy(v2, 0, v1)

    local v3 = buffer.create(BlockSize)
    local v4 = buffer.create(BlockSize)

    for i = 0, BlockSize - 1 do
        local v5 = buffer.readu8(v2, i)

        buffer.writeu8(v3, i, (bit32.bxor(v5, 92)))
        buffer.writeu8(v4, i, (bit32.bxor(v5, 54)))
    end

    local function ComputeHmac(p3) -- line: 69
        -- upvalues: p1 (copy), BlockSize (copy), v3 (copy), v4 (copy)
        local v8 = buffer.create(BlockSize + buffer.len(p3))

        buffer.copy(v8, 0, v4)
        buffer.copy(v8, BlockSize, p3)

        local v9 = p1.DigestBuffer(v8)
        local v10 = buffer.create(BlockSize + buffer.len(v9))

        buffer.copy(v10, 0, v3)
        buffer.copy(v10, BlockSize, v9)

        return p1.DigestBuffer(v10)
    end

    return {
        Name = "HMAC-" .. p1.Name,
        BlockSize = p1.BlockSize,
        OutputSize = p1.OutputSize,
        Digest = function(p4) -- Digest | line: 89
            -- upvalues: ComputeHmac (copy)
            return buffer.tostring(ComputeHmac(buffer.fromstring(p4)))
        end,
        DigestBuffer = ComputeHmac,
        DigestToBuffer = function(p5) -- DigestToBuffer | line: 93
            -- upvalues: ComputeHmac (copy)
            return ComputeHmac(buffer.fromstring(p5))
        end
    }
end

return {
    Derive = Derive,
    DeriveString = function(p6, p7) -- DeriveString | line: 108
        -- upvalues: Derive (copy)
        return (Derive(p6, buffer.fromstring(p7)))
    end
}
