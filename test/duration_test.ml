(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let test_round_trip ts =
  let year, month, day, hour, min, sec = Duration.to_datetime ts in
  let rts = Duration.from_datetime ~year ~month ~day ~hour ~min ~sec in
  if not (Duration.equal ts rts)
  then
    print_endline
      ("round-trip failed for " ^ (ts |> Duration.to_int64 |> Int64.to_string))
;;

let%expect_test "from_tm for 1970/01/01 at 00:00:00" =
  Duration.from_datetime ~year:1970 ~month:1 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> dump_duration;
  [%expect {| 0 |}]
;;

let%expect_test "from_tm for 1970/01/02 at 12:32:21" =
  Duration.from_datetime ~year:1970 ~month:1 ~day:2 ~hour:12 ~min:32 ~sec:21
  |> dump_duration;
  [%expect {| 131541 |}]
;;

let%expect_test "from_tm for 0000/01/01 at 00:00:00" =
  Duration.from_datetime ~year:0 ~month:1 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> dump_duration;
  [%expect {| -62167219200 |}]
;;

let%expect_test "epoch 1970-01-01 00:00:00" =
  Duration.from_datetime ~year:1970 ~month:1 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> dump_duration;
  [%expect {| 0 |}]
;;

let%expect_test "one second before epoch" =
  Duration.from_datetime ~year:1969 ~month:12 ~day:31 ~hour:23 ~min:59 ~sec:59
  |> dump_duration;
  [%expect {| -1 |}]
;;

let%expect_test "one day after epoch" =
  Duration.from_datetime ~year:1970 ~month:1 ~day:2 ~hour:0 ~min:0 ~sec:0
  |> dump_duration;
  [%expect {| 86400 |}]
;;

let%expect_test "from_tm for 1970/01/02 at 12:32:21" =
  Duration.from_datetime ~year:1970 ~month:1 ~day:2 ~hour:12 ~min:32 ~sec:21
  |> dump_duration;
  [%expect {| 131541 |}]
;;

let%expect_test "leap year 1972-02-29" =
  Duration.from_datetime ~year:1972 ~month:2 ~day:29 ~hour:0 ~min:0 ~sec:0
  |> dump_duration;
  [%expect {| 68169600 |}]
;;

let%expect_test "non-leap century 1900-03-01" =
  Duration.from_datetime ~year:1900 ~month:3 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> dump_duration;
  [%expect {| -2203891200 |}]
;;

let%expect_test "400-year leap 2000-02-29" =
  Duration.from_datetime ~year:2000 ~month:2 ~day:29 ~hour:0 ~min:0 ~sec:0
  |> dump_duration;
  [%expect {| 951782400 |}]
;;

let%expect_test "year 2000-01-01 midnight" =
  Duration.from_datetime ~year:2000 ~month:1 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> dump_duration;
  [%expect {| 946684800 |}]
;;

let%expect_test "negative timestamp random date" =
  Duration.from_datetime ~year:1950 ~month:6 ~day:15 ~hour:8 ~min:30 ~sec:0
  |> dump_duration;
  [%expect {| -616865400 |}]
;;

let%expect_test "round_trip" =
  List.iter
    test_round_trip
    (List.map
       Duration.from_seconds
       [ 1771431393
       ; -616865400
       ; 946684800
       ; 951782400
       ; -2203891200
       ; 68169600
       ; 131541
       ; 86400
       ; -1
       ; 0
       ; -62167219200
       ])
;;
