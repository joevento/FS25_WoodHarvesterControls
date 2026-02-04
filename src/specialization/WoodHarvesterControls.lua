--
-- Author: Bargon Mods, DiscoFlower8890
--
WoodHarvesterControls = {}

local WHC = WoodHarvesterControls

WHC.AUTOMATIC = 1
WHC.SEMIAUTOMATIC = 2
WHC.MANUAL = 3

WHC.SAW_AUTO = 1
WHC.SAW_SENSOR = 2
WHC.SAW_MANUAL = 3

WHC.ON = 1
WHC.OFF = 2

WHC.AUTO_PUSH = 1
WHC.AUTO_HOLD = 2
WHC.AUTO_OFF = 3

local Button = {
    SAW = 0,
    POWER_TOGGLE = 1,
    TILT_TOGGLE = 2,
    TILT_UP = 3,
    TILT_DOWN = 4,
    GRAB_OPEN = 5,
    GRAB_CLOSE = 6,
    GRAB_TOGGLE = 7,
    FORWARD_FEED = 8,
    BACKWARD_FEED = 9,
    SLOW_FORWARD_FEED = 10,
    SLOW_BACKWARD_FEED = 11,
    AUTOMATIC_PROGRAM = 12,
    STOP = 13,
    LENGTH_PRESET_1 = 14,
    LENGTH_PRESET_2 = 15,
    MENU = 16,
    LENGTH_PRESET_3 = 17
}

local ActionName = {
    DEFAULT_SAW = InputAction.IMPLEMENT_EXTRA2,
    DEFAULT_MENU = InputAction.IMPLEMENT_EXTRA3,
    SAW = 'WOOD_HARVESTER_CONTROLS_SAW',
    TURN_ON_OFF_HEAD = 'WOOD_HARVESTER_CONTROLS_TURN_ON_OFF_HEAD',
    TILT_UP_DOWN_HEAD = 'WOOD_HARVESTER_CONTROLS_TILT_UP_DOWN_HEAD',
    TILT_UP_HEAD = 'WOOD_HARVESTER_CONTROLS_TILT_UP_HEAD',
    TILT_DOWN_HEAD = 'WOOD_HARVESTER_CONTROLS_TILT_DOWN_HEAD',
    OPEN_HEAD = 'WOOD_HARVESTER_CONTROLS_OPEN_HEAD',
    CLOSE_HEAD = 'WOOD_HARVESTER_CONTROLS_CLOSE_HEAD',
    OPEN_CLOSE_HEAD = 'WOOD_HARVESTER_CONTROLS_OPEN_CLOSE_HEAD',
    FORWARD_FEED = 'WOOD_HARVESTER_CONTROLS_FORWARD_FEED',
    BACKWARD_FEED = 'WOOD_HARVESTER_CONTROLS_BACKWARD_FEED',
    SLOW_FORWARD_FEED = 'WOOD_HARVESTER_CONTROLS_SLOW_FORWARD_FEED',
    SLOW_BACKWARD_FEED = 'WOOD_HARVESTER_CONTROLS_SLOW_BACKWARD_FEED',
    AUTOMATIC_PROGRAM = 'WOOD_HARVESTER_CONTROLS_AUTOMATIC_PROGRAM',
    STOP = 'WOOD_HARVESTER_CONTROLS_STOP',
    LENGTH_PRESET_1 = 'WOOD_HARVESTER_CONTROLS_LENGTH_PRESET_1',
    LENGTH_PRESET_2 = 'WOOD_HARVESTER_CONTROLS_LENGTH_PRESET_2',
    LENGTH_PRESET_3 = 'WOOD_HARVESTER_CONTROLS_LENGTH_PRESET_3',
    MENU = 'WOOD_HARVESTER_CONTROLS_MENU'
}

local ActionButtonMapping = {
    [ActionName.DEFAULT_SAW] = Button.SAW,
    [ActionName.DEFAULT_MENU] = Button.MENU,
    [ActionName.SAW] = Button.SAW,
    [ActionName.TURN_ON_OFF_HEAD] = Button.POWER_TOGGLE,
    [ActionName.TILT_UP_DOWN_HEAD] = Button.TILT_TOGGLE,
    [ActionName.TILT_UP_HEAD] = Button.TILT_UP,
    [ActionName.TILT_DOWN_HEAD] = Button.TILT_DOWN,
    [ActionName.OPEN_HEAD] = Button.GRAB_OPEN,
    [ActionName.CLOSE_HEAD] = Button.GRAB_CLOSE,
    [ActionName.OPEN_CLOSE_HEAD] = Button.GRAB_TOGGLE,
    [ActionName.FORWARD_FEED] = Button.FORWARD_FEED,
    [ActionName.BACKWARD_FEED] = Button.BACKWARD_FEED,
    [ActionName.SLOW_FORWARD_FEED] = Button.SLOW_FORWARD_FEED,
    [ActionName.SLOW_BACKWARD_FEED] = Button.SLOW_BACKWARD_FEED,
    [ActionName.AUTOMATIC_PROGRAM] = Button.AUTOMATIC_PROGRAM,
    [ActionName.STOP] = Button.STOP,
    [ActionName.LENGTH_PRESET_1] = Button.LENGTH_PRESET_1,
    [ActionName.LENGTH_PRESET_2] = Button.LENGTH_PRESET_2,
    [ActionName.MENU] = Button.MENU,
    [ActionName.LENGTH_PRESET_3] = Button.LENGTH_PRESET_3
}

local ButtonHandlerMapping = {
    [Button.SAW] = "onSawButton",
    [Button.TILT_TOGGLE] = "onTiltToggleButton",
    [Button.TILT_UP] = "onTiltUpButton",
    [Button.TILT_DOWN] = "onTiltDownButton",
    [Button.GRAB_OPEN] = "onGrabOpenButton",
    [Button.GRAB_CLOSE] = "onGrabCloseButton",
    [Button.GRAB_TOGGLE] = "onGrabToggleButton",
    [Button.FORWARD_FEED] = "onForwardFeedButton",
    [Button.BACKWARD_FEED] = "onBackwardFeedButton",
    [Button.SLOW_FORWARD_FEED] = "onSlowForwardFeedButton",
    [Button.SLOW_BACKWARD_FEED] = "onSlowBackwardFeedButton",
    [Button.AUTOMATIC_PROGRAM] = "onAutomaticProgramButton",
    [Button.STOP] = "onStopButton",
    [Button.LENGTH_PRESET_1] = "onPreset1Button",
    [Button.LENGTH_PRESET_2] = "onPreset2Button",
    [Button.LENGTH_PRESET_3] = "onPreset3Button"
}

local AnimationKey = {
    SAW = "cutAnimation",
    DEFAULT_GRAB = "grabAnimation",
    TOP_KNIVES = "topGrabAnimation",
    BOTTOM_KNIVES = "bottomGrabAnimation",
    ROLLERS = "rollersGrabAnimation"
}

WHC.DEFAULT_TILT_DOWN_FORCE = 0
WHC.DEFAULT_TILT_DOWN_DAMPING = 1

WHC.ROTATOR_FREE = 1
WHC.ROTATOR_FIXED = 2
WHC.ROTATOR_PHYSICAL = 3

WHC.MIN_BREAKING_SPEED = 0.0005
WHC.MIN_DISTANCE_TO_GROUND = 0.3

local Actions = { {
    name = ActionName.DEFAULT_SAW,
    priority = GS_PRIO_HIGH,
    text = g_i18n:getText("action_saw"),
    triggerUp = true
}, {
    name = ActionName.DEFAULT_SAW,
    priority = GS_PRIO_HIGH,
    text = g_i18n:getText("action_openWoodHarvesterControlsMenu")
}, {
    name = ActionName.SAW,
    priority = GS_PRIO_HIGH,
    text = g_i18n:getText("action_saw"),
    triggerUp = true
}, {
    name = ActionName.TURN_ON_OFF_HEAD,
    priority = GS_PRIO_HIGH
}, {
    name = ActionName.TILT_UP_DOWN_HEAD,
    priority = GS_PRIO_NORMAL
}, {
    name = ActionName.TILT_UP_HEAD,
    priority = GS_PRIO_NORMAL,
    triggerUp = true
}, {
    name = ActionName.TILT_DOWN_HEAD,
    priority = GS_PRIO_NORMAL,
    triggerUp = true
}, {
    name = ActionName.OPEN_HEAD,
    priority = GS_PRIO_VERY_HIGH,
    triggerUp = true
}, {
    name = ActionName.CLOSE_HEAD,
    priority = GS_PRIO_VERY_HIGH,
    triggerUp = true
}, {
    name = ActionName.OPEN_CLOSE_HEAD,
    priority = GS_PRIO_HIGH,
    triggerUp = true
}, {
    name = ActionName.FORWARD_FEED,
    priority = GS_PRIO_NORMAL,
    triggerUp = true
}, {
    name = ActionName.BACKWARD_FEED,
    priority = GS_PRIO_NORMAL,
    triggerUp = true
}, {
    name = ActionName.SLOW_FORWARD_FEED,
    priority = GS_PRIO_NORMAL,
    triggerUp = true
}, {
    name = ActionName.SLOW_BACKWARD_FEED,
    priority = GS_PRIO_NORMAL,
    triggerUp = true
}, {
    name = ActionName.AUTOMATIC_PROGRAM,
    priority = GS_PRIO_HIGH,
    triggerUp = true
}, {
    name = ActionName.STOP,
    priority = GS_PRIO_HIGH
}, {
    name = ActionName.LENGTH_PRESET_1,
    priority = GS_PRIO_NORMAL
}, {
    name = ActionName.LENGTH_PRESET_2,
    priority = GS_PRIO_NORMAL
}, {
    name = ActionName.LENGTH_PRESET_3,
    priority = GS_PRIO_NORMAL
}, {
    name = ActionName.MENU,
    priority = GS_PRIO_HIGH
} }

function WoodHarvesterControls.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(TurnOnVehicle, specializations)
end

function WoodHarvesterControls.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType("woodHarvesterControls", "Wood Harvester Controls",
        "woodHarvesterControls", VehicleConfigurationItem)

    WHC.registerXMLSchema()
    WHC.registerSavegameSchema()
end

function WoodHarvesterControls.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "whcHandleCutEffects", WHC.whcHandleCutEffects)
    SpecializationUtil.registerFunction(vehicleType, "whcHandleDelimbEffects", WHC.whcHandleDelimbEffects)
    SpecializationUtil.registerFunction(vehicleType, "whcHandleRegisterSound", WHC.whcHandleRegisterSound)
    SpecializationUtil.registerFunction(vehicleType, "whcPlayAnimationWithEvent", WHC.whcPlayAnimationWithEvent)
    SpecializationUtil.registerFunction(vehicleType, "whcUpdateSettings", WHC.whcUpdateSettings)
    SpecializationUtil.registerFunction(vehicleType, "whcOnButtonPressed", WHC.whcOnButtonPressed)
end

function WoodHarvesterControls.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "cutTree", WoodHarvesterControls.cutTree)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "findSplitShapesInRange",
        WoodHarvesterControls.findSplitShapesInRange)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "woodHarvesterSplitShapeCallback",
        WoodHarvesterControls.woodHarvesterSplitShapeCallback)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setLastTreeDiameter",
        WoodHarvesterControls.setLastTreeDiameter)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDoConsumePtoPower",
        WoodHarvesterControls.getDoConsumePtoPower)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanSplitShapeBeAccessed",
        WoodHarvesterControls.getCanSplitShapeBeAccessed)
end

function WoodHarvesterControls:initSpecAndGetConfiguration()
    self.spec_woodHarvesterControls = {
        enabled = true
    }
end

