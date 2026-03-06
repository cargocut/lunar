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

let hour t = t / 3600
let minute t = t mod 3600 / 60
let second t = t mod 60
let equal = Int.equal
let compare = Int.compare

let to_string t =
  (* NOTE: The function does not rely on Format for Js_of_ocaml, but it
     does allocate a lot. For now, we accept that this is okay.*)
  [ Util.lpad ~size:2 (hour t)
  ; Util.lpad ~size:2 (minute t)
  ; Util.lpad ~size:2 (second t)
  ]
  |> String.concat ":"
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
