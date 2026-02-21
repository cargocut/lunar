(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t = int64

let zero = Int64.zero
let one = Int64.one
let from_int64 x = x
let from_seconds = Int64.of_int
let from_minutes x = x |> from_seconds |> Int64.mul 60L
let from_hours x = x |> from_seconds |> Int64.mul 3600L
let from_days x = x |> from_seconds |> Int64.mul 86400L
let one_day = from_days 1

let div_floor a b =
  let q = a / b
  and r = a mod b in
  if (not (Int.equal 0 r)) && not (Bool.equal (r > 0) (b > 0))
  then pred q
  else q
;;

let gregorian_cycle = 146097
let epoch_shift = 719468

let days_from_civil year month day =
  (* NOTE: This the Howard Hinnant’s "civil calendar" algorithms.
     See: https://howardhinnant.github.io/date/date.html *)
  let year = if month <= 2 then pred year else year in
  let era = div_floor year 400 in
  let y = year - (era * 400) in
  let m = if month > 2 then month - 3 else month + 9 in
  let d = (y * 365) + (y / 4) - (y / 100) + ((((153 * m) + 2) / 5) + day - 1) in
  (era * gregorian_cycle) + d - epoch_shift
;;

let civil_from_days d =
  (* NOTE: This the Howard Hinnant’s dual "civil calendar" algorithms.
     See: https://howardhinnant.github.io/date/date.html *)
  let shift = d + epoch_shift in
  let era = div_floor shift gregorian_cycle in
  let day_of_era = shift - (era * gregorian_cycle) in
  let year_of_era =
    (day_of_era
     - (day_of_era / 1460)
     + (day_of_era / 36524)
     - (day_of_era / 146096))
    / 365
  in
  let year = year_of_era + (era * 400) in
  let day_of_year =
    day_of_era - ((365 * year_of_era) + (year_of_era / 4) - (year_of_era / 100))
  in
  let m = ((5 * day_of_year) + 2) / 153 in
  let day = day_of_year - (((153 * m) + 2) / 5) + 1 in
  let month = if m < 10 then m + 3 else m - 9 in
  let year = if month <= 2 then year + 1 else year in
  year, month, day
;;

let from_datetime ~year ~month ~day ~hour ~min ~sec =
  let days = days_from_civil year month day |> from_days in
  days
  |> Int64.add (from_hours hour)
  |> Int64.add (from_minutes min)
  |> Int64.add (from_seconds sec)
;;

let to_datetime duration =
  let days = one_day |> Int64.div duration |> Int64.to_int in
  let rem_secs = one_day |> Int64.rem duration |> Int64.to_int in
  let days, rem_secs =
    if rem_secs < 0
    then days - 1, rem_secs + Int64.to_int one_day
    else days, rem_secs
  in
  let year, month, day = civil_from_days days in
  let hour = rem_secs / 3600
  and min = rem_secs mod 3600 / 60
  and sec = rem_secs mod 60 in
  year, month, day, hour, min, sec
;;

let to_int64 x = x
let compare = Int64.compare
let equal = Int64.equal
let add = Int64.add
let sub = Int64.sub
let mul ts x = Int64.(mul ts (of_int x))

module Infix = struct
  let ( + ) = Int64.abs
  let ( - ) = Int64.sub
  let ( * ) = mul
  let ( = ) = equal
  let ( <> ) x y = not (equal x y)
  let ( > ) x y = compare x y > 0
  let ( >= ) x y = compare x y >= 0
  let ( < ) x y = compare x y < 0
  let ( <= ) x y = compare x y <= 0
end

include Infix