function WoodHarvesterControls:onLoad(superFunc, savegame)
    WoodHarvesterControls.initSpecAndGetConfiguration(self)

    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, savegame)
        return
    end

    local spec = self.spec_woodHarvester

    spec.curSplitShape = nil
    spec.attachedSplitShape = nil
    spec.hasAttachedSplitShape = false
    spec.isAttachedSplitShapeMoving = false
    spec.attachedSplitShapeX = 0
    spec.attachedSplitShapeY = 0
    spec.attachedSplitShapeZ = 0
    spec.attachedSplitShapeTargetY = 0
    spec.attachedSplitShapeLastCutY = 0
    spec.attachedSplitShapeStartY = 0
    spec.cutTimer = -1
    spec.lastTreeSize = nil
    spec.lastTreeJointPos = nil
    spec.loadedSplitShapeFromSavegame = false

    spec.cutNode = self.xmlFile:getValue("vehicle.woodHarvester.cutNode#node", nil, self.components, self.i3dMappings)
    spec.cutMaxRadius = self.xmlFile:getValue("vehicle.woodHarvester.cutNode#maxRadius", 1)
    spec.cutSizeY = self.xmlFile:getValue("vehicle.woodHarvester.cutNode#sizeY", 1)
    spec.cutSizeZ = self.xmlFile:getValue("vehicle.woodHarvester.cutNode#sizeZ", 1)
    spec.cutAttachNode = self.xmlFile:getValue("vehicle.woodHarvester.cutNode#attachNode", nil, self.components,
        self.i3dMappings)
    spec.cutAttachReferenceNode = self.xmlFile:getValue("vehicle.woodHarvester.cutNode#attachReferenceNode", nil,
        self.components, self.i3dMappings)
    local cutReleasedComponentJointIndex = self.xmlFile:getValue(
        "vehicle.woodHarvester.cutNode#releasedComponentJointIndex")
    if cutReleasedComponentJointIndex ~= nil then
        spec.cutReleasedComponentJoint = self.componentJoints[cutReleasedComponentJointIndex]
        spec.cutReleasedComponentJointRotLimitX = 0
        spec.cutReleasedComponentJointRotLimitXSpeed = self.xmlFile:getValue(
            "vehicle.woodHarvester.cutNode#releasedComponentJointRotLimitXSpeed", 100) * 0.001
    end
    local cutReleasedComponentJoint2Index = self.xmlFile:getValue(
        "vehicle.woodHarvester.cutNode#releasedComponentJoint2Index")
    if cutReleasedComponentJoint2Index ~= nil then
        spec.cutReleasedComponentJoint2 = self.componentJoints[cutReleasedComponentJoint2Index]
        spec.cutReleasedComponentJoint2RotLimitX = 0
        spec.cutReleasedComponentJoint2RotLimitXSpeed = self.xmlFile:getValue(
            "vehicle.woodHarvester.cutNode#releasedComponentJointRotLimitXSpeed", 100) * 0.001
    end

    if spec.cutAttachReferenceNode ~= nil and spec.cutAttachNode ~= nil then
        spec.cutAttachHelperNode = createTransformGroup("helper")
        link(spec.cutAttachReferenceNode, spec.cutAttachHelperNode)
        setTranslation(spec.cutAttachHelperNode, 0, 0, 0)
        setRotation(spec.cutAttachHelperNode, 0, 0, 0)
    end

    spec.cutAttachDirection = 1

    spec.delimbNode = self.xmlFile:getValue("vehicle.woodHarvester.delimbNode#node", nil, self.components,
        self.i3dMappings)
    spec.delimbSizeX = self.xmlFile:getValue("vehicle.woodHarvester.delimbNode#sizeX", 0.1)
    spec.delimbSizeY = self.xmlFile:getValue("vehicle.woodHarvester.delimbNode#sizeY", 1)
    spec.delimbSizeZ = self.xmlFile:getValue("vehicle.woodHarvester.delimbNode#sizeZ", 1)
    spec.delimbOnCut = self.xmlFile:getValue("vehicle.woodHarvester.delimbNode#delimbOnCut", false)

    spec.currentCutLength = 0

    if self.isClient then
        spec.cutEffects = g_effectManager:loadEffect(self.xmlFile, "vehicle.woodHarvester.cutEffects", self.components,
            self, self.i3dMappings)
        spec.delimbEffects = g_effectManager:loadEffect(self.xmlFile, "vehicle.woodHarvester.delimbEffects",
            self.components, self, self.i3dMappings)
        spec.forwardingNodes = g_animationManager:loadAnimations(self.xmlFile, "vehicle.woodHarvester.forwardingNodes",
            self.components, self, self.i3dMappings)

        spec.samples = {}
        spec.samples.cut = g_soundManager:loadSampleFromXML(self.xmlFile, "vehicle.woodHarvester.sounds", "cut",
            self.baseDirectory, self.components, 0, AudioGroup.VEHICLE, self.i3dMappings, self)
        spec.samples.delimb = g_soundManager:loadSampleFromXML(self.xmlFile, "vehicle.woodHarvester.sounds", "delimb",
            self.baseDirectory, self.components, 0, AudioGroup.VEHICLE, self.i3dMappings, self)
        spec.isCutSamplePlaying = false
        spec.isDelimbSamplePlaying = false
    end

    local cutAnimation = {}
    cutAnimation.name = self.xmlFile:getValue("vehicle.woodHarvester.cutAnimation#name")
    cutAnimation.speedScale = self.xmlFile:getValue("vehicle.woodHarvester.cutAnimation#speedScale", 1)
    cutAnimation.cutTime = self.xmlFile:getValue("vehicle.woodHarvester.cutAnimation#cutTime", 1)

    local grabAnimation = {}
    grabAnimation.name = self.xmlFile:getValue("vehicle.woodHarvester.grabAnimation#name")
    grabAnimation.speedScale = self.xmlFile:getValue("vehicle.woodHarvester.grabAnimation#speedScale", 1)

    spec.treeSizeMeasure = {}
    spec.treeSizeMeasure.node = self.xmlFile:getValue("vehicle.woodHarvester.treeSizeMeasure#node", nil,
        self.components, self.i3dMappings)
    spec.treeSizeMeasure.rotMaxRadius = self.xmlFile:getValue("vehicle.woodHarvester.treeSizeMeasure#rotMaxRadius", 1)
    spec.treeSizeMeasure.rotMaxAnimTime = self.xmlFile:getValue("vehicle.woodHarvester.treeSizeMeasure#rotMaxAnimTime",
        1)

    spec.warnInvalidTree = false
    spec.warnInvalidTreeRadius = false
    spec.warnInvalidTreePosition = false
    spec.warnTreeNotOwned = false

    spec.lastDiameter = 0

    spec.texts = {}
    spec.texts.actionChangeCutLength = g_i18n:getText("action_woodHarvesterChangeCutLength")
    spec.texts.woodHarvesterTiltHeader = g_i18n:getText("action_woodHarvesterTiltHeader")
    spec.texts.uiMax = g_i18n:getText("ui_max")
    spec.texts.unitMeterShort = g_i18n:getText("unit_mShort")
    spec.texts.actionCut = g_i18n:getText("action_woodHarvesterCut")
    spec.texts.warningFoldingTreeMounted = g_i18n:getText("warning_foldingTreeMounted")
    spec.texts.warningTreeTooThick = g_i18n:getText("warning_treeTooThick")
    spec.texts.warningTreeTooThickAtPosition = g_i18n:getText("warning_treeTooThickAtPosition")
    spec.texts.warningTreeTypeNotSupported = g_i18n:getText("warning_treeTypeNotSupported")
    spec.texts.warningYouDontHaveAccessToThisLand = g_i18n:getText("warning_youAreNotAllowedToCutThisTree")
    spec.texts.warningFirstTurnOnTheTool = string.format(g_i18n:getText("warning_firstTurnOnTheTool"), self.typeDesc)

    local whcSpec = self.spec_woodHarvesterControls

    if not whcSpec.enabled then
        return
    end

    local spec = self.spec_woodHarvester

    for _, movingTool in pairs(self.spec_cylindered.movingTools) do
        if movingTool.axisActionIndex == "AXIS_CRANE_TOOL2" then
            spec.rotatorMovingTool = movingTool
            spec.rotatorRotAcceleration = movingTool.rotAcceleration
            spec.rotatorInvertAxis = movingTool.invertAxis
            spec.rotatorRotSpeed = movingTool.rotSpeed
            spec.rotatorRotMax = movingTool.rotMax
            spec.rotatorRotMin = movingTool.rotMin
            spec.rotatorCurRot = movingTool.curRot
            spec.rotatorRotationAxis = movingTool.rotationAxis
            spec.rotatorNode = movingTool.node
            spec.rotatorComponentJoints = movingTool.componentJoints
            break
        end
    end

    if spec.cutReleasedComponentJoint ~= nil then
        spec.cutReleasedComponentJointRotLimitXNegative = 0
    end

    spec.autoProgramWithCut = true
    spec.automaticTiltUp = true
    spec.automaticOpen = true
    spec.grabOnCut = true

    spec.numberOfAssortments = 4;
    spec.bucking = { {
        length = 5.3,
        minDiameter = 0.26
    }, {
        length = 3.15,
        minDiameter = 0.20
    }, {
        length = 4.5,
        minDiameter = 0.1
    }, {
        length = 3.7,
        minDiameter = 0
    } }

    spec.autoProgramFeeding = WHC.AUTO_PUSH
    spec.autoProgramFellingCut = WHC.AUTO_PUSH
    spec.autoProgramBuckingCut = WHC.AUTO_PUSH
    spec.autoProgramWithClose = false
    spec.automaticFeedingOption = false

    spec.rotatorMode = WHC.ROTATOR_FREE
    spec.rotatorRotLimitForceLimit = 10
    spec.rotatorThreshold = 0.2618

    spec.sawMode = WHC.AUTOMATIC

    spec.lengthPreset1 = 3
    spec.lengthPreset2 = 4
    spec.lengthPreset3 = 5
    spec.lengthPreset4 = 6
    spec.lengthPreset5 = 7
    spec.lengthPreset6 = 8
    spec.repeatLengthPreset = false

    spec.breakingDistance = 1
    spec.slowFeedingTiltedUp = true
    spec.feedingSpeed = 0.0045
    spec.slowFeedingSpeed = 0.001

    spec.tiltDownOnFellingCut = true
    spec.tiltUpWithOpenButton = true
    spec.tiltUpDelay = 500
    spec.tiltMaxRot = 95 / 180 * math.pi

    spec.registerSound = true
    spec.maxRemovingLength = 0.5
    spec.maxRemovingDiameter = 0.2
    spec.allSplitType = false

    spec.tempDiameter = 0
    spec.tiltControl = true
    spec.tiltDownForce = 30
    spec.tiltDownDamping = 20
    spec.tiltMaxRotDriveForce = 0.01
    spec.forcedTiltDown = false
    spec.forcedTiltUp = false
    spec.currentTiltDownForce = WHC.DEFAULT_TILT_DOWN_FORCE
    spec.currentTiltDownDamping = WHC.DEFAULT_TILT_DOWN_DAMPING

    spec.currentLength = 0
    spec.registerFound = false
    spec.automaticFeedingStarted = false
    spec.tiltedUp = WHC.isTiltSupported(self)
    spec.tiltedUpOnCut = nil
    spec.isHeadClosed = true
    spec.currentAssortmentIndex = nil
    spec.lastAssortment = nil

    spec.cutSawSpeedMultiplier = 1
    spec.sawSpeedMultiplier = 2
    spec.currentLengthPreset = 0
    spec.currentFeedingSpeed = 0
    spec.isSawOut = false
    spec.currentSawMode = nil
    spec.referenceCutDone = false
    spec.autoProgramStarted = false
    spec.autoProgramHoldTimer = -1
    spec.autoProgramTransitionTimer = -1
    spec.autoProgramTransitionTargetTime = 250
    spec.autoFeedingTimer = -1
    spec.autoFeedingDelay = 200
    spec.closeHoldTimer = -1
    spec.openHoldTimer = -1
    spec.closeHoldTargetTime = 250
    spec.playCutSound = false

    spec.lastPreset1Time = -1
    spec.lastPreset2Time = -1
    spec.lastPreset3Time = -1
    spec.doublePressPresetTime = 500

    if self.isServer then
        if spec.cutReleasedComponentJoint2 ~= nil then
            local jointIndex = spec.cutReleasedComponentJoint2.index
            spec.rotatorOriginalRotLimitForce = self.componentJoints[jointIndex].rotLimitForceLimit[1]
        end
    end

    spec.forwardingNodesSpeed = {}
    for key, forwardingAnimation in pairs(spec.forwardingNodes) do
        spec.forwardingNodesSpeed[key] = spec.forwardingNodes[key].rotSpeed
    end

    spec.headHeight = 1
    if spec.cutNode and spec.delimbNode then
        local cx, cy, cz = getWorldTranslation(spec.cutNode)
        local dx, dy, dz = getWorldTranslation(spec.delimbNode)
        local distance = MathUtil.vector3Length(cx - dx, cy - dy, cz - dz)
        spec.headHeight = math.clamp(distance, 0.5, 2)
    end

    local sawAnimation = {}
    sawAnimation.name = self.xmlFile:getValue("vehicle.woodHarvesterControls.sawAnimation#name")
    sawAnimation.speedScale = self.xmlFile:getValue("vehicle.woodHarvesterControls.sawAnimation#speedScale", 1)
    sawAnimation.maxCutDiameter = self.xmlFile:getValue("vehicle.woodHarvesterControls.sawAnimation#maxCutDiameter", 1)

    if (sawAnimation.name ~= nil and sawAnimation.maxCutDiameter ~= nil) then
        spec[AnimationKey.SAW] = sawAnimation
        spec.advancedCut = true
    else
        spec[AnimationKey.SAW] = cutAnimation
    end

    local topAnimation = {}
    topAnimation.name = self.xmlFile:getValue("vehicle.woodHarvesterControls.topGrabAnimation#name")
    topAnimation.speedScale = self.xmlFile:getValue("vehicle.woodHarvesterControls.topGrabAnimation#speedScale", 1)

    local bottomAnimation = {}
    bottomAnimation.name = self.xmlFile:getValue("vehicle.woodHarvesterControls.bottomGrabAnimation#name")
    bottomAnimation.speedScale =
        self.xmlFile:getValue("vehicle.woodHarvesterControls.bottomGrabAnimation#speedScale", 1)

    local rollersAnimation = {}
    rollersAnimation.name = self.xmlFile:getValue("vehicle.woodHarvesterControls.rollersGrabAnimation#name")
    rollersAnimation.speedScale = self.xmlFile:getValue("vehicle.woodHarvesterControls.rollersGrabAnimation#speedScale",
        1)

    if rollersAnimation.name or (topAnimation.name or bottomAnimation.name) then
        spec.advancedOpenClose = true
        spec[AnimationKey.TOP_KNIVES] = topAnimation
        spec[AnimationKey.BOTTOM_KNIVES] = bottomAnimation
        spec[AnimationKey.ROLLERS] = rollersAnimation
    else
        spec[AnimationKey.DEFAULT_GRAB] = grabAnimation
    end

    if self.isClient then
        if WoodHarvesterControls.registerFoundSample == nil then
            local fileName = Utils.getFilename("assets/register.ogg",
                g_currentMission.woodHarvesterControls.modDirectory)
            WoodHarvesterControls.registerFoundSample = createSample("RegisterFound")
            loadSample(WoodHarvesterControls.registerFoundSample, fileName, false)
        end

        if WoodHarvesterControls.assortmentChangedSample == nil then
            local fileName = Utils.getFilename("assets/assortment.ogg",
                g_currentMission.woodHarvesterControls.modDirectory)
            WoodHarvesterControls.assortmentChangedSample = createSample("AssortmentChanged")
            loadSample(WoodHarvesterControls.assortmentChangedSample, fileName, false)
        end

        local cutSound = g_soundManager:loadSampleFromXML(self.xmlFile, "vehicle.woodHarvesterControls.sounds", "cut",
            self.baseDirectory, self.components, 0, AudioGroup.VEHICLE, self.i3dMappings, self)

        if cutSound ~= nil then
            spec.samples.cut = cutSound
        end

        spec.samples.cutEnd = g_soundManager:loadSampleFromXML(self.xmlFile, "vehicle.woodHarvesterControls.sounds",
            "cutEnd", self.baseDirectory, self.components, 1, AudioGroup.VEHICLE, self.i3dMappings, self)
    end
end

