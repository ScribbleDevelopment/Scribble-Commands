-- ====================================================================================
-- MODULE: Device Hardware Detector & Optimizer
-- ====================================================================================

local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local DeviceOptimizer = {}
DeviceOptimizer.Platform = "PC"
DeviceOptimizer.Settings = {
    FlightSpeed = 50,
    UIWidth = 600,
    TouchFriendly = false
}

function DeviceOptimizer:Detect()
    local isTouch = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    local platform = UserInputService:GetPlatform()
    
    if isTouch or platform == Enum.Platform.IOS or platform == Enum.Platform.Android or platform == Enum.Platform.UWP then
        self.Platform = "Mobile"
        self.Settings.FlightSpeed = 40 -- Slightly dampened for touch joystick stability
        self.Settings.UIWidth = 500  -- Compact for phone/tablet screens
        self.Settings.TouchFriendly = true
    else
        self.Platform = "PC"
        self.Settings.FlightSpeed = 60
        self.Settings.UIWidth = 620
        self.Settings.TouchFriendly = false
    end
    
    getgenv().ScribbleDeviceType = self.Platform
    getgenv().ScribbleDeviceSettings = self.Settings
    print("[Scribble Optimizer]: Detected hardware -> " .. self.Platform .. ". Applying optimized profile.")
    return self.Platform
end

return DeviceOptimizer:Detect()
