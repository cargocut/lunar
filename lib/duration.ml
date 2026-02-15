(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t = int64

let from_int64 x = x
let of_int64 = from_int64
let from_seconds = Int64.of_int
let from_minutes x = x |> from_seconds |> Int64.mul 60L
let from_hours x = x |> from_seconds |> Int64.mul 3600L
let from_days x = x |> from_seconds |> Int64.mul 86400L

let div_floor a b =
  let q = a / b
  and r = a mod b in
  if (not (Int.equal 0 r)) && not (Bool.equal (r > 0) (b > 0))
  then pred q
  else q
;;

let days_from_civil year month day =
  let year = if month <= 2 then pred year else year in
  let era = div_floor year 400 in
  let y = year - (era * 400) in
  let m = if month > 2 then month - 3 else month + 9 in
  let d = (y * 365) + (y / 4) - (y / 100) + ((((153 * m) + 2) / 5) + day - 1) in
  (era * 146097) + d - 719468
;;

let from_datetime ~year ~month ~day ~hour ~min ~sec =
  let days = days_from_civil year month day |> from_days in
  days
  |> Int64.add (from_hours hour)
  |> Int64.add (from_minutes min)
  |> Int64.add (from_seconds sec)
;;

let to_int64 x = x
