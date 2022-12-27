--------------------------------------------------------------------------------
-- Cache commonly used functions
--------------------------------------------------------------------------------
local callbacks_register, error, pairs, table_insert, type, callback = callbacks.register, error, pairs, table.insert, type, callback

--------------------------------------------------------------------------------
-- Constants and variables
--------------------------------------------------------------------------------

local uix = {
    config = {},
    elements = {}
}

----------------------------------------------------------
-- Implementation
----------------------------------------------------------

function uix:callback(event, callback)
    if event == nil then
        error("not found: event")
    elseif callback == nil then
        error("not found: callback")
    end

    return callbacks_register(event, callback)
end

function uix:set_callback(name, callback)
    if name == nil then
        error("not found: name")
    elseif callback == nil then
        error("not found: callback")
    end

    return name:add_callback(callback)
end

function uix:get(name, another)
    if name == nil then
        error("not found: name")
    end

    return name:get(another)
end

function uix:set(name, another)
    if name == nil then
        error("not found: name")
    end

    return name:set(another)
end

function uix:update(name, items)
    if name == nil then
        error("not found: name")
    elseif items == nil then
        error("not found: items")
    end

    return name:update_items({items})
end

function uix:set_visible(name, ...)
    if name == nil then
        error("not found: name")
    end

    local varargs = ...

    return name:set_visible(varargs)
end

function uix:new(element, condition, config, callback)
    condition = condition or true
    config = config or false
    callback = callback or function() end

    local update = function()
        for k, v in pairs(uix.elements) do
            if type(v.condition) == "function" then
                uix:set_visible(v.element, v.condition())
            else
                uix:set_visible(v.element, v.condition)
            end
        end
    end

    uix:callback("paint", function(value)
        update()
        callback(value)
    end)

    table_insert(uix.elements, { element = element, condition = condition})

    if config then
        table_insert(uix.config, element)
    end

    update()

    return element
end

function uix:get(tab, sub_tab, group, option)
    if tab == nil then error("not found: tab") end
    if sub_tab == nil then error("not found: sub_tab") end
    if group == nil then error("not found: group") end
    if option == nil then error("not found: option") end

    return ui.get(tab, sub_tab, group, option)
end