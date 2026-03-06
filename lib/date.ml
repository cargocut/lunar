(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t =
  { year : int
  ; month : Month.t
  ; day_of_month : int
  }

type error =
  | Invalid_year of int
  | Invalid_month of Month.error
  | Invalid_day of
      { day_max : int
      ; day : int
      }

exception Invalid_date of error

let validate_year y =
  if y < 0 || y > 9999
  then
    (* NOTE: Perhaps this constraint is a little too strict, but the
       acceptable range of years seems reasonable for software development.*)
    Error (Invalid_year y)
  else Ok y
;;

let validate_day year month day =
  let day_max = Month.days_in ~year month in
  if day < 1 || day > day_max
  then Error (Invalid_day { day_max; day })
  else Ok day
;;

let make ~year ~month ~day () =
  let ( let* ) = Result.bind in
  let* year = validate_year year in
  let* day_of_month = validate_day year month day in
  Ok { year; month; day_of_month }
;;

let make_exn ~year ~month ~day () =
  match make ~year ~month ~day () with
  | Ok dt -> dt
  | Error err -> raise (Invalid_date err)
;;

let make' ~year ~month ~day () =
  let ( let* ) = Result.bind in
  let* month =
    Month.from_int month |> Result.map_error (fun e -> Invalid_month e)
  in
  make ~year ~month ~day ()
;;

let make_exn' ~year ~month ~day () =
  match make' ~year ~month ~day () with
  | Ok dt -> dt
  | Error err -> raise (Invalid_date err)
;;

let from_duration d =
  let year, month, day_of_month, _, _, _ = Duration.to_datetime d in
  let month =
    (* Result.get_ok should be safe because of
       [to_datetime]. *)
    month |> Month.from_int |> Result.get_ok
  in
  make_exn ~year ~month ~day:day_of_month ()
;;

let to_duration { year; month; day_of_month } =
  let month = Month.to_int month in
  Duration.from_datetime ~year ~month ~day:day_of_month ~hour:0 ~min:0 ~sec:0
;;

let epoch = from_duration Duration.zero
let year { year; _ } = year
let month { month; _ } = month
let day_of_month { day_of_month; _ } = day_of_month
let on_leap_year { year; _ } = Util.is_leap_year year

let day_of_week dt =
  let d = to_duration dt in
  Duration.weekday d
;;

let day_of_year { year; month; day_of_month } =
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

let week_of_year ({ year; _ } as d) =
  let ts = to_duration d in
  let iso_wd = (ts |> Duration.weekday |> Weekday.to_int) + 1
  and day_y = day_of_year d in
  let w = (day_y - iso_wd + 10) / 7 in
  if w < 1
  then (
    let prev_year = year - 1 in
    prev_year, iso_week_in_year prev_year)
  else year, w
;;

let to_string { year; month; day_of_month } =
  (* NOTE: The function does not rely on Format for Js_of_ocaml, but it
     does allocate a lot. For now, we accept that this is okay.*)
  [ Util.lpad ~size:4 year
  ; Util.lpad ~size:2 (Month.to_int month)
  ; Util.lpad ~size:2 day_of_month
  ]
  |> String.concat "-"
;;

let equal { year; month; day_of_month } b =
  Int.equal year b.year
  && Month.equal month b.month
  && Int.equal day_of_month b.day_of_month
;;

let compare { year; month; day_of_month } b =
  let c = Int.compare year b.year in
  if Int.equal c 0
  then (
    let c = Month.compare month b.month in
    if Int.equal c 0 then Int.compare day_of_month b.day_of_month else c)
  else c
;;

let as_duration f dt = f (to_duration dt) |> from_duration
let add dt d = as_duration (fun dt -> Duration.add dt d) dt
let sub dt d = as_duration (fun dt -> Duration.sub dt d) dt

let diff a b =
  let a = to_duration a
  and b = to_duration b in
  Duration.sub a b
;;

module Infix = struct
  let ( + ) = add
  let ( - ) = sub
  let ( = ) = equal
  let ( <> ) x y = not (equal x y)
  let ( > ) x y = compare x y > 0
  let ( >= ) x y = compare x y >= 0
  let ( < ) x y = compare x y < 0
  let ( <= ) x y = compare x y <= 0
end

include Infix
