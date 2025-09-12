-- InfernoxMain.lua
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Infernox Hub",
    LoadingTitle = "Infernox",
    LoadingSubtitle = "Main UI",
    Theme = "Amethyst",
    ConfigurationSaving = { Enabled = false }
})
local Tab = Window:CreateTab("Scripts", "⚡")
Tab:CreateLabel("Welcome to Infernox Hub!")