function WoodHarvesterControls:onPostLoad(superFunc, savegame)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, savegame)
        return
    end

    local spec = self.spec_woodHarvester

    if savegame == nil or savegame.resetVehicles then
        return
    end

    local key = savegame.key .. "." .. g_woodHarvesterControlsModName .. ".woodHarvesterControls"

    spec.autoProgramWithCut = savegame.xmlFile:getValue(key .. "#autoProgramWithCut", spec.autoProgramWithCut)
    spec.automaticTiltUp = savegame.xmlFile:getValue(key .. "#automaticTiltUp", spec.automaticTiltUp)
    spec.automaticOpen = savegame.xmlFile:getValue(key .. "#automaticOpen", spec.automaticOpen)
    spec.grabOnCut = savegame.xmlFile:getValue(key .. "#grabOnCut", spec.grabOnCut)

    spec.numberOfAssortments = savegame.xmlFile:getValue(key .. "#numberOfAssortments", spec.numberOfAssortments)
    for i = 1, 4 do
        local toolKey = string.format("%s.buckingSystem(%d)", key, i - 1)
        spec.bucking[i].minDiameter = savegame.xmlFile:getValue(toolKey .. "#minDiameter", spec.bucking[i].minDiameter)
        spec.bucking[i].length = savegame.xmlFile:getValue(toolKey .. "#length", spec.bucking[i].length)
    end

    spec.autoProgramFeeding = savegame.xmlFile:getValue(key .. "#autoProgramFeeding", spec.autoProgramFeeding)
    spec.autoProgramFellingCut = savegame.xmlFile:getValue(key .. "#autoProgramFellingCut", spec.autoProgramFellingCut)
    spec.autoProgramBuckingCut = savegame.xmlFile:getValue(key .. "#autoProgramBuckingCut", spec.autoProgramBuckingCut)
    spec.autoProgramWithClose = savegame.xmlFile:getValue(key .. "#autoProgramWithClose", spec.autoProgramWithClose)
    spec.automaticFeedingOption = savegame.xmlFile:getValue(key .. "#automaticFeedingOption",
        spec.automaticFeedingOption)

    spec.rotatorMode = savegame.xmlFile:getValue(key .. "#rotatorMode", spec.rotatorMode)
    spec.rotatorRotLimitForceLimit = savegame.xmlFile:getValue(key .. "#rotatorRotLimitForceLimit",
        spec.rotatorRotLimitForceLimit)
    spec.rotatorThreshold = savegame.xmlFile:getValue(key .. "#rotatorThreshold", spec.rotatorThreshold)

    spec.sawMode = savegame.xmlFile:getValue(key .. "#sawMode", spec.sawMode)

    for i = 1, 6 do
        local toolKey = string.format("%s.lengthPreset(%d)", key, i - 1)
        spec["lengthPreset" .. i] = savegame.xmlFile:getValue(toolKey .. "#length", spec["lengthPreset" .. i])
    end
    spec.repeatLengthPreset = savegame.xmlFile:getValue(key .. "#repeatLengthPreset", spec.repeatLengthPreset)

    spec.breakingDistance = savegame.xmlFile:getValue(key .. "#breakingDistance", spec.breakingDistance)
    spec.slowFeedingTiltedUp = savegame.xmlFile:getValue(key .. "#slowFeedingTiltedUp", spec.slowFeedingTiltedUp)
    spec.feedingSpeed = savegame.xmlFile:getValue(key .. "#feedingSpeed", spec.feedingSpeed)
    spec.slowFeedingSpeed = savegame.xmlFile:getValue(key .. "#slowFeedingSpeed", spec.slowFeedingSpeed)

    spec.tiltDownOnFellingCut = savegame.xmlFile:getValue(key .. "#tiltDownOnFellingCut", spec.tiltDownOnFellingCut)
    spec.tiltUpWithOpenButton = savegame.xmlFile:getValue(key .. "#tiltUpWithOpenButton", spec.tiltUpWithOpenButton)
    spec.tiltUpDelay = savegame.xmlFile:getValue(key .. "#tiltUpDelay", spec.tiltUpDelay)
    spec.tiltMaxRot = savegame.xmlFile:getValue(key .. "#tiltMaxRot", spec.tiltMaxRot)

    spec.registerSound = savegame.xmlFile:getValue(key .. "#registerSound", spec.registerSound)
    spec.maxRemovingLength = savegame.xmlFile:getValue(key .. "#maxRemovingLength", spec.maxRemovingLength)
    spec.maxRemovingDiameter = savegame.xmlFile:getValue(key .. "#maxRemovingDiameter", spec.maxRemovingDiameter)
    spec.allSplitType = savegame.xmlFile:getValue(key .. "#allSplitType", spec.allSplitType)
end

function WoodHarvesterControls:onLoadFinished(superFunc, savegame)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, savegame)
        return
    end

    if self.isServer then
        WHC.updateRotatorMode(self)
    end
end

function WoodHarvesterControls:onRegisterDashboardValueTypes()
    local spec = self.spec_woodHarvester

    local cutLength = DashboardValueType.new("woodHarvester", "cutLength")
    cutLength:setValue(spec, function()
        if spec.currentCutLength == math.huge then
            return 9999999
        else
            return spec.currentCutLength * 100
        end
    end)
    self:registerDashboardValueType(cutLength)

    local curCutLength = DashboardValueType.new("woodHarvester", "curCutLength")
    curCutLength:setValue(spec, function()
        return spec.currentLength * 100
    end)
    self:registerDashboardValueType(curCutLength)

    local diameter = DashboardValueType.new("woodHarvester", "diameter")
    diameter:setValue(spec, function()
        return spec.lastDiameter * 1000
    end)
    self:registerDashboardValueType(diameter)
end

function WHC:originalSaveToXMLFile(superFunc, xmlFile, key, usedModNames)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, xmlFile, key, usedModNames)
    end
end

function WoodHarvesterControls:saveToXMLFile(xmlFile, key, usedModNames)
    if not self.spec_woodHarvesterControls.enabled then
        return
    end

    local spec = self.spec_woodHarvester

    xmlFile:setValue(key .. "#autoProgramWithCut", spec.autoProgramWithCut)
    xmlFile:setValue(key .. "#automaticTiltUp", spec.automaticTiltUp)
    xmlFile:setValue(key .. "#automaticOpen", spec.automaticOpen)
    xmlFile:setValue(key .. "#grabOnCut", spec.grabOnCut)

    xmlFile:setValue(key .. "#numberOfAssortments", spec.numberOfAssortments)
    for i = 1, 4 do
        local toolKey = string.format("%s.buckingSystem(%d)", key, i - 1)
        xmlFile:setValue(toolKey .. "#minDiameter", spec.bucking[i].minDiameter)
        xmlFile:setValue(toolKey .. "#length", spec.bucking[i].length)
    end

    xmlFile:setValue(key .. "#autoProgramFeeding", spec.autoProgramFeeding)
    xmlFile:setValue(key .. "#autoProgramFellingCut", spec.autoProgramFellingCut)
    xmlFile:setValue(key .. "#autoProgramBuckingCut", spec.autoProgramBuckingCut)
    xmlFile:setValue(key .. "#autoProgramWithClose", spec.autoProgramWithClose)
    xmlFile:setValue(key .. "#automaticFeedingOption", spec.automaticFeedingOption)

    xmlFile:setValue(key .. "#rotatorMode", spec.rotatorMode)
    xmlFile:setValue(key .. "#rotatorRotLimitForceLimit", spec.rotatorRotLimitForceLimit)
    xmlFile:setValue(key .. "#rotatorThreshold", spec.rotatorThreshold)

    xmlFile:setValue(key .. "#sawMode", spec.sawMode)

    for i = 1, 6 do
        local toolKey = string.format("%s.lengthPreset(%d)", key, i - 1)
        xmlFile:setValue(toolKey .. "#length", spec["lengthPreset" .. i])
    end
    xmlFile:setValue(key .. "#repeatLengthPreset", spec.repeatLengthPreset)

    xmlFile:setValue(key .. "#breakingDistance", spec.breakingDistance)
    xmlFile:setValue(key .. "#slowFeedingTiltedUp", spec.slowFeedingTiltedUp)
    xmlFile:setValue(key .. "#feedingSpeed", spec.feedingSpeed)
    xmlFile:setValue(key .. "#slowFeedingSpeed", spec.slowFeedingSpeed)

    xmlFile:setValue(key .. "#tiltDownOnFellingCut", spec.tiltDownOnFellingCut)
    xmlFile:setValue(key .. "#tiltUpWithOpenButton", spec.tiltUpWithOpenButton)
    xmlFile:setValue(key .. "#tiltUpDelay", spec.tiltUpDelay)
    xmlFile:setValue(key .. "#tiltMaxRot", spec.tiltMaxRot)

    xmlFile:setValue(key .. "#registerSound", spec.registerSound)
    xmlFile:setValue(key .. "#maxRemovingLength", spec.maxRemovingLength)
    xmlFile:setValue(key .. "#maxRemovingDiameter", spec.maxRemovingDiameter)
    xmlFile:setValue(key .. "#allSplitType", spec.allSplitType)
end

function WoodHarvesterControls:onReadStream(superFunc, streamId, connection)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, streamId, connection)
        return
    end

    local spec = self.spec_woodHarvester
    spec.hasAttachedSplitShape = streamReadBool(streamId)
    if spec.hasAttachedSplitShape then
        local animTime = streamReadUIntN(streamId, 7) / 127
        self:setAnimationTime(spec.grabAnimation.name, animTime, true)

        self:setAnimationTime(spec.cutAnimation.name, 0, true)
    end

    spec.autoProgramWithCut = streamReadBool(streamId)
    spec.automaticTiltUp = streamReadBool(streamId)
    spec.automaticOpen = streamReadBool(streamId)
    spec.grabOnCut = streamReadBool(streamId)

    spec.numberOfAssortments = streamReadUIntN(streamId, 3)
    spec.bucking = {}
    for i = 1, 4 do
        spec.bucking[i] = {}
        spec.bucking[i].minDiameter = streamReadFloat32(streamId)
        spec.bucking[i].length = streamReadFloat32(streamId)
    end

    spec.autoProgramFeeding = streamReadUIntN(streamId, 3)
    spec.autoProgramFellingCut = streamReadUIntN(streamId, 3)
    spec.autoProgramBuckingCut = streamReadUIntN(streamId, 3)
    spec.autoProgramWithClose = streamReadBool(streamId)
    spec.automaticFeedingOption = streamReadBool(streamId)

    spec.rotatorMode = streamReadUIntN(streamId, 3)
    spec.rotatorRotLimitForceLimit = streamReadFloat32(streamId)
    spec.rotatorThreshold = streamReadFloat32(streamId)

    spec.sawMode = streamReadUIntN(streamId, 3)

    for i = 1, 6 do
        spec["lengthPreset" .. i] = streamReadFloat32(streamId)
    end
    spec.repeatLengthPreset = streamReadBool(streamId)

    spec.breakingDistance = streamReadFloat32(streamId)
    spec.slowFeedingTiltedUp = streamReadBool(streamId)
    spec.feedingSpeed = streamReadFloat32(streamId)
    spec.slowFeedingSpeed = streamReadFloat32(streamId)

    spec.tiltDownOnFellingCut = streamReadBool(streamId)
    spec.tiltUpWithOpenButton = streamReadBool(streamId)
    spec.tiltUpDelay = streamReadFloat32(streamId)
    spec.tiltMaxRot = streamReadFloat32(streamId)

    spec.registerSound = streamReadBool(streamId)
    spec.maxRemovingLength = streamReadFloat32(streamId)
    spec.maxRemovingDiameter = streamReadFloat32(streamId)
    spec.allSplitType = streamReadBool(streamId)
end

function WoodHarvesterControls:onWriteStream(superFunc, streamId, connection)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, streamId, connection)
        return
    end

    local spec = self.spec_woodHarvester
    if streamWriteBool(streamId, spec.hasAttachedSplitShape) then
        local animTime = self:getAnimationTime(spec.grabAnimation.name)
        streamWriteUIntN(streamId, animTime * 127, 7)
    end

    streamWriteBool(streamId, spec.autoProgramWithCut)
    streamWriteBool(streamId, spec.automaticTiltUp)
    streamWriteBool(streamId, spec.automaticOpen)
    streamWriteBool(streamId, spec.grabOnCut)

    streamWriteUIntN(streamId, spec.numberOfAssortments, 3)
    for i = 1, 4 do
        streamWriteFloat32(streamId, spec.bucking[i].minDiameter)
        streamWriteFloat32(streamId, spec.bucking[i].length)
    end

    streamWriteUIntN(streamId, spec.autoProgramFeeding, 3)
    streamWriteUIntN(streamId, spec.autoProgramFellingCut, 3)
    streamWriteUIntN(streamId, spec.autoProgramBuckingCut, 3)
    streamWriteBool(streamId, spec.autoProgramWithClose)
    streamWriteBool(streamId, spec.automaticFeedingOption)

    streamWriteUIntN(streamId, spec.rotatorMode, 3)
    streamWriteFloat32(streamId, spec.rotatorRotLimitForceLimit)
    streamWriteFloat32(streamId, spec.rotatorThreshold)

    streamWriteUIntN(streamId, spec.sawMode, 3)

    for i = 1, 6 do
        streamWriteFloat32(streamId, spec["lengthPreset" .. i])
    end
    streamWriteBool(streamId, spec.repeatLengthPreset)

    streamWriteFloat32(streamId, spec.breakingDistance)
    streamWriteBool(streamId, spec.slowFeedingTiltedUp)
    streamWriteFloat32(streamId, spec.feedingSpeed)
    streamWriteFloat32(streamId, spec.slowFeedingSpeed)

    streamWriteBool(streamId, spec.tiltDownOnFellingCut)
    streamWriteBool(streamId, spec.tiltUpWithOpenButton)
    streamWriteFloat32(streamId, spec.tiltUpDelay)
    streamWriteFloat32(streamId, spec.tiltMaxRot)

    streamWriteBool(streamId, spec.registerSound)
    streamWriteFloat32(streamId, spec.maxRemovingLength)
    streamWriteFloat32(streamId, spec.maxRemovingDiameter)
    streamWriteBool(streamId, spec.allSplitType)
end

function WoodHarvesterControls:onReadUpdateStream(superFunc, streamId, timestamp, connection)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, streamId, timestamp, connection)
        return
    end

    if connection:getIsServer() then
        local spec = self.spec_woodHarvester

        spec.currentLength = streamReadFloat32(streamId)
    end
end

function WoodHarvesterControls:onWriteUpdateStream(superFunc, streamId, connection, dirtyMask)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, streamId, connection, dirtyMask)
        return
    end

    if not connection:getIsServer() then
        local spec = self.spec_woodHarvester

        streamWriteFloat32(streamId, spec.currentLength)
    end
end

