(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "succ" =
  let time = Time.am 11 in
  time |> Time.succ |> dump_time;
  [%expect {| 11:00:01 |}]
;;

let%expect_test "pred" =
  let time = Time.am 11 in
  time |> Time.pred |> dump_time;
  [%expect {| 10:59:59 |}]
;;

let%expect_test "succ_minute" =
  let time = Time.am 11 in
  time |> Time.succ_minute |> dump_time;
  [%expect {| 11:01:00 |}]
;;

let%expect_test "pred_minute" =
  let time = Time.am 11 in
  time |> Time.pred_minute |> dump_time;
  [%expect {| 10:59:00 |}]
;;

let%expect_test "succ_minute" =
  let time = Time.make_exn ~hour:11 ~min:32 ~sec:22 () in
  time |> Time.succ_minute |> dump_time;
  [%expect {| 11:33:00 |}]
;;

let%expect_test "pred_minute" =
  let time = Time.make_exn ~hour:11 ~min:32 ~sec:22 () in
  time |> Time.pred_minute |> dump_time;
  [%expect {| 11:31:00 |}]
;;

let%expect_test "succ_hour" =
  let time = Time.make_exn ~hour:11 ~min:32 ~sec:22 () in
  time |> Time.succ_hour |> dump_time;
  [%expect {| 12:00:00 |}]
;;

let%expect_test "pred_hour" =
  let time = Time.make_exn ~hour:11 ~min:32 ~sec:22 () in
  time |> Time.pred_hour |> dump_time;
  [%expect {| 10:00:00 |}]
;;

let%expect_test "succ - wraps to midnight" =
  Time.end_of_day |> Time.succ |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "pred - wraps to end_of_day" =
  Time.midnight |> Time.pred |> dump_time;
  [%expect {| 23:59:59 |}]
;;

let%expect_test "succ_minute - wraps hour" =
  Time.make_exn ~hour:11 ~min:59 ~sec:59 () |> Time.succ_minute |> dump_time;
  [%expect {| 12:00:00 |}]
;;

let%expect_test "pred_minute - wraps hour" =
  Time.make_exn ~hour:11 ~min:0 ~sec:0 () |> Time.pred_minute |> dump_time;
  [%expect {| 10:59:00 |}]
;;

let%expect_test "succ_hour - wraps day" =
  Time.make_exn ~hour:23 ~min:10 ~sec:10 () |> Time.succ_hour |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "pred_hour - wraps day" =
  Time.make_exn ~hour:0 ~min:10 ~sec:10 () |> Time.pred_hour |> dump_time;
  [%expect {| 23:00:00 |}]
;;

let%expect_test "succ then pred = identity" =
  let t = Time.make_exn ~hour:12 ~min:34 ~sec:56 () in
  t |> Time.succ |> Time.pred |> dump_time;
  [%expect {| 12:34:56 |}]
;;

let%expect_test "pred then succ = identity" =
  let t = Time.make_exn ~hour:12 ~min:34 ~sec:56 () in
  t |> Time.pred |> Time.succ |> dump_time;
  [%expect {| 12:34:56 |}]
;;

let%expect_test "succ_minute always resets seconds" =
  Time.make_exn ~hour:5 ~min:10 ~sec:59 () |> Time.succ_minute |> dump_time;
  [%expect {| 05:11:00 |}]
;;

let%expect_test "succ_hour always resets minutes and seconds" =
  Time.make_exn ~hour:5 ~min:59 ~sec:59 () |> Time.succ_hour |> dump_time;
  [%expect {| 06:00:00 |}]
;;

let%expect_test "succ_hour crosses am/pm boundary" =
  Time.am 11 |> Time.succ_hour |> dump_time;
  [%expect {| 12:00:00 |}]
;;

let%expect_test "pred_hour crosses pm/am boundary" =
  Time.midnight |> Time.pred_hour |> dump_time;
  [%expect {| 23:00:00 |}]
;;
