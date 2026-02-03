WoodHarvesterControlsButtonPressEvent = {}
local WoodHarvesterControlsButtonPressEvent_mt = Class(WoodHarvesterControlsButtonPressEvent, Event)
local BITS_TO_SEND_BUTTON_ID = 4;

InitEventClass(WoodHarvesterControlsButtonPressEvent, "WoodHarvesterControlsButtonPressEvent")

function WoodHarvesterControlsButtonPressEvent.emptyNew()
    local self = Event.new(WoodHarvesterControlsButtonPressEvent_mt)

    return self
end

function WoodHarvesterControlsButtonPressEvent.new(object, buttonType, isHolding)
    local self = WoodHarvesterControlsButtonPressEvent.emptyNew()

    self.object = object
    self.buttonType = buttonType
    self.isHolding = isHolding

    return self
end

function WoodHarvesterControlsButtonPressEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteUIntN(streamId, self.buttonType, BITS_TO_SEND_BUTTON_ID)
    streamWriteBool(streamId, self.isHolding)
end

function WoodHarvesterControlsButtonPressEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.buttonType = streamReadUIntN(streamId, BITS_TO_SEND_BUTTON_ID)
    self.isHolding = streamReadBool(streamId)

    self:run(connection)
end

function WoodHarvesterControlsButtonPressEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent(WoodHarvesterControlsButtonPressEvent.new(self.object, self.buttonType, self.isHolding),
            nil, connection, self.object)
    end

    if self.object ~= nil and self.object:getIsSynchronized() then
        self.object:whcOnButtonPressed(self.buttonType, self.isHolding, true)
    end
end

function WoodHarvesterControlsButtonPressEvent.sendEvent(object, buttonType, isHolding, noEventSend)
    if noEventSend == nil or noEventSend == false then
        if g_server ~= nil then
            g_server:broadcastEvent(WoodHarvesterControlsButtonPressEvent.new(object, buttonType, isHolding), nil, nil,
                object)
        else
            g_client:getServerConnection():sendEvent(WoodHarvesterControlsButtonPressEvent.new(object, buttonType,
                isHolding))
        end
    end
end
