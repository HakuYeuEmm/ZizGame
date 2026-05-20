local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

local Window = Library:CreateWindow({
    Title = "Script Hub",
    SubTitle = "Made by User",
    TabWidth = 140,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {}
local Elements = {}
local ActiveThreads = {}
local StopCallbacks = {}

local TabOrder = {"Main", "Settings"}
local TabIcons = {
    Main = "phosphor-users-bold",
    Settings = "settings"
}

local SettingsFile = "ScriptHub_Settings.json"
local Settings = {}

local LoadSettings = function()
    local success, result = pcall(function()
        local data = readfile(SettingsFile)
        if data and data ~= "" then
            return game:GetService("HttpService"):JSONDecode(data)
        end
        return {}
    end)
    if success and type(result) == "table" then
        Settings = result
    else
        Settings = {}
    end
end

local SaveSettings = function()
    pcall(function()
        writefile(SettingsFile, game:GetService("HttpService"):JSONEncode(Settings))
    end)
end

LoadSettings()

local SpawnTracked = function(fn)
    local thread = task.spawn(fn)
    table.insert(ActiveThreads, thread)
    return thread
end

local StopAllLogic = function()
    for _, thread in ipairs(ActiveThreads) do
        pcall(task.cancel, thread)
    end
    ActiveThreads = {}

    for _, fn in ipairs(StopCallbacks) do
        pcall(fn)
    end
    StopCallbacks = {}
end

local GetDefault = function(Element)
    if Element.Default ~= nil then
        return Element.Default
    end
    if Element.Mode == "Toggle" then
        return false
    elseif Element.Mode == "Slider" then
        return 0
    elseif Element.Mode == "Dropdown" then
        return ""
    elseif Element.Mode == "TextBox" then
        return ""
    elseif Element.Mode == "Colorpicker" then
        return {R = 1, G = 1, B = 1}
    elseif Element.Mode == "Keybind" then
        return "LeftControl"
    end
    return nil
end

local UIConfig = {
    Main = {
        {
            Section = "Information"
        },
        {
            Id = "Welcome",
            Mode = "Label",
            Title = "Welcome to Script Hub",
            Content = "Thank you for using Script Hub. Navigate the tabs above to configure combat, player, and visual settings."
        },
        {
            Section = "Tsuki Hub Premium/Free"
        },
        {
            Id = "Anti-Banned",
            Mode = "Toggle",
            Title = "Auto Bypass",
            Description = "Bypass Anti-Cheating in Games",
            Default = true,
            Callback = function(Value)
                print("", Value)
            end
        },
        -- ===== CUSTOM INFO =====

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local StartTime = tick()

local GameName = "Unknown"

pcall(function()
    GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

Tabs.Main:CreateParagraph("GameInfo", {
    Title = "Tên Game Đang Chơi",
    Content = GameName
})

Tabs.Main:CreateParagraph("UserInfo", {
    Title = "Tên Người Dùng",
    Content = LocalPlayer.Name
})

Tabs.Main:CreateParagraph("ExecutorInfo", {
    Title = "Client Sử Dụng",
    Content = identifyexecutor and identifyexecutor() or "Unknown"
})

Tabs.Main:CreateParagraph("DeviceInfo", {
    Title = "Thiết Bị",
    Content = UserInputService.TouchEnabled and "Mobile" or "PC"
})

spawn(function()
    while task.wait(1) do
        local elapsed = math.floor(tick() - StartTime)

        local h = math.floor(elapsed / 3600)
        local m = math.floor((elapsed % 3600) / 60)
        local s = elapsed % 60

        local realtime = os.date("%H:%M:%S")
        local servertime = game.Lighting.TimeOfDay

        local fps = math.floor(1 / RunService.RenderStepped:Wait())

        Tabs.Main:CreateParagraph("RealtimeInfo", {
            Title = "Thông Tin",
            Content =
                "Thời Gian Chơi: " .. h .. "h " .. m .. "m " .. s .. "s\n" ..
                "Thời Gian Máy Chủ: " .. servertime .. "\n" ..
                "FPS: " .. fps .. "\n" ..
                "Thời Gian Thực: " .. realtime
        })
    end
end)

-- ===== BUTTONS =====

local RunButton = Tabs.Main:AddButton({
    Title = "Run Script",
    Callback = function()
        Library:Notify({
            Title = "Script Hub",
            Content = "Script Running...",
            Duration = 3
        })
    end
})

local CopyButton1 = Tabs.Main:AddButton({
    Title = "Copy 1",
    Callback = function()
        setclipboard("https://example1.com")
    end
})

local CopyButton2 = Tabs.Main:AddButton({
    Title = "Copy 2",
    Callback = function()
        setclipboard("https://example2.com")
    end
})

local CloseButton = Tabs.Settings:AddButton({
    Title = "Close GUI",
    Callback = function()
        for _,v in pairs(game:GetService("CoreGui"):GetChildren()) do
            if v.Name:find("ScreenGui") then
                v:Destroy()
            end
        end
    end
})
        {
            Section = "Bypass"
        },
        {
            Id = "AntiAFK",
            Mode = "Toggle",
            Title = "Anti-AFK",
            Description = "Prevent the game from kicking you due to inactivity.",
            Default = false,
            Callback = function(Value)
                print("Anti-AFK:", Value)
            end
        },
        {
            Section = "Misc-WebHook"
        },
        {
            Id = "Webhook",
            Mode = "TextBox",
            Title = "Discord Webhook",
            Description = "Paste your Discord webhook URL to receive farm notifications.",
            Default = "",
            Placeholder = "Input...",
            Callback = function(Value)
                print("Webhook:", Value)
            end
        },
        {
            Id = "ToggleKey",
            Mode = "Keybind",
            Title = "Toggle UI",
            Description = "Keybind to show or hide the Script Hub window.",
            Mode2 = "Toggle",
            Default = "LeftControl"
        }
    },

    Settings = {
        {
            Section = "Settings Manager"
        },
        {
            Id = "SettingsLabel",
            Mode = "Label",
            Title = "Manage Settings",
            Content = "Reset all settings back to their default values. This will also stop all active logic and running tasks."
        },
        {
            Id = "ResetSettings",
            Mode = "Button",
            Title = "Reset to Default",
            Description = "Clear the saved settings file and restore all values to default.",
            Callback = function() end
        }
    }
}

local ResetSettings = function()
    StopAllLogic()

    Settings = {}
    pcall(function()
        delfile(SettingsFile)
    end)

    for _, Name in ipairs(TabOrder) do
        local ElementsList = UIConfig[Name]
        if type(ElementsList) == "table" then
            for _, Element in ipairs(ElementsList) do
                if type(Element) == "table" and Element.Id and Element.Mode then
                    if Element.Mode ~= "Label" and Element.Mode ~= "Button" and Element.Mode ~= "Section" then
                        local Default = GetDefault(Element)
                        pcall(function()
                            if Element.Mode == "Toggle" and Library.Options[Element.Id] then
                                Library.Options[Element.Id]:SetValue(Default)
                            elseif Element.Mode == "Slider" and Elements[Name] and Elements[Name][Element.Id] then
                                Elements[Name][Element.Id]:SetValue(Default)
                            elseif Element.Mode == "Dropdown" and Elements[Name] and Elements[Name][Element.Id] then
                                Elements[Name][Element.Id]:SetValue(Default)
                            elseif Element.Mode == "Colorpicker" and Elements[Name] and Elements[Name][Element.Id] then
                                local DefaultColor = Color3.fromRGB(Default.R * 255, Default.G * 255, Default.B * 255)
                                Elements[Name][Element.Id]:SetValueRGB(DefaultColor)
                            elseif Element.Mode == "Keybind" and Elements[Name] and Elements[Name][Element.Id] then
                                Elements[Name][Element.Id]:SetValue(Default, Element.Mode2 or "Toggle")
                            elseif Element.Mode == "TextBox" and Library.Options[Element.Id] then
                                Library.Options[Element.Id]:SetValue(Default)
                            end
                        end)
                    end
                end
            end
        end
    end

    Library:Notify({
        Title = "Settings Reset",
        Content = "All settings have been restored to their default values.",
        SubContent = "All active logic and tasks have been stopped.",
        Duration = 4
    })
end

UIConfig.Settings[3].Callback = function()
    ResetSettings()
end

local BuildElement = function(Tab, Name, Element)
    if type(Element) ~= "table" then return end

    if Element.Section then
        Tab:AddSection(Element.Section)
        return
    end

    local Mode = Element.Mode
    local Id = Element.Id

    if not Id or not Mode then return end

    if Mode == "Label" then
        Elements[Name][Id] = Tab:CreateParagraph(Id, {
            Title = Element.Title,
            Content = Element.Content
        })
        return
    end

    local Key = Name .. "_" .. Id

    if Settings[Key] == nil and Mode ~= "Button" then
        Settings[Key] = GetDefault(Element)
        SaveSettings()
    end

    if Mode == "Toggle" then
        local Default = Settings[Key]
        Elements[Name][Id] = Tab:CreateToggle(Id, {
            Title = Element.Title,
            Description = Element.Description,
            Default = Default
        })

        if Default == true and Element.Callback then
            SpawnTracked(function()
                Element.Callback(Default)
            end)
        end

        Elements[Name][Id]:OnChanged(function(Value)
            if Value == nil then return end
            Settings[Key] = Value
            SaveSettings()
            if Element.Callback then
                if Value == true then
                    SpawnTracked(function()
                        Element.Callback(Value)
                    end)
                else
                    StopAllLogic()
                    Element.Callback(Value)
                end
            end
        end)

    elseif Mode == "Slider" then
        local Default = Settings[Key]
        Elements[Name][Id] = Tab:CreateSlider(Id, {
            Title = Element.Title,
            Description = Element.Description,
            Default = Default,
            Min = Element.Min or 0,
            Max = Element.Max or 100,
            Rounding = Element.Rounding or 1
        })

        if Element.Callback then
            SpawnTracked(function()
                Element.Callback(Default)
            end)
        end

        Elements[Name][Id]:OnChanged(function(Value)
            if Value == nil then return end
            Settings[Key] = Value
            SaveSettings()
            if Element.Callback then
                Element.Callback(Value)
            end
        end)

    elseif Mode == "Dropdown" then
        local Default = Settings[Key]
        Elements[Name][Id] = Tab:CreateDropdown(Id, {
            Title = Element.Title,
            Description = Element.Description,
            Values = Element.Values or {},
            Default = Default,
            Multi = Element.Multi or false
        })

        if Element.Callback then
            SpawnTracked(function()
                Element.Callback(Default)
            end)
        end

        Elements[Name][Id]:OnChanged(function(Value)
            if Value == nil then return end
            Settings[Key] = Value
            SaveSettings()
            if Element.Callback then
                Element.Callback(Value)
            end
        end)

    elseif Mode == "Button" then
        Elements[Name][Id] = Tab:CreateButton({
            Title = Element.Title,
            Description = Element.Description,
            Callback = Element.Callback or function() end
        })

    elseif Mode == "Keybind" then
        local Default = Settings[Key]
        Elements[Name][Id] = Tab:CreateKeybind(Id, {
            Title = Element.Title,
            Description = Element.Description,
            Mode = Element.Mode2 or "Toggle",
            Default = Default
        })

        Elements[Name][Id]:OnChanged(function()
            local Value = Elements[Name][Id].Value
            if Value == nil then return end
            Settings[Key] = Value
            SaveSettings()
        end)

    elseif Mode == "Colorpicker" then
        local C = Settings[Key]
        if type(C) ~= "table" or C.R == nil then
            C = GetDefault(Element)
            Settings[Key] = C
            SaveSettings()
        end
        local DefaultColor = Color3.fromRGB(C.R * 255, C.G * 255, C.B * 255)
        Elements[Name][Id] = Tab:CreateColorpicker(Id, {
            Title = Element.Title,
            Description = Element.Description,
            Default = DefaultColor
        })

        if Element.Callback then
            SpawnTracked(function()
                Element.Callback(DefaultColor)
            end)
        end

        Elements[Name][Id]:OnChanged(function()
            local Color = Elements[Name][Id].Value
            if Color == nil then return end
            Settings[Key] = {
                R = math.floor(Color.R * 255 + 0.5) / 255,
                G = math.floor(Color.G * 255 + 0.5) / 255,
                B = math.floor(Color.B * 255 + 0.5) / 255
            }
            SaveSettings()
            if Element.Callback then
                Element.Callback(Color)
            end
        end)

    elseif Mode == "TextBox" then
        local Default = Settings[Key]
        Elements[Name][Id] = Tab:CreateInput(Id, {
            Title = Element.Title,
            Description = Element.Description,
            Default = Default,
            Placeholder = Element.Placeholder or "",
            Numeric = Element.Numeric or false,
            Finished = Element.Finished or false,
            Callback = function(Value)
                Settings[Key] = Value
                SaveSettings()
                if Element.Callback then
                    Element.Callback(Value)
                end
            end
        })
    end
end

for _, Name in ipairs(TabOrder) do
    Elements[Name] = {}
    Tabs[Name] = Window:CreateTab({
        Title = Name,
        Icon = TabIcons[Name] or ""
    })
end

for _, Name in ipairs(TabOrder) do
    local ElementsList = UIConfig[Name]
    if Tabs[Name] and type(ElementsList) == "table" then
        for _, Element in ipairs(ElementsList) do
            BuildElement(Tabs[Name], Name, Element)
        end
    end
end

InterfaceManager:SetLibrary(Library)
InterfaceManager:SetFolder("ScriptHub")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

Window:SelectTab(1)
