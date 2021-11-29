#[derive(Clone)]
enum Dir {
    L, R
}

impl std::fmt::Display for Dir {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let dir = match self {
            Dir::L => 'L',
            Dir::R => 'R',
        };
        write!(f, "{}", dir)
    }
}

#[derive(Clone)]
struct Elem {
    ch : char,
    dir : Dir,
}

impl std::fmt::Display for Elem {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.ch)
    }
}

impl std::fmt::Debug for Elem {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}{}", self.ch, self.dir)
    }
}

impl std::cmp::Ord for Elem {
    fn cmp(self : &Self, other: &Self) -> std::cmp::Ordering {
        self.ch.cmp(&other.ch)
    }
}

impl std::cmp::PartialOrd for Elem {
    fn partial_cmp(self: &Self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl std::cmp::PartialEq for Elem {
    fn eq(self: &Self, other: &Self) -> bool {
        self == other
    }
}

impl std::cmp::Eq for Elem {
}

type It<'a> = (usize, &'a Elem);

pub fn main() {
    let t = read_int::<usize>();
    rep(t, run_test);
}

fn make_elem(index: u8) -> Elem {
    let ch = char::from(index + 'a' as u8);
    Elem {
        ch: ch,
        dir: Dir::L,
    }
}

fn run_test() {
    let k = read_int::<u8>();
    let items : Vec<Elem> = (0..k)
        .map(make_elem)
        .collect();
    perms(items)
}

fn print(items: &Vec<Elem>) {
    for e in items.iter() {
        print!("{}", e.ch);
    }
    print!("\n");
}

fn move_elem<'a>(items: &mut Vec<Elem>, idx: usize, dir: Dir) {
    match dir {
        Dir::L => items.swap(idx, idx - 1),
        Dir::R => items.swap(idx, idx + 1),
    }
}

fn reverse(elem: &mut Elem) {
    elem.dir = match elem.dir {
        Dir::L => Dir::R,
        Dir::R => Dir::L,
    }
}

fn switch_dirs(items: &mut Vec<Elem>, elem: Elem) {
    let iter = items.iter_mut();
    for e in iter {
        if e.ch > elem.ch {
            reverse(e);
        }
    }
}

fn perms(mut items: Vec<Elem>) {
    print(&items);
    loop {
        match get_elem_to_move(&items) {
            None => return,
            Some((idx, elem)) => {
                let e = elem.clone();
                move_elem(&mut items, idx, e.dir.clone());
                switch_dirs(&mut items, e);
                print(&items);
            },
        }
    }
}

fn get_elem_to_move<'a>(items: &'a Vec<Elem>) -> Option<It> {
    let len = items.len();

    let nonfirst = |idx: usize| idx > 0;
    let nonlast = |idx: usize| idx < len - 1;
    let smaller_left = |idx: usize| items[idx] > items[idx - 1];
    let smaller_right = |idx: usize| items[idx] > items[idx + 1];

    let moveable = |(idx, elem): &It| {
        match elem.dir {
            Dir::L => {nonfirst(*idx) && smaller_left(*idx)},
            Dir::R => {nonlast(*idx) && smaller_right(*idx)},
        }
    };

    let bigger_moveable_elem = |it1: It<'a>, it2: It<'a>| {
        let elem1 = it1.1;
        let elem2 = it2.1;
        if (elem1.ch > elem2.ch && moveable(&it1)) || !moveable(&it2) {
            it1
        }
        else {
            it2
        }
    };

    let iter = items.iter().enumerate();
    iter.reduce(bigger_moveable_elem).filter(moveable)
}

fn read_int<T: std::str::FromStr>() -> T
    where <T as std::str::FromStr>::Err: std::fmt::Debug
{
    let mut line = String::new();
    std::io::stdin().read_line(&mut line).unwrap();
    line.trim().parse().unwrap()
}

fn rep<F: Fn() -> ()>(n: usize, f: F) {
    for _i in 0..n {
        f();
    }
}
