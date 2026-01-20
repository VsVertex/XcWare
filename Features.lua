-- [[ XCWARE: FEATURES COMPONENT ]]
local CoreGui = game:GetService("CoreGui")

-- Wait for the MainGui to exist
local MainGui = CoreGui:WaitForChild("XcWare_System")
local MainFrame = MainGui:WaitForChild("MainFrame")
local FeatureFrame = MainFrame:WaitForChild("FeatureFrame")

-- The "Bridge" function: Use this when you want to add a button
local function AddFeature(name, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "_Btn"
    btn.Parent = FeatureFrame
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(45, 45, 45)
    stroke.Thickness = 1

    btn.MouseButton1Click:Connect(callback)
end

-- [[ NO FEATURES ADDED YET - WAITING FOR YOUR INPUT ]]
