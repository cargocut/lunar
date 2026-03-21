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
  | Invalid_string of string

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

let from_string s =
  (* TODO: improve cases. *)
  match String.split_on_char '-' s with
  | [ y; m; d ]
    when Util.only_numbers y && Util.only_numbers m && Util.only_numbers d ->
    (* NOTE: Using unsafe function here is safe
       because of the guard [Util.only_numbers]. *)
    let year = int_of_string y
    and month = int_of_string m
    and day = int_of_string d in
    make' ~year ~month ~day ()
  | _ -> Error (Invalid_string s)
;;

let from_string_exn s =
  match from_string s with
  | Ok x -> x
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
let days_in_month { year; month; _ } = Month.days_in ~year month
let era { year; _ } = Era.from_year year
let year_of_era { year; _ } = Era.year year
let century_of_era { year; _ } = Era.century year
let year_of_century { year; _ } = Era.year_of_century year

let day_of_week d =
  let d = to_duration d in
  Duration.weekday d
;;

let is_weekend d =
  match day_of_week d with
  | Weekday.Sat | Weekday.Sun -> true
  | Weekday.Mon | Weekday.Tue | Weekday.Wed | Weekday.Thu | Weekday.Fri -> false
;;

let is_weekday d = not (is_weekend d)

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

module CE = struct
  type nonrec t = t

  let equal = equal
  let compare = compare
end

let as_duration f dt = f (to_duration dt) |> from_duration
let add d dt = as_duration (fun dt -> Duration.add dt d) dt
let sub d dt = as_duration (fun dt -> Duration.sub dt d) dt
let add_days ds dt = as_duration (fun d -> Duration.(add d (from_days ds))) dt
let sub_days ds dt = as_duration (fun d -> Duration.(sub d (from_days ds))) dt
let add_weeks w = add_days (w * 7)
let sub_weeks w = add_weeks (-w)
let succ = add_days 1
let pred = sub_days 1

let trim_day_of_month ~year ~month d =
  Int.min (day_of_month d) (Month.days_in ~year month)
;;

let add_years n d =
  let y = year d + n
  and m = month d in
  let day = trim_day_of_month ~year:y ~month:m d in
  (* NOTE: Should never performs any exception here. *)
  make_exn ~year:y ~month:m ~day ()
;;

let sub_years n = add_years (-n)

let add_months n d =
  let y = year d
  and m = d |> month |> Month.to_int in
  let t = (y * 12) + (m - 1) + n in
  let ny = t / 12 in
  let nm = Util.mod_floor t 12 + 1 in
  let m =
    (* NOTE: [nm] is guarded by [mod] so it should be unreachable. *)
    nm |> Month.from_int |> Result.get_ok
  in
  let day = trim_day_of_month ~year:ny ~month:m d in
  (* NOTE: Should never performs any exception here. *)
  make_exn ~year:ny ~month:m ~day ()
;;

let sub_months n = add_months (-n)

let diff a b =
  let a = to_duration a
  and b = to_duration b in
  Duration.sub a b
;;

let tomorrow = succ
let yesterday = pred
let start_of_month d = { d with day_of_month = 1 }

let end_of_month d =
  let day_of_month = days_in_month d in
  { d with day_of_month }
;;

let quarter { month; _ } =
  match month with
  | Month.Jan | Month.Feb | Month.Mar -> 1
  | Month.Apr | Month.May | Month.Jun -> 2
  | Month.Jul | Month.Aug | Month.Sep -> 3
  | Month.Oct | Month.Nov | Month.Dec -> 4
;;

let start_of_year d = make_exn ~year:(year d) ~month:Month.Jan ~day:1 ()
let end_of_year d = make_exn ~year:(year d) ~month:Month.Dec ~day:31 ()
let is_leap_year { year; _ } = Util.is_leap_year year
let is_first_day_of_month { day_of_month; _ } = Int.equal 1 day_of_month

let is_last_day_of_month { day_of_month; month; year } =
  let m = Month.days_in ~year month in
  Int.equal day_of_month m
;;

let is_first_day_of_year { day_of_month; month; _ } =
  match month with
  | Month.Jan -> Int.equal day_of_month 1
  | _ -> false
;;

let is_last_day_of_year { day_of_month; month; _ } =
  match month with
  | Month.Dec -> Int.equal day_of_month 31
  | _ -> false
;;

let get_day f ~where ~from =
  let rec aux d = if where d then d else aux (f 1 d) in
  aux (f 1 from)
;;

let next_day = get_day add_days
let prev_day = get_day sub_days
let is_dow dow d = Weekday.equal dow (day_of_week d)
let next_day_of_week dow = next_day ~where:(is_dow dow)
let prev_day_of_week dow = prev_day ~where:(is_dow dow)
let next_weekday = next_day ~where:is_weekday
let prev_weekday = prev_day ~where:is_weekday

module Infix = struct
  let ( + ) x y = add y x
  let ( - ) x y = sub y x

  include (Util.Make_equal_infix (CE) : Sigs.EQUATABLE_INFIX with type t := t)

  include (
    Util.Make_compare_infix (CE) : Sigs.COMPARABLE_INFIX with type t := t)
end

include (
  Util.Make_compare_helpers (CE) : Sigs.COMPARABLE_HELPERS with type t := t)

let age ~birthday current =
  let sign, earlier, later =
    if Infix.(current >= birthday)
    then 1, birthday, current
    else -1, current, birthday
  in
  let y = year later - year earlier
  and mb = month earlier
  and mc = month later
  and db = day_of_month earlier
  and dc = day_of_month later in
  let res =
    if Month.(mc < mb) || (Month.equal mc mb && dc < db) then Int.pred y else y
  in
  sign * res
;;

let day = day_of_month
let weekday = day_of_week

let start_of_week ?(week_start = Weekday.Mon) d =
  let curr = day_of_week d |> Weekday.to_int
  and start = Weekday.to_int week_start in
  let diff = (curr - start + 7) mod 7 in
  sub_days diff d
;;

let end_of_week ?(week_start = Weekday.Mon) d =
  start_of_week ~week_start d |> add_days 6
;;

let start_of_quarter d =
  let year = year d in
  let month, _ = Month.quarter_of (month d) in
  (* NOTE: Should never performs any exception here. *)
  make_exn ~year ~month ~day:1 ()
;;

let end_of_quarter d =
  let year = year d in
  let _, month = Month.quarter_of (month d) in
  let day = Month.days_in ~year month in
  (* NOTE: Should never performs any exception here. *)
  make_exn ~year ~month ~day ()
;;

include Infix
