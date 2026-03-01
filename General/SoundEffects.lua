local frame = CreateFrame("Frame")

local events = {
    "PLAYER_ENTERING_WORLD",
    "PLAYER_REGEN_DISABLED",
    "PLAYER_REGEN_ENABLED",
    "UNIT_LEVEL",
    "PLAYER_TARGET_CHANGED",
    "UI_ERROR_MESSAGE",
    "LOOT_OPENED",
    "PLAYER_LEVEL_UP",
    "RAID_INSTANCE_WELCOME",
    "PLAYER_EQUIPMENT_CHANGED",
    "CHAT_MSG_WHISPER",
}

for _, event in ipairs(events) do
    frame:RegisterEvent(event)
end

local function PlayCustomSFX(fileName)
    local path = "Interface\\AddOns\\FFXIV_UI\\Media\\Audio\\" .. fileName
    PlaySoundFile(path, "Master")
end

local lastHadTarget = false
local lastPlayTime = 0

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        return

    elseif event == "PLAYER_REGEN_DISABLED" then
        PlayCustomSFX("FFXIV_Aggro.mp3")

    elseif event == "PLAYER_TARGET_CHANGED" then
        local now = GetTime()
        local hasTarget = UnitExists("target")

        if now - lastPlayTime < 0.1 then return end

        if hasTarget and not lastHadTarget then
            PlayCustomSFX("FFXIV_Switch_Target.mp3")
            lastPlayTime = now

        elseif not hasTarget and lastHadTarget then
            PlayCustomSFX("FFXIV_Untarget.mp3")
            lastPlayTime = now
        end

        lastHadTarget = hasTarget

    elseif event == "UI_ERROR_MESSAGE" then
        PlayCustomSFX("FFXIV_Error.mp3")

    elseif event == "LOOT_OPENED" then
        PlayCustomSFX("FFXIV_Obtain_Item.mp3")

    elseif event == "PLAYER_LEVEL_UP" then
        PlayCustomSFX("FFXIV_Level_Up.mp3")

    elseif event == "RAID_INSTANCE_WELCOME" then
        PlayCustomSFX("FFXIV_Enter_Instance.mp3")

    --elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        --PlayCustomSFX("FFXIV_Change_Gear_Set.mp3")

    elseif event == "CHAT_MSG_WHISPER" then
        PlayCustomSFX("FFXIV_Incoming_Tell_1.mp3")
    end
end)