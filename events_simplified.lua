------------------------------------------------------------------------------
-- EventEmitter Class in Node.js Style
-- LICENSE: MIT
-- Simen Li <simenkid@gmail.com>
------------------------------------------------------------------------------
local PFX = '_n_'
local PFX_LEN = #PFX
local Events = {}

local function rm(tbl, pred)
    if (pred == nil) then return tbl end
    local x, len = 0, #tbl
    for i = 1, len do
        local trusy, idx = false, (i - x)
        if (type(pred) == 'function') then trusy = pred(tbl[idx])
        else trusy = tbl[idx] == pred
        end

        if (trusy) then
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

function Events:_evtb(ev)
    self._on[ev] = self._on[ev] or {}
    return self._on[ev]
end

-- ************************************************************************ --
-- ** Public APIs                                                         * --
-- ************************************************************************ --
function Events:on(ev, listener)
    table.insert(self:_evtb(PFX .. tostring(ev)), listener)
    return self
end

function Events:emit(ev, ...)
    local pfx_ev, argus = PFX .. tostring(ev), {...}
    local evtbl = self._on[pfx_ev]

    local function exec(tbl)
        for _, lsn in ipairs(tbl) do
            local status, err = pcall(lsn, unpack(argus))
            if not (status) then print(string.sub(_, PFX_LEN + 1) .. " emit error: " .. tostring(err)) end
        end
    end

    if (evtbl ~= nil) then exec(evtbl) end

    -- one-time listener
    pfx_ev = pfx_ev .. ':_'
    evtbl = self._on[pfx_ev]

    if (evtbl ~= nil) then
        exec(evtbl)
        rm(evtbl, function (v) return v ~= nil  end)
        self._on[pfx_ev] = nil
    end
    return self
end

function Events:once(ev, listener)
    table.insert(self:_evtb(PFX .. tostring(ev) .. ':_'), listener)
    return self
end

function Events:removeAll(ev)
    if ev ~= nil then
        local pfx_ev = PFX .. tostring(ev)
        local evtbl = self:_evtb(pfx_ev)
        rm(evtbl, function (v) return v ~= nil  end)

        pfx_ev = pfx_ev .. ':_'
        evtbl = self:_evtb(pfx_ev)
        rm(evtbl, function (v) return v ~= nil  end)
        self._on[pfx_ev] = nil
    else
        for _pfx_ev, _t in pairs(self._on) do self:removeAll(string.sub(_pfx_ev, PFX_LEN + 1)) end
    end

    for _pfx_ev, _t in pairs(self._on) do
        if (#_t == 0) then self._on[_pfx_ev] = nil end
    end

    return self
end

function Events:remove(ev, listener)
    local pfx_ev = PFX .. tostring(ev)
    local evtbl = self:_evtb(pfx_ev)
    local lsnCount = 0
    -- normal listener
    rm(evtbl, listener)
    if (#evtbl == 0) then self._on[pfx_ev] = nil end

    -- emit-once listener
    pfx_ev = pfx_ev .. ':_'
    evtbl = self:_evtb(pfx_ev)
    rm(evtbl, listener)
    if (#evtbl == 0) then self._on[pfx_ev] = nil end

    return self
end

return Events
