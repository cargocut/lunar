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

let time_err_to_string = function
  | Time.Invalid_hour x -> "invalid hour: " ^ string_of_int x
  | Time.Invalid_minute x -> "invalid min: " ^ string_of_int x
  | Time.Invalid_second x -> "invalid sec: " ^ string_of_int x
  | Time.Invalid_string s -> "invalid string: " ^ s
;;

let month_err_to_string = function
  | Month.Invalid_month_number i -> "invalid month number: " ^ string_of_int i
  | Month.Invalid_month_string s -> "invalid month string: " ^ s
;;

let weekday_err_to_string = function
  | Weekday.Invalid_weekday_number i ->
    "invalid weekday number: " ^ string_of_int i
  | Weekday.Invalid_weekday_string s -> "invalid weekday string: " ^ s
;;

let date_err_to_string = function
  | Date.Invalid_string s -> "invalid string: " ^ s
  | Date.Invalid_year x -> "invalid year: " ^ string_of_int x
  | Date.Invalid_month err -> month_err_to_string err
  | Date.Invalid_day { day_max; day } ->
    "invalid day: " ^ string_of_int day ^ "/" ^ string_of_int day_max
;;

let dump_date_error err = err |> date_err_to_string |> print_endline
let dump_month_validation = dump_result Month.to_string month_err_to_string
let dump_weekday x = x |> Weekday.to_string |> print_endline

let dump_weekday_validation =
  dump_result Weekday.to_string weekday_err_to_string
;;

let dump_date x = x |> Date.to_string |> print_endline
let dump_time x = x |> Time.to_string |> print_endline
let dump_time_validation = dump_result Time.to_string time_err_to_string
let dump_date_validation = dump_result Date.to_string date_err_to_string

let dump_date_iso_week_of_year dt =
  let wk = Date.day_of_week dt
  and y, n = Date.week_of_year dt in
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

let dump_era era = era |> Era.to_string |> print_endline
