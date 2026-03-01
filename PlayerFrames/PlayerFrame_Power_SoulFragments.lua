--print("FFXIV UI Player Power (Soul Fragments) loaded")


local SCALE = 100
local function s(x) return x * SCALE / 100 end 


PlayerFrame_Power_SoulFragments = CreateFrame("Frame", nil, UIParent)
local f = PlayerFrame_Power_SoulFragments

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
powerLabel:SetText("SF")  
powerLabel:SetTextColor(252/255, 251/255, 250/255)
powerLabel:SetShadowColor(0.8196, 0.7804, 0.6980)
powerLabel:SetShadowOffset(0, -1)


local soulFragmentTexture = "Interface\\AddOns\\FFXIV_UI\\Media\\Textures\\PlayerFrame\\ClassResources\\Primary\\Health"


local function Update()

    if select(2, UnitClass("player")) ~= "DEMONHUNTER" then
        f:Hide()
        return
    else
        f:Show()
    end

    local powerType = SPELL_POWER_SOUL_SHARDS
    local power = UnitPower("player", powerType)
    local maxPower = UnitPowerMax("player", powerType)

    bar:SetMinMaxValues(0, maxPower)
    bar:SetValue(power)
    bar:SetStatusBarTexture(soulFragmentTexture)

    local tex = bar:GetStatusBarTexture()
    tex:SetDrawLayer("ARTWORK", 0)
    tex:SetTexCoord(0.5, 1, 0, 1)

    text:SetText(power)
end


f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UNIT_POWER_UPDATE")
f:RegisterEvent("UNIT_MAXPOWER")
f:RegisterEvent("UNIT_DISPLAYPOWER")

f:SetScript("OnEvent", function(_, event, unit, powerType)
    if unit == "player" and (not powerType or powerType == SPELL_POWER_SOUL_SHARDS) then
        Update()
    end
end)

Update()
