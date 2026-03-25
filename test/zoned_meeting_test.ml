(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

type p =
  { name : string
  ; tz : Timezone.t
  }

let fr = Timezone.make ~hour:1 ~min:0
let au = Timezone.make ~hour:11 ~min:0
let make tz name = { tz; name }
