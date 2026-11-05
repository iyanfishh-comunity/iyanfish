--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║  🌌 IYANN FISH | GALAXY EDITION 🌌                          ║
    ║  Game   : Fish It! (Place ID: 121864768012064)              ║
    ║  Theme  : Galaxy (Dark Purple / Neon Cyan)                   ║
    ║  Note   : Gunakan executor yang mendukung Rayfield.          ║
    ╚══════════════════════════════════════════════════════════════╝
]]

-- ============================================================
-- 1. VALIDASI GAME
-- ============================================================
if game.PlaceId ~= 121864768012064 then
    return warn("[iyann fish] Script ini hanya untuk game Fish It! (121864768012064)")
end

-- ============================================================
-- 2. LOAD RAYFIELD UI
-- ============================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ============================================================
-- 3. TEMA GALAXY (KUSTOM)
-- ============================================================
local GalaxyTheme = {
    TextColor = Color3.fromRGB(220, 220, 255),
    Background = Color3.fromRGB(10, 5, 25),
    Topbar = Color3.fromRGB(20, 10, 45),
    Shadow = Color3.fromRGB(5, 0, 15),
    NotificationBackground = Color3.fromRGB(15, 8, 35),
    NotificationActionsBackground = Color3.fromRGB(30, 15, 60),
    TabBackground = Color3.fromRGB(25, 12, 50),
    TabStroke = Color3.fromRGB(60, 30, 100),
    TabBackgroundSelected = Color3.fromRGB(50, 25, 90),
    TabTextColor = Color3.fromRGB(180, 180, 220),
    SelectedTabTextColor = Color3.fromRGB(0, 255, 255), -- Cyan neon
    ElementBackground = Color3.fromRGB(20, 10, 40),
    ElementBackgroundHover = Color3.fromRGB(35, 18, 65),
    SecondaryElementBackground = Color3.fromRGB(15, 8, 30),
    ElementStroke = Color3.fromRGB(70, 35, 120),
    SecondaryElementStroke = Color3.fromRGB(45, 20, 80),
    SliderBackground = Color3.fromRGB(60, 30, 110),
    SliderProgress = Color3.fromRGB(0, 200, 255),
    SliderStroke = Color3.fromRGB(0, 255, 255),
    ToggleBackground = Color3.fromRGB(30, 15, 55),
    ToggleEnabled = Color3.fromRGB(0, 200, 255),
    ToggleDisabled = Color3.fromRGB(80, 80, 100),
    ToggleEnabledStroke = Color3.fromRGB(0, 255, 255),
    ToggleDisabledStroke = Color3.fromRGB(100, 100, 120),
    ToggleEnabledOuterStroke = Color3.fromRGB(0, 150, 200),
    ToggleDisabledOuterStroke = Color3.fromRGB(60, 60, 80),
    DropdownSelected = Color3.fromRGB(50, 25, 90),
    DropdownUnselected = Color3.fromRGB(25, 12, 50),
    InputBackground = Color3.fromRGB(20, 10, 40),
    InputStroke = Color3.fromRGB(70, 35, 120),
    PlaceholderColor = Color3.fromRGB(150, 150, 180),
}

-- ============================================================
-- 4. BUAT WINDOW UTAMA
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "🌌 iyann fish | Galaxy",
    LoadingTitle = "iyann fish",
    LoadingSubtitle = "Galaxy Edition",
    Theme = GalaxyTheme, -- Pakai tema kustom
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "iyann_fish_galaxy",
        FileName = "config"
    },
    KeySystem = false,
})

-- ============================================================
-- 5. SERVICES & REMOTE EVENTS
-- ============================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Ambil folder net (sesuai struktur game Fish It)
local net = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

-- Remote yang umum dipakai di script Fish It
local RE_Equip = net:FindFirstChild("RE/EquipToolFromHotbar")
local RF_Charge = net:FindFirstChild("RF/ChargeFishingRod")
local RF_StartMinigame = net:FindFirstChild("RF/RequestFishingMinigameStarted")
local RE_Completed = net:FindFirstChild("RE/FishingCompleted")
local RF_SellAll = net:FindFirstChild("RF/SellAllItems")

-- Remote opsional (bisa ada atau tidak tergantung update game)
local RF_PlaceTotem = net:FindFirstChild("RE/PlaceTotem") or net:FindFirstChild("RF/PlaceTotem")
local RF_Favorite = net:FindFirstChild("RF/FavoriteItem") or net:FindFirstChild("RE/FavoriteItem")
local RF_GetInventory = net:FindFirstChild("RF/GetInventory") or net:FindFirstChild("RE/GetInventory")

-- ============================================================
-- 6. STATE VARIABEL
-- ============================================================
local isAutoFish = false
local isAutoSell = false
local isAutoTotem = false
local isRemoveEffects = false
local isAutoFavRuby = false

-- ============================================================
-- 7. TAB: AUTO FARM
-- ============================================================
local FarmTab = Window:CreateTab("🎣 Auto Farm", 4483362458)

-- Auto Fish (Fast Reel + Instant + No Anim)
FarmTab:CreateToggle({
    Name = "Auto Fish (Instant + Fast Reel)",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(value)
        isAutoFish = value
        if value then
            task.spawn(function()
                while isAutoFish do
                    pcall(function()
                        -- Nonaktifkan animasi (No Animasi)
                        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                        humanoid:Move(Vector3.new(0, 0, 0))

                        -- Proses memancing instan
                        if RE_Equip then RE_Equip:FireServer() end
                        if RF_Charge then RF_Charge:InvokeServer(1) end
                        if RF_StartMinigame then RF_StartMinigame:InvokeServer(1, 1) end
                        if RE_Completed then RE_Completed:FireServer() end
                    end)
                    task.wait(0.05) -- Jeda sangat kecil agar tidak crash
                end
            end)
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Sell (Semua Item)",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(value)
        isAutoSell = value
        if value then
            task.spawn(function()
                while isAutoSell do
                    pcall(function()
                        if RF_SellAll then
                            RF_SellAll:InvokeServer()
                        end
                    end)
                    task.wait(1) -- Jual tiap 1 detik
                end
            end)
        end
    end,
})

