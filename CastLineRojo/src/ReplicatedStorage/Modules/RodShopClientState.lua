-- RemoteFunction responses may arrive after a newer inventory signal or a newer request.
local State = {}
State.__index = State

local function valid(snapshot)
	return typeof(snapshot) == "table" and snapshot.ok == true and typeof(snapshot.ownedRods) == "table"
end

function State.new()
	return setmetatable({ data = nil, eventVersion = 0, requestVersion = 0 }, State)
end

function State:BeginRequest()
	self.requestVersion += 1
	return { eventVersion = self.eventVersion, requestVersion = self.requestVersion }
end

function State:ApplyEvent(snapshot): boolean
	if not valid(snapshot) then
		return false
	end
	self.eventVersion += 1
	self.data = snapshot
	return true
end

function State:ApplyResponse(token, snapshot): boolean
	if
		not valid(snapshot)
		or token.eventVersion ~= self.eventVersion
		or token.requestVersion ~= self.requestVersion
	then
		return false
	end
	self.data = snapshot
	return true
end

return State
