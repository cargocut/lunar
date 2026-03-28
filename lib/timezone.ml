(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t = Duration.t
type error = Invalid_string of string

exception Invalid_timezone of error

let utc = Duration.zero
let make ~hour:h ~min:m = Duration.(from_hours h + from_minutes m)
let equal = Duration.equal
let compare = Duration.compare
let to_duration x = x

let str_to_pair s =
  ( s.[0]
  , String.make 1 s.[1] ^ String.make 1 s.[2]
  , s.[3]
  , String.make 1 s.[4] ^ String.make 1 s.[5] )
;;

let from_string s =
  if String.equal "Z" s
  then Ok utc
  else if String.equal "" s
  then Error (Invalid_string s)
  else (
    let len = String.length s in
    if len = 6
    then (
      match str_to_pair s with
      | (('-' | '+') as sign), hour, ':', min
        when Util.only_numbers hour && Util.only_numbers min ->
        let hour = int_of_string (String.make 1 sign ^ hour)
        and min = int_of_string min in
        if min > 59 || min < 0
        then Error (Invalid_string s)
        else Ok (make ~hour ~min)
      | _ -> Error (Invalid_string s))
    else Error (Invalid_string s))
;;

let from_string_exn s =
  match from_string s with
  | Ok x -> x
  | Error err -> raise (Invalid_timezone err)
;;

let to_string x =
  let d = to_duration x in
  if Duration.equal d Duration.zero
  then "Z"
  else (
    let sign = if Duration.(zero > d) then "-" else "+" in
    let h, m, _ = Duration.hms d in
    sign ^ Util.lpad ~size:2 (Int.abs h) ^ ":" ^ Util.lpad ~size:2 (Int.abs m))
;;

module CE = struct
  type nonrec t = t

  let equal = equal
  let compare = compare
end

module Infix = struct
  include Util.Make_equal_infix (CE)
  include Util.Make_compare_infix (CE)
end

include Util.Make_compare_helpers (CE)
module Map = Stdlib.Map.Make (CE)
module Set = Stdlib.Set.Make (CE)
include Infix
