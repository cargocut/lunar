(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t =
  | BCE
  | CE

let to_int = function
  | BCE -> 0
  | CE -> 1
;;

let equal a b = Int.equal (to_int a) (to_int b)
let compare a b = Int.compare (to_int a) (to_int b)
let from_year y = if y <= 0 then BCE else CE

let to_string = function
  | CE -> "ce"
  | BCE -> "bce"
;;

let year y =
  match from_year y with
  | BCE -> 1 - y
  | CE -> y
;;

let century y =
  let y = year y in
  ((y - 1) / 100) + 1
;;

let year_of_century y =
  let y = year y in
  ((y - 1) mod 100) + 1
;;

module CE = struct
  type nonrec t = t

  let equal = equal
  let compare = compare
end

include (
  Util.Make_compare_helpers (CE) : Sigs.COMPARABLE_HELPERS with type t := t)

module Infix = struct
  include (Util.Make_equal_infix (CE) : Sigs.EQUATABLE_INFIX with type t := t)

  include (
    Util.Make_compare_infix (CE) : Sigs.COMPARABLE_INFIX with type t := t)
end

include Infix
