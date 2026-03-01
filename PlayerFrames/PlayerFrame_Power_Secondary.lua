--print("FFXIV UI Player Power Secondary (MP / Brewmaster Stagger) loaded")


local SCALE = 100
local function s(x) return x * SCALE / 100 end


local f = CreateFrame("Frame", nil, UIParent)
PlayerFrame_Power_Secondary = f
f:SetSize(s(232), s(230))
f:SetPoint("LEFT", PlayerFrame_Power, "RIGHT", s(8), 0)
f:SetFrameStrata("MEDIUM")


local bg = f:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetTexture("Interface\\AddOns\\FFXIV_UI\\Media\\Textures\\PlayerFrame\\Background")


local bar = CreateFrame("StatusBar", nil, f)
bar:SetPoint("TOPLEFT", s(4), s(-4))
bar:SetPoint("BOTTOMRIGHT", s(-4), s(4))
bar:SetStatusBarTexture("Interface\\AddOns\\FFXIV_UI\\Media\\Textures\\PlayerFrame\\Health")

local tex = bar:GetStatusBarTexture()
tex:SetDrawLayer("ARTWORK", 0)
tex:SetTexCoord(0.5, 1, 0, 1)


local outlineFrame = CreateFrame("Frame", nil, f)
outlineFrame:SetFrameStrata("MEDIUM")
outlineFrame:SetFrameLevel(f:GetFrameLevel() + 5)
outlineFrame:SetSize(f:GetWidth(), f:GetHeight())
outlineFrame:SetPoint("CENTER", f, "CENTER")
outlineFrame:EnableMouse(false)

local outline = outlineFrame:CreateTexture(nil, "OVERLAY")
outline:SetAllPoints()
outline:SetTexture("Interface\\AddOns\\FFXIV_UI\\Media\\Textures\\PlayerFrame\\Frame")
outline:SetDrawLayer("OVERLAY", 3)

local text = outlineFrame:CreateFontString(nil, "OVERLAY")
text:SetFont("Interface\\AddOns\\FFXIV_UI\\Media\\Fonts\\EurostileExtended.ttf", s(30))
text:SetPoint("BOTTOMRIGHT", outlineFrame, "BOTTOMRIGHT", s(-4), s(76))
text:SetJustifyH("RIGHT")
text:SetDrawLayer("OVERLAY", 7)
text:SetTextColor(252/255, 251/255, 250/255)
text:SetShadowColor(0.8196, 0.7804, 0.6980)
text:SetShadowOffset(0, -1)


local powerLabel = outlineFrame:CreateFontString(nil, "OVERLAY")
powerLabel:SetFont("Interface\\AddOns\\FFXIV_UI\\Media\\Fonts\\MiedingerMedium.ttf", s(18))
powerLabel:SetPoint("BOTTOMLEFT", outlineFrame, "BOTTOMLEFT", s(2), s(80))
powerLabel:SetJustifyH("LEFT")
powerLabel:SetDrawLayer("OVERLAY", 7)
powerLabel:SetTextColor(252/255, 251/255, 250/255)
powerLabel:SetShadowColor(0.8196, 0.7804, 0.6980)
powerLabel:SetShadowOffset(0, -1)


local anchor = FFXIV_UI_Anchors.PlayerPowerSec
f:SetParent(anchor)
f:ClearAllPoints()
f:SetPoint("CENTER", anchor, "CENTER", 0, 0)


local textures = {
    default = "Interface\\AddOns\\FFXIV_UI\\Media\\Textures\\PlayerFrame\\Mana",
    mana = "Interface\\AddOns\\FFXIV_UI\\Media\\Textures\\PlayerFrame\\ClassResources\\Primary\\Mana",
    stagger = "Interface\\AddOns\\FFXIV_UI\\Media\\Textures\\PlayerFrame\\ClassResources\\Primary\\Stagger",
}

local function Update()
    local _, class = UnitClass("player")
    local spec = GetSpecialization()


    f:Hide()


    if class == "DRUID" then
        local formID = GetShapeshiftFormID()
        if formID == 27 or formID == 29 then
            return
        end
    end

    if class == "MONK" and spec == 1 then
        local stagger = UnitStagger("player") or 0
        local maxHealth = UnitHealthMax("player")

        bar:SetStatusBarTexture(textures.stagger)
        bar:SetMinMaxValues(0, maxHealth)
        bar:SetValue(stagger)

        text:SetText(stagger)
        powerLabel:SetText("SP")

        f:Show()


    elseif (class == "SHAMAN" and spec == 1)
        or (class == "DRUID" and spec == 1)
        or (class == "PRIEST" and spec == 3) then

        local mana = UnitPower("player", Enum.PowerType.Mana)
        local maxMana = UnitPowerMax("player", Enum.PowerType.Mana)

        bar:SetStatusBarTexture(textures.mana)
        bar:SetMinMaxValues(0, maxMana)
        bar:SetValue(mana)

        text:SetText(mana)
        powerLabel:SetText("MP")

        f:Show()
    end

    local tex = bar:GetStatusBarTexture()
    tex:SetDrawLayer("ARTWORK", 0)
    tex:SetTexCoord(0.5, 1, 0, 1)
end



f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UNIT_POWER_UPDATE")
f:RegisterEvent("UNIT_MAXPOWER")
f:RegisterEvent("UNIT_DISPLAYPOWER")
f:RegisterEvent("UNIT_HEALTH")
f:RegisterEvent("UNIT_MAXHEALTH")
f:RegisterEvent("UNIT_AURA")
f:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
f:RegisterEvent("UPDATE_SHAPESHIFT_FORM")

f:SetScript("OnEvent", function(_, event, unit)
    if not unit or unit == "player" then
        Update()
    end
end)

 