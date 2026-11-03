-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local reconcileParticleProps = require(script:WaitForChild("Utility"):WaitForChild("ParticleProps"):WaitForChild("reconcileParticleProps"))
local registerEmitter = require(script:WaitForChild("GooeyEmitter"):WaitForChild("registerEmitter"))
local registerSingleEmitter = require(script:WaitForChild("GooeyEmitter"):WaitForChild("registerSingleEmitter"))
local RoactElement = require(script:WaitForChild("RoactElement"))
require(script:WaitForChild("Utility"):WaitForChild("Types"))
return {
	RoactElement = RoactElement,
	Emit = function(p1, p2, p3, p4) --[[ Emit | Line: 12 | Upvalues: reconcileParticleProps (copy), registerSingleEmitter (copy) ]]
		reconcileParticleProps(p3)
		local Frame = Instance.new("Frame")
		Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame.BackgroundTransparency = 1
		Frame.Position = p2
		Frame.Size = UDim2.fromOffset(0, 0)
		Frame.Parent = p1
		registerSingleEmitter(Frame, p3, p4, function() --[[ Line: 22 | Upvalues: Frame (ref) ]]
			Frame:Destroy()
			Frame = nil
		end)
	end,
	CreateEmitter = function(p1, p2, p3) --[[ CreateEmitter | Line: 28 | Upvalues: reconcileParticleProps (copy), registerEmitter (copy) ]]
		reconcileParticleProps(p3)
		local Frame = Instance.new("Frame")
		Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame.BackgroundTransparency = 1
		Frame.Position = p2
		Frame.Size = UDim2.fromOffset(0, 0)
		Frame.Parent = p1
		return {
			emitter = nil,
			container = Frame,
			props = p3,
			SetEnabled = function(p1, p2) --[[ SetEnabled | Line: 44 | Upvalues: registerEmitter (ref) ]]
				if p2 == true then
					if p1.emitter == nil then
						p1.emitter = registerEmitter(p1.container, p1.props)
					end
				else
					if p2 ~= false or p1.emitter == nil then
						return
					end
					p1.emitter()
					p1.emitter = nil
				end
			end,
			Destroy = function(p1, p2) --[[ Destroy | Line: 58 ]]
				if p1.emitter == nil then
					return
				end
				p1.emitter(function() --[[ Line: 60 | Upvalues: p1 (copy), p2 (copy) ]]
					p1.container:Destroy()
					if p2 == nil then
						return
					end
					p2()
				end)
			end
		}
	end
}