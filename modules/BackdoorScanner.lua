local BackdoorScanner = {}
BackdoorScanner.List = {}
getgenv().BackdoorScanner = BackdoorScanner

-- High-performance pattern matching scanner for vulnerable server remotes and backdoors
function BackdoorScanner:ScanGame()
    local findings = {}
    print("[Scribble Scanner]: Scanning workspace and storage for vulnerable remotes...")
    
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local nameLower = obj.Name:lower()
            local isSuspicious = nameLower:find("backdoor") or nameLower:find("admin") or nameLower:find("execute") or nameLower:find("server") or nameLower:find("loader")
            
            table.insert(findings, {
                Name = obj.Name,
                Class = obj.ClassName,
                Path = obj:GetFullName(),
                Instance = obj,
                RiskLevel = isSuspicious and "High" else "Normal"
            })
        end
    end
    
    print("[Scribble Scanner]: Scan complete. Total endpoints found: " .. #findings)
    return findings
end

function BackdoorScanner:TestPayload(remoteInstance, payloadCode)
    local success, err = pcall(function()
        if remoteInstance:IsA("RemoteEvent") then
            remoteInstance:FireServer(payloadCode)
        elseif remoteInstance:IsA("RemoteFunction") then
            remoteInstance:InvokeServer(payloadCode)
        end
    end)
    return success, err
end

return BackdoorScanner
