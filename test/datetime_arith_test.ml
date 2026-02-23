(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "arithmetic on datetime" =
  let dt = Datetime.make_exn ~year:2023 ~month:Feb ~day:23 () in
  Datetime.(dt + Duration.from_days 7) |> dump_datetime;
  [%expect {| 2023-03-02T00:00:00 |}]
;;

let%expect_test "arithmetic on datetime" =
  let dt = Datetime.make_exn ~at:(23, 0, 0) ~year:2023 ~month:Feb ~day:23 () in
  Datetime.(dt + Duration.from_hours 2 + Duration.from_minutes 24)
  |> dump_datetime;
  [%expect {| 2023-02-24T01:24:00 |}]
;;

let%expect_test "arithmetic on datetime" =
  let dt = Datetime.make_exn ~at:(23, 0, 0) ~year:2023 ~month:Feb ~day:23 () in
  Datetime.(dt - Duration.from_days 23 - Duration.from_minutes 23)
  |> dump_datetime;
  [%expect {| 2023-01-31T22:37:00 |}]
;;
