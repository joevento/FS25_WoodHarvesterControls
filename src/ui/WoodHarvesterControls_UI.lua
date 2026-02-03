--
-- Author: Bargon Mods, DiscoFlower8890
--
WoodHarvesterControls_UI = {}
local WoodHarvesterControls_UI_mt = Class(WoodHarvesterControls_UI, ScreenElement)

WoodHarvesterControls_UI.MAX_LENGTH = 3000
WoodHarvesterControls_UI.MAX_DIAMETER = 300
WoodHarvesterControls_UI.MAX_FEEDING_SPEED = 15
WoodHarvesterControls_UI.MIN_FEEDING_SPEED = 1
WoodHarvesterControls_UI.FEEDING_SPEED_FACTOR = 0.001
WoodHarvesterControls_UI.LENGTH_FACTOR = 0.01

function WoodHarvesterControls_UI:new(modName)
    local self = DialogElement.new(nil, WoodHarvesterControls_UI_mt)

    self.vehicle = nil
    self.modName = modName
    self.i18n = g_i18n.modEnvironments[self.modName]

    return self
end

function WoodHarvesterControls_UI:delete()

end

function WoodHarvesterControls_UI:setVehicle(vehicle)
    self.vehicle = vehicle
end

function WoodHarvesterControls_UI:onOpen()
    WoodHarvesterControls_UI:superClass().onOpen(self)

    self.numberOfAssortmentsSetting:setTexts({ "1", "2", "3", "4" })

    self.autoProgramFeedingSetting:setTexts({ self.i18n:getText("ui_WoodHarvesterControls_press"),
        self.i18n:getText("ui_WoodHarvesterControls_hold") })

    self.autoProgramFellingCutSetting:setTexts({ self.i18n:getText("ui_WoodHarvesterControls_press"),
        self.i18n:getText("ui_WoodHarvesterControls_hold"),
        self.i18n:getText("ui_WoodHarvesterControls_off") })

    self.autoProgramBuckingCutSetting:setTexts({ self.i18n:getText("ui_WoodHarvesterControls_press"),
        self.i18n:getText("ui_WoodHarvesterControls_hold"),
        self.i18n:getText("ui_WoodHarvesterControls_off") })

    self.rotatorModeSetting:setTexts({ self.i18n:getText("ui_WoodHarvesterControls_free"),
        self.i18n:getText("ui_WoodHarvesterControls_fixed"),
        self.i18n:getText("ui_WoodHarvesterControls_physical") })

    self.sawModeSetting:setTexts({ self.i18n:getText("ui_WoodHarvesterControls_automatic"),
        self.i18n:getText("ui_WoodHarvesterControls_semiautomatic"),
        self.i18n:getText("ui_WoodHarvesterControls_manual") })

    local alternated = false;
    for key, element in pairs(self.boxLayout.elements) do
        if element.name ~= nil then
            alternated = false
        elseif element:getIsVisible() then
            local r, g, b, a = unpack(SettingsScreen.COLOR_ALTERNATING[alternated])
            element:setImageColor(nil, r, g, b, a)
            alternated = not alternated
        end
    end

    self:updateValues()
end

