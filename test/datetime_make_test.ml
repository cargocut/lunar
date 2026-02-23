(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "to_string on epoch" =
  Datetime.epoch |> dump_datetime;
  [%expect {| 1970-01-01T00:00:00 |}]
;;

let%expect_test "make" =
  Datetime.make ~year:2023 ~month:Feb ~day:25 () |> dump_datetime_validation;
  [%expect {| ok: 2023-02-25T00:00:00 |}]
;;

let%expect_test "make" =
  Datetime.make ~at:(22, 33, 59) ~year:2023 ~month:Feb ~day:25 ()
  |> dump_datetime_validation;
  [%expect {| ok: 2023-02-25T22:33:59 |}]
;;

let%expect_test "make" =
  Datetime.make ~at:(22, 33, 60) ~year:2023 ~month:Feb ~day:25 ()
  |> dump_datetime_validation;
  [%expect {| error: invalid sec: 60 |}]
;;

let%expect_test "make" =
  Datetime.make ~at:(22, 33, 59) ~year:2023 ~month:Feb ~day:29 ()
  |> dump_datetime_validation;
  [%expect {| error: invalid day: 29/28 |}]
;;

let%expect_test "make" =
  Datetime.make ~at:(22, 33, 59) ~year:2024 ~month:Feb ~day:29 ()
  |> dump_datetime_validation;
  [%expect {| ok: 2024-02-29T22:33:59 |}]
;;

let%expect_test "make'" =
  Datetime.make' ~at:(25, 33, 59) ~year:2024 ~month:10 ~day:29 ()
  |> dump_datetime_validation;
  [%expect {| error: invalid hour: 25 |}]
;;

let%expect_test "make'" =
  Datetime.make' ~at:(21, 33, 59) ~year:2024 ~month:10 ~day:29 ()
  |> dump_datetime_validation;
  [%expect {| ok: 2024-10-29T21:33:59 |}]
;;
