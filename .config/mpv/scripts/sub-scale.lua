mp.observe_property("sub-scale", "number", function(name, value)
    if value == nil then return end
end)
 
mp.register_event("file-loaded", function()
    mp.set_property_number("sub-scale", 0.3)
end)
