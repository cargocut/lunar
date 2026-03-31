(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "unix comparison" =
  1774957076 |> Duration.from_seconds |> Datetime.from_duration |> dump_datetime;
  [%expect {| 2026-03-31T11:37:56 |}]
;;

let%expect_test "unix comparison" =
  1774957076
  |> Duration.from_seconds
  |> Datetime.from_duration
  |> Zoned_datetime.from_utc
  |> Zoned_datetime.to_datetime ~tz:(Timezone.make ~hour:2 ~min:0)
  |> dump_datetime;
  [%expect {| 2026-03-31T13:37:56 |}]
;;