function WoodHarvesterControls_UI:updateValues()
    local whSpec = self.vehicle.spec_woodHarvester

    self.automaticWithCutButtonSetting:setIsChecked(whSpec.autoProgramWithCut)

    if whSpec.cutReleasedComponentJoint ~= nil then
        self.automaticTiltUpSetting:setIsChecked(whSpec.automaticTiltUp)
        self.automaticTiltUpSetting:setDisabled(false)
    else
        self.automaticTiltUpSetting:setDisabled(true)
        self.automaticTiltUpSetting:setIsChecked(false)
    end

    if whSpec.advancedOpenClose or whSpec.grabAnimation.name then
        self.automaticOpenSetting:setIsChecked(whSpec.automaticOpen)
        self.automaticOpenSetting:setDisabled(false)
    else
        self.automaticOpenSetting:setDisabled(true)
        self.automaticOpenSetting:setIsChecked(false)
    end

    if whSpec.cutAttachReferenceNode ~= nil and whSpec.cutAttachNode ~= nil then
        self.grabOnCutSetting:setIsChecked(whSpec.grabOnCut)
        self.grabOnCutSetting:setDisabled(false)
    else
        self.grabOnCutSetting:setDisabled(true)
        self.grabOnCutSetting:setIsChecked(false)
    end

    self.numberOfAssortmentsSetting:setState(whSpec.numberOfAssortments)

    for i = 1, 4 do
        if self["minDiameter" .. i] ~= nil then
            self["minDiameter" .. i]:setText(tostring(MathUtil.round(
                whSpec.bucking[i].minDiameter / WoodHarvesterControls_UI.LENGTH_FACTOR)))
        end
        if self["buckingLength" .. i] ~= nil then
            self["buckingLength" .. i]:setText(tostring(MathUtil.round(whSpec.bucking[i].length /
                WoodHarvesterControls_UI.LENGTH_FACTOR)))
        end
    end

    self:updateBuckingSystem()

    self.autoProgramFeedingSetting:setState(whSpec.autoProgramFeeding)
    self.autoProgramFellingCutSetting:setState(whSpec.autoProgramFellingCut)
    self.autoProgramBuckingCutSetting:setState(whSpec.autoProgramBuckingCut)
    self.automaticWithCloseButtonSetting:setIsChecked(whSpec.autoProgramWithClose)
    self.automaticFeedSetting:setIsChecked(whSpec.automaticFeedingOption)
    self:updateAutomaticFeeding()

    if whSpec.cutReleasedComponentJoint2 ~= nil then
        self.rotatorModeSetting:setState(whSpec.rotatorMode)
        self.rotatorModeSetting:setDisabled(false)
    else
        self.rotatorModeSetting:setDisabled(true)
        self.rotatorModeSetting:setState(2)
    end

    self.rotatorForce:setText(tostring(whSpec.rotatorRotLimitForceLimit))
    self.rotatorThreshold:setText(tostring(MathUtil.round(math.deg(whSpec.rotatorThreshold), 2)))
    self:updateRotatorMode()

    self.sawModeSetting:setState(whSpec.sawMode)

    for i = 1, 4 do
        self["lengthPreset" .. i]:setText(tostring(MathUtil.round(whSpec["lengthPreset" .. i] /
            WoodHarvesterControls_UI.LENGTH_FACTOR)))
    end
    self.repeatLengthPresetSetting:setIsChecked(whSpec.repeatLengthPreset)

    self.breakingDistance:setText(tostring(MathUtil.round(whSpec.breakingDistance /
        WoodHarvesterControls_UI.LENGTH_FACTOR)))

    if whSpec.cutReleasedComponentJoint ~= nil then
        self.slowFeedingTiltedUpSetting:setIsChecked(whSpec.slowFeedingTiltedUp)
        self.slowFeedingTiltedUpSetting:setDisabled(false)
    else
        self.slowFeedingTiltedUpSetting:setDisabled(true)
        self.slowFeedingTiltedUpSetting:setState(2)
    end

    self.feedingSpeed:setText(tostring(MathUtil.round(whSpec.feedingSpeed /
        WoodHarvesterControls_UI.FEEDING_SPEED_FACTOR, 2)))
    self.slowFeedingSpeed:setText(tostring(MathUtil.round(whSpec.slowFeedingSpeed /
        WoodHarvesterControls_UI.FEEDING_SPEED_FACTOR, 2)))

    if whSpec.cutReleasedComponentJoint ~= nil then
        self.tiltDownOnFellingCutSetting:setIsChecked(whSpec.tiltDownOnFellingCut)
        self.tiltDownOnFellingCutSetting:setDisabled(false)
    else
        self.tiltDownOnFellingCutSetting:setDisabled(true)
        self.tiltDownOnFellingCutSetting:setState(2)
    end

    if whSpec.cutReleasedComponentJoint ~= nil then
        self.tiltUpWithOpenButtonSetting:setIsChecked(whSpec.tiltUpWithOpenButton)
        self.tiltUpWithOpenButtonSetting:setDisabled(false)
    else
        self.tiltUpWithOpenButtonSetting:setDisabled(true)
        self.tiltUpWithOpenButtonSetting:setState(2)
    end

    self.tiltUpDelay:setText(tostring(whSpec.tiltUpDelay))
    self:updateTiltUpDelay()

    self.tiltMaxAngle:setDisabled(whSpec.cutReleasedComponentJoint == nil)
    self.tiltMaxAngle:setText(tostring(MathUtil.round(math.deg(whSpec.tiltMaxRot), 2)))

    self.registerSoundSetting:setIsChecked(whSpec.registerSound)

    self.maxRemovingLength:setText(tostring(MathUtil.round(whSpec.maxRemovingLength /
        WoodHarvesterControls_UI.LENGTH_FACTOR)))

    self.maxRemovingDiameter:setText(tostring(MathUtil.round(whSpec.maxRemovingDiameter /
        WoodHarvesterControls_UI.LENGTH_FACTOR)))

    if whSpec.allSplitType ~= nil then
        self.allSplitTypeSetting:setIsChecked(whSpec.allSplitType)
    end
end

function WoodHarvesterControls_UI:haveDifferentValues(table1, table2)
    if type(table1) ~= "table" or type(table2) ~= "table" then
        if type(table1) == "number" and type(table2) == "number" then
            local epsilon = 1e-5
            return math.abs(table1 - table2) > epsilon
        end

        return table1 ~= table2
    end

    for key, value1 in pairs(table1) do
        local value2 = table2[key]
        if self:haveDifferentValues(value1, value2) then
            return true
        end
    end

    return false
