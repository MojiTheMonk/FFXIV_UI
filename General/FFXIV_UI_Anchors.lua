 

local combatWatcher = CreateFrame("Frame")
combatWatcher:RegisterEvent("PLAYER_REGEN_DISABLED") 
combatWatcher:RegisterEvent("PLAYER_REGEN_ENABLED")  

combatWatcher:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_REGEN_DISABLED" then
   
        if anchorsUnlocked then
            FFXIV_UI_SetAnchorsUnlocked(false)
        end

    elseif event == "PLAYER_REGEN_ENABLED" then

    end
end)
