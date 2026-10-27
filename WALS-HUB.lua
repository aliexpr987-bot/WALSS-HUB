--========================================
-- WALS HUB v2.0 | UI independiente
-- Interfaz Lua para entorno cliente
-- Sin carga de scripts remotos
--========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("WALS_HUB")
if old then old:Destroy() end

local Themes = {
    Morado = {
        bg = Color3.fromRGB(18, 15, 27),
        panel = Color3.fromRGB(31, 24, 44),
        card = Color3.fromRGB(44, 34, 61),
        accent = Color3.fromRGB(151, 89, 255),
        text = Color3.fromRGB(250, 246, 255),
        muted = Color3.fromRGB(183, 168, 207)
    },
    Rojo = {
        bg = Color3.fromRGB(25, 15, 19),
        panel = Color3.fromRGB(43, 24, 31),
        card = Color3.fromRGB(59, 34, 43),
        accent = Color3.fromRGB(255, 76, 101),
        text = Color3.fromRGB(255, 245, 247),
        muted = Color3.fromRGB(204, 164, 174)
    },
    Azul = {
        bg = Color3.fromRGB(14, 19, 30),
        panel = Color3.fromRGB(23, 31, 48),
        card = Color3.fromRGB(33, 44, 66),
        accent = Color3.fromRGB(69, 145, 255),
        text = Color3.fromRGB(245, 250, 255),
        muted = Color3.fromRGB(163, 181, 209)
    },
    Verde = {
        bg = Color3.fromRGB(14, 23, 19),
        panel = Color3.fromRGB(22, 36, 29),
        card = Color3.fromRGB(32, 49, 39),
        accent = Color3.fromRGB(55, 218, 142),
        text = Color3.fromRGB(244, 255, 248),
        muted = Color3.fromRGB(161, 195, 174)
    }
}

local themeName = "Morado"
local C = Themes[themeName]
local selectedTab = "Inicio"
local minimized = false
local sidebarOpen = true

local function new(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    new("UICorner", {
        CornerRadius = UDim.new(0, radius or 10)
    }, obj)
end

local gui = new("ScreenGui", {
    Name = "WALS_HUB",
    ResetOnSpawn = false,
    DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, playerGui)

local floating = new("TextButton", {
    Name = "WALS_Button",
    Size = UDim2.fromOffset(54, 54),
    Position = UDim2.new(0, 16, 0.5, -27),
    BackgroundColor3 = C.accent,
    Text = "W",
    TextColor3 = C.text,
    TextSize = 26,
    Font = Enum.Font.GothamBold,
    Visible = false,
    ZIndex = 10
}, gui)
round(floating, 18)

local main = new("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(620, 420),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, gui)
round(main, 14)

new("UIStroke", {
    Color = C.accent,
    Thickness = 1.5,
    Transparency = 0.25
}, main)

new("UISizeConstraint", {
    MinSize = Vector2.new(285, 300),
    MaxSize = Vector2.new(720, 520)
}, main)

local header = new("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 58),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0
}, main)
round(header, 14)

local logo = new("TextLabel", {
    Position = UDim2.fromOffset(12, 10),
    Size = UDim2.fromOffset(38, 38),
    BackgroundColor3 = C.accent,
    Text = "W",
    TextColor3 = C.text,
    TextSize = 23,
    Font = Enum.Font.GothamBold
}, header)
round(logo, 10)

new("TextLabel", {
    Position = UDim2.fromOffset(60, 7),
    Size = UDim2.new(1, -125, 0, 27),
    BackgroundTransparency = 1,
    Text = "WALS HUB",
    TextColor3 = C.text,
    TextSize = 19,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

new("TextLabel", {
    Position = UDim2.fromOffset(61, 32),
    Size = UDim2.new(1, -125, 0, 15),
    BackgroundTransparency = 1,
    Text = "CUSTOM INTERFACE  •  v2.0",
    TextColor3 = C.muted,
    TextSize = 9,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local hide = new("TextButton", {
    Position = UDim2.new(1, -46, 0, 12),
    Size = UDim2.fromOffset(34, 34),
    BackgroundColor3 = C.card,
    Text = "—",
    TextColor3 = C.text,
    TextSize = 20,
    Font = Enum.Font.GothamBold
}, header)
round(hide, 9)

local sidebar = new("Frame", {
    Position = UDim2.fromOffset(0, 58),
    Size = UDim2.new(0, 145, 1, -58),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0
}, main)

new("UIPadding", {
    PaddingTop = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 9),
    PaddingRight = UDim.new(0, 9)
}, sidebar)

new("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder
}, sidebar)

local content = new("ScrollingFrame", {
    Position = UDim2.new(0, 157, 0, 70),
    Size = UDim2.new(1, -169, 1, -82),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = C.accent,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new()
}, main)

new("UIPadding", {
    PaddingRight = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 12)
}, content)

new("UIListLayout", {
    Padding = UDim.new(0, 9),
    SortOrder = Enum.SortOrder.LayoutOrder
}, content)

local nav = {}
local render

local function label(parent, text, height, size, color)
    return new("TextLabel", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or C.text,
        TextSize = size or 13,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    }, parent)
end

local function button(parent, text, callback)
    local b = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = C.card,
        Text = text,
        TextColor3 = C.text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = true
    }, parent)
    round(b, 8)
    b.Activated:Connect(callback)
    return b
