local events = require 'events'
local emitter = events:new()

emitter:on('test_on', function () 
    print('test_on LSN1 fires')
end)

emitter:on('test_on', function () 
    print('test_on LSN2 fires')
end)

emitter:on('test_on', function () 
    print('test_on LSN2 fires')
end)

emitter:on('test_on_args', function (...) 
    print('test_on_args fires')
    print(...)
end)

emitter:on('test_on_args', function (...) 
    print('test_on_args fires')
    print(...)
end)

emitter:on('test_addListener', function () 
    print('test_addListener LSN 1fires')
end)

emitter:on('test_addListener', function () 
    print('test_addListener LSN 2 fires')
end)

emitter:on('test_addListener_args', function (...) 
    print('test_addListener_args fires')
    print(...)
end)

emitter:once('test_once', function () 
    print('test_once LSN1 fires')
end)

emitter:once('test_once', function () 
    print('test_once LSN2 fires')
end)

emitter:once('test_once', function () 
    print('test_once LSN3 fires')
end)

emitter:once('test_once_args', function (...) 
    print('test_once_args fires')
    print(...)
end)

print(emitter:getMaxListeners())
print(emitter:listenerCount('test_on'))
print(emitter:listenerCount('test_on_args'))
print(emitter:listenerCount('test_addListener'))
print(emitter:listenerCount('test_addListener_args'))
print(emitter:listenerCount('test_once'))
print(emitter:listenerCount('test_once_args'))
print(emitter:listeners())
print(emitter:setMaxListeners(20))
print(emitter:getMaxListeners())
print(emitter:setMaxListeners(10))

emitter:emit('test_on')
emitter:emit('test_on')
emitter:emit('test_on')

emitter:emit('test_on_args', 1, 'hello', { x = 'x' })
emitter:emit('test_on_args', 2, 'world', { y = 'y' })

emitter:emit('test_once')
emitter:emit('test_once')

emitter:emit('test_once_args', 1, 'hello', { x = 'x' })
emitter:emit('test_once_args', 1, 'hello', { x = 'x' })

emitter:removeAllListeners('test_on')
emitter:emit('test_on')
emitter:emit('test_on')

print(emitter:listenerCount('test_on_args'))
emitter:removeAllListeners('test_on_args')
print(emitter:listenerCount('test_on_args'))

emitter:removeAllListeners()
print('remove all listeners')

emitter:emit('test_on')
emitter:emit('test_on')
emitter:emit('test_on')

emitter:emit('test_on_args', 1, 'hello', { x = 'x' })
emitter:emit('test_on_args', 2, 'world', { y = 'y' })

emitter:emit('test_once')
emitter:emit('test_once')

emitter:emit('test_once_args', 1, 'hello', { x = 'x' })
emitter:emit('test_once_args', 1, 'hello', { x = 'x' })

--------------------------------------------------------------
local cb1 = function () 
    print('>> cb1_test_on fires')
end

local cb1once = function () 
    print('**** cb1_test_once fires')
end

local cb2 = function (...) 
    print('cb2_test_on fires')
    print(...)
end

print('-----------------------------------')

emitter:on('cb1_test_on', cb1)
emitter:on('cb1_test_on', cb1)
emitter:on('cb1_test_on', cb1)

emitter:once('cb1_test_once', cb1once)
emitter:once('cb1_test_once', cb1once)
emitter:once('cb1_test_once', cb1once)

emitter:on('cb2_test_on', cb2)
emitter:on('cb2_test_on', cb2)
emitter:once('cb2_test_on', cb1)
emitter:once('cb2_test_on', cb1)
emitter:once('cb2_test_on', cb1)
emitter:once('cb2_test_on', cb1)
emitter:once('cb2_test_on', cb1)
emitter:once('cb2_test_on', cb1)
emitter:once('cb2_test_on', cb1)
emitter:once('cb2_test_on', cb1)
emitter:once('cb2_test_on', cb1)
emitter:once('cb2_test_on', cb1)
emitter:once('cb2_test_on', cb1)
emitter:once('cb2_test_on', cb1)
print('******')
print(emitter:getMaxListeners())
print(emitter:listenerCount('cb2_test_on'))
print(#emitter:listeners('cb2_test_on'))

emitter:emit('cb1_test_on')
emitter:emit('cb1_test_on')

emitter:emit('cb1_test_once')
emitter:emit('cb1_test_once')
emitter:emit('cb1_test_once')

emitter:emit('cb2_test_on', 1, 2, 'hello')
emitter:emit('cb2_test_on', 3, 4, 'world', { a = 1 })

print('-----------------------------------')

