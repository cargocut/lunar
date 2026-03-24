(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t =
  { tz : Timezone.t
  ; local : Datetime.t
  }

let from_datetime ?(tz = Timezone.utc) local = { tz; local }
let from ?tz date time = time |> Datetime.from date |> from_datetime ?tz
let from_date ?tz date = date |> Datetime.from_date |> from_datetime ?tz
let epoch ?tz () = from_datetime ?tz Datetime.epoch

let from_duration ?tz duration =
  duration |> Datetime.from_duration |> from_datetime ?tz
;;

let make ?tz ?at ~year ~month ~day () =
  Result.map (from_datetime ?tz) (Datetime.make ?at ~year ~month ~day ())
;;

let make' ?tz ?at ~year ~month ~day () =
  Result.map (from_datetime ?tz) (Datetime.make' ?at ~year ~month ~day ())
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

let to_string { tz; local } = Datetime.to_string local ^ Timezone.to_string tz
