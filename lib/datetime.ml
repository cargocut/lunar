(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t = Date.t * Time.t

type error =
  | Invalid_date of Date.error
  | Invalid_time of Time.error
  | Invalid of Date.error * Time.error
  | Invalid_string of string

exception Invalid_datetime of error

let from date time = date, time
let from_date date = from date Time.midnight
let epoch = from_date Date.epoch

let make_aux f ?at ~year ~month ~day () =
  let hour, min, sec = Option.value ~default:(0, 0, 0) at in
  match f ~year ~month ~day (), Time.make ~hour ~min ~sec () with
  | Ok date, Ok time -> Ok (from date time)
  | Error a, Error b -> Error (Invalid (a, b))
  | Error a, _ -> Error (Invalid_date a)
  | _, Error a -> Error (Invalid_time a)
;;

let make = make_aux Date.make
let make' = make_aux Date.make'

let make_exn ?at ~year ~month ~day () =
  match make ?at ~year ~month ~day () with
  | Error err -> raise (Invalid_datetime err)
  | Ok x -> x
;;

let make_exn' ?at ~year ~month ~day () =
  match make' ?at ~year ~month ~day () with
  | Error err -> raise (Invalid_datetime err)
  | Ok x -> x
;;

let from_string s =
  (* TODO: improve cases. *)
  match
    s
    |> Util.split_on_chars (function
      | 'T' | ' ' | 't' | '\n' | '\t' -> true
      | _ -> false)
    |> List.filter_map (fun x ->
      match String.trim x with
      | "" -> None
      | x -> Some x)
  with
  | [ date; time ] ->
    (match Date.from_string date, Time.from_string time with
     | Ok date, Ok time -> Ok (from date time)
     | Error a, Error b -> Error (Invalid (a, b))
     | Error a, _ -> Error (Invalid_date a)
     | _, Error b -> Error (Invalid_time b))
  | [ date ] ->
    Date.from_string date
    |> Result.map_error (fun err -> Invalid_date err)
    |> Result.map from_date
  | _ -> Error (Invalid_string s)
;;

let from_string_exn s =
  match from_string s with
  | Ok x -> x
  | Error err -> raise (Invalid_datetime err)
;;

let from_duration d =
  let year, month, day, hour, min, sec = Duration.to_datetime d in
  let at = hour, min, sec in
  let month =
    (* NOTE: Result.get_ok should be safe because of
       [to_datetime]. *)
    month |> Month.from_int |> Result.get_ok
  in
  make_exn ~at ~year ~month ~day ()
;;

let to_duration (d, t) = Duration.(Date.to_duration d + Time.to_duration t)

let diff a b =
  let a = to_duration a
  and b = to_duration b in
  Duration.sub a b
;;

let to_pair x = x
let date = fst
let time = snd
let on_date f x = x |> date |> f
let on_time f x = x |> time |> f
let map_date f (d, t) = f d, t
let map_time f (d, t) = d, f t
let hour = on_time Time.hour
let minute = on_time Time.minute
let second = on_time Time.second
let era = on_date Date.era
let year_of_era = on_date Date.year_of_era
let century_of_era = on_date Date.century_of_era
let year_of_century = on_date Date.year_of_century
let year = on_date Date.year
let quarter = on_date Date.quarter
let month = on_date Date.month
let day_of_month = on_date Date.day_of_month
let day_of_week = on_date Date.day_of_week
let days_in_month = on_date Date.days_in_month
let day_of_year = on_date Date.day_of_year
let week_of_year = on_date Date.week_of_year
let day = on_date Date.day
let weekday = on_date Date.weekday

let to_string dt =
  let d = date dt
  and t = time dt in
  Date.to_string d ^ " " ^ Time.to_string t
;;

let equal a b =
  let da = date a
  and db = date b in
  let c = Date.equal da db in
  if c
  then (
    let ta = time a
    and tb = time b in
    Time.equal ta tb)
  else c
;;

let compare a b =
  let da = date a
  and db = date b in
  let c = Date.compare da db in
  if Int.equal c 0
  then (
    let ta = time a
    and tb = time b in
    Time.compare ta tb)
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
let add_seconds n = add (Duration.from_seconds n)
let sub_seconds n = sub (Duration.from_seconds n)
let add_minutes n = add (Duration.from_minutes n)
let sub_minutes n = sub (Duration.from_minutes n)
let add_hours n = add (Duration.from_hours n)
let sub_hours n = sub (Duration.from_hours n)
let add_days i = map_date (Date.add_days i)
let sub_days i = map_date (Date.sub_days i)
let add_weeks i = map_date (Date.add_weeks i)
let sub_weeks i = map_date (Date.sub_weeks i)
let add_months i = map_date (Date.add_months i)
let sub_months i = map_date (Date.sub_months i)
let add_quarters i = map_date (Date.add_quarters i)
let sub_quarters i = map_date (Date.sub_quarters i)
let add_years i = map_date (Date.add_years i)
let sub_years i = map_date (Date.sub_years i)

module Infix = struct
  let ( + ) x y = add y x
  let ( - ) x y = sub y x

  include (Util.Make_equal_infix (CE) : Sigs.EQUATABLE_INFIX with type t := t)

  include (
    Util.Make_compare_infix (CE) : Sigs.COMPARABLE_INFIX with type t := t)
end

include (
  Util.Make_compare_helpers (CE) : Sigs.COMPARABLE_HELPERS with type t := t)

let truncate resolution dt =
  match resolution with
  | `duration dur -> map_time (Time.truncate (`duration dur)) dt
  | #Resolution.for_date as r ->
    dt |> map_date (Date.truncate r) |> map_time (fun _ -> Time.midnight)
