-- [[ 7chronic Ultra Suite v5.3 - Complete Master Release ]]
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Cleanup previous UI instances
if CoreGui:FindFirstChild("7chronicUI") then CoreGui["7chronicUI"]:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "7chronicUI"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)

----------------------------------------------------
-- MAIN COMMAND BAR (BOTTOM)
----------------------------------------------------
local Bar = Instance.new("Frame")
Bar.Name = "CommandBar"
Bar.Size = UDim2.new(0, 520, 0, 48)
Bar.Position = UDim2.new(0.5, -260, 0.88, 0)
Bar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Bar.BorderSizePixel = 0
Bar.Active = true
Bar.Draggable = true
Bar.Parent = ScreenGui

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(0, 10)
BarCorner.Parent = Bar

local BarGlow = Instance.new("UIStroke")
BarGlow.Color = Color3.fromRGB(160, 90, 255)
BarGlow.Thickness = 2
BarGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BarGlow.Parent = Bar

local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 90, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(85, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 90, 255))
})
StrokeGradient.Parent = BarGlow

task.spawn(function()
    while BarGlow and BarGlow.Parent do
        StrokeGradient.Rotation = (StrokeGradient.Rotation + 1) % 360
        task.wait(0.03)
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 100, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.Text = "7chronic ⚡"
Title.TextColor3 = Color3.fromRGB(180, 120, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Bar

local Input = Instance.new("TextBox")
Input.Size = UDim2.new(1, -165, 1, 0)
Input.Position = UDim2.new(0, 110, 0, 0)
Input.BackgroundTransparency = 1
Input.PlaceholderText = "Type command or press Ctrl+K..."
Input.PlaceholderColor3 = Color3.fromRGB(110, 110, 135)
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.Font = Enum.Font.GothamMedium
Input.TextSize = 13
Input.TextXAlignment = Enum.TextXAlignment.Left
Input.Parent = Bar

local CmdsBtn = Instance.new("TextButton")
CmdsBtn.Size = UDim2.new(0, 42, 0, 28)
CmdsBtn.Position = UDim2.new(1, -50, 0.5, -14)
CmdsBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
CmdsBtn.Text = "CMDS"
CmdsBtn.TextColor3 = Color3.fromRGB(200, 160, 255)
CmdsBtn.Font = Enum.Font.GothamBold
CmdsBtn.TextSize = 10
CmdsBtn.Parent = Bar

local CmdsBtnCorner = Instance.new("UICorner")
CmdsBtnCorner.CornerRadius = UDim.new(0, 6)
CmdsBtnCorner.Parent = CmdsBtn

local CmdsBtnStroke = Instance.new("UIStroke")
CmdsBtnStroke.Color = Color3.fromRGB(140, 85, 255)
CmdsBtnStroke.Thickness = 1
CmdsBtnStroke.Parent = CmdsBtn

----------------------------------------------------
-- AUTOCOMPLETE DROP DOWN
----------------------------------------------------
local SuggestionsFrame = Instance.new("Frame")
SuggestionsFrame.Name = "Suggestions"
SuggestionsFrame.Size = UDim2.new(1, 0, 0, 0)
SuggestionsFrame.Position = UDim2.new(0, 0, 0, -8)
SuggestionsFrame.AnchorPoint = Vector2.new(0, 1)
SuggestionsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
SuggestionsFrame.BorderSizePixel = 0
SuggestionsFrame.ClipsDescendants = true
SuggestionsFrame.Parent = Bar

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = SuggestionsFrame

local SuggestionCorner = Instance.new("UICorner")
SuggestionCorner.CornerRadius = UDim.new(0, 8)
SuggestionCorner.Parent = SuggestionsFrame

local SuggestionStroke = Instance.new("UIStroke")
SuggestionStroke.Color = Color3.fromRGB(60, 50, 90)
SuggestionStroke.Thickness = 1
SuggestionStroke.Parent = SuggestionsFrame

----------------------------------------------------
-- POP-UP COMMANDS MENU
----------------------------------------------------
local ModalFrame = Instance.new("Frame")
ModalFrame.Name = "CommandsModal"
ModalFrame.Size = UDim2.new(0, 560, 0, 380)
ModalFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
ModalFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
ModalFrame.BorderSizePixel = 0
ModalFrame.Visible = false
ModalFrame.Active = true
ModalFrame.Draggable = true
ModalFrame.Parent = ScreenGui

local ModalCorner = Instance.new("UICorner")
ModalCorner.CornerRadius = UDim.new(0, 12)
ModalCorner.Parent = ModalFrame

local ModalStroke = Instance.new("UIStroke")
ModalStroke.Color = Color3.fromRGB(140, 85, 255)
ModalStroke.Thickness = 1.5
ModalStroke.Parent = ModalFrame

local ModalHeader = Instance.new("Frame")
ModalHeader.Size = UDim2.new(1, 0, 0, 42)
ModalHeader.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
ModalHeader.BorderSizePixel = 0
ModalHeader.Parent = ModalFrame

local ModalHeaderCorner = Instance.new("UICorner")
ModalHeaderCorner.CornerRadius = UDim.new(0, 12)
ModalHeaderCorner.Parent = ModalHeader

local ModalTitle = Instance.new("TextLabel")
ModalTitle.Size = UDim2.new(0, 250, 1, 0)
ModalTitle.Position = UDim2.new(0, 16, 0, 0)
ModalTitle.Text = "7chronic Commands Hub"
ModalTitle.TextColor3 = Color3.fromRGB(220, 180, 255)
ModalTitle.Font = Enum.Font.GothamBold
ModalTitle.TextSize = 14
ModalTitle.BackgroundTransparency = 1
ModalTitle.TextXAlignment = Enum.TextXAlignment.Left
ModalTitle.Parent = ModalHeader

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.Parent = ModalHeader

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 6)
CloseBtnCorner.Parent = CloseBtn

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -32, 0, 32)
SearchBox.Position = UDim2.new(0, 16, 0, 52)
SearchBox.BackgroundColor3 = Color3.fromRGB(26, 26, 38)
SearchBox.PlaceholderText = "🔍 Search commands..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 135)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 12
SearchBox.Parent = ModalFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchBox

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -32, 1, -102)
Scroll.Position = UDim2.new(0, 16, 0, 92)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(140, 85, 255)
Scroll.Parent = ModalFrame

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0.48, 0, 0, 34)
Grid.CellPadding = UDim2.new(0.04, 0, 0, 8)
Grid.SortOrder = Enum.SortOrder.Name
Grid.Parent = Scroll

