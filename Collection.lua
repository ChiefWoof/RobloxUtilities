local Collection = {};
Collection.__index = Collection;


-- Class Content

function Collection.new(...)
	local res = {};
	setmetatable(res, Collection);
	res:push(...);
	return res;
end


-- Instance Content

---
-- @description The first items in the table. If the magnitude of the amount
-- of equal to 1, returns the value at the index else returns a table of values.
-- By default, the amount is 1
-- @param {number} amount The amount of items to return
-- @returns {*[]}

function Collection:first(amount)

	if (type(amount) ~= "number") then
		amount = 1;
	end

	if (amount < 0) then
		return self:last(-amount);
	else
		return self:slice(1, amount);
	end

end

---
-- @description The last items in the table. If the magnitude of the amount
-- of equal to 1, returns the value at the index else returns a table of values.
-- By default, the amount is 1
-- @param {number} amount The amount of items to return
-- @returns {*[]}

function Collection:last(amount)

	if (type(amount) ~= "number") then
		amount = 1;
	end

	if (amount < 0) then
		return self:first(-amount);
	else
		return self:slice(#self - amount + 1, #self):reverse();
	end
end

---
-- @description Retrives a slice of the table, creating a new
-- "Collection" and returning it
-- @param {number} indexInitial The initial index to begin the slice
-- @param {number} amount The maximum amount of entries to return
-- @returns {Collection}

function Collection:slice(indexInitial, amount)
	if (type(amount) ~= "number") then
		amount = 1;
	end
	return Collection.new(unpack(self, indexInitial, indexInitial + amount - 1));
end

---
-- @description Empties the table
-- @returns {@self}

function Collection:clear()
	self:splice(1, #self);
	return self;
end

---
-- @description Reverses the order of items
-- @returns {@self}

function Collection:reverse()
	table.foreach({ table.unpack(self, 1, math.floor(#self / 2)) }, function(i, v)
		self[i], self[#self - i + 1] = self[#self - i + 1], self[i];
	end)
	return self;
end

---
-- @description Inserts items starting at a specified index
-- @param {number} index The index to start at
-- @param {*...} The items to add
-- @returns {@self}

function Collection:insert(index, ...)
	table.foreach({ ... }, function(i, v)
		table.insert(self, index + i - 1, v);
	end)
	return self;
end

---
-- @description Removes items starting at specified index then inserts items starting at a specified index
-- @param {number} index The index to start at
-- @param {number} index The amount of items to remove
-- @param {*...} The items to add
-- @returns {@self}

function Collection:splice(index, amount, ...)
	for i = 1, amount, 1 do
		table.remove(self, index);
	end
	self:insert(index, ...);
	return self;
end

---
-- @description Adds items to the end of the table
-- @param {*...} The items to add
-- @returns {@self}

function Collection:push(...)
	table.foreach({ ... }, function(i, v)
		self:insert(1 + #self, v);
	end)
	return self;
end

---
-- @description Adds items to the beginning of the table
-- @param {*...} The items to add
-- @returns {@self}


function Collection:unshift(...)
	table.foreach({ ... }, function(i, v)
		self:insert(1, v);
	end)
	return self;
end

---
-- @description Checks whether all of the entered items can be found
-- in the table. If no items are entered, returns false
-- @param {*...} The items to check for
-- @returns {boolean} Whether all of the items were found in the table


function Collection:includes(...)

	if (table.getn({ ... }) == 0) then
		return false;
	end

	local bool = true;
	for _, v in ipairs({ ... }) do
		if (table.find(self, v) == nil) then
			bool = false;
			break;
		end
	end

	return bool;
end

---
-- @description Retrieves the index for specified item or returns -1
-- @param {number} indexInitial The index to start at
-- @returns {number}

function Collection:findIndex(indexInitial, value)
	return table.find(self, value, indexInitial) or -1;
end


return Collection;
