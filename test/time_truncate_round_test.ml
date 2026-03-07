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
