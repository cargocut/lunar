(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "from_int" =
  [ 0; 1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 13; -2; 2000; 42 ]
  |> List.map Weekday.from_int
  |> List.iter dump_weekday_validation;
  [%expect
    {|
    ok: monday
    ok: tuesday
    ok: wednesday
    ok: thursday
    ok: friday
    ok: saturday
    ok: sunday
    error: invalid weekday number: 7
    error: invalid weekday number: 8
    error: invalid weekday number: 9
    error: invalid weekday number: 10
    error: invalid weekday number: 11
    error: invalid weekday number: 12
    error: invalid weekday number: 13
    error: invalid weekday number: -2
    error: invalid weekday number: 2000
    error: invalid weekday number: 42
    |}]
;;

let%expect_test "succ" =
  Weekday.all |> List.map Weekday.succ |> List.iter dump_weekday;
  [%expect
    {|
    tuesday
    wednesday
    thursday
    friday
    saturday
    sunday
    monday
    |}]
;;

let%expect_test "pred" =
  Weekday.all |> List.map Weekday.pred |> List.iter dump_weekday;
  [%expect
    {|
    sunday
    monday
    tuesday
    wednesday
    thursday
    friday
    saturday
    |}]
;;

let%expect_test "from string" =
  [ "Sun"
  ; "Mon"
  ; "tue"
  ; "wed"
  ; "thu"
  ; "fri"
  ; "sat"
  ; "sunday"
  ; "monday"
  ; "tuesday"
  ; "wednesday"
  ; "thursday"
  ; "friday"
  ; "saturday"
  ; " thursDAY  "
  ; "friDAy  "
  ; "  saturday"
  ; "foo bar"
  ]
  |> List.map Weekday.from_string
  |> List.iter dump_weekday_validation;
  [%expect
    {|
    ok: sunday
    ok: monday
    ok: tuesday
    ok: wednesday
    ok: thursday
    ok: friday
    ok: saturday
    ok: sunday
    ok: monday
    ok: tuesday
    ok: wednesday
    ok: thursday
    ok: friday
    ok: saturday
    ok: thursday
    ok: friday
    ok: saturday
    error: invalid weekday string: foo bar
    |}]
;;
