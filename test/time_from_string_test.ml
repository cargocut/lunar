(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "from_string" =
  "" |> Time.from_string |> dump_time_validation;
  [%expect {| error: invalid string: |}]
;;

let%expect_test "from_string" =
  "test" |> Time.from_string |> dump_time_validation;
  [%expect {| error: invalid string: test |}]
;;

let%expect_test "from_string" =
  "25:11:57" |> Time.from_string |> dump_time_validation;
  [%expect {| error: invalid hour: 25 |}]
;;

let%expect_test "from_string" =
  "23:11:57" |> Time.from_string |> dump_time_validation;
  [%expect {| ok: 23:11:57 |}]
;;

let%expect_test "from_string" =
  "23:11" |> Time.from_string |> dump_time_validation;
  [%expect {| ok: 23:11:00 |}]
;;

let%expect_test "from_string" =
  "23" |> Time.from_string |> dump_time_validation;
  [%expect {| ok: 23:00:00 |}]
;;

let%expect_test "from_string" =
  " 23 " |> Time.from_string |> dump_time_validation;
  [%expect {| error: invalid string:  23 |}]
;;
