(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "dump time range" =
  Time.Range.day |> dump_range Time.to_string (module Time.Range);
  [%expect {| (00:00:00..23:59:59) |}]
;;

let%expect_test "dump time range with iteration" =
  Time.Range.day
  |> Time.Range.length ~iterator:Time.Range.iterator_second
  |> print_int;
  [%expect {| 86400 |}]
;;

let%expect_test "dump time range with iteration" =
  Time.Range.day
  |> Time.Range.length ~iterator:Time.Range.iterator_minute
  |> print_int;
  [%expect {| 1441 |}]
;;

let%expect_test "dump time range with iteration" =
  Time.Range.day
  |> Time.Range.length ~iterator:Time.Range.iterator_hour
  |> print_int;
  [%expect {| 25 |}]
;;

let%expect_test "dump time range with iteration" =
  Time.Range.day
  |> Time.Range.length
       ~include_boundaries:false
       ~iterator:Time.Range.iterator_minute
  |> print_int;
  [%expect {| 1440 |}]
;;

let%expect_test "dump time range with iteration" =
  Time.Range.day
  |> Time.Range.length
       ~include_boundaries:false
       ~iterator:Time.Range.iterator_hour
  |> print_int;
  [%expect {| 24 |}]
;;

let%expect_test "dump time range with iteration" =
  Time.Range.day |> Time.Range.iter ~iterator:Time.Range.iterator_hour dump_time;
  [%expect
    {|
    00:00:00
    01:00:00
    02:00:00
    03:00:00
    04:00:00
    05:00:00
    06:00:00
    07:00:00
    08:00:00
    09:00:00
    10:00:00
    11:00:00
    12:00:00
    13:00:00
    14:00:00
    15:00:00
    16:00:00
    17:00:00
    18:00:00
    19:00:00
    20:00:00
    21:00:00
    22:00:00
    23:00:00
    23:59:59
    |}]
;;

let%expect_test "dump time range with iteration" =
  Time.Range.day
  |> Time.Range.iter
       ~include_boundaries:false
       ~iterator:Time.Range.iterator_hour
       dump_time;
  [%expect
    {|
    00:00:00
    01:00:00
    02:00:00
    03:00:00
    04:00:00
    05:00:00
    06:00:00
    07:00:00
    08:00:00
    09:00:00
    10:00:00
    11:00:00
    12:00:00
    13:00:00
    14:00:00
    15:00:00
    16:00:00
    17:00:00
    18:00:00
    19:00:00
    20:00:00
    21:00:00
    22:00:00
    23:00:00
    |}]
;;

let%expect_test "dump time range with iteration" =
  let iterator = Time.Range.linear_iterator Time.add_minutes 15 in
  Time.Range.day
  |> Time.Range.iter ~include_boundaries:false ~iterator dump_time;
  [%expect
    {|
    00:00:00
    00:15:00
    00:30:00
    00:45:00
    01:00:00
    01:15:00
    01:30:00
    01:45:00
    02:00:00
    02:15:00
    02:30:00
    02:45:00
    03:00:00
    03:15:00
    03:30:00
    03:45:00
    04:00:00
    04:15:00
    04:30:00
    04:45:00
    05:00:00
    05:15:00
    05:30:00
    05:45:00
    06:00:00
    06:15:00
    06:30:00
    06:45:00
    07:00:00
    07:15:00
    07:30:00
    07:45:00
    08:00:00
    08:15:00
    08:30:00
    08:45:00
    09:00:00
    09:15:00
    09:30:00
    09:45:00
    10:00:00
    10:15:00
    10:30:00
    10:45:00
    11:00:00
    11:15:00
    11:30:00
    11:45:00
    12:00:00
    12:15:00
    12:30:00
    12:45:00
    13:00:00
    13:15:00
    13:30:00
    13:45:00
    14:00:00
    14:15:00
    14:30:00
    14:45:00
    15:00:00
    15:15:00
    15:30:00
    15:45:00
    16:00:00
    16:15:00
    16:30:00
    16:45:00
    17:00:00
    17:15:00
    17:30:00
    17:45:00
    18:00:00
    18:15:00
    18:30:00
    18:45:00
    19:00:00
    19:15:00
    19:30:00
    19:45:00
    20:00:00
    20:15:00
    20:30:00
    20:45:00
    21:00:00
    21:15:00
    21:30:00
    21:45:00
    22:00:00
    22:15:00
    22:30:00
    22:45:00
    23:00:00
    23:15:00
    23:30:00
    23:45:00
    |}]
;;