-- ============================================================
-- 8. TAB: AUTO TOTEM
-- ============================================================
local TotemTab = Window:CreateTab("🗿 Auto Totem", 4483362458)

TotemTab:CreateToggle({
    Name = "Auto Spawn Totem",
    CurrentValue = false,
    Flag = "AutoTotem",
    Callback = function(value)
        isAutoTotem = value
        if value then
            task.spawn(function()
                while isAutoTotem do
                    pcall(function()
                        -- Coba panggil remote totem jika ada
                        if RF_PlaceTotem then
                            RF_PlaceTotem:FireServer()
                        else
                            -- Fallback: cari tool bernama "Totem" di backpack dan equip/aktifkan
                            local backpack = player:FindFirstChild("Backpack")
                            if backpack then
                                for _, item in ipairs(backpack:GetChildren()) do
                                    if item.Name:lower():find("totem") then
                                        humanoid:EquipTool(item)
                                        task.wait(0.2)
                                        item:Activate()
                                        break
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(5) -- Coba tiap 5 detik
                end
            end)
        end
    end,
})

-- ============================================================
-- 9. TAB: VISUAL / EFFECTS
-- ============================================================
local VisualTab = Window:CreateTab("✨ Visuals", 4483362458)

VisualTab:CreateToggle({
    Name = "Hapus Efek (Ability + Skin)",
    CurrentValue = false,
    Flag = "RemoveEffects",
    Callback = function(value)
        isRemoveEffects = value
        if value then
            task.spawn(function()
                while isRemoveEffects do
                    pcall(function()
                        -- Hapus particle / trail / beam di karakter
                        for _, obj in ipairs(char:GetDescendants()) do
                            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") then
                                obj.Enabled = false
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end,
})

-- ============================================================
-- 10. TAB: AUTO FAVORITE (RUBY GAMESTONE)
-- ============================================================
local FavTab = Window:CreateTab("⭐ Auto Favorite", 4483362458)

FavTab:CreateToggle({
    Name = "Auto Fav: Ruby Gamestone (Legendary)",
    CurrentValue = false,
    Flag = "AutoFavRuby",
    Callback = function(value)
        isAutoFavRuby = value
        if value then
            task.spawn(function()
                while isAutoFavRuby do
                    pcall(function()
                        -- Dapatkan daftar inventory (jika remote tersedia)
                        local inventory = nil
                        if RF_GetInventory then
                            inventory = RF_GetInventory:InvokeServer()
                        end

                        -- Jika inventory adalah tabel, iterasi dan cari yang cocok
                        if type(inventory) == "table" then
                            for _, fish in pairs(inventory) do
                                -- Asumsi struktur fish: {Name, Mutation, Rarity, Id}
                                local fishName = fish.Name or fish.name or ""
                                local fishMutation = fish.Mutation or fish.mutation or ""
                                local fishRarity = fish.Rarity or fish.rarity or ""

                                if fishName:lower() == "ruby"
                                    and fishMutation:lower() == "gamestone"
                                    and fishRarity:lower() == "legendary" then
                                    -- Panggil remote favorite
                                    if RF_Favorite then
                                        RF_Favorite:FireServer(fish.Id or fish.id or fish)
                                    end
                                end
                            end
                        else
                            -- Fallback: jika tidak ada remote inventory, coba panggil favorite tanpa filter
                            -- (Tidak disarankan, hanya jika terpaksa)
                            warn("[iyann fish] Remote inventory tidak ditemukan, Auto Fav mungkin tidak bekerja optimal.")
                        end
                    end)
                    task.wait(2) -- Scan tiap 2 detik
                end
            end)
        end
    end,
})

-- ============================================================
-- 11. TAB: MISC (Fitur Tambahan)
-- ============================================================
local MiscTab = Window:CreateTab("⚙️ Misc", 4483362458)

-- Anti AFK
MiscTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = true,
    Flag = "AntiAFK",
    Callback = function(value)
        if value then
            player.Idled:Connect(function()
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end,
})

-- FPS Boost (sederhana: kurangi kualitas grafis)
MiscTab:CreateButton({
    Name = "FPS Boost (Kurangi Grafis)",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
        Rayfield:Notify({
            Title = "iyann fish",
            Content = "FPS Boost diaktifkan. Efek partikel dimatikan.",
            Duration = 3,
        })
    end,
})

-- ============================================================
-- 12. WATERMARK & NOTIFIKASI
-- ============================================================
-- Watermark di pojok kiri atas (ScreenGui terpisah)
local function createWatermark()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "iyann_fish_watermark"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 40)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(10, 5, 25)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.5
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🌌 iyann fish | Galaxy"
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.TextScaled = false
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.Parent = frame

    -- Efek gradien sederhana (UIGradient)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255)),
    })
    gradient.Rotation = 90
    gradient.Parent = stroke
end

createWatermark()

-- Notifikasi saat script dimuat
Rayfield:Notify({
    Title = "iyann fish | Galaxy",
    Content = "Script berhasil dimuat. Selamat memancing! 🌌",
    Duration = 5,
})

print("[iyann fish] Galaxy Edition loaded successfully.")