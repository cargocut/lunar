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

let only_numbers = function
  | "" -> false
  | s ->
    String.for_all
      (function
        | '0' .. '9' -> true
        | _ -> false)
      s
;;

module Make_equal_infix (E : Sigs.EQUATABLE) = struct
  type t = E.t

  let ( = ) = E.equal
  let ( <> ) x y = not (E.equal x y)
end

module Make_compare_helpers (E : Sigs.COMPARABLE) = struct
  type t = E.t

  let min a b = if E.compare a b < 0 then a else b
  let max a b = if E.compare a b > 0 then a else b

  let clamp ~min:a ~max:b x =
    let small = min a b
    and big = max a b in
    min big (max small x)
  ;;

  let is_earlier ~than x = E.compare x than < 0
  let is_later ~than x = E.compare x than > 0
end

module Make_compare_infix (E : Sigs.COMPARABLE) = struct
  type t = E.t

  let ( > ) x y = E.compare x y > 0
  let ( >= ) x y = E.compare x y >= 0
  let ( < ) x y = E.compare x y < 0
  let ( <= ) x y = E.compare x y <= 0
end
