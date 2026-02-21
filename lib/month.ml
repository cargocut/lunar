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

type error = Invalid_month_number of int

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

let days_in ~year = function
  | Jan | Mar | May | Jul | Aug | Oct | Dec -> 31
  | Feb -> if Util.is_leap_year year then 29 else 28
  | Apr | Jun | Sep | Nov -> 30
;;

let succ = function
  | Dec -> Jan
  | mon ->
    from_int (succ @@ to_int mon)
    |> Result.get_ok (* NOTE: [Dec] case is guarded so [get_ok] is safe. *)
;;

let pred = function
  | Jan -> Dec
  | mon ->
    from_int (pred @@ to_int mon)
    |> Result.get_ok (* NOTE: [Jan] case is guarded so [get_ok] is safe. *)
;;
