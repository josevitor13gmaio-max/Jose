-- ==================================================
-- FRED MOD MENU - SCRIPT ÚNICO FINAL
-- ESP (pauzinhos limpos) + FOV (+/-) + AIMBOT SÓ INIMIGO
-- Menu arrastável + Botão José
-- ==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ===== CONFIG =====
local CONFIG = {
    ESP_Ativo = true,
    Aimbot_Ativo = false,
    FOV = 150,
    Tecla_Menu = Enum.KeyCode.RightShift,
    Tecla_Aimbot = Enum.KeyCode.E,
    Tecla_ESP = Enum.KeyCode.F,
    AimSuave = 0.35,
    MostrarLinhas = true,
    MostrarBox = true,
    MostrarNome = true,
    MostrarDistancia = true,
    SoInimigoNoESP = true,
    CorInimigo = Color3.fromRGB(255, 50, 50),
    CorAliado = Color3.fromRGB(50, 255, 50),
}

-- ==========================================
-- VERIFICAÇÃO DE TIME
-- ==========================================
local function isInimigo(player)
    if not player.Team or not LocalPlayer.Team then
        return true
    end
    return player.Team ~= LocalPlayer.Team
end

-- ==========================================
-- GUI
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "FredModMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Círculo FOV
local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(0, CONFIG.FOV, 0, CONFIG.FOV)
fovCircle.Position = UDim2.new(0.5, -CONFIG.FOV/2, 0.5, -CONFIG.FOV/2)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 2
fovCircle.BorderColor3 = Color3.fromRGB(0, 255, 0)
fovCircle.Visible = false
fovCircle.ZIndex = 5
fovCircle.Parent = gui

-- ==========================================
-- MENU ARRASTÁVEL
-- ==========================================
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 260, 0, 400)
menu.Position = UDim2.new(0, 40, 0.5, -200)
menu.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
menu.BorderSizePixel = 0
menu.Active = true
menu.Draggable = true
menu.Visible = true
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menu

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = Color3.fromRGB(0, 150, 255)
menuStroke.Thickness = 1.5
menuStroke.Parent = menu

-- Barra de título
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
topBar.BorderSizePixel = 0
topBar.Parent = menu

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 10)
topCorner.Parent = topBar

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, -40, 1, 0)
titulo.Position = UDim2.new(0, 10, 0, 0)
titulo.BackgroundTransparency = 1
titulo.Text = "🎯 FRED MOD MENU"
titulo.TextColor3 = Color3.new(1,1,1)
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 15
titulo.Parent = topBar

local btnFechar = Instance.new("TextButton")
btnFechar.Size = UDim2.new(0, 26, 0, 26)
btnFechar.Position = UDim2.new(1, -32, 0, 5)
btnFechar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btnFechar.Text = "X"
btnFechar.TextColor3 = Color3.new(1,1,1)
btnFechar.Font = Enum.Font.GothamBold
btnFechar.TextSize = 14
btnFechar.Parent = topBar
local xCorner = Instance.new("UICorner"); xCorner.CornerRadius = UDim.new(0,6); xCorner.Parent = btnFechar

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -12, 1, -46)
scroll.Position = UDim2.new(0, 6, 0, 42)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
scroll.CanvasSize = UDim2.new(0, 0, 0, 520)
scroll.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

-- ===== FUNÇÕES DE UI =====
local function criarBotao(texto, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    btn.Text = texto
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = scroll
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function criarLabel(texto)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -8, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = texto
    lbl.TextColor3 = Color3.fromRGB(180, 180, 200)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = scroll
    return lbl
end

local function criarSeparador()
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -8, 0, 1)
    sep.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sep.BorderSizePixel = 0
    sep.Parent = scroll
    return sep
end

-- ==========================================
-- BOTÕES DO MENU
-- ==========================================
criarLabel("▸ VISUAL")

local btnESP = criarBotao("ESP: ON  [F]", function()
    CONFIG.ESP_Ativo = not CONFIG.ESP_Ativo
    btnESP.Text = "ESP: " .. (CONFIG.ESP_Ativo and "ON" or "OFF") .. "  [F]"
end)

local btnLinhas = criarBotao("Pauzinhos: ON", function()
    CONFIG.MostrarLinhas = not CONFIG.MostrarLinhas
    btnLinhas.Text = "Pauzinhos: " .. (CONFIG.MostrarLinhas and "ON" or "OFF")
end)

