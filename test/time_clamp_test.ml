(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "clamp" =
  let min = Time.am 11
  and max = Time.pm 5
  and curr = Time.pm 2 in
  curr |> Time.clamp ~min ~max |> dump_time;
  [%expect {| 14:00:00 |}]
;;

let%expect_test "clamp" =
  let min = Time.am 11
  and max = Time.pm 5
  and curr = Time.pm 6 in
  curr |> Time.clamp ~min ~max |> dump_time;
  [%expect {| 17:00:00 |}]
;;

let%expect_test "clamp" =
  let min = Time.am 11
  and max = Time.pm 5
  and curr = Time.am 6 in
  curr |> Time.clamp ~min ~max |> dump_time;
  [%expect {| 11:00:00 |}]
;;
