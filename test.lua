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

-- emitter:removeAllListeners('test_on_args')

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