local btnBox = criarBotao("Box: ON", function()
    CONFIG.MostrarBox = not CONFIG.MostrarBox
    btnBox.Text = "Box: " .. (CONFIG.MostrarBox and "ON" or "OFF")
end)

local btnNome = criarBotao("Nome: ON", function()
    CONFIG.MostrarNome = not CONFIG.MostrarNome
    btnNome.Text = "Nome: " .. (CONFIG.MostrarNome and "ON" or "OFF")
end)

local btnDist = criarBotao("Distância: ON", function()
    CONFIG.MostrarDistancia = not CONFIG.MostrarDistancia
    btnDist.Text = "Distância: " .. (CONFIG.MostrarDistancia and "ON" or "OFF")
end)

local btnSoInimigo = criarBotao("ESP só Inimigo: ON", function()
    CONFIG.SoInimigoNoESP = not CONFIG.SoInimigoNoESP
    btnSoInimigo.Text = "ESP só Inimigo: " .. (CONFIG.SoInimigoNoESP and "ON" or "OFF")
end)

criarSeparador()
criarLabel("▸ AIMBOT")

local btnAimbot = criarBotao("AIMBOT: OFF  [E]", function()
    CONFIG.Aimbot_Ativo = not CONFIG.Aimbot_Ativo
    btnAimbot.Text = "AIMBOT: " .. (CONFIG.Aimbot_Ativo and "ON" or "OFF") .. "  [E]"
    fovCircle.Visible = CONFIG.Aimbot_Ativo
end)

