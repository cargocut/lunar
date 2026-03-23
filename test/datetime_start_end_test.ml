(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "start_of_day" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_day
  |> dump_datetime;
  [%expect {| 2026-03-19 00:00:00 |}]
;;

let%expect_test "end_of_day" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.end_of_day
  |> dump_datetime;
  [%expect {| 2026-03-19 23:59:59 |}]
;;

let%expect_test "start_of_week" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_week
  |> dump_datetime;
  [%expect {| 2026-03-16 00:00:00 |}]
;;

let%expect_test "start_of_week (Sunday)" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_week ~week_start:Weekday.Sun
  |> dump_datetime;
  [%expect {| 2026-03-15 00:00:00 |}]
;;

let%expect_test "end_of_week" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.end_of_week
  |> dump_datetime;
  [%expect {| 2026-03-22 23:59:59 |}]
;;

let%expect_test "end_of_week (Sunday)" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.end_of_week ~week_start:Weekday.Sun
  |> dump_datetime;
  [%expect {| 2026-03-21 23:59:59 |}]
;;

let%expect_test "start_of_month" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_month
  |> dump_datetime;
  [%expect {| 2026-03-01 00:00:00 |}]
;;

let%expect_test "end_of_month" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.end_of_month
  |> dump_datetime;
  [%expect {| 2026-03-31 23:59:59 |}]
;;

let%expect_test "start_of_month - feb leap" =
  "2024-02-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_month
  |> dump_datetime;
  [%expect {| 2024-02-01 00:00:00 |}]
;;

let%expect_test "end_of_month - feb leap" =
  "2024-02-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.end_of_month
  |> dump_datetime;
  [%expect {| 2024-02-29 23:59:59 |}]
;;

let%expect_test "start_of_quarter" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_quarter
  |> dump_datetime;
  [%expect {| 2026-01-01 00:00:00 |}]
;;

let%expect_test "end_of_quarter" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.end_of_quarter
  |> dump_datetime;
  [%expect {| 2026-03-31 23:59:59 |}]
;;

let%expect_test "start_of_quarter" =
  "2026-08-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_quarter
  |> dump_datetime;
  [%expect {| 2026-07-01 00:00:00 |}]
;;

let%expect_test "end_of_quarter" =
  "2026-10-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.end_of_quarter
  |> dump_datetime;
  [%expect {| 2026-12-31 23:59:59 |}]
;;

let%expect_test "start_of_year" =
  "2026-08-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_year
  |> dump_datetime;
  [%expect {| 2026-01-01 00:00:00 |}]
;;

let%expect_test "end_of_year" =
  "2026-10-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.end_of_year
  |> dump_datetime;
  [%expect {| 2026-12-31 23:59:59 |}]
;;

let%expect_test "start_of_day idempotent" =
  let dt =
    "2026-03-19 12:34:56" |> Datetime.from_string_exn |> Datetime.start_of_day
  in
  dt |> Datetime.start_of_day |> dump_datetime;
  [%expect {| 2026-03-19 00:00:00 |}]
;;

let%expect_test "end_of_month idempotent" =
  let dt =
    "2026-03-19 12:34:56" |> Datetime.from_string_exn |> Datetime.end_of_month
  in
  dt |> Datetime.end_of_month |> dump_datetime;
  [%expect {| 2026-03-31 23:59:59 |}]
;;

let%expect_test "start_of_day already aligned" =
  "2026-03-19 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.start_of_day
  |> dump_datetime;
  [%expect {| 2026-03-19 00:00:00 |}]
;;

let%expect_test "end_of_day already aligned" =
  "2026-03-19 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.end_of_day
  |> dump_datetime;
  [%expect {| 2026-03-19 23:59:59 |}]
;;

let%expect_test "end_of_day near midnight" =
  "2026-03-19 23:59:58"
  |> Datetime.from_string_exn
  |> Datetime.end_of_day
  |> dump_datetime;
  [%expect {| 2026-03-19 23:59:59 |}]
;;

let%expect_test "start_of_day just after midnight" =
  "2026-03-19 00:00:01"
  |> Datetime.from_string_exn
  |> Datetime.start_of_day
  |> dump_datetime;
  [%expect {| 2026-03-19 00:00:00 |}]
;;

let%expect_test "start_of_week already monday" =
  "2026-03-16 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.start_of_week
  |> dump_datetime;
  [%expect {| 2026-03-16 00:00:00 |}]
;;

let%expect_test "end_of_week already sunday" =
  "2026-03-22 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.end_of_week
  |> dump_datetime;
  [%expect {| 2026-03-22 23:59:59 |}]
;;

let%expect_test "start_of_week sunday boundary" =
  "2026-03-15 00:00:01"
  |> Datetime.from_string_exn
  |> Datetime.start_of_week ~week_start:Weekday.Sun
  |> dump_datetime;
  [%expect {| 2026-03-15 00:00:00 |}]
;;

let%expect_test "end_of_month 30 days" =
  "2026-04-15 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.end_of_month
  |> dump_datetime;
  [%expect {| 2026-04-30 23:59:59 |}]
;;

let%expect_test "end_of_month non-leap february" =
  "2025-02-10 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.end_of_month
  |> dump_datetime;
  [%expect {| 2025-02-28 23:59:59 |}]
;;

let%expect_test "start_of_quarter boundary" =
  "2026-04-01 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.start_of_quarter
  |> dump_datetime;
  [%expect {| 2026-04-01 00:00:00 |}]
;;

let%expect_test "end_of_quarter boundary" =
  "2026-06-30 23:00:00"
  |> Datetime.from_string_exn
  |> Datetime.end_of_quarter
  |> dump_datetime;
  [%expect {| 2026-06-30 23:59:59 |}]
;;

let%expect_test "start_of_year boundary" =
  "2026-01-01 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.start_of_year
  |> dump_datetime;
  [%expect {| 2026-01-01 00:00:00 |}]
;;

let%expect_test "end_of_year boundary" =
  "2026-12-31 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.end_of_year
  |> dump_datetime;
  [%expect {| 2026-12-31 23:59:59 |}]
;;

let%expect_test "start_of_month then end_of_month" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_month
  |> Datetime.end_of_month
  |> dump_datetime;
  [%expect {| 2026-03-31 23:59:59 |}]
;;

let%expect_test "start_of_week then end_of_week" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_week
  |> Datetime.end_of_week
  |> dump_datetime;
  [%expect {| 2026-03-22 23:59:59 |}]
;;

let%expect_test "start_of_minute" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_minute
  |> dump_datetime;
  [%expect {| 2026-03-19 12:34:00 |}]
;;

let%expect_test "end_of_minute" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.end_of_minute
  |> dump_datetime;
  [%expect {| 2026-03-19 12:34:59 |}]
;;

let%expect_test "start_of_hour" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_hour
  |> dump_datetime;
  [%expect {| 2026-03-19 12:00:00 |}]
;;

let%expect_test "end_of_hour" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.end_of_hour
  |> dump_datetime;
  [%expect {| 2026-03-19 12:59:59 |}]
;;

let%expect_test "start_of_morning" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_morning
  |> dump_datetime;
  [%expect {| 2026-03-19 05:00:00 |}]
;;

let%expect_test "end_of_morning" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.end_of_morning
  |> dump_datetime;
  [%expect {| 2026-03-19 11:59:59 |}]
;;

let%expect_test "start_of_afternoon" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_afternoon
  |> dump_datetime;
  [%expect {| 2026-03-19 12:00:00 |}]
;;

let%expect_test "end_of_afternoon" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.end_of_afternoon
  |> dump_datetime;
  [%expect {| 2026-03-19 16:59:59 |}]
;;

let%expect_test "start_of_evening" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_evening
  |> dump_datetime;
  [%expect {| 2026-03-19 17:00:00 |}]
;;

let%expect_test "end_of_evening" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.end_of_evening
  |> dump_datetime;
  [%expect {| 2026-03-19 20:59:59 |}]
;;

let%expect_test "start_of_night" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.start_of_night
  |> dump_datetime;
  [%expect {| 2026-03-19 21:00:00 |}]
;;

let%expect_test "end_of_night" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.end_of_night
  |> dump_datetime;
  [%expect {| 2026-03-19 04:59:59 |}]
;;
