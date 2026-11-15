-- ====================================================================================
-- PROJECT: SCRIBBLE COMMANDS - MASTER UI & MULTI-TAB EXPLORER (MODULE)
-- ====================================================================================

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("ScribbleCommandBarUI") then
    CoreGui.ScribbleCommandBarUI:Destroy()
end

local isMobile = _G.ScribbleDeviceType == "Mobile"
local uiSettings = _G.ScribbleDeviceSettings or {UIWidth = 720, UIHeight = 480}

local UIModule = {}
UIModule.Gui = Instance.new("ScreenGui")
UIModule.Gui.Name = "ScribbleCommandBarUI"
UIModule.Gui.Parent = CoreGui
UIModule.Gui.ResetOnSpawn = false
UIModule.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, uiSettings.UIWidth, 0, uiSettings.UIHeight)
MainFrame.Position = UDim2.new(0.5, -uiSettings.UIWidth/2, 0.5, -uiSettings.UIHeight/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
MainFrame.BackgroundTransparency = 0.02
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = UIModule.Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 170, 255)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.25
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 350, 1, 0)
TitleLabel.Position = UDim2.new(0, 18, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Scribble Commands Studio [v13.5]"
TitleLabel.TextColor3 = Color3.fromRGB(240, 245, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -42, 0.5, -16)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 170, 1, -110)
Sidebar.Position = UDim2.new(0, 15, 0, 58)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 18, 26)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 10)
SideCorner.Parent = Sidebar

local SideLayout = Instance.new("UIListLayout")
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding = UDim.new(0, 8)
SideLayout.Parent = Sidebar

local ContentPane = Instance.new("Frame")
ContentPane.Name = "ContentPane"
ContentPane.Size = UDim2.new(1, -205, 1, -110)
ContentPane.Position = UDim2.new(0, 195, 0, 58)
ContentPane.BackgroundTransparency = 1
ContentPane.Parent = MainFrame

local function CreateTabButton(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 40)
    btn.Position = UDim2.new(0, 8, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 210, 230)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.LayoutOrder = order
    btn.Parent = Sidebar
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 8)
    bCorner.Parent = btn
    return btn
end

local TabCmdsBtn = CreateTabButton("Commands", 1)
local TabScannerBtn = CreateTabButton("Backdoor Scanner", 2)
local TabTeleportBtn = CreateTabButton("Teleport Hub", 3)
local TabSettingsBtn = CreateTabButton("Settings", 4)

local function CreatePane(name)
    local pane = Instance.new("ScrollingFrame")
    pane.Name = name
    pane.Size = UDim2.new(1, 0, 1, 0)
    pane.BackgroundTransparency = 1
    pane.Visible = false
    pane.CanvasSize = UDim2.new(0, 0, 0, 0)
    pane.ScrollBarThickness = 6
    pane.Parent = ContentPane
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = pane
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pane.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    return pane
end

local CmdsPane = CreatePane("CmdsPane")
local ScannerPane = CreatePane("ScannerPane")
local TeleportPane = CreatePane("TeleportPane")
local SettingsPane = CreatePane("SettingsPane")

CmdsPane.Visible = true

local function SwitchTab(activePane)
    CmdsPane.Visible = (CmdsPane == activePane)
    ScannerPane.Visible = (ScannerPane == activePane)
    TeleportPane.Visible = (TeleportPane == activePane)
    SettingsPane.Visible = (SettingsPane == activePane)
end

TabCmdsBtn.MouseButton1Click:Connect(function() SwitchTab(CmdsPane) end)
TabScannerBtn.MouseButton1Click:Connect(function() SwitchTab(ScannerPane) end)
TabTeleportBtn.MouseButton1Click:Connect(function() SwitchTab(TeleportPane) end)
TabSettingsBtn.MouseButton1Click:Connect(function() SwitchTab(SettingsPane) end)

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, 0, 0, 35)
SearchBox.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
SearchBox.PlaceholderText = "Search commands or filter registry..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderColor3 = Color3.fromRGB(130, 140, 160)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 13
SearchBox.LayoutOrder = 0
SearchBox.Parent = CmdsPane

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 6)
sCorner.Parent = SearchBox

local BarFrame = Instance.new("Frame")
BarFrame.Name = "CommandBar"
BarFrame.Size = UDim2.new(1, -30, 0, 45)
BarFrame.Position = UDim2.new(0, 15, 1, -52)
BarFrame.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
BarFrame.BorderSizePixel = 0
BarFrame.Parent = MainFrame

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(0, 8)
BarCorner.Parent = BarFrame

UIModule.TextBox = Instance.new("TextBox")
UIModule.TextBox.Size = UDim2.new(1, -20, 1, 0)
UIModule.TextBox.Position = UDim2.new(0, 10, 0, 0)
UIModule.TextBox.BackgroundTransparency = 1
UIModule.TextBox.PlaceholderText = "Type command here (;fly, ;goto, ;scan)..."
UIModule.TextBox.Text = ""
UIModule.TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
UIModule.TextBox.PlaceholderColor3 = Color3.fromRGB(130, 140, 160)
UIModule.TextBox.Font = Enum.Font.GothamMedium
UIModule.TextBox.TextSize = 14
UIModule.TextBox.TextXAlignment = Enum.TextXAlignment.Left
UIModule.TextBox.Parent = BarFrame

