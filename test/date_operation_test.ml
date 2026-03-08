(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "tomorrow epoch" =
  Date.epoch |> Date.tomorrow |> dump_date;
  [%expect {| 1970-01-02 |}]
;;

let%expect_test "yesterday epoch" =
  Date.epoch |> Date.yesterday |> dump_date;
  [%expect {| 1969-12-31 |}]
;;

let%expect_test "tomorrow normal day" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:8 ()
  |> Date.tomorrow
  |> dump_date;
  [%expect {| 2026-03-09 |}]
;;

let%expect_test "yesterday normal day" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:8 ()
  |> Date.yesterday
  |> dump_date;
  [%expect {| 2026-03-07 |}]
;;

let%expect_test "tomorrow end of month" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:31 ()
  |> Date.tomorrow
  |> dump_date;
  [%expect {| 2026-04-01 |}]
;;

let%expect_test "yesterday start of month" =
  Date.make_exn ~year:2026 ~month:Month.Apr ~day:1 ()
  |> Date.yesterday
  |> dump_date;
  [%expect {| 2026-03-31 |}]
;;

let%expect_test "tomorrow end of year" =
  Date.make_exn ~year:2026 ~month:Month.Dec ~day:31 ()
  |> Date.tomorrow
  |> dump_date;
  [%expect {| 2027-01-01 |}]
;;

let%expect_test "yesterday start of year" =
  Date.make_exn ~year:2026 ~month:Month.Jan ~day:1 ()
  |> Date.yesterday
  |> dump_date;
  [%expect {| 2025-12-31 |}]
;;

let%expect_test "tomorrow feb 28 leap year" =
  Date.make_exn ~year:2028 ~month:Month.Feb ~day:28 ()
  |> Date.tomorrow
  |> dump_date;
  [%expect {| 2028-02-29 |}]
;;

let%expect_test "tomorrow feb 29 leap year" =
  Date.make_exn ~year:2028 ~month:Month.Feb ~day:29 ()
  |> Date.tomorrow
  |> dump_date;
  [%expect {| 2028-03-01 |}]
;;

let%expect_test "yesterday march 1 leap year" =
  Date.make_exn ~year:2028 ~month:Month.Mar ~day:1 ()
  |> Date.yesterday
  |> dump_date;
  [%expect {| 2028-02-29 |}]
;;

let%expect_test "tomorrow feb 28 non-leap year" =
  Date.make_exn ~year:2027 ~month:Month.Feb ~day:28 ()
  |> Date.tomorrow
  |> dump_date;
  [%expect {| 2027-03-01 |}]
;;

let%expect_test "tomorrow then yesterday identity" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:8 ()
  |> Date.tomorrow
  |> Date.yesterday
  |> dump_date;
  [%expect {| 2026-03-08 |}]
;;

let%expect_test "yesterday then tomorrow identity" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:8 ()
  |> Date.yesterday
  |> Date.tomorrow
  |> dump_date;
  [%expect {| 2026-03-08 |}]
;;

let%expect_test "start_of_month normal month" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 ()
  |> Date.start_of_month
  |> dump_date;
  [%expect {| 2026-03-01 |}]
;;

let%expect_test "start_of_month already first" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:1 ()
  |> Date.start_of_month
  |> dump_date;
  [%expect {| 2026-03-01 |}]
;;

let%expect_test "end_of_month 31-day month" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:10 ()
  |> Date.end_of_month
  |> dump_date;
  [%expect {| 2026-03-31 |}]
;;

let%expect_test "end_of_month 30-day month" =
  Date.make_exn ~year:2026 ~month:Month.Apr ~day:10 ()
  |> Date.end_of_month
  |> dump_date;
  [%expect {| 2026-04-30 |}]
;;

let%expect_test "end_of_month february non-leap" =
  Date.make_exn ~year:2027 ~month:Month.Feb ~day:10 ()
  |> Date.end_of_month
  |> dump_date;
  [%expect {| 2027-02-28 |}]
;;

let%expect_test "end_of_month february leap year" =
  Date.make_exn ~year:2028 ~month:Month.Feb ~day:10 ()
  |> Date.end_of_month
  |> dump_date;
  [%expect {| 2028-02-29 |}]
;;

let%expect_test "start_of_year middle of year" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 ()
  |> Date.start_of_year
  |> dump_date;
  [%expect {| 2026-01-01 |}]
;;

let%expect_test "start_of_year already first" =
  Date.make_exn ~year:2026 ~month:Month.Jan ~day:1 ()
  |> Date.start_of_year
  |> dump_date;
  [%expect {| 2026-01-01 |}]
;;

let%expect_test "end_of_year middle of year" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 ()
  |> Date.end_of_year
  |> dump_date;
  [%expect {| 2026-12-31 |}]
;;

let%expect_test "end_of_year already last" =
  Date.make_exn ~year:2026 ~month:Month.Dec ~day:31 ()
  |> Date.end_of_year
  |> dump_date;
  [%expect {| 2026-12-31 |}]
;;

let%expect_test "start_of_month idempotent" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 ()
  |> Date.start_of_month
  |> Date.start_of_month
  |> dump_date;
  [%expect {| 2026-03-01 |}]
;;

let%expect_test "end_of_month idempotent" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 ()
  |> Date.end_of_month
  |> Date.end_of_month
  |> dump_date;
  [%expect {| 2026-03-31 |}]
;;

let%expect_test "start_of_year idempotent" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 ()
  |> Date.start_of_year
  |> Date.start_of_year
  |> dump_date;
  [%expect {| 2026-01-01 |}]
;;

let%expect_test "end_of_year idempotent" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 ()
  |> Date.end_of_year
  |> Date.end_of_year
  |> dump_date;
  [%expect {| 2026-12-31 |}]
;;