function WoodHarvesterControls:onUpdate(superFunc, dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
        return
    end

    local spec = self.spec_woodHarvester

    if self.isServer then
        local lostShape = false
        if spec.attachedSplitShape ~= nil then
            if not entityExists(spec.attachedSplitShape) then
                spec.attachedSplitShape = nil
                spec.attachedSplitShapeJointIndex = nil
                spec.isAttachedSplitShapeMoving = false
                spec.cutTimer = -1
                lostShape = true
            end
        elseif spec.curSplitShape ~= nil then
            if not entityExists(spec.curSplitShape) then
                spec.curSplitShape = nil
                lostShape = true
            end
        end
        if lostShape then
            self:setLastTreeDiameter(0)
            SpecializationUtil.raiseEvent(self, "onCutTree", 0)
            if g_server ~= nil then
                g_server:broadcastEvent(WoodHarvesterOnCutTreeEvent.new(self, 0), nil, nil, self)
            end
        end
    end

    if self.isServer and (spec.attachedSplitShape ~= nil or spec.curSplitShape ~= nil) then
        if spec.cutTimer > 0 then
            if spec.cutAnimation.name ~= nil then
                local targetTime = spec.cutAnimation.cutTime
                if spec.advancedCut == true then
                    targetTime = math.min(1.0, (spec.tempDiameter / spec.cutAnimation.maxCutDiameter) * 1.1)
                end
                if self:getAnimationTime(spec.cutAnimation.name) >= targetTime then
                    spec.cutTimer = 0
                    if spec.currentSawMode == WHC.SAW_SENSOR then
                        WHC.raiseSaw(self)
                        spec.registerFound = false
                    elseif spec.currentSawMode == WHC.SAW_MANUAL then
                        if spec.advancedCut == true then
                            WHC.playAnimationForward(self, AnimationKey.SAW, spec.sawSpeedMultiplier)
                        else
                            WHC.stopAnimation(self, AnimationKey.SAW)
                        end
                    else
                        WHC.raiseSaw(self)
                    end
                end
            else
                spec.cutTimer = math.max(spec.cutTimer - dt, 0)
            end
        end

        local readyToCut = spec.cutTimer == 0

        if readyToCut and spec.attachedSplitShape ~= nil then
            local x, y, z = localToWorld(spec.cutNode, 0, 0, 0)
            local nx, ny, nz = localDirectionToWorld(spec.cutNode, 1, 0, 0)
            local yx, yy, yz = localDirectionToWorld(spec.cutNode, 0, 1, 0)
            local minY, maxY, minZ, maxZ = testSplitShape(spec.attachedSplitShape, x, y, z, nx, ny, nz, yx, yy, yz,
                spec.cutSizeY, spec.cutSizeZ)
            if minY == nil then
                spec.cutTimer = -1
                readyToCut = false
            end
        end

        if readyToCut then
            spec.cutTimer = -1

            spec.currentLength = 0

            local x, y, z = getWorldTranslation(spec.cutNode)
            local nx, ny, nz = localDirectionToWorld(spec.cutNode, 1, 0, 0)
            local yx, yy, yz = localDirectionToWorld(spec.cutNode, 0, 1, 0)
            local newTreeCut = false

            if WHC.isStandingTreeAttached(self) or WHC.isStandingTreeInRange(self) then
                newTreeCut = true
            end

            local currentSplitShape
            if spec.attachedSplitShapeJointIndex ~= nil then
                removeJoint(spec.attachedSplitShapeJointIndex)
                spec.attachedSplitShapeJointIndex = nil
                currentSplitShape = spec.attachedSplitShape
                spec.attachedSplitShape = nil
            else
                currentSplitShape = spec.curSplitShape
                spec.curSplitShape = nil
            end

            local splitTypeName = ""
            local splitType = g_splitShapeManager:getSplitTypeByIndex(getSplitType(currentSplitShape))
            if splitType ~= nil then
                splitTypeName = splitType.name
            end

            if spec.delimbOnCut then
                local xD, yD, zD = getWorldTranslation(spec.delimbNode)
                local nxD, nyD, nzD = localDirectionToWorld(spec.delimbNode, 1, 0, 0)
                local yxD, yyD, yzD = localDirectionToWorld(spec.delimbNode, 0, 1, 0)
                local vx, vy, vz = x - xD, y - yD, z - zD
                local sizeX = MathUtil.vector3Length(vx, vy, vz)
                removeSplitShapeAttachments(currentSplitShape, xD + vx * 0.5, yD + vy * 0.5, zD + vz * 0.5, nxD, nyD,
                    nzD, yxD, yyD, yzD, sizeX * 0.7 + spec.delimbSizeX, spec.delimbSizeY, spec.delimbSizeZ)
            end

            spec.attachedSplitShape = nil
            spec.curSplitShape = nil
            spec.prevSplitShape = currentSplitShape

            if not spec.loadedSplitShapeFromSavegame then
                g_currentMission:removeKnownSplitShape(currentSplitShape)
                self.shapeBeingCut = currentSplitShape
                self.shapeBeingCutIsTree = getRigidBodyType(currentSplitShape) == RigidBodyType.STATIC
                splitShape(currentSplitShape, x, y, z, nx, ny, nz, yx, yy, yz, spec.cutSizeY, spec.cutSizeZ,
                    "woodHarvesterSplitShapeCallback", self)
                g_treePlantManager:removingSplitShape(currentSplitShape)
            else
                self:woodHarvesterSplitShapeCallback(currentSplitShape, false, true, unpack(spec.lastTreeSize))
            end

            if spec.attachedSplitShape == nil then
                SpecializationUtil.raiseEvent(self, "onCutTree", 0)
                if g_server ~= nil then
                    g_server:broadcastEvent(WoodHarvesterOnCutTreeEvent.new(self, 0), nil, nil, self)
                end
            else
                if spec.delimbOnCut then
                    local xD, yD, zD = getWorldTranslation(spec.delimbNode)
                    local nxD, nyD, nzD = localDirectionToWorld(spec.delimbNode, 1, 0, 0)
                    local yxD, yyD, yzD = localDirectionToWorld(spec.delimbNode, 0, 1, 0)
                    local vx, vy, vz = x - xD, y - yD, z - zD
                    local sizeX = MathUtil.vector3Length(vx, vy, vz)
                    removeSplitShapeAttachments(spec.attachedSplitShape, xD + vx * 3, yD + vy * 3, zD + vz * 3, nxD,
                        nyD, nzD, yxD, yyD, yzD, sizeX * 3 + spec.delimbSizeX, spec.delimbSizeY, spec.delimbSizeZ)
                end
            end

            if newTreeCut then
                local stats = g_currentMission:farmStats(self:getActiveFarm())

                local cutTreeCount = stats:updateStats("cutTreeCount", 1)

                g_achievementManager:tryUnlock("CutTreeFirst", cutTreeCount)
                g_achievementManager:tryUnlock("CutTree", cutTreeCount)

                if splitTypeName ~= "" then
                    stats:updateTreeTypesCut(splitTypeName)
                end
            end
        end

        if spec.attachedSplitShape ~= nil and spec.isAttachedSplitShapeMoving then
            local translatedDistance = spec.currentFeedingSpeed
            if (not spec.manualFeedingForward and not spec.manualFeedingBackward) then
                local distanceToTarget = math.abs(spec.attachedSplitShapeY - spec.attachedSplitShapeTargetY)
                if (distanceToTarget < spec.breakingDistance) then
                    translatedDistance = MathUtil.lerp(WHC.MIN_BREAKING_SPEED, translatedDistance,
                        distanceToTarget / spec.breakingDistance)
                end
            end
            translatedDistance = translatedDistance * dt

            if WHC.isStandingTreeAttached(self) and spec.manualFeedingBackward then
                local _, cutNodeHeight, _ = localToWorld(spec.cutNode, -WHC.MIN_DISTANCE_TO_GROUND, 0, 0)

                local limitHeight = cutNodeHeight - translatedDistance

                local terrainHeight = getTerrainHeightAtWorldPos(g_currentMission.terrainRootNode,
                    getWorldTranslation(spec.cutNode))

                if limitHeight < terrainHeight then
                    if cutNodeHeight < terrainHeight then
                        translatedDistance = 0
                    else
                        translatedDistance = math.min(cutNodeHeight - terrainHeight, translatedDistance)
                    end
                end
            end

            if spec.delimbNode ~= nil then
                local x, y, z = getWorldTranslation(spec.delimbNode)
                local nx, ny, nz = localDirectionToWorld(spec.delimbNode, 1, 0, 0)
                local yx, yy, yz = localDirectionToWorld(spec.delimbNode, 0, 1, 0)

                removeSplitShapeAttachments(spec.attachedSplitShape, x, y, z, nx, ny, nz, yx, yy, yz,
                    spec.delimbSizeX + translatedDistance * 2, spec.delimbSizeY, spec.delimbSizeZ)
            end

            if spec.cutNode ~= nil and spec.attachedSplitShapeJointIndex ~= nil then
                local x, y, z = getWorldTranslation(spec.cutAttachReferenceNode)
                local nx, ny, nz = localDirectionToWorld(spec.cutAttachReferenceNode, 0, 1, 0)
                local lengthToBottom, lengthToTop = getSplitShapePlaneExtents(spec.attachedSplitShape, x, y, z, nx, ny,
                    nz)

                if lengthToTop == nil or lengthToTop <= 0.1 or lengthToBottom == nil or lengthToBottom <=
                    -spec.headHeight then
                    removeJoint(spec.attachedSplitShapeJointIndex)
                    spec.attachedSplitShapeJointIndex = nil
                    spec.attachedSplitShape = nil

                    WHC.setDelimbStatus(self, 0, false, false)
                    self:setLastTreeDiameter(0)

                    SpecializationUtil.raiseEvent(self, "onCutTree", 0)
                    if g_server ~= nil then
                        g_server:broadcastEvent(WoodHarvesterOnCutTreeEvent.new(self, 0), nil, nil, self)
                    end
                else
                    spec.registerFound = false
                    local registerFound = false

                    if spec.manualFeedingForward or spec.manualFeedingBackward then
                        if spec.manualFeedingForward then
                            spec.attachedSplitShapeY = spec.attachedSplitShapeY + translatedDistance *
                                spec.cutAttachDirection
                        elseif spec.manualFeedingBackward then
                            spec.attachedSplitShapeY = spec.attachedSplitShapeY - translatedDistance *
                                spec.cutAttachDirection
                        end
                    elseif spec.attachedSplitShapeY < spec.attachedSplitShapeTargetY then
                        local changedRegister = false
                        if spec.currentAssortmentIndex ~= nil then
                            local assortment = spec.bucking[spec.currentAssortmentIndex]

                            if spec.currentAssortmentIndex ~= spec.numberOfAssortments and assortment ~= nil and
                                assortment.minDiameter ~= nil and assortment.minDiameter > spec.lastDiameter then
                                WHC.findRegister(self)
                                changedRegister = true
                            end
                        end

                        if changedRegister == false then
                            spec.attachedSplitShapeY = spec.attachedSplitShapeY + translatedDistance
                            if spec.attachedSplitShapeY >= spec.attachedSplitShapeTargetY then
                                registerFound = true
                            end
                        end
                    else
                        spec.attachedSplitShapeY = spec.attachedSplitShapeY - translatedDistance
                        if spec.attachedSplitShapeY <= spec.attachedSplitShapeTargetY then
                            registerFound = true
                        end
                    end

                    if registerFound then
                        spec.attachedSplitShapeY = spec.attachedSplitShapeTargetY
                        WHC.setDelimbStatus(self, 0, false, false)
                    end

                    if spec.attachedSplitShapeJointIndex ~= nil then
                        x, y, z = localToWorld(spec.cutNode, 0.3, 0, 0)
                        nx, ny, nz = localDirectionToWorld(spec.cutNode, 1, 0, 0)
                        local yx, yy, yz = localDirectionToWorld(spec.cutNode, 0, 1, 0)
                        local shape, minY, maxY, minZ, maxZ =
                            findSplitShape(x, y, z, nx, ny, nz, yx, yy, yz, spec.cutSizeY, spec.cutSizeZ)
                        if shape == spec.attachedSplitShape then
                            local treeCenterX, treeCenterY, treeCenterZ = localToWorld(spec.cutNode, 0,
                                (minY + maxY) * 0.5, (minZ + maxZ) * 0.5)
                            spec.attachedSplitShapeX, _, spec.attachedSplitShapeZ = worldToLocal(
                                spec.attachedSplitShape, treeCenterX, treeCenterY, treeCenterZ)
                            self:setLastTreeDiameter((maxY - minY + maxZ - minZ) * 0.5)
                        end
                        x, y, z = localToWorld(spec.attachedSplitShape, spec.attachedSplitShapeX,
                            spec.attachedSplitShapeY, spec.attachedSplitShapeZ)
                        setJointPosition(spec.attachedSplitShapeJointIndex, 1, x, y, z)

                        local cutLength = spec.attachedSplitShapeTargetY - spec.attachedSplitShapeLastCutY
                        local remainingLength = spec.attachedSplitShapeTargetY - spec.attachedSplitShapeY
                        spec.currentLength = cutLength - remainingLength
                    end

                    if registerFound then
                        WHC.onRegisterFound(self)
                    end
                end
            end
        end
    end

    if self.isServer and self:getIsTurnedOn() then
        if spec.rotatorMode == WHC.ROTATOR_PHYSICAL and spec.cutReleasedComponentJoint2 ~= nil and spec.rotatorNode ~=
            nil then
            if not spec.physicalRotatorStarted then
                spec.physicalRotatorStarted = true
                WHC.updateRotatorMode(self)
            end

            local jointNodeActor1 = spec.cutReleasedComponentJoint2.jointNodeActor1
            local mountNode = spec.cutReleasedComponentJoint2.jointNode
            local rotNode = spec.rotatorNode

            if jointNodeActor1 ~= nil and mountNode ~= nil and rotNode ~= nil then
                local x = spec.rotatorRotationAxis == 1 and 1 or 0
                local y = spec.rotatorRotationAxis == 2 and 1 or 0
                local z = spec.rotatorRotationAxis == 3 and 1 or 0

                local dirYRotX, dirYRotY, dirYRotZ = localDirectionToWorld(rotNode, x, y, z)

                local dirXActorX, dirXActorY, dirXActorZ = localDirectionToWorld(jointNodeActor1, 0.1, 0.1, 1)

                local dir = MathUtil.dotProduct(dirXActorX, dirXActorY, dirXActorZ, dirYRotX, dirYRotY, dirYRotZ)
                dir = dir > 0 and 1 or -1

                local dirZMountX, dirZMountY, dirZMountZ = localDirectionToWorld(mountNode, 0, 0, 1)
                local dirZActorX, dirZActorY, dirZActorZ = localDirectionToWorld(jointNodeActor1, 0, 0, 1)
                local rotAxisX, rotAxisY, rotAxisZ = MathUtil.crossProduct(dirZMountX, dirZMountY, dirZMountZ,
                    dirZActorX, dirZActorY, dirZActorZ)
                local nActorX, nActorY, nActorZ = localDirectionToWorld(jointNodeActor1, 1, 0, 0)

                local x = MathUtil.dotProduct(dirZMountX, dirZMountY, dirZMountZ, dirZActorX, dirZActorY, dirZActorZ)

                local y = MathUtil.dotProduct(nActorX, nActorY, nActorZ, rotAxisX, rotAxisY, rotAxisZ)

                local angleBetween = math.atan2(y, x)
                local rotNodeRotation = { getRotation(rotNode) }
                local isMoving = spec.rotatorMovingTool.move ~= nil and math.abs(spec.rotatorMovingTool.move) > 0.05
                local currentRotation = rotNodeRotation[spec.rotatorRotationAxis]
                local newRotation

                if isMoving and math.abs(angleBetween) > spec.rotatorThreshold then
                    local delta = angleBetween - spec.rotatorThreshold
                    if angleBetween < 0 then
                        delta = angleBetween + spec.rotatorThreshold
                    end

                    newRotation = currentRotation - delta * dir;
                elseif not isMoving and math.abs(angleBetween) > math.rad(5) then
                    newRotation = currentRotation - angleBetween * dir
                end

                if newRotation then
                    if spec.rotatorRotMin ~= nil and spec.rotatorRotMax ~= nil then
                        newRotation = math.clamp(newRotation, spec.rotatorRotMin, spec.rotatorRotMax)
                    end
                    rotNodeRotation[spec.rotatorRotationAxis] = newRotation
                    setRotation(rotNode, unpack(rotNodeRotation))
                end

                local componentJoint = self.componentJoints[spec.cutReleasedComponentJoint2.index]
                self:setComponentJointFrame(componentJoint, 1)
            end
        end
    end

    if self.isServer then
        if spec.closeHoldTimer >= 0 then
            spec.closeHoldTimer = spec.closeHoldTimer + dt
            if spec.isHeadClosed == false then
                if spec.closeHoldTimer >= spec.closeHoldTargetTime then
                    WHC.attachTree(self)
                    spec.closeHoldTimer = -1
                end
            end
        end

        if spec.autoProgramHoldTimer >= 0 then
            spec.autoProgramHoldTimer = spec.autoProgramHoldTimer + dt
            if spec.isHeadClosed == false then
            else
                if spec.registerFound == false then
                    if spec.autoProgramFeeding == WHC.AUTO_HOLD then
                        if spec.hasAttachedSplitShape then
                            if not spec.isAttachedSplitShapeMoving and not spec.isSawOut then
                                spec.autoFeedingTimer = spec.autoFeedingTimer + dt
                                if spec.autoFeedingTimer > spec.autoFeedingDelay then
                                    WHC.findRegister(self)
                                    spec.autoFeedingTimer = -1
                                end
                            end
                        end
                    end
                else
                    if WHC.checkAutoProgramCut(self, WHC.AUTO_HOLD) then
                        if spec.hasAttachedSplitShape then
                            if spec.autoProgramTransitionTimer == -1 and not spec.isAttachedSplitShapeMoving and
                                not spec.isSawOut then
                                spec.autoProgramTransitionTimer = 0
                            end
                        end
                    end
                end
            end
        end

        if spec.autoProgramTransitionTimer >= 0 then
            spec.autoProgramTransitionTimer = spec.autoProgramTransitionTimer + dt
            if spec.autoProgramTransitionTimer > spec.autoProgramTransitionTargetTime then
                if not spec.isAttachedSplitShapeMoving and not spec.isSawOut then
                    WHC.lowerSaw(self, WHC.SAW_SENSOR)
                    spec.autoProgramTransitionTimer = -1
                end
            end
        end

        if WHC.isTiltSupported(self) and spec.tiltUpWithOpenButton and spec.openHoldTimer >= 0 then
            spec.openHoldTimer = spec.openHoldTimer + dt
            if spec.openHoldTimer >= spec.tiltUpDelay then
                spec.tiltedUp = true
                spec.openHoldTimer = -1
            end
        end

        if spec.isSawOut and not self:getIsAnimationPlaying(spec.cutAnimation.name) and
            self:getAnimationTime(spec.cutAnimation.name) == 0 then
            spec.isSawOut = false
        end
    end

    if self.isServer then
        if spec.cutAnimation.name ~= nil then
            if spec.isSawOut and spec.playCutSound == true then
                local targetTime = spec.cutAnimation.cutTime
                if spec.advancedCut == true then
                    targetTime = math.min(1.0, (spec.tempDiameter / spec.cutAnimation.maxCutDiameter) * 1.1)
                end

                if (spec.hasAttachedSplitShape or spec.curSplitShape ~= nil) and
                    self:getAnimationTime(spec.cutAnimation.name) < targetTime then
                    self:whcHandleCutEffects(true, true)
                else
                    self:whcHandleCutEffects(true, false)
                end
            else
                self:whcHandleCutEffects(false, false)
            end
        end

        if spec.isAttachedSplitShapeMoving then
            local forwardFeed = true
            if spec.manualFeedingBackward or
                (not spec.manualFeedingForward and spec.hasAttachedSplitShape and spec.attachedSplitShapeY >=
                    spec.attachedSplitShapeTargetY) then
                forwardFeed = false
            end

            if spec.hasAttachedSplitShape then
                self:whcHandleDelimbEffects(true, true, forwardFeed)
            else
                self:whcHandleDelimbEffects(true, false, forwardFeed)
            end
        else
            self:whcHandleDelimbEffects(false, false)
        end
    end
end

function WoodHarvesterControls:whcHandleCutEffects(sound, particles, noEventSend)
    if sound == nil then
        sound = false
    end

    if particles == nil then
        particles = false
    end

    WoodHarvesterControlsCutEffectsEvent.sendEvent(self, sound, particles, noEventSend)

    if self.isClient then
        local spec = self.spec_woodHarvester

        if spec.samples.cut then
            if sound then
                if not spec.isCutSamplePlaying then
                    g_soundManager:playSample(spec.samples.cut)
                    spec.isCutSamplePlaying = true
                end
            elseif spec.isCutSamplePlaying then
                g_soundManager:stopSample(spec.samples.cut)
                spec.isCutSamplePlaying = false

                if spec.samples.cutEnd ~= nil then
                    g_soundManager:playSample(spec.samples.cutEnd, 0, spec.samples.cut)
                end
            end
        end

        if spec.cutEffects then
            if particles then
                if not spec.isCutEffectPlaying then
                    g_effectManager:setEffectTypeInfo(spec.cutEffects, FillType.WOODCHIPS)
                    g_effectManager:startEffects(spec.cutEffects)
                    spec.isCutEffectPlaying = true
                end
            else
                g_effectManager:stopEffects(spec.cutEffects)
                spec.isCutEffectPlaying = false
            end
        end
    end
end

function WoodHarvesterControls:whcHandleDelimbEffects(sound, particles, forward, noEventSend)
    if sound == nil then
        sound = false
    end

    if particles == nil then
        particles = false
    end

    if forward == nil then
        forward = true
    end

    WoodHarvesterControlsDelimbEffectsEvent.sendEvent(self, sound, particles, forward, noEventSend)

    if self.isClient then
        local spec = self.spec_woodHarvester

        if spec.samples.delimb then
            if sound then
                if not spec.isDelimbSamplePlaying then
                    g_soundManager:playSample(spec.samples.delimb)
                    spec.isDelimbSamplePlaying = true
                end
            else
                g_soundManager:stopSample(spec.samples.delimb)
                spec.isDelimbSamplePlaying = false
            end
        end

        if spec.forwardingNodes then
            if sound then
                if not spec.isDelimbAnimationPlaying then
                    local animationSpeed = 1

                    if not forward then
                        animationSpeed = -1
                    end

                    for key, forwardingAnimation in pairs(spec.forwardingNodes) do
                        spec.forwardingNodes[key].rotSpeed = spec.forwardingNodesSpeed[key] * animationSpeed
                    end

                    g_animationManager:startAnimations(spec.forwardingNodes)
                    spec.isDelimbAnimationPlaying = true
                end
            else
                g_animationManager:stopAnimations(spec.forwardingNodes)
                spec.isDelimbAnimationPlaying = false
            end
        end

        if spec.delimbEffects then
            if particles then
                if not spec.isDelimbEffectPlaying then
                    g_effectManager:setEffectTypeInfo(spec.delimbEffects, FillType.WOODCHIPS)
                    g_effectManager:startEffects(spec.delimbEffects)
                    spec.isDelimbEffectPlaying = true
                end
            else
                g_effectManager:stopEffects(spec.delimbEffects)
                spec.isDelimbEffectPlaying = false
            end
        end
    end
end

function WoodHarvesterControls:onUpdateTick(superFunc, dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
        return
    end

    local spec = self.spec_woodHarvester

    spec.warnInvalidTree = false
    spec.warnInvalidTreeRadius = false
    spec.warnInvalidTreePosition = false
    spec.warnTreeNotOwned = false

    if self.isServer and self:getIsTurnedOn() then
        if spec.attachedSplitShape == nil and spec.cutNode ~= nil then
            local x, y, z = getWorldTranslation(spec.cutNode)
            local nx, ny, nz = localDirectionToWorld(spec.cutNode, 1, 0, 0)
            local yx, yy, yz = localDirectionToWorld(spec.cutNode, 0, 1, 0)

            self:findSplitShapesInRange()

            if spec.curSplitShape ~= nil then
                local minY, maxY, minZ, maxZ = testSplitShape(spec.curSplitShape, x, y, z, nx, ny, nz, yx, yy, yz,
                    spec.cutSizeY, spec.cutSizeZ)
                if minY == nil then
                    spec.curSplitShape = nil
                else
                    local cutTooLow = false
                    local _
                    _, y, _ = localToLocal(spec.cutNode, spec.curSplitShape, 0, minY, minZ)
                    cutTooLow = cutTooLow or y < 0.01
                    _, y, _ = localToLocal(spec.cutNode, spec.curSplitShape, 0, minY, maxZ)
                    cutTooLow = cutTooLow or y < 0.01
                    _, y, _ = localToLocal(spec.cutNode, spec.curSplitShape, 0, maxY, minZ)
                    cutTooLow = cutTooLow or y < 0.01
                    _, y, _ = localToLocal(spec.cutNode, spec.curSplitShape, 0, maxY, maxZ)
                    cutTooLow = cutTooLow or y < 0.01
                    if cutTooLow then
                        spec.curSplitShape = nil
                    end
                end
            end

            if spec.curSplitShape == nil and spec.cutTimer > -1 then
                self:setLastTreeDiameter(0)
                SpecializationUtil.raiseEvent(self, "onCutTree", 0)
                if g_server ~= nil then
                    g_server:broadcastEvent(WoodHarvesterOnCutTreeEvent.new(self, 0), nil, nil, self)
                end
            end
        else
            self:setLastTreeDiameter(self.spec_woodHarvester.lastDiameter)
            WHC.closeHead(self)
            -- The position of the tree doesn't get updated so its sometimes sitting quite far from the body but I don't see a way to fix it
        end
    end

    if self.isServer then
        if spec.tiltControl == true then
            local shouldUpdateLimit = false
            local shouldUpdateSpring = false

            if WHC.isTiltSupported(self) then
                if spec.tiltedUp == false and spec.forcedTiltDown == true then
                    if spec.cutReleasedComponentJointRotLimitX ~= spec.tiltMaxRot then
                        spec.cutReleasedComponentJointRotLimitX = spec.tiltMaxRot
                        shouldUpdateLimit = true
                    end

                    if spec.cutReleasedComponentJointRotLimitXNegative ~= spec.tiltMaxRot then
                        spec.cutReleasedComponentJointRotLimitXNegative = math.min(spec.tiltMaxRot,
                            spec.cutReleasedComponentJointRotLimitXNegative +
                            spec.cutReleasedComponentJointRotLimitXSpeed * dt)
                        shouldUpdateLimit = true
                    end

                    if spec.currentTiltDownForce ~= spec.tiltDownForce or spec.currentTiltDownDamping ~=
                        spec.tiltDownDamping then
                        spec.currentTiltDownForce = spec.tiltDownForce
                        spec.currentTiltDownDamping = spec.tiltDownDamping
                        shouldUpdateSpring = true
                    end
                elseif spec.tiltedUp == false and not spec.forcedTiltUp then
                    if spec.cutReleasedComponentJointRotLimitXNegative ~= 0 then
                        spec.cutReleasedComponentJointRotLimitXNegative = 0
                        shouldUpdateLimit = true
                    end

                    if spec.cutReleasedComponentJointRotLimitX ~= spec.tiltMaxRot then
                        spec.cutReleasedComponentJointRotLimitX = math.min(spec.tiltMaxRot,
                            spec.cutReleasedComponentJointRotLimitX + spec.cutReleasedComponentJointRotLimitXSpeed * dt)
                        shouldUpdateLimit = true
                    end

                    if spec.currentTiltDownForce ~= WHC.DEFAULT_TILT_DOWN_FORCE or spec.currentTiltDownDamping ~=
                        WHC.DEFAULT_TILT_DOWN_DAMPING then
                        spec.currentTiltDownForce = WHC.DEFAULT_TILT_DOWN_FORCE
                        spec.currentTiltDownDamping = WHC.DEFAULT_TILT_DOWN_DAMPING
                        shouldUpdateSpring = true
                    end
                elseif spec.tiltedUp == true then
                    if spec.cutReleasedComponentJointRotLimitXNegative ~= 0 then
                        spec.cutReleasedComponentJointRotLimitXNegative = 0
                        shouldUpdateLimit = true
                    end

                    if spec.cutReleasedComponentJointRotLimitX ~= 0 then
                        spec.cutReleasedComponentJointRotLimitX =
                            math.max(0, spec.cutReleasedComponentJointRotLimitX -
                                spec.cutReleasedComponentJointRotLimitXSpeed * dt)
                        shouldUpdateLimit = true
                    end

                    if spec.currentTiltDownForce ~= WHC.DEFAULT_TILT_DOWN_FORCE or spec.currentTiltDownDamping ~=
                        WHC.DEFAULT_TILT_DOWN_DAMPING then
                        spec.currentTiltDownForce = WHC.DEFAULT_TILT_DOWN_FORCE
                        spec.currentTiltDownDamping = WHC.DEFAULT_TILT_DOWN_DAMPING
                        shouldUpdateSpring = true
                    end
                end

                if shouldUpdateLimit then
                    setJointRotationLimit(spec.cutReleasedComponentJoint.jointIndex, 0, true,
                        spec.cutReleasedComponentJointRotLimitXNegative, spec.cutReleasedComponentJointRotLimitX)
                end
                if shouldUpdateSpring then
                    setJointRotationLimitSpring(spec.cutReleasedComponentJoint.jointIndex, 0, spec.currentTiltDownForce,
                        spec.currentTiltDownDamping)
                end
            end
        else
            if spec.attachedSplitShape == nil then
                if spec.cutReleasedComponentJoint ~= nil and spec.cutReleasedComponentJointRotLimitX ~= 0 then
                    spec.cutReleasedComponentJointRotLimitX =
                        math.max(0, spec.cutReleasedComponentJointRotLimitX -
                            spec.cutReleasedComponentJointRotLimitXSpeed * dt)
                    setJointRotationLimit(spec.cutReleasedComponentJoint.jointIndex, 0, true, 0,
                        spec.cutReleasedComponentJointRotLimitX)
                end
            end
        end

        if spec.rotatorMode == WHC.ROTATOR_FREE then
            if spec.attachedSplitShape == nil then
                if spec.cutReleasedComponentJoint2 ~= nil and spec.cutReleasedComponentJoint2RotLimitX ~= 0 then
                    spec.cutReleasedComponentJoint2RotLimitX = math.max(
                        spec.cutReleasedComponentJoint2RotLimitX - spec.cutReleasedComponentJoint2RotLimitXSpeed * dt, 0)
                    setJointRotationLimit(spec.cutReleasedComponentJoint2.jointIndex, 0, true,
                        -spec.cutReleasedComponentJoint2RotLimitX, spec.cutReleasedComponentJoint2RotLimitX)
                end
            end
        end
    end

    if self.isServer then
        if spec.automaticFeedingOption == true and spec.automaticFeedingStarted == true then
            if spec.autoProgramFeeding ~= WHC.AUTO_HOLD then
                if spec.registerFound == false then
                    if spec.hasAttachedSplitShape then
                        if not spec.isAttachedSplitShapeMoving and not spec.isSawOut then
                            spec.autoFeedingTimer = spec.autoFeedingTimer + dt
                            if spec.autoFeedingTimer > spec.autoFeedingDelay then
                                if spec.repeatLengthPreset then
                                    WHC.findRegister(self, spec.currentLengthPreset)
                                else
                                    WHC.findRegister(self)
                                end
                                spec.autoFeedingTimer = -1
                            end
                        end
                    end
                end
            end
        end
    end

    if self.isClient then
        local actionEvent = spec.actionEvents[InputAction.IMPLEMENT_EXTRA2]
        if actionEvent ~= nil then
            if spec.autoProgramWithCut == true then
                g_inputBinding:setActionEventText(actionEvent.actionEventId,
                    g_i18n:getText("action_feedCutAutomaticProgram"))
            elseif not spec.isAttachedSplitShapeMoving then
                g_inputBinding:setActionEventText(actionEvent.actionEventId, g_i18n:getText("action_saw"))
            end
        end
    end
end

function WoodHarvesterControls:cutTree(superFunc, length, noEventSend)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, length, noEventSend)
        return
    end

    length = length or 0
    WoodHarvesterCutTreeEvent.sendEvent(self, length, noEventSend)
end

function WoodHarvesterControls:onCutTree(superFunc, radius)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, radius)
        return
    end

    local spec = self.spec_woodHarvester
    if radius > 0 then
        spec.hasAttachedSplitShape = true
        if self.isServer then
            self:setLastTreeDiameter(2 * radius)
            WHC.closeHead(self)
        end
    else
        spec.cutTimer = -1
        if spec.currentSawMode == WHC.SAW_AUTO then
            WHC.raiseSaw(self)
        end

        if spec.hasAttachedSplitShape == true then
            spec.hasAttachedSplitShape = false
            if self.isServer then
                spec.tempDiameter = 0
                spec.referenceCutDone = false
                spec.automaticFeedingStarted = false
                spec.autoProgramStarted = false
                spec.currentAssortmentIndex = nil
                spec.lastAssortment = nil

                if WHC.isTiltSupported(self) and spec.tiltedUp == false and spec.automaticTiltUp == true and
                    spec.tiltedUpOnCut then
                    spec.tiltedUp = true
                    spec.tiltedUpOnCut = false
                end

                if spec.automaticOpen == false then
                    if spec.isHeadClosed then
                        WHC.closeHead(self)
                    end
                else
                    spec.isHeadClosed = false
                    WHC.openHead(self)
                end
            end
        end
    end
