(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t =
  | Day
  | Week of Weekday.t
  | Month
  | Quarter
  | Year
  | Duration of Duration.t

let day = Day
let week = Week Weekday.Mon
let week_with_start s = Week s
let month = Month
let year = Year
let quarter = Quarter
let duration d = Duration (Duration.max Duration.one (Duration.abs d))
let seconds d = duration (Duration.from_seconds d)
let minutes d = duration (Duration.from_minutes d)
let hours d = duration (Duration.from_hours d)
let second = seconds 1
let minute = minutes 1
let hour = hours 1