----------------------------------------------------
-- COMMANDS DATABASE (FULL MASTER LIST)
----------------------------------------------------
local Commands = {
    ["moist7"] = "moist7 - Execute Moist 7 Luarmor loader",
    ["antivc"] = "antivc - Execute Moist 7 Luarmor loader",
    ["fly"] = "fly [speed] - Fly around",
    ["unfly"] = "unfly - Stop flight",
    ["ws"] = "ws [num] - Walk speed",
    ["jp"] = "jp [num] - Jump power",
    ["hipheight"] = "hipheight [num] - Hip height",
    ["gravity"] = "gravity [num] - World gravity",
    ["noclip"] = "noclip - Walk through walls",
    ["clip"] = "clip - Disable noclip",
    ["infinitejump"] = "infinitejump - Infinite jump",
    ["uninfinitejump"] = "uninfinitejump - Normal jump",
    ["goto"] = "goto [player] - Teleport to player",
    ["bring"] = "bring [player] - Bring player to you",
    ["tp"] = "tp [p1] [p2] - Teleport p1 to p2",
    ["float"] = "float - Hover in mid-air",
    ["unfloat"] = "unfloat - Stop hovering",
    ["freeze"] = "freeze - Anchor player",
    ["unfreeze"] = "unfreeze - Unanchor player",
    ["god"] = "god - Max health & resistance",
    ["ungod"] = "ungod - Normal 100 health",
    ["reset"] = "reset - Respawn character",
    ["invis"] = "invis - Hide character mesh",
    ["vis"] = "vis - Show character mesh",
    ["sit"] = "sit - Make character sit",
    ["lay"] = "lay - Turn character sideways",
    ["stand"] = "stand - Stand character up",
    ["spin"] = "spin [speed] - Spin character",
    ["unspin"] = "unspin - Stop spinning",
    ["size"] = "size [num] - Scale character size",
    ["ghost"] = "ghost - Semi-transparent",
    ["unghost"] = "unghost - Fully opaque",
    ["fire"] = "fire - Attach fire instance",
    ["unfire"] = "unfire - Remove fire instance",
    ["smoke"] = "smoke - Attach smoke instance",
    ["unsmoke"] = "unsmoke - Remove smoke instance",
    ["sparkles"] = "sparkles - Attach sparkles",
    ["unsparkles"] = "unsparkles - Remove sparkles",
    ["esp"] = "esp - Highlight players",
    ["unesp"] = "unesp - Remove highlights",
    ["fullbright"] = "fullbright - Remove shadows",
    ["day"] = "day - Set daytime 14:00",
    ["night"] = "night - Set nighttime 00:00",
    ["rejoin"] = "rejoin - Reconnect to server",
    ["serverhop"] = "serverhop - Join new server",
    ["btools"] = "btools - Client building tools",
    ["dex"] = "dex - Load Dark Dex Explorer",
    ["spy"] = "spy - Load Remote Logger",
    ["cmds"] = "cmds - Open commands GUI"
}

