lua-events
========================  
Current version: v1.0.0 (stable)  
Compatible Lua version: 5.1.x  
<br />

## Table of Contents

1. [Overiew](#Overiew)  
2. [Installation](#Installation)  
3. [APIs](#APIs)  

<a name="Overiew"></a>  
## 1. Overview  

**lua-events** is an EventEmitter class that provides you with APIs in node.js style.  
  
I am using this module with my own [**nodemcu**](https://github.com/nodemcu/nodemcu-firmware) project on [ESP8266](http://www.esp8266.com/) WiFi Soc. It helps me write my code in *event-driven* style. I often grab a emitter from this module and use the emitter as an event hub in my application to control my program flow. Try it on **nodemcu**, it won't let you down.  
  
If you like to code something in an asynchronous manner on **nodemcu**, might I sugguest [**nodemcu-timer**](https://github.com/simenkid/nodemcu-timer)? They are working well with each other to help arrange your asynchronous flow, e.g. your function can defer its callback and return right away.  

<a name="Installation"></a>
## 2. Installation

> $ git clone https://github.com/simenkid/lua-events.git
  
Just include the file `events.lua` or use the minified one `events_min.lua` in your project.  
If you are with the **nodemcu** on ESP8266, it would be good for you to compile `*.lua` text file into `*.lc` bytecode to further reduce memory usage.  

<a name="APIs"></a>
## 3. APIs

* [EventEmitter:new()](#API_new)
* [emitter:emit()](#API_emit)
* [emitter:on()](#API_on)
* [emitter:once()](#API_once)
* [emitter:addListener()](#API_addListener)
* [emitter:removeListener()](#API_removeListener)
* [emitter:removeAllListeners()](#API_removeAllListeners)
* [emitter:getMaxListeners()](#API_getMaxListeners)
* [emitter:listenerCount()](#API_listenerCount)
* [emitter:listeners()](#API_listeners)
* [emitter:setMaxListeners()](#API_setMaxListeners)

*************************************************
### EventEmitter Class
Exposed by `require 'events'`  
    
```lua
local EventEmitter = require 'events'  -- or 'events_min'
```

<br />

<a name="API_new"></a>
### EventEmitter:new([table])
Create an instance of event emitter. If a table (or an object) is given, the table will inherit EventEmitter class and itself will be an event emiiter.
  
**Arguments:**  

1. `table` (_table_): If given, the table (or an object) itself will be returned as an event emitter. If not given, a new emitter will be returned.

**Returns:**  
  
* (_object_) emitter

**Examples:**

```lua
local EventEmitter = require 'events'

-- Inheritance
local myObject = {
    name = 'foo',
    greet = function ()
        print('Hello!')
    end
}

myObject = EventEmitter:new(myObject)

myObject:on('knock', function ()
    print('knock, knock!')
end)

myObject:emit('knock')

-- A simple emitter
local hub = EventEmitter:new()

hub:on('sing', function (who)
    print(who .. ' is singing.')
end)

hub:emit('sing', 'John')

```
  
********************************************

<a name="API_emit"></a>
### emitter:emit(event[, ...])
Calls each of the listeners in order with the given arguments.
  
**Arguments:**  

1. `event` (_string_): Event name.
2. `...` (_variadic arguments_): The parameters pass along with the event.

**Returns:**  
  
* (_boolean_) Returns true if listeners exist, false otherwise.

**Examples:**

```lua
local greet = 'hello'
local name = 'John Doe'
emitter:emit('knock', greet, name)

emitter:emit('tick')
```
  
********************************************

<a name="API_on"></a>
### emitter:on(event, listener)
Adds a listener to the listeners table of the specified event. 
  
**Arguments:**  

1. `event` (_string_): Event name.
2. `listener` (_listener_): Event handler.
  
**Returns:**  
  
* (_object_) emitter

**Examples:**

```lua
emitter:on('knock', function () {
    print('Someone knocks.')
});
```
  
********************************************

<a name="API_once"></a>
### emitter:once(event, listener)
Attaches a **one time** listener to the specified event. This listener will be removed after invoked.
  
**Arguments:**  

1. `event` (_string_): Event name.
2. `listener` (_listener_): Event handler.
  
**Returns:**  
  
* (_object_) emitter

**Examples:**

```lua
emitter:once('knock', function () {
    print('First visitor comes.')
});
```
  
********************************************

<a name="API_addListener"></a>
### emitter:addListener(event, listener)
This is an alias of [emitter.on(event, listener)](#API_on).

  
********************************************

<a name="API_removeListener"></a>
### emitter:removeListener(event, listener)
Removes a listener from the listener table of the specified event. 
  
**Arguments:**  

1. `event` (_string_): Event name.
2. `listener` (_function_): Event handler

**Returns:**  
  
* (_object_) emitter

**Examples:**

```lua
local callback = function (something)
    print('Someone says ' .. greet)
end

emitter:on('greeting', callback)
-- ...
emitter:removeListener('greeting', callback)
```
  
********************************************

<a name="API_removeAllListeners"></a>
### emitter:removeAllListeners([event])
Removes all listeners, or those of the specified event.
  
**Arguments:**  

1. `event` (_string_): This is optional. If given, all listeners attached to the specified event will be removed. If not given, all listeners of the emiiter will be removed.

**Returns:**  
  
* (_object_) emitter

**Examples:**

```lua
emitter:removeAllListeners('foo_event')
```
  
********************************************

<a name="API_getMaxListeners"></a>
### emitter:getMaxListeners()
Returns the current max listener value of the emitter.
  
**Arguments:**  

1. _none_

**Returns:**  
  
* (_number_) Number of current max listeners.

  
********************************************

<a name="API_listenerCount"></a>
### emitter:listenerCount(event)
Returns the number of listeners listening to the specified event.
  
**Arguments:**  

1. `event` (_string_): Event name.

**Returns:**  
  
* (_number_) Total number of the listeners.

**Examples:**

```lua
local numOfListeners = emitter:listenerCount('knock')
```
  
********************************************

<a name="API_listeners"></a>
### emitter:listeners(event)
Returns a shallow copy of listener table for the specified event.
  
**Arguments:**  

1. `event` (_string_): Event name.

**Returns:**  
  
* (_table_) table of listeners

**Examples:**

```lua
local knockHandlers = emitter:listeners('knock')
```
  
********************************************

<a name="API_setMaxListeners"></a>
### emitter:setMaxListeners(n)
The emitter will print a warning if more than 10 listeners are added to a event. This method let you increase the maximum number of listeners attached to a event.
  
**Arguments:**  

1. `n` (_number_): Maximum number of listeners attached to a event.

**Returns:**  
  
* (_object_) emitter
  
<br />
********************************************
<br />
## License  
MIT