(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "truncate" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.second
  |> dump_datetime;
  [%expect {| 2026-03-19 23:58:59 |}]
;;

let%expect_test "truncate" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate (Resolution.seconds 15)
  |> dump_datetime;
  [%expect {| 2026-03-19 23:58:45 |}]
;;

let%expect_test "truncate" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.minute
  |> dump_datetime;
  [%expect {| 2026-03-19 23:58:00 |}]
;;

let%expect_test "truncate" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate (Resolution.minutes 15)
  |> dump_datetime;
  [%expect {| 2026-03-19 23:45:00 |}]
;;

let%expect_test "truncate" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.hour
  |> dump_datetime;
  [%expect {| 2026-03-19 23:00:00 |}]
;;

let%expect_test "truncate" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate (Resolution.hours 2)
  |> dump_datetime;
  [%expect {| 2026-03-19 22:00:00 |}]
;;

let%expect_test "truncate" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.day
  |> dump_datetime;
  [%expect {| 2026-03-19 00:00:00 |}]
;;

let%expect_test "truncate" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.week
  |> dump_datetime;
  [%expect {| 2026-03-16 00:00:00 |}]
;;

let%expect_test "truncate" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate (Resolution.week_with_start Weekday.Thu)
  |> dump_datetime;
  [%expect {| 2026-03-19 00:00:00 |}]
;;

let%expect_test "truncate" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate (Resolution.week_with_start Weekday.Sun)
  |> dump_datetime;
  [%expect {| 2026-03-15 00:00:00 |}]
;;

let%expect_test "truncate" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.month
  |> dump_datetime;
  [%expect {| 2026-03-01 00:00:00 |}]
;;

let%expect_test "truncate" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.quarter
  |> dump_datetime;
  [%expect {| 2026-01-01 00:00:00 |}]
;;

let%expect_test "truncate" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.year
  |> dump_datetime;
  [%expect {| 2026-01-01 00:00:00 |}]
;;

let%expect_test "truncate seconds - already aligned" =
  "2026-03-19 23:58:45"
  |> Datetime.from_string_exn
  |> Datetime.truncate (Resolution.seconds 15)
  |> dump_datetime;
  [%expect {| 2026-03-19 23:58:45 |}]
;;

let%expect_test "truncate minutes - already aligned" =
  "2026-03-19 23:45:00"
  |> Datetime.from_string_exn
  |> Datetime.truncate (Resolution.minutes 15)
  |> dump_datetime;
  [%expect {| 2026-03-19 23:45:00 |}]
;;

let%expect_test "truncate hours - already aligned" =
  "2026-03-19 22:00:00"
  |> Datetime.from_string_exn
  |> Datetime.truncate (Resolution.hours 2)
  |> dump_datetime;
  [%expect {| 2026-03-19 22:00:00 |}]
;;

let%expect_test "truncate seconds - small value" =
  "2026-03-19 23:58:07"
  |> Datetime.from_string_exn
  |> Datetime.truncate (Resolution.seconds 5)
  |> dump_datetime;
  [%expect {| 2026-03-19 23:58:05 |}]
;;

let%expect_test "truncate minutes - non-trivial" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate (Resolution.minutes 7)
  |> dump_datetime;
  [%expect {| 2026-03-19 23:55:00 |}]
;;

let%expect_test "truncate hour - near midnight" =
  "2026-03-19 00:58:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.hour
  |> dump_datetime;
  [%expect {| 2026-03-19 00:00:00 |}]
;;

let%expect_test "truncate hours - crossing midnight boundary" =
  "2026-03-19 01:30:00"
  |> Datetime.from_string_exn
  |> Datetime.truncate (Resolution.hours 2)
  |> dump_datetime;
  [%expect {| 2026-03-19 00:00:00 |}]
;;

let%expect_test "truncate week - already start of week" =
  "2026-03-16 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.week
  |> dump_datetime;
  [%expect {| 2026-03-16 00:00:00 |}]
;;

let%expect_test "truncate week - sunday boundary" =
  "2026-03-15 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate (Resolution.week_with_start Weekday.Sun)
  |> dump_datetime;
  [%expect {| 2026-03-15 00:00:00 |}]
;;

let%expect_test "truncate month - already first day" =
  "2026-03-01 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.month
  |> dump_datetime;
  [%expect {| 2026-03-01 00:00:00 |}]
;;

let%expect_test "truncate quarter - boundary" =
  "2026-04-01 00:00:01"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.quarter
  |> dump_datetime;
  [%expect {| 2026-04-01 00:00:00 |}]
;;

let%expect_test "truncate year - already first day" =
  "2026-01-01 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.year
  |> dump_datetime;
  [%expect {| 2026-01-01 00:00:00 |}]
;;

let%expect_test "truncate day - leap day" =
  "2024-02-29 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.day
  |> dump_datetime;
  [%expect {| 2024-02-29 00:00:00 |}]
;;

let%expect_test "truncate month - leap february" =
  "2024-02-29 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.truncate Resolution.month
  |> dump_datetime;
  [%expect {| 2024-02-01 00:00:00 |}]
;;

let%expect_test "truncate idempotent - minute" =
  let dt =
    "2026-03-19 23:58:59"
    |> Datetime.from_string_exn
    |> Datetime.truncate Resolution.minute
  in
  let dt' = Datetime.truncate Resolution.minute dt in
  dump_bool (Datetime.equal dt dt');
  [%expect {| true |}]
;;

let%expect_test "truncate idempotent - month" =
  let dt =
    "2026-03-19 23:58:59"
    |> Datetime.from_string_exn
    |> Datetime.truncate Resolution.month
  in
  let dt' = Datetime.truncate Resolution.month dt in
  dump_bool (Datetime.equal dt dt');
  [%expect {| true |}]
;;

let%expect_test "truncate monotonicity" =
  let d1 = Datetime.from_string_exn "2026-03-19 10:00:00" in
  let d2 = Datetime.from_string_exn "2026-03-19 23:59:59" in
  let t1 = Datetime.truncate Resolution.day d1
  and t2 = Datetime.truncate Resolution.day d2 in
  dump_bool Datetime.(t1 <= t2);
  [%expect {| true |}]
;;

let%expect_test "truncate always <= original" =
  let dt = Datetime.from_string_exn "2026-03-19 23:58:59" in
  let t = Datetime.truncate (Resolution.minutes 15) dt in
  dump_bool Datetime.(t <= dt);
  [%expect {| true |}]
;;

let%expect_test "ceil seconds - already aligned" =
  "2026-03-19 23:58:45"
  |> Datetime.from_string_exn
  |> Datetime.ceil (Resolution.seconds 15)
  |> dump_datetime;
  [%expect {| 2026-03-19 23:58:45 |}]
;;

let%expect_test "ceil seconds - small value" =
  "2026-03-19 23:58:07"
  |> Datetime.from_string_exn
  |> Datetime.ceil (Resolution.seconds 5)
  |> dump_datetime;
  [%expect {| 2026-03-19 23:58:10 |}]
;;

let%expect_test "ceil minutes - already aligned" =
  "2026-03-19 23:45:00"
  |> Datetime.from_string_exn
  |> Datetime.ceil (Resolution.minutes 15)
  |> dump_datetime;
  [%expect {| 2026-03-19 23:45:00 |}]
;;

let%expect_test "ceil minutes - non-trivial" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.ceil (Resolution.minutes 7)
  |> dump_datetime;
  [%expect {| 2026-03-20 00:02:00 |}]
;;

let%expect_test "ceil hours - crossing midnight" =
  "2026-03-19 01:30:00"
  |> Datetime.from_string_exn
  |> Datetime.ceil (Resolution.hours 2)
  |> dump_datetime;
  [%expect {| 2026-03-19 02:00:00 |}]
;;

let%expect_test "ceil day - already midnight" =
  "2026-03-19 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.ceil Resolution.day
  |> dump_datetime;
  [%expect {| 2026-03-19 00:00:00 |}]
;;

let%expect_test "ceil day - regular" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.ceil Resolution.day
  |> dump_datetime;
  [%expect {| 2026-03-20 00:00:00 |}]
;;

let%expect_test "ceil week - start on Monday" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.ceil Resolution.week
  |> dump_datetime;
  [%expect {| 2026-03-23 00:00:00 |}]
;;

let%expect_test "ceil week - start on Sunday" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.ceil (Resolution.week_with_start Weekday.Sun)
  |> dump_datetime;
  [%expect {| 2026-03-22 00:00:00 |}]
;;

let%expect_test "ceil month - leap february" =
  "2024-02-29 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.ceil Resolution.month
  |> dump_datetime;
  [%expect {| 2024-03-01 00:00:00 |}]
;;

let%expect_test "ceil quarter - boundary" =
  "2026-04-01 00:00:01"
  |> Datetime.from_string_exn
  |> Datetime.ceil Resolution.quarter
  |> dump_datetime;
  [%expect {| 2026-07-01 00:00:00 |}]
;;

let%expect_test "ceil year - already first day" =
  "2026-01-01 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.ceil Resolution.year
  |> dump_datetime;
  [%expect {| 2026-01-01 00:00:00 |}]
;;

let%expect_test "round seconds - midpoint goes up" =
  "2026-03-19 23:58:53"
  |> Datetime.from_string_exn
  |> Datetime.round (Resolution.seconds 10)
  |> dump_datetime;
  [%expect {| 2026-03-19 23:58:50 |}]
;;

let%expect_test "round seconds - midpoint exact" =
  "2026-03-19 23:58:55"
  |> Datetime.from_string_exn
  |> Datetime.round (Resolution.seconds 10)
  |> dump_datetime;
  [%expect {| 2026-03-19 23:59:00 |}]
;;

let%expect_test "round minutes - non-trivial" =
  "2026-03-19 23:58:59"
  |> Datetime.from_string_exn
  |> Datetime.round (Resolution.minutes 7)
  |> dump_datetime;
  [%expect {| 2026-03-19 00:02:00 |}]
;;

let%expect_test "round hours - midpoint" =
  "2026-03-19 01:00:00"
  |> Datetime.from_string_exn
  |> Datetime.round (Resolution.hours 2)
  |> dump_datetime;
  [%expect {| 2026-03-19 02:00:00 |}]
;;

let%expect_test "round day - midpoint" =
  "2026-03-19 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.round Resolution.day
  |> dump_datetime;
  [%expect {| 2026-03-19 00:00:00 |}]
;;

let%expect_test "round week - midpoint" =
  "2026-03-18 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.round Resolution.week
  |> dump_datetime;
  [%expect {| 2026-03-16 00:00:00 |}]
;;

let%expect_test "round week - after midpoint" =
  "2026-03-20 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.round Resolution.week
  |> dump_datetime;
  [%expect {| 2026-03-23 00:00:00 |}]
;;

let%expect_test "round month - midpoint" =
  "2026-03-16 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.round Resolution.month
  |> dump_datetime;
  [%expect {| 2026-03-01 00:00:00 |}]
;;

let%expect_test "round quarter - midpoint" =
  "2026-02-15 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.round Resolution.quarter
  |> dump_datetime;
  [%expect {| 2026-01-01 00:00:00 |}]
;;

let%expect_test "round year - midpoint" =
  "2026-07-01 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.round Resolution.year
  |> dump_datetime;
  [%expect {| 2026-01-01 00:00:00 |}]
;;