-- Controle de FOV
local fovFrame = Instance.new("Frame")
fovFrame.Size = UDim2.new(1, -8, 0, 36)
fovFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
fovFrame.BorderSizePixel = 0
fovFrame.Parent = scroll
local fovFrameCorner = Instance.new("UICorner"); fovFrameCorner.CornerRadius = UDim.new(0,6); fovFrameCorner.Parent = fovFrame

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0.5, 0, 1, 0)
fovLabel.Position = UDim2.new(0, 10, 0, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: " .. CONFIG.FOV
fovLabel.TextColor3 = Color3.new(1,1,1)
fovLabel.Font = Enum.Font.GothamBold
fovLabel.TextSize = 13
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.Parent = fovFrame

local btnMenos = Instance.new("TextButton")
btnMenos.Size = UDim2.new(0, 34, 0, 26)
btnMenos.Position = UDim2.new(1, -84, 0, 5)
btnMenos.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
btnMenos.Text = "−"
btnMenos.TextColor3 = Color3.new(1,1,1)
btnMenos.Font = Enum.Font.GothamBold
btnMenos.TextSize = 18
btnMenos.Parent = fovFrame
local cMenos = Instance.new("UICorner"); cMenos.CornerRadius = UDim.new(0,6); cMenos.Parent = btnMenos

local btnMais = Instance.new("TextButton")
btnMais.Size = UDim2.new(0, 34, 0, 26)
btnMais.Position = UDim2.new(1, -44, 0, 5)
btnMais.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
btnMais.Text = "+"
btnMais.TextColor3 = Color3.new(1,1,1)
btnMais.Font = Enum.Font.GothamBold
btnMais.TextSize = 18
btnMais.Parent = fovFrame
local cMais = Instance.new("UICorner"); cMais.CornerRadius = UDim.new(0,6); cMais.Parent = btnMais

local function atualizarFOV()
    fovLabel.Text = "FOV: " .. CONFIG.FOV
    fovCircle.Size = UDim2.new(0, CONFIG.FOV, 0, CONFIG.FOV)
    fovCircle.Position = UDim2.new(0.5, -CONFIG.FOV/2, 0.5, -CONFIG.FOV/2)
end

btnMais.MouseButton1Click:Connect(function()
    CONFIG.FOV = math.min(CONFIG.FOV + 20, 1000)
    atualizarFOV()
end)

btnMenos.MouseButton1Click:Connect(function()
    CONFIG.FOV = math.max(CONFIG.FOV - 20, 20)
    atualizarFOV()
end)

local btnSuave = criarBotao("Suavidade: 0.35", function()
    CONFIG.AimSuave = CONFIG.AimSuave + 0.15
    if CONFIG.AimSuave > 1 then CONFIG.AimSuave = 0.05 end
    btnSuave.Text = string.format("Suavidade: %.2f", CONFIG.AimSuave)
end)

criarSeparador()
criarLabel("▸ SISTEMA")

local btnReset = criarBotao("Resetar Config", function()
    CONFIG.FOV = 150
    CONFIG.AimSuave = 0.35
    CONFIG.ESP_Ativo = true
    CONFIG.Aimbot_Ativo = false
    atualizarFOV()
    btnESP.Text = "ESP: ON  [F]"
    btnAimbot.Text = "AIMBOT: OFF  [E]"
    btnSuave.Text = "Suavidade: 0.35"
    fovCircle.Visible = false
end)

-- ==========================================
-- BOTÃO JOSÉ
-- ==========================================
local jose = Instance.new("TextButton")
jose.Size = UDim2.new(0, 110, 0, 40)
jose.Position = UDim2.new(0, 20, 0, 20)
jose.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
jose.Text = "👤 JOSÉ"
jose.TextColor3 = Color3.new(1,1,1)
jose.Font = Enum.Font.GothamBold
jose.TextSize = 15
jose.Active = true
jose.Draggable = true
jose.Parent = gui

local joseCorner = Instance.new("UICorner")
joseCorner.CornerRadius = UDim.new(0, 20)
joseCorner.Parent = jose

local joseStroke = Instance.new("UIStroke")
joseStroke.Color = Color3.fromRGB(0, 200, 255)
joseStroke.Thickness = 2
joseStroke.Parent = jose

jose.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

btnFechar.MouseButton1Click:Connect(function()
    menu.Visible = false
end)

-- ==========================================
-- ESP LIMPO
-- ==========================================
local espAtivos = {}

local function criarESP(player)
    local container = Instance.new("Frame")
    container.Name = "ESP_" .. player.Name
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ZIndex = 998
    container.Visible = false
    container.Parent = gui

    local linha = Instance.new("Frame")
    linha.Name = "Linha"
    linha.BackgroundColor3 = CONFIG.CorInimigo
    linha.BorderSizePixel = 0
    linha.AnchorPoint = Vector2.new(0.5, 0)
    linha.ZIndex = 998
    linha.Parent = container

    local box = Instance.new("Frame")
    box.Name = "Box"
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 2
    box.BorderColor3 = CONFIG.CorInimigo
    box.ZIndex = 998
    box.Parent = container

    local nome = Instance.new("TextLabel")
    nome.Name = "Nome"
    nome.BackgroundTransparency = 1
    nome.TextColor3 = Color3.new(1,1,1)
    nome.Font = Enum.Font.GothamBold
    nome.TextSize = 13
    nome.TextStrokeTransparency = 0
    nome.TextStrokeColor3 = Color3.new(0,0,0)
    nome.ZIndex = 1000
    nome.Parent = container

    local dist = Instance.new("TextLabel")
    dist.Name = "Dist"
    dist.BackgroundTransparency = 1
    dist.TextColor3 = Color3.fromRGB(0, 255, 0)
    dist.Font = Enum.Font.Gotham
    dist.TextSize = 12
    dist.TextStrokeTransparency = 0
    dist.TextStrokeColor3 = Color3.new(0,0,0)
    dist.ZIndex = 1000
    dist.Parent = container

    espAtivos[player] = {
        container = container,
        linha = linha,
        box = box,
        nome = nome,
        dist = dist,
    }
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then criarESP(p) end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then criarESP(p) end
end)
Players.PlayerRemoving:Connect(function(p)
    local d = espAtivos[p]
    if d then
        d.container:Destroy()
        espAtivos[p] = nil
    end
end)

