let rep n f =
        for _ = 1 to n do
                f ()
        done

let nth_char n =
        Char.chr (Char.code 'a' + n)

type dir = L | R

type elem = {
        ch: char;
        mutable d: dir;
}

let char_of_dir = function
        | L -> 'L'
        | R -> 'R'

let gen_arr k =
        Array.init k (fun i -> {
                        ch = nth_char i;
                        d = L;
                }
        )

let fold_arrayi fn arr =
        let len = Array.length arr in
        if len = 0 then None
        else
                let res = ref (0, arr.(0)) in
                let elem = ref (0, arr.(0)) in
                for i = 1 to (len - 1) do
                        let next = ref (i, arr.(i)) in
                        res := fn !res !next;
                        elem := !next
                done;
                Some !res

let option_filter pred = function
        | None -> None
        | Some x as opt ->
                if pred x then opt
                else None

let get_elem_to_move arr =
        let len = Array.length arr in
        let nonfirst id = id > 0 in
        let nonlast id = id < len - 1 in
        let smaller_left id = arr.(id).ch > arr.(id - 1).ch in
        let smaller_right id = arr.(id).ch > arr.(id + 1).ch in
        let moveable (id, el) =
                match el.d with
                | L -> nonfirst id && smaller_left id
                | R -> nonlast id && smaller_right id
        in
        let max_el ((_, e1) as it1) ((_, e2) as it2) =
                if (e1.ch > e2.ch && moveable it1) || not (moveable it2) then it1
                else it2
        in
        fold_arrayi max_el arr |> option_filter moveable

let swap arr id1 id2 =
        let tmp = arr.(id1) in
        arr.(id1) <- arr.(id2);
        arr.(id2) <- tmp;
        arr

let move_elem arr (id, el) =
        match el.d with
        | L -> swap arr id (id - 1)
        | R -> swap arr id (id + 1)

let rev = function
        | L -> R
        | R -> L

let switch_dirs arr {ch = ch; d = d} =
        Array.iter (fun el ->
                if el.ch > ch then el.d <- rev el.d
        ) arr;
        arr

let perms arr f =
        f arr;
        let rec proc = function
                | None -> ()
                | Some (id, ({ch = ch; d = d} as el) as it) ->
                        let _ = move_elem arr it in
                        let _ = switch_dirs arr el in
                        let () = f arr in
                        let it = get_elem_to_move arr in
                        proc it
        in proc (get_elem_to_move arr)

let print_elem out_ch el =
        output_char out_ch el.ch

let print_arr out_ch arr =
        Array.iter (print_elem out_ch) arr

let _ =
        let () =
                assert (nth_char 0 = 'a');
                assert (nth_char 1 = 'b');
                assert (nth_char 2 = 'c');
                assert (gen_arr 1 = [| {ch = 'a'; d = L} |]);
                assert (gen_arr 2 = [| {ch = 'a'; d = L}; {ch = 'b'; d = L} |]);
                assert (gen_arr 3 = [| {ch = 'a'; d = L}; {ch = 'b'; d = L}; {ch = 'c'; d = L};  |]);
                assert (get_elem_to_move [| |] = None);
                assert (get_elem_to_move [| {ch = 'a'; d = L} |] = None);
                assert (get_elem_to_move [| {ch = 'a'; d = L}; {ch = 'b'; d = L} |] = Some (1, {ch = 'b'; d = L}));
                assert (get_elem_to_move [| {ch = 'a'; d = L}; {ch = 'b'; d = R} |] = None);
                assert (get_elem_to_move [| {ch = 'b'; d = L}; {ch = 'a'; d = R} |] = None);
                assert (get_elem_to_move [| {ch = 'b'; d = L}; {ch = 'c'; d = L}; {ch = 'a'; d = L} |] = Some (1, {ch = 'c'; d = L}));
                assert (get_elem_to_move [| {ch = 'c'; d = L}; {ch = 'b'; d = R}; {ch = 'a'; d = L} |] = Some (1, {ch = 'b'; d = R}));
                assert (get_elem_to_move [| {ch = 'a'; d = L}; {ch = 'b'; d = L}; {ch = 'c'; d = R} |] = Some (1, {ch = 'b'; d = L}));
                assert (get_elem_to_move [| {ch = 'b'; d = L}; {ch = 'a'; d = L}; {ch = 'c'; d = R} |] = None);
                assert (move_elem [| {ch = 'a'; d = R}; {ch = 'b'; d = L} |] (0, {ch = 'a'; d = R}) = [| {ch = 'b'; d = L}; {ch = 'a'; d = R} |] );
                assert (switch_dirs [| {ch = 'a'; d = L}; {ch = 'b'; d = L}; {ch = 'c'; d = L} |] {ch = 'b'; d = L} = [| {ch = 'a'; d = L}; {ch = 'b'; d = L}; {ch = 'c'; d = R} |]);
                assert (switch_dirs [| {ch = 'b'; d = L}; {ch = 'c'; d = R}; {ch = 'a'; d = L} |] {ch = 'c'; d = R} = [| {ch = 'b'; d = L}; {ch = 'c'; d = R}; {ch = 'a'; d = L} |]);
        in
        Scanf.scanf "%d\n" (fun t ->
                rep t (fun () ->
                        Scanf.scanf "%d\n" (fun k ->
                                let arr = gen_arr k in
                                perms arr (fun perm ->
                                        Printf.printf "%a\n" print_arr perm
                                )
                        )
                )
        )
