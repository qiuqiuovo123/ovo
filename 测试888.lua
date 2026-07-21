-- ================= Delta 专用版本检查模块 =================

local current_version = "1.0" 
local url = "https://mass-gopo.upma.site" -- 确保这个链接返回纯文本版本号

-- 【Delta 专用网络请求】
-- Roblox 环境下必须使用 game:HttpGet
local function httpGetRoblox(link)
    local success, result = pcall(function()
        return game:HttpGet(link)
    end)
    
    if success then
        return result
    else
        return nil
    end
end

-- 【通用版本对比函数】(保持不变)
local function isVersionNewer(localVer, cloudVer)
    localVer = tostring(localVer):gsub("[^%d%.]", "")
    cloudVer = tostring(cloudVer):gsub("[^%d%.]", "")
    
    local l_parts = {}
    for v in string.gmatch(localVer, "%d+") do table.insert(l_parts, tonumber(v)) end
    
    local c_parts = {}
    for v in string.gmatch(cloudVer, "%d+") do table.insert(c_parts, tonumber(v)) end
    
    local max_len = math.max(#l_parts, #c_parts)
    for i = 1, max_len do
        local l_val = l_parts[i] or 0
        local c_val = c_parts[i] or 0
        
        if c_val > l_val then return true end
        if c_val < l_val then return false end
    end
    return false
end

-- ================= 执行检查 =================
print("正在连接服务器检查版本...")
local raw_content = httpGetRoblox(url)

if raw_content then
    local clean_cloud_ver = raw_content:gsub("<[^>]+>", ""):gsub("%s+", "")
    print("云端返回内容: " .. clean_cloud_ver)
    
    if isVersionNewer(current_version, clean_cloud_ver) then
        -- Delta 环境下的弹窗通知
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "版本更新",
            Text = "发现新版本: " .. clean_cloud_ver .. "\n请前往下载最新版。",
            Duration = 10
        })
        -- 注意：Roblox 脚本很难强制退出，通常只能停止后续代码执行
        return 
    else
        print("已是最新版本 (" .. current_version .. ")")
    end
else
    -- 网络连接失败，弹出警告并强行退出脚本
    warn("网络连接失败，无法验证版本，脚本已停止运行。")
    return 
end

-- ================= 下面是你的 UI 和功能代码 =================
-- // 初始化服务
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- // 清理旧 UI
if Player:FindFirstChild("PlayerGui") then
    local existing = Player.PlayerGui:FindFirstChild("Qiuqiu")
    if existing then
        existing:Destroy()
    end
end

-- // 辅助函数
local function Create(Parent, Type, Props)
    local Obj = Instance.new(Type, Parent)
    for K, V in pairs(Props or {}) do
        pcall(function()
            Obj[K] = V
        end)
    end
    return Obj
end

-- // 1. 主容器
local ScreenGui = Create(Player.PlayerGui, "ScreenGui", {
    Name = "Qiuqiu",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

-- // 2. 主窗口框架
local MainFrame = Create(ScreenGui, "Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 650, 0, 420),
    Position = UDim2.new(0.5, -325, 0.5, -210),
    BackgroundColor3 = Color3.fromRGB(10, 10, 15),
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    ClipsDescendants = true,
})

Create(MainFrame, "UICorner", { CornerRadius = UDim.new(0, 16) })

-- ✨ 主边框炫彩流光描边
local RainbowStroke = Create(MainFrame, "UIStroke", {
    Thickness = 3,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    LineJoinMode = Enum.LineJoinMode.Round,
    Transparency = 0,
})

local MainGradient = Create(RainbowStroke, "UIGradient", {
    Rotation = 45,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 150, 80)),
        ColorSequenceKeypoint.new(0.40, Color3.fromRGB(255, 220, 80)),
        ColorSequenceKeypoint.new(0.60, Color3.fromRGB(80, 255, 120)),
        ColorSequenceKeypoint.new(0.80, Color3.fromRGB(80, 180, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(220, 80, 255)),
    }),
})

-- ✨ 内层发光边框
local GlowStroke = Create(MainFrame, "UIStroke", {
    Thickness = 1.5,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    LineJoinMode = Enum.LineJoinMode.Round,
    Transparency = 0.3,
})

