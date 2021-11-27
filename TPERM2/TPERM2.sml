fun rep 0 _ = ()
  | rep n f = (f (); rep (n - 1) f);

fun nth_char n =
  Char.chr (Char.ord #"a" + n);

datatype dir = L | R;

type elem = {
  ch: char,
  d: dir ref
};

fun nth_elem n = {
  ch = nth_char n,
  d = ref L
  };

fun gen_array k =
  Array.tabulate (k, nth_elem);

fun read_int () =
  Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) TextIO.stdIn);

fun get_elem_to_move (arr:elem array) =
  let
    val len = Array.length arr
    fun nonfirst idx = idx > 0
    fun nonlast idx = idx < len - 1
    fun smaller_left idx = #ch (Array.sub (arr, idx)) > #ch (Array.sub (arr, (idx - 1)))
    fun smaller_right idx = #ch (Array.sub (arr, idx)) > #ch (Array.sub (arr, (idx + 1)))
    fun moveable (idx, el:elem) =
      case !(#d el) of
        L => nonfirst idx andalso smaller_left idx
      | R => nonlast idx andalso smaller_right idx
    fun max_el (curr_idx, curr_elem, max_it) =
      let
        (* +1 because we chopped the head of the array *)
        val curr_it = (curr_idx + 1, curr_elem)
        val (_, max_elem) = max_it
      in
        if (#ch curr_elem > #ch max_elem andalso moveable curr_it) orelse not (moveable max_it) then curr_it
        else max_it
      end
    val hd = (0, Array.sub (arr, 0))
    val rest = ArraySlice.slice (arr, 1, NONE)
    val elem_to_move = ArraySlice.foldli max_el hd rest
    val (idx, el) = elem_to_move
  in
    if moveable elem_to_move then SOME elem_to_move
    else NONE
  end

fun swap arr id1 id2 =
  let val tmp = Array.sub (arr, id1) in
    Array.update (arr, id1, Array.sub (arr, id2));
    Array.update (arr, id2, tmp)
  end;

fun move_elem arr (idx, el:elem) =
  case !(#d el) of
    L => swap arr idx (idx - 1)
  | R => swap arr idx (idx + 1);

fun rev L = R
  | rev R = L;

fun switch_dirs arr {ch, d} =
  Array.app (fn el:elem =>
    if #ch el > ch then #d el := rev (!(#d el))
    else ()
  ) arr;

fun perms arr f = (
  f arr;
  let
    fun proc NONE = ()
      | proc (SOME it) =
          let
            val (idx, el) = it
          in
            () = move_elem arr it;
            () = switch_dirs arr el;
            () = f arr;
            let
              val it' = get_elem_to_move arr
            in
              proc it'
            end
          end
  in proc (get_elem_to_move arr)
  end);

fun print_char ch =
  TextIO.output1 (TextIO.stdOut, ch);

fun print_elem (elem:elem) =
  print_char (#ch elem);

fun print_elems array = (
  Array.app print_elem array;
  TextIO.output1 (TextIO.stdOut, #"\n")
  );

let val t = read_int () in
  rep t (fn () =>
    let
      val k = read_int ()
      val array = gen_array k in
        perms array print_elems
    end
  )
end;
