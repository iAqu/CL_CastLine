-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local v1 = require("./logger")
local v2 = require("./utility")
local v3 = require("../obj/Bezier")
return {
	fromParams = function(p1, p2, p3, p4, p5, p6, p7) --[[ fromParams | Line: 10 | Upvalues: v2 (copy), v1 (copy), v3 (copy), RunService (copy) ]]
		local v12, v22 = pcall(function() --[[ Line: 19 | Upvalues: v2 (ref), p1 (copy) ]]
			return v2.deserializePath(p1)
		end)
		if not v12 then
			v1.error((("failed to decode bezier path data with error: %*"):format(v22)))
		end
		local v32 = v3.new(v22, 0)
		local v4 = 0
		local v5 = nil
		local function step(p1) --[[ step | Line: 33 | Upvalues: p6 (copy), v4 (ref), p2 (copy), v32 (copy), p3 (copy), p4 (copy), v5 (ref), p5 (copy) ]]
			if not p6 and v4 == 0 then
				v4 = math.clamp(v4 + p1, 0, (math.max(p2, 0)))
			end
			local v52 = p3(1 - v32:getEase((math.clamp(v4 / p2, 0, 1))).y, p1, v4)
			local v6, v7, v8
			if v52 ~= nil and not if p2 == 0 then if p2 < v4 then true else false else p2 <= v4 then
				if v52 then
					v6 = v4 + v52
					v7 = p2
					v8 = math.max(p2, 0.001)
					v4 = math.clamp(v6, 0, v8)
				end
				return
			end
			if p4 and p4.Connected then
				if v52 then
					v6 = v4 + v52
					v7 = p2
					v8 = math.max(p2, 0.001)
					v4 = math.clamp(v6, 0, v8)
				end
			else
				v5()
				if p5 then
					p5(true)
				end
			end
		end
		if p7 then
			local v6 = v2.getRanomId()
			RunService:BindToRenderStep(v6, p7, step)
			local v7 = true
			v5 = function() --[[ Line: 78 | Upvalues: v7 (ref), RunService (ref), v6 (copy) ]]
				if v7 then
					v7 = false
					RunService:UnbindFromRenderStep(v6)
				end
			end
			return v5
		else
			local v8 = RunService.RenderStepped:Connect(step)
			v5 = function() --[[ Line: 66 | Upvalues: v8 (ref) ]]
				v8:Disconnect()
			end
			return v8
		end
	end,
	timer = function(p1, p2, p3, p4, p5) --[[ timer | Line: 92 | Upvalues: RunService (copy), v2 (copy) ]]
		local v1 = coroutine.running()
		local v22 = 0
		local v3 = nil
		local function step(p12) --[[ step | Line: 105 | Upvalues: p2 (copy), v22 (ref), p1 (copy), p3 (copy), v3 (ref), v1 (copy) ]]
			local v12 = p2(p12, v22)
			local v2, v32, v4
			if v12 ~= nil and not if p1 == 0 then if p1 < v22 then true else false else p1 <= v22 then
				if v12 then
					v2 = v22 + v12
					v32 = p1
					v4 = math.max(p1, 0.001)
					v22 = math.clamp(v2, 0, v4)
				end
				return
			end
			if p3 and p3.Connected then
				if v12 then
					v2 = v22 + v12
					v32 = p1
					v4 = math.max(p1, 0.001)
					v22 = math.clamp(v2, 0, v4)
				end
			else
				v3()
				task.spawn(v1)
			end
		end
		if p5 then
			local v4 = v2.getRanomId()
			RunService:BindToRenderStep(v4, p5, step)
			local v5 = true
			v3 = function() --[[ Line: 135 | Upvalues: v5 (ref), RunService (ref), v4 (copy) ]]
				if v5 then
					v5 = false
					RunService:UnbindFromRenderStep(v4)
				end
			end
		else
			local v6 = RunService.RenderStepped:Connect(step)
			v3 = function() --[[ Line: 125 | Upvalues: v6 (copy) ]]
				v6:Disconnect()
			end
		end
		if p4 then
			table.insert(p4, v3)
		end
		coroutine.yield()
	end
}