end

function WoodHarvesterControls_UI:hasChangedSettings()
    if self.vehicle == nil then
        return
    end

    self:updateSettingsToSave()

    local whSpec = self.vehicle.spec_woodHarvester

    return self:haveDifferentValues(self.settingsToSave, whSpec)
end

function WoodHarvesterControls_UI:onClickOk()
    if self.vehicle == nil then
        g_gui:closeDialogByName("WoodHarvesterControls_UI")
        return
    end

    self:updateSettingsToSave()

    local whSpec = self.vehicle.spec_woodHarvester

    if whSpec.rotatorMode ~= self.settingsToSave.rotatorMode and self.settingsToSave.rotatorMode == 3 then
        YesNoDialog.show(self.handleOkDialog, self, self.i18n:getText("ui_WoodHarvesterControls_rotatorModeWarning"),
            "", self.i18n:getText("ui_WoodHarvesterControls_confirm"),
            self.i18n:getText("ui_WoodHarvesterControls_goBack"))
    else
        self:handleOkDialog(true)
    end
end

function WoodHarvesterControls_UI:updateSettingsToSave()
    local settings = {}

    local state

    settings.autoProgramWithCut = self.automaticWithCutButtonSetting:getIsChecked()
    settings.automaticTiltUp = self.automaticTiltUpSetting:getIsChecked()
    settings.automaticOpen = self.automaticOpenSetting:getIsChecked()
    settings.grabOnCut = self.grabOnCutSetting:getIsChecked()

    state = self.numberOfAssortmentsSetting:getState()
    if state <= 4 then
        settings.numberOfAssortments = state
    else
        settings.numberOfAssortments = 1
    end

    settings.bucking = {}
    for i = 1, 4 do
        settings.bucking[i] = {}

        settings.bucking[i].minDiameter = 0
        if self["minDiameter" .. i] ~= nil then
            local n = Utils.getNoNil(tonumber(self["minDiameter" .. i]:getText()), 0)
            settings.bucking[i].minDiameter = MathUtil.round(n) * WoodHarvesterControls_UI.LENGTH_FACTOR
        end

        settings.bucking[i].length = 1
        if self["buckingLength" .. i] ~= nil then
            local n = Utils.getNoNil(tonumber(self["buckingLength" .. i]:getText()), 0)
            settings.bucking[i].length = MathUtil.round(n) * WoodHarvesterControls_UI.LENGTH_FACTOR
        end
    end

    settings.autoProgramFeeding = self.autoProgramFeedingSetting:getState()
    settings.autoProgramFellingCut = self.autoProgramFellingCutSetting:getState()
    settings.autoProgramBuckingCut = self.autoProgramBuckingCutSetting:getState()
    settings.autoProgramWithClose = self.automaticWithCloseButtonSetting:getIsChecked()
    settings.automaticFeedingOption = self.automaticFeedSetting:getIsChecked()

    settings.rotatorMode = self.rotatorModeSetting:getState()

    local n = Utils.getNoNil(tonumber(self.rotatorForce:getText()), 0)
    settings.rotatorRotLimitForceLimit = n

    local n = Utils.getNoNil(tonumber(self.rotatorThreshold:getText()), 0)
    settings.rotatorThreshold = math.rad(n)

    settings.sawMode = self.sawModeSetting:getState()

    for i = 1, 4 do
        local n = Utils.getNoNil(tonumber(self["lengthPreset" .. i]:getText()), 0)
        settings["lengthPreset" .. i] = MathUtil.round(n) * WoodHarvesterControls_UI.LENGTH_FACTOR
    end

    settings.repeatLengthPreset = self.repeatLengthPresetSetting:getIsChecked()

    local n = Utils.getNoNil(tonumber(self.breakingDistance:getText()), 0)
    settings.breakingDistance = MathUtil.round(n) * WoodHarvesterControls_UI.LENGTH_FACTOR

    settings.slowFeedingTiltedUp = self.slowFeedingTiltedUpSetting:getIsChecked()

    local n = Utils.getNoNil(tonumber(self.feedingSpeed:getText()), WoodHarvesterControls_UI.MIN_FEEDING_SPEED)
    settings.feedingSpeed = n * WoodHarvesterControls_UI.FEEDING_SPEED_FACTOR

    local n = Utils.getNoNil(tonumber(self.slowFeedingSpeed:getText()), WoodHarvesterControls_UI.MIN_FEEDING_SPEED)
    settings.slowFeedingSpeed = n * WoodHarvesterControls_UI.FEEDING_SPEED_FACTOR

    settings.tiltDownOnFellingCut = self.tiltDownOnFellingCutSetting:getIsChecked()
    settings.tiltUpWithOpenButton = self.tiltUpWithOpenButtonSetting:getIsChecked()

    local n = Utils.getNoNil(tonumber(self.tiltUpDelay:getText()), 0)
    settings.tiltUpDelay = n

    local n = Utils.getNoNil(tonumber(self.tiltMaxAngle:getText()), 0)
    settings.tiltMaxRot = math.rad(n)

    settings.registerSound = self.registerSoundSetting:getIsChecked()

    local n = Utils.getNoNil(tonumber(self.maxRemovingLength:getText()), 0)
    settings.maxRemovingLength = MathUtil.round(n) * WoodHarvesterControls_UI.LENGTH_FACTOR

    local n = Utils.getNoNil(tonumber(self.maxRemovingDiameter:getText()), 0)
    settings.maxRemovingDiameter = MathUtil.round(n) * WoodHarvesterControls_UI.LENGTH_FACTOR

    settings.allSplitType = self.allSplitTypeSetting:getIsChecked()

    self.settingsToSave = settings
