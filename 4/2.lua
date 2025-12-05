local function btoi(data, row_index, column_index)
    local row = data[row_index]
    if row then
        if row[column_index] then
            return 1
        end
    end

    return 0
end

local function read_input()
    local data = {}
    local row = {}
    while true do
        local char = io.read(1)
        if not char then
            return data
        end
        if char == "\n" then
            table.insert(data, row)
            row = {}
        else
            table.insert(row, char == "@")
        end
    end
end

local function parse_count(data)
    local output = {}
    for row_index, row in pairs(data) do
        local output_row = {}
        output[row_index] = output_row
        for column_index, value in pairs(row) do
            if value then
                output_row[column_index]
                    = btoi(data, row_index - 1, column_index - 1)
                    + btoi(data, row_index - 1, column_index)
                    + btoi(data, row_index - 1, column_index + 1)
                    + btoi(data, row_index, column_index - 1)
                    + btoi(data, row_index, column_index + 1)
                    + btoi(data, row_index + 1, column_index - 1)
                    + btoi(data, row_index + 1, column_index)
                    + btoi(data, row_index + 1, column_index + 1)
            end
        end
    end
    return output
end

local function trim(data)
    local output = {}
    local removed = 0
    for row_index, row in pairs(data) do
        local output_row = {}
        output[row_index] = output_row
        for column_index, value in pairs(row) do
            if value then
                if value >= 4 then
                    output_row[column_index] = true
                else
                    removed = removed + 1
                end
            end
        end
    end
    return removed, output
end

local function trim_recursively(data)
    local count = 0
    while true do
        local removed
        removed, data = trim(parse_count(data))
        if removed == 0 then
            return count
        end
        count = count + removed
    end
end

print(trim_recursively(read_input()))


