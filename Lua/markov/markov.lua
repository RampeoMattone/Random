local path, len, duration = arg[1], arg[2] or 2, arg[3] or 1000

function associate(path)
    local buffer = read(path)
    if buffer then
        local ass = {}
        local prev = {}
        for i = 1, len do
            table.insert(prev, i, "")
        end
        for cur in string.gmatch(buffer, "%S+") do
            local group = table.concat(prev, " ")
            local tmp = ass[group]
            if tmp then
                if not tmp[cur] then
                    table.insert(tmp, cur)
                end
            else
                ass[group] = {cur}
            end
            shift_add(prev, cur)
        end
        return ass
    else
        return {}
    end
end

function read(path)
    local file = io.open(path)
    local buffer = file:read("a"):lower()
    return buffer
end

function shift_add(tab, addendum)
    for i=1, #tab - 1 do
        tab[i] = tab[i+1]
    end
    tab[#tab] = addendum
end

local prev = {}
for i = 1, len do
    table.insert(prev, i, "")
end
local ass = associate(path)
local buffer = {}
    for i = 1, duration do
        local primer = table.concat(prev, " ")
        local temp = ass[primer]
        local word = temp[math.random(#temp)]
        shift_add(prev, word)
        table.insert(buffer, word)
    end

print(table.concat(buffer, " "))