local Base64Util = {}

local BASE64_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local BASE64_DECODE_MAP = {}
for i = 1, #BASE64_ALPHABET do
    BASE64_DECODE_MAP[string.sub(BASE64_ALPHABET, i, i)] = i - 1
end

function Base64Util.Encode(input: string): string
    local out = {}
    local outIndex = 1
    local i = 1
    while i <= #input do
        local b1 = string.byte(input, i) or 0
        local b2 = string.byte(input, i + 1)
        local b3 = string.byte(input, i + 2)
        local hasB2 = b2 ~= nil
        local hasB3 = b3 ~= nil
        b2 = b2 or 0
        b3 = b3 or 0

        local triple = bit32.bor(bit32.lshift(b1, 16), bit32.lshift(b2, 8), b3)
        local c1 = bit32.band(bit32.rshift(triple, 18), 0x3F) + 1
        local c2 = bit32.band(bit32.rshift(triple, 12), 0x3F) + 1
        local c3 = bit32.band(bit32.rshift(triple, 6), 0x3F) + 1
        local c4 = bit32.band(triple, 0x3F) + 1

        out[outIndex] = string.sub(BASE64_ALPHABET, c1, c1)
        outIndex += 1
        out[outIndex] = string.sub(BASE64_ALPHABET, c2, c2)
        outIndex += 1
        out[outIndex] = hasB2 and string.sub(BASE64_ALPHABET, c3, c3) or "="
        outIndex += 1
        out[outIndex] = hasB3 and string.sub(BASE64_ALPHABET, c4, c4) or "="
        outIndex += 1
        i += 3
    end
    return table.concat(out)
end

function Base64Util.Decode(input: string): string
    local cleaned = string.gsub(input, "%s", "")
    local out = {}
    local outIndex = 1
    local i = 1
    while i <= #cleaned do
        local c1 = string.sub(cleaned, i, i)
        local c2 = string.sub(cleaned, i + 1, i + 1)
        local c3 = string.sub(cleaned, i + 2, i + 2)
        local c4 = string.sub(cleaned, i + 3, i + 3)
        if c1 == "" or c2 == "" then
            break
        end

        local n1 = BASE64_DECODE_MAP[c1]
        local n2 = BASE64_DECODE_MAP[c2]
        if n1 == nil or n2 == nil then
            error("Invalid base64 input")
        end

        local n3 = (c3 ~= "=" and BASE64_DECODE_MAP[c3]) or 0
        local n4 = (c4 ~= "=" and BASE64_DECODE_MAP[c4]) or 0

        local triple = bit32.bor(
            bit32.lshift(n1, 18),
            bit32.lshift(n2, 12),
            bit32.lshift(n3, 6),
            n4
        )

        out[outIndex] = string.char(bit32.band(bit32.rshift(triple, 16), 0xFF))
        outIndex += 1
        if c3 ~= "=" then
            out[outIndex] = string.char(bit32.band(bit32.rshift(triple, 8), 0xFF))
            outIndex += 1
        end
        if c4 ~= "=" then
            out[outIndex] = string.char(bit32.band(triple, 0xFF))
            outIndex += 1
        end
        i += 4
    end
    return table.concat(out)
end

return Base64Util
