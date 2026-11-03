-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
function observeTag(p1, p2, p3) --[[ observeTag | Line: 56 | Upvalues: CollectionService (copy) ]]
	local t = {}
	local t2 = {}
	local v1 = nil
	local function IsGoodAncestor(p1) --[[ IsGoodAncestor | Line: 63 | Upvalues: p3 (copy) ]]
		if p3 == nil then
			return true
		else
			for v1, v2 in p3 do
				if p1:IsDescendantOf(v2) then
					return true
				end
			end
			return false
		end
	end
	local function AttemptStartup(p12) --[[ AttemptStartup | Line: 77 | Upvalues: t (copy), p2 (copy), p1 (copy) ]]
		t[p12] = "__inflight__"
		task.defer(function() --[[ Line: 82 | Upvalues: t (ref), p12 (copy), p2 (ref), p1 (ref) ]]
			if t[p12] == "__inflight__" then
				local v1, v2 = xpcall(function(p1) --[[ Line: 88 | Upvalues: p2 (ref) ]]
					local v1 = p2(p1)
					if v1 ~= nil then
						assert(typeof(v1) == "function", "callback must return a function or nil")
					end
					return v1
				end, debug.traceback, p12)
				if v1 then
					if t[p12] == "__inflight__" then
						t[p12] = v2
					elseif v2 ~= nil then
						task.spawn(v2)
					end
				else
					local v3 = string.split(v2, "\n")[1]
					local v4 = string.find(v3, ": ")
					warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, if v4 then v3:sub(v4 + 1) else "", v2)))
				end
			end
		end)
	end
	local function AttemptCleanup(p1) --[[ AttemptCleanup | Line: 120 | Upvalues: t (copy) ]]
		local v1 = t[p1]
		t[p1] = "__dead__"
		if typeof(v1) == "function" then
			task.spawn(v1)
		end
	end
	local function OnAncestryChanged(p12) --[[ OnAncestryChanged | Line: 129 | Upvalues: p3 (copy), t (copy), p2 (copy), p1 (copy) ]]
		local v1, v2
		if p3 == nil then
			v1 = true
		else
			for v3, v4 in p3 do
				if p12:IsDescendantOf(v4) then
					v1 = true
					if v1 then
						if t[p12] == "__dead__" then
							t[p12] = "__inflight__"
							task.defer(function() --[[ Line: 82 | Upvalues: t (ref), p12 (copy), p2 (ref), p1 (ref) ]]
								if t[p12] == "__inflight__" then
									local v1, v2 = xpcall(function(p1_2) --[[ Line: 88 | Upvalues: p2 (ref) ]]
										local v1 = p2(p1_2)
										if v1 ~= nil then
											assert(typeof(v1) == "function", "callback must return a function or nil")
										end
										return v1
									end, debug.traceback, p12)
									if v1 then
										if t[p12] == "__inflight__" then
											t[p12] = v2
										elseif v2 ~= nil then
											task.spawn(v2)
										end
									else
										local v3 = string.split(v2, "\n")[1]
										local v4 = string.find(v3, ": ")
										warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, if v4 then v3:sub(v4 + 1) else "", v2)))
									end
								end
							end)
							return
						end
					else
						v2 = t[p12]
						t[p12] = "__dead__"
						if typeof(v2) ~= "function" then
							return
						end
						task.spawn(v2)
					end
					return
				end
			end
			v1 = false
		end
		if v1 then
			if t[p12] == "__dead__" then
				t[p12] = "__inflight__"
				task.defer(function() --[[ Line: 82 | Upvalues: t (ref), p12 (copy), p2 (ref), p1 (ref) ]]
					if t[p12] == "__inflight__" then
						local v1, v2 = xpcall(function(p1_2) --[[ Line: 88 | Upvalues: p2 (ref) ]]
							local v1 = p2(p1_2)
							if v1 ~= nil then
								assert(typeof(v1) == "function", "callback must return a function or nil")
							end
							return v1
						end, debug.traceback, p12)
						if v1 then
							if t[p12] == "__inflight__" then
								t[p12] = v2
							elseif v2 ~= nil then
								task.spawn(v2)
							end
						else
							local v3 = string.split(v2, "\n")[1]
							local v4 = string.find(v3, ": ")
							warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, if v4 then v3:sub(v4 + 1) else "", v2)))
						end
					end
				end)
			end
		else
			v2 = t[p12]
			t[p12] = "__dead__"
			if typeof(v2) ~= "function" then
				return
			end
			task.spawn(v2)
		end
	end
	local function OnInstanceAdded(p12) --[[ OnInstanceAdded | Line: 139 | Upvalues: v1 (ref), t (copy), t2 (copy), p3 (copy), p2 (copy), p1 (copy) ]]
		if v1.Connected and t[p12] == nil then
			t[p12] = "__dead__"
			t2[p12] = p12.AncestryChanged:Connect(function() --[[ Line: 149 | Upvalues: p12 (copy), p3 (ref), t (ref), p2 (ref), p1 (ref) ]]
				local v1 = p12
				local v2, v3
				if p3 == nil then
					v2 = true
				else
					for v4, v5 in p3 do
						if v1:IsDescendantOf(v5) then
							v2 = true
							if v2 then
								if t[v1] == "__dead__" then
									t[v1] = "__inflight__"
									task.defer(function() --[[ Line: 82 | Upvalues: t (ref), v1 (copy), p2 (ref), p1 (ref) ]]
										if t[v1] == "__inflight__" then
											local v12, v2 = xpcall(function(p1_2) --[[ Line: 88 | Upvalues: p2 (ref) ]]
												local v1 = p2(p1_2)
												if v1 ~= nil then
													assert(typeof(v1) == "function", "callback must return a function or nil")
												end
												return v1
											end, debug.traceback, v1)
											if v12 then
												if t[v1] == "__inflight__" then
													t[v1] = v2
												elseif v2 ~= nil then
													task.spawn(v2)
												end
											else
												local v3 = string.split(v2, "\n")[1]
												local v4 = string.find(v3, ": ")
												warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, if v4 then v3:sub(v4 + 1) else "", v2)))
											end
										end
									end)
									return
								end
							else
								v3 = t[v1]
								t[v1] = "__dead__"
								if typeof(v3) ~= "function" then
									return
								end
								task.spawn(v3)
							end
							return
						end
					end
					v2 = false
				end
				if v2 then
					if t[v1] == "__dead__" then
						t[v1] = "__inflight__"
						task.defer(function() --[[ Line: 82 | Upvalues: t (ref), v1 (copy), p2 (ref), p1 (ref) ]]
							if t[v1] == "__inflight__" then
								local v12, v2 = xpcall(function(p1_2) --[[ Line: 88 | Upvalues: p2 (ref) ]]
									local v1 = p2(p1_2)
									if v1 ~= nil then
										assert(typeof(v1) == "function", "callback must return a function or nil")
									end
									return v1
								end, debug.traceback, v1)
								if v12 then
									if t[v1] == "__inflight__" then
										t[v1] = v2
									elseif v2 ~= nil then
										task.spawn(v2)
									end
								else
									local v3 = string.split(v2, "\n")[1]
									local v4 = string.find(v3, ": ")
									warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, if v4 then v3:sub(v4 + 1) else "", v2)))
								end
							end
						end)
					end
				else
					v3 = t[v1]
					t[v1] = "__dead__"
					if typeof(v3) ~= "function" then
						return
					end
					task.spawn(v3)
				end
			end)
			local v12, v2
			if p3 == nil then
				v12 = true
			else
				for v3, v4 in p3 do
					if p12:IsDescendantOf(v4) then
						v12 = true
						if v12 then
							if t[p12] == "__dead__" then
								t[p12] = "__inflight__"
								task.defer(function() --[[ Line: 82 | Upvalues: t (ref), p12 (copy), p2 (ref), p1 (ref) ]]
									if t[p12] == "__inflight__" then
										local v1, v2 = xpcall(function(p1_2) --[[ Line: 88 | Upvalues: p2 (ref) ]]
											local v1 = p2(p1_2)
											if v1 ~= nil then
												assert(typeof(v1) == "function", "callback must return a function or nil")
											end
											return v1
										end, debug.traceback, p12)
										if v1 then
											if t[p12] == "__inflight__" then
												t[p12] = v2
											elseif v2 ~= nil then
												task.spawn(v2)
											end
										else
											local v3 = string.split(v2, "\n")[1]
											local v4 = string.find(v3, ": ")
											warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, if v4 then v3:sub(v4 + 1) else "", v2)))
										end
									end
								end)
								return
							end
						else
							v2 = t[p12]
							t[p12] = "__dead__"
							if typeof(v2) ~= "function" then
								return
							end
							task.spawn(v2)
						end
						return
					end
				end
				v12 = false
			end
			if v12 then
				if t[p12] == "__dead__" then
					t[p12] = "__inflight__"
					task.defer(function() --[[ Line: 82 | Upvalues: t (ref), p12 (copy), p2 (ref), p1 (ref) ]]
						if t[p12] == "__inflight__" then
							local v1, v2 = xpcall(function(p1_2) --[[ Line: 88 | Upvalues: p2 (ref) ]]
								local v1 = p2(p1_2)
								if v1 ~= nil then
									assert(typeof(v1) == "function", "callback must return a function or nil")
								end
								return v1
							end, debug.traceback, p12)
							if v1 then
								if t[p12] == "__inflight__" then
									t[p12] = v2
								elseif v2 ~= nil then
									task.spawn(v2)
								end
							else
								local v3 = string.split(v2, "\n")[1]
								local v4 = string.find(v3, ": ")
								warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, if v4 then v3:sub(v4 + 1) else "", v2)))
							end
						end
					end)
				end
			else
				v2 = t[p12]
				t[p12] = "__dead__"
				if typeof(v2) ~= "function" then
					return
				end
				task.spawn(v2)
			end
		end
	end
	local function OnInstanceRemoved(p1) --[[ OnInstanceRemoved | Line: 155 | Upvalues: t (copy), t2 (copy) ]]
		local v1 = t[p1]
		t[p1] = "__dead__"
		if typeof(v1) == "function" then
			task.spawn(v1)
		end
		local v2 = t2[p1]
		if v2 then
			v2:Disconnect()
			t2[p1] = nil
		end
		t[p1] = nil
	end
	v1 = CollectionService:GetInstanceAddedSignal(p1):Connect(OnInstanceAdded)
	local v2 = CollectionService:GetInstanceRemovedSignal(p1):Connect(OnInstanceRemoved)
	task.defer(function() --[[ Line: 172 | Upvalues: v1 (ref), CollectionService (ref), p1 (copy), OnInstanceAdded (copy) ]]
		if v1.Connected then
			for v12, v2 in CollectionService:GetTagged(p1) do
				task.spawn(OnInstanceAdded, v2)
			end
		end
	end)
	return function() --[[ Line: 183 | Upvalues: v1 (ref), v2 (ref), t (copy), t2 (copy) ]]
		v1:Disconnect()
		v2:Disconnect()
		local v12 = next(t)
		while v12 do
			local v22 = t[v12]
			t[v12] = "__dead__"
			if typeof(v22) == "function" then
				task.spawn(v22)
			end
			local v3 = t2[v12]
			local v4, v5
			if v3 then
				v3:Disconnect()
				t2[v12] = nil
				v4 = v12
				t[v4] = nil
				v5 = next(t)
				v12 = v5
			end
			v4 = v12
			t[v4] = nil
			v5 = next(t)
			v12 = v5
		end
	end
end
return observeTag