;;

let floor = truncate

let ceil resolution dt =
  (* KLUDGE: We need to keep logic since date and time ar now connected. *)
  match resolution with
  | `duration dur ->
    let tt = time dt in
    let tr = Time.truncate (`duration dur) tt in
    if Time.equal tt tr then dt else add dur (map_time (fun _ -> tr) dt)
  | #Resolution.for_date as r ->
    let t = truncate r dt in
    if equal dt t
    then dt
    else (
      match r with
      | `day -> add_days 1 t
      | `week _ -> add_weeks 1 t
      | `month -> add_months 1 t
      | `quarter -> add_quarters 1 t
      | `year -> add_years 1 t)
;;

let round resolution dt =
  (* KLUDGE: We need to keep logic since date and time ar now connected. *)
  match resolution with
  | `duration dur -> map_time (Time.round (`duration dur)) dt
  | #Resolution.for_date as r ->
    let t = truncate r dt
    and c = ceil r dt in
    if equal t c
    then t
    else (
      let dt = diff dt t
      and dc = diff c dt in
      if Duration.(dt <= dc) then t else c)
;;

let succ = add_seconds 1
let pred = sub_seconds 1
let succ_second = succ
let pred_second = pred
let succ_minute dt = dt |> add_minutes 1 |> truncate Resolution.minute
let pred_minute dt = dt |> sub_minutes 1 |> truncate Resolution.minute
let succ_hour dt = dt |> add_hours 1 |> truncate Resolution.hour
let pred_hour dt = dt |> sub_hours 1 |> truncate Resolution.hour
let start_of_day dt = map_time (fun _ -> Time.midnight) dt
let end_of_day dt = map_time (fun _ -> Time.end_of_day) dt
let handle_succ f dt = dt |> map_date f |> start_of_day
let succ_day ?where dt = handle_succ (Date.succ_day ?where) dt
let pred_day ?where dt = handle_succ (Date.pred_day ?where) dt
let succ_day_of_week wd dt = handle_succ (Date.succ_day_of_week wd) dt
let pred_day_of_week wd dt = handle_succ (Date.pred_day_of_week wd) dt
let succ_weekday dt = handle_succ Date.succ_weekday dt
let pred_weekday dt = handle_succ Date.pred_weekday dt
let succ_week ?week_start dt = handle_succ (Date.succ_week ?week_start) dt
let pred_week ?week_start dt = handle_succ (Date.pred_week ?week_start) dt
let succ_month dt = handle_succ Date.succ_month dt
let pred_month dt = handle_succ Date.pred_month dt
let succ_quarter dt = handle_succ Date.succ_quarter dt
let pred_quarter dt = handle_succ Date.pred_quarter dt
let succ_year dt = handle_succ Date.succ_year dt
let pred_year dt = handle_succ Date.pred_year dt

include Infix
