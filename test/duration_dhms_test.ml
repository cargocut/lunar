(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

let dump_dhms d =
  let d, h, m, s = d |> Duration.dhms in
  string_of_int d
  ^ "d, "
  ^ string_of_int h
  ^ ":"
  ^ string_of_int m
  ^ ":"
  ^ string_of_int s
  |> print_endline
;;

let%expect_test "dhms" =
  Duration.from_datetime ~year:1970 ~month:1 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> dump_dhms;
  [%expect {| 0d, 0:0:0 |}]
;;

let%expect_test "dhms" =
  Duration.from_days 1 |> dump_dhms;
  [%expect {| 1d, 0:0:0 |}]
;;

let%expect_test "dhms" =
  Duration.(from_days 1 + from_hours 22 + from_minutes 21 + from_seconds 3601)
  |> dump_dhms;
  [%expect {| 1d, 23:21:1 |}]
;;

let%expect_test "dhms" =
  Duration.from_datetime ~year:0 ~month:1 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> dump_dhms;
  [%expect {| -719528d, 0:0:0 |}]
;;

let%expect_test "dhms next day minus one second" =
  Duration.from_datetime ~year:1970 ~month:1 ~day:2 ~hour:0 ~min:0 ~sec:(-1)
  |> dump_dhms;
  [%expect {| 0d, 23:59:59 |}]
;;

let%expect_test "dhms one second before epoch" =
  Duration.from_datetime ~year:1969 ~month:12 ~day:31 ~hour:23 ~min:59 ~sec:59
  |> dump_dhms;
  [%expect {| -1d, 23:59:59 |}]
;;

let%expect_test "dhms negative one day exactly" =
  Duration.from_days (-1) |> dump_dhms;
  [%expect {| -1d, 0:0:0 |}]
;;

let%expect_test "dhms negative with time component" =
  Duration.(from_days (-2) + from_hours 3) |> dump_dhms;
  [%expect {| -2d, 3:0:0 |}]
;;

let%expect_test "dhms leap day 1972-02-29" =
  Duration.from_datetime ~year:1972 ~month:2 ~day:29 ~hour:0 ~min:0 ~sec:0
  |> dump_dhms;
  [%expect {| 789d, 0:0:0 |}]
;;

let%expect_test "dhms century non-leap 1900-03-01" =
  Duration.from_datetime ~year:1900 ~month:3 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> dump_dhms;
  [%expect {| -25508d, 0:0:0 |}]
;;

let%expect_test "dhms 2000-02-29 (400-year leap)" =
  Duration.from_datetime ~year:2000 ~month:2 ~day:29 ~hour:0 ~min:0 ~sec:0
  |> dump_dhms;
  [%expect {| 11016d, 0:0:0 |}]
;;

let%expect_test "dhms 2000-01-01 midnight" =
  Duration.from_datetime ~year:2000 ~month:1 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> dump_dhms;
  [%expect {| 10957d, 0:0:0 |}]
;;

let%expect_test "dhms large positive span" =
  Duration.from_datetime ~year:2400 ~month:1 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> dump_dhms;
  [%expect {| 157054d, 0:0:0 |}]
;;

let%expect_test "dhms far past date" =
  Duration.from_datetime ~year:(-1000) ~month:6 ~day:15 ~hour:0 ~min:0 ~sec:0
  |> dump_dhms;
  [%expect {| -1084605d, 0:0:0 |}]
;;