end

function WoodHarvesterControls_UI:handleOkDialog(accepted)
    if accepted then
        self.vehicle:whcUpdateSettings(self.settingsToSave)
        g_gui:closeDialogByName("WoodHarvesterControls_UI")
    end
end

function WoodHarvesterControls_UI:onClickBack()
    if self:hasChangedSettings() then
        YesNoDialog.show(self.handleBackDialog, self, self.i18n:getText("ui_WoodHarvesterControls_backMenuWarning"), "",
            self.i18n:getText("ui_WoodHarvesterControls_discardChanges"),
            self.i18n:getText("ui_WoodHarvesterControls_keepEditing"))
    else
        self:handleBackDialog(true)
    end
end

function WoodHarvesterControls_UI:handleBackDialog(accepted)
    if accepted then
        g_gui:closeDialogByName("WoodHarvesterControls_UI")
    end
end

function WoodHarvesterControls_UI:onClickNumberOfAssortment(state)
    self:updateBuckingSystem()
end

function WoodHarvesterControls_UI:onClickAutomaticProgramFeeding(state)
    self:updateAutomaticFeeding()
end

function WoodHarvesterControls_UI:onClickTiltUpWithOpenButton(state)
    self:updateTiltUpDelay()
end

function WoodHarvesterControls_UI:onClickRotatorMode(state)
    self:updateRotatorMode()
end

function WoodHarvesterControls_UI:updateAutomaticFeeding()
    self.automaticFeedSetting:setDisabled(self.autoProgramFeedingSetting:getState() == 2)
end

function WoodHarvesterControls_UI:updateTiltUpDelay()
    self.tiltUpDelay:setDisabled(not self.tiltUpWithOpenButtonSetting:getIsChecked())
end

function WoodHarvesterControls_UI:updateBuckingSystem()
    local state = self.numberOfAssortmentsSetting:getState()

    for i = 1, 4 do
        if self["buckingLength" .. i] ~= nil then
            self["buckingLength" .. i]:setDisabled(i > state)
        end
        if self["minDiameter" .. i] ~= nil then
            self["minDiameter" .. i]:setDisabled(i >= state)
        end
    end
end

function WoodHarvesterControls_UI:updateRotatorMode()
    local whSpec = self.vehicle.spec_woodHarvester
    local enabled = whSpec.cutReleasedComponentJoint2 ~= nil and self.rotatorModeSetting:getState() == 3

    self.rotatorForce:setDisabled(not enabled)
    self.rotatorThreshold:setDisabled(not enabled)
end

function WoodHarvesterControls_UI:onDiameterChanged(element, text)
    self:onNumberChangedClamp(element, text, 0, WoodHarvesterControls_UI.MAX_DIAMETER)
end

function WoodHarvesterControls_UI:onLengthChanged(element, text)
    self:onNumberChangedClamp(element, text, 0, WoodHarvesterControls_UI.MAX_LENGTH)
end

function WoodHarvesterControls_UI:onFeedingSpeedChanged(element, text)
    self:onNumberChangedClamp(element, text, WoodHarvesterControls_UI.MIN_FEEDING_SPEED,
        WoodHarvesterControls_UI.MAX_FEEDING_SPEED)
end

function WoodHarvesterControls_UI:ensurePositiveNumber(element, text)
    self:onNumberChangedClamp(element, text)
end

function WoodHarvesterControls_UI:onNumberChangedClamp(element, text, min, max)
    if min == nil then
        min = 0
    end

    if max == nil then
        max = 99999
    end

    local number = tonumber(text)

    if number == nil then
        element:setText("")
    else
        if number < min then
            element:setText(tostring(min))
        elseif number > max then
            element:setText(tostring(max))
        else
            element:setText(text)
        end
    end
end