-- ==========================================
-- ATUALIZAR ESP (função por jogador)
-- ==========================================
local function atualizarESP(player, esp)
    local char = player.Character
    if not char then
        esp.container.Visible = false
        return
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")

    if not hum or not root or not head or hum.Health <= 0 then
        esp.container.Visible = false
        return
    end

    local inimigo = isInimigo(player)
    local cor = inimigo and CONFIG.CorInimigo or CONFIG.CorAliado
    esp.linha.BackgroundColor3 = cor
    esp.box.BorderColor3 = cor

    local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
    local rootPos = Camera:WorldToViewportPoint(root.Position)

    if not onScreen or headPos.Z <= 0 then
        esp.container.Visible = false
        return
    end

    esp.container.Visible = true

    -- Pauzinho (topo da tela até a cabeça)
    if CONFIG.MostrarLinhas then
        local comprimento = headPos.Y
        esp.linha.Size = UDim2.new(0, 2, 0, comprimento)
        esp.linha.Position = UDim2.new(0, headPos.X, 0, 0)
        esp.linha.Visible = true
    else
        esp.linha.Visible = false
    end

    -- Box
    if CONFIG.MostrarBox then
        local altura = math.abs(rootPos.Y - headPos.Y) * 2.4
        local largura = altura * 0.55
        esp.box.Size = UDim2.new(0, largura, 0, altura)
        esp.box.Position = UDim2.new(0, headPos.X - largura/2, 0, headPos.Y - altura/4)
        esp.box.Visible = true
    else
        esp.box.Visible = false
    end

    -- Nome
    if CONFIG.MostrarNome then
        esp.nome.Text = player.Name
        esp.nome.Size = UDim2.new(0, 200, 0, 16)
        esp.nome.Position = UDim2.new(0, headPos.X - 100, 0, headPos.Y - 34)
        esp.nome.Visible = true
    else
        esp.nome.Visible = false
    end

    -- Distância
    if CONFIG.MostrarDistancia then
        local d = math.floor((root.Position - Camera.CFrame.Position).Magnitude)
        esp.dist.Text = d .. "m"
        esp.dist.Size = UDim2.new(0, 100, 0, 14)
        esp.dist.Position = UDim2.new(0, headPos.X - 50, 0, headPos.Y + 4)
        esp.dist.Visible = true
    else
        esp.dist.Visible = false
    end
end

-- ==========================================
-- LISTA DE INIMIGOS (pro aimbot)
-- ==========================================
local function getInimigos()
    local lista = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if not isInimigo(p) then continue end
        local char = p.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if hum and root and hum.Health > 0 then
            table.insert(lista, {player=p, char=char, hum=hum, root=root, head=head})
        end
    end
    return lista
end

-- ==========================================
-- LOOP PRINCIPAL
-- ==========================================
RunService.RenderStepped:Connect(function()
    -- ===== ESP =====
    if CONFIG.ESP_Ativo then
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            local esp = espAtivos[p]
            if not esp then continue end

            if CONFIG.SoInimigoNoESP and not isInimigo(p) then
                esp.container.Visible = false
                continue
            end

            atualizarESP(p, esp)
        end
    else
        for _, esp in pairs(espAtivos) do
            esp.container.Visible = false
        end
    end

    -- ===== AIMBOT =====
    if CONFIG.Aimbot_Ativo then
        local viewport = Camera.ViewportSize
        local centro = Vector2.new(viewport.X/2, viewport.Y/2)
        local melhor, menorDist = nil, CONFIG.FOV

        for _, data in ipairs(getInimigos()) do
            local screenPos, onScreen = Camera:WorldToViewportPoint(data.head.Position)
            if onScreen and screenPos.Z > 0 then
                local d = (Vector2.new(screenPos.X, screenPos.Y) - centro).Magnitude
                if d < menorDist then
                    menorDist = d
                    melhor = data
                end
            end
        end

        if melhor then
            local aimCFrame = CFrame.new(Camera.CFrame.Position, melhor.head.Position)
            Camera.CFrame = Camera.CFrame:Lerp(aimCFrame, CONFIG.AimSuave)
        end
    end
end)

-- ==========================================
-- TECLAS
-- ==========================================
UserInputService.InputBegan:Connect(function(input, processado)
    if processado then return end

    if input.KeyCode == CONFIG.Tecla_ESP then
        CONFIG.ESP_Ativo = not CONFIG.ESP_Ativo
        btnESP.Text = "ESP: " .. (CONFIG.ESP_Ativo and "ON" or "OFF") .. "  [F]"
    elseif input.KeyCode == CONFIG.Tecla_Aimbot then
        CONFIG.Aimbot_Ativo = not CONFIG.Aimbot_Ativo
        btnAimbot.Text = "AIMBOT: " .. (CONFIG.Aimbot_Ativo and "ON" or "OFF") .. "  [E]"
        fovCircle.Visible = CONFIG.Aimbot_Ativo
    elseif input.KeyCode == CONFIG.Tecla_Menu then
        menu.Visible = not menu.Visible
    end
end)

print("✅ FRED MOD MENU carregado!")
print("👤 José abre/fecha | F = ESP | E = Aimbot | RightShift = menu")
