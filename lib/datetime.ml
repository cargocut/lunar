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

type error =
  | Invalid_year of int
  | Invalid_month of Month.error
  | Invalid_day of
      { day_max : int
      ; day : int
      }
  | Invalid_hour of int
  | Invalid_min of int
  | Invalid_sec of int

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

let validate_bound max err x = if x < 0 || x >= max then Error (err x) else Ok x

let make ?(at = 0, 0, 0) ~year ~month ~day () =
  let hour, min, sec = at in
  let ( let* ) = Result.bind in
  let* year = validate_year year in
  let* day_of_month = validate_day year month day in
  let* hour = validate_bound 24 (fun x -> Invalid_hour x) hour in
  let* min = validate_bound 60 (fun x -> Invalid_min x) min in
  let* sec = validate_bound 60 (fun x -> Invalid_sec x) sec in
  Ok { year; month; day_of_month; hour; min; sec }
;;

let make_exn ?at ~year ~month ~day () =
  match make ?at ~year ~month ~day () with
  | Ok dt -> dt
  | Error err -> raise (Invalid_date err)
;;

let make' ?at ~year ~month ~day () =
  let ( let* ) = Result.bind in
  let* month =
    Month.from_int month |> Result.map_error (fun e -> Invalid_month e)
  in
  make ?at ~year ~month ~day ()
;;

let make_exn' ?at ~year ~month ~day () =
  match make' ?at ~year ~month ~day () with
  | Ok dt -> dt
  | Error err -> raise (Invalid_date err)
;;

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

let to_string { year; month; day_of_month; hour; min; sec } =
  (* NOTE: The function does not rely on Format for Js_of_ocaml, but it
     does allocate a lot. For now, we accept that this is okay.*)
  [ [ Util.lpad ~size:4 year
    ; Util.lpad ~size:2 (Month.to_int month)
    ; Util.lpad ~size:2 day_of_month
    ]
    |> String.concat "-"
  ; [ Util.lpad ~size:2 hour; Util.lpad ~size:2 min; Util.lpad ~size:2 sec ]
    |> String.concat ":"
  ]
  |> String.concat "T"
;;

let as_duration f dt = f (to_duration dt) |> from_duration
let add dt d = as_duration (fun dt -> Duration.add dt d) dt
let sub dt d = as_duration (fun dt -> Duration.sub dt d) dt

let diff a b =
  let a = to_duration a
  and b = to_duration b in
  Duration.sub a b
;;

let equal { year; month; day_of_month; hour; min; sec } b =
  Int.equal year b.year
  && Month.equal month b.month
  && Int.equal day_of_month b.day_of_month
  && Int.equal hour b.hour
  && Int.equal min b.min
  && Int.equal sec b.sec
;;

let compare { year; month; day_of_month; hour; min; sec } b =
  let c = Int.compare year b.year in
  if Int.equal c 0
  then (
    let c = Month.compare month b.month in
    if Int.equal c 0
    then (
      let c = Int.compare day_of_month b.day_of_month in
      if Int.equal c 0
      then (
        let c = Int.compare hour b.hour in
        if Int.equal c 0
        then (
          let c = Int.compare min b.min in
          if Int.equal c 0 then Int.compare sec b.sec else c)
        else c)
      else c)
    else c)
  else c
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
