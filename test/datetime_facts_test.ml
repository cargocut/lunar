(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "hour" =
  "2026-03-19 21:22:23"
  |> Datetime.from_string_exn
  |> Datetime.hour
  |> print_int;
  [%expect {| 21 |}]
;;

let%expect_test "minute" =
  "2026-03-19 21:22:23"
  |> Datetime.from_string_exn
  |> Datetime.minute
  |> print_int;
  [%expect {| 22 |}]
;;

let%expect_test "second" =
  "2026-03-19 21:22:23"
  |> Datetime.from_string_exn
  |> Datetime.second
  |> print_int;
  [%expect {| 23 |}]
;;

let%expect_test "day_of_month" =
  "2026-03-19 21:22:23"
  |> Datetime.from_string_exn
  |> Datetime.day_of_month
  |> print_int;
  [%expect {| 19 |}]
;;

let%expect_test "month" =
  "2026-03-19 21:22:23"
  |> Datetime.from_string_exn
  |> Datetime.month
  |> dump_month;
  [%expect {| march |}]
;;

let%expect_test "year" =
  "2026-03-19 21:22:23"
  |> Datetime.from_string_exn
  |> Datetime.year
  |> print_int;
  [%expect {| 2026 |}]
;;

let%expect_test "era" =
  "2026-03-19 21:22:23" |> Datetime.from_string_exn |> Datetime.era |> dump_era;
  [%expect {| ce |}]
;;

let%expect_test "year_of_era" =
  "2026-03-19 21:22:23"
  |> Datetime.from_string_exn
  |> Datetime.year_of_era
  |> print_int;
  [%expect {| 2026 |}]
;;

let%expect_test "century_of_era" =
  "2026-03-19 21:22:23"
  |> Datetime.from_string_exn
  |> Datetime.century_of_era
  |> print_int;
  [%expect {| 21 |}]
;;

let%expect_test "year_of_century" =
  "2026-03-19 21:22:23"
  |> Datetime.from_string_exn
  |> Datetime.year_of_century
  |> print_int;
  [%expect {| 26 |}]
;;

let%expect_test "quarter" =
  "2026-03-19 21:22:23"
  |> Datetime.from_string_exn
  |> Datetime.quarter
  |> print_int;
  [%expect {| 1 |}]
;;

let%expect_test "day_of_week" =
  "2026-03-19 21:22:23"
  |> Datetime.from_string_exn
  |> Datetime.day_of_week
  |> dump_weekday;
  [%expect {| thursday |}]
;;

let%expect_test "day_of_year" =
  "2026-03-19 21:22:23"
  |> Datetime.from_string_exn
  |> Datetime.day_of_year
  |> print_int;
  [%expect {| 78 |}]
;;

let%expect_test "week_of_year" =
  "2026-03-19 21:22:23"
  |> Datetime.from_string_exn
  |> dump_datetime_iso_week_of_year;
  [%expect {| 2026 W12, thu/4 |}]
;;

let%expect_test "hour - midnight" =
  "2026-03-19 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.hour
  |> print_int;
  [%expect {| 0 |}]
;;

let%expect_test "hour - last hour" =
  "2026-03-19 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.hour
  |> print_int;
  [%expect {| 23 |}]
;;

let%expect_test "minute - boundary" =
  "2026-03-19 21:00:59"
  |> Datetime.from_string_exn
  |> Datetime.minute
  |> print_int;
  [%expect {| 0 |}]
;;

let%expect_test "second - boundary" =
  "2026-03-19 21:22:00"
  |> Datetime.from_string_exn
  |> Datetime.second
  |> print_int;
  [%expect {| 0 |}]
;;

let%expect_test "day_of_month - first day" =
  "2026-03-01" |> Datetime.from_string_exn |> Datetime.day_of_month |> print_int;
  [%expect {| 1 |}]
;;

let%expect_test "day_of_month - last day (31)" =
  "2026-03-31" |> Datetime.from_string_exn |> Datetime.day_of_month |> print_int;
  [%expect {| 31 |}]
;;

let%expect_test "day_of_month - feb non leap" =
  "2025-02-28" |> Datetime.from_string_exn |> Datetime.day_of_month |> print_int;
  [%expect {| 28 |}]
;;

let%expect_test "day_of_month - feb leap" =
  "2024-02-29" |> Datetime.from_string_exn |> Datetime.day_of_month |> print_int;
  [%expect {| 29 |}]
;;

let%expect_test "day_of_year - first day" =
  "2026-01-01" |> Datetime.from_string_exn |> Datetime.day_of_year |> print_int;
  [%expect {| 1 |}]
;;

let%expect_test "day_of_year - last day (non leap)" =
  "2025-12-31" |> Datetime.from_string_exn |> Datetime.day_of_year |> print_int;
  [%expect {| 365 |}]
;;

let%expect_test "day_of_year - last day (leap)" =
  "2024-12-31" |> Datetime.from_string_exn |> Datetime.day_of_year |> print_int;
  [%expect {| 366 |}]
;;

let%expect_test "quarter - boundary Q1 end" =
  "2026-03-31" |> Datetime.from_string_exn |> Datetime.quarter |> print_int;
  [%expect {| 1 |}]
;;

let%expect_test "quarter - boundary Q2 start" =
  "2026-04-01" |> Datetime.from_string_exn |> Datetime.quarter |> print_int;
  [%expect {| 2 |}]
;;

let%expect_test "quarter - Q4" =
  "2026-12-31" |> Datetime.from_string_exn |> Datetime.quarter |> print_int;
  [%expect {| 4 |}]
;;

let%expect_test "day_of_week - known sunday" =
  "2026-03-22"
  |> Datetime.from_string_exn
  |> Datetime.day_of_week
  |> dump_weekday;
  [%expect {| sunday |}]
;;

let%expect_test "day_of_week - epoch" =
  "1970-01-01"
  |> Datetime.from_string_exn
  |> Datetime.day_of_week
  |> dump_weekday;
  [%expect {| thursday |}]
;;

let%expect_test "week_of_year - first ISO week" =
  "2021-01-04" (* Monday *)
  |> Datetime.from_string_exn
  |> dump_datetime_iso_week_of_year;
  [%expect {| 2021 W1, mon/1 |}]
;;

let%expect_test "week_of_year - belongs to previous year" =
  "2021-01-01" |> Datetime.from_string_exn |> dump_datetime_iso_week_of_year;
  [%expect {| 2020 W53, fri/5 |}]
;;

let%expect_test "week_of_year - last ISO week" =
  "2020-12-31" |> Datetime.from_string_exn |> dump_datetime_iso_week_of_year;
  [%expect {| 2020 W53, thu/4 |}]
;;

let%expect_test "era - year zero" =
  "0000-01-01" |> Datetime.from_string_exn |> Datetime.era |> dump_era;
  [%expect {| bce |}]
;;

let%expect_test "year_of_era - year zero" =
  "0000-01-01" |> Datetime.from_string_exn |> Datetime.year_of_era |> print_int;
  [%expect {| 1 |}]
;;

let%expect_test "century_of_era - boundary" =
  "2000-01-01"
  |> Datetime.from_string_exn
  |> Datetime.century_of_era
  |> print_int;
  [%expect {| 20 |}]
;;

let%expect_test "year_of_century - boundary" =
  "2000-01-01"
  |> Datetime.from_string_exn
  |> Datetime.year_of_century
  |> print_int;
  [%expect {| 100 |}]
;;

let%expect_test "month consistency" =
  let d = Datetime.from_string_exn "2026-03-19" in
  let m = Datetime.month d in
  dump_bool (Month.to_int m = 3);
  [%expect {| true |}]
;;

let%expect_test "day_of_year monotonicity" =
  let d1 = Datetime.from_string_exn "2026-03-19" in
  let d2 = Datetime.from_string_exn "2026-03-20" in
  dump_bool (Datetime.day_of_year d2 > Datetime.day_of_year d1);
  [%expect {| true |}]
;;

let%expect_test "year - lower bound" =
  "0000-01-01" |> Datetime.from_string_exn |> Datetime.year |> print_int;
  [%expect {| 0 |}]
;;

let%expect_test "year - upper bound" =
  "9999-12-31" |> Datetime.from_string_exn |> Datetime.year |> print_int;
  [%expect {| 9999 |}]
;;
