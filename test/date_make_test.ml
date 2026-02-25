(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "to_string on epoch" =
  Date.epoch |> dump_date;
  [%expect {| 1970-01-01 |}]
;;

let%expect_test "make" =
  Date.make ~year:2023 ~month:Feb ~day:25 () |> dump_date_validation;
  [%expect {| ok: 2023-02-25 |}]
;;

let%expect_test "make" =
  Date.make ~year:2023 ~month:Feb ~day:29 () |> dump_date_validation;
  [%expect {| error: invalid day: 29/28 |}]
;;

let%expect_test "make" =
  Date.make ~year:2024 ~month:Feb ~day:29 () |> dump_date_validation;
  [%expect {| ok: 2024-02-29 |}]
;;

let%expect_test "make'" =
  Date.make' ~year:2024 ~month:10 ~day:29 () |> dump_date_validation;
  [%expect {| ok: 2024-10-29 |}]
;;
