(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "from_tm for 1970/01/01 at 00:00:00" =
  Duration.from_datetime ~year:1970 ~month:1 ~day:1 ~hour:0 ~min:0 ~sec:0
  |> dump_duration
;;
