(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

let%expect_test "to_seconds" =
  124 |> Duration.from_seconds |> Duration.to_seconds |> print_int;
  [%expect {| 124 |}]
;;

let%expect_test "to_seconds" =
  -124 |> Duration.from_seconds |> Duration.to_seconds |> print_int;
  [%expect {| -124 |}]
;;

let%expect_test "to_minutes" =
  124 |> Duration.from_minutes |> Duration.to_minutes |> print_int;
  [%expect {| 124 |}]
;;

let%expect_test "to_minutes" =
  -124 |> Duration.from_minutes |> Duration.to_minutes |> print_int;
  [%expect {| -124 |}]
;;

let%expect_test "to_hours" =
  124 |> Duration.from_hours |> Duration.to_hours |> print_int;
  [%expect {| 124 |}]
;;

let%expect_test "to_hours" =
  -124 |> Duration.from_hours |> Duration.to_hours |> print_int;
  [%expect {| -124 |}]
;;

let%expect_test "to_days" =
  124 |> Duration.from_days |> Duration.to_days |> print_int;
  [%expect {| 124 |}]
;;

let%expect_test "to_days" =
  -124 |> Duration.from_days |> Duration.to_days |> print_int;
  [%expect {| -124 |}]
;;

let%expect_test "seconds_to_minutes_to_seconds" =
  360
  |> Duration.from_seconds
  |> Duration.to_minutes
  |> Duration.from_minutes
  |> Duration.to_seconds
  |> print_int;
  [%expect {| 360 |}]
;;

let%expect_test "negative_seconds_to_minutes_to_seconds" =
  -360
  |> Duration.from_seconds
  |> Duration.to_minutes
  |> Duration.from_minutes
  |> Duration.to_seconds
  |> print_int;
  [%expect {| -360 |}]
;;

let%expect_test "minutes_to_hours_to_minutes" =
  180
  |> Duration.from_minutes
  |> Duration.to_hours
  |> Duration.from_hours
  |> Duration.to_minutes
  |> print_int;
  [%expect {| 180 |}]
;;

let%expect_test "negative_minutes_to_hours_to_minutes" =
  -180
  |> Duration.from_minutes
  |> Duration.to_hours
  |> Duration.from_hours
  |> Duration.to_minutes
  |> print_int;
  [%expect {| -180 |}]
;;

let%expect_test "hours_to_days_to_hours" =
  48
  |> Duration.from_hours
  |> Duration.to_days
  |> Duration.from_days
  |> Duration.to_hours
  |> print_int;
  [%expect {| 48 |}]
;;

let%expect_test "negative_hours_to_days_to_hours" =
  -48
  |> Duration.from_hours
  |> Duration.to_days
  |> Duration.from_days
  |> Duration.to_hours
  |> print_int;
  [%expect {| -48 |}]
;;

let%expect_test "seconds_to_minutes_to_hours_to_seconds" =
  7200
  |> Duration.from_seconds
  |> Duration.to_minutes
  |> Duration.from_minutes
  |> Duration.to_hours
  |> Duration.from_hours
  |> Duration.to_seconds
  |> print_int;
  [%expect {| 7200 |}]
;;

let%expect_test "negative_seconds_to_minutes_to_hours_to_seconds" =
  -7200
  |> Duration.from_seconds
  |> Duration.to_minutes
  |> Duration.from_minutes
  |> Duration.to_hours
  |> Duration.from_hours
  |> Duration.to_seconds
  |> print_int;
  [%expect {| -7200 |}]
;;

let%expect_test "days_to_hours_to_minutes_to_seconds_to_days" =
  3
  |> Duration.from_days
  |> Duration.to_hours
  |> Duration.from_hours
  |> Duration.to_minutes
  |> Duration.from_minutes
  |> Duration.to_seconds
  |> Duration.from_seconds
  |> Duration.to_days
  |> print_int;
  [%expect {| 3 |}]
;;

let%expect_test "negative_days_to_hours_to_minutes_to_seconds_to_days" =
  -3
  |> Duration.from_days
  |> Duration.to_hours
  |> Duration.from_hours
  |> Duration.to_minutes
  |> Duration.from_minutes
  |> Duration.to_seconds
  |> Duration.from_seconds
  |> Duration.to_days
  |> print_int;
  [%expect {| -3 |}]
;;

let%expect_test "non_round_seconds_to_minutes_to_seconds" =
  90
  |> Duration.from_seconds
  |> Duration.to_minutes
  |> Duration.from_minutes
  |> Duration.to_seconds
  |> print_int;
  [%expect {| 60 |}]
;;

let%expect_test "large_seconds_conversion" =
  1_000_000
  |> Duration.from_seconds
  |> Duration.to_days
  |> Duration.from_days
  |> Duration.to_hours
  |> Duration.from_hours
  |> Duration.to_minutes
  |> Duration.from_minutes
  |> Duration.to_seconds
  |> print_int;
  [%expect {| 950400 |}]
;;
