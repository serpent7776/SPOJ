#include <stdio.h>

#include <err.h>
#include <sysexits.h>
#include <limits.h>

static const char L = -1;
static const char R = 1;

struct Elem
{
	char ch;
	char dir;
};

#define MAX_ARRAY_SIZE 26

// 26 elements + 2 sentinel values: at the beginning and at the end
static struct Elem g_array[MAX_ARRAY_SIZE + 2];

static struct Elem* array = &g_array[1];

void print_array(int size)
{
	char buf[size + 1];
	int i = 0;
	for (i = 0; i < size; i+=4)
	{
		buf[i] = array[i].ch;
		buf[i+1] = array[i+1].ch;
		buf[i+2] = array[i+2].ch;
		buf[i+3] = array[i+3].ch;
	}
	for (; i < size; ++i)
	{
		buf[i] = array[i].ch;
	}
	buf[size] = 0;
	puts(buf);
}

void test(int size)
{
	// init array
	for (int i = 1; i <= size; ++i)
	{
		struct Elem e = {.ch = 'a' + i - 1, .dir = L};
		g_array[i] = e;
	}
	// create sentinel values
	struct Elem sentinel = {.ch = CHAR_MAX, .dir = L};
	g_array[0] = sentinel;
	g_array[size + 1] = sentinel;

	print_array(size);

	for (;;)
	{
		// get elem to move
		int max = 0;
		struct Elem max_elem = array[max];
		struct Elem max_sibling = array[-1];
		int max_moveable = max_elem.ch > max_sibling.ch;
		for (int i = 0; i < size; ++i)
		{
			const struct Elem elem = array[i];
			const struct Elem sibling = array[i + elem.dir];
			if ((elem.ch > max_elem.ch && elem.ch > sibling.ch) || !max_moveable)
			{
				max = i;
				max_elem = elem;
				max_sibling = sibling;
				max_moveable = max_elem.ch > max_sibling.ch;
			}
		}

		if (!max_moveable)
		{
			// no element can be moved, we're done
			return;
		}

		// move elem
		const struct Elem tmp = array[max];
		const int swapped = max + array[max].dir;
		array[max] = array[swapped];
		array[swapped] = tmp;

		max = swapped;

		// switch dirs
		for (int i = 0; i < size; ++i)
		{
			if (array[i].ch > array[max].ch)
			{
				// switch L to R and R to L
				array[i].dir *= -1;
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
