(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t =
  { tz : Timezone.t
  ; datetime : Datetime.t
  }

let from_local ?(tz = Timezone.utc) datetime = { tz; datetime }
let epoch ?tz () = from_local ?tz Datetime.epoch

let from ?(tz = Timezone.utc) date time =
  { tz; datetime = Datetime.from date time }
;;

let from_date ?(tz = Timezone.utc) date =
  { tz; datetime = Datetime.from_date date }
;;

let from_duration ?(tz = Timezone.utc) duration =
  { tz; datetime = Datetime.from_duration duration }
;;

let make ?(tz = Timezone.utc) ?at ~year ~month ~day () =
  Result.map
    (fun datetime -> { tz; datetime })
    (Datetime.make ?at ~year ~month ~day ())
;;

let make' ?(tz = Timezone.utc) ?at ~year ~month ~day () =
  Result.map
    (fun datetime -> { tz; datetime })
    (Datetime.make' ?at ~year ~month ~day ())
;;

let make_exn ?tz ?at ~year ~month ~day () =
  match make ?tz ?at ~year ~month ~day () with
  | Error err -> raise (Datetime.Invalid_datetime err)
  | Ok x -> x
;;

let make_exn' ?tz ?at ~year ~month ~day () =
  match make' ?tz ?at ~year ~month ~day () with
  | Error err -> raise (Datetime.Invalid_datetime err)
  | Ok x -> x
;;

(* let datetime { datetime; _ } = datetime *)
(* let timezome { tz; _ } = tz *)

let to_local { datetime; tz } =
  datetime |> Datetime.add (Timezone.to_duration tz)
;;

let to_string { tz; datetime } =
  Datetime.to_string datetime ^ Timezone.to_string tz
;;
