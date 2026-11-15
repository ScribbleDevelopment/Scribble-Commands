-- ====================================================================================
-- MODULE: Backdoor Scanner & Remote Inspector
-- ====================================================================================

local BackdoorScanner = {}

function BackdoorScanner:Scan()
    local remotes = {}
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(remotes, {Name = obj.Name, Path = obj:GetFullName(), Instance = obj})
        end
    end
    return remotes
end

return BackdoorScanner