end

function WoodHarvesterControls:whcUpdateSettings(settings, noEventSend)
    WoodHarvesterControlsUpdateSettingsEvent.sendEvent(self, settings, noEventSend)

    local spec = self.spec_woodHarvester

    spec.autoProgramWithCut = settings.autoProgramWithCut
    spec.automaticTiltUp = settings.automaticTiltUp
    if self.isServer and settings.automaticOpen and spec.automaticOpen == false and spec.attachedSplitShape == nil then
        WHC.detachTree(self)
    end
    spec.automaticOpen = settings.automaticOpen
    spec.grabOnCut = settings.grabOnCut

    spec.numberOfAssortments = settings.numberOfAssortments
    for i = 1, 4 do
        spec.bucking[i].minDiameter = settings.bucking[i].minDiameter
        spec.bucking[i].length = settings.bucking[i].length
    end

    spec.autoProgramFeeding = settings.autoProgramFeeding
    spec.autoProgramFellingCut = settings.autoProgramFellingCut
    spec.autoProgramBuckingCut = settings.autoProgramBuckingCut
    spec.autoProgramWithClose = settings.autoProgramWithClose
    spec.automaticFeedingOption = settings.automaticFeedingOption

    spec.rotatorMode = settings.rotatorMode
    spec.rotatorRotLimitForceLimit = settings.rotatorRotLimitForceLimit
    spec.rotatorThreshold = settings.rotatorThreshold

    spec.sawMode = settings.sawMode

    for i = 1, 6 do
        spec["lengthPreset" .. i] = settings["lengthPreset" .. i]
    end
    spec.repeatLengthPreset = settings.repeatLengthPreset

    spec.breakingDistance = settings.breakingDistance
    spec.slowFeedingTiltedUp = settings.slowFeedingTiltedUp
    spec.feedingSpeed = settings.feedingSpeed
    spec.slowFeedingSpeed = settings.slowFeedingSpeed

    spec.tiltDownOnFellingCut = settings.tiltDownOnFellingCut
    spec.tiltUpWithOpenButton = settings.tiltUpWithOpenButton
    spec.tiltUpDelay = settings.tiltUpDelay
    spec.tiltMaxRot = settings.tiltMaxRot

    spec.registerSound = settings.registerSound
    spec.maxRemovingLength = settings.maxRemovingLength
    spec.maxRemovingDiameter = settings.maxRemovingDiameter
    spec.allSplitType = settings.allSplitType

    if self.isServer then
        WHC.updateRotatorMode(self)
    end
