(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

let time_a = 1788778949.

let%expect_test "tz" =
  time_a |> Lunar_unix.tz |> Timezone.to_string |> print_endline;
  [%expect {| +02:00 |}]
;;

let%expect_test "utc" =
  time_a |> Lunar_unix.utc |> Zoned_datetime.to_string |> print_endline;
  [%expect {| 2026-09-07T11:02:29Z |}]
;;

let%expect_test "local" =
  time_a |> Lunar_unix.local |> Zoned_datetime.to_string |> print_endline;
  [%expect {| 2026-09-07T13:02:29+02:00 |}]
;;

let time_b =
  Datetime.make_exn' ~at:(12, 0, 0) ~year:2026 ~month:11 ~day:22 ()
  |> Datetime.to_duration
  |> Duration.to_int64
  |> Int64.to_float
;;

let%expect_test "tz" =
  time_b |> Lunar_unix.tz |> Timezone.to_string |> print_endline;
  [%expect {| +01:00 |}]
;;

let%expect_test "utc" =
  time_b |> Lunar_unix.utc |> Zoned_datetime.to_string |> print_endline;
  [%expect {| 2026-11-22T12:00:00Z |}]
;;

let%expect_test "local" =
  time_b |> Lunar_unix.local |> Zoned_datetime.to_string |> print_endline;
  [%expect {| 2026-11-22T13:00:00+01:00 |}]
;;
