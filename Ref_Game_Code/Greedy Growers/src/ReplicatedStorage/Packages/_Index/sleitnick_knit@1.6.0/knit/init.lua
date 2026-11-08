-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMLBGdhbWUKUnVuU2VydmljZQpHZXRTZXJ2aWNlCElzU2VydmVyB3JlcXVpcmUGc2NyaXB0CktuaXRTZXJ2ZXIORmluZEZpcnN0Q2hpbGQJSXNSdW5uaW5nB0Rlc3Ryb3kKS25pdENsaWVudAABBAAAAQIAKaMAAACkAAEAAAAAQG8CAgC8AAAWAwAAAJ8AAwK8AQALBAAAAJ8BAgIOAQgApAEGAAAAUECkAggAAABwQE0CAtgJAAAAnwECAIIBAACkAQgAAABwQG8DCQC8AQEDCgAAAJ8BAwIOAQcAvAIAswsAAACfAgICDgIDALwCAVAMAAAAnwICAaQCBgAAAFBApAMIAAAAcEBNAwMIDQAAAJ8CAgCCAgAADgMBBAAAAEADAgMDAwQDBQQAAFBAAwYEAABwQAMHAwgDCQMKAwsAAQABGAAAAAAAAAACAAAAAQAAAAAAAAACAAAAAAABAAAAAAEAAAIAAAAAAAAAAQAAAAAAKCMzACBE3tttDBzMI7x3iVg7JHQa51kB

-- https://lua.expert/
local RunService = game:GetService("RunService")

if RunService:IsServer() then
	return require(script.KnitServer)
end

local KnitServer = script:FindFirstChild("KnitServer")

if not (KnitServer and RunService:IsRunning()) then
	return require(script.KnitClient)
end

KnitServer:Destroy()

return require(script.KnitClient)