local GlowGradient = Create(GlowStroke, "UIGradient", {
    Rotation = -45,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 100, 200)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(100, 200, 255)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(200, 255, 100)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 100, 200)),
    }),
})

-- ✨ 背景流光粒子效果
local ParticleContainer = Create(MainFrame, "Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 0,
})

-- 创建多个流动光点
local particles = {}
for i = 1, 8 do
    local particle = Create(ParticleContainer, "Frame", {
        Size = UDim2.new(0, math.random(4, 8), 0, math.random(4, 8)),
        Position = UDim2.new(0, math.random(0, 650), 0, math.random(0, 420)),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 0,
    })
    Create(particle, "UICorner", { CornerRadius = UDim.new(1, 0) })

    local particleGradient = Create(particle, "UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 255, 255)),
        }),
    })

    table.insert(particles, {
        obj = particle,
        gradient = particleGradient,
        speed = math.random(50, 150),
        offset = math.random() * 2 * math.pi,
    })
end

-- ✨ 主循环：更新所有流光特效
RunService.RenderStepped:Connect(function(dt)
    local time = tick()

    MainGradient.Offset = Vector2.new((time % 3) / 3, (time % 2) / 2)

    GlowGradient.Offset = Vector2.new((time % 4) / 4, (time % 3) / 3)

    for _, p in ipairs(particles) do
        local x = (math.sin(time * p.speed * 0.01 + p.offset) + 1) / 2
        local y = (math.cos(time * p.speed * 0.01 + p.offset + 1) + 1) / 2
        p.obj.Position = UDim2.new(0, x * 650, 0, y * 420)
        p.obj.BackgroundTransparency = 0.3 + math.sin(time * 2 + p.offset) * 0.2
        p.gradient.Rotation = time * 50 % 360
    end
end)

-- // 3. 顶部标题栏 (Header)
local Header = Create(MainFrame, "Frame", {
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundColor3 = Color3.fromRGB(20, 20, 25),
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
})
Create(Header, "UICorner", { CornerRadius = UDim.new(0, 16) })

-- ✨ 标题文字容器
local TitleContainer = Create(Header, "Frame", {
    Size = UDim2.new(0, 250, 1, 0),
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 20, 0, 0),
    ClipsDescendants = true,
})

local TitleText = Create(TitleContainer, "TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "Qiuqiu | Neon Glass",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local TitleGradient = Create(TitleText, "UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 80, 200)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(80, 200, 255)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(80, 255, 150)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 255, 80)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 80, 200)),
    }),
})

local TitleGlow = Create(TitleText, "UIStroke", {
    Thickness = 1,
    Transparency = 0.3,
    Color = Color3.fromRGB(255, 255, 255),
})

task.spawn(function()
    while true do
        task.wait(0.05)
        TitleGradient.Offset = Vector2.new((tick() % 3) / 3, 0)
        TitleGlow.Color = Color3.fromRGB(
            180 + math.sin(tick() * 2) * 75,
            180 + math.sin(tick() * 2.5) * 75,
            180 + math.sin(tick() * 3) * 75
        )
    end
end)

local TimeLabel = Create(Header, "TextLabel", {
    Size = UDim2.new(0, 150, 1, 0),
    BackgroundTransparency = 1,
    Text = "Loading...",
    TextColor3 = Color3.fromRGB(220, 220, 220),
    Font = Enum.Font.GothamMedium,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Right,
    Position = UDim2.new(1, -100, 0, 0),
})

local TimeGradient = Create(TimeLabel, "UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 255)),
    }),
})

task.spawn(function()
    while true do
        task.wait(1)
        TimeLabel.Text = os.date("%H:%M:%S")
        TimeGradient.Offset = Vector2.new((tick() % 2) / 2, (tick() % 3) / 3)
    end
end)

-- 按钮样式
local MinBtn = Create(Header, "TextButton", {
    Size = UDim2.new(0, 35, 0, 35),
    Position = UDim2.new(1, -80, 0.5, -17.5),
    BackgroundColor3 = Color3.fromRGB(60, 60, 65),
    BackgroundTransparency = 0.1,
    Text = "-",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 24,
})
Create(MinBtn, "UICorner", { CornerRadius = UDim.new(0, 8) })

local MinBtnGradient = Create(MinBtn, "UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 200)),
    }),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.6),
        NumberSequenceKeypoint.new(1, 0.6),
    }),
})

