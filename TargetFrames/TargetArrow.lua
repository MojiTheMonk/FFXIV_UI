local addonName = ...
local frame = CreateFrame("Frame")
local textureFrame = CreateFrame("Frame", nil, UIParent)

textureFrame:SetSize(90, 90)
textureFrame:Hide()

local baseTexture = textureFrame:CreateTexture(nil, "OVERLAY", nil, 1)
baseTexture:SetAllPoints()
baseTexture:SetTexture("Interface\\AddOns\\FFXIV_UI\\Media\\Textures\\TargetArrow.tga")

local overlayTexture = textureFrame:CreateTexture(nil, "OVERLAY", nil, 2)
overlayTexture:SetAllPoints()
overlayTexture:SetTexture("Interface\\AddOns\\FFXIV_UI\\Media\\Textures\\TargetArrow2.tga")
overlayTexture:SetVertexColor(1,1,1)

local slideAnimGroup = textureFrame:CreateAnimationGroup()

local slide = slideAnimGroup:CreateAnimation("Translation")
slide:SetDuration(0.30)
slide:SetSmoothing("OUT")

local fade = slideAnimGroup:CreateAnimation("Alpha")
fade:SetDuration(0.30)
fade:SetFromAlpha(0)
fade:SetToAlpha(1)
fade:SetSmoothing("OUT")

slideAnimGroup:SetToFinalAlpha(true)

local function PlaySlideIn()
    slideAnimGroup:Stop()
    textureFrame:SetAlpha(0)
    textureFrame:SetPoint("BOTTOM", textureFrame:GetParent(), "TOP", 0, 45)
    slide:SetOffset(0, -25)
    slideAnimGroup:Play()
end

slideAnimGroup:SetScript("OnFinished", function()
    textureFrame:ClearAllPoints()
    textureFrame:SetPoint("BOTTOM", textureFrame:GetParent(), "TOP", 0, 20)
end)

local COLORS = {
    player   = {0.3, 0.6, 1.0},
    hostile  = {1.0, 0.2, 0.2},
    neutral  = {235/255, 222/255, 129/255},
    friendly = {113/255, 214/255, 64/255},
    dead     = {0.4, 0.4, 0.4},
}

local function UpdateTextureColor()
    if not UnitExists("target") then return end

    if UnitIsUnit("target", "player") or UnitInParty("target") or UnitInRaid("target") then
        baseTexture:SetVertexColor(unpack(COLORS.player))
        return
    end

    local inCombatWithTarget = UnitAffectingCombat("player") and UnitCanAttack("player", "target")

    if UnitIsDeadOrGhost("target") then
        baseTexture:SetVertexColor(unpack(COLORS.dead))
        return
    end

    if inCombatWithTarget then
        baseTexture:SetVertexColor(unpack(COLORS.hostile))
        return
    end

    if UnitIsPlayer("target") then
        baseTexture:SetVertexColor(unpack(COLORS.player))
        return
    end

    local reaction = UnitReaction("target","player")

    if reaction then
        if reaction <= 3 then
            baseTexture:SetVertexColor(unpack(COLORS.hostile))
        elseif reaction == 4 then
            baseTexture:SetVertexColor(unpack(COLORS.neutral))
        else
            baseTexture:SetVertexColor(unpack(COLORS.friendly))
        end
    else
        baseTexture:SetVertexColor(unpack(COLORS.neutral))
    end
end

local function UpdateTexturePosition(playAnimation)
    if not UnitExists("target") then
        textureFrame:Hide()
        return
    end

    local nameplate = C_NamePlate.GetNamePlateForUnit("target")
    if nameplate then
        textureFrame:SetParent(nameplate)
        textureFrame:Show()
        UpdateTextureColor()

        if playAnimation then
            PlaySlideIn()
        else
            textureFrame:ClearAllPoints()
            textureFrame:SetPoint("BOTTOM", nameplate, "TOP", 0, 20)
            textureFrame:SetAlpha(1)
        end
    else
        textureFrame:Hide()
    end
end

frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("UNIT_FACTION")
frame:RegisterEvent("UNIT_FLAGS")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")

frame:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_TARGET_CHANGED" then
        UpdateTexturePosition(true)
    elseif unit == "target" then
        UpdateTextureColor()
    else
        UpdateTextureColor()
    end
end)