(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t =
  | Jan
  | Feb
  | Mar
  | Apr
  | May
  | Jun
  | Jul
  | Aug
  | Sep
  | Oct
  | Nov
  | Dec

type error =
  | Invalid_month_number of int
  | Invalid_month_string of string

let all = [ Jan; Feb; Mar; Apr; May; Jun; Jul; Aug; Sep; Oct; Nov; Dec ]

let to_int = function
  | Jan -> 1
  | Feb -> 2
  | Mar -> 3
  | Apr -> 4
  | May -> 5
  | Jun -> 6
  | Jul -> 7
  | Aug -> 8
  | Sep -> 9
  | Oct -> 10
  | Nov -> 11
  | Dec -> 12
;;

let from_int = function
  | 1 -> Ok Jan
  | 2 -> Ok Feb
  | 3 -> Ok Mar
  | 4 -> Ok Apr
  | 5 -> Ok May
  | 6 -> Ok Jun
  | 7 -> Ok Jul
  | 8 -> Ok Aug
  | 9 -> Ok Sep
  | 10 -> Ok Oct
  | 11 -> Ok Nov
  | 12 -> Ok Dec
  | n -> Error (Invalid_month_number n)
;;

let to_string = function
  | Jan -> "january"
  | Feb -> "february"
  | Mar -> "march"
  | Apr -> "april"
  | May -> "may"
  | Jun -> "june"
  | Jul -> "july"
  | Aug -> "august"
  | Sep -> "september"
  | Oct -> "october"
  | Nov -> "november"
  | Dec -> "december"
;;

let to_short_string = function
  | Jan -> "jan"
  | Feb -> "feb"
  | Mar -> "mar"
  | Apr -> "apr"
  | May -> "may"
  | Jun -> "jun"
  | Jul -> "jul"
  | Aug -> "aug"
  | Sep -> "sep"
  | Oct -> "oct"
  | Nov -> "nov"
  | Dec -> "dec"
;;

let from_string str =
  match String.(trim @@ lowercase_ascii str) with
  | "jan" | "january" -> Ok Jan
  | "feb" | "february" -> Ok Feb
  | "mar" | "march" -> Ok Mar
  | "apr" | "april" -> Ok Apr
  | "may" -> Ok May
  | "jun" | "june" -> Ok Jun
  | "jul" | "july" -> Ok Jul
  | "aug" | "august" -> Ok Aug
  | "sep" | "september" -> Ok Sep
  | "oct" | "october" -> Ok Oct
  | "nov" | "november" -> Ok Nov
  | "dec" | "december" -> Ok Dec
  | s -> Error (Invalid_month_string s)
;;

let days_in ~year = function
  | Jan | Mar | May | Jul | Aug | Oct | Dec -> 31
  | Feb -> if Util.is_leap_year year then 29 else 28
  | Apr | Jun | Sep | Nov -> 30
;;

let succ = function
  | Dec -> Jan
  | mon ->
    from_int (succ @@ to_int mon)
    |>
    (* NOTE: [Dec] case is guarded so [get_ok] is safe. *)
    Result.get_ok
;;

let pred = function
  | Jan -> Dec
  | mon ->
    from_int (pred @@ to_int mon)
    |>
    (* NOTE: [Jan] case is guarded so [get_ok] is safe. *)
    Result.get_ok
;;

let equal a b =
  let a = to_int a
  and b = to_int b in
  Int.equal a b
;;

let compare a b =
  let a = to_int a
  and b = to_int b in
  Int.compare a b
;;

module Infix = struct
  let ( = ) = equal
  let ( <> ) x y = not (equal x y)
  let ( > ) x y = compare x y > 0
  let ( >= ) x y = compare x y >= 0
  let ( < ) x y = compare x y < 0
  let ( <= ) x y = compare x y <= 0
end

include Infix
