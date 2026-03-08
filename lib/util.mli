(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Common utilities. *)

(** {1 Functions} *)

(** [is_leap_year y] returns [true] if the given year [y] is leap.*)
val is_leap_year : int -> bool

(** [lpad ?char ~size number] pad a given [number] with the given [char].*)
val lpad : ?char:char -> size:int -> int -> string

(** [mod_floor a b] modulo works using negative numbers. *)
val mod_floor : int -> int -> int

(** [only_numbers s] returns [true] if a string is only composed by
    number, [false] otherwise. (Mostly used for [from_string]
    functions) *)
val only_numbers : string -> bool

(** {1 Shared APIs} *)

module Make_equal_infix (E : Sigs.EQUATABLE) :
  Sigs.EQUATABLE_INFIX with type t = E.t

module Make_compare_infix (E : Sigs.COMPARABLE) :
  Sigs.COMPARABLE_INFIX with type t = E.t

module Make_compare_helpers (E : Sigs.COMPARABLE) :
  Sigs.COMPARABLE_HELPERS with type t = E.t
