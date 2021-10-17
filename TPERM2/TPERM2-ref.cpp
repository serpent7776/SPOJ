#include <iostream>
#include <vector>
#include <numeric>

std::ostream& operator<<(std::ostream& s, const std::vector<char>& v)
{
	std::copy(std::begin(v), std::end(v), std::ostream_iterator<char>(std::cout));
	return s;
}

template <typename Index, typename Callable>
void repeat(Index n, Callable f)
{
	for (Index i = 0; i < n; ++i)
	{
		f(i);
	}
}

int main()
{
	unsigned t;
	std::cin >> t;
	repeat(t, [](unsigned)
	{
		unsigned k;
		std::cin >> k;
		std::vector<char> v(k);
		std::iota(std::begin(v), std::end(v), 'a');
		std::cout << v << '\n';
		while (std::next_permutation(std::begin(v), std::end(v)))
		{
			std::cout << v << '\n';
		}
	});

	return 0;
}
