(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "truncate - should change nothing" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.truncate (Duration.from_seconds 1)
  |> dump_time;
  [%expect {| 21:12:26 |}]
;;

let%expect_test "truncate" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.truncate (Duration.from_minutes 1)
  |> dump_time;
  [%expect {| 21:12:00 |}]
;;

let%expect_test "truncate" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.truncate (Duration.from_hours 1)
  |> dump_time;
  [%expect {| 21:00:00 |}]
;;

let%expect_test "truncate - should be 0" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.truncate (Duration.from_days 1)
  |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "truncate - should be 0" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.truncate (Duration.from_days 7)
  |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "truncate" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.truncate (Duration.from_seconds 15)
  |> dump_time;
  [%expect {| 21:12:15 |}]
;;

let%expect_test "truncate" =
  Time.make_exn ~hour:21 ~min:12 ~sec:31 ()
  |> Time.truncate (Duration.from_seconds 15)
  |> dump_time;
  [%expect {| 21:12:30 |}]
;;

let%expect_test "truncate" =
  Time.make_exn ~hour:21 ~min:12 ~sec:31 ()
  |> Time.truncate (Duration.from_minutes 5)
  |> dump_time;
  [%expect {| 21:10:00 |}]
;;

let%expect_test "truncate" =
  Time.make_exn ~hour:21 ~min:12 ~sec:31 ()
  |> Time.truncate (Duration.from_hours 6)
  |> dump_time;
  [%expect {| 18:00:00 |}]
;;

let%expect_test "round" =
  Time.make_exn ~hour:12 ~min:34 ~sec:29 ()
  |> Time.round (Duration.from_minutes 1)
  |> dump_time;
  [%expect {| 12:34:00 |}]
;;

let%expect_test "round" =
  Time.make_exn ~hour:12 ~min:34 ~sec:31 ()
  |> Time.round (Duration.from_minutes 1)
  |> dump_time;
  [%expect {| 12:35:00 |}]
;;

let%expect_test "round" =
  Time.make_exn ~hour:12 ~min:29 ~sec:59 ()
  |> Time.round (Duration.from_hours 1)
  |> dump_time;
  [%expect {| 12:00:00 |}]
;;

let%expect_test "round" =
  Time.make_exn ~hour:12 ~min:30 ~sec:59 ()
  |> Time.round (Duration.from_hours 1)
  |> dump_time;
  [%expect {| 13:00:00 |}]
;;

let%expect_test "ceil - should change nothing" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.ceil (Duration.from_seconds 1)
  |> dump_time;
  [%expect {| 21:12:26 |}]
;;

let%expect_test "ceil - seconds resolution" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.ceil (Duration.from_seconds 15)
  |> dump_time;
  [%expect {| 21:12:30 |}]
;;

let%expect_test "ceil - seconds resolution already aligned" =
  Time.make_exn ~hour:21 ~min:12 ~sec:30 ()
  |> Time.ceil (Duration.from_seconds 15)
  |> dump_time;
  [%expect {| 21:12:30 |}]
;;

let%expect_test "ceil - minutes resolution" =
  Time.make_exn ~hour:21 ~min:12 ~sec:31 ()
  |> Time.ceil (Duration.from_minutes 5)
  |> dump_time;
  [%expect {| 21:15:00 |}]
;;

let%expect_test "ceil - hours resolution" =
  Time.make_exn ~hour:21 ~min:12 ~sec:31 ()
  |> Time.ceil (Duration.from_hours 6)
  |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "ceil - exact multiple of day" =
  Time.make_exn ~hour:0 ~min:0 ~sec:0 ()
  |> Time.ceil (Duration.from_days 1)
  |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "ceil - next day" =
  Time.make_exn ~hour:21 ~min:12 ~sec:26 ()
  |> Time.ceil (Duration.from_days 1)
  |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "ceil - minutes small" =
  Time.make_exn ~hour:12 ~min:34 ~sec:29 ()
  |> Time.ceil (Duration.from_minutes 1)
  |> dump_time;
  [%expect {| 12:35:00 |}]
;;

let%expect_test "ceil - minutes small already aligned" =
  Time.make_exn ~hour:12 ~min:34 ~sec:00 ()
  |> Time.ceil (Duration.from_minutes 1)
  |> dump_time;
  [%expect {| 12:34:00 |}]
;;

let%expect_test "ceil - hours small" =
  Time.make_exn ~hour:12 ~min:29 ~sec:59 ()
  |> Time.ceil (Duration.from_hours 1)
  |> dump_time;
  [%expect {| 13:00:00 |}]
;;

let%expect_test "ceil - hours exact" =
  Time.make_exn ~hour:12 ~min:00 ~sec:00 ()
  |> Time.ceil (Duration.from_hours 1)
  |> dump_time;
  [%expect {| 12:00:00 |}]
;;
