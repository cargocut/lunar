(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "from_string" =
  "" |> Date.from_string |> dump_date_validation;
  [%expect {| error: invalid string: |}]
;;

let%expect_test "from_string" =
  "test" |> Date.from_string |> dump_date_validation;
  [%expect {| error: invalid string: test |}]
;;

let%expect_test "from_string" =
  "32-14-22" |> Date.from_string |> dump_date_validation;
  [%expect {| error: invalid month number: 14 |}]
;;

let%expect_test "from_string" =
  "32-00-22" |> Date.from_string |> dump_date_validation;
  [%expect {| error: invalid month number: 0 |}]
;;

let%expect_test "from_string" =
  "32-1-32" |> Date.from_string |> dump_date_validation;
  [%expect {| error: invalid day: 32/31 |}]
;;

let%expect_test "from_string" =
  "2032-01-30" |> Date.from_string |> dump_date_validation;
  [%expect {| ok: 2032-01-30 |}]
;;

let%expect_test "from_string" =
  "2032-02-28" |> Date.from_string |> dump_date_validation;
  [%expect {| ok: 2032-02-28 |}]
;;
