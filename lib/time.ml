(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t = int

let to_duration = Duration.from_seconds

type error =
  | Invalid_hour of int
  | Invalid_minute of int
  | Invalid_second of int
  | Invalid_string of string

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

let from_string s =
  (* TODO: improve cases, to handle [3am] for example. *)
  match String.split_on_char ':' s with
  | [ hr; min; sec ]
    when Util.only_numbers hr && Util.only_numbers min && Util.only_numbers sec
    ->
    (* NOTE: Using unsafe function here is safe
       because of the guard [Util.only_numbers]. *)
    let hour = int_of_string hr
    and min = int_of_string min
    and sec = int_of_string sec in
    make ~hour ~min ~sec ()
  | [ hr; min ] when Util.only_numbers hr && Util.only_numbers min ->
    (* NOTE: Using unsafe function here is safe
       because of the guard [Util.only_numbers]. *)
    let hour = int_of_string hr
    and min = int_of_string min in
    make ~hour ~min ~sec:0 ()
  | [ hr ] when Util.only_numbers hr ->
    (* NOTE: Using unsafe function here is safe
       because of the guard [Util.only_numbers]. *)
    let hour = int_of_string hr in
    make ~hour ~min:0 ~sec:0 ()
  | _ -> Error (Invalid_string s)
;;

let midnight = make_exn ~hour:0 ~min:0 ~sec:0 ()
let noon = make_exn ~hour:12 ~min:0 ~sec:0 ()
let end_of_day = make_exn ~hour:23 ~min:59 ~sec:59 ()
let hour t = t / 3600
let minute t = t mod 3600 / 60
let second t = t mod 60
let equal = Int.equal
let compare = Int.compare

module CE = struct
  type nonrec t = t

  let equal = equal
  let compare = compare
end

include (
  Util.Make_compare_helpers (CE) : Sigs.COMPARABLE_HELPERS with type t := t)

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

let diff a b =
  let a = to_duration a
  and b = to_duration b in
  Duration.sub a b
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
let pred = sub_seconds 1

let truncate_duration dur t =
  let d = t |> to_duration |> Duration.to_int64
  and s = dur |> Duration.abs |> Duration.to_int64 in
  let r = Int64.rem d s in
  let b = Int64.sub d r in
  from_duration (Duration.from_int64 b)
;;

let round_duration dur t =
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

let truncate resolution t =
  match resolution with
  | `duration dur -> truncate_duration dur t
  | _ -> midnight
;;

let round resolution t =
  match resolution with
  | `duration dur -> round_duration dur t
  | _ -> midnight
;;

let succ_minute t = t |> add_minutes 1 |> truncate Resolution.minute
let pred_minute t = t |> sub_minutes 1 |> truncate Resolution.minute
let succ_hour t = t |> add_hours 1 |> truncate Resolution.hour
let pred_hour t = t |> sub_hours 1 |> truncate Resolution.hour

module Infix = struct
  let ( + ) x y = add y x
  let ( - ) x y = sub y x

  include (Util.Make_equal_infix (CE) : Sigs.EQUATABLE_INFIX with type t := t)

  include (
    Util.Make_compare_infix (CE) : Sigs.COMPARABLE_INFIX with type t := t)
end

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
let floor = truncate

let ceil resolution t =
  match resolution with
  | `duration dur ->
    let x = truncate_duration dur t in
    if equal x t then t else add dur x
  | _ -> midnight
;;

include Infix
