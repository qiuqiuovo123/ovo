-- ================= Delta 专用版本检查模块 =================

local current_version = "0.9" 
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
    -- 如果网络失败，为了不耽误你使用功能，这里建议不要强行退出
    warn("网络连接失败，跳过版本检查，直接加载功能...")
end

-- ================= 下面是你的 UI 和功能代码 =================
-- (保持你原本的那段 redzlib 代码不变即可)
local CoreGui = game:GetService("StarterGui")

CoreGui:SetCore("SendNotification", {
    Title = "通知",
    Text = "欢迎使用Z脚本",
    Duration = 6, 
    Icon = "rbxassetid://91831698502565" 
})

local redzlib = loadstring(game:HttpGet("https://pastebin.com/raw/UhLA1SWR"))()
local Window = redzlib:MakeWindow({
  Title = "Z脚本:整合",
  SubTitle = "测试",
  SaveFolder = "testando | redz lib v5.lua"
})

local Tab1 = Window:MakeTab({"公告", "cherry"})
local Tab2 = Window:MakeTab({"玩家功能", "apple"})
local Tab3 = Window:MakeTab({"被遗弃", "banana"})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://91831698502565", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

Tab1:AddDiscordInvite({
    Name = "ZY Hub",
    Description = "点击复制作者QQ",
    Logo = "rbxassetid://115544787599495",
    Invite = "2998873563",
})

Tab2:AddButton({
  Name = "爬墙",
  Callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/zXk4Rq2r"))()
  end
})

Tab2:AddButton({
  Name = "z飞行",
  Callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/2rxpWav7"))()
  end
})

Tab2:AddToggle({
	Name = "无限跳跳",
	Default = false,
	Callback = function(s)
		getgenv().InfJ = s
    game:GetService("UserInputService").JumpRequest:connect(function()
        if InfJ == true then
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
        end
    end)
	end
})

Tab2:AddToggle({
  Name = "夜视",
  Default = false,
  Callback = function(Value)
    if Value then
      game.Lighting.Ambient = Color3.new(1, 1, 1)
     else
      game.Lighting.Ambient = Color3.new(0, 0, 0)
    end
  end
})

Tab2:AddToggle({
  Name = "穿墙",
  Default = false,
  Callback = function(Value)
    if Value then
      Noclip = true
      Stepped = game.RunService.Stepped:Connect(function()
        if Noclip == true then
          for a, b in pairs(game.Workspace:GetChildren()) do
            if b.Name == game.Players.LocalPlayer.Name then
              for i, v in pairs(game.Workspace[game.Players.LocalPlayer.Name]:GetChildren()) do
                if v:IsA("BasePart") then
                  v.CanCollide = false
                end
              end
            end
          end
         else
          Stepped:Disconnect()
        end
      end)
     else
      Noclip = false
    end
  end
})

Tab3:AddButton({
  Name = "被遗弃(外国搬运)",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/sigmaboy-sigma-boy/Stamina-Settings-and-ESP/refs/heads/main/SigmasakenLoader"))()
  end
})

Tab3:AddButton({
	Name = "复制卡密",
	Callback = function()
     setclipboard("BETTERPROTECTNAMESANDESP")
  	end
})
