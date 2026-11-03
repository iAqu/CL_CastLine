-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Client = require(script.Client)
local Server = require(script.Server)
local Freeze = require(script.Parent.Freeze)
return table.freeze({
	Server = Server,
	Client = Client,
	None = Freeze.None
})