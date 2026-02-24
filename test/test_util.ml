(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

let dump_duration x = x |> Duration.to_int64 |> Int64.to_string |> print_endline
let dump_bool x = print_endline (if x then "true" else "false")

let dump_result f_r f_e = function
  | Ok x -> "ok: " ^ f_r x |> print_endline
  | Error err -> "error: " ^ f_e err |> print_endline
;;

let dump_month m = m |> Month.to_string |> print_endline

let month_err_to_string = function
  | Month.Invalid_month_number i -> "invalid month number: " ^ string_of_int i
  | Month.Invalid_month_string s -> "invalid month string: " ^ s
;;

let weekday_err_to_string = function
  | Weekday.Invalid_weekday_number i ->
    "invalid weekday number: " ^ string_of_int i
  | Weekday.Invalid_weekday_string s -> "invalid weekday string: " ^ s
;;

let datetime_err_to_string = function
  | Datetime.Invalid_year x -> "invalid year: " ^ string_of_int x
  | Datetime.Invalid_month err -> month_err_to_string err
  | Datetime.Invalid_hour x -> "invalid hour: " ^ string_of_int x
  | Datetime.Invalid_min x -> "invalid min: " ^ string_of_int x
  | Datetime.Invalid_sec x -> "invalid sec: " ^ string_of_int x
  | Datetime.Invalid_day { day_max; day } ->
    "invalid day: " ^ string_of_int day ^ "/" ^ string_of_int day_max
;;

let dump_month_validation = dump_result Month.to_string month_err_to_string
let dump_weekday x = x |> Weekday.to_string |> print_endline

let dump_weekday_validation =
  dump_result Weekday.to_string weekday_err_to_string
;;

let dump_datetime x = x |> Datetime.to_string |> print_endline

let dump_datetime_validation =
  dump_result Datetime.to_string datetime_err_to_string
;;

let dump_iso_week_of_year dt =
  let wk = Datetime.day_of_week dt
  and y, n = Datetime.week_of_year dt in
  string_of_int y
  ^ " W"
  ^ string_of_int n
  ^ ", "
  ^ Weekday.to_short_string wk
  ^ "/"
  ^ string_of_int (succ (Weekday.to_int wk))
  |> print_endline
;;

let dump_dhms d =
  let d, h, m, s = d |> Duration.dhms in
  string_of_int d
  ^ "d, "
  ^ string_of_int h
  ^ ":"
  ^ string_of_int m
  ^ ":"
  ^ string_of_int s
  |> print_endline
;;
