(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t =
  { year : int
  ; month : Month.t
  ; day_of_month : int
  ; hour : int
  ; min : int
  ; sec : int
  }

let from_duration d =
  let year, month, day_of_month, hour, min, sec = Duration.to_datetime d in
  let month =
    (* Result.get_ok should be safe because of
       [to_datetime]. *)
    month |> Month.from_int |> Result.get_ok
  in
  { year; month; day_of_month; hour; min; sec }
;;

let to_duration { year; month; day_of_month; hour; min; sec } =
  let month = Month.to_int month in
  Duration.from_datetime ~year ~month ~day:day_of_month ~hour ~min ~sec
;;

let epoch = from_duration Duration.zero
let year { year; _ } = year
let month { month; _ } = month
let day_of_month { day_of_month; _ } = day_of_month
let hour { hour; _ } = hour
let minute { min; _ } = min
let second { sec; _ } = sec
let on_leap_year { year; _ } = Util.is_leap_year year

let day_of_week dt =
  let d = to_duration dt in
  Duration.weekday d
;;

let day_of_year { year; month; day_of_month; _ } =
  let month_i = Month.to_int month
  and offsets = [| 0; 31; 59; 90; 120; 151; 181; 212; 243; 273; 304; 334 |] in
  let day_of_year = offsets.(pred month_i) + day_of_month in
  if Month.(month > Feb) && Util.is_leap_year year
  then day_of_year + 1
  else day_of_year
;;

let iso_week_in_year year =
  match
    Duration.from_datetime ~year ~month:1 ~day:1 ~hour:0 ~min:0 ~sec:0
    |> Duration.weekday
  with
  | Thu -> 53
  | Wed when Util.is_leap_year year -> 53
  | _ -> 52
;;

let week_of_year ({ year; month; day_of_month; _ } as dt) =
  let month_i = Month.to_int month in
  let ts =
    Duration.from_datetime
      ~year
      ~month:month_i
      ~day:day_of_month
      ~hour:0
      ~min:0
      ~sec:0
  in
  let iso_wd = (ts |> Duration.weekday |> Weekday.to_int) + 1
  and day_y = day_of_year dt in
  let w = (day_y - iso_wd + 10) / 7 in
  if w < 1
  then (
    let prev_year = year - 1 in
    prev_year, iso_week_in_year prev_year)
  else year, w
;;
