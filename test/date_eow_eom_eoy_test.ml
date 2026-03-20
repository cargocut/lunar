(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "end of year" =
  let date = Date.make_exn' ~year:2026 ~month:3 ~day:20 () in
  date |> Date.end_of_year |> dump_date;
  [%expect {| 2026-12-31 |}]
;;

let%expect_test "start of year" =
  let date = Date.make_exn' ~year:2026 ~month:3 ~day:20 () in
  date |> Date.start_of_year |> dump_date;
  [%expect {| 2026-01-01 |}]
;;

let%expect_test "end of month" =
  let date = Date.make_exn' ~year:2026 ~month:3 ~day:20 () in
  date |> Date.end_of_month |> dump_date;
  [%expect {| 2026-03-31 |}]
;;

let%expect_test "start of month" =
  let date = Date.make_exn' ~year:2026 ~month:3 ~day:20 () in
  date |> Date.start_of_month |> dump_date;
  [%expect {| 2026-03-01 |}]
;;

let%expect_test "start of week" =
  let date = Date.make_exn' ~year:2026 ~month:3 ~day:20 () in
  date |> Date.start_of_week |> dump_date;
  [%expect {| 2026-03-16 |}]
;;

let%expect_test "start of week" =
  let date = Date.make_exn' ~year:2026 ~month:3 ~day:20 () in
  date |> Date.start_of_week ~week_start:Weekday.Sun |> dump_date;
  [%expect {| 2026-03-15 |}]
;;

let%expect_test "end of week" =
  let date = Date.make_exn' ~year:2026 ~month:3 ~day:20 () in
  date |> Date.end_of_week |> dump_date;
  [%expect {| 2026-03-22 |}]
;;

let%expect_test "end of week" =
  let date = Date.make_exn' ~year:2026 ~month:3 ~day:20 () in
  date |> Date.end_of_week ~week_start:Weekday.Sun |> dump_date;
  [%expect {| 2026-03-21 |}]
;;

let%expect_test "start of month - already first day" =
  let date = Date.make_exn' ~year:2026 ~month:3 ~day:1 () in
  date |> Date.start_of_month |> dump_date;
  [%expect {| 2026-03-01 |}]
;;

let%expect_test "end of month - already last day" =
  let date = Date.make_exn' ~year:2026 ~month:3 ~day:31 () in
  date |> Date.end_of_month |> dump_date;
  [%expect {| 2026-03-31 |}]
;;

let%expect_test "start of year - already first day" =
  let date = Date.make_exn' ~year:2026 ~month:1 ~day:1 () in
  date |> Date.start_of_year |> dump_date;
  [%expect {| 2026-01-01 |}]
;;

let%expect_test "end of year - already last day" =
  let date = Date.make_exn' ~year:2026 ~month:12 ~day:31 () in
  date |> Date.end_of_year |> dump_date;
  [%expect {| 2026-12-31 |}]
;;

let%expect_test "end of month - feb non-leap year" =
  let date = Date.make_exn' ~year:2025 ~month:2 ~day:10 () in
  date |> Date.end_of_month |> dump_date;
  [%expect {| 2025-02-28 |}]
;;

let%expect_test "end of month - feb leap year" =
  let date = Date.make_exn' ~year:2024 ~month:2 ~day:10 () in
  date |> Date.end_of_month |> dump_date;
  [%expect {| 2024-02-29 |}]
;;

let%expect_test "start of week - already monday" =
  let date = Date.make_exn' ~year:2026 ~month:3 ~day:16 () in
  date |> Date.start_of_week |> dump_date;
  [%expect {| 2026-03-16 |}]
;;

let%expect_test "end of week - already sunday (iso)" =
  let date = Date.make_exn' ~year:2026 ~month:3 ~day:22 () in
  date |> Date.end_of_week |> dump_date;
  [%expect {| 2026-03-22 |}]
;;

let%expect_test "start of week - sunday start already aligned" =
  let date = Date.make_exn' ~year:2026 ~month:3 ~day:15 () in
  date |> Date.start_of_week ~week_start:Weekday.Sun |> dump_date;
  [%expect {| 2026-03-15 |}]
;;

let%expect_test "start of week - crosses month" =
  let date = Date.make_exn' ~year:2026 ~month:4 ~day:1 () in
  date |> Date.start_of_week |> dump_date;
  [%expect {| 2026-03-30 |}]
;;

let%expect_test "end of week - crosses month" =
  let date = Date.make_exn' ~year:2026 ~month:3 ~day:30 () in
  date |> Date.end_of_week |> dump_date;
  [%expect {| 2026-04-05 |}]
;;

let%expect_test "start of week - crosses year" =
  let date = Date.make_exn' ~year:2026 ~month:1 ~day:1 () in
  date |> Date.start_of_week |> dump_date;
  [%expect {| 2025-12-29 |}]
;;

let%expect_test "end of week - crosses year" =
  let date = Date.make_exn' ~year:2026 ~month:12 ~day:31 () in
  date |> Date.end_of_week |> dump_date;
  [%expect {| 2027-01-03 |}]
;;

let%expect_test "week invariant - inside bounds" =
  let d = Date.make_exn' ~year:2026 ~month:3 ~day:20 () in
  let s = Date.start_of_week d in
  let e = Date.end_of_week d in
  dump_date s;
  dump_date d;
  dump_date e;
  [%expect
    {|
    2026-03-16
    2026-03-20
    2026-03-22
  |}]
;;

let%expect_test "end_of_week = start_of_week + 6 days" =
  let d = Date.make_exn' ~year:2026 ~month:3 ~day:20 () in
  let s = Date.start_of_week d in
  let e = Date.end_of_week d in
  Date.add_days 6 s |> dump_date;
  dump_date e;
  [%expect
    {|
    2026-03-22
    2026-03-22
  |}]
;;

let%expect_test "week range consistency - sunday start" =
  let d = Date.make_exn' ~year:2026 ~month:3 ~day:20 () in
  let s = Date.start_of_week ~week_start:Weekday.Sun d in
  let e = Date.end_of_week ~week_start:Weekday.Sun d in
  dump_date s;
  dump_date e;
  [%expect
    {|
    2026-03-15
    2026-03-21
  |}]
;;
