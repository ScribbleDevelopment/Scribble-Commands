-- ====================================================================================
-- PROJECT: SCRIBBLE COMMANDS - MASTER LOADER (v11.0)
-- ====================================================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local ScribbleSuite = {}
ScribbleSuite.Version = "11.0"
ScribbleSuite.User = LocalPlayer.Name

print("[Scribble Commands]: Initializing device-optimized client suite for " .. ScribbleSuite.User)

function ScribbleSuite:LoadModule(path)
    local success, result = pcall(function()
        local url = "https://raw.githubusercontent.com/ScribbleDevelopment/Scribble-Commands/refs/heads/main/" .. path
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("[Scribble Error]: Failed to load module -> " .. path .. " | " .. tostring(result))
    end
    return result
end

local manifestSuccess, manifestData = pcall(function()
    local rawJson = game:HttpGet("https://raw.githubusercontent.com/ScribbleDevelopment/Scribble-Commands/refs/heads/main/config/manifest.json")
    return HttpService:JSONDecode(rawJson)
end)

if manifestSuccess and manifestData and manifestData.modules then
    print("[Scribble Config]: Successfully loaded manifest v" .. manifestData.version .. ". Mounting modules...")
    for _, modulePath in ipairs(manifestData.modules) do
        local keyName = modulePath:match("(.+)%..+$")
        ScribbleSuite[keyName] = ScribbleSuite:LoadModule("modules/" .. modulePath)
    end
else
    warn("[Scribble Config Error]: Failed to parse manifest.json, falling back to manual load.")
    ScribbleSuite.DeviceOptimizer = ScribbleSuite:LoadModule("modules/DeviceOptimizer.lua")
    ScribbleSuite.UI = ScribbleSuite:LoadModule("modules/UI.lua")
    ScribbleSuite.Cmd1 = ScribbleSuite:LoadModule("modules/CommandsPart1.lua")
    ScribbleSuite.Cmd2 = ScribbleSuite:LoadModule("modules/CommandsPart2.lua")
    ScribbleSuite.Cmd3 = ScribbleSuite:LoadModule("modules/CommandsPart3.lua")
    ScribbleSuite.Cmd4 = ScribbleSuite:LoadModule("modules/CommandsPart4.lua")
    ScribbleSuite.Scanner = ScribbleSuite:LoadModule("modules/BackdoorScanner.lua")
    ScribbleSuite.Bypass = ScribbleSuite:LoadModule("modules/BypassManager.lua")
end

print("[Scribble Commands]: All modules fully loaded and optimized for " .. _G.ScribbleDeviceType)
return ScribbleSuite
