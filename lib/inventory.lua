function count(block)
    local total = 0
    for i=1,16 do
        local slot_detail = turtle.getItemDetail(i)
        if slot_detail["name"] == block then
            total = total + slot_detail["count"]
        end
    end

    return total
end

function fillSlot(slot)
    local detail = turtle.getItemDetail(slot)
    local block = detail["name"]
    
    local slot_count = turtle.getItemCount(slot) 
    if turtle.getItemSpace(slot) > 0 and count(block) > turtle.getItemCount(slot) do
        for slot_i=1,16 do
            if slot_i ~= slot then
                local slot_detail = turtle.getItemDetail(slot_i)
                if slot_detail["name"] == block then
                    turtle.select(slot_i)
                    turtle.transferTo(slot, math.min(turtle.getItemSpace(slot), slot_detail["count"]))
                    if turtle.getItemSpace(slot) == 0 then
                        break
                    end
                end
            end
        end
    end
    turtle.select(slot)
end

function refuel(target, slot=1)
    local fuel_slot = 1
    local fuel_type_detail = turtle.getItemDetail(fuel_slot)
    local fuel_block = fuel_type_detail["name"]

    while turtle.getFuelLevel() < target and count(fuel_block) > 1 do
        if getItemCount(fuel_slot) <= 1 then
            fillSlot(fuel_slot)
        end
        turtle.select(fuel_slot)
        turtle.refuel(1)
    end
end

print("Inventory Library")