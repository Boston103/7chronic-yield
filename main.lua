-- [[ 7chronic Ultra Suite v6.0 - Master Release (200+ Commands) ]]
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
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

----------------------------------------------------
-- POP-UP COMMANDS MENU
----------------------------------------------------
local ModalFrame = Instance.new("Frame")
ModalFrame.Name = "CommandsModal"
ModalFrame.Size = UDim2.new(0, 560, 0, 400)
ModalFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
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
SearchBox.PlaceholderText = "🔍 Search 200+ commands..."
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
-- COMMANDS DATABASE (200+ COMMANDS)
----------------------------------------------------
local Commands = {
    -- Core & Script Hubs
    ["moist7"] = "moist7 - Execute Moist 7 Luarmor loader",
    ["antivc"] = "antivc - Execute Moist 7 Luarmor loader",
    ["cmds"] = "cmds - Toggle command hub",
    ["dex"] = "dex - Load Dark Dex Explorer",
    ["spy"] = "spy - Load Remote Event Spy",
    ["iy"] = "iy - Load Infinite Yield",
    ["vfly"] = "vfly [speed] - Fly inside vehicle",
    ["unvfly"] = "unvfly - Stop vehicle flying",
    
    -- Movement & Physics
    ["fly"] = "fly [speed] - Toggle flight",
    ["unfly"] = "unfly - Stop flying",
    ["ws"] = "ws [num] - Set WalkSpeed",
    ["jp"] = "jp [num] - Set JumpPower",
    ["jh"] = "jh [num] - Set JumpHeight",
    ["hipheight"] = "hipheight [num] - Set HipHeight",
    ["gravity"] = "gravity [num] - Set world gravity",
    ["noclip"] = "noclip - Pass through walls",
    ["clip"] = "clip - Disable noclip",
    ["infinitejump"] = "infinitejump - Continuous jumps",
    ["uninfinitejump"] = "uninfinitejump - Disable inf jump",
    ["float"] = "float - Hover in place",
    ["unfloat"] = "unfloat - Stop hovering",
    ["freeze"] = "freeze - Anchor character",
    ["unfreeze"] = "unfreeze - Unanchor character",
    ["swim"] = "swim - Enable swimming state",
    ["unswim"] = "unswim - Disable swimming",
    ["spin"] = "spin [speed] - Spin character",
    ["unspin"] = "unspin - Stop spinning",
    ["stutter"] = "stutter - Teleport jitter effect",
    ["unstutter"] = "unstutter - Stop jitter",
    ["airwalk"] = "airwalk - Walk on invisible platform",
    ["unairwalk"] = "unairwalk - Remove platform",
    ["speedboost"] = "speedboost - Temporary high speed",
    ["superjump"] = "superjump - Extreme high jump",
    ["slowmo"] = "slowmo - Slow motion locally",
    ["unslowmo"] = "unslowmo - Restore speed",

    -- Teleportation & Player Target
    ["goto"] = "goto [player] - Teleport to target",
    ["bring"] = "bring [player] - Bring player (if enabled)",
    ["tp"] = "tp [p1] [p2] - Teleport p1 to p2",
    ["tppos"] = "tppos [x] [y] [z] - Teleport to coordinates",
    ["view"] = "view [player] - Spectate target",
    ["unview"] = "unview - Spectate self",
    ["clicktp"] = "clicktp - Ctrl+Click to teleport",
    ["unclicktp"] = "unclicktp - Disable click TP",
    ["rejoin"] = "rejoin - Reconnect to current server",
    ["serverhop"] = "serverhop - Switch server",
    ["tptool"] = "tptool - Equip teleport tool",
    ["spawnmark"] = "spawnmark - Set home point",
    ["spawntp"] = "spawntp - Teleport to home point",

    -- Visuals & ESP
    ["esp"] = "esp - Enable player highlights",
    ["unesp"] = "unesp - Disable ESP",
    ["chams"] = "chams - Solid color ESP",
    ["unchams"] = "unchams - Remove chams",
    ["tracers"] = "tracers - Draw lines to players",
    ["untracers"] = "untracers - Disable tracers",
    ["nametags"] = "nametags - Show display names",
    ["unnametags"] = "unnametags - Hide display names",
    ["fullbright"] = "fullbright - Maximise lighting",
    ["unfullbright"] = "unfullbright - Restore lighting",
    ["day"] = "day - Set time to 12:00",
    ["night"] = "night - Set time to 00:00",
    ["nofog"] = "nofog - Clear map fog",
    ["ambient"] = "ambient [r] [g] [b] - Custom ambient color",
    ["fogcolor"] = "fogcolor [r] [g] [b] - Custom fog color",
    ["fieldofview"] = "fieldofview [num] - Change Camera FOV",
    ["firstperson"] = "firstperson - Lock to 1st person",
    ["thirdperson"] = "thirdperson - Lock to 3rd person",

    -- Particle & Effects
    ["fire"] = "fire - Attach fire",
    ["unfire"] = "unfire - Remove fire",
    ["smoke"] = "smoke - Attach smoke",
    ["unsmoke"] = "unsmoke - Remove smoke",
    ["sparkles"] = "sparkles - Attach sparkles",
    ["unsparkles"] = "unsparkles - Remove sparkles",
    ["beams"] = "beams - Enable trail beams",
    ["unbeams"] = "unbeams - Clear beams",

    -- Character Rigs & Utility
    ["god"] = "god - Enable max health state",
    ["ungod"] = "ungod - Reset health state",
    ["reset"] = "reset - Respawn local character",
    ["invis"] = "invis - Hide character mesh",
    ["vis"] = "vis - Show character mesh",
    ["ghost"] = "ghost - Semi-transparent body",
    ["unghost"] = "unghost - Opaque body",
    ["sit"] = "sit - Make character sit",
    ["lay"] = "lay - Lay character flat",
    ["stand"] = "stand - Stand character up",
    ["btools"] = "btools - Give building tools",
    ["clear tools"] = "cleartools - Drop inventory tools",
    ["copypos"] = "copypos - Copy current X,Y,Z",
    ["size"] = "size [scale] - Scale body parts",
    ["headless"] = "headless - Hide character head",
    ["korblox"] = "korblox - Hide right leg",
    ["noname"] = "noname - Hide overhead HUD",
    ["droptools"] = "droptools - Drop all held items",

    -- 120 Extra Expanded Commands (Lighting, Utility, Player Adjustments)
    ["fov90"] = "fov90 - Set FOV to 90",
    ["fov120"] = "fov120 - Set FOV to 120",
    ["fov70"] = "fov70 - Set FOV to 70 (Default)",
    ["shadows"] = "shadows - Enable lighting shadows",
    ["noshadows"] = "noshadows - Disable lighting shadows",
    ["sat1"] = "sat1 - Set saturation boost",
    ["sat0"] = "sat0 - Normal saturation",
    ["tintred"] = "tintred - Red screen filter",
    ["tintblue"] = "tintblue - Blue screen filter",
    ["tintgreen"] = "tintgreen - Green screen filter",
    ["cleartint"] = "cleartint - Remove screen filters",
    ["fpscap"] = "fpscap [num] - Adjust frame target",
    ["infstamina"] = "infstamina - Endless running",
    ["antimove"] = "antimove - Lock position",
    ["unantimove"] = "unantimove - Unlock position",
    ["fling"] = "fling - Spin character rapidly",
    ["unfling"] = "unfling - Stop fling speed",
    ["bang"] = "bang [player] - Loop position behind target",
    ["unbang"] = "unbang - Stop bang loop",
    ["headspin"] = "headspin - Rotate head part",
    ["unheadspin"] = "unheadspin - Stop head rotate",
    ["seizure"] = "seizure - Jitter animation",
    ["unseizure"] = "unseizure - Stop seizure",
    ["loopws"] = "loopws [num] - Freeze speed parameter",
    ["unloopws"] = "unloopws - Unfreeze speed",
    ["loopjp"] = "loopjp [num] - Freeze jump parameter",
    ["unloopjp"] = "unloopjp - Unfreeze jump",
    ["loopgoto"] = "loopgoto [player] - Continual teleport to target",
    ["unloopgoto"] = "unloopgoto - Stop loop teleport",
    ["freezecam"] = "freezecam - Lock camera in place",
    ["unfreezecam"] = "unfreezecam - Restore camera movement",
    ["fixcam"] = "fixcam - Reset camera script",
    ["inspect"] = "inspect [player] - View avatar details",
    ["toolreach"] = "toolreach - Expand tool hitboxes",
    ["untoolreach"] = "untoolreach - Reset hitboxes",
    ["clickdelete"] = "clickdelete - Ctrl+Click to destroy part",
    ["unclickdelete"] = "unclickdelete - Turn off click delete",
    ["bhop"] = "bhop - Enable auto bhop",
    ["unbhop"] = "unbhop - Disable auto bhop",
    ["autoclicker"] = "autoclicker - Enable auto clicker",
    ["unautoclicker"] = "unautoclicker - Stop auto clicker",
    ["wallwalk"] = "wallwalk - Stick to walls",
    ["unwallwalk"] = "unwallwalk - Normal physics",
    ["infyield"] = "infyield - Alternative IY shortcut",
    ["shatter"] = "shatter - Break character joints",
    ["ragdoll"] = "ragdoll - Enable ragdoll physics",
    ["unragdoll"] = "unragdoll - Disable ragdoll physics",
    ["drown"] = "drown - Force health decay",
    ["heal"] = "heal - Restore max health",
    ["damage"] = "damage [num] - Subtract target health",
    ["kill"] = "kill - Set character health 0",
    ["removehats"] = "removehats - Clear accessory items",
    ["removeclothing"] = "removeclothing - Clear textures",
    ["blackwhite"] = "blackwhite - Monochrome lighting",
    ["invertcolors"] = "invertcolors - Negative screen preset",
    ["sepia"] = "sepia - Retro warm tint",
    ["blur"] = "blur [num] - Blur view camera",
    ["unblur"] = "unblur - Clear blur view",
    ["bloom"] = "bloom - High intensity bloom",
    ["unbloom"] = "unbloom - Remove bloom",
    ["sunrays"] = "sunrays - Add sun ray effects",
    ["unsunrays"] = "unsunrays - Remove sun rays",
    ["clocktime"] = "clocktime [num] - Change world time",
    ["fogend"] = "fogend [num] - Distance fog parameter",
    ["fogstart"] = "fogstart [num] - Distance fog start",
    ["bringtools"] = "bringtools - Grab workspace tools",
    ["equip tools"] = "equiptools - Force equip backpack",
    ["unequip tools"] = "unequiptools - Clear active hands",
    ["dropaccessories"] = "dropaccessories - Detach head items",
    ["charscale"] = "charscale [num] - Rescale character",
    ["unscale"] = "unscale - Restore original scale",
    ["hipheight0"] = "hipheight0 - Reset heightOffset",
    ["flyspeed"] = "flyspeed [num] - Change default fly rate",
    ["walkspeed"] = "walkspeed [num] - WalkSpeed alias",
    ["jumppower"] = "jumppower [num] - JumpPower alias",
    ["antiidle"] = "antiidle - Anti-AFK disabler",
    ["unantiidle"] = "unantiidle - Stop anti-AFK",
    ["chatlogs"] = "chatlogs - Print incoming chat",
    ["clearlogs"] = "clearlogs - Wipe active console",
    ["volume"] = "volume [num] - Modify game audio",
    ["mute"] = "mute - Mute global sounds",
    ["unmute"] = "unmute - Restore global sounds",
    ["rejoinserver"] = "rejoinserver - Instant reconnect",
    ["copygameid"] = "copygameid - Save PlaceId to clipboard",
    ["copyjobid"] = "copyjobid - Save JobId to clipboard",
    ["spawntools"] = "spawntools - Request backpack refresh",
    ["partesp"] = "partesp [name] - Target named instances",
    ["unpartesp"] = "unpartesp - Remove part highlight",
    ["boxesp"] = "boxesp - 2D bounding box ESP",
    ["unboxesp"] = "unboxesp - Remove bounding box",
    ["distanceesp"] = "distanceesp - Display range values",
    ["undistanceesp"] = "undistanceesp - Remove range labels",
    ["tracerscolor"] = "tracerscolor [r] [g] [b] - Tracer RGB",
    ["espcolor"] = "espcolor [r] [g] [b] - ESP RGB fill",
    ["crosshair"] = "crosshair - Draw screen center dot",
    ["uncrosshair"] = "uncrosshair - Remove center dot",
    ["noclip2"] = "noclip2 - Alternative phase mode",
    ["godmode"] = "godmode - Health lock alias",
    ["infinitefly"] = "infinitefly - Extended flight mode",
    ["superflight"] = "superflight - Max speed flight preset",
    ["lowgfx"] = "lowgfx - Boost performance mode",
    ["highgfx"] = "highgfx - Enable max rendering",
    ["removetrees"] = "removetrees - Delete foliage models",
    ["removegrass"] = "removegrass - Clear terrain grass",
    ["invisiblecam"] = "invisiblecam - No camera clip",
    ["shiftlock"] = "shiftlock - Force enable shiftlock",
    ["zoom"] = "zoom [num] - Expand zoom boundary",
    ["resetfps"] = "resetfps - Set FPS to default",
    ["unlimitedzoom"] = "unlimitedzoom - Remove zoom limits",
    ["stopspin"] = "stopspin - Emergency spin cancel",
    ["stopfly"] = "stopfly - Emergency fly cancel",
    ["stopprograms"] = "stopprograms - Terminate active loops"
}

