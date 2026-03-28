(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "from_string" =
  "Z" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| ok: Z |}]
;;

let%expect_test "from_string" =
  "+42:45" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| ok: +42:45 |}]
;;

let%expect_test "from_string" =
  "-42:45" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| ok: -42:45 |}]
;;

let%expect_test "from_string" =
  "foo" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| error: invalid string: foo |}]
;;

open Test_util

let%expect_test "from_string utc" =
  "Z" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| ok: Z |}]
;;

let%expect_test "from_string positive offset" =
  "+42:45" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| ok: +42:45 |}]
;;

let%expect_test "from_string negative offset" =
  "-42:45" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| ok: -42:45 |}]
;;

let%expect_test "from_string zero offset explicit plus" =
  "+00:00" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| ok: Z |}]
;;

let%expect_test "from_string zero offset explicit minus" =
  "-00:00" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| ok: Z |}]
;;

let%expect_test "from_string max common positive offset" =
  "+14:00" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| ok: +14:00 |}]
;;

let%expect_test "from_string max common negative offset" =
  "-12:00" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| ok: -12:00 |}]
;;

let%expect_test "from_string invalid string" =
  "foo" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| error: invalid string: foo |}]
;;

let%expect_test "from_string empty" =
  "" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| error: invalid string:  |}]
;;

let%expect_test "from_string missing sign" =
  "42:45" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| error: invalid string: 42:45 |}]
;;

let%expect_test "from_string missing colon" =
  "+4245" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| error: invalid string: +4245 |}]
;;

let%expect_test "from_string incomplete hour" =
  "+4:45" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| error: invalid string: +4:45 |}]
;;

let%expect_test "from_string incomplete minute" =
  "+04:5" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| error: invalid string: +04:5 |}]
;;

let%expect_test "from_string trailing garbage" =
  "+04:30foo" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| error: invalid string: +04:30foo |}]
;;

let%expect_test "from_string wrong utc lowercase" =
  "z" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| error: invalid string: z |}]
;;

let%expect_test "from_string wrong separator" =
  "+04-30" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| error: invalid string: +04-30 |}]
;;

let%expect_test "from_string wrong min" =
  "+04:61" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| error: invalid string: +04:61 |}]
;;

let%expect_test "from_string ok min" =
  "+04:59" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| ok: +04:59 |}]
;;

let%expect_test "from_string wrong min" =
  "-04:61" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| error: invalid string: -04:61 |}]
;;

let%expect_test "from_string ok min" =
  "-04:59" |> Timezone.from_string |> dump_tz_validation;
  [%expect {| ok: -04:59 |}]
;;
