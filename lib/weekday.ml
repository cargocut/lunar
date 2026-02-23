(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t =
  | Mon
  | Tue
  | Wed
  | Thu
  | Fri
  | Sat
  | Sun

type error =
  | Invalid_weekday_number of int
  | Invalid_weekday_string of string

let all = [ Mon; Tue; Wed; Thu; Fri; Sat; Sun ]

let to_int = function
  | Mon -> 0
  | Tue -> 1
  | Wed -> 2
  | Thu -> 3
  | Fri -> 4
  | Sat -> 5
  | Sun -> 6
;;

let from_int = function
  | 0 -> Ok Mon
  | 1 -> Ok Tue
  | 2 -> Ok Wed
  | 3 -> Ok Thu
  | 4 -> Ok Fri
  | 5 -> Ok Sat
  | 6 -> Ok Sun
  | n -> Error (Invalid_weekday_number n)
;;

let to_string = function
  | Mon -> "monday"
  | Tue -> "tuesday"
  | Wed -> "wednesday"
  | Thu -> "thursday"
  | Fri -> "friday"
  | Sat -> "saturday"
  | Sun -> "sunday"
;;

let to_short_string = function
  | Mon -> "mon"
  | Tue -> "tue"
  | Wed -> "wed"
  | Thu -> "thu"
  | Fri -> "fri"
  | Sat -> "sat"
  | Sun -> "sun"
;;

let from_string str =
  match String.(trim @@ lowercase_ascii str) with
  | "mon" | "monday" -> Ok Mon
  | "tue" | "tuesday" -> Ok Tue
  | "wed" | "wednesday" -> Ok Wed
  | "thu" | "thursday" -> Ok Thu
  | "fri" | "friday" -> Ok Fri
  | "sat" | "saturday" -> Ok Sat
  | "sun" | "sunday" -> Ok Sun
  | s -> Error (Invalid_weekday_string s)
;;

let succ = function
  | Sun -> Mon
  | wd ->
    from_int (succ @@ to_int wd)
    |>
    (* NOTE: [Sun] case is guarded so [get_ok] is safe. *)
    Result.get_ok
;;

let pred = function
  | Mon -> Sun
  | wd ->
    from_int (pred @@ to_int wd)
    |>
    (* NOTE: [Mon] case is guarded so [get_ok] is safe. *)
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
