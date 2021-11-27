#include <stdio.h>

#include <err.h>
#include <sysexits.h>

enum Dir
{
	L = 0,
	R = 1,
};

struct Elem
{
	char ch;
	enum Dir dir;
};

#define MAX_ARRAY_SIZE 26

struct Elem array[MAX_ARRAY_SIZE];

int moveable(int idx, int size)
{
	switch (array[idx].dir)
	{
		case L: return idx > 0 && array[idx].ch > array[idx - 1].ch;
		case R: return idx < size - 1 && array[idx].ch > array[idx + 1].ch;
	}
	__builtin_unreachable();
}

void print_array(int size)
{
	for (int i = 0; i < size; ++i)
	{
		putchar(array[i].ch);
	}
	putchar('\n');
}

void test(int size)
{
	// init array
	for (int i = 0; i < size; ++i)
	{
		struct Elem e = {.ch = 'a' + i, .dir = L};
		array[i] = e;
	}

	print_array(size);

	for (;;)
	{
		// get elem to move
		int max = 0;
		for (int i = 1; i < size; ++i)
		{
			if ((array[i].ch > array[max].ch && moveable(i, size)) || !moveable(max, size))
			{
				max = i;
			}
		}

		if (!moveable(max, size))
		{
			// no element can be moved, we're done
			return;
		}

		// move elem
		struct Elem tmp = array[max];
		const int swapped = array[max].dir == L ? max - 1 : max + 1;
		array[max] = array[swapped];
		array[swapped] = tmp;

		max = swapped;

		// switch dirs
		for (int i = 0; i < size; ++i)
		{
			if (array[i].ch > array[max].ch)
			{
				// switch L to R and R to L
				array[i].dir ^= 1;
			}
		}

		print_array(size);
	}
}

int main()
{
	int t;
	if (scanf("%i", &t) != 1)
	{
		err(EX_USAGE, "Invalid input");
	}

	for (int i = 0; i < t; ++i)
	{
		int k;
		if (scanf("%i", &k) != 1)
		{
			err(EX_USAGE, "Invalid input");
		}
		if (k < 1)
		{
			err(EX_USAGE, "Array size needs to be positive");
		}
		if (k > MAX_ARRAY_SIZE)
		{
			err(EX_USAGE, "Array too large");
		}

		test(k);
	}

	return 0;
}
