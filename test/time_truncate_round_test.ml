(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "truncate - should change nothing" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.truncate (Resolution.seconds 1)
  |> dump_time;
  [%expect {| 21:12:26 |}]
;;

let%expect_test "truncate" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.truncate (Resolution.minutes 1)
  |> dump_time;
  [%expect {| 21:12:00 |}]
;;

let%expect_test "truncate" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.truncate (Resolution.hours 1)
  |> dump_time;
  [%expect {| 21:00:00 |}]
;;

let%expect_test "truncate - should be 0" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.truncate Resolution.day
  |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "truncate - should be 0" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.truncate Resolution.day
  |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "truncate" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.truncate (Resolution.seconds 15)
  |> dump_time;
  [%expect {| 21:12:15 |}]
;;

let%expect_test "truncate" =
  Time.make_exn ~hour:21 ~min:12 ~sec:31 ()
  |> Time.truncate (Resolution.seconds 15)
  |> dump_time;
  [%expect {| 21:12:30 |}]
;;

let%expect_test "truncate" =
  Time.make_exn ~hour:21 ~min:12 ~sec:31 ()
  |> Time.truncate (Resolution.minutes 5)
  |> dump_time;
  [%expect {| 21:10:00 |}]
;;

let%expect_test "truncate" =
  Time.make_exn ~hour:21 ~min:12 ~sec:31 ()
  |> Time.truncate (Resolution.hours 6)
  |> dump_time;
  [%expect {| 18:00:00 |}]
;;

let%expect_test "round" =
  Time.make_exn ~hour:12 ~min:34 ~sec:29 ()
  |> Time.round (Resolution.minutes 1)
  |> dump_time;
  [%expect {| 12:34:00 |}]
;;

let%expect_test "round" =
  Time.make_exn ~hour:12 ~min:34 ~sec:31 ()
  |> Time.round (Resolution.minutes 1)
  |> dump_time;
  [%expect {| 12:35:00 |}]
;;

let%expect_test "round" =
  Time.make_exn ~hour:12 ~min:29 ~sec:59 ()
  |> Time.round (Resolution.hours 1)
  |> dump_time;
  [%expect {| 12:00:00 |}]
;;

let%expect_test "round" =
  Time.make_exn ~hour:12 ~min:30 ~sec:59 ()
  |> Time.round (Resolution.hours 1)
  |> dump_time;
  [%expect {| 13:00:00 |}]
;;

let%expect_test "ceil - should change nothing" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.ceil (Resolution.seconds 1)
  |> dump_time;
  [%expect {| 21:12:26 |}]
;;

let%expect_test "ceil - seconds resolution" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.ceil (Resolution.seconds 15)
  |> dump_time;
  [%expect {| 21:12:30 |}]
;;

let%expect_test "ceil - seconds resolution already aligned" =
  Time.make_exn ~hour:21 ~min:12 ~sec:30 ()
  |> Time.ceil (Resolution.seconds 15)
  |> dump_time;
  [%expect {| 21:12:30 |}]
;;

let%expect_test "ceil - minutes resolution" =
  Time.make_exn ~hour:21 ~min:12 ~sec:31 ()
  |> Time.ceil (Resolution.minutes 5)
  |> dump_time;
  [%expect {| 21:15:00 |}]
;;

let%expect_test "ceil - hours resolution" =
  Time.make_exn ~hour:21 ~min:12 ~sec:31 ()
  |> Time.ceil (Resolution.hours 6)
  |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "ceil - exact multiple of day" =
  Time.make_exn ~hour:0 ~min:0 ~sec:0 ()
  |> Time.ceil Resolution.day
  |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "ceil - next day" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.ceil Resolution.day
  |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "ceil - minutes small" =
  Time.make_exn ~hour:12 ~min:34 ~sec:29 ()
  |> Time.ceil (Resolution.minutes 1)
  |> dump_time;
  [%expect {| 12:35:00 |}]
;;

let%expect_test "ceil - minutes small already aligned" =
  Time.make_exn ~hour:12 ~min:34 ~sec:00 ()
  |> Time.ceil (Resolution.minutes 1)
  |> dump_time;
  [%expect {| 12:34:00 |}]
;;

let%expect_test "ceil - hours small" =
  Time.make_exn ~hour:12 ~min:29 ~sec:59 ()
  |> Time.ceil (Resolution.hours 1)
  |> dump_time;
  [%expect {| 13:00:00 |}]
;;

let%expect_test "ceil - hours exact" =
  Time.make_exn ~hour:12 ~min:00 ~sec:00 ()
  |> Time.ceil (Resolution.hours 1)
  |> dump_time;
  [%expect {| 12:00:00 |}]
;;

let%expect_test "truncate tests" =
  let t = Time.make_exn ~hour:21 ~min:12 ~sec:26 () in
  Time.truncate (Resolution.seconds 1) t |> dump_time;
  [%expect {| 21:12:26 |}];
  Time.truncate (Resolution.seconds 15) t |> dump_time;
  [%expect {| 21:12:15 |}];
  Time.truncate (Resolution.minutes 1) t |> dump_time;
  [%expect {| 21:12:00 |}];
  Time.truncate (Resolution.minutes 5) t |> dump_time;
  [%expect {| 21:10:00 |}];
  Time.truncate (Resolution.hours 1) t |> dump_time;
  [%expect {| 21:00:00 |}];
  Time.truncate (Resolution.hours 6) t |> dump_time;
  [%expect {| 18:00:00 |}];
  Time.truncate Resolution.day t |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "round tests" =
  let t1 = Time.make_exn ~hour:12 ~min:34 ~sec:29 () in
  let t2 = Time.make_exn ~hour:12 ~min:34 ~sec:31 () in
  let t3 = Time.make_exn ~hour:12 ~min:29 ~sec:59 () in
  let t4 = Time.make_exn ~hour:12 ~min:30 ~sec:00 () in
  Time.round (Resolution.minutes 1) t1 |> dump_time;
  [%expect {| 12:34:00 |}];
  Time.round (Resolution.minutes 1) t2 |> dump_time;
  [%expect {| 12:35:00 |}];
  Time.round (Resolution.hours 1) t3 |> dump_time;
  [%expect {| 12:00:00 |}];
  Time.round (Resolution.hours 1) t4 |> dump_time;
  [%expect {| 13:00:00 |}];
  let t5 = Time.make_exn ~hour:10 ~min:07 ~sec:00 () in
  Time.round (Resolution.minutes 15) t5 |> dump_time;
  [%expect {| 10:00:00 |}];
  let t6 = Time.make_exn ~hour:10 ~min:07 ~sec:29 () in
  Time.round (Resolution.minutes 15) t6 |> dump_time;
  [%expect {| 10:00:00 |}];
  let t7 = Time.make_exn ~hour:10 ~min:07 ~sec:31 () in
  Time.round (Resolution.minutes 15) t7 |> dump_time;
  [%expect {| 10:15:00 |}]
;;

let%expect_test "ceil tests" =
  let t = Time.make_exn ~hour:21 ~min:12 ~sec:26 () in
  Time.ceil (Resolution.seconds 15) t |> dump_time;
  [%expect {| 21:12:30 |}];
  Time.ceil (Resolution.minutes 1) t |> dump_time;
  [%expect {| 21:13:00 |}];
  Time.ceil (Resolution.minutes 5) t |> dump_time;
  [%expect {| 21:15:00 |}];
  Time.ceil (Resolution.hours 1) t |> dump_time;
  [%expect {| 22:00:00 |}];
  Time.ceil (Resolution.hours 6) t |> dump_time;
  [%expect {| 00:00:00 |}];
  Time.ceil Resolution.day t |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "negative duration tests" =
  let t = Time.make_exn ~hour:3 ~min:12 ~sec:26 () in
  let d = Duration.(from_hours (-1) - from_minutes 15) |> Resolution.duration in
  Time.truncate d t |> dump_time;
  [%expect {| 02:30:00 |}];
  Time.round d t |> dump_time;
  [%expect {| 03:45:00 |}];
  Time.ceil d t |> dump_time;
  [%expect {| 03:45:00 |}]
;;

let%expect_test "full day edge tests" =
  let noon = Time.noon in
  let eod = Time.end_of_day in
  Time.truncate (Resolution.hours 12) noon |> dump_time;
  [%expect {| 12:00:00 |}];
  Time.round (Resolution.hours 12) noon |> dump_time;
  [%expect {| 12:00:00 |}];
  Time.ceil (Resolution.hours 12) noon |> dump_time;
  [%expect {| 12:00:00 |}];
  Time.truncate Resolution.day eod |> dump_time;
  [%expect {| 00:00:00 |}];
  Time.round Resolution.day eod |> dump_time;
  [%expect {| 00:00:00 |}];
  Time.ceil Resolution.day eod |> dump_time;
  [%expect {| 00:00:00 |}]
;;