end

function WoodHarvesterControls:updateRotatorMode()
    local spec = self.spec_woodHarvester

    if spec.cutReleasedComponentJoint2 ~= nil then
        if spec.rotatorMode == WHC.ROTATOR_FREE then
            setJointRotationLimitForceLimit(spec.cutReleasedComponentJoint2.jointIndex, 0,
                spec.rotatorOriginalRotLimitForce)
            if spec.attachedSplitShape ~= nil then
                spec.cutReleasedComponentJoint2RotLimitX = math.pi * 0.9
                if spec.cutReleasedComponentJoint2.jointIndex ~= 0 then
                    setJointRotationLimit(spec.cutReleasedComponentJoint2.jointIndex, 0, true,
                        -spec.cutReleasedComponentJoint2RotLimitX, spec.cutReleasedComponentJoint2RotLimitX)
                end
            end
        elseif spec.rotatorMode == WHC.ROTATOR_FIXED then
            setJointRotationLimitForceLimit(spec.cutReleasedComponentJoint2.jointIndex, 0,
                spec.rotatorOriginalRotLimitForce)
        elseif spec.rotatorMode == WHC.ROTATOR_PHYSICAL then
            setJointRotationLimitForceLimit(spec.cutReleasedComponentJoint2.jointIndex, 0,
                spec.rotatorRotLimitForceLimit)

            if spec.cutReleasedComponentJoint2RotLimitX ~= 0 then
                spec.cutReleasedComponentJoint2RotLimitX = 0
                setJointRotationLimit(spec.cutReleasedComponentJoint2.jointIndex, 0, true,
                    -spec.cutReleasedComponentJoint2RotLimitX, spec.cutReleasedComponentJoint2RotLimitX)
            end
        end
    end
end

function WoodHarvesterControls:setDelimbStatus(speed, manualFeedingForward, manualFeedingBackward, noEventSend)
    if speed == nil then
        speed = 0
    end
    if manualFeedingForward == nil then
        manualFeedingForward = false
    end
    if manualFeedingBackward == nil then
        manualFeedingBackward = false
    end

    local spec = self.spec_woodHarvester

    spec.isAttachedSplitShapeMoving = false
    spec.currentFeedingSpeed = 0
    spec.manualFeedingForward = false
    spec.manualFeedingBackward = false

    if not spec.isSawOut then
        if speed > 0 then
            spec.isAttachedSplitShapeMoving = true
            if spec.slowFeedingTiltedUp and (WHC.isTiltedUp(self) or WHC.isStandingTreeAttached(self)) then
                spec.currentFeedingSpeed = spec.slowFeedingSpeed
            else
                spec.currentFeedingSpeed = speed
            end
        end

        if manualFeedingForward then
            spec.manualFeedingForward = true
        elseif manualFeedingBackward then
            spec.manualFeedingBackward = true
        end
    end

    if manualFeedingForward or manualFeedingBackward then
        spec.automaticFeedingStarted = false
        spec.autoProgramStarted = false
    end
end

function WoodHarvesterControls:findRegister(desiredLength, noEventSend)
    desiredLength = desiredLength or 0

    local spec = self.spec_woodHarvester
    local assortmentDefined = false
    local length = spec.currentCutLength
    spec.currentAssortmentIndex = nil

    if (desiredLength == 0) then
        for index, assortment in pairs(spec.bucking) do
            local minDiameter = assortment.minDiameter or 0

            if index == spec.numberOfAssortments then
                minDiameter = 0
            end

            if assortment.length ~= nil and minDiameter < spec.lastDiameter then
                spec.currentAssortmentIndex = index
                length = assortment.length
                break
            end
        end
        spec.currentLengthPreset = 0
    else
        length = desiredLength
        spec.currentLengthPreset = length
    end

    spec.attachedSplitShapeTargetY = spec.attachedSplitShapeLastCutY + length * spec.cutAttachDirection
    spec.currentCutLength = length

    WHC.setDelimbStatus(self, spec.feedingSpeed, false, false)
end

function WoodHarvesterControls:whcHandleRegisterSound(newRegister, noEventSend)
    local spec = self.spec_woodHarvester

    WoodHarvesterControlsRegisterSoundEvent.sendEvent(self, newRegister, noEventSend)

    if self.isClient then
        local isEntered = false

        if self.getIsEntered ~= nil then
            isEntered = self:getIsEntered()
        elseif self.getAttacherVehicle ~= nil then
            local parentVehicle = self:getAttacherVehicle()
            while parentVehicle.getAttacherVehicle ~= nil do
                parentVehicle = parentVehicle:getAttacherVehicle()
            end
            if parentVehicle.getIsEntered ~= nil then
                isEntered = parentVehicle:getIsEntered()
            end
        end

        if isEntered then
            local sample = WoodHarvesterControls.registerFoundSample

            if newRegister then
                sample = WoodHarvesterControls.assortmentChangedSample
            end

            if spec.registerSound then
                playSample(sample, 1, 0.2, 0, 0, 0)
            end
        end
    end
end

function WoodHarvesterControls:onRegisterFound()
    local spec = self.spec_woodHarvester
    if spec.registerFound == true then
        return
    end

    spec.registerFound = true
    if spec.automaticFeedingOption == true and spec.automaticFeedingStarted == false then
        spec.automaticFeedingStarted = true
    end

    local newRegister = spec.lastAssortment ~= nil and spec.lastAssortment ~= spec.currentAssortmentIndex

    self:whcHandleRegisterSound(newRegister)

    if spec.lastAssortment ~= nil and spec.lastAssortment ~= spec.currentAssortmentIndex then
        spec.autoProgramHoldTimer = -1
        spec.autoProgramTransitionTimer = -1
    end

    spec.lastAssortment = spec.currentAssortmentIndex
end

function WoodHarvesterControls:lowerSaw(mode)
    local spec = self.spec_woodHarvester

    if spec.isAttachedSplitShapeMoving then
        return
    end

    if mode == WHC.SAW_AUTO and spec.attachedSplitShape == nil and spec.curSplitShape == nil then
        return
    end

    spec.currentSawMode = mode

    if spec.currentSawMode == WHC.SAW_SENSOR then
        spec.registerFound = true
    else
        spec.referenceCutDone = true
        spec.registerFound = false
        spec.attachedSplitShapeLastCutY = spec.attachedSplitShapeY
        spec.attachedSplitShapeStartY = spec.attachedSplitShapeY
        spec.attachedSplitShapeTargetY = spec.attachedSplitShapeY
        spec.currentLength = 0
    end

    if not spec.isAttachedSplitShapeMoving then
        spec.cutTimer = 100
        WHC.playAnimationForward(self, AnimationKey.SAW, spec.cutSawSpeedMultiplier)
        spec.isSawOut = true
        spec.playCutSound = true
    end
end

function WoodHarvesterControls:raiseSaw()
    local spec = self.spec_woodHarvester

    if spec.isSawOut == false then
        return
    end

    spec.currentSawMode = nil
    WHC.playAnimationBackwards(self, AnimationKey.SAW, spec.sawSpeedMultiplier)
    spec.playCutSound = false
end

function WoodHarvesterControls:woodHarvesterSplitShapeCallback(superFunc, shape, isBelow, isAbove, minY, maxY, minZ,
                                                               maxZ)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, shape, isBelow, isAbove, minY, maxY, minZ, maxZ)
        return
    end

    local spec = self.spec_woodHarvester

    g_currentMission:addKnownSplitShape(shape)
    g_treePlantManager:addingSplitShape(shape, self.shapeBeingCut, self.shapeBeingCutIsTree)

    if isAbove and not isBelow then
        if spec.grabOnCut then
            spec.isHeadClosed = true
        end

        if spec.isHeadClosed then
            WHC.attachShape(self, shape, minY, maxY, minZ, maxZ)

            spec.referenceCutDone = true

            if spec.tiltControl ~= true then
                if spec.cutReleasedComponentJoint ~= nil then
                    spec.cutReleasedComponentJointRotLimitX = math.pi * 0.9
                    if spec.cutReleasedComponentJoint.jointIndex ~= 0 then
                        setJointRotationLimit(spec.cutReleasedComponentJoint.jointIndex, 0, true, 0,
                            spec.cutReleasedComponentJointRotLimitX)
                    end
                end
            else
                if WHC.isTiltedUp(self) and spec.tiltDownOnFellingCut then
                    spec.tiltedUpOnCut = true
                    spec.tiltedUp = false
                end
            end

            if spec.rotatorMode == WHC.ROTATOR_FREE then
                if spec.cutReleasedComponentJoint2 ~= nil then
                    spec.cutReleasedComponentJoint2RotLimitX = math.pi * 0.9
                    if spec.cutReleasedComponentJoint2.jointIndex ~= 0 then
                        setJointRotationLimit(spec.cutReleasedComponentJoint2.jointIndex, 0, true,
                            -spec.cutReleasedComponentJoint2RotLimitX, spec.cutReleasedComponentJoint2RotLimitX)
                    end
                end
            end

            local radius = ((maxY - minY) + (maxZ - minZ)) / 4
            SpecializationUtil.raiseEvent(self, "onCutTree", radius)
            if g_server ~= nil then
                g_server:broadcastEvent(WoodHarvesterOnCutTreeEvent.new(self, radius), nil, nil, self)
            end
        end
    end

    if spec.maxRemovingLength > 0 and isBelow and not isAbove then
        local sizeX, sizeY, sizeZ, _, _ = getSplitShapeStats(shape)
        local maxSize = math.max(sizeX, sizeY, sizeZ)
        if maxSize < spec.maxRemovingLength then
            delete(shape)
        end
    elseif spec.maxRemovingDiameter > 0 then
        local sizeX, sizeY, sizeZ, _, _ = getSplitShapeStats(shape)
        local minSize = math.min(sizeX, sizeY, sizeZ)
        if minSize < spec.maxRemovingDiameter then
            delete(shape)
            spec.attachedSplitShape = nil
        end
    end
end

