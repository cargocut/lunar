(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

let mk_range ~year ~month =
  let start_month = Date.make_exn ~year ~month ~day:1 () in
  let first = Date.start_of_week start_month
  and last = Date.end_of_month start_month |> Date.end_of_week in
  Date.Range.make ~first ~last
;;

let dump_range month range =
  let iterator = Date.Range.iterator_day in
  let header =
    (range |> Date.Range.first_elt |> Date.to_string)
    ^ ".."
    ^ (range |> Date.Range.last_elt |> Date.to_string)
    ^ "\n| "
    ^ (Weekday.all
       |> List.map (fun x ->
         x |> Weekday.to_short_string |> String.uppercase_ascii)
       |> String.concat " | ")
    ^ " | "
  in
  print_endline header;
  Date.Range.iter
    ~iterator
    (fun date ->
       let wd = Date.day_of_week date
       and dm = Date.day_of_month date
       and md = Date.month date in
       let dr =
         if Month.equal md month
         then (
           let p = if dm > 9 then " " else " 0" in
           "" ^ p ^ string_of_int dm)
         else " . "
       in
       let () = if Weekday.(equal wd Mon) then print_string "|" in
       let () = print_string (" " ^ dr ^ " ") in
       let () = print_string "|" in
       if Weekday.(equal wd Sun) then print_newline ())
    range
;;

let dump_calendar ~year ~month =
  let range = mk_range ~year ~month in
  dump_range month range
;;

let%expect_test "dump a March 2026" =
  dump_calendar ~year:2026 ~month:Month.Mar;
  [%expect
    {|
    2026-02-23..2026-04-05
    | MON | TUE | WED | THU | FRI | SAT | SUN |
    |  .  |  .  |  .  |  .  |  .  |  .  |  01 |
    |  02 |  03 |  04 |  05 |  06 |  07 |  08 |
    |  09 |  10 |  11 |  12 |  13 |  14 |  15 |
    |  16 |  17 |  18 |  19 |  20 |  21 |  22 |
    |  23 |  24 |  25 |  26 |  27 |  28 |  29 |
    |  30 |  31 |  .  |  .  |  .  |  .  |  .  |
    |}]
;;

let%expect_test "dump a Apr 2034" =
  dump_calendar ~year:2034 ~month:Month.Apr;
  [%expect
    {|
    2034-03-27..2034-04-30
    | MON | TUE | WED | THU | FRI | SAT | SUN |
    |  .  |  .  |  .  |  .  |  .  |  01 |  02 |
    |  03 |  04 |  05 |  06 |  07 |  08 |  09 |
    |  10 |  11 |  12 |  13 |  14 |  15 |  16 |
    |  17 |  18 |  19 |  20 |  21 |  22 |  23 |
    |  24 |  25 |  26 |  27 |  28 |  29 |  30 |
    |}]
;;
