(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "start_of_minute" =
  "12:47:33" |> Time.from_string_exn |> Time.start_of_minute |> dump_time;
  [%expect {| 12:47:00 |}]
;;

let%expect_test "end_of_minute" =
  "12:47:33" |> Time.from_string_exn |> Time.end_of_minute |> dump_time;
  [%expect {| 12:47:59 |}]
;;

let%expect_test "start_of_hour" =
  "12:47:33" |> Time.from_string_exn |> Time.start_of_hour |> dump_time;
  [%expect {| 12:00:00 |}]
;;

let%expect_test "end_of_hour" =
  "12:47:33" |> Time.from_string_exn |> Time.end_of_hour |> dump_time;
  [%expect {| 12:59:59 |}]
;;
