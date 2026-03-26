(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Representation of the days of a week, using an enumeration. *)

(** {1 Type} *)

(** Type describing a day of week. *)
type t =
  | Mon
  | Tue
  | Wed
  | Thu
  | Fri
  | Sat
  | Sun

(** Type listing errors that may occur when working with weekdays.*)
type error =
  | Invalid_weekday_number of int
  | Invalid_weekday_string of string

(** [all] is a list of all days Monday to Sunday. *)
val all : t list

(** {1 Operation and facts} *)

(** [from_int i] converts an integer (0-based) to weekday
    (0 = monday, 6 = sunday). *)
val from_int : int -> (t, error) result

(** [to_int wd] returns the numeric representation of a weekday (0-based)
    (0 = monday, 6 = sunday). *)
val to_int : t -> int

(** [to_string wd] returns the string representation of a weekday
    (not capitalized).*)
val to_string : t -> string

(** [to_short_string wd] returns the short string representation of a weekday
    (not capitalized), ie: ["mon"] for ["monday"]. *)
val to_short_string : t -> string

(** [from_string str] try to convert a string to a weekday. (Using string
    representation or short representation). *)
val from_string : string -> (t, error) result

(** [succ m] returns the following weekday. *)
val succ : t -> t

(** [pred m] returns the previous weekday. *)
val pred : t -> t

(** [equal a b] is equality between [a] and [b]. *)
val equal : t -> t -> bool

(** [compare a b] comparison between weekdays,
    following OCaml convention. *)
val compare : t -> t -> int

include Sigs.COMPARABLE_HELPERS with type t := t (** @inline *)

(** {1 Map and Set} *)

module Map : Stdlib.Map.S with type key = t
module Set : Stdlib.Set.S with type elt = t

(** {1 Infix operators} *)

module Infix : sig
  (** Common and useful infix operators. *)

  include Sigs.EQUATABLE_INFIX with type t := t (** @inline *)

  include Sigs.COMPARABLE_INFIX with type t := t (** @inline *)
end

include module type of Infix
