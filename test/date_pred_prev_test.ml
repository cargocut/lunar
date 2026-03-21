(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "tomorrow" =
  "2026-03-20" |> Date.from_string_exn |> Date.tomorrow |> dump_date;
  [%expect {| 2026-03-21 |}]
;;

let%expect_test "yesterday" =
  "2026-03-20" |> Date.from_string_exn |> Date.yesterday |> dump_date;
  [%expect {| 2026-03-19 |}]
;;

let%expect_test "tomorrow year boundaries" =
  "2026-12-31" |> Date.from_string_exn |> Date.tomorrow |> dump_date;
  [%expect {| 2027-01-01 |}]
;;

let%expect_test "yesterday" =
  "2026-01-01" |> Date.from_string_exn |> Date.yesterday |> dump_date;
  [%expect {| 2025-12-31 |}]
;;

let%expect_test "yesterday" =
  "0001-01-01" |> Date.from_string_exn |> Date.yesterday |> dump_date;
  [%expect {| 0000-12-31 |}]
;;

let%expect_test "next_week" =
  "2026-03-20" |> Date.from_string_exn |> Date.next_week |> dump_date;
  [%expect {| 2026-03-23 |}]
;;

let%expect_test "next_week (start on sunday)" =
  "2026-03-20"
  |> Date.from_string_exn
  |> Date.next_week ~week_start:Weekday.Sun
  |> dump_date;
  [%expect {| 2026-03-22 |}]
;;

let%expect_test "prev_week" =
  "2026-03-20" |> Date.from_string_exn |> Date.prev_week |> dump_date;
  [%expect {| 2026-03-09 |}]
;;

let%expect_test "prev_week (start on sunday)" =
  "2026-03-20"
  |> Date.from_string_exn
  |> Date.prev_week ~week_start:Weekday.Sun
  |> dump_date;
  [%expect {| 2026-03-08 |}]
;;

let%expect_test "next_month" =
  "2026-03-20" |> Date.from_string_exn |> Date.next_month |> dump_date;
  [%expect {| 2026-04-01 |}]
;;

let%expect_test "prev_month" =
  "2026-03-20" |> Date.from_string_exn |> Date.prev_month |> dump_date;
  [%expect {| 2026-02-01 |}]
;;

let%expect_test "next_quarter" =
  "2026-03-20" |> Date.from_string_exn |> Date.next_quarter |> dump_date;
  [%expect {| 2026-04-01 |}]
;;

let%expect_test "prev_quarter" =
  "2026-03-20" |> Date.from_string_exn |> Date.prev_quarter |> dump_date;
  [%expect {| 2025-10-01 |}]
;;

let%expect_test "next_year" =
  "2026-03-20" |> Date.from_string_exn |> Date.next_year |> dump_date;
  [%expect {| 2027-01-01 |}]
;;

let%expect_test "prev_year" =
  "2026-03-20" |> Date.from_string_exn |> Date.prev_year |> dump_date;
  [%expect {| 2025-01-01 |}]
;;

let%expect_test "tomorrow on leap day" =
  "2024-02-28" |> Date.from_string_exn |> Date.tomorrow |> dump_date;
  [%expect {| 2024-02-29 |}]
;;

let%expect_test "tomorrow after leap day" =
  "2024-02-29" |> Date.from_string_exn |> Date.tomorrow |> dump_date;
  [%expect {| 2024-03-01 |}]
;;

let%expect_test "yesterday before leap day" =
  "2024-03-01" |> Date.from_string_exn |> Date.yesterday |> dump_date;
  [%expect {| 2024-02-29 |}]
;;

let%expect_test "next_week starting on sunday at month boundary" =
  "2026-01-30"
  |> Date.from_string_exn
  |> Date.next_week ~week_start:Weekday.Sun
  |> dump_date;
  [%expect {| 2026-02-01 |}]
;;

let%expect_test "prev_week starting on sunday at month boundary" =
  "2026-02-01"
  |> Date.from_string_exn
  |> Date.prev_week ~week_start:Weekday.Sun
  |> dump_date;
  [%expect {| 2026-01-25 |}]
;;
