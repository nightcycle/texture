local packages = script.Parent

local Isotope = require(packages:WaitForChild("isotope"))

local Texture = {}

Texture.__index = Texture
Texture.ClassName = "Texture"

function Texture:Destroy()
	Isotope.Destroy(self)
end

function Texture:Apply(inst)
	inst.Color = self.Color:Get()
	inst.Material = self.Material:Get()
	inst.Reflectance = self.Reflectance:Get()
	inst.Transparency = self.Transparency:Get()
	inst.MaterialVariant = self.MaterialVariant:Get()
	if self.Map.Color and self.Map.Color:Get() then
		local surfaceAppearance = inst:FindFirstChildOfClass("SurfaceAppearance") or Instance.new("SurfaceAppearance", inst)
		surfaceAppearance.ColorMap = self.Map.Color:Get()
		surfaceAppearance.MetalnessMap = self.Map.Metal:Get()
		surfaceAppearance.NormalMap = self.Map.Normal:Get()
		surfaceAppearance.RoughnessMap = self.Map.Roughness:Get()
	end
end

function Texture.new(config)
	local self = setmetatable(Isotope.new(config), Texture)

	self.Color = self:Import(config.Color, Color3.new(0,0,0))
	self.Material = self:Import(config.Material, Enum.Material.SmoothPlastic)
	self.MaterialVariant = self:Import(config.MaterialVariant, "")

	self.Map = config.Map or {
		Color = self:Import(config.ColorMap),
		Metalness = self:Import(config.MetalnessMap),
		Normal = self:Import(config.NormalMap),
		Roughness = self:Import(config.RoughnessMap),
	}

	self.Reflectance = self:Import(config.Reflectance, 0)
	self.Transparency = self:Import(config.Transparency, 0)
	self.Code = self._Fuse.Computed(
		self.Color,
		self.Material,
		self.MaterialVariant,
		self.Reflectance,
		self.Transparency,
		function(col, mat, matVar, ref, trans)
			-- local rgb = col:ToRGB()
			local colString = tostring(col)
			local matString = tostring(mat.Name)..tostring(matVar)
			local refString = tostring(ref)
			local tranString = tostring(trans)
			return colString.."_"..matString.."_"..refString.."_"..tranString
		end
	)
	return self
end

setmetatable(Texture, Isotope)

return Texture