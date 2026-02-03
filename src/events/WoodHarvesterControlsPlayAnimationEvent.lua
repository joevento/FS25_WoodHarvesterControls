WoodHarvesterControlsPlayAnimationEvent = {}
local WoodHarvesterControlsPlayAnimationEvent_mt = Class(WoodHarvesterControlsPlayAnimationEvent, Event)

InitEventClass(WoodHarvesterControlsPlayAnimationEvent, "WoodHarvesterControlsPlayAnimationEvent")

function WoodHarvesterControlsPlayAnimationEvent.emptyNew()
    local self = Event.new(WoodHarvesterControlsPlayAnimationEvent_mt)

    return self
end

function WoodHarvesterControlsPlayAnimationEvent.new(object, name, speed, animTime, targetAnimTime)
    local self = WoodHarvesterControlsPlayAnimationEvent.emptyNew()

    self.object = object
    self.name = name
    self.speed = speed
    self.animTime = animTime
    self.targetAnimTime = targetAnimTime

    return self
end

function WoodHarvesterControlsPlayAnimationEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteString(streamId, self.name)
    streamWriteFloat32(streamId, self.speed)
    streamWriteFloat32(streamId, self.animTime)
    streamWriteFloat32(streamId, self.targetAnimTime)

end

function WoodHarvesterControlsPlayAnimationEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.name = streamReadString(streamId)
    self.speed = streamReadFloat32(streamId)
    self.animTime = streamReadFloat32(streamId)
    self.targetAnimTime = streamReadFloat32(streamId)

    self:run(connection)
end

function WoodHarvesterControlsPlayAnimationEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent(WoodHarvesterControlsPlayAnimationEvent.new(self.object, self.name, self.speed,
            self.animTime, self.targetAnimTime), nil, connection, self.object)
    end

    if self.object ~= nil and self.object:getIsSynchronized() then
        self.object:whcPlayAnimationWithEvent(self.name, self.speed, self.animTime, self.targetAnimTime, true)
    end
end

function WoodHarvesterControlsPlayAnimationEvent.sendEvent(object, name, speed, animTime, targetAnimTime, noEventSend)
    if noEventSend == nil or noEventSend == false then
        if g_server ~= nil then
            g_server:broadcastEvent(WoodHarvesterControlsPlayAnimationEvent.new(object, name, speed, animTime,
                targetAnimTime), nil, nil, object)
        else
            g_client:getServerConnection():sendEvent(WoodHarvesterControlsPlayAnimationEvent.new(object, name, speed,
                animTime, targetAnimTime))
        end
    end
end
