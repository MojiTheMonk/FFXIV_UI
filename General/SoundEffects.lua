FFXIV_UI = FFXIV_UI or {}

local frame = CreateFrame("Frame")

local events = {
    "ADDON_LOADED",  
    "PLAYER_REGEN_DISABLED",
    "PLAYER_TARGET_CHANGED",
    "UI_ERROR_MESSAGE",
    "LOOT_OPENED",
    "PLAYER_LEVEL_UP",
    "RAID_INSTANCE_WELCOME",
    "CHAT_MSG_WHISPER",
}

for _, event in ipairs(events) do 
    frame:RegisterEvent(event) 
end

 
local lastPlayTime = 0
local lastTargetGUID = nil

 
local DEBUG_MODE = false

local function DebugPrint(...)
    if DEBUG_MODE then
        print("|cff00ffff[FFXIV_UI Debug]|r", ...)
    end
end

 
local function PlayCustomSFX(fileName)

    if not FFXIV_UI_DB or not FFXIV_UI_DB.sfxEnabled then
        return
    end

    if fileName == "FFXIV_Error.mp3" and not FFXIV_UI_DB.errorSfxEnabled then
        return
    end

    local path = "Interface\\AddOns\\FFXIV_UI\\Media\\Audio\\" .. fileName

    DebugPrint("Attempting to play:", path)

    PlaySoundFile(path, "Master")
end

 
frame:SetScript("OnEvent", function(self, event, arg1)

    if event == "ADDON_LOADED" and arg1 == "FFXIV_UI" then

        if FFXIV_UI_DB == nil then
            FFXIV_UI_DB = {}
        end

        if FFXIV_UI_DB.sfxEnabled == nil then
            FFXIV_UI_DB.sfxEnabled = true
        end

        if FFXIV_UI_DB.errorSfxEnabled == nil then
            FFXIV_UI_DB.errorSfxEnabled = true
        end
         
        lastTargetGUID = UnitExists("target") and UnitGUID("target") or nil

        DebugPrint("Addon loaded. Initial target GUID:", lastTargetGUID)

        return
    end

    local now = GetTime()


    if event == "PLAYER_REGEN_DISABLED" then

        DebugPrint("PLAYER_REGEN_DISABLED triggered")

        PlayCustomSFX("FFXIV_Aggro.mp3")


    elseif event == "PLAYER_TARGET_CHANGED" then

        local hasTarget = UnitExists("target")
        
        if now - lastPlayTime < 0.1 then
            return
        end

 
        if not lastTargetGUID or not UnitIsUnit("target", "playertarget") then

            if hasTarget then

                DebugPrint("Playing Switch_Target SFX")

                PlayCustomSFX("FFXIV_Switch_Target.mp3")
               
                lastTargetGUID = UnitGUID("target")

            else

                DebugPrint("Playing Untarget SFX")

                PlayCustomSFX("FFXIV_Untarget.mp3")

                lastTargetGUID = nil
            end

            lastPlayTime = now
        end

        lastTargetGUID = currentGUID


    elseif event == "UI_ERROR_MESSAGE" then

        DebugPrint("UI_ERROR_MESSAGE triggered")

        PlayCustomSFX("FFXIV_Error.mp3")


    elseif event == "LOOT_OPENED" then

        DebugPrint("LOOT_OPENED triggered")

        PlayCustomSFX("FFXIV_Obtain_Item.mp3")


    elseif event == "PLAYER_LEVEL_UP" then

        DebugPrint("PLAYER_LEVEL_UP triggered")

        PlayCustomSFX("FFXIV_Level_Up.mp3")


    elseif event == "RAID_INSTANCE_WELCOME" then

        DebugPrint("RAID_INSTANCE_WELCOME triggered")

        PlayCustomSFX("FFXIV_Enter_Instance.mp3")


    elseif event == "CHAT_MSG_WHISPER" then

        DebugPrint("CHAT_MSG_WHISPER triggered")

        PlayCustomSFX("FFXIV_Incoming_Tell_1.mp3")

    end

end)

 
SLASH_FFXIVSFX1 = "/FFXIVSFX"

SlashCmdList["FFXIVSFX"] = function()

    FFXIV_UI_DB.sfxEnabled = not FFXIV_UI_DB.sfxEnabled

    print(
        FFXIV_UI_DB.sfxEnabled
        and "|cff00ff00FFXIV_UI sounds enabled|r"
        or "|cffff0000FFXIV_UI sounds disabled|r"
    )

end