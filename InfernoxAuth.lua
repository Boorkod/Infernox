-- InfernoxAuth.lua
-- Redeem bind HWID + Verify -> ถ้า HWID ไม่ตรง คัดลอก HWID แจ้งรีเซ็ท แล้ว Kick
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Analytics = game:GetService("RbxAnalyticsService")
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local API_BASE = "https://infernox.wuaze.com/api" -- เปลี่ยนเป็นโดเมนจริง
local DISCORD_INVITE = "discord.gg/infernox"     -- เปลี่ยนเป็นลิงก์จริง

-- ดึง HWID (GetClientId เป็นหลัก, fallback เป็น UserId)
local function getHWID()
    local ok, id = pcall(function() return Analytics:GetClientId() end)
    if ok and id and id ~= "" then return tostring(id) end
    return "RBX-" .. tostring(LocalPlayer.UserId)
end

-- ช่วย POST JSON แล้ว decode (fallback เป็น GET)
local function api_call(path, payload)
    local url = API_BASE .. "/" .. path
    -- try POST
    local ok, res = pcall(function()
        return HttpService:PostAsync(url, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson, false)
    end)
    if ok and res then
        local dec; pcall(function() dec = HttpService:JSONDecode(res) end)
        return dec or { raw = res }
    end
    -- fallback GET
    local qs = "?"
    for k,v in pairs(payload) do
        qs = qs .. HttpService:UrlEncode(tostring(k)) .. "=" .. HttpService:UrlEncode(tostring(v)) .. "&"
    end
    local ok2, res2 = pcall(function() return game:HttpGet(url .. qs) end)
    if ok2 then
        local dec2; pcall(function() dec2 = HttpService:JSONDecode(res2) end)
        return dec2 or { raw = res2 }
    end
    return nil
end

-- ตรวจ success (รองรับ status/msg หรือ success)
local function is_ok(t)
    if not t then return false end
    if t.status and tostring(t.status):lower():find("success") then return true end
    if t.success == true then return true end
    return false
end

-- คัดลอก HWID (ถ้ามี API ใน executor)
local function copyHWID(h)
    pcall(function()
        if setclipboard then setclipboard(h) end
        if set_clipboard then set_clipboard(h) end
        if syn and syn.set_clipboard then syn.set_clipboard(h) end
    end)
end

-- Redeem (bind hwid)
local function redeemKey(key)
    local payload = { key = tostring(key), hwid = getHWID(), userid = LocalPlayer.UserId, username = LocalPlayer.Name }
    local res = api_call("redeem.php", payload)
    if is_ok(res) then return true, res.msg or "Redeem success" end
    return false, res and (res.msg or res.message or tostring(res)) or "Redeem failed"
end

-- Verify (check key+hwid)
local function verifyKey(key)
    local payload = { key = tostring(key), hwid = getHWID() }
    local res = api_call("verify.php", payload)
    if is_ok(res) then return true, res.msg or "Verified" end
    return false, res and (res.msg or res.message or tostring(res)) or "Verify failed"
end

-- UI (Rayfield)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Infernox | Auth",
    LoadingTitle = "Infernox",
    LoadingSubtitle = "Authentication",
    Theme = "Ocean",
    ConfigurationSaving = { Enabled = false }
})
local Tab = Window:CreateTab("Auth", 4483362458)

local KeyInput = Tab:CreateInput({
    Name = "Key",
    PlaceholderText = "วางคีย์ที่ได้รับ",
    RemoveTextAfterFocusLost = false,
    Callback = function() end
})

Tab:CreateButton({
    Name = "Redeem & Bind HWID",
    Callback = function()
        local key = (KeyInput.Get and KeyInput:Get()) or KeyInput.CurrentValue or ""
        if key == "" then
            Rayfield:Notify({Title="Redeem", Content="กรุณาใส่คีย์", Duration=3})
            return
        end
        local ok, msg = redeemKey(key)
        if ok then
            Rayfield:Notify({Title="Redeem", Content=tostring(msg), Duration=3})
        else
            Rayfield:Notify({Title="Redeem Failed", Content=tostring(msg), Duration=4})
        end
    end
})

Tab:CreateButton({
    Name = "Verify & Launch",
    Callback = function()
        local key = (KeyInput.Get and KeyInput:Get()) or KeyInput.CurrentValue or ""
        if key == "" then
            Rayfield:Notify({Title="Verify", Content="กรุณาใส่คีย์", Duration=3})
            return
        end
        local ok, msg = verifyKey(key)
        if ok then
            Rayfield:Notify({Title="Access", Content="ยินดีต้อนรับ!", Duration=3})
            -- โหลด main script (ปรับ raw link ของคุณ)
            local okL, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/<username>/Infernox/main/InfernoxMain.lua"))()
            end)
            if not okL then warn("Load main failed:", err) end
        else
            -- HWID mismatch หรืออื่น ๆ -> copy HWID + แจ้งวิธีรีเซ็ต + kick
            local hw = getHWID()
            copyHWID(hw)
            Rayfield:Notify({
                Title = "Access Denied",
                Content = tostring(msg) .. " | รีเซ็ต HWID ที่ Discord: " .. DISCORD_INVITE,
                Duration = 6
            })
            Rayfield:Notify({Title="HWID", Content="Copied HWID: "..hw, Duration=4})
            task.wait(2)
            pcall(function() LocalPlayer:Kick("HWID mismatch — รีเซ็ตที่ Discord: "..DISCORD_INVITE.." | HWID: "..hw) end)
        end
    end
})

Tab:CreateButton({
    Name = "Request HWID Reset (1/day)",
    Callback = function()
        local key = (KeyInput.Get and KeyInput:Get()) or KeyInput.CurrentValue or ""
        if key == "" then
            Rayfield:Notify({Title="Reset", Content="กรุณาใส่คีย์", Duration=3})
            return
        end
        local payload = { key = key, hwid = getHWID() }
        local res = api_call("reset.php", payload)
        if is_ok(res) then
            Rayfield:Notify({Title="Reset", Content=res.msg or "Reset OK", Duration=4})
        else
            Rayfield:Notify({Title="Reset Failed", Content=(res and (res.msg or res.message)) or "Reset failed", Duration=5})
        end
    end
})

Tab:CreateButton({
    Name = "Copy HWID",
    Callback = function()
        local hw = getHWID()
        copyHWID(hw)
        Rayfield:Notify({Title="HWID", Content="Copied: "..hw, Duration=3})
    end
})
