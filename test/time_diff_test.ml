(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "diff" =
  let a = Time.midnight
  and b = Time.end_of_day in
  Time.diff a b |> dump_duration;
  [%expect {| -86399 |}]
;;

let%expect_test "diff - same time" =
  let t = Time.make_exn ~hour:12 ~min:34 ~sec:56 () in
  Time.diff t t |> dump_duration;
  [%expect {| 0 |}]
;;

let%expect_test "diff - midnight vs end_of_day" =
  Time.diff Time.midnight Time.end_of_day |> dump_duration;
  [%expect {| -86399 |}]
;;

let%expect_test "diff - end_of_day vs midnight" =
  Time.diff Time.end_of_day Time.midnight |> dump_duration;
  [%expect {| 86399 |}]
;;

let%expect_test "diff - noon vs midnight" =
  Time.diff Time.noon Time.midnight |> dump_duration;
  [%expect {| 43200 |}]
;;

let%expect_test "diff - midnight vs noon" =
  Time.diff Time.midnight Time.noon |> dump_duration;
  [%expect {| -43200 |}]
;;

let%expect_test "diff - intermediate times" =
  let a = Time.make_exn ~hour:6 ~min:15 ~sec:30 () in
  let b = Time.make_exn ~hour:9 ~min:45 ~sec:15 () in
  Time.diff a b |> dump_duration;
  [%expect {| -12585 |}];
  Time.diff b a |> dump_duration;
  [%expect {| 12585 |}]
;;

let%expect_test "diff - consecutive seconds" =
  let a = Time.make_exn ~hour:14 ~min:59 ~sec:59 () in
  let b = Time.make_exn ~hour:15 ~min:0 ~sec:0 () in
  Time.diff a b |> dump_duration;
  [%expect {| -1 |}];
  Time.diff b a |> dump_duration;
  [%expect {| 1 |}]
;;