end

local function card(parent, height)
    local f = new("Frame", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = C.card,
        BorderSizePixel = 0
    }, parent)
    round(f, 10)
    return f
end

local function clear()
    for _, v in ipairs(content:GetChildren()) do
        if not v:IsA("UIListLayout")
            and not v:IsA("UIPadding") then
            v:Destroy()
        end
    end
end

local function heading(title, subtitle)
    label(content, title, 32, 21, C.text).Font =
        Enum.Font.GothamBold
    if subtitle then
        label(content, subtitle, 32, 12, C.muted)
    end
end

local function renderHome()
    heading("Bienvenido a WALS", "Tu panel personalizado")

    local welcome = card(content, 85)
    new("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 12)
    }, welcome)

    label(welcome, "WALS HUB v2.0", 25, 16, C.accent)
        .Font = Enum.Font.GothamBold
    label(welcome, "Interfaz independiente para movil y PC.",
        35, 12, C.muted)

    button(content, "▦   Abrir Juegos", function()
        selectedTab = "Juegos"
        render()
    end)

    button(content, "◈   Cambiar Tema", function()
        selectedTab = "Temas"
        render()
    end)
end

local function renderGames()
    heading("Juegos", "Lista informativa")

    local games = {
        "Steal an Egg",
        "Rivals",
        "Jump for Animals",
        "Steal a Brainrot",
        "Murder Mystery 2",
        "Brookhaven"
    }

    for _, name in ipairs(games) do
        local item = card(content, 45)
        new("TextLabel", {
            Position = UDim2.fromOffset(12, 0),
            Size = UDim2.new(1, -24, 1, 0),
            BackgroundTransparency = 1,
            Text = "▸   " .. name,
            TextColor3 = C.text,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left
        }, item)
    end

    label(content,
        "Los nombres no ejecutan funciones ni scripts externos.",
        38, 11, C.muted)
end

local function renderThemes()
    heading("Temas", "Personaliza los colores")

    for name, palette in pairs(Themes) do
        local b = button(content,
            (name == themeName and "✓   " or "◉   ") .. name,
            function()
                themeName = name
                C = Themes[name]
                render()
            end)
        b.BackgroundColor3 = palette.panel
        b.TextColor3 = palette.text
    end
end

local function renderSettings()
    heading("Ajustes", "Preferencias de la interfaz")

    button(content,
        sidebarOpen and "Barra lateral: completa"
            or "Barra lateral: compacta",
        function()
            sidebarOpen = not sidebarOpen
            render()
        end)

    button(content, "Minimizar WALS", function()
        minimized = true
        main.Visible = false
        floating.Visible = true
    end)

    label(content, "Nombre: WALS HUB\nVersion: 2.0\nModo: interfaz local",
        65, 12, C.muted)
end

render = function()
    clear()

    for name, b in pairs(nav) do
        b.BackgroundColor3 = name == selectedTab
            and C.accent or C.panel
        b.TextColor3 = C.text
    end

    if selectedTab == "Inicio" then
        renderHome()
    elseif selectedTab == "Juegos" then
        renderGames()
    elseif selectedTab == "Temas" then
        renderThemes()
    elseif selectedTab == "Ajustes" then
        renderSettings()
    end

    main.BackgroundColor3 = C.bg
    main:FindFirstChildOfClass("UIStroke").Color = C.accent
    header.BackgroundColor3 = C.panel
    sidebar.BackgroundColor3 = C.panel
    floating.BackgroundColor3 = C.accent
    logo.BackgroundColor3 = C.accent

    for _, b in pairs(nav) do
        b.BackgroundColor3 = b.Name == selectedTab
            and C.accent or C.panel
    end
end

local tabs = {
    {"Inicio", "⌂"},
    {"Juegos", "▦"},
    {"Temas", "◈"},
    {"Ajustes", "⚙"}
}

for i, info in ipairs(tabs) do
    local name, icon = info[1], info[2]
    local b = new("TextButton", {
        Name = name
