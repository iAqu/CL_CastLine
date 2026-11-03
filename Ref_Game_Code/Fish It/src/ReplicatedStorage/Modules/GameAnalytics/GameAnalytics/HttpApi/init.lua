-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local Validation = require(script.Parent.Validation)
local Version = require(script.Parent.Version)
local HashLib = require(script.HashLib)
local t = {
	protocol = "https",
	hostName = "api.gameanalytics.com",
	version = "v2",
	remoteConfigsVersion = "v1",
	initializeUrlPath = "init",
	eventsUrlPath = "events",
	EGAHTTPApiResponse = {
		NoResponse = 0,
		BadResponse = 1,
		RequestTimeout = 2,
		JsonEncodeFailed = 3,
		JsonDecodeFailed = 4,
		InternalServerError = 5,
		BadRequest = 6,
		Unauthorized = 7,
		UnknownResponseCode = 8,
		Ok = 9,
		Created = 10
	}
}
local HttpService = game:GetService("HttpService")
local Logger = require(script.Parent.Logger)
local v1 = if RunService:IsStudio() then "https" else t.protocol
local v4 = v1 .. "://" .. (if RunService:IsStudio() then "sandbox-" else "") .. t.hostName .. "/" .. t.version
local v5 = if RunService:IsStudio() then "https" else t.protocol
local v8 = v5 .. "://" .. (if RunService:IsStudio() then "sandbox-" else "") .. t.hostName .. "/remote_configs/" .. t.remoteConfigsVersion
local function getInitAnnotations(p1, p2, p3) --[[ getInitAnnotations | Line: 44 | Upvalues: Version (copy) ]]
	return {
		user_id = tostring(p3) .. p2.CustomUserId,
		sdk_version = "roblox " .. Version.SdkVersion,
		os_version = p2.OS,
		platform = p2.Platform,
		build = p1,
		session_num = p2.Sessions,
		random_salt = p2.Sessions
	}
end
local function encode(p1, p2) --[[ encode | Line: 58 | Upvalues: Logger (copy), HashLib (copy), RunService (copy) ]]
	if not p2 then
		Logger:w("Error encoding, invalid SecretKey")
		return
	end
	return HashLib.base64_encode((HashLib.hmac(HashLib.sha256, if RunService:IsStudio() then "16813a12f718bc5c620f56944e1abc3ea13ccbac" else p2, p1, true)))
end
local function processRequestResponse(p1, p2) --[[ processRequestResponse | Line: 76 | Upvalues: Logger (copy), t (copy) ]]
	local StatusCode = p1.StatusCode
	local Body = p1.Body
	if Body and #Body ~= 0 then
		if StatusCode == 200 then
			return t.EGAHTTPApiResponse.Ok
		end
		if StatusCode == 201 then
			return t.EGAHTTPApiResponse.Created
		end
		if StatusCode == 0 or StatusCode == 401 then
			Logger:d(p2 .. " request. 401 - Unauthorized.")
			return t.EGAHTTPApiResponse.Unauthorized
		end
		if StatusCode == 400 then
			Logger:d(p2 .. " request. 400 - Bad Request.")
			return t.EGAHTTPApiResponse.BadRequest
		end
		if StatusCode == 500 then
			Logger:d(p2 .. " request. 500 - Internal Server Error.")
			return t.EGAHTTPApiResponse.InternalServerError
		else
			return t.EGAHTTPApiResponse.UnknownResponseCode
		end
	else
		Logger:d(p2 .. " request. failed. Might be no connection. Status code: " .. tostring(StatusCode))
		return t.EGAHTTPApiResponse.NoResponse
	end