MinBtn.MouseEnter:Connect(function()
    TweenService:Create(MinBtnGradient, TweenInfo.new(0.3), {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 0),
        }),
    }):Play()
    TweenService:Create(MinBtn, TweenInfo.new(0.3), {
        BackgroundColor3 = Color3.fromRGB(255, 150, 100),
    }):Play()
end)

MinBtn.MouseLeave:Connect(function()
    TweenService:Create(MinBtnGradient, TweenInfo.new(0.3), {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6),
            NumberSequenceKeypoint.new(1, 0.6),
        }),
    }):Play()
    TweenService:Create(MinBtn, TweenInfo.new(0.3), {
        BackgroundColor3 = Color3.fromRGB(60, 60, 65),
    }):Play()
end)

local CloseBtn = Create(Header, "TextButton", {
    Size = UDim2.new(0, 35, 0, 35),
    Position = UDim2.new(1, -40, 0.5, -17.5),
    BackgroundColor3 = Color3.fromRGB(220, 60, 60),
    BackgroundTransparency = 0.05,
    Text = "×",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 24,
})
Create(CloseBtn, "UICorner", { CornerRadius = UDim.new(0, 8) })

local CloseGlow = Create(CloseBtn, "UIStroke", {
    Thickness = 0,
    Color = Color3.fromRGB(255, 100, 100),
    Transparency = 1,
})

task.spawn(function()
    while true do
        for i = 0, 1, 0.05 do
            CloseGlow.Thickness = 2 * i
            CloseGlow.Transparency = 1 - i
            task.wait(0.02)
        end
        for i = 1, 0, -0.05 do
            CloseGlow.Thickness = 2 * i
            CloseGlow.Transparency = 1 - i
            task.wait(0.02)
        end
    end
end)

-- // 4. 内容区域布局
local ContentArea = Create(MainFrame, "Frame", {
    Size = UDim2.new(1, 0, 1, -45),
    Position = UDim2.new(0, 0, 0, 45),
    BackgroundTransparency = 1,
})

-- 左侧导航栏 (Sidebar)
local Sidebar = Create(ContentArea, "Frame", {
    Size = UDim2.new(0, 140, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(15, 15, 20),
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    ZIndex = 5,
})

local SidebarLine = Create(Sidebar, "Frame", {
    Size = UDim2.new(0, 2, 1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0,
    ZIndex = 6,
})

local SidebarLineGradient = Create(SidebarLine, "UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 100)),
    }),
})

task.spawn(function()
    while true do
        task.wait(0.05)
        SidebarLineGradient.Offset = Vector2.new(0, (tick() % 2) / 2)
    end
end)

local SidebarList = Create(Sidebar, "Frame", {
    Size = UDim2.new(1, 0, 1, -15),
    Position = UDim2.new(0, 0, 0, 15),
    BackgroundTransparency = 1,
    ZIndex = 5,
})

Create(SidebarList, "UIListLayout", {
    Padding = UDim.new(0, 12),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder,
})

local PagesContainer = Create(ContentArea, "Frame", {
    Size = UDim2.new(1, -140, 1, 0),
    Position = UDim2.new(0, 140, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 4,
})

-- ============================================
-- 通用功能函数
-- ============================================

local Noclip = false
local Stepped = nil
local Speed = 1
local sudu = nil
local InfJ = false
local JumpPowerValue = 50

-- 创建开关组件
local function CreateToggle(Parent, Title, Desc, Default, Callback)
    local ToggleFrame = Create(Parent, "Frame", {
        Size = UDim2.new(0.95, 0, 0, 55),
        BackgroundColor3 = Color3.fromRGB(30, 30, 38),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 6,
    })
    Create(ToggleFrame, "UICorner", { CornerRadius = UDim.new(0, 10) })

    Create(ToggleFrame, "TextLabel", {
        Size = UDim2.new(0, 150, 0, 25),
        Position = UDim2.new(0, 15, 0, 5),
        BackgroundTransparency = 1,
        Text = Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
    })

    Create(ToggleFrame, "TextLabel", {
        Size = UDim2.new(0, 280, 0, 20),
        Position = UDim2.new(0, 15, 0, 30),
        BackgroundTransparency = 1,
        Text = Desc or "",
        TextColor3 = Color3.fromRGB(160, 160, 170),
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
    })

    local ToggleBtn = Create(ToggleFrame, "TextButton", {
        Size = UDim2.new(0, 45, 0, 25),
        Position = UDim2.new(1, -60, 0.5, -12.5),
        BackgroundColor3 = Default and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 70),
        Text = "",
        BorderSizePixel = 0,
        ZIndex = 7,
        AutoButtonColor = false,
    })
    Create(ToggleBtn, "UICorner", { CornerRadius = UDim.new(1, 0) })

    local ToggleDot = Create(ToggleBtn, "Frame", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = Default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 8,
    })
    Create(ToggleDot, "UICorner", { CornerRadius = UDim.new(1, 0) })

    local IsEnabled = Default

    ToggleBtn.MouseButton1Click:Connect(function()
        IsEnabled = not IsEnabled
        if IsEnabled then
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(80, 200, 120),
            }):Play()
            TweenService:Create(ToggleDot, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -22, 0.5, -10),
            }):Play()
        else
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 70),
            }):Play()
            TweenService:Create(ToggleDot, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -10),
            }):Play()
        end
        Callback(IsEnabled)
    end)

    return ToggleFrame
