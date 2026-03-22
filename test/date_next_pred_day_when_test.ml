(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "next day of week" =
  let from = Date.make_exn' ~year:2026 ~month:3 ~day:16 () in
  Date.succ_day_of_week Weekday.Thu from |> dump_date;
  [%expect {| 2026-03-19 |}]
;;

let%expect_test "prev day of week" =
  let from = Date.make_exn' ~year:2026 ~month:3 ~day:16 () in
  Date.succ_day_of_week Weekday.Thu from |> dump_date;
  [%expect {| 2026-03-19 |}]
;;

let%expect_test "next day of week - same day skips to next week" =
  let from = Date.make_exn' ~year:2026 ~month:3 ~day:19 () in
  Date.succ_day_of_week Weekday.Thu from |> dump_date;
  [%expect {| 2026-03-26 |}]
;;

let%expect_test "prev day of week - same day skips to previous week" =
  let from = Date.make_exn' ~year:2026 ~month:3 ~day:19 () in
  Date.pred_day_of_week Weekday.Thu from |> dump_date;
  [%expect {| 2026-03-12 |}]
;;

let%expect_test "next day of week - across month" =
  let from = Date.make_exn' ~year:2026 ~month:3 ~day:30 () in
  Date.succ_day_of_week Weekday.Wed from |> dump_date;
  [%expect {| 2026-04-01 |}]
;;

let%expect_test "prev day of week - across month" =
  let from = Date.make_exn' ~year:2026 ~month:4 ~day:1 () in
  Date.pred_day_of_week Weekday.Mon from |> dump_date;
  [%expect {| 2026-03-30 |}]
;;

let%expect_test "next day of week - across year" =
  let from = Date.make_exn' ~year:2026 ~month:12 ~day:31 () in
  Date.succ_day_of_week Weekday.Mon from |> dump_date;
  [%expect {| 2027-01-04 |}]
;;

let%expect_test "prev day of week - across year" =
  let from = Date.make_exn' ~year:2026 ~month:1 ~day:1 () in
  Date.pred_day_of_week Weekday.Mon from |> dump_date;
  [%expect {| 2025-12-29 |}]
;;

let%expect_test "next weekday - normal" =
  let from = Date.make_exn' ~year:2026 ~month:3 ~day:16 () in
  Date.succ_weekday from |> dump_date;
  [%expect {| 2026-03-17 |}]
;;

let%expect_test "prev weekday - normal" =
  let from = Date.make_exn' ~year:2026 ~month:3 ~day:17 () in
  Date.pred_weekday from |> dump_date;
  [%expect {| 2026-03-16 |}]
;;

let%expect_test "next weekday - skips weekend (Fri -> Mon)" =
  let from = Date.make_exn' ~year:2026 ~month:3 ~day:20 () in
  Date.succ_weekday from |> dump_date;
  [%expect {| 2026-03-23 |}]
;;

let%expect_test "prev weekday - skips weekend (Mon -> Fri)" =
  let from = Date.make_exn' ~year:2026 ~month:3 ~day:23 () in
  Date.pred_weekday from |> dump_date;
  [%expect {| 2026-03-20 |}]
;;

let%expect_test "next day - simple previcate (day > 20)" =
  let from = Date.make_exn' ~year:2026 ~month:3 ~day:16 () in
  Date.succ_day ~where:(fun d -> Date.day_of_month d > 20) from |> dump_date;
  [%expect {| 2026-03-21 |}]
;;

let%expect_test "next day - previcate matches current but excluded" =
  let from = Date.make_exn' ~year:2026 ~month:3 ~day:16 () in
  Date.succ_day ~where:(fun d -> Int.equal (Date.day_of_month d) 16) from
  |> dump_date;
  [%expect {| 2026-04-16 |}]
;;

let%expect_test "next day - previcate across month" =
  let from = Date.make_exn' ~year:2026 ~month:3 ~day:30 () in
  Date.succ_day ~where:(fun d -> Int.equal (Date.day_of_month d) 1) from
  |> dump_date;
  [%expect {| 2026-04-01 |}]
;;

let%expect_test "prev day - simple previcate" =
  let from = Date.make_exn' ~year:2026 ~month:3 ~day:16 () in
  Date.pred_day ~where:(fun d -> Date.day_of_month d < 10) from |> dump_date;
  [%expect {| 2026-03-09 |}]
;;

let%expect_test "next day - complex previcate (Friday && >= 20)" =
  let from = Date.make_exn' ~year:2026 ~month:3 ~day:1 () in
  Date.succ_day
    ~where:(fun d ->
      Weekday.equal (Date.day_of_week d) Weekday.Fri
      && Date.day_of_month d >= 20)
    from
  |> dump_date;
  [%expect {| 2026-03-20 |}]
;;

let%expect_test "next day - far previcate (Dec 31)" =
  let from = Date.make_exn' ~year:2026 ~month:1 ~day:1 () in
  Date.succ_day
    ~where:(fun d ->
      Month.equal (Date.month d) Month.Dec && Date.day_of_month d = 31)
    from
  |> dump_date;
  [%expect {| 2026-12-31 |}]
;;