function WoodHarvesterControls:attachShape(shape, minY, maxY, minZ, maxZ)
    local spec = self.spec_woodHarvester

    if spec.attachedSplitShape == nil and spec.cutAttachNode ~= nil and spec.cutAttachReferenceNode ~= nil then
        spec.attachedSplitShape = shape
        spec.lastTreeSize = { minY, maxY, minZ, maxZ }

        local treeCenterX, treeCenterY, treeCenterZ = localToWorld(spec.cutNode, 0, (minY + maxY) * 0.5,
            (minZ + maxZ) * 0.5)

        if spec.loadedSplitShapeFromSavegame then
            if spec.lastTreeJointPos ~= nil then
                treeCenterX, treeCenterY, treeCenterZ = localToWorld(shape, unpack(spec.lastTreeJointPos))
            end

            spec.loadedSplitShapeFromSavegame = false
        end
        spec.lastTreeJointPos = { worldToLocal(shape, treeCenterX, treeCenterY, treeCenterZ) }

        local x, y, z = localToWorld(spec.cutAttachReferenceNode, 0, 0, (maxZ - minZ) * 0.5)

        local dx, dy, dz = localDirectionToWorld(shape, 0, 0, 1)

        local _, treeYDirection, _ = localDirectionToLocal(shape, spec.cutAttachReferenceNode, 0, 1, 0)
        spec.cutAttachDirection = treeYDirection > 0 and 1 or -1

        local upx, upy, upz = localDirectionToWorld(spec.cutAttachReferenceNode, 0, spec.cutAttachDirection, 0)
        local sideX, sideY, sizeZ = MathUtil.crossProduct(upx, upy, upz, dx, dy, dz)
        dx, dy, dz = MathUtil.crossProduct(sideX, sideY, sizeZ, upx, upy, upz)
        I3DUtil.setWorldDirection(spec.cutAttachHelperNode, dx, dy, dz, upx, upy, upz, 2)

        local constr = JointConstructor.new()
        constr:setActors(spec.cutAttachNode, shape)

        constr:setJointTransforms(spec.cutAttachHelperNode, shape)
        constr:setJointWorldPositions(x, y, z, treeCenterX, treeCenterY, treeCenterZ)

        constr:setRotationLimit(0, 0, 0)
        constr:setRotationLimit(1, 0, 0)
        constr:setRotationLimit(2, 0, 0)

        constr:setEnableCollision(false)

        spec.attachedSplitShapeJointIndex = constr:finalize()

        spec.attachedSplitShapeX, spec.attachedSplitShapeY, spec.attachedSplitShapeZ =
            worldToLocal(shape, treeCenterX, treeCenterY, treeCenterZ)
        spec.attachedSplitShapeLastCutY = spec.attachedSplitShapeY
        spec.attachedSplitShapeStartY = spec.attachedSplitShapeY
        spec.attachedSplitShapeTargetY = spec.attachedSplitShapeY
        spec.currentLength = 0

        spec.hasAttachedSplitShape = true
    end
end

function WoodHarvesterControls:setLastTreeDiameter(superFunc, diameter, noEventSend)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, diameter, noEventSend)
        return
    end

    local spec = self.spec_woodHarvester
    spec.lastDiameter = diameter
    if self.isServer then
        spec.tempDiameter = diameter
    end

    WoodHarvesterControlsSetDiameterEvent.sendEvent(self, diameter, noEventSend)
end

function WoodHarvesterControls:getDoConsumePtoPower(superFunc)
    if not self.spec_woodHarvesterControls.enabled then
        return superFunc(self)
    end

    local spec = self.spec_woodHarvester
    return superFunc(self) or self:getIsTurnedOn()
end

function WoodHarvesterControls:onRegisterActionEvents(superFunc, isActiveForInput, isActiveForInputIgnoreSelection)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, isActiveForInput, isActiveForInputIgnoreSelection)
        return
    end

    if self.isClient then
        local spec = self.spec_woodHarvester
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            for _, action in pairs(Actions) do
                local actionName = action.name
                local triggerUp = action.triggerUp ~= nil and action.triggerUp or false
                local triggerDown = action.triggerDown ~= nil and action.triggerDown or true
                local triggerAlways = action.triggerAlways ~= nil and action.triggerAlways or false
                local startActive = action.startActive ~= nil and action.startActive or true
                local _, eventName = self:addActionEvent(spec.actionEvents, actionName, self,
                    WoodHarvesterControls.onActionCall, triggerUp, triggerDown, triggerAlways, startActive, nil)

                if g_inputBinding ~= nil and g_inputBinding.events ~= nil and g_inputBinding.events[eventName] ~= nil then
                    if action.priority ~= nil then
                        g_inputBinding:setActionEventTextPriority(eventName, action.priority)
                    end

                    if action.text ~= nil then
                        g_inputBinding:setActionEventText(eventName, action.text)
                    end
                end
            end
        end
    end
end

function WoodHarvesterControls:onActionCall(actionName, keyStatus, callbackStatus, isAnalog, arg6)
    local spec = self.spec_woodHarvester

    if actionName == ActionName.TURN_ON_OFF_HEAD then
        WHC.onPowerToggleButton(self)
        return
    end

    if not self:getIsTurnedOn() then
        g_currentMission:showBlinkingWarning(g_i18n:getText("warning_turnOnHead"), 2000)
        return
    end

    if actionName == ActionName.DEFAULT_MENU or actionName == ActionName.MENU then
        WHC.onMenuButton(self)
        return
    end

    if actionName == ActionName.LENGTH_PRESET_1 then
        if g_time - spec.lastPreset1Time < spec.doublePressPresetTime then
            self:whcOnButtonPressed(Button.LENGTH_PRESET_1, true)
        else
            self:whcOnButtonPressed(Button.LENGTH_PRESET_1, false)
        end
        spec.lastPreset1Time = g_time
        return
    end
    if actionName == ActionName.LENGTH_PRESET_2 then
        if g_time - spec.lastPreset2Time < spec.doublePressPresetTime then
            self:whcOnButtonPressed(Button.LENGTH_PRESET_2, true)
        else
            self:whcOnButtonPressed(Button.LENGTH_PRESET_2, false)
        end
        spec.lastPreset2Time = g_time
        return
    end
    if actionName == ActionName.LENGTH_PRESET_3 then
        if g_time - spec.lastPreset3Time < spec.doublePressPresetTime then
            self:whcOnButtonPressed(Button.LENGTH_PRESET_3, true)
        else
            self:whcOnButtonPressed(Button.LENGTH_PRESET_3, false)
        end
        spec.lastPreset3Time = g_time
        return
    end

    local buttonId = ActionButtonMapping[actionName]

    if buttonId then
        local isButtonDown = keyStatus > 0
        self:whcOnButtonPressed(buttonId, isButtonDown)
        return
    end
end

function WoodHarvesterControls:actionEventCutTree(superFunc, actionName, inputValue, callbackState, isAnalog)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, actionName, inputValue, callbackState, isAnalog)
        return
    end
end

function WoodHarvesterControls:onSawButton(isButtonDown)
    local spec = self.spec_woodHarvester

    if isButtonDown then
        local automaticProgramOk = false
        if spec.autoProgramWithCut then
            automaticProgramOk = WHC.runAutomaticProgram(self, isButtonDown)
        end

        if automaticProgramOk == false then
            if spec.sawMode == WHC.MANUAL then
                WHC.lowerSaw(self, WHC.SAW_MANUAL)
            elseif spec.sawMode == WHC.SEMIAUTOMATIC and
                (WHC.isTiltedUp(self) or WHC.isStandingTreeAttached(self) or WHC.isStandingTreeInRange(self)) then
                WHC.lowerSaw(self, WHC.SAW_MANUAL)
            else
                WHC.lowerSaw(self, WHC.SAW_AUTO)
            end
        end
    else
        local automaticProgramOk = false
        if spec.autoProgramWithCut then
            automaticProgramOk = WHC.runAutomaticProgram(self, isButtonDown)
        end

        if automaticProgramOk == false then
            if spec.isSawOut and (spec.currentSawMode == WHC.SAW_SENSOR or spec.currentSawMode == WHC.SAW_MANUAL) then
                WHC.raiseSaw(self)
            end
        end
    end
end

function WoodHarvesterControls:whcOnButtonPressed(buttonId, isButtonDown, noEventSend)
    WoodHarvesterControlsButtonPressEvent.sendEvent(self, buttonId, isButtonDown, noEventSend)

    if self.isServer then
        local funcName = ButtonHandlerMapping[buttonId];

        if funcName and WHC[funcName] then
            WHC[funcName](self, isButtonDown)
        end
    end
end

function WoodHarvesterControls:onTiltToggleButton(isButtonDown)
    local spec = self.spec_woodHarvester
    spec.tiltedUp = not spec.tiltedUp
end

function WoodHarvesterControls:onTiltUpButton(isButtonDown)
    local spec = self.spec_woodHarvester
    if isButtonDown then
        spec.tiltedUp = true
    end
    spec.forcedTiltUp = isButtonDown
end

function WoodHarvesterControls:onTiltDownButton(isButtonDown)
    local spec = self.spec_woodHarvester
    if not spec.tiltedUp then
        spec.forcedTiltDown = isButtonDown
    end
    spec.tiltedUp = false
end

function WoodHarvesterControls:onGrabToggleButton(isButtonDown)
    local spec = self.spec_woodHarvester
    if isButtonDown then
        if spec.isHeadClosed == true then
            WHC.detachTree(self)
            spec.openHoldTimer = 0
        else
            WHC.attachTree(self)
        end
    else
        spec.openHoldTimer = -1
    end
end

function WoodHarvesterControls:onGrabCloseButton(isButtonDown)
    local spec = self.spec_woodHarvester
    if spec.isHeadClosed then
        if spec.autoProgramWithClose then
            WHC.runAutomaticProgram(self, isButtonDown)
        end
    else
        if isButtonDown then
            spec.closeHoldTimer = 0
            WHC.closeKnives(self)
        else
            spec.closeHoldTimer = -1
            WHC.stopClosingHead(self)
        end
    end
end

function WoodHarvesterControls:onGrabOpenButton(isButtonDown)
    local spec = self.spec_woodHarvester
    if isButtonDown then
        if spec.isHeadClosed then
            WHC.detachTree(self)
        else
            WHC.openHead(self)
        end
        spec.openHoldTimer = 0
    else
        spec.openHoldTimer = -1
    end
end

function WoodHarvesterControls:onForwardFeedButton(isButtonDown)
    local spec = self.spec_woodHarvester

    if isButtonDown then
        WHC.setDelimbStatus(self, spec.feedingSpeed, true, false)
    else
        WHC.setDelimbStatus(self, 0, false, false)
    end
end

function WoodHarvesterControls:onBackwardFeedButton(isButtonDown)
    local spec = self.spec_woodHarvester

    if isButtonDown then
        WHC.setDelimbStatus(self, spec.feedingSpeed, false, true)
    else
        WHC.setDelimbStatus(self, 0, false, false)
    end
end

function WoodHarvesterControls:onSlowForwardFeedButton(isButtonDown)
    local spec = self.spec_woodHarvester

    if isButtonDown then
        WHC.setDelimbStatus(self, spec.slowFeedingSpeed, true, false)
    else
        WHC.setDelimbStatus(self, 0, false, false)
    end
end

function WoodHarvesterControls:onSlowBackwardFeedButton(isButtonDown)
    local spec = self.spec_woodHarvester

    if isButtonDown then
        WHC.setDelimbStatus(self, spec.slowFeedingSpeed, false, true)
    else
        WHC.setDelimbStatus(self, 0, false, false)
    end
end

function WoodHarvesterControls:onMenuButton()
    local spec = self.spec_woodHarvester
    WoodHarvesterControls_Main.ui_menu:setVehicle(self)
    g_gui:showDialog("WoodHarvesterControls_UI")
end

function WoodHarvesterControls:onPowerToggleButton()
    TurnOnVehicle.actionEventTurnOn(self)
end

function WoodHarvesterControls:onAutomaticProgramButton(isButtonDown)
    WHC.runAutomaticProgram(self, isButtonDown)
end

function WoodHarvesterControls:onStopButton(isButtonDown)
    if isButtonDown then
        WHC.stopHead(self)
    end
end

function WoodHarvesterControls:stopHead()
    local spec = self.spec_woodHarvester

    WHC.setDelimbStatus(self, 0)

    spec.automaticFeedingStarted = false
    spec.autoProgramStarted = false
end

function WoodHarvesterControls:onPreset1Button(isDoublePress)
    local spec = self.spec_woodHarvester

    if isDoublePress then
        WHC.findRegister(self, spec.lengthPreset2)
    else
        WHC.findRegister(self, spec.lengthPreset1)
    end
end

function WoodHarvesterControls:onPreset2Button(isDoublePress)
    local spec = self.spec_woodHarvester

    if isDoublePress then
        WHC.findRegister(self, spec.lengthPreset4)
    else
        WHC.findRegister(self, spec.lengthPreset3)
    end
end

function WoodHarvesterControls:onPreset3Button(isDoublePress)
    local spec = self.spec_woodHarvester

    if isDoublePress then
        WHC.findRegister(self, spec.lengthPreset6)
    else
        WHC.findRegister(self, spec.lengthPreset5)
    end
end

function WoodHarvesterControls:runAutomaticProgram(isButtonDown)
    local spec = self.spec_woodHarvester

    if isButtonDown then
        if WHC.isTiltedUp(self) or WHC.isStandingTreeAttached(self) or WHC.isStandingTreeInRange(self) then
            if spec.autoProgramFellingCut == WHC.AUTO_PUSH then
                WHC.lowerSaw(self, WHC.SAW_AUTO)
                return true
            elseif spec.autoProgramFellingCut == WHC.AUTO_HOLD then
                WHC.lowerSaw(self, WHC.SAW_SENSOR)
                return true
            end
        elseif spec.attachedSplitShape == nil or spec.referenceCutDone == false then
            if spec.autoProgramBuckingCut == WHC.AUTO_PUSH then
                WHC.lowerSaw(self, WHC.SAW_AUTO)
                return true
            elseif spec.autoProgramBuckingCut == WHC.AUTO_HOLD then
                WHC.lowerSaw(self, WHC.SAW_SENSOR)
                return true
            end
        elseif spec.attachedSplitShape ~= nil then
            spec.autoProgramHoldTimer = 0
            if spec.registerFound then
                if spec.autoProgramBuckingCut == WHC.AUTO_HOLD then
                    WHC.lowerSaw(self, WHC.SAW_SENSOR)
                    return true
                elseif spec.autoProgramBuckingCut == WHC.AUTO_PUSH then
                    WHC.lowerSaw(self, WHC.SAW_AUTO)
                    return true
                end
            else
                spec.autoProgramStarted = true
                if spec.autoProgramFeeding == WHC.AUTO_HOLD then
                    WHC.findRegister(self)
                    return true
                elseif spec.autoProgramFeeding == WHC.AUTO_PUSH then
                    WHC.setDelimbStatus(self, 0, false, false)
                    spec.automaticFeedingStarted = false
                    return true
                end
            end
        end
    else
        spec.autoProgramHoldTimer = -1
        spec.autoProgramTransitionTimer = -1
        if spec.isSawOut then
            if spec.currentSawMode == WHC.SAW_SENSOR then
                WHC.raiseSaw(self)
                return true
            end
        else
            if spec.autoProgramFeeding == WHC.AUTO_HOLD then
                if spec.isAttachedSplitShapeMoving then
                    WHC.setDelimbStatus(self, 0, false, false)
                    return true
                end
            elseif spec.autoProgramFeeding == WHC.AUTO_PUSH then
                if not spec.registerFound and spec.autoProgramStarted then
                    WHC.findRegister(self)
                    return true
                end
            end
        end
    end

    return false
end

function WoodHarvesterControls:attachTree(noEventSend)
    local spec = self.spec_woodHarvester

    spec.isHeadClosed = true

    if self.isServer then
        local offset = 0

        if spec.curSplitShape == nil then
            offset = spec.headHeight / 2
            self:findSplitShapesInRange(offset)
        end

        if spec.curSplitShape ~= nil then
            local x, y, z = localToWorld(spec.cutNode, offset, 0, 0)
            local nx, ny, nz = localDirectionToWorld(spec.cutNode, 1, 0, 0)
            local yx, yy, yz = localDirectionToWorld(spec.cutNode, 0, 1, 0)
            local minY, maxY, minZ, maxZ = testSplitShape(spec.curSplitShape, x, y, z, nx, ny, nz, yx, yy, yz,
                spec.cutSizeY, spec.cutSizeZ)
            if minY ~= nil and minY ~= 0 then
                self:setLastTreeDiameter(math.max(maxY - minY, maxZ - minZ))
                WHC.attachShape(self, spec.curSplitShape, minY, maxY, minZ, maxZ)
                WHC.closeHead(self)
            end

            spec.curSplitShape = nil
        else
            WHC.closeHead(self)
        end
    end