if isMobile then
    local MobileToggle = Instance.new("TextButton")
    MobileToggle.Size = UDim2.new(0, 50, 0, 50)
    MobileToggle.Position = UDim2.new(0, 15, 0.72, 0)
    MobileToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    MobileToggle.Text = "MENU"
    MobileToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MobileToggle.Font = Enum.Font.GothamBold
    MobileToggle.TextSize = 11
    MobileToggle.Parent = UIModule.Gui
    
    local mCorner = Instance.new("UICorner")
    mCorner.CornerRadius = UDim.new(0, 8)
    mCorner.Parent = MobileToggle
    
    MobileToggle.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            UIModule.TextBox:CaptureFocus()
        end
    end)
end

local function ExecuteCommand(rawText)
    if rawText:sub(1, 1) == ";" then
        rawText = rawText:sub(2)
    end
    
    local args = {}
    for word in rawText:gmatch("%S+") do
        table.insert(args, word)
    end
    
    local cmdName = table.remove(args, 1)
    if not cmdName then return end
    
    local executed = false
    for _, modName in ipairs({"Cmd1", "Cmd2", "Cmd3", "Cmd4"}) do
        local mod = getgenv()[modName]
        if mod and mod.List then
            local cmdData = mod.List[cmdName:lower()]
            if cmdData and cmdData.Callback then
                pcall(function()
                    cmdData.Callback(LocalPlayer, unpack(args))
                end)
                executed = true
                break
            end
        end
    end
    
    if not executed and cmdName:lower() == "scan" then
        local scanner = getgenv().BackdoorScanner
        if scanner and scanner.ScanGame then
            scanner:ScanGame()
        end
    end
end

UIModule.TextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = UIModule.TextBox.Text
        UIModule.TextBox.Text = ""
        MainFrame.Visible = false
        ExecuteCommand(text)
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Semicolon then
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            UIModule.TextBox:CaptureFocus()
        end
    end
end)

local function PopulateExplorer()
    local allCommands = {}
    for _, modName in ipairs({"Cmd1", "Cmd2", "Cmd3", "Cmd4"}) do
        local mod = getgenv()[modName]
        if mod and mod.List then
            for cmdName, data in pairs(mod.List) do
                table.insert(allCommands, {Name = cmdName, Desc = data.Description or "Client utility action"})
            end
        end
    end
    
    table.sort(allCommands, function(a, b) return a.Name < b.Name end)
    
    for idx, cData in ipairs(allCommands) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
        row.BorderSizePixel = 0
        row.LayoutOrder = idx + 1
        row.Parent = CmdsPane
        
        local rCorner = Instance.new("UICorner")
        rCorner.CornerRadius = UDim.new(0, 6)
        rCorner.Parent = row
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.35, 0, 1, 0)
        nameLabel.Position = UDim2.new(0, 12, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = ";" .. cData.Name
        nameLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 13
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = row
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0.65, -15, 1, 0)
        descLabel.Position = UDim2.new(0.35, 0, 0, 0)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = cData.Desc
        descLabel.TextColor3 = Color3.fromRGB(180, 190, 210)
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 12
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = row
    end
end

-- Scanner Panel Populate
local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(1, 0, 0, 42)
ScanBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ScanBtn.Text = "Run Deep Backdoor & Remote Scan"
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.TextSize = 14
ScanBtn.LayoutOrder = 1
ScanBtn.Parent = ScannerPane

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 8)
sbCorner.Parent = ScanBtn

local ScanResultsBox = Instance.new("TextBox")
ScanResultsBox.Size = UDim2.new(1, 0, 0, 280)
ScanResultsBox.BackgroundColor3 = Color3.fromRGB(14, 18, 26)
ScanResultsBox.TextColor3 = Color3.fromRGB(0, 255, 120)
ScanResultsBox.Font = Enum.Font.Code
ScanResultsBox.TextSize = 12
ScanResultsBox.MultiLine = true
ScanResultsBox.TextEditable = false
ScanResultsBox.Text = "-- Click 'Run Deep Backdoor Scan' to analyze ReplicatedStorage & Workspace..."
ScanResultsBox.LayoutOrder = 2
ScanResultsBox.Parent = ScannerPane

local srbCorner = Instance.new("UICorner")
srbCorner.CornerRadius = UDim.new(0, 8)
srbCorner.Parent = ScanResultsBox

ScanBtn.MouseButton1Click:Connect(function()
    ScanResultsBox.Text = "Scanning game environment for remote endpoints...\n"
    task.wait(0.4)
    local scanner = getgenv().BackdoorScanner
    if scanner and scanner.ScanGame then
        local results = scanner:ScanGame()
        local log = ""
        for _, r in ipairs(results) do
            log = log .. "[" .. r.RiskLevel .. "] " .. r.Class .. " -> " .. r.Path .. "\n"
        end
        ScanResultsBox.Text = log .. "\nScan Complete. Total endpoints inspected: " .. #results
    else
        ScanResultsBox.Text = "Scanner module not detected."
    end
end)

task.spawn(function()
    task.wait(1.5)
    PopulateExplorer()
end)

return UIModule
