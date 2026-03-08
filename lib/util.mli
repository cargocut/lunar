(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Common utilities. *)

(** [is_leap_year y] returns [true] if the given year [y] is leap.*)
val is_leap_year : int -> bool

(** [lpad ?char ~size number] pad a given [number] with the given [char].*)
val lpad : ?char:char -> size:int -> int -> string

(** [mod_floor a b] modulo works using negative numbers. *)
val mod_floor : int -> int -> int

(** Like {!val:Stdlib.String.split_on_char} but taking a predicate instead
    of a char. *)
val split_on_chars : (char -> bool) -> string -> string list

(** [only_numbers s] returns [true] if a string is only composed by
    number, [false] otherwise. (Mostly used for [from_string]
    functions) *)
val only_numbers : string -> bool
