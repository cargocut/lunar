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
  [%expect {| 1440 |}]
;;

let%expect_test "dump time range with iteration" =
  Time.Range.day
  |> Time.Range.length ~iterator:Time.Range.iterator_hour
  |> print_int;
  [%expect {| 24 |}]
;;
