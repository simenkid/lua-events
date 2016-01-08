------------------------------------------------------------------------------
-- EventEmitter Class in Node.js Style
-- LICENSE: MIT
-- Simen Li <simenkid@gmail.com>
------------------------------------------------------------------------------
local PFX = '__lsn_'
local PFX_LEN = #PFX
local Events = { defaultMaxListeners = 10 }

setmetatable(Events, {
    __call = function (_, ...) return Events:new(...) end
})

local function rmEntry(tbl, pred)
    local x, len = 0, #tbl
    for i = 1, len do
        local trusy, idx = false, (i - x)
        if (type(pred) == 'function') then trusy = pred(tbl[idx])
        else trusy = tbl[idx] == pred
        end

        if (tbl[idx] ~= nil and trusy) then
            tbl[idx] = nil
            table.remove(tbl, idx)
            x = x + 1
        end
    end
    return tbl
end

function Events:new(obj)
    obj = obj or {}
    self.__index = self
    setmetatable(obj, self)
    obj._on = {}

    return obj
end

function Events:evTable(ev)
    if (type(self._on[ev]) ~= 'table') then self._on[ev] = {} end
    return self._on[ev]
end

function Events:getEvTable(ev)
    return self._on[ev]
end

-- ************************************************************************ --
-- ** Public APIs                                                         * --
-- ************************************************************************ --
function Events:addListener(ev, listener)
    local pfx_ev = PFX .. tostring(ev)
    local evtbl = self:evTable(pfx_ev)
    local maxLsnNum = self.currentMaxListeners or self.defaultMaxListeners
    local lsnNum = self:listenerCount(ev)
    table.insert(evtbl, listener)

    if (lsnNum > maxLsnNum) then  print('WARN: Number of ' .. string.sub(pfx_ev, PFX_LEN + 1) .. " event listeners: " .. tostring(lsnNum)) end
    return self
end

function Events:emit(ev, ...)
    local pfx_ev = PFX .. tostring(ev)
    local evtbl = self:getEvTable(pfx_ev)
    if (evtbl ~= nil) then
        for _, lsn in ipairs(evtbl) do
            local status, err = pcall(lsn, ...)
            if not (status) then print(string.sub(_, PFX_LEN + 1) .. " emit error: " .. tostring(err)) end
        end
    end

    -- one-time listener
    pfx_ev = pfx_ev .. ':once'
    evtbl = self:getEvTable(pfx_ev)

    if (evtbl ~= nil) then
        for _, lsn in ipairs(evtbl) do
            local status, err = pcall(lsn, ...)
            if not (status) then print(string.sub(_, PFX_LEN + 1) .. " emit error: " .. tostring(err)) end
        end

        rmEntry(evtbl, function (v) return v ~= nil  end)
        self._on[pfx_ev] = nil
    end
    return self
end

function Events:getMaxListeners()
    return self.currentMaxListeners or self.defaultMaxListeners
end

function Events:listenerCount(ev)
    local totalNum = 0
    local pfx_ev = PFX .. tostring(ev)
    local evtbl = self:getEvTable(pfx_ev)

    if (evtbl ~= nil) then totalNum = totalNum + #evtbl end

    pfx_ev = pfx_ev .. ':once'
    evtbl = self:getEvTable(pfx_ev)

    if (evtbl ~= nil) then totalNum = totalNum + #evtbl end

    return totalNum
end

function Events:listeners(ev)
    local pfx_ev = PFX .. tostring(ev)
    local evtbl = self:getEvTable(pfx_ev)
    local clone = {}

    if (evtbl ~= nil) then
        for i, lsn in ipairs(evtbl) do table.insert(clone, lsn) end
    end

    pfx_ev = pfx_ev .. ':once'
    evtbl = self:getEvTable(pfx_ev)

    if (evtbl ~= nil) then
        for i, lsn in ipairs(evtbl) do table.insert(clone, lsn) end
    end

    return clone
end

Events.on = Events.addListener

function Events:once(ev, listener)
    local pfx_ev = PFX .. tostring(ev) .. ':once'
    local evtbl = self:evTable(pfx_ev)
    local maxLsnNum = self.currentMaxListeners or self.defaultMaxListeners
    local lsnNum = self:listenerCount(ev)
    if (lsnNum > maxLsnNum) then print('WARN: Number of ' .. ev .. " event listeners: " .. tostring(lsnNum)) end

    table.insert(evtbl, listener)
    return self
end

function Events:removeAllListeners(ev)
    if ev ~= nil then
        local pfx_ev = PFX .. tostring(ev)
        local evtbl = self:evTable(pfx_ev)
        rmEntry(evtbl, function (v) return v ~= nil  end)

        pfx_ev = pfx_ev .. ':once'
        evtbl = self:evTable(pfx_ev)
        rmEntry(evtbl, function (v) return v ~= nil  end)
        self._on[pfx_ev] = nil
    else
        for _pfx_ev, _t in pairs(self._on) do self:removeAllListeners(string.sub(_pfx_ev, PFX_LEN + 1)) end
    end

    for _pfx_ev, _t in pairs(self._on) do
        if (#_t == 0) then self._on[_pfx_ev] = nil end
    end

    return self
end

function Events:removeListener(ev, listener)
    local pfx_ev = PFX .. tostring(ev)
    local evtbl = self:evTable(pfx_ev)
    local lsnCount = 0
    assert(listener ~= nil, "listener is nil")
    -- normal listener
    rmEntry(evtbl, listener)

    if (#evtbl == 0) then self._on[pfx_ev] = nil end

    -- emit-once listener
    pfx_ev = pfx_ev .. ':once'
    evtbl = self:evTable(pfx_ev)
    rmEntry(evtbl, listener)

    if (#evtbl == 0) then self._on[pfx_ev] = nil end
    return self
end

function Events:setMaxListeners(n)
    self.currentMaxListeners = n
    return self
end

return Events
