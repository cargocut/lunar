(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "is_am" =
  "2026-03-19 11:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_am
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_am" =
  "2026-03-19 14:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_am
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_am - lower bound" =
  "2026-03-19 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_am
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_am - upper bound" =
  "2026-03-19 11:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_am
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_am - just after" =
  "2026-03-19 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_am
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_pm - lower bound" =
  "2026-03-19 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_pm
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_pm - upper bound" =
  "2026-03-19 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_pm
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_pm - just before" =
  "2026-03-19 11:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_pm
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_noon exact" =
  "2026-03-19 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_noon
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_noon - just before" =
  "2026-03-19 11:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_noon
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_midnight exact" =
  "2026-03-19 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_midnight
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_midnight - just after" =
  "2026-03-19 00:00:01"
  |> Datetime.from_string_exn
  |> Datetime.is_midnight
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_morning lower bound" =
  "2026-03-19 05:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_morning
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_morning upper bound" =
  "2026-03-19 11:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_morning
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_morning before" =
  "2026-03-19 04:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_morning
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_afternoon lower bound" =
  "2026-03-19 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_afternoon
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_afternoon upper bound" =
  "2026-03-19 16:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_afternoon
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_afternoon after" =
  "2026-03-19 17:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_afternoon
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_evening lower bound" =
  "2026-03-19 17:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_evening
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_evening upper bound" =
  "2026-03-19 20:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_evening
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_evening before" =
  "2026-03-19 16:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_evening
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_night late evening" =
  "2026-03-19 21:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_night
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_night before midnight" =
  "2026-03-19 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_night
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_night after midnight" =
  "2026-03-19 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_night
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_night upper bound" =
  "2026-03-19 04:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_night
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_night just after" =
  "2026-03-19 05:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_night
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "am/pm partition" =
  let dt = Datetime.from_string_exn "2026-03-19 10:00:00" in
  dump_bool (Datetime.is_am dt && not (Datetime.is_pm dt));
  [%expect {| true |}]
;;

let%expect_test "no overlap morning/afternoon" =
  let dt = Datetime.from_string_exn "2026-03-19 12:00:00" in
  dump_bool (Datetime.is_morning dt && Datetime.is_afternoon dt);
  [%expect {| false |}]
;;

let%expect_test "night overlaps midnight correctly" =
  let dt = Datetime.from_string_exn "2026-03-19 02:00:00" in
  dump_bool (Datetime.is_night dt);
  [%expect {| true |}]
;;

let%expect_test "is_weekend saturday" =
  "2026-03-21 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_weekend
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_weekend sunday" =
  "2026-03-22 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_weekend
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_weekend weekday" =
  "2026-03-18 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_weekend
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_weekday monday" =
  "2026-03-16 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_weekday
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_weekday saturday" =
  "2026-03-21 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_weekday
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "weekend/weekday complement" =
  let dt = Datetime.from_string_exn "2026-03-21 12:00:00" in
  dump_bool (Datetime.is_weekend dt && not (Datetime.is_weekday dt));
  [%expect {| true |}]
;;

let%expect_test "is_leap_year true (2024)" =
  "2024-03-01 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_leap_year
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_leap_year false (2025)" =
  "2025-03-01 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_leap_year
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_leap_year century non-leap (1900)" =
  "1900-03-01 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_leap_year
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_leap_year century leap (2000)" =
  "2000-03-01 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_leap_year
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_first_day_of_month true" =
  "2026-03-01 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_first_day_of_month
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_first_day_of_month false" =
  "2026-03-02 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_first_day_of_month
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_last_day_of_month 31 days" =
  "2026-03-31 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_month
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_last_day_of_month 30 days" =
  "2026-04-30 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_month
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_last_day_of_month feb non-leap" =
  "2025-02-28 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_month
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_last_day_of_month feb leap" =
  "2024-02-29 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_month
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_last_day_of_month false" =
  "2026-03-30 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_month
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_first_day_of_year true" =
  "2026-01-01 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_first_day_of_year
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_first_day_of_year false" =
  "2026-01-02 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_first_day_of_year
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_last_day_of_year true" =
  "2026-12-31 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_year
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_last_day_of_year false" =
  "2026-12-30 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_year
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "first and last day of month cannot both be true" =
  let dt = Datetime.from_string_exn "2026-03-15 12:00:00" in
  dump_bool
    (Datetime.is_first_day_of_month dt && Datetime.is_last_day_of_month dt);
  [%expect {| false |}]
;;

let%expect_test "first and last day of year cannot both be true" =
  let dt = Datetime.from_string_exn "2026-06-15 12:00:00" in
  dump_bool (Datetime.is_first_day_of_year dt && Datetime.is_last_day_of_year dt);
  [%expect {| false |}]
;;

let%expect_test "first day of month implies not last (except degenerate)" =
  let dt = Datetime.from_string_exn "2026-03-01 12:00:00" in
  dump_bool (Datetime.is_last_day_of_month dt);
  [%expect {| false |}]
;;

let%expect_test "is_first_day_of_quarter - Q1" =
  "2026-01-01 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_first_day_of_quarter
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_first_day_of_quarter - Q2" =
  "2026-04-01 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_first_day_of_quarter
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_first_day_of_quarter - Q3" =
  "2026-07-01 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_first_day_of_quarter
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_first_day_of_quarter - Q4" =
  "2026-10-01 08:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_first_day_of_quarter
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_first_day_of_quarter - false (middle of quarter)" =
  "2026-03-15 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_first_day_of_quarter
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_first_day_of_quarter - false (day before boundary)" =
  "2026-03-31 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_first_day_of_quarter
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_first_day_of_quarter - leap year still valid" =
  "2024-04-01 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_first_day_of_quarter
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_last_day_of_quarter - Q1" =
  "2026-03-31 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_quarter
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_last_day_of_quarter - Q2" =
  "2026-06-30 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_quarter
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_last_day_of_quarter - Q3" =
  "2026-09-30 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_quarter
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_last_day_of_quarter - Q4" =
  "2026-12-31 08:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_quarter
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_last_day_of_quarter - false (not boundary)" =
  "2026-03-30 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_quarter
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_last_day_of_quarter - false (start of quarter)" =
  "2026-04-01 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_quarter
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_last_day_of_quarter - leap year Q1" =
  "2024-03-31 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_quarter
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_last_day_of_quarter - feb 29 not quarter end" =
  "2024-02-29 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_last_day_of_quarter
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "first and last cannot both be true" =
  let dt = Datetime.from_string_exn "2026-03-31 12:00:00" in
  dump_bool
    (Datetime.is_first_day_of_quarter dt && Datetime.is_last_day_of_quarter dt);
  [%expect {| false |}]
;;

let%expect_test "quarter boundaries consistency" =
  let start = Datetime.from_string_exn "2026-04-01 00:00:00" in
  let prev = Datetime.pred_day start in
  dump_bool (Datetime.is_last_day_of_quarter prev);
  [%expect {| true |}]
;;
