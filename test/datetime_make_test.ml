(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "make: default time (midnight)" =
  Datetime.make ~year:2026 ~month:Month.Mar ~day:22 ()
  |> dump_datetime_validation;
  [%expect {| ok: 2026-03-22 00:00:00 |}]
;;

let%expect_test "make: explicit midnight" =
  Datetime.make ~at:(0, 0, 0) ~year:2026 ~month:Month.Mar ~day:22 ()
  |> dump_datetime_validation;
  [%expect {| ok: 2026-03-22 00:00:00 |}]
;;

let%expect_test "make: valid time" =
  Datetime.make ~at:(22, 12, 59) ~year:2026 ~month:Month.Mar ~day:22 ()
  |> dump_datetime_validation;
  [%expect {| ok: 2026-03-22 22:12:59 |}]
;;

let%expect_test "make: leap year valid (Feb 29)" =
  Datetime.make ~at:(23, 0, 59) ~year:2024 ~month:Month.Feb ~day:29 ()
  |> dump_datetime_validation;
  [%expect {| ok: 2024-02-29 23:00:59 |}]
;;

let%expect_test "make: non-leap year invalid (Feb 29)" =
  Datetime.make ~at:(23, 0, 59) ~year:2025 ~month:Month.Feb ~day:29 ()
  |> dump_datetime_validation;
  [%expect {| error: invalid day: 29/28 |}]
;;

let%expect_test "make: invalid hour" =
  Datetime.make ~at:(26, 0, 59) ~year:2026 ~month:Month.Mar ~day:22 ()
  |> dump_datetime_validation;
  [%expect {| error: invalid hour: 26 |}]
;;

let%expect_test "make: invalid minute" =
  Datetime.make ~at:(12, 61, 0) ~year:2026 ~month:Month.Mar ~day:22 ()
  |> dump_datetime_validation;
  [%expect {| error: invalid min: 61 |}]
;;

let%expect_test "make: invalid second" =
  Datetime.make ~at:(12, 0, 61) ~year:2026 ~month:Month.Mar ~day:22 ()
  |> dump_datetime_validation;
  [%expect {| error: invalid sec: 61 |}]
;;

let%expect_test "make: invalid day (April 31)" =
  Datetime.make ~year:2026 ~month:Month.Apr ~day:31 ()
  |> dump_datetime_validation;
  [%expect {| error: invalid day: 31/30 |}]
;;

let%expect_test "make: invalid year (negative)" =
  Datetime.make ~year:(-1) ~month:Month.Jan ~day:1 ()
  |> dump_datetime_validation;
  [%expect {| error: invalid year: -1 |}]
;;

let%expect_test "make: invalid year (too large)" =
  Datetime.make ~year:10000 ~month:Month.Jan ~day:1 ()
  |> dump_datetime_validation;
  [%expect {| error: invalid year: 10000 |}]
;;

let%expect_test "make: multiple errors (day + hour)" =
  Datetime.make ~at:(27, 0, 59) ~year:2025 ~month:Month.Feb ~day:29 ()
  |> dump_datetime_validation;
  [%expect {| error: invalid day: 29/28, invalid hour: 27 |}]
;;

let%expect_test "make: multiple errors (minute + second)" =
  Datetime.make ~at:(12, 70, 70) ~year:2026 ~month:Month.Mar ~day:22 ()
  |> dump_datetime_validation;
  [%expect {| error: invalid min: 70 |}]
;;

let%expect_test "make: lowest valid date" =
  Datetime.make ~year:0 ~month:Month.Jan ~day:1 () |> dump_datetime_validation;
  [%expect {| ok: 0000-01-01 00:00:00 |}]
;;

let%expect_test "make: highest valid date" =
  Datetime.make ~year:9999 ~month:Month.Dec ~day:31 ()
  |> dump_datetime_validation;
  [%expect {| ok: 9999-12-31 00:00:00 |}]
;;