end
function t.initRequest(p1, p2, p3, p4, p5, p6) --[[ initRequest | Line: 103 | Upvalues: v8 (copy), t (copy), RunService (copy), v4 (copy), Logger (copy), HttpService (copy), Version (copy), HashLib (copy), processRequestResponse (copy), Validation (copy) ]]
	local v1 = v8 .. "/" .. t.initializeUrlPath .. "?game_key=" .. p2 .. "&interval_seconds=0&configs_hash=" .. (p5.ConfigsHash or "")
	if RunService:IsStudio() then
		v1 = v4 .. "/5c6bcb5402204249437fb5a7a80a4959/" .. p1.initializeUrlPath
	end
	Logger:d("Sending \'init\' URL: " .. v1)
	local v2 = HttpService:JSONEncode({
		user_id = tostring(p6) .. p5.CustomUserId,
		sdk_version = "roblox " .. Version.SdkVersion,
		os_version = p5.OS,
		platform = p5.Platform,
		build = p4,
		session_num = p5.Sessions,
		random_salt = p5.Sessions
	}):gsub("\"country_code\":\"unknown\"", "\"country_code\":null")
	local v3 = v2
	local v42
	if p3 then
		v42 = HashLib.base64_encode((HashLib.hmac(HashLib.sha256, if RunService:IsStudio() then "16813a12f718bc5c620f56944e1abc3ea13ccbac" else p3, v3, true)))
	else
		Logger:w("Error encoding, invalid SecretKey")
		v42 = nil
	end
	Logger:d("init payload: " .. v2)
	local v7 = nil
	local v82, v9 = pcall(function() --[[ Line: 124 | Upvalues: v7 (ref), HttpService (ref), v1 (ref), v42 (copy), v2 (ref) ]]
		v7 = HttpService:RequestAsync({
			Method = "POST",
			Url = v1,
			Headers = {
				Authorization = v42,
				["Content-Type"] = "application/json"
			},
			Body = v2
		})
	end)
	if not v82 then
		Logger:d("Failed Init Call. error: " .. v9)
		return {
			body = nil,
			statusCode = t.EGAHTTPApiResponse.UnknownResponseCode
		}
	end
	Logger:d("init request content: " .. v7.Body)
	local v10 = processRequestResponse(v7, "Init")
	if v10 ~= t.EGAHTTPApiResponse.Ok and (v10 ~= t.EGAHTTPApiResponse.Created and v10 ~= t.EGAHTTPApiResponse.BadRequest) then
		Logger:d("Failed Init Call. URL: " .. v1 .. ", JSONString: " .. v2 .. ", Authorization: " .. v42)
		return {
			body = nil,
			statusCode = v10
		}
	end
	local v11 = nil
	if not pcall(function() --[[ Line: 164 | Upvalues: v11 (ref), HttpService (ref), v7 (ref) ]]
		v11 = HttpService:JSONDecode(v7.Body)
	end) then
		Logger:d("Failed Init Call. Json decoding failed: " .. v9)
		return {
			body = nil,
			statusCode = t.EGAHTTPApiResponse.JsonDecodeFailed
		}
	end
	if v10 == t.EGAHTTPApiResponse.BadRequest then
		Logger:d("Failed Init Call. Bad request. Response: " .. v7.Body)
		return {
			body = nil,
			statusCode = v10
		}
	end
	local v13 = v11
	if Validation:validateAndCleanInitRequestResponse(v13, v10 == t.EGAHTTPApiResponse.Created) then
		return {
			statusCode = v10,
			body = v11
		}
	else
		return {
			body = nil,
			statusCode = t.EGAHTTPApiResponse.BadResponse
		}
	end
end
function t.sendEventsInArray(p1, p2, p3, p4) --[[ sendEventsInArray | Line: 205 | Upvalues: Logger (copy), v4 (copy), RunService (copy), HttpService (copy), HashLib (copy), t (copy), processRequestResponse (copy) ]]
	if not p4 or #p4 == 0 then
		Logger:d("sendEventsInArray called with missing eventArray")
		return
	end
	local v1 = v4 .. "/" .. p2 .. "/" .. p1.eventsUrlPath
	if RunService:IsStudio() then
		v1 = v4 .. "/5c6bcb5402204249437fb5a7a80a4959/" .. p1.eventsUrlPath
	end
	Logger:d("Sending \'events\' URL: " .. v1)
	local v2 = HttpService:JSONEncode(p4):gsub("\"country_code\":\"unknown\"", "\"country_code\":null")
	local v3 = v2
	local v42
	if p3 then
		v42 = HashLib.base64_encode((HashLib.hmac(HashLib.sha256, if RunService:IsStudio() then "16813a12f718bc5c620f56944e1abc3ea13ccbac" else p3, v3, true)))
	else
		Logger:w("Error encoding, invalid SecretKey")
		v42 = nil
	end
	local v7 = nil
	local v8, v9 = pcall(function() --[[ Line: 225 | Upvalues: v7 (ref), HttpService (ref), v1 (ref), v42 (copy), v2 (ref) ]]
		v7 = HttpService:RequestAsync({
			Method = "POST",
			Url = v1,
			Headers = {
				Authorization = v42,
				["Content-Type"] = "application/json"
			},
			Body = v2
		})
	end)
	if not v8 then
		Logger:d("Failed Events Call. error: " .. v9)
		return {
			body = nil,
			statusCode = t.EGAHTTPApiResponse.UnknownResponseCode
		}
	end
	Logger:d("body: " .. v7.Body)
	local v10 = processRequestResponse(v7, "Events")
	if v10 ~= t.EGAHTTPApiResponse.Ok and (v10 ~= t.EGAHTTPApiResponse.Created and v10 ~= t.EGAHTTPApiResponse.BadRequest) then
		Logger:d("Failed Events Call. URL: " .. v1 .. ", JSONString: " .. v2 .. ", Authorization: " .. v42)
		return {
			body = nil,
			statusCode = v10
		}
	end
	local v11 = nil
	pcall(function() --[[ Line: 264 | Upvalues: v11 (ref), HttpService (ref), v7 (ref) ]]
		v11 = HttpService:JSONDecode(v7.Body)
	end)
	if not v11 then
		Logger:d("Failed Events Call. Json decoding failed")
		return {
			body = nil,
			statusCode = t.EGAHTTPApiResponse.JsonDecodeFailed
		}
	end
	if v10 == t.EGAHTTPApiResponse.BadRequest then
		Logger:d("Failed Events Call. Bad request. Response: " .. v7.Body)
		return {
			body = nil,
			statusCode = v10
		}
	else
		return {
			statusCode = t.EGAHTTPApiResponse.Ok,
			body = v11
		}
	end
end
return t