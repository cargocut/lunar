(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "weekday of epoch" =
  Duration.from_datetime ~year:1970 ~month:1 ~day:1 ~hour:23 ~min:59 ~sec:59
  |> Duration.weekday
  |> dump_weekday;
  [%expect {| thursday |}]
;;

let%expect_test "weekday of day before epoch" =
  Duration.from_datetime ~year:1969 ~month:12 ~day:31 ~hour:7 ~min:59 ~sec:59
  |> Duration.weekday
  |> dump_weekday;
  [%expect {| wednesday |}]
;;

let%expect_test "weekday of 2000-01-01" =
  Duration.from_datetime ~year:2000 ~month:1 ~day:1 ~hour:12 ~min:1 ~sec:59
  |> Duration.weekday
  |> dump_weekday;
  [%expect {| saturday |}]
;;

let%expect_test "weekday of 0000-01-01" =
  Duration.from_datetime ~year:0 ~month:1 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> Duration.weekday
  |> dump_weekday;
  [%expect {| saturday |}]
;;

let%expect_test "weekday leap day 2000" =
  Duration.from_datetime ~year:2000 ~month:2 ~day:29 ~hour:0 ~min:0 ~sec:0
  |> Duration.weekday
  |> dump_weekday;
  [%expect {| tuesday |}]
;;

let%expect_test "weekday 1900-03-01 (not leap year)" =
  Duration.from_datetime ~year:1900 ~month:3 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> Duration.weekday
  |> dump_weekday;
  [%expect {| thursday |}]
;;

let%expect_test "weekday 2000-03-01 (leap year)" =
  Duration.from_datetime ~year:2000 ~month:3 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> Duration.weekday
  |> dump_weekday;
  [%expect {| wednesday |}]
;;

let%expect_test "weekday 1969-12-29 (two days before epoch)" =
  Duration.from_datetime ~year:1969 ~month:12 ~day:29 ~hour:0 ~min:0 ~sec:0
  |> Duration.weekday
  |> dump_weekday;
  [%expect {| monday |}]
;;

let%expect_test "weekday 1970-01-04 (first Sunday after epoch)" =
  Duration.from_datetime ~year:1970 ~month:1 ~day:4 ~hour:0 ~min:0 ~sec:0
  |> Duration.weekday
  |> dump_weekday;
  [%expect {| sunday |}]
;;

let%expect_test "weekday 1600-01-01 (leap century)" =
  Duration.from_datetime ~year:1600 ~month:1 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> Duration.weekday
  |> dump_weekday;
  [%expect {| saturday |}]
;;

let%expect_test "weekday 1582-10-15 (Gregorian reform date, proleptic)" =
  Duration.from_datetime ~year:1582 ~month:10 ~day:15 ~hour:0 ~min:0 ~sec:0
  |> Duration.weekday
  |> dump_weekday;
  [%expect {| friday |}]
;;

let%expect_test "weekday year -1-12-31 (1 BCE end)" =
  Duration.from_datetime ~year:(-1) ~month:12 ~day:31 ~hour:0 ~min:0 ~sec:0
  |> Duration.weekday
  |> dump_weekday;
  [%expect {| friday |}]
;;

let%expect_test "weekday far future 2400-01-01" =
  Duration.from_datetime ~year:2400 ~month:1 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> Duration.weekday
  |> dump_weekday;
  [%expect {| saturday |}]
;;

let%expect_test "weekday 2024-02-29" =
  Duration.from_datetime ~year:2024 ~month:2 ~day:29 ~hour:0 ~min:0 ~sec:0
  |> Duration.weekday
  |> dump_weekday;
  [%expect {| thursday |}]
;;