-- Engine Variables
local Flying = false
local FlySpeed = 50
local FlyConnection, InfJumpConnection, SpinConnection = nil, nil, nil

local function PopulateModal(filter)
    for _, child in pairs(Scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    filter = string.lower(filter or "")
    local count = 0

    for name, desc in pairs(Commands) do
        if filter == "" or string.find(string.lower(name), filter) or string.find(string.lower(desc), filter) then
            count = count + 1
            local Card = Instance.new("Frame")
            Card.Name = name
            Card.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
            Card.Parent = Scroll

            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = UDim.new(0, 6)
            CardCorner.Parent = Card

            local CmdBtn = Instance.new("TextButton")
            CmdBtn.Size = UDim2.new(1, 0, 1, 0)
            CmdBtn.BackgroundTransparency = 1
            CmdBtn.Text = "  " .. name
            CmdBtn.TextColor3 = Color3.fromRGB(180, 130, 255)
            CmdBtn.Font = Enum.Font.GothamBold
            CmdBtn.TextSize = 11
            CmdBtn.TextXAlignment = Enum.TextXAlignment.Left
            CmdBtn.Parent = Card

            local SubText = Instance.new("TextLabel")
            SubText.Size = UDim2.new(1, -10, 0, 12)
            SubText.Position = UDim2.new(0, 10, 0.55, 0)
            SubText.BackgroundTransparency = 1
            SubText.Text = string.split(desc, " - ")[2] or desc
            SubText.TextColor3 = Color3.fromRGB(130, 130, 155)
            SubText.Font = Enum.Font.Gotham
            SubText.TextSize = 9
            SubText.TextXAlignment = Enum.TextXAlignment.Left
            SubText.Parent = Card

            CmdBtn.MouseButton1Click:Connect(function()
                Input.Text = name .. " "
                Input:CaptureFocus()
                ModalFrame.Visible = false
            end)
        end
    end

    local rows = math.ceil(count / 2)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, rows * 42)
end

PopulateModal("")

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    PopulateModal(SearchBox.Text)
end)

local function ToggleModal()
    ModalFrame.Visible = not ModalFrame.Visible
    if ModalFrame.Visible then
        SearchBox.Text = ""
        PopulateModal("")
        SearchBox:CaptureFocus()
    end
end

CmdsBtn.MouseButton1Click:Connect(ToggleModal)
CloseBtn.MouseButton1Click:Connect(function() ModalFrame.Visible = false end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        ToggleModal()
    end
end)