end

function WoodHarvesterControls:detachTree()
    local spec = self.spec_woodHarvester

    spec.isHeadClosed = false

    spec.referenceCutDone = false
    spec.automaticFeedingStarted = false
    spec.autoProgramStarted = false
    spec.currentAssortmentIndex = nil
    spec.lastAssortment = nil

    spec.curSplitShape = nil
    spec.hasAttachedSplitShape = false
    spec.isAttachedSplitShapeMoving = false

    if spec.attachedSplitShapeJointIndex ~= nil then
        removeJoint(spec.attachedSplitShapeJointIndex)
        spec.attachedSplitShapeJointIndex = nil
        spec.attachedSplitShape = nil

        self:setLastTreeDiameter(0)

        SpecializationUtil.raiseEvent(self, "onCutTree", 0)
        if g_server ~= nil then
            g_server:broadcastEvent(WoodHarvesterOnCutTreeEvent.new(self, 0), nil, nil, self)
        end
    end

    if WHC.isTiltSupported(self) and spec.tiltedUp == false and spec.automaticTiltUp == true and spec.tiltedUpOnCut then
        spec.tiltedUp = true
        spec.tiltedUpOnCut = false
    end

    WHC.openHead(self)

    self:whcHandleDelimbEffects(false, false)
    self:whcHandleCutEffects(false, false)
end

function WoodHarvesterControls:onDeactivate()
    local spec = self.spec_woodHarvester
    spec.curSplitShape = nil
end

function WoodHarvesterControls:onTurnedOn(superFunc)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self)
        return
    end

    if not self.isServer then
        return
    end

    local spec = self.spec_woodHarvester

    if spec.automaticOpen and spec.attachedSplitShape == nil then
        WHC.openHead(self)
    end
end

function WoodHarvesterControls:onTurnedOff(superFunc)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self)
        return
    end

    if not self.isServer then
        return
    end

    local spec = self.spec_woodHarvester

    if spec.automaticOpen and spec.attachedSplitShape == nil then
        WHC.closeHead(self)
    end

    self:whcHandleDelimbEffects(false, false, false)
    self:whcHandleCutEffects(false, false)
end

function WoodHarvesterControls:getCanSplitShapeBeAccessed(superFunc, x, z, shape)
    return superFunc(self, x, z, shape)
end

function WoodHarvesterControls:findSplitShapesInRange(superFunc, yOffset, skipCutAnimation)
    if not self.spec_woodHarvesterControls.enabled then
        superFunc(self, yOffset, skipCutAnimation)
        return
    end

    local spec = self.spec_woodHarvester
    if spec.attachedSplitShape == nil and spec.cutNode ~= nil then
        local x, y, z = localToWorld(spec.cutNode, yOffset or 0, 0, 0)
        local nx, ny, nz = localDirectionToWorld(spec.cutNode, 1, 0, 0)
        local yx, yy, yz = localDirectionToWorld(spec.cutNode, 0, 1, 0)

        local shape, minY, maxY, minZ, maxZ = findSplitShape(x, y, z, nx, ny, nz, yx, yy, yz, spec.cutSizeY,
            spec.cutSizeZ)

        if shape ~= 0 then
            local splitType = g_splitShapeManager:getSplitTypeByIndex(getSplitType(shape))
            if not spec.allSplitType and (splitType == nil or not splitType.allowsWoodHarvester) then
                spec.warnInvalidTree = true
            else
                if self:getCanSplitShapeBeAccessed(x, z, shape) then
                    local treeDx, treeDy, treeDz = localDirectionToWorld(shape, 0, 1, 0)
                    local cosTreeAngle = MathUtil.dotProduct(nx, ny, nz, treeDx, treeDy, treeDz)

                    local angleLimit = 0.2617

                    local angle = 1.57079 - math.abs(math.acos(cosTreeAngle) - 1.57079)
                    if angle <= angleLimit then
                        local radius = math.max(maxY - minY, maxZ - minZ) * 0.5 * math.cos(angle)

                        if radius > spec.cutMaxRadius then
                            spec.warnInvalidTreeRadius = true

                            x, y, z = localToWorld(spec.cutNode, yOffset or 0 + 1, 0, 0)
                            shape, minY, maxY, minZ, maxZ = findSplitShape(x, y, z, nx, ny, nz, yx, yy, yz,
                                spec.cutSizeY, spec.cutSizeZ)
                            if shape ~= 0 then
                                radius = math.max(maxY - minY, maxZ - minZ) * 0.5 * math.cos(angle)

                                if radius <= spec.cutMaxRadius then
                                    spec.warnInvalidTreeRadius = false
                                    spec.warnInvalidTreePosition = true
                                end
                            end
                        else
                            spec.tempDiameter = math.max(maxY - minY, maxZ - minZ)
                            spec.curSplitShape = shape

                            if skipCutAnimation then
                                spec.cutTimer = 0
                            end
                        end
                    end
                else
                    spec.warnTreeNotOwned = true
                end
            end
        else
            spec.tempDiameter = 0
        end
    end
end

function WHC:isTiltedUp()
    local spec = self.spec_woodHarvester

    return WHC.isTiltSupported(self) and spec.tiltedUp
end

function WHC:isTiltSupported()
    local spec = self.spec_woodHarvester

    return spec.cutReleasedComponentJoint ~= nil
end

function WHC:checkAutoProgramCut(mode)
    local spec = self.spec_woodHarvester

    if (WHC.isTiltedUp(self)) then
        return spec.autoProgramFellingCut == mode
    end

    return spec.autoProgramBuckingCut == mode
end

function WHC:isStandingTreeAttached()
    local spec = self.spec_woodHarvester

    return spec.attachedSplitShape ~= nil and getRigidBodyType(spec.attachedSplitShape) == RigidBodyType.STATIC
end

function WHC:isStandingTreeInRange()
    local spec = self.spec_woodHarvester

    return spec.attachedSplitShape == nil and spec.curSplitShape ~= nil and getRigidBodyType(spec.curSplitShape) ==
        RigidBodyType.STATIC
end

function WHC:openHead()
    local spec = self.spec_woodHarvester

    if spec.advancedOpenClose == true then
        WHC.playAnimationForward(self, AnimationKey.TOP_KNIVES)
        WHC.playAnimationForward(self, AnimationKey.BOTTOM_KNIVES)
        WHC.playAnimationForward(self, AnimationKey.ROLLERS)
    else
        WHC.playAnimationForward(self, AnimationKey.DEFAULT_GRAB)
    end
end

function WHC:getMaxClosingPoint()
    local spec = self.spec_woodHarvester
    return math.min(1.0, spec.tempDiameter / 2 / spec.treeSizeMeasure.rotMaxRadius)
end

function WHC:closeKnives()
    local spec = self.spec_woodHarvester
    local targetTime = WHC.getMaxClosingPoint(self)

    if spec.advancedOpenClose == true then
        WHC.playAnimationToStopTime(self, "topGrabAnimation", targetTime)
        WHC.playAnimationToStopTime(self, "bottomGrabAnimation", targetTime)
    else
        WHC.playAnimationToStopTime(self, "grabAnimation", targetTime)
    end
end

function WHC:closeRollers()
    local spec = self.spec_woodHarvester

    if spec.advancedOpenClose == true then
        local targetTime = WHC.getMaxClosingPoint(self)
        WHC.playAnimationToStopTime(self, "rollersGrabAnimation", targetTime)
    end
end

function WHC:closeHead()
    WHC.closeKnives(self)
    WHC.closeRollers(self)
end

function WHC:stopClosingHead()
    local spec = self.spec_woodHarvester

    if spec.advancedOpenClose == true then
        WHC.stopAnimation(self, AnimationKey.TOP_KNIVES)
        WHC.stopAnimation(self, AnimationKey.BOTTOM_KNIVES)
    else
        WHC.stopAnimation(self, AnimationKey.DEFAULT_GRAB)
    end
end

function WHC:stopAnimation(animationKey)
    local spec = self.spec_woodHarvester

    if not spec[animationKey].name then
        return
    end
    local name = spec[animationKey].name

    self:stopAnimation(name)
end

function WHC:playAnimationForward(animationKey, speedFactor)
    WHC.playAnimationToStopTime(self, animationKey, 1, speedFactor)
end

function WHC:playAnimationBackwards(animationKey, speedFactor)
    WHC.playAnimationToStopTime(self, animationKey, 0, speedFactor)
end

function WHC:playAnimationToStopTime(animationKey, targetTime, speedFactor)
    local spec = self.spec_woodHarvester

    if not spec[animationKey].name or not targetTime then
        return
    end

    local name = spec[animationKey].name
    local factor = math.abs(speedFactor or 1)
    local speedScale = spec[animationKey].speedScale * factor

    if speedScale < 0 then
        targetTime = 1.0 - targetTime
    end

    local direction = 1
    local currentTime = self:getAnimationTime(name)
    if currentTime < targetTime then
        direction = speedScale > 0 and 1 or -1
    else
        direction = speedScale < 0 and 1 or -1
    end

    self:whcPlayAnimationWithEvent(name, speedScale * direction, currentTime, targetTime)
end

function WHC:whcPlayAnimationWithEvent(name, speed, animTime, targetTime, noEventSend)
    WoodHarvesterControlsPlayAnimationEvent.sendEvent(self, name, speed, animTime, targetTime, noEventSend)

    self:setAnimationStopTime(name, targetTime)

    self:playAnimation(name, speed, animTime, true)
end

function WHC.registerXMLSchema()
    local schema = Vehicle.xmlSchema
    local key = "vehicle.woodHarvesterControls"

    schema:setXMLSpecializationType("WoodHarvesterControls")

    schema:register(XMLValueType.STRING, key .. ".sawAnimation#name", "Saw animation name")
    schema:register(XMLValueType.FLOAT, key .. ".sawAnimation#speedScale", "Saw animation speed scale")
    schema:register(XMLValueType.FLOAT, key .. ".sawAnimation#maxCutDiameter", "Max cutting diameter")
    schema:register(XMLValueType.STRING, key .. ".topGrabAnimation#name", "Front grab animation name")
    schema:register(XMLValueType.FLOAT, key .. ".topGrabAnimation#speedScale", "Front grab animation speed scale")
    schema:register(XMLValueType.STRING, key .. ".bottomGrabAnimation#name", "Back grab animation name")
    schema:register(XMLValueType.FLOAT, key .. ".bottomGrabAnimation#speedScale", "Back grab animation speed scale")
    schema:register(XMLValueType.STRING, key .. ".rollersGrabAnimation#name", "Rollers grab animation name")
    schema:register(XMLValueType.FLOAT, key .. ".rollersGrabAnimation#speedScale", "Rollers grab animation speed scale")

    schema:setXMLSpecializationType()
end

function WHC.registerSavegameSchema()
    local schemaSavegame = Vehicle.xmlSchemaSavegame
    local key = ("vehicles.vehicle(?).%s.woodHarvesterControls"):format(g_woodHarvesterControlsModName)

    schemaSavegame:register(XMLValueType.BOOL, key .. "#autoProgramWithCut", "Automatic program with cut button")
    schemaSavegame:register(XMLValueType.BOOL, key .. "#automaticTiltUp", "Automatic Tilt Up")
    schemaSavegame:register(XMLValueType.BOOL, key .. "#automaticOpen", "Automatic Open")
    schemaSavegame:register(XMLValueType.BOOL, key .. "#grabOnCut", "Grab tree after cut")

    schemaSavegame:register(XMLValueType.INT, key .. "#numberOfAssortments", "Number of assortments")
    schemaSavegame:register(XMLValueType.FLOAT, key .. ".buckingSystem(?)#minDiameter", "Minimun Diameter (cm)")
    schemaSavegame:register(XMLValueType.FLOAT, key .. ".buckingSystem(?)#length", "Cutting Length (cm)")

    schemaSavegame:register(XMLValueType.INT, key .. "#autoProgramFeeding", "Automatic Program Feeding")
    schemaSavegame:register(XMLValueType.INT, key .. "#autoProgramFellingCut", "Automatic Program Felling Cut")
    schemaSavegame:register(XMLValueType.INT, key .. "#autoProgramBuckingCut", "Automatic Program Bucking Cut")
    schemaSavegame:register(XMLValueType.BOOL, key .. "#autoProgramWithClose", "Automatic program with close button")
    schemaSavegame:register(XMLValueType.BOOL, key .. "#automaticFeedingOption", "Automatic feed after cut")

    schemaSavegame:register(XMLValueType.INT, key .. "#rotatorMode", "Rotator Mode")
    schemaSavegame:register(XMLValueType.FLOAT, key .. "#rotatorRotLimitForceLimit", "Rotator Force")
    schemaSavegame:register(XMLValueType.ANGLE, key .. "#rotatorThreshold", "Rotator Threshold")

    schemaSavegame:register(XMLValueType.INT, key .. "#sawMode", "Saw mode")

    schemaSavegame:register(XMLValueType.FLOAT, key .. ".lengthPreset(?)#length", "Length Preset (cm)")
    schemaSavegame:register(XMLValueType.BOOL, key .. "#repeatLengthPreset", "Repeat length preset")

    schemaSavegame:register(XMLValueType.FLOAT, key .. "#breakingDistance", "Breaking Distance")
    schemaSavegame:register(XMLValueType.BOOL, key .. "#slowFeedingTiltedUp", "Slow feed when titled up Mode")
    schemaSavegame:register(XMLValueType.FLOAT, key .. "#feedingSpeed", "General feeding speed")
    schemaSavegame:register(XMLValueType.FLOAT, key .. "#slowFeedingSpeed", "Slow feeding speed")

    schemaSavegame:register(XMLValueType.BOOL, key .. "#tiltDownOnFellingCut", "Tilt down on felling cut")
    schemaSavegame:register(XMLValueType.BOOL, key .. "#tiltUpWithOpenButton", "Tilt up with open button")
    schemaSavegame:register(XMLValueType.FLOAT, key .. "#tiltUpDelay", "Tilt up with open button delay")
    schemaSavegame:register(XMLValueType.ANGLE, key .. "#tiltMaxRot", "Max tilt angle")

    schemaSavegame:register(XMLValueType.BOOL, key .. "#registerSound", "Register found sounds")
    schemaSavegame:register(XMLValueType.FLOAT, key .. "#maxRemovingLength", "Max removing length")
    schemaSavegame:register(XMLValueType.FLOAT, key .. "#maxRemovingDiameter", "Max removing diameter")
    schemaSavegame:register(XMLValueType.BOOL, key .. "#allSplitType", "Support all trees")
end
