(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

let is_leap_year y =
  Int.equal 0 (y mod 4)
  && ((not (Int.equal 0 (y mod 100))) || Int.equal 0 (y mod 400))
;;

let lpad ?(char = '0') ~size n =
  let pre = if n < 0 then "-" else "" in
  let str = string_of_int (abs n) in
  let len = String.length str in
  pre ^ if len >= size then str else String.make (size - len) char ^ str
;;

let mod_floor a b =
  let r = a mod b in
  if r < 0 then r + b else r
;;
