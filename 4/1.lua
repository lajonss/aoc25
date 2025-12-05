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
    for row_index, row in ipairs(data) do
        local output_row = {}
        output[row_index] = output_row
        for column_index, value in ipairs(row) do
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

local function count_valid(data)
    local count = 0
    for _, row in pairs(data) do
        for _, value in pairs(row) do
            if value and value < 4 then
                count = count + 1
            end
        end
    end
    return count
end

print(count_valid(parse_count(read_input())))
