-- ====================================================================================
-- MODULE: Adaptive UI & Infinite Yield Command Bar
-- ====================================================================================

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("ScribbleCommandBarUI") then
    CoreGui.ScribbleCommandBarUI:Destroy()
end

local isMobile = _G.ScribbleDeviceType == "Mobile"
local uiWidth = _G.ScribbleDeviceSettings and _G.ScribbleDeviceSettings.UIWidth or 600

local UIModule = {}
UIModule.Gui = Instance.new("ScreenGui")
UIModule.Gui.Name = "ScribbleCommandBarUI"
UIModule.Gui.Parent = CoreGui
UIModule.Gui.ResetOnSpawn = false

local BarFrame = Instance.new("Frame")
BarFrame.Size = UDim2.new(0, uiWidth, 0, isMobile and 65 or 55)
BarFrame.Position = UDim2.new(0.5, -uiWidth/2, 1, isMobile and -90 or -80)
BarFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
BarFrame.BackgroundTransparency = 0.05
BarFrame.BorderSizePixel = 0
BarFrame.Visible = false
BarFrame.Parent = UIModule.Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = BarFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 2
Stroke.Transparency = 0.2
Stroke.Parent = BarFrame

UIModule.TextBox = Instance.new("TextBox")
UIModule.TextBox.Size = UDim2.new(1, -30, 1, 0)
UIModule.TextBox.Position = UDim2.new(0, 15, 0, 0)
UIModule.TextBox.BackgroundTransparency = 1
UIModule.TextBox.PlaceholderText = isMobile and "Tap here to type command (;fly, ;goto)..." or "Type command here (;fly, ;goto, ;loopgoto)..."
UIModule.TextBox.Text = ""
UIModule.TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
UIModule.TextBox.PlaceholderColor3 = Color3.fromRGB(130, 140, 160)
UIModule.TextBox.Font = Enum.Font.GothamMedium
UIModule.TextBox.TextSize = isMobile and 16 or 15
UIModule.TextBox.TextXAlignment = Enum.TextXAlignment.Left
UIModule.TextBox.Parent = BarFrame

-- On mobile, provide a toggle button if semicolon key is unavailable
if isMobile then
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
    ToggleBtn.Position = UDim2.new(0, 15, 0.5, -22)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    ToggleBtn.Text = "CMD"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 12
    ToggleBtn.Parent = UIModule.Gui
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 8)
    tCorner.Parent = ToggleBtn
    
    ToggleBtn.MouseButton1Click:Connect(function()
        BarFrame.Visible = not BarFrame.Visible
        if BarFrame.Visible then
            UIModule.TextBox:CaptureFocus()
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Semicolon then
        BarFrame.Visible = not BarFrame.Visible
        if BarFrame.Visible then
            UIModule.TextBox:CaptureFocus()
        end
    end
end)

return UIModule
