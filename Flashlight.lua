local Player = game.Players.LocalPlayer
local Backpack = Player:WaitForChild("Backpack")

-- 1. Create the Tool
local Tool = Instance.new("Tool")
Tool.Name = "Flashlight"
Tool.RequiresHandle = true

-- 2. Create the Handle
local Handle = Instance.new("Part")
Handle.Name = "Handle"
Handle.Size = Vector3.new(0.4, 0.4, 1.5)
Handle.Color = Color3.fromRGB(30, 30, 30)
Handle.Material = Enum.Material.Metal
Handle.Parent = Tool

-- 3. Create the Lens (Visual Glow)
local Lens = Instance.new("SurfaceLight")
Lens.Name = "Glow"
Lens.Brightness = 2
Lens.Range = 5
Lens.Enabled = false
Lens.Parent = Handle

-- 4. THE HIGH-POWER BEAM
local Light = Instance.new("SpotLight")
Light.Name = "Beam"
Light.Brightness = 15 -- Massive brightness boost
Light.Range = 120    -- Distance doubled
Light.Angle = 40     -- Narrower beam for more "focus"
Light.Enabled = false
Light.Face = Enum.NormalId.Front
Light.Shadows = true -- Makes it look high-quality/realistic
Light.Color = Color3.fromRGB(230, 245, 255) -- Tactical Cool White
Light.Parent = Handle

-- 5. Toggle Logic
Tool.Activated:Connect(function()
    Light.Enabled = not Light.Enabled
    Lens.Enabled = Light.Enabled
    
    -- Change handle material when on
    Handle.Material = Light.Enabled and Enum.Material.Neon or Enum.Material.Metal
end)

-- 6. Put it in Backpack
Tool.Parent = Backpack

print("Ultra-Bright Flashlight added! Go explore the dark.")
