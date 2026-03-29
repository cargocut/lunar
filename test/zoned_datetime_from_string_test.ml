(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "from_string" =
  "2026-03-21T11:45:58Z" |> Zoned_datetime.from_string |> dump_zoned_validation;
  [%expect {| ok: 2026-03-21T11:45:58Z |}]
;;

let%expect_test "from_string" =
  "2026-03-21T11:45:58+02:03"
  |> Zoned_datetime.from_string
  |> dump_zoned_validation;
  [%expect {| ok: 2026-03-21T11:45:58+02:03 |}]
;;

let%expect_test "from_string" =
  "2026-03-21T11:45:58" |> Zoned_datetime.from_string |> dump_zoned_validation;
  [%expect {| error: invalid string: :45:58 |}]
;;

let%expect_test "from_string" =
  "2026-03-:45:58" |> Zoned_datetime.from_string |> dump_zoned_validation;
  [%expect {| error: invalid string: 2026-03- |}]
;;

let%expect_test "from_string utc" =
  "2026-03-21T11:45:58Z" |> Zoned_datetime.from_string |> dump_zoned_validation;
  [%expect {| ok: 2026-03-21T11:45:58Z |}]
;;

let%expect_test "from_string positive offset" =
  "2026-03-21T11:45:58+02:03"
  |> Zoned_datetime.from_string
  |> dump_zoned_validation;
  [%expect {| ok: 2026-03-21T11:45:58+02:03 |}]
;;

let%expect_test "from_string negative offset" =
  "2026-03-21T11:45:58-05:30"
  |> Zoned_datetime.from_string
  |> dump_zoned_validation;
  [%expect {| ok: 2026-03-21T11:45:58-05:30 |}]
;;

let%expect_test "from_string zero explicit offset" =
  "2026-03-21T11:45:58+00:00"
  |> Zoned_datetime.from_string
  |> dump_zoned_validation;
  [%expect {| ok: 2026-03-21T11:45:58Z |}]
;;

let%expect_test "from_string missing timezone" =
  "2026-03-21T11:45:58" |> Zoned_datetime.from_string |> dump_zoned_validation;
  [%expect {| error: invalid string: :45:58 |}]
;;

let%expect_test "from_string malformed datetime" =
  "2026-03-:45:58" |> Zoned_datetime.from_string |> dump_zoned_validation;
  [%expect {| error: invalid string: 2026-03- |}]
;;

let%expect_test "from_string invalid timezone syntax" =
  "2026-03-21T11:45:58foo"
  |> Zoned_datetime.from_string
  |> dump_zoned_validation;
  [%expect {| error: invalid string: :58foo |}]
;;

let%expect_test "from_string invalid timezone hour" =
  "2026-03-21T11:45:58+24:00"
  |> Zoned_datetime.from_string
  |> dump_zoned_validation;
  [%expect {| ok: 2026-03-21T11:45:58+24:00 |}]
;;

let%expect_test "from_string invalid timezone minute" =
  "2026-03-21T11:45:58+10:60"
  |> Zoned_datetime.from_string
  |> dump_zoned_validation;
  [%expect {| error: invalid string: +10:60 |}]
;;

let%expect_test "from_string incomplete timezone" =
  "2026-03-21T11:45:58+02"
  |> Zoned_datetime.from_string
  |> dump_zoned_validation;
  [%expect {| error: invalid string: :58+02 |}]
;;

let%expect_test "from_string trailing garbage after utc" =
  "2026-03-21T11:45:58Zfoo"
  |> Zoned_datetime.from_string
  |> dump_zoned_validation;
  [%expect {| error: invalid string: 11:45: |}]
;;

let%expect_test "from_string empty" =
  "" |> Zoned_datetime.from_string |> dump_zoned_validation;
  [%expect {| error: invalid string:  |}]
;;

let%expect_test "from_string with invalid date" =
  "2026-03-48T11:45:58Z" |> Zoned_datetime.from_string |> dump_zoned_validation;
  [%expect {| error: invalid day: 48/31 |}]
;;
