(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "clamp: inside interval" =
  let min = Time.am 11
  and max = Time.pm 5
  and curr = Time.pm 2 in
  curr |> Time.clamp ~min ~max |> dump_time;
  [%expect {| 14:00:00 |}]
;;

let%expect_test "clamp: above interval" =
  let min = Time.am 11
  and max = Time.pm 5
  and curr = Time.pm 6 in
  curr |> Time.clamp ~min ~max |> dump_time;
  [%expect {| 17:00:00 |}]
;;

let%expect_test "clamp: below interval" =
  let min = Time.am 11
  and max = Time.pm 5
  and curr = Time.am 6 in
  curr |> Time.clamp ~min ~max |> dump_time;
  [%expect {| 11:00:00 |}]
;;

let%expect_test "clamp: at min boundary" =
  let min = Time.am 11
  and max = Time.pm 5
  and curr = Time.am 11 in
  curr |> Time.clamp ~min ~max |> dump_time;
  [%expect {| 11:00:00 |}]
;;

let%expect_test "clamp: at max boundary" =
  let min = Time.am 11
  and max = Time.pm 5
  and curr = Time.pm 5 in
  curr |> Time.clamp ~min ~max |> dump_time;
  [%expect {| 17:00:00 |}]
;;

let%expect_test "clamp: reversed bounds" =
  let min = Time.pm 5
  and max = Time.am 11
  and curr = Time.pm 2 in
  curr |> Time.clamp ~min ~max |> dump_time;
  [%expect {| 14:00:00 |}]
;;

let%expect_test "clamp: midnight below range" =
  let min = Time.am 11
  and max = Time.pm 5
  and curr = Time.midnight in
  curr |> Time.clamp ~min ~max |> dump_time;
  [%expect {| 11:00:00 |}]
;;

let%expect_test "clamp: end_of_day above range" =
  let min = Time.am 11
  and max = Time.pm 5
  and curr = Time.end_of_day in
  curr |> Time.clamp ~min ~max |> dump_time;
  [%expect {| 17:00:00 |}]
;;
