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

let%expect_test "succ_week" =
  "2026-03-20" |> Date.from_string_exn |> Date.succ_week |> dump_date;
  [%expect {| 2026-03-23 |}]
;;

let%expect_test "succ_week (start on sunday)" =
  "2026-03-20"
  |> Date.from_string_exn
  |> Date.succ_week ~week_start:Weekday.Sun
  |> dump_date;
  [%expect {| 2026-03-22 |}]
;;

let%expect_test "pred_week" =
  "2026-03-20" |> Date.from_string_exn |> Date.pred_week |> dump_date;
  [%expect {| 2026-03-09 |}]
;;

let%expect_test "pred_week (start on sunday)" =
  "2026-03-20"
  |> Date.from_string_exn
  |> Date.pred_week ~week_start:Weekday.Sun
  |> dump_date;
  [%expect {| 2026-03-08 |}]
;;

let%expect_test "succ_month" =
  "2026-03-20" |> Date.from_string_exn |> Date.succ_month |> dump_date;
  [%expect {| 2026-04-01 |}]
;;

let%expect_test "pred_month" =
  "2026-03-20" |> Date.from_string_exn |> Date.pred_month |> dump_date;
  [%expect {| 2026-02-01 |}]
;;

let%expect_test "succ_quarter" =
  "2026-03-20" |> Date.from_string_exn |> Date.succ_quarter |> dump_date;
  [%expect {| 2026-04-01 |}]
;;

let%expect_test "pred_quarter" =
  "2026-03-20" |> Date.from_string_exn |> Date.pred_quarter |> dump_date;
  [%expect {| 2025-10-01 |}]
;;

let%expect_test "succ_year" =
  "2026-03-20" |> Date.from_string_exn |> Date.succ_year |> dump_date;
  [%expect {| 2027-01-01 |}]
;;

let%expect_test "pred_year" =
  "2026-03-20" |> Date.from_string_exn |> Date.pred_year |> dump_date;
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

let%expect_test "succ_week starting on sunday at month boundary" =
  "2026-01-30"
  |> Date.from_string_exn
  |> Date.succ_week ~week_start:Weekday.Sun
  |> dump_date;
  [%expect {| 2026-02-01 |}]
;;

let%expect_test "pred_week starting on sunday at month boundary" =
  "2026-02-01"
  |> Date.from_string_exn
  |> Date.pred_week ~week_start:Weekday.Sun
  |> dump_date;
  [%expect {| 2026-01-25 |}]
;;
