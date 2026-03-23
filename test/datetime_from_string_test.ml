(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "from_string" =
  "2026-03-22" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| ok: 2026-03-22T00:00:00 |}]
;;

let%expect_test "from_string" =
  "2026-03-22 12:12:45" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| ok: 2026-03-22T12:12:45 |}]
;;

let%expect_test "from_string" =
  "  2026-03-22    12:12:45    "
  |> Datetime.from_string
  |> dump_datetime_validation;
  [%expect {| ok: 2026-03-22T12:12:45 |}]
;;

let%expect_test "from_string" =
  "  2026-03-22T12:12:45    "
  |> Datetime.from_string
  |> dump_datetime_validation;
  [%expect {| ok: 2026-03-22T12:12:45 |}]
;;

let%expect_test "from_string" =
  "  2026-02-29T12:12:45    "
  |> Datetime.from_string
  |> dump_datetime_validation;
  [%expect {| error: invalid day: 29/28 |}]
;;

let%expect_test "from_string" =
  "  2026-02-28T12:76:45    "
  |> Datetime.from_string
  |> dump_datetime_validation;
  [%expect {| error: invalid min: 76 |}]
;;

let%expect_test "from_string" =
  "  2026-02-29T12:76:45    "
  |> Datetime.from_string
  |> dump_datetime_validation;
  [%expect {| error: invalid day: 29/28, invalid min: 76 |}]
;;

let%expect_test "from_string" =
  "  2026-02-29T12:76:67    "
  |> Datetime.from_string
  |> dump_datetime_validation;
  [%expect {| error: invalid day: 29/28, invalid min: 76 |}]
;;

let%expect_test "from_string: single-digit components" =
  "2026-3-2 1:2:3" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| ok: 2026-03-02T01:02:03 |}]
;;

let%expect_test "from_string: date only with spaces" =
  "   2026-03-22   " |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| ok: 2026-03-22T00:00:00 |}]
;;

let%expect_test "from_string: invalid separator" =
  "2026/03/22" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| error: invalid string: 2026/03/22 |}]
;;

let%expect_test "from_string: missing components" =
  "2026-03" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| error: invalid string: 2026-03 |}]
;;

let%expect_test "from_string: empty string" =
  "" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| error: invalid string:  |}]
;;

let%expect_test "from_string: garbage string" =
  "hello world" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| error: invalid string: hello, invalid string: world |}]
;;

let%expect_test "from_string: invalid month" =
  "2026-13-22" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| error: invalid month number: 13 |}]
;;

let%expect_test "from_string: invalid hour" =
  "2026-03-22 25:00:00" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| error: invalid hour: 25 |}]
;;

let%expect_test "from_string: invalid second" =
  "2026-03-22 12:00:61" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| error: invalid sec: 61 |}]
;;

let%expect_test "from_string: multiple errors (month + hour)" =
  "2026-13-22 25:00:00" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| error: invalid month number: 13, invalid hour: 25 |}]
;;

let%expect_test "from_string: multiple errors (day + min + sec)" =
  "2026-02-30 12:70:70" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| error: invalid day: 30/28, invalid min: 70 |}]
;;

let%expect_test "from_string: valid leap day" =
  "2024-02-29 12:00:00" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| ok: 2024-02-29T12:00:00 |}]
;;

let%expect_test "from_string: invalid leap day" =
  "2025-02-29 12:00:00" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| error: invalid day: 29/28 |}]
;;

let%expect_test "from_string: maximum date" =
  "9999-12-31 23:59:59" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| ok: 9999-12-31T23:59:59 |}]
;;

let%expect_test "from_string: extra trailing garbage" =
  "2026-03-22 12:12:45 abc" |> Datetime.from_string |> dump_datetime_validation;
  [%expect {| error: invalid string: 2026-03-22 12:12:45 abc |}]
;;