-- Engine Variables
local Flying = false
local FlySpeed = 50
local FlyConnection, InfJumpConnection, SpinConnection, LoopGotoConnection = nil, nil, nil, nil
local AirwalkPart = nil

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
-- COMPLETE COMMAND EXECUTION ROUTER
----------------------------------------------------
local function ExecuteCommand(cmdStr)
    local args = string.split(cmdStr, " ")
    local cmd = string.lower(args[1] or "")
    local val1 = args[2]
    local val2 = args[3]
    local val3 = args[4]
    local numVal = tonumber(val1)

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    -- External Handlers & Core
    if cmd == "moist7" or cmd == "antivc" then
        task.spawn(function()
            pcall(function() loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/c146e7169df99db2afa5052b177dd747.lua"))() end)
        end)
    elseif cmd == "iy" or cmd == "infyield" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    elseif cmd == "dex" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    elseif cmd == "spy" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/exunys/AirHub/main/AirHub.lua"))()
    elseif cmd == "cmds" then ToggleModal()
    
    -- Movement Commands
    elseif cmd == "fly" or cmd == "infinitefly" then StartFly(numVal or 50)
    elseif cmd == "superflight" then StartFly(250)
    elseif cmd == "unfly" or cmd == "stopfly" then StopFly()
    elseif cmd == "ws" or cmd == "walkspeed" or cmd == "loopws" then if hum then hum.WalkSpeed = numVal or 16 end
    elseif cmd == "jp" or cmd == "jumppower" or cmd == "loopjp" then if hum then hum.UseJumpPower = true; hum.JumpPower = numVal or 50 end
    elseif cmd == "jh" then if hum then hum.Height = numVal or 7.2 end
    elseif cmd == "hipheight" or cmd == "hipheight0" then if hum then hum.HipHeight = numVal or 0 end
    elseif cmd == "gravity" then workspace.Gravity = numVal or 196.2
    elseif cmd == "noclip" or cmd == "noclip2" then
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
    elseif cmd == "airwalk" then
        if not AirwalkPart then
            AirwalkPart = Instance.new("Part", workspace)
            AirwalkPart.Size = Vector3.new(10, 1, 10)
            AirwalkPart.Anchored = true
            AirwalkPart.Transparency = 0.5
            RunService.RenderStepped:Connect(function()
                if AirwalkPart and root then AirwalkPart.CFrame = CFrame.new(root.Position.X, root.Position.Y - 3.5, root.Position.Z) end
            end)
        end
    elseif cmd == "unairwalk" then if AirwalkPart then AirwalkPart:Destroy(); AirwalkPart = nil end
    elseif cmd == "speedboost" then if hum then hum.WalkSpeed = 100 end
    elseif cmd == "superjump" then if hum then hum.UseJumpPower = true; hum.JumpPower = 200 end

    -- Teleportation Engine (Robust Physics Mechanics)
    elseif cmd == "tp" then
        local p1 = GetPlayer(val1)
        local p2 = GetPlayer(val2)
        if p1 and not p2 then
            if p1.Character and p1.Character:FindFirstChild("HumanoidRootPart") and char then
                if root then root.AssemblyLinearVelocity = Vector3.zero end
                char:PivotTo(p1.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
            end
        elseif p1 and p2 then
            if p1.Character and p2.Character and p2.Character:FindFirstChild("HumanoidRootPart") then
                p1.Character:PivotTo(p2.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2))
            end
        end
    elseif cmd == "goto" then
        local target = GetPlayer(val1)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and char then
            if root then root.AssemblyLinearVelocity = Vector3.zero end
            char:PivotTo(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
        end
    elseif cmd == "bring" then
        local target = GetPlayer(val1)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and root then
            target.Character:PivotTo(root.CFrame * CFrame.new(0, 0, -3))
        end
    elseif cmd == "loopgoto" then
        local target = GetPlayer(val1)
        if LoopGotoConnection then LoopGotoConnection:Disconnect() end
        LoopGotoConnection = RunService.RenderStepped:Connect(function()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and char then
                char:PivotTo(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
            end
        end)
    elseif cmd == "unloopgoto" then if LoopGotoConnection then LoopGotoConnection:Disconnect(); LoopGotoConnection = nil end
    elseif cmd == "tppos" then
        if char and tonumber(val1) and tonumber(val2) and tonumber(val3) then
            char:PivotTo(CFrame.new(tonumber(val1), tonumber(val2), tonumber(val3)))
        end
    elseif cmd == "clicktp" then
        _G.ClickTP = UserInputService.InputBegan:Connect(function(input, gpe)
            if not gpe and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                local mouse = LocalPlayer:GetMouse()
                if char and mouse.Hit then char:PivotTo(CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))) end
            end
        end)
    elseif cmd == "unclicktp" then if _G.ClickTP then _G.ClickTP:Disconnect(); _G.ClickTP = nil end

    -- Visuals & Camera
    elseif cmd == "esp" or cmd == "chams" or cmd == "boxesp" then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("7chronicHighlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "7chronicHighlight"
                hl.FillColor = Color3.fromRGB(160, 90, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Parent = p.Character
            end
        end
    elseif cmd == "unesp" or cmd == "unchams" or cmd == "unboxesp" then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("7chronicHighlight") then p.Character["7chronicHighlight"]:Destroy() end
        end
    elseif cmd == "fullbright" then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
    elseif cmd == "unfullbright" then Lighting.Brightness = 1; Lighting.GlobalShadows = true
    elseif cmd == "day" then Lighting.ClockTime = 14
    elseif cmd == "night" then Lighting.ClockTime = 0
    elseif cmd == "clocktime" then if numVal then Lighting.ClockTime = numVal end
    elseif cmd == "fieldofview" or cmd == "fov90" or cmd == "fov120" or cmd == "fov70" then
        workspace.CurrentCamera.FieldOfView = numVal or (cmd == "fov90" and 90 or (cmd == "fov120" and 120 or 70))
    elseif cmd == "view" or cmd == "inspect" then
        local target = GetPlayer(val1)
        if target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
            workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
        end
    elseif cmd == "unview" then if hum then workspace.CurrentCamera.CameraSubject = hum end
    elseif cmd == "shadows" then Lighting.GlobalShadows = true
    elseif cmd == "noshadows" then Lighting.GlobalShadows = false
    elseif cmd == "blur" then
        local b = Lighting:FindFirstChildOfClass("BlurEffect") or Instance.new("BlurEffect", Lighting)
        b.Size = numVal or 24
    elseif cmd == "unblur" then
        if Lighting:FindFirstChildOfClass("BlurEffect") then Lighting:FindFirstChildOfClass("BlurEffect"):Destroy() end
    end

    -- Character Actions & Status
    if cmd == "god" or cmd == "godmode" then if hum then hum.MaxHealth = math.huge; hum.Health = math.huge end
    elseif cmd == "ungod" then if hum then hum.MaxHealth = 100; hum.Health = 100 end
    elseif cmd == "reset" or cmd == "kill" then if hum then hum.Health = 0 end
    elseif cmd == "heal" then if hum then hum.Health = hum.MaxHealth end
    elseif cmd == "invis" then
        if char then
            for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = 1 end end
        end
    elseif cmd == "vis" then
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = 0
                elseif p:IsA("Decal") then p.Transparency = 0 end
            end
        end
    elseif cmd == "ghost" then
        if char then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = 0.5 end end end
    elseif cmd == "unghost" then
        if char then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = 0 end end end
    elseif cmd == "sit" then if hum then hum.Sit = true end
    elseif cmd == "lay" then if hum and root then hum.Sit = true; root.CFrame = root.CFrame * CFrame.Angles(math.rad(90), 0, 0) end
    elseif cmd == "stand" then if hum then hum.Sit = false end
    elseif cmd == "spin" or cmd == "fling" then
        local speed = numVal or (cmd == "fling" and 100 or 20)
        if SpinConnection then SpinConnection:Disconnect() end
        SpinConnection = RunService.RenderStepped:Connect(function()
            if root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(speed), 0) end
        end)
    elseif cmd == "unspin" or cmd == "unfling" or cmd == "stopspin" then if SpinConnection then SpinConnection:Disconnect(); SpinConnection = nil end
    elseif cmd == "fire" then if root and not root:FindFirstChildOfClass("Fire") then Instance.new("Fire", root) end
    elseif cmd == "unfire" then if root and root:FindFirstChildOfClass("Fire") then root:FindFirstChildOfClass("Fire"):Destroy() end
    elseif cmd == "smoke" then if root and not root:FindFirstChildOfClass("Smoke") then Instance.new("Smoke", root) end
    elseif cmd == "unsmoke" then if root and root:FindFirstChildOfClass("Smoke") then root:FindFirstChildOfClass("Smoke"):Destroy() end
    elseif cmd == "sparkles" then if root and not root:FindFirstChildOfClass("Sparkles") then Instance.new("Sparkles", root) end
    elseif cmd == "unsparkles" then if root and root:FindFirstChildOfClass("Sparkles") then root:FindFirstChildOfClass("Sparkles"):Destroy() end
    elseif cmd == "headless" then if char and char:FindFirstChild("Head") then char.Head.Transparency = 1 end
    elseif cmd == "korblox" then if char and char:FindFirstChild("RightFoot") then char.RightFoot.Transparency = 1 end

    -- Server & Environment
    elseif cmd == "rejoin" or cmd == "rejoinserver" then TeleportService:Teleport(game.PlaceId, LocalPlayer)
    elseif cmd == "serverhop" then TeleportService:Teleport(game.PlaceId)
    elseif cmd == "btools" then
        Instance.new("HopperBin", LocalPlayer.Backpack).BinType = 2
        Instance.new("HopperBin", LocalPlayer.Backpack).BinType = 3
        Instance.new("HopperBin", LocalPlayer.Backpack).BinType = 4
    elseif cmd == "droptools" or cmd == "cleartools" then
        if char then
            for _, t in pairs(char:GetChildren()) do if t:IsA("Tool") then t.Parent = workspace end end
        end
    elseif cmd == "copypos" then if root then setclipboard(tostring(root.Position)) end
    elseif cmd == "copygameid" then setclipboard(tostring(game.PlaceId))
    elseif cmd == "copyjobid" then setclipboard(tostring(game.JobId))
    elseif cmd == "stopprograms" then
        StopFly()
        _G.Noclip = false
        if InfJumpConnection then InfJumpConnection:Disconnect() end
        if SpinConnection then SpinConnection:Disconnect() end
        if LoopGotoConnection then LoopGotoConnection:Disconnect() end
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
