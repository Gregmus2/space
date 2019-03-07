---@class Collection
---@field public elements table[]
local Collection = {}

---@param elements any[]
---@field protected count number
function Collection:new(elements)
    local list = {}
    for _, value in pairs(elements) do
        list[#list + 1] = value
    end

    local newObj = {
        elements = list,
        count = #list
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

function Collection:remove(element)
    for i = 1, self.count do
        if self.elements[i] == element then
            self.elements[i] = self.elements[self.count]
            self.elements[self.count] = nil
            self.count = self.count - 1

            return true
        end
    end

    return false
end

function Collection:add(element)
    self.count = self.count + 1
    self.elements[self.count] = element
end

---@param chunkCount number
---@return table[]
function Collection:chunk(chunkCount, startElement, endElement)
    assert(chunkCount > 0, 'Can\'t split by zero or less')

    local chunks = {}
    local currentChunk = {}
    local counter = 0

    for i = startElement, endElement do
        currentChunk[#currentChunk + 1] = self.elements[i]
        counter = counter + 1
        if counter == chunkCount then
            chunks[#chunks + 1] = currentChunk
            currentChunk = {}
            counter = 0
        end
    end

    if counter > 0 then
        chunks[#chunks + 1] = currentChunk
    end

    return chunks
end

---@return number
function Collection:getCount()
    return self.count
end

return Collection