(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "am" =
  List.init 24 (fun x -> x |> Time.am |> dump_time) |> ignore;
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
    |}]
;;

let%expect_test "pm" =
  List.init 24 (fun x -> x |> Time.pm |> dump_time) |> ignore;
  [%expect
    {|
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
