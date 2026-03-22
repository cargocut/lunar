(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t = Date.t * Time.t

type error =
  | Invalid_date of Date.error
  | Invalid_time of Time.error
  | Invalid of Date.error * Time.error
  | Invalid_string of string

exception Invalid_datetime of error

let from date time = date, time
let from_date date = from date Time.midnight
let epoch = from_date Date.epoch

let make_aux f ?at ~year ~month ~day () =
  let hour, min, sec = Option.value ~default:(0, 0, 0) at in
  match f ~year ~month ~day (), Time.make ~hour ~min ~sec () with
  | Ok date, Ok time -> Ok (from date time)
  | Error a, Error b -> Error (Invalid (a, b))
  | Error a, _ -> Error (Invalid_date a)
  | _, Error a -> Error (Invalid_time a)
;;

let make = make_aux Date.make
let make' = make_aux Date.make'

let make_exn ?at ~year ~month ~day () =
  match make ?at ~year ~month ~day () with
  | Error err -> raise (Invalid_datetime err)
  | Ok x -> x
;;

let make_exn' ?at ~year ~month ~day () =
  match make' ?at ~year ~month ~day () with
  | Error err -> raise (Invalid_datetime err)
  | Ok x -> x
;;

let from_string s =
  (* TODO: improve cases. *)
  match
    s
    |> Util.split_on_chars (function
      | 'T' | ' ' | 't' | '\n' | '\t' -> true
      | _ -> false)
    |> List.filter_map (fun x ->
      match String.trim x with
      | "" -> None
      | x -> Some x)
  with
  | [ date; time ] ->
    (match Date.from_string date, Time.from_string time with
     | Ok date, Ok time -> Ok (from date time)
     | Error a, Error b -> Error (Invalid (a, b))
     | Error a, _ -> Error (Invalid_date a)
     | _, Error b -> Error (Invalid_time b))
  | [ date ] ->
    Date.from_string date
    |> Result.map_error (fun err -> Invalid_date err)
    |> Result.map from_date
  | _ -> Error (Invalid_string s)
;;

let from_string_exn s =
  match from_string s with
  | Ok x -> x
  | Error err -> raise (Invalid_datetime err)
;;

let from_duration d =
  let year, month, day, hour, min, sec = Duration.to_datetime d in
  let at = hour, min, sec in
  let month =
    (* NOTE: Result.get_ok should be safe because of
       [to_datetime]. *)
    month |> Month.from_int |> Result.get_ok
  in
  make_exn ~at ~year ~month ~day ()
;;

let to_duration (d, t) = Duration.(Date.to_duration d + Time.to_duration t)
let to_pair x = x
let date = fst
let time = snd
let on_date f x = x |> date |> f
let on_time f x = x |> time |> f
let map_date f (d, t) = f d, t
let map_time f (d, t) = d, f t

let to_string dt =
  let d = date dt
  and t = time dt in
  Date.to_string d ^ " " ^ Time.to_string t
;;

let equal a b =
  let da = date a
  and db = date b in
  let c = Date.equal da db in
  if c
  then (
    let ta = time a
    and tb = time b in
    Time.equal ta tb)
  else c
;;

let compare a b =
  let da = date a
  and db = date b in
  let c = Date.compare da db in
  if Int.equal c 0
  then (
    let ta = time a
    and tb = time b in
    Time.compare ta tb)
  else c
;;

module CE = struct
  type nonrec t = t

  let equal = equal
  let compare = compare
end

let as_duration f dt = f (to_duration dt) |> from_duration
let add d dt = as_duration (fun dt -> Duration.add dt d) dt
let sub d dt = as_duration (fun dt -> Duration.sub dt d) dt
let add_seconds n = add (Duration.from_seconds n)
let sub_seconds n = sub (Duration.from_seconds n)
let add_minutes n = add (Duration.from_minutes n)
let sub_minutes n = sub (Duration.from_minutes n)
let add_hours n = add (Duration.from_hours n)
let sub_hours n = sub (Duration.from_hours n)
let succ = add_seconds 1
let pred = sub_seconds 1

module Infix = struct
  let ( + ) x y = add y x
  let ( - ) x y = sub y x

  include (Util.Make_equal_infix (CE) : Sigs.EQUATABLE_INFIX with type t := t)

  include (
    Util.Make_compare_infix (CE) : Sigs.COMPARABLE_INFIX with type t := t)
end

include (
  Util.Make_compare_helpers (CE) : Sigs.COMPARABLE_HELPERS with type t := t)

include Infix
