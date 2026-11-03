-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Packet = require(script.Packet)
return {
	NewGiftPacket = Packet("NewGiftPacket", Packet.String, Packet.String):Response(Packet.Boolean8)
}