end

-- 创建按钮组件
local function CreateButton(Parent, Title, Callback)
    local BtnFrame = Create(Parent, "TextButton", {
        Size = UDim2.new(0.95, 0, 0, 45),
        BackgroundColor3 = Color3.fromRGB(30, 30, 38),
        BackgroundTransparency = 0.3,
        Text = "",
        BorderSizePixel = 0,
        ZIndex = 6,
        AutoButtonColor = false,
    })
    Create(BtnFrame, "UICorner", { CornerRadius = UDim.new(0, 10) })

    Create(BtnFrame, "TextLabel", {
        Size = UDim2.new(0, 280, 0, 25),
        Position = UDim2.new(0, 15, 0.5, -12.5),
        BackgroundTransparency = 1,
        Text = Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
    })

    local BtnGradient = Create(BtnFrame, "UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 255)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6),
            NumberSequenceKeypoint.new(1, 0.6),
        }),
        Rotation = 90,
    })

    BtnFrame.MouseEnter:Connect(function()
        TweenService:Create(BtnGradient, TweenInfo.new(0.3), {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 0),
            }),
        }):Play()
        TweenService:Create(BtnFrame, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 80),
        }):Play()
    end)

    BtnFrame.MouseLeave:Connect(function()
        TweenService:Create(BtnGradient, TweenInfo.new(0.3), {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.6),
                NumberSequenceKeypoint.new(1, 0.6),
            }),
        }):Play()
        TweenService:Create(BtnFrame, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 38),
        }):Play()
    end)

    BtnFrame.MouseButton1Click:Connect(function()
        Callback()
    end)

    return BtnFrame
end

-- ============================================
-- 构建页面与导航逻辑
-- ============================================
local Pages = {}
local NavButtons = {}
local MenuItems = { "公告", "通用" }

for i, name in ipairs(MenuItems) do
    local Page = Create(PagesContainer, "Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = (i == 1),
        ZIndex = 4,
    })

    local PageTitle = Create(Page, "TextLabel", {
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = name .. " 功能面板",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        ZIndex = 5,
    })

    Create(PageTitle, "UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 255)),
        }),
    })

    -- ✨ 公告页面
    if name == "公告" then
        local AnnouncementFrame = Create(Page, "Frame", {
            Size = UDim2.new(0.9, 0, 0.7, 0),
            Position = UDim2.new(0.05, 0, 0, 90),
            BackgroundColor3 = Color3.fromRGB(25, 25, 35),
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            ZIndex = 5,
        })
        Create(AnnouncementFrame, "UICorner", { CornerRadius = UDim.new(0, 12) })

        local QQGroupLabel = Create(AnnouncementFrame, "TextLabel", {
            Size = UDim2.new(0.9, 0, 0, 40),
            Position = UDim2.new(0.05, 0, 0, 30),
            BackgroundTransparency = 1,
            Text = "QQ群: 485082349",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 22,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6,
        })

        local QQGroupGradient = Create(QQGroupLabel, "UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 180, 100)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 220, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 255)),
            }),
        })

        task.spawn(function()
            while true do
                task.wait(0.05)
                if QQGroupGradient and QQGroupGradient.Parent then
                    QQGroupGradient.Offset = Vector2.new((tick() % 3) / 3, 0)
                end
            end
        end)

        Create(AnnouncementFrame, "Frame", {
            Size = UDim2.new(0.9, 0, 0, 1),
            Position = UDim2.new(0.05, 0, 0, 80),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            ZIndex = 6,
        })

        local AuthorLabel = Create(AnnouncementFrame, "TextLabel", {
            Size = UDim2.new(0.9, 0, 0, 40),
            Position = UDim2.new(0.05, 0, 0, 95),
            BackgroundTransparency = 1,
            Text = "作者: 秋秋",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 22,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6,
        })

        local AuthorGradient = Create(AuthorLabel, "UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 255, 180)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 100)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 255)),
            }),
        })

        task.spawn(function()
            while true do
                task.wait(0.05)
                if AuthorGradient and AuthorGradient.Parent then
                    AuthorGradient.Offset = Vector2.new((tick() % 3) / 3, 0)
                end
            end
        end)

        local WelcomeLabel = Create(AnnouncementFrame, "TextLabel", {
            Size = UDim2.new(0.9, 0, 0, 30),
            Position = UDim2.new(0.05, 0, 1, -50),
            BackgroundTransparency = 1,
            Text = "✨ 欢迎使用 Qiuqiu脚本 ✨",
            TextColor3 = Color3.fromRGB(200, 200, 220),
            Font = Enum.Font.GothamMedium,
            TextSize = 16,
            ZIndex = 6,
        })

        local WelcomeGradient = Create(WelcomeLabel, "UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 200)),
            }),
        })

        task.spawn(function()
            while true do
                task.wait(0.05)
                if WelcomeGradient and WelcomeGradient.Parent then
                    WelcomeGradient.Offset = Vector2.new((tick() % 4) / 4, 0)
                end
            end
        end)
    end

    -- ✨ 通用页面
    if name == "通用" then
        local ScrollFrame = Create(Page, "ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, -70),
            Position = UDim2.new(0, 0, 0, 70),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120),
            ZIndex = 5,
            CanvasSize = UDim2.new(0, 0, 0, 1500),
        })

        local FunctionList = Create(ScrollFrame, "Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ZIndex = 5,
        })

        Create(FunctionList, "UIListLayout", {
            Padding = UDim.new(0, 10),
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        -- ====================
        -- 穿墙
        -- ====================
        CreateToggle(FunctionList, "穿墙", "开启/关闭穿墙模式", false, function(state)
            if state then
                Noclip = true
                Stepped = RunService.Stepped:Connect(function()
                    if Noclip then
                        for _, b in pairs(game.Workspace:GetChildren()) do
                            if b.Name == Player.Name then
                                for _, v in pairs(game.Workspace[Player.Name]:GetChildren()) do
                                    if v:IsA("BasePart") then
                                        v.CanCollide = false
                                    end
                                end
                            end
                        end
                    else
                        if Stepped then
                            Stepped:Disconnect()
                            Stepped = nil
                        end
                    end
                end)
            else
                Noclip = false
                if Stepped then
                    Stepped:Disconnect()
                    Stepped = nil
                end
            end
        end)

        -- ====================
        -- 夜视
        -- ====================
        CreateToggle(FunctionList, "夜视", "开启/关闭夜视效果", false, function(state)
            if state then
                game.Lighting.Ambient = Color3.new(1, 1, 1)
            else
                game.Lighting.Ambient = Color3.new(0, 0, 0)
            end
        end)

        -- ====================
        -- 开启快速跑步
        -- ====================
        CreateToggle(FunctionList, "开启快速跑步", "开启/关闭快速跑步", false, function(enabled)
            if enabled then
                sudu = RunService.Heartbeat:Connect(function()
                    local player = Players.LocalPlayer
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        local humanoid = player.Character.Humanoid
                        if humanoid.MoveDirection.Magnitude > 0 then
                            player.Character:TranslateBy(humanoid.MoveDirection * Speed * 0.5)
                        end
                    end
                end)
            else
                if sudu then
                    sudu:Disconnect()
                    sudu = nil
                end
            end
        end)

        -- ====================
        -- 无限跳
        -- ====================
        CreateToggle(FunctionList, "无限跳", "开启/关闭无限跳", false, function(Value)
            InfJ = Value
            if Value then
                UserInputService.JumpRequest:Connect(function()
                    if InfJ and Player.Character then
                        local humanoid = Player.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid:ChangeState("Jumping")
                        end
                    end
                end)
            end
        end)

        -- ====================
        -- 自瞄脚本
        -- ====================
        CreateButton(FunctionList, "自瞄脚本", function()
            loadstring(game:HttpGet("https://atlasteam.live/silentaim"))()
        end)

        -- ====================
        -- 子弹追踪
        -- ====================
        CreateButton(FunctionList, "通用子追", function()
            loadstring(game:HttpGet("https://pastefy.app/QuCIYgQY/raw"))()
        end)

        -- ====================
        -- 甩飞所有人
        -- ====================
        CreateButton(FunctionList, "甩飞所有人", function()
            loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
        end)

        -- ====================
        -- 甩飞
        -- ====================
        CreateButton(FunctionList, "甩飞", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/hknvh/main/%E7%94%A9%E9%A3%9E.txt"))()
        end)

        -- ====================
        -- 玩家加入游戏提示
        -- ====================
        CreateButton(FunctionList, "玩家加入游戏提示", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))()
        end)

        -- ====================
        -- 获得管理员权限
        -- ====================
        CreateButton(FunctionList, "获得管理员权限", function()
            loadstring(game:HttpGet("https://pastebin.com/raw/sZpgTVas"))()
        end)

        -- ====================
        -- 死亡笔记
        -- ====================
        CreateButton(FunctionList, "死亡笔记", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/tt/main/%E6%AD%BB%E4%BA%A1%E7%AC%94%E8%AE%B0%20(1).txt"))()
        end)

        -- ====================
        -- 飞行
        -- ====================
        CreateButton(FunctionList, "Qiuqiu飞行", function()
            loadstring(game:HttpGet("https://pastefy.app/KQS5TrQA/raw"))()
        end)

        -- ====================
        -- 透视
        -- ====================
        CreateButton(FunctionList, "透视", function()
            _G.FriendColor = Color3.fromRGB(0, 0, 255)
            local function ApplyESP(v)
                if v.Character and v.Character:FindFirstChildOfClass("Humanoid") then
                    v.Character.Humanoid.NameDisplayDistance = 9e9
                    v.Character.Humanoid.NameOcclusion = "NoOcclusion"
                    v.Character.Humanoid.HealthDisplayDistance = 9e9
                    v.Character.Humanoid.HealthDisplayType = "AlwaysOn"
                    v.Character.Humanoid.Health = v.Character.Humanoid.Health
                end
            end

            for _, v in pairs(Players:GetPlayers()) do
                ApplyESP(v)
                v.CharacterAdded:Connect(function()
                    task.wait(0.33)
                    ApplyESP(v)
                end)
            end

            Players.PlayerAdded:Connect(function(v)
                ApplyESP(v)
                v.CharacterAdded:Connect(function()
                    task.wait(0.33)
                    ApplyESP(v)
                end)
            end)

            local highlight = Instance.new("Highlight")
            highlight.Name = "Highlight"

            for _, v in pairs(Players:GetPlayers()) do
                repeat task.wait() until v.Character
                if not v.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Highlight") then
                    local highlightClone = highlight:Clone()
                    highlightClone.Adornee = v.Character
                    highlightClone.Parent = v.Character:FindFirstChild("HumanoidRootPart")
                    highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlightClone.Name = "Highlight"
                end
            end

            Players.PlayerAdded:Connect(function(player)
                repeat task.wait() until player.Character
                if not player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Highlight") then
                    local highlightClone = highlight:Clone()
                    highlightClone.Adornee = player.Character
                    highlightClone.Parent = player.Character:FindFirstChild("HumanoidRootPart")
                    highlightClone.Name = "Highlight"
                end
            end)

            Players.PlayerRemoving:Connect(function(playerRemoved)
                if playerRemoved.Character and playerRemoved.Character:FindFirstChild("HumanoidRootPart") then
                    local hl = playerRemoved.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Highlight")
                    if hl then
                        hl:Destroy()
                    end
                end
            end)

            RunService.Heartbeat:Connect(function()
                for _, v in pairs(Players:GetPlayers()) do
                    repeat task.wait() until v.Character
                    if not v.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Highlight") then
                        local highlightClone = highlight:Clone()
                        highlightClone.Adornee = v.Character
                        highlightClone.Parent = v.Character:FindFirstChild("HumanoidRootPart")
                        highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlightClone.Name = "Highlight"
                        task.wait()
                    end
                end
            end)
        end)
    end

    Pages[name] = Page

    -- 创建导航按钮
    local Btn = Create(SidebarList, "TextButton", {
        Name = "NavBtn_" .. name,
        Size = UDim2.new(0.85, 0, 0, 45),
        BackgroundColor3 = if i == 1 then Color3.fromRGB(80, 80, 100) else Color3.fromRGB(45, 45, 55),
        BackgroundTransparency = if i == 1 then 0.05 else 0.15,
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        ZIndex = 10,
        AutoButtonColor = false,
    })
    Create(Btn, "UICorner", { CornerRadius = UDim.new(0, 10) })

    local BtnGradient = Create(Btn, "UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 255)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, if i == 1 then 0.2 else 0.5),
            NumberSequenceKeypoint.new(1, if i == 1 then 0.2 else 0.5),
        }),
        Rotation = 90,
    })

    Btn.MouseEnter:Connect(function()
        if Pages[name].Visible then return end
        TweenService:Create(BtnGradient, TweenInfo.new(0.3), {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.05),
                NumberSequenceKeypoint.new(1, 0.05),
            }),
        }):Play()
        TweenService:Create(Btn, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(100, 100, 120),
            BackgroundTransparency = 0.1,
        }):Play()
    end)

    Btn.MouseLeave:Connect(function()
        if Pages[name].Visible then return end
        TweenService:Create(BtnGradient, TweenInfo.new(0.3), {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.5),
                NumberSequenceKeypoint.new(1, 0.5),
            }),
        }):Play()
        TweenService:Create(Btn, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 55),
            BackgroundTransparency = 0.15,
        }):Play()
    end)

    task.spawn(function()
        while true do
            task.wait(0.05)
            if Btn and Btn.Parent then
                BtnGradient.Rotation = (BtnGradient.Rotation + 1) % 360
            end
        end
    end)

    NavButtons[name] = Btn

    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do
            if p.Visible then
                TweenService:Create(p, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 50, 0, 0),
                    BackgroundTransparency = 1,
                }):Play()
                task.wait(0.15)
                p.Visible = false
                p.Position = UDim2.new(0, 0, 0, 0)
            end
        end

        for _, b in pairs(NavButtons) do
            b.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            b.BackgroundTransparency = 0.15
            local grad = b:FindFirstChildOfClass("UIGradient")
            if grad then
                grad.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.5),
                    NumberSequenceKeypoint.new(1, 0.5),
                })
            end
        end

        Pages[name].Visible = true
        TweenService:Create(Pages[name], TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
        }):Play()

        Btn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        Btn.BackgroundTransparency = 0.05
        local selectedGrad = Btn:FindFirstChildOfClass("UIGradient")
        if selectedGrad then
            selectedGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                NumberSequenceKeypoint.new(1, 0.2),
            })
        end
    end)
end

-- // 6. 拖拽逻辑
local Dragging = false
local DragStart, StartPos

local function UpdateDrag(Input)
    local Delta = Input.Position - DragStart
    MainFrame.Position = UDim2.new(
        StartPos.X.Scale,
        StartPos.X.Offset + Delta.X,
        StartPos.Y.Scale,
        StartPos.Y.Offset + Delta.Y
    )
end

Header.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPos = MainFrame.Position
    end
end)

Header.InputChanged:Connect(function(Input)
    if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        UpdateDrag(Input)
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

-- // 7. 最小化与关闭逻辑
local IsMinimized = false
local OriginalSize = MainFrame.Size

MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        MainFrame:TweenSize(UDim2.new(OriginalSize.X.Scale, OriginalSize.X.Offset, 0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        ContentArea.Visible = false
    else
        MainFrame:TweenSize(OriginalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        ContentArea.Visible = true
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }):Play()

    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
    }):Play()

    task.wait(0.3)
    ScreenGui:Destroy()
end)

print("✅ Qiuqiu UI Loaded Successfully!")