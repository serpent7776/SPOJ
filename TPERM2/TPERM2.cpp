#include <iostream>
#include <vector>
#include <numeric>
#include <optional>
#include <iterator>

enum class Dir : char {
	L,
	R,
};

struct Elem
{
	char ch;
	Dir dir;

	Elem(char c) : ch{c}, dir{Dir::L}
	{}
};

std::ostream& operator<<(std::ostream& o, const Elem& elem)
{
	return o << elem.ch;
}

struct It
{
	size_t idx;
	const Elem& elem;
};

using Array = std::vector<Elem>;

template <typename Count, typename Callable>
void repeat(Count n, Callable&& f)
{
	for (Count i = 0; i < n; ++i)
	{
		f();
	}
}

Array gen_array(size_t size)
{
	Array arr;
	arr.reserve(size);
	for (size_t i = 0; i < size; ++i)
	{
		arr.emplace_back('a' + i);
	}
	return arr;
}

void print_perms(const Array& arr)
{
	std::copy(std::begin(arr), std::end(arr), std::ostream_iterator<Elem>(std::cout));
	std::cout << '\n';
}

std::optional<It> get_elem_to_move(const Array& arr)
{
	const auto len = arr.size();
	auto nonfirst = [](std::size_t idx){return idx > 0;};
	auto nonlast = [len](std::size_t idx){return idx < len - 1;};
	auto smaller_left = [&arr](std::size_t idx){return arr[idx].ch > arr[idx - 1].ch;};
	auto smaller_right = [&arr](std::size_t idx){return arr[idx].ch > arr[idx + 1].ch;};
	auto moveable = [&](size_t idx, const Elem& elem)
	{
		switch (elem.dir)
		{
			case Dir::L:
				return nonfirst(idx) && smaller_left(idx);
			case Dir::R:
				return nonlast(idx) && smaller_right(idx);
		}
		__builtin_unreachable();
	};
	auto max_elem = [&](auto id_left, auto id_right)
	{
		const auto& elem_left = arr[id_left];
		const auto& elem_right = arr[id_right];
		if ((elem_left.ch > elem_right.ch && moveable(id_left, elem_left)) || !moveable(id_right, elem_right))
		{
			return id_left;
		}
		else
		{
			return id_right;
		}
	};
	size_t current = 0;
	const size_t end = arr.size();
	for (size_t next = current + 1; next < end; ++next)
	{
		current = max_elem(current, next);
	}
	if (moveable(current, arr[current]))
	{
		const auto max = It{current, arr[current]};
		return {max};
	}
	else
	{
		return std::nullopt;
	}
}

void move_elem(Array& arr, const It& it)
{
	const auto idx = it.idx;
	switch (it.elem.dir)
	{
		case Dir::L:
			return std::swap(arr[idx], arr[idx - 1]);
		case Dir::R:
			return std::swap(arr[idx], arr[idx + 1]);
	}
}

void reverse(Elem& elem)
{
	switch (elem.dir)
	{
		case Dir::L:
			elem.dir = Dir::R;
			break;
		case Dir::R:
			elem.dir = Dir::L;
			break;
	}
}

void switch_dirs(Array& arr, const Elem& elem)
{
	for (auto& el : arr)
	{
		if (el.ch > elem.ch)
		{
			reverse(el);
		}
	}
}

template <typename Proc>
void perms(Array& arr, Proc&& proc)
{
	proc(arr);
	for (;;)
	{
		const std::optional<It> it = get_elem_to_move(arr);
		if (!it.has_value())
		{
			break;
		}
		const Elem elem = it.value().elem;
		move_elem(arr, it.value());
		switch_dirs(arr, elem);
		proc(arr);
	}
}

void test()
{
	unsigned k;
	std::cin >> k;
	Array arr = gen_array(k);
	perms(arr, print_perms);
}

int main()
{
	unsigned t;
	std::cin >> t;
	repeat(t, test);
}
