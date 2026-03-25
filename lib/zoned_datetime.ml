(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t =
  { tz : Timezone.t
  ; utc : Datetime.t
  }

let from_local_datetime ?(tz = Timezone.utc) local =
  let utc = Datetime.sub (Timezone.to_duration tz) local in
  { tz; utc }
;;

let from_utc utc = { tz = Timezone.utc; utc }
let from ?tz date time = time |> Datetime.from date |> from_local_datetime ?tz
let from_date ?tz date = date |> Datetime.from_date |> from_local_datetime ?tz
let epoch ?tz () = from_local_datetime ?tz Datetime.epoch

let from_duration ?tz duration =
  duration |> Datetime.from_duration |> from_local_datetime ?tz
;;

let make ?tz ?at ~year ~month ~day () =
  Result.map (from_local_datetime ?tz) (Datetime.make ?at ~year ~month ~day ())
;;

let make' ?tz ?at ~year ~month ~day () =
  Result.map (from_local_datetime ?tz) (Datetime.make' ?at ~year ~month ~day ())
;;

let make_exn ?tz ?at ~year ~month ~day () =
  match make ?tz ?at ~year ~month ~day () with
  | Error err -> raise (Datetime.Invalid_datetime err)
  | Ok x -> x
;;

let make_exn' ?tz ?at ~year ~month ~day () =
  match make' ?tz ?at ~year ~month ~day () with
  | Error err -> raise (Datetime.Invalid_datetime err)
  | Ok x -> x
;;

let to_zoned_utc zdt = { zdt with tz = Timezone.utc }
let to_local_datetime { tz; utc } = Datetime.add (Timezone.to_duration tz) utc
let change_timezone ~tz zdt = { zdt with tz }
let to_datetime ~tz zdt = zdt |> change_timezone ~tz |> to_local_datetime
let on_utc f { utc; _ } = f utc
let map_utc f zdt = { zdt with utc = f zdt.utc }
let timezone { tz; _ } = tz
let to_utc { utc; _ } = utc
let on_local f zdt = f (to_local_datetime zdt)

let map_local f zdt =
  let local = f (zdt |> to_local_datetime) in
  let tz = timezone zdt in
  from_local_datetime ~tz local
;;

let to_string ({ tz; _ } as zdt) =
  Datetime.to_string (to_local_datetime zdt) ^ Timezone.to_string tz
;;

let compare a b =
  let a = to_utc a
  and b = to_utc b in
  Datetime.compare a b
;;

let equal a b =
  let a = to_utc a
  and b = to_utc b in
  Datetime.equal a b
;;

let diff a b =
  let a = to_utc a
  and b = to_utc b in
  Datetime.diff a b
;;

(* NOTE: The choice between [map_utc] and [map_local] (and [on_utc] and
   [on_local]) generally depends on whether you are working with
   non-calendar data (in which case you should use [_utc]) or
   calendar data (in which case you should use [_local]).*)

let add d = map_utc (Datetime.add d)
let sub d = map_utc (Datetime.sub d)
let add_seconds d = map_utc (Datetime.add_seconds d)
let sub_seconds d = map_utc (Datetime.sub_seconds d)
let add_minutes d = map_utc (Datetime.add_minutes d)
let sub_minutes d = map_utc (Datetime.sub_minutes d)
let add_hours d = map_utc (Datetime.add_hours d)
let sub_hours d = map_utc (Datetime.sub_hours d)

(* NOTE: Contrary to what you might think, adding days and weeks uses a
   duration representation, so there's no need to convert to
   local time. *)

let add_days d = map_utc (Datetime.add_days d)
let sub_days d = map_utc (Datetime.sub_days d)
let add_weeks d = map_utc (Datetime.add_weeks d)
let sub_weeks d = map_utc (Datetime.sub_weeks d)
let add_months d = map_local (Datetime.add_months d)
let sub_months d = map_local (Datetime.sub_months d)
let add_quarters d = map_local (Datetime.add_quarters d)
let sub_quarters d = map_local (Datetime.sub_quarters d)
let add_years d = map_local (Datetime.add_years d)
let sub_years d = map_local (Datetime.sub_years d)
let succ = map_utc Datetime.succ
let pred = map_utc Datetime.pred
let succ_second = map_utc Datetime.succ_second
let pred_second = map_utc Datetime.pred_second
let succ_minute = map_utc Datetime.succ_minute
let pred_minute = map_utc Datetime.pred_minute
let succ_hour = map_utc Datetime.succ_hour
let pred_hour = map_utc Datetime.pred_hour
let succ_day ?where = map_local (Datetime.succ_day ?where)
let pred_day ?where = map_local (Datetime.pred_day ?where)
let succ_day_of_week sow = map_local (Datetime.succ_day_of_week sow)
let pred_day_of_week sow = map_local (Datetime.pred_day_of_week sow)
let succ_weekday = map_local Datetime.succ_weekday
let pred_weekday = map_local Datetime.pred_weekday
let succ_week ?week_start = map_local (Datetime.succ_week ?week_start)
let pred_week ?week_start = map_local (Datetime.pred_week ?week_start)
let succ_month = map_local Datetime.succ_month
let pred_month = map_local Datetime.pred_month
let succ_quarter = map_local Datetime.succ_quarter
let pred_quarter = map_local Datetime.pred_quarter
let succ_year = map_local Datetime.succ_year
let pred_year = map_local Datetime.pred_year
let with_local_time time = map_local (Datetime.with_time time)
let with_local_date date = map_local (Datetime.with_date date)
let tomorrow zdt = succ_day zdt
let yesterday zdt = pred_day zdt
let start_of_minute = map_local Datetime.start_of_minute
let end_of_minute = map_local Datetime.end_of_minute
let start_of_hour = map_local Datetime.start_of_hour
let end_of_hour = map_local Datetime.end_of_hour
let start_of_day = map_local Datetime.start_of_day
let end_of_day = map_local Datetime.end_of_day
let start_of_morning = map_local Datetime.start_of_morning
let end_of_morning = map_local Datetime.end_of_morning
let start_of_afternoon = map_local Datetime.start_of_afternoon
let end_of_afternoon = map_local Datetime.end_of_afternoon
let at_noon = map_local Datetime.at_noon
let start_of_evening = map_local Datetime.start_of_evening
let end_of_evening = map_local Datetime.end_of_evening
let start_of_night = map_local Datetime.start_of_night
let end_of_night = map_local Datetime.end_of_night
let start_of_week ?week_start = map_local (Datetime.start_of_week ?week_start)
let end_of_week ?week_start = map_local (Datetime.end_of_week ?week_start)
let start_of_month = map_local Datetime.start_of_month
let end_of_month = map_local Datetime.end_of_month
let start_of_quarter = map_local Datetime.start_of_quarter
let end_of_quarter = map_local Datetime.end_of_quarter
let start_of_year = map_local Datetime.start_of_year
let end_of_year = map_local Datetime.end_of_year
let age ~birthday = on_local (Datetime.age ~birthday)

let classify_resolution f res =
  (* NOTE: As before, clock expressions are handled in UTC, and calendar
     data is handled in local time. *)
  match res with
  | #Resolution.for_time -> map_utc (f res)
  | #Resolution.for_date -> map_local (f res)
;;

let truncate r = classify_resolution Datetime.truncate r
let floor = truncate
let ceil r = classify_resolution Datetime.ceil r
let round r = classify_resolution Datetime.round r

(* NOTE: here, everything is local-based *)

let is_am = on_local Datetime.is_am
let is_pm = on_local Datetime.is_pm
let is_noon = on_local Datetime.is_noon
let is_midnight = on_local Datetime.is_midnight
let is_morning = on_local Datetime.is_morning
let is_afternoon = on_local Datetime.is_afternoon
let is_evening = on_local Datetime.is_evening
let is_night = on_local Datetime.is_night
let is_weekend = on_local Datetime.is_weekend
let is_weekday = on_local Datetime.is_weekday
let is_leap_year = on_local Datetime.is_leap_year
let is_first_day_of_month = on_local Datetime.is_first_day_of_month
let is_last_day_of_month = on_local Datetime.is_last_day_of_month
let is_first_day_of_quarter = on_local Datetime.is_first_day_of_quarter
let is_last_day_of_quarter = on_local Datetime.is_last_day_of_quarter
let is_first_day_of_year = on_local Datetime.is_first_day_of_year
let is_last_day_of_year = on_local Datetime.is_last_day_of_year
let is_day_of_week wd = on_local (Datetime.is_day_of_week wd)

let is_first_day_of_week ?week_start =
  on_local (Datetime.is_first_day_of_week ?week_start)
;;

let is_last_day_of_week ?week_start =
  on_local (Datetime.is_last_day_of_week ?week_start)
;;

module CE = struct
  type nonrec t = t

  let equal = equal
  let compare = compare
end

module Infix = struct
  let ( + ) x y = add y x
  let ( - ) x y = sub y x

  include Util.Make_equal_infix (CE)
  include Util.Make_compare_infix (CE)
end

include Util.Make_compare_helpers (CE)
include Infix
