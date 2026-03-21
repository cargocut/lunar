(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type for_date =
  [ `day
  | `week of Weekday.t
  | `month
  | `quarter
  | `year
  ]

type for_time = [ `duration of Duration.t ]

type t =
  [ for_date
  | for_time
  ]

let day = `day
let week = `week Weekday.Mon
let week_with_start s = `week s
let month = `month
let year = `year
let quarter = `quarter
let duration d = `duration (Duration.max Duration.one (Duration.abs d))
let seconds d = duration (Duration.from_seconds d)
let minutes d = duration (Duration.from_minutes d)
let hours d = duration (Duration.from_hours d)
let second = seconds 1
let minute = minutes 1
let hour = hours 1
