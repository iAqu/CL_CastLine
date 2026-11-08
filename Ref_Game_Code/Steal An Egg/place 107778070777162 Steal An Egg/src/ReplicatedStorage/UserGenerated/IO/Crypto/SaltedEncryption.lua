-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AES = require(game.ReplicatedStorage.UserGenerated.IO.Crypto.AES)
local Base64 = require(game.ReplicatedStorage.UserGenerated.IO.Base64)
local HMAC = require(game.ReplicatedStorage.UserGenerated.IO.Crypto.HMAC)
local ISAAC = require(game.ReplicatedStorage.UserGenerated.Randoms.ISAAC)
local SHA256 = require(game.ReplicatedStorage.UserGenerated.IO.Crypto.SHA256)

require(game.ReplicatedStorage.UserGenerated.IO.Crypto.Hash)

local v1 = ISAAC.Unique()

local function GetRandomBytes(p1) -- line: 44
    -- upvalues: v1 (copy)
    local v2 = buffer.create(p1)

    for i = 0, p1 - 1 do
        buffer.writeu8(v2, i, (v1:NextInteger(0, 255)))
    end

    return v2
end

local function PBKDF2(p2, p3, p4, p5, p6) -- line: 62
    -- upvalues: HMAC (copy)
    local v4 = HMAC.Derive(p6, p2)
    local OutputSize = p6.OutputSize
    local v6 = math.ceil(p4 / OutputSize)
    local v7 = buffer.create(p4)
    local n1 = 0

    for i = 1, v6 do
        local v8 = buffer.create(buffer.len(p3) + 4)

        buffer.copy(v8, 0, p3)
        buffer.writeu32(v8, buffer.len(p3), (bit32.byteswap(i)))

        local v11 = v4.DigestBuffer(v8)
        local v12 = buffer.create(buffer.len(v11))

        buffer.copy(v12, 0, v11)

        for _ = 2, p5 do
            v11 = v4.DigestBuffer(v11)

            for j = 0, buffer.len(v11) - 1 do
                buffer.writeu8(v12, j, (bit32.bxor(buffer.readu8(v12, j), (buffer.readu8(v11, j)))))
            end
        end

        local v17 = math.min(OutputSize, p4 - n1)

        buffer.copy(v7, n1, v12, 0, v17)
        n1 += v17
    end

    return v7
end

local function ApplyPKCS7Padding(p7) -- line: 109
    local v18 = buffer.len(p7)
    local v19 = 16 - v18 % 16
    local v20 = v18 + v19
    local v21 = buffer.create(v20)

    buffer.copy(v21, 0, p7)

    for i = v18, v20 - 1 do
        buffer.writeu8(v21, i, v19)
    end

    return v21
end

local function RemovePKCS7Padding(p8) -- line: 131
    local v22 = buffer.len(p8)

    if v22 == 0 then
        error("Invalid padding: empty input")
    end

    local v24 = buffer.readu8(p8, v22 - 1)

    if v24 < 1 or v24 > 16 then
        error("Invalid padding length: " .. v24)
    end

    for i = v22 - v24, v22 - 1 do
        if buffer.readu8(p8, i) ~= v24 then
            error("Invalid padding")
        end
    end

    local v25 = v22 - v24
    local v26 = buffer.create(v25)

    buffer.copy(v26, 0, p8, 0, v25)

    return v26
end

local function Encrypt(p9, p10, p11) -- line: 166
    -- upvalues: AES (copy), Base64 (copy), SHA256 (copy), GetRandomBytes (copy), PBKDF2 (copy), ApplyPKCS7Padding (copy)
    p11 = p11 or SHA256

    local v28 = buffer.fromstring(p9)
    local v29 = GetRandomBytes(8)
    local v30 = PBKDF2(p10, v29, 48, 10000, p11)
    local v31 = buffer.create(32)

    buffer.copy(v31, 0, v30, 0, 32)

    local v32 = buffer.create(16)

    buffer.copy(v32, 0, v30, 32, 16)

    local v33 = ApplyPKCS7Padding(v28)
    local v34 = AES.new(buffer.tostring(v31), AES.modes.CBC, AES.pads.None):Encrypt(v33, nil, v32)
    local v35 = 16 + buffer.len(v34)
    local v36 = buffer.create(v35)

    buffer.writestring(v36, 0, "Salted__")
    buffer.copy(v36, 8, v29)
    buffer.copy(v36, 16, v34)

    return buffer.tostring(Base64.EncodeBuffer(v36))
end

local function Decrypt(p12, p13, p14) -- line: 220
    -- upvalues: AES (copy), Base64 (copy), SHA256 (copy), PBKDF2 (copy), RemovePKCS7Padding (copy)
    p14 = p14 or SHA256

    local v38 = Base64.DecodeBuffer(buffer.fromstring(p12))

    if buffer.len(v38) < 16 then
        error("Invalid data: too short")
    end

    local v39 = buffer.create(8)

    buffer.copy(v39, 0, v38, 0, 8)

    if buffer.tostring(v39) ~= "Salted__" then
        error("Invalid data: Missing 'Salted__' header")
    end

    local v40 = buffer.create(8)

    buffer.copy(v40, 0, v38, 8, 8)

    local v41 = buffer.len(v38) - 16
    local v42 = buffer.create(v41)

    buffer.copy(v42, 0, v38, 16, v41)

    local v43 = PBKDF2(p13, v40, 48, 10000, p14)
    local v44 = buffer.create(32)

    buffer.copy(v44, 0, v43, 0, 32)

    local v45 = buffer.create(16)

    buffer.copy(v45, 0, v43, 32, 16)

    local v47 = RemovePKCS7Padding((AES.new(buffer.tostring(v44), AES.modes.CBC, AES.pads.None):Decrypt(v42, nil, v45)))

    return buffer.tostring(v47)
end

local function EncryptString(p15, p16, p17) -- line: 281
    -- upvalues: Encrypt (copy)
    return Encrypt(p15, buffer.fromstring(p16), p17)
end

local t1 = {
    Encrypt = Encrypt,
    Decrypt = Decrypt,
    EncryptString = EncryptString,
    DecryptString = function(p18, p19, p20) -- DecryptString | line: 294
        -- upvalues: Decrypt (copy)
        return Decrypt(p18, buffer.fromstring(p19), p20)
    end,
    PBKDF2 = PBKDF2,
    GetRandomBytes = GetRandomBytes
}

table.freeze(t1)

return t1
