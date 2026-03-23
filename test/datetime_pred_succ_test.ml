(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "succ_second" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.succ_second
  |> dump_datetime;
  [%expect {| 2026-03-19 12:34:57 |}]
;;

let%expect_test "succ_second" =
  "2026-03-19 12:34:59"
  |> Datetime.from_string_exn
  |> Datetime.succ_second
  |> dump_datetime;
  [%expect {| 2026-03-19 12:35:00 |}]
;;

let%expect_test "pred_second" =
  "2026-03-19 12:34:59"
  |> Datetime.from_string_exn
  |> Datetime.pred_second
  |> dump_datetime;
  [%expect {| 2026-03-19 12:34:58 |}]
;;

let%expect_test "pred_second" =
  "2026-03-19 12:34:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_second
  |> dump_datetime;
  [%expect {| 2026-03-19 12:33:59 |}]
;;

let%expect_test "succ_minute" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.succ_minute
  |> dump_datetime;
  [%expect {| 2026-03-19 12:35:00 |}]
;;

let%expect_test "pred_minute" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.pred_minute
  |> dump_datetime;
  [%expect {| 2026-03-19 12:33:00 |}]
;;

let%expect_test "succ_hour" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.succ_hour
  |> dump_datetime;
  [%expect {| 2026-03-19 13:00:00 |}]
;;

let%expect_test "pred_hour" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.pred_hour
  |> dump_datetime;
  [%expect {| 2026-03-19 11:00:00 |}]
;;

let%expect_test "succ_second - end of day" =
  "2026-03-19 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.succ_second
  |> dump_datetime;
  [%expect {| 2026-03-20 00:00:00 |}]
;;

let%expect_test "pred_second - start of day" =
  "2026-03-19 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_second
  |> dump_datetime;
  [%expect {| 2026-03-18 23:59:59 |}]
;;

let%expect_test "succ_minute - end of hour" =
  "2026-03-19 12:59:59"
  |> Datetime.from_string_exn
  |> Datetime.succ_minute
  |> dump_datetime;
  [%expect {| 2026-03-19 13:00:00 |}]
;;

let%expect_test "succ_minute - end of day" =
  "2026-03-19 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.succ_minute
  |> dump_datetime;
  [%expect {| 2026-03-20 00:00:00 |}]
;;

let%expect_test "pred_minute - start of hour" =
  "2026-03-19 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_minute
  |> dump_datetime;
  [%expect {| 2026-03-19 11:59:00 |}]
;;

let%expect_test "pred_minute - start of day" =
  "2026-03-19 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_minute
  |> dump_datetime;
  [%expect {| 2026-03-18 23:59:00 |}]
;;

let%expect_test "succ_minute - end of hour" =
  "2026-03-19 12:59:59"
  |> Datetime.from_string_exn
  |> Datetime.succ_minute
  |> dump_datetime;
  [%expect {| 2026-03-19 13:00:00 |}]
;;

let%expect_test "succ_minute - end of day" =
  "2026-03-19 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.succ_minute
  |> dump_datetime;
  [%expect {| 2026-03-20 00:00:00 |}]
;;

let%expect_test "pred_minute - start of hour" =
  "2026-03-19 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_minute
  |> dump_datetime;
  [%expect {| 2026-03-19 11:59:00 |}]
;;

let%expect_test "pred_minute - start of day" =
  "2026-03-19 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_minute
  |> dump_datetime;
  [%expect {| 2026-03-18 23:59:00 |}]
;;

let%expect_test "succ_hour - end of day" =
  "2026-03-19 23:34:56"
  |> Datetime.from_string_exn
  |> Datetime.succ_hour
  |> dump_datetime;
  [%expect {| 2026-03-20 00:00:00 |}]
;;

let%expect_test "pred_hour - start of day" =
  "2026-03-19 00:34:56"
  |> Datetime.from_string_exn
  |> Datetime.pred_hour
  |> dump_datetime;
  [%expect {| 2026-03-18 23:00:00 |}]
;;

let%expect_test "succ_second - end of month" =
  "2026-01-31 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.succ_second
  |> dump_datetime;
  [%expect {| 2026-02-01 00:00:00 |}]
;;

let%expect_test "pred_second - start of month" =
  "2026-02-01 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_second
  |> dump_datetime;
  [%expect {| 2026-01-31 23:59:59 |}]
;;

let%expect_test "succ_second - end of year" =
  "2026-12-31 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.succ_second
  |> dump_datetime;
  [%expect {| 2027-01-01 00:00:00 |}]
;;

let%expect_test "pred_second - start of year" =
  "2026-01-01 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_second
  |> dump_datetime;
  [%expect {| 2025-12-31 23:59:59 |}]
;;

let%expect_test "succ_second - leap day" =
  "2024-02-29 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.succ_second
  |> dump_datetime;
  [%expect {| 2024-03-01 00:00:00 |}]
;;

let%expect_test "pred_second - leap day" =
  "2024-03-01 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_second
  |> dump_datetime;
  [%expect {| 2024-02-29 23:59:59 |}]
;;

let%expect_test "pred_minute <= dt <= succ_minute" =
  let dt = Datetime.from_string_exn "2026-03-19 12:34:56" in
  let p = Datetime.pred_minute dt
  and s = Datetime.succ_minute dt in
  dump_bool Datetime.(p <= dt && dt <= s);
  [%expect {| true |}]
;;

let%expect_test "pred after succ is stable" =
  let dt = Datetime.from_string_exn "2026-03-19 12:34:56" in
  let s = Datetime.succ_minute dt in
  let p = Datetime.pred_minute s in
  dump_bool (Datetime.equal p (Datetime.truncate Resolution.minute dt));
  [%expect {| true |}]
;;

let%expect_test "succ_day - basic" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.succ_day
  |> dump_datetime;
  [%expect {| 2026-03-20 00:00:00 |}]
;;

let%expect_test "pred_day - basic" =
  "2026-03-19 12:34:56"
  |> Datetime.from_string_exn
  |> Datetime.pred_day
  |> dump_datetime;
  [%expect {| 2026-03-18 00:00:00 |}]
;;

let%expect_test "succ_day - end of month" =
  "2026-01-31 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.succ_day
  |> dump_datetime;
  [%expect {| 2026-02-01 00:00:00 |}]
;;

let%expect_test "pred_day - start of month" =
  "2026-02-01 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_day
  |> dump_datetime;
  [%expect {| 2026-01-31 00:00:00 |}]
;;

let is_monday d = Weekday.equal (Date.day_of_week d) Weekday.Mon

let%expect_test "succ_day with predicate" =
  "2026-03-17 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.succ_day ~where:is_monday
  |> dump_datetime;
  [%expect {| 2026-03-23 00:00:00 |}]
;;

let%expect_test "pred_day with predicate" =
  "2026-03-17 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_day ~where:is_monday
  |> dump_datetime;
  [%expect {| 2026-03-16 00:00:00 |}]
;;

let%expect_test "succ_day_of_week - same week" =
  "2026-03-17 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.succ_day_of_week Weekday.Thu
  |> dump_datetime;
  [%expect {| 2026-03-19 00:00:00 |}]
;;

let%expect_test "succ_day_of_week - wrap next week" =
  "2026-03-19 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.succ_day_of_week Weekday.Mon
  |> dump_datetime;
  [%expect {| 2026-03-23 00:00:00 |}]
;;

let%expect_test "pred_day_of_week - wrap previous week" =
  "2026-03-19 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_day_of_week Weekday.Mon
  |> dump_datetime;
  [%expect {| 2026-03-16 00:00:00 |}]
;;

let%expect_test "succ_weekday - normal" =
  "2026-03-18 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.succ_weekday
  |> dump_datetime;
  [%expect {| 2026-03-19 00:00:00 |}]
;;

let%expect_test "succ_weekday - friday skips weekend" =
  "2026-03-20 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.succ_weekday
  |> dump_datetime;
  [%expect {| 2026-03-23 00:00:00 |}]
;;

let%expect_test "pred_weekday - monday skips weekend" =
  "2026-03-23 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_weekday
  |> dump_datetime;
  [%expect {| 2026-03-20 00:00:00 |}]
;;

let%expect_test "succ_week - default (Mon)" =
  "2026-03-19 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.succ_week
  |> dump_datetime;
  [%expect {| 2026-03-23 00:00:00 |}]
;;

let%expect_test "pred_week - default (Mon)" =
  "2026-03-19 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_week
  |> dump_datetime;
  [%expect {| 2026-03-09 00:00:00 |}]
;;

let%expect_test "succ_week - sunday start" =
  "2026-03-19 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.succ_week ~week_start:Weekday.Sun
  |> dump_datetime;
  [%expect {| 2026-03-22 00:00:00 |}]
;;

let%expect_test "succ_month - basic" =
  "2026-03-19 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.succ_month
  |> dump_datetime;
  [%expect {| 2026-04-01 00:00:00 |}]
;;

let%expect_test "pred_month - basic" =
  "2026-03-19 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_month
  |> dump_datetime;
  [%expect {| 2026-02-01 00:00:00 |}]
;;

let%expect_test "succ_month - december rollover" =
  "2026-12-15 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.succ_month
  |> dump_datetime;
  [%expect {| 2027-01-01 00:00:00 |}]
;;

let%expect_test "succ_quarter - basic" =
  "2026-02-15 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.succ_quarter
  |> dump_datetime;
  [%expect {| 2026-04-01 00:00:00 |}]
;;

let%expect_test "pred_quarter - basic" =
  "2026-05-10 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_quarter
  |> dump_datetime;
  [%expect {| 2026-01-01 00:00:00 |}]
;;

let%expect_test "succ_year - basic" =
  "2026-03-19 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.succ_year
  |> dump_datetime;
  [%expect {| 2027-01-01 00:00:00 |}]
;;

let%expect_test "pred_year - basic" =
  "2026-03-19 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_year
  |> dump_datetime;
  [%expect {| 2025-01-01 00:00:00 |}]
;;

let%expect_test "succ_month - leap february" =
  "2024-02-15 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.succ_month
  |> dump_datetime;
  [%expect {| 2024-03-01 00:00:00 |}]
;;

let%expect_test "pred_month - after leap february" =
  "2024-03-15 10:00:00"
  |> Datetime.from_string_exn
  |> Datetime.pred_month
  |> dump_datetime;
  [%expect {| 2024-02-01 00:00:00 |}]
;;
