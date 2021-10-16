local L = 'L'
local R = 'R'

local function rep(n, f)
	for _= 1, n do
		f()
	end
end

local function gen_arr(k)
	local arr = {}
	for i = 1, k do
		arr[i] = {
			ch = string.char(string.byte('a') + i - 1),
			dir = L,
		}
	end
	return arr
end

local function get_elem_to_move(arr)
	local len = #arr
	local nonfirst = function(idx) return idx > 1 end
	local nonlast = function(idx) return idx < len end
	local smaller_left = function(idx) return arr[idx].ch > arr[idx - 1].ch end
	local smaller_right = function(idx) return arr[idx].ch > arr[idx + 1].ch end
	local moveable = function(idx, elem)
		local dir = elem.dir
		if dir == L then
			return nonfirst(idx) and smaller_left(idx)
		elseif dir == R then
			return nonlast(idx) and smaller_right(idx)
		else
			error('invalid direction ' .. dir)
		end
	end
	local function bigger_elem(i, j)
		local el_i = arr[i]
		local el_j = arr[j]
		if (el_i.ch > el_j.ch and moveable(i, el_i)) or not moveable(j, el_j) then
			return i
		else
			return j
		end
	end
	local function get_biggest_elem_to_move()
		local current = 1
		for i = 2, len do
			current = bigger_elem(current, i)
		end
		return current, arr[current]
	end
	local idx, elem = get_biggest_elem_to_move()
	if not moveable(idx, elem) then
		return false, {}
	end
	return idx, elem
end

local function swap(arr, i, j)
	arr[i], arr[j] = arr[j], arr[i]
end

local function move_elem(arr, idx, elem)
	local dir = elem.dir
	if dir == L then
		swap(arr, idx, idx - 1)
	elseif dir == R then
		swap(arr, idx, idx + 1)
	else
		error('invalid direction ' .. dir)
	end
end

local function reverse(elem)
	if elem.dir == L then
		elem.dir = R
	else
		elem.dir = L
	end
end

local function switch_dirs(arr, elem)
	for i = 1, #arr do
		local el = arr[i]
		if el.ch > elem.ch then
			reverse(el)
		end
	end
end

local function perms(arr, fn)
	fn(arr)
	while true do
		local idx, elem = get_elem_to_move(arr)
		if (idx == false) then
			break
		end
		move_elem(arr, idx, elem)
		switch_dirs(arr, elem)
		fn(arr)
	end
end

local function print_perm(arr)
	for i = 1, #arr do
		io.write(arr[i].ch)
	end
	io.write('\n')
end

local n = io.read()
rep(n, function()
	local k = io.read()
	local arr = gen_arr(k)
	perms(arr, print_perm)
end)
