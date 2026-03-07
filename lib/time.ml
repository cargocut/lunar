(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t = int

let to_duration = Duration.from_seconds

type error =
  | Invalid_hour of int
  | Invalid_minute of int
  | Invalid_second of int

exception Invalid_time of error

let validate_bound max err x = if x < 0 || x >= max then Error (err x) else Ok x

let make ~hour ~min ~sec () =
  let ( let* ) = Result.bind in
  let* hour = validate_bound 24 (fun x -> Invalid_hour x) hour in
  let* min = validate_bound 60 (fun x -> Invalid_minute x) min in
  let* sec = validate_bound 60 (fun x -> Invalid_second x) sec in
  Ok ((hour * 3600) + (min * 60) + sec)
;;

let make_exn ~hour ~min ~sec () =
  match make ~hour ~min ~sec () with
  | Ok t -> t
  | Error err -> raise (Invalid_time err)
;;

let am_h n = n mod 24 mod 12
let pm_h n = am_h n + 12

let pm h =
  let hour = pm_h h in
  make_exn ~hour ~min:0 ~sec:0 ()
;;

let am h =
  let hour = am_h h in
  make_exn ~hour ~min:0 ~sec:0 ()
;;

let midnight = make_exn ~hour:0 ~min:0 ~sec:0 ()
let noon = make_exn ~hour:12 ~min:0 ~sec:0 ()
let end_of_day = make_exn ~hour:23 ~min:59 ~sec:59 ()
let hour t = t / 3600
let minute t = t mod 3600 / 60
let second t = t mod 60
let equal = Int.equal
let compare = Int.compare
let min = Int.min
let max = Int.max

let to_string t =
  (* NOTE: The function does not rely on Format for Js_of_ocaml, but it
     does allocate a lot. For now, we accept that this is okay.*)
  [ Util.lpad ~size:2 (hour t)
  ; Util.lpad ~size:2 (minute t)
  ; Util.lpad ~size:2 (second t)
  ]
  |> String.concat ":"
;;

let from_duration d =
  let u = Duration.from_days 1 |> Duration.to_int64 in
  let d = Duration.to_int64 d in
  let r = Int64.rem d u in
  let res = if r < 0L then Int64.add r u else r in
  Int64.to_int res
;;

let add d t = Duration.add (to_duration t) d |> from_duration
let sub d t = Duration.sub (to_duration t) d |> from_duration
let add_seconds n = add (Duration.from_seconds n)
let sub_seconds n = sub (Duration.from_seconds n)
let add_minutes n = add (Duration.from_minutes n)
let sub_minutes n = sub (Duration.from_minutes n)
let add_hours n = add (Duration.from_hours n)
let sub_hours n = sub (Duration.from_hours n)
let succ = add_seconds 1
let pred = add_seconds 1

let truncate dur t =
  let d = t |> to_duration |> Duration.to_int64
  and s = dur |> Duration.to_int64 in
  let r = Int64.rem d s in
  let b = Int64.sub d r in
  from_duration (Duration.from_int64 b)
;;

let round dur t =
  let s = dur |> Duration.to_int64 in
  let d = t |> to_duration |> Duration.to_int64
  and h = Int64.div s 2L in
  let r = Int64.rem d s in
  let r = if r < 0L then Int64.add r s else r in
  let base = Int64.sub d r in
  let res =
    (if r >= h then Int64.add base s else base) |> Duration.from_int64
  in
  from_duration res
;;

module Infix = struct
  let ( + ) x y = add y x
  let ( - ) x y = sub y x
  let ( = ) = equal
  let ( <> ) x y = not (equal x y)
  let ( > ) x y = compare x y > 0
  let ( >= ) x y = compare x y >= 0
  let ( < ) x y = compare x y < 0
  let ( <= ) x y = compare x y <= 0
end

let is_earlier ~than t = Infix.(t < than)
let is_later ~than t = Infix.(t > than)
let is_am t = t < noon
let is_pm t = t >= noon
let is_noon = equal noon
let is_midnight = equal midnight

let is_morning t =
  let h = hour t in
  h >= 5 && h < 12
;;

let is_afternoon t =
  let h = hour t in
  h >= 12 && h < 17
;;

let is_evening t =
  let h = hour t in
  h >= 17 && h < 21
;;

let is_night x = not (is_morning x || is_afternoon x || is_evening x)

include Infix