local function StopFly()
    Flying = false
    if FlyConnection then FlyConnection:Disconnect(); FlyConnection = nil end

    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, obj in pairs(root:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") or obj.Name == "7chronicFly" then
                    obj:Destroy()
                end
            end
        end
        if hum then hum.PlatformStand = false; hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end

local function StartFly(speed)
    StopFly()
    FlySpeed = speed or 50
    Flying = true
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    local bg = Instance.new("BodyGyro")
    bg.Name = "7chronicFly"
    bg.P = 90000; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.CFrame = root.CFrame; bg.Parent = root

    local bv = Instance.new("BodyVelocity")
    bv.Name = "7chronicFly"
    bv.Velocity = Vector3.new(0, 0, 0); bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Parent = root

    FlyConnection = RunService.RenderStepped:Connect(function()
        if not Flying or not char or not root or not hum then StopFly() return end
        hum.PlatformStand = true
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

        bv.Velocity = moveDir * FlySpeed
        bg.CFrame = cam.CFrame
    end)
end

local function GetPlayer(str)
    if not str or str == "" then return nil end
    str = string.lower(str)
    for _, p in pairs(Players:GetPlayers()) do
        if string.find(string.lower(p.Name), str) or string.find(string.lower(p.DisplayName), str) then
            return p
        end
    end
    return nil
end

----------------------------------------------------
-- FULL COMMAND ROUTER
----------------------------------------------------
local function ExecuteCommand(cmdStr)
    local args = string.split(cmdStr, " ")
    local cmd = string.lower(args[1] or "")
    local val1 = args[2]
    local val2 = args[3]
    local numVal = tonumber(val1)

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if cmd == "moist7" or cmd == "antivc" then
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/c146e7169df99db2afa5052b177dd747.lua"))()
            end)
        end)
    elseif cmd == "cmds" then ToggleModal()
    elseif cmd == "fly" then StartFly(numVal or 50)
    elseif cmd == "unfly" then StopFly()
    elseif cmd == "ws" then if hum then hum.WalkSpeed = numVal or 16 end
    elseif cmd == "jp" then if hum then hum.UseJumpPower = true; hum.JumpPower = numVal or 50 end
    elseif cmd == "hipheight" then if hum then hum.HipHeight = numVal or 0 end
    elseif cmd == "gravity" then workspace.Gravity = numVal or 196.2
    elseif cmd == "noclip" then
        _G.Noclip = true
        task.spawn(function()
            while _G.Noclip do
                if LocalPlayer.Character then
                    for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
                RunService.Stepped:Wait()
            end
        end)
    elseif cmd == "clip" then _G.Noclip = false
    elseif cmd == "infinitejump" then
        if not InfJumpConnection then
            InfJumpConnection = UserInputService.JumpRequest:Connect(function()
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end
    elseif cmd == "uninfinitejump" then if InfJumpConnection then InfJumpConnection:Disconnect(); InfJumpConnection = nil end
    elseif cmd == "tp" then
        local p1 = GetPlayer(val1)
        local p2 = GetPlayer(val2)
        if p1 and not p2 then
            if p1.Character and p1.Character:FindFirstChild("HumanoidRootPart") and root then
                root.CFrame = p1.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        elseif p1 and p2 then
            if p1.Character and p1.Character:FindFirstChild("HumanoidRootPart") and p2.Character and p2.Character:FindFirstChild("HumanoidRootPart") then
                p1.Character.HumanoidRootPart.CFrame = p2.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
            end
        end
    elseif cmd == "goto" then
        local target = GetPlayer(val1)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and root then
            root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    elseif cmd == "bring" then
        local target = GetPlayer(val1)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and root then
            target.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 0, -3)
        end
    elseif cmd == "float" then
        if root and not root:FindFirstChild("7chronicFloat") then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "7chronicFloat"
            bv.MaxForce = Vector3.new(0, 9e9, 0)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = root
        end
    elseif cmd == "unfloat" then
        if root and root:FindFirstChild("7chronicFloat") then root["7chronicFloat"]:Destroy() end
    elseif cmd == "freeze" then if root then root.Anchored = true end
    elseif cmd == "unfreeze" then if root then root.Anchored = false end
    elseif cmd == "god" then if hum then hum.MaxHealth = math.huge; hum.Health = math.huge end
    elseif cmd == "ungod" then if hum then hum.MaxHealth = 100; hum.Health = 100 end
    elseif cmd == "reset" then if hum then hum.Health = 0 end
    elseif cmd == "invis" then
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = 1 end
            end
        end
    elseif cmd == "vis" then
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = 0
                elseif p:IsA("Decal") then p.Transparency = 0 end
            end
        end
    elseif cmd == "sit" then if hum then hum.Sit = true end
    elseif cmd == "lay" then
        if hum and root then
            hum.Sit = true
            root.CFrame = root.CFrame * CFrame.Angles(math.rad(90), 0, 0)
        end
    elseif cmd == "stand" then if hum then hum.Sit = false end
    elseif cmd == "spin" then
        local speed = numVal or 20
        if SpinConnection then SpinConnection:Disconnect() end
        SpinConnection = RunService.RenderStepped:Connect(function()
            if root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(speed), 0) end
        end)
    elseif cmd == "unspin" then if SpinConnection then SpinConnection:Disconnect(); SpinConnection = nil end
    elseif cmd == "size" then
        if hum and numVal then
            for _, scale in pairs(hum:GetChildren()) do
                if scale:IsA("NumberValue") then scale.Value = numVal end
            end
        end
    elseif cmd == "ghost" then
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = 0.5 end
            end
        end
    elseif cmd == "unghost" then
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = 0 end
            end
        end
    elseif cmd == "fire" then if root and not root:FindFirstChildOfClass("Fire") then Instance.new("Fire", root) end
    elseif cmd == "unfire" then if root and root:FindFirstChildOfClass("Fire") then root:FindFirstChildOfClass("Fire"):Destroy() end
    elseif cmd == "smoke" then if root and not root:FindFirstChildOfClass("Smoke") then Instance.new("Smoke", root) end
    elseif cmd == "unsmoke" then if root and root:FindFirstChildOfClass("Smoke") then root:FindFirstChildOfClass("Smoke"):Destroy() end
    elseif cmd == "sparkles" then if root and not root:FindFirstChildOfClass("Sparkles") then Instance.new("Sparkles", root) end
    elseif cmd == "unsparkles" then if root and root:FindFirstChildOfClass("Sparkles") then root:FindFirstChildOfClass("Sparkles"):Destroy() end
    elseif cmd == "esp" then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("7chronicHighlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "7chronicHighlight"
                hl.FillColor = Color3.fromRGB(160, 90, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Parent = p.Character
            end
        end
    elseif cmd == "unesp" then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("7chronicHighlight") then
                p.Character["7chronicHighlight"]:Destroy()
            end
        end
    elseif cmd == "fullbright" then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    elseif cmd == "day" then Lighting.ClockTime = 14
    elseif cmd == "night" then Lighting.ClockTime = 0
    elseif cmd == "rejoin" then TeleportService:Teleport(game.PlaceId, LocalPlayer)
    elseif cmd == "serverhop" then TeleportService:Teleport(game.PlaceId)
    elseif cmd == "btools" then
        Instance.new("HopperBin", LocalPlayer.Backpack).BinType = 2
        Instance.new("HopperBin", LocalPlayer.Backpack).BinType = 3
        Instance.new("HopperBin", LocalPlayer.Backpack).BinType = 4
    elseif cmd == "dex" then loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    elseif cmd == "spy" then loadstring(game:HttpGet("https://raw.githubusercontent.com/exunys/AirHub/main/AirHub.lua"))()
    end
end

----------------------------------------------------
-- AUTOCOMPLETE SUGGESTIONS LOGIC
----------------------------------------------------
local function UpdateSuggestions()
    for _, child in pairs(SuggestionsFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    local text = string.lower(Input.Text)
    if text == "" then SuggestionsFrame.Size = UDim2.new(1, 0, 0, 0) return end

    local count = 0
    for name, desc in pairs(Commands) do
        if string.find(name, text) and count < 6 then
            count = count + 1
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(26, 26, 38)
            btn.BackgroundTransparency = 0.2
            btn.Text = "  " .. desc
            btn.TextColor3 = Color3.fromRGB(220, 210, 245)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 11
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = SuggestionsFrame

            btn.MouseButton1Click:Connect(function()
                Input.Text = name .. " "
                UpdateSuggestions()
                Input:CaptureFocus()
            end)
        end
    end

    SuggestionsFrame.Size = UDim2.new(1, 0, 0, count * 30)
end

Input:GetPropertyChangedSignal("Text"):Connect(UpdateSuggestions)

Input.FocusLost:Connect(function(enter)
    if enter and Input.Text ~= "" then
        ExecuteCommand(Input.Text)
        Input.Text = ""
        UpdateSuggestions()
    end
end)
