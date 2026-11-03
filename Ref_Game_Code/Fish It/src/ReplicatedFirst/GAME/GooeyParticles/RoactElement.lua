-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("ReplicatedStorage")
local defaultParticleProps = require(script.Parent.Utility.ParticleProps.defaultParticleProps)
local registerEmitter = require(script.Parent.GooeyEmitter.registerEmitter)
local Roact = require(script.Parent:WaitForChild("Internal"):WaitForChild("Roact"))
local v1 = Roact.PureComponent:extend("RoactElement")
v1.defaultProps = defaultParticleProps
function v1.init(p1) --[[ init | Line: 11 | Upvalues: Roact (copy) ]]
	p1.frameRef = Roact.createRef()
end
function v1.didMount(p1) --[[ didMount | Line: 15 ]]
	if p1.props.Enabled ~= true then
		return
	end
	p1:createEmitter()
end
function v1.didUpdate(p1, p2) --[[ didUpdate | Line: 21 ]]
	if p2.Enabled == p1.props.Enabled then
		return
	end
	if p1.props.Enabled == true then
		p1:createEmitter()
		return
	end
	p1:destroyEmitter()
end
function v1.render(p1) --[[ render | Line: 31 | Upvalues: Roact (copy) ]]
	return Roact.createElement("Frame", {
		AnchorPoint = p1.props.AnchorPoint,
		Position = p1.props.Position,
		Size = UDim2.fromOffset(0, 0),
		ZIndex = p1.props.ZIndex,
		[Roact.Ref] = p1.frameRef
	})
end
function v1.willUnmount(p1) --[[ willUnmount | Line: 41 ]]
	p1:destroyEmitter()
end
function v1.createEmitter(p1) --[[ createEmitter | Line: 45 | Upvalues: registerEmitter (copy) ]]
	if p1.particles ~= nil then
		return
	end
	p1.particles = registerEmitter(p1.frameRef:getValue(), {
		Acceleration = p1.props.Acceleration,
		Color = p1.props.Color,
		Image = p1.props.Image,
		Lifetime = p1.props.Lifetime,
		Rate = p1.props.Rate,
		Rotation = p1.props.Rotation,
		Size = p1.props.Size,
		Speed = p1.props.Speed,
		Spread = p1.props.Spread,
		Transparency = p1.props.Transparency,
		ZIndex = p1.props.ZIndex
	})
end
function v1.destroyEmitter(p1) --[[ destroyEmitter | Line: 63 ]]
	if p1.particles == nil then
		return
	end
	p1.particles()
	p1.particles = nil
end
return v1