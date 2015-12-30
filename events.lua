------------------------------------------------------------------------------
-- EventEmitter Class in Node.js Style
-- 
-- LICENCE: MIT
-- Simen Li <simenkid@gmail.com>
------------------------------------------------------------------------------

-- .defaultMaxListeners
-- .addListener(event, listener)
-- .removeListener(event, listener)
-- .removeAllListeners([event])
-- .once(event, listener)
-- .on(event, listener)
-- .emit(event[, arg1][, arg2][, ...])
-- .setMaxListeners(n)
-- .getMaxListeners()
-- .listenerCount(event)
-- .listeners(event)


local PFX = '__lsn_'
local PFX_LEN = #PFX

local Events = { defaultMaxListeners = 10 }

setmetatable(Events, {
    __call = function (_, ...)
        return Events:new(...)
    end
})

function Events:new(obj)
    obj = obj or {}
    self.__index = self
    setmetatable(obj, self)
    obj._on = {}        -- give each obj an property of '_.on' to avoid rawget()

    print('obj: ')
    print(obj)
    print('class: ')
    print(self)
    return obj
end

function Events:evTable(ev)
    -- for i, v in pairs(self) do
    --     print(i)
    --     print(v)
    -- end
    if (type(self._on[ev]) ~= 'table') then
        self._on[ev] = {}
    end

    return self._on[ev]
end

function Events:addListener(ev, listener)
    local pfx_ev = PFX .. tostring(ev)
    local evtbl = self:evTable(pfx_ev)
    local maxLsnNum = self.currentMaxListeners or self.defaultMaxListeners

    table.insert(evtbl, listener)

    local lsnNum = #evtbl
    if (lsnNum > maxLsnNum) then
        print('WARN: Number of ' .. string.sub(_pfx_ev, 1, PFX_LEN) .. " event listeners: " .. tostring(lsnNum))
    end

    return self
end

Events.on = Events.addListener



function Events:listeners(ev)
    local pfx_ev = PFX .. tostring(ev)
    local evtbl = self:evTable(pfx_ev)

    return evtbl
end

function Events:removeListener(ev, listener)
    local pfx_ev = PFX .. tostring(ev)
    local evtbl = self:evTable(pfx_ev)

    -- normal listener
    for i, lsn in ipairs(evtbl) do
        if lsn == listener then
            table.remove(evtbl, i)
        end
    end

    if (#evtbl == 0) then
        self._on[pfx_ev] = nil
    end

    -- emit-once listener
    pfx_ev = pfx_ev .. ':once'
    evtbl = self:evTable(pfx_ev)

    for i, lsn in ipairs(evtbl) do
        if lsn == listener then
            table.remove(evtbl, i)
        end
    end

    if (#evtbl == 0) then
        self._on[pfx_ev] = nil
    end

    return self
end


function Events:removeAllListeners(ev)
    if ev ~= nil then
        local pfx_ev = PFX .. tostring(ev)
        local evtbl = self:evTable(pfx_ev)

        for i, lsn in ipairs(evtbl) do
            table.remove(evtbl, i)
        end

        pfx_ev = pfx_ev .. ':once'
        evtbl = self:evTable(pfx_ev)

        for i, lsn in ipairs(evtbl) do
            table.remove(evtbl, i)
        end

        self._on[pfx_ev] = nil
    else
        for _pfx_ev, _table in pairs(self._on) do
            self:removeAllListeners(string.sub(_pfx_ev, 1, PFX_LEN))
        end
    end

    return self
end

function Events:once(ev, listener)
    local pfx_ev = PFX .. tostring(ev) .. ':once'
    local evtbl = self:evTable(pfx_ev)

    table.insert(evtbl, listener)
    return self
end

function Events:emit(ev, ...)
    local pfx_ev = PFX .. tostring(ev)
    local evtbl = self:evTable(pfx_ev)

    for _, lsn in ipairs(evtbl) do
        local status, err = pcall(lsn, ...)
        if not (status) then
            print(string.sub(_pfx_ev, 1, PFX_LEN) .. " emit error: " .. tostring(err))
        end
    end


    -- one-time listener
    pfx_ev = pfx_ev .. ':once'
    evtbl = self:evTable(pfx_ev)

    for _, lsn in ipairs(evtbl) do
        local status, err = pcall(lsn, ...)
        if not (status) then
            print(string.sub(_pfx_ev, 1, PFX_LEN) .. " emit error: " .. tostring(err))
        end
    end

    for i, lsn in ipairs(evtbl) do
        table.remove(evtbl, i)
    end

    self._on[pfx_ev] = nil

    return self
end


function Events:setMaxListeners(n)
    self.currentMaxListeners = n

    return self
end

function Events:getMaxListeners()
    print('who: ')
    print(self)
    -- for i, v in pairs(self) do
    --     print(i)
    --     print(v)
    -- end
    local maxLsnNum = self.currentMaxListeners or self.defaultMaxListeners

    return maxLsnNum
end

function Events:listenerCount(ev)
    local totalNum = 0
    local pfx_ev = PFX .. tostring(ev)
    local evtbl = self:evTable(pfx_ev)

    totalNum = totalNum + #evtbl;

    if (#evtbl == 0) then
        self._on[pfx_ev] = nil
    end

    pfx_ev = pfx_ev .. ':once'
    evtbl = self:evTable(pfx_ev)

    totalNum = totalNum + #evtbl;

    if (#evtbl == 0) then
        self._on[pfx_ev] = nil
    end

    return totalNum
end

return Events
