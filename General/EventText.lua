local frame = CreateFrame("Frame", "EventTexturesFrame", UIParent)

local readyTime = 0
local loadDelay = 2

local textures = {
    ["PLAYER_LEVEL_UP"] = "Interface\\AddOns\\FFXIV_UI\\Media\\Textures\\FFLevelUp.tga",
    ["QUEST_ACCEPTED"] = "Interface\\AddOns\\FFXIV_UI\\Media\\Textures\\FFQuestAccept.tga",
    ["QUEST_TURNED_IN"] = "Interface\\AddOns\\FFXIV_UI\\Media\\Textures\\FFQuestComplete.tga",
}

local tex = frame:CreateTexture(nil, "OVERLAY")
tex:SetPoint("CENTER", UIParent, "CENTER", 0, 250)
tex:SetSize(1200, 1200)
tex:SetAlpha(0)
tex:Hide()

local fadeInTime = 0.15
local holdTime = 2
local fadeOutTime = 0.25
local startScale = 1
local endScale = 0.9

local animFrame = CreateFrame("Frame", nil, UIParent)
animFrame:Hide()

animFrame:SetScript("OnUpdate", function(self)
    if not self.startTime then return end

    local t = GetTime() - self.startTime

    if t < fadeInTime then
        local p = t / fadeInTime
        tex:SetAlpha(p)
        tex:SetScale(startScale - (startScale - endScale) * p)

    elseif t < fadeInTime + holdTime then
        tex:SetAlpha(1)
        tex:SetScale(endScale)

    elseif t < fadeInTime + holdTime + fadeOutTime then
        local p = (t - fadeInTime - holdTime) / fadeOutTime
        tex:SetAlpha(1 - p)

    else
        tex:Hide()
        animFrame:Hide()
        animFrame.startTime = nil
    end
end)

local function ShowTexture(path)
    tex:SetTexture(path)
    tex:SetAlpha(0)
    tex:SetScale(startScale)
    tex:Show()
    animFrame.startTime = GetTime()
    animFrame:Show()
end

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        readyTime = GetTime() + loadDelay
        return
    end

    if GetTime() < readyTime then return end

    if event == "QUEST_ACCEPTED" then
        local questID = ...
        if not questID then return end
        if not C_QuestLog.IsOnQuest(questID) then return end
        if C_QuestLog.IsWorldQuest(questID) then return end
    end

    if textures[event] then
        ShowTexture(textures[event])
    end
end)

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("QUEST_ACCEPTED")
frame:RegisterEvent("QUEST_TURNED_IN")