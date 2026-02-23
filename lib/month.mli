(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Representation of the months of the year, using an enumeration. *)

(** {1 Type} *)

(** Type describing a month of the year. *)
type t =
  | Jan
  | Feb
  | Mar
  | Apr
  | May
  | Jun
  | Jul
  | Aug
  | Sep
  | Oct
  | Nov
  | Dec

(** Type listing errors that may occur when working with months. *)
type error =
  | Invalid_month_number of int
  | Invalid_month_string of string

(** [all] is a list of all month from January to December. *)
val all : t list

(** {1 Operation and facts} *)

(** [from_int i] converts an integer (1-based) to months. *)
val from_int : int -> (t, error) result

(** [to_int m] returns the numeric representation of a month (1-based).*)
val to_int : t -> int

(** [to_string m] returns the string representation of a month (not
    capitalized).*)
val to_string : t -> string

(** [to_short_string m] returns the short string representation of a month
    (not capitalized), ie: ["jan"] for ["january"]. *)
val to_short_string : t -> string

(** [from_string str] try to convert a string to a month. (Using string
    representation or short representation). *)
val from_string : string -> (t, error) result

(** [days_in ~year m] Returns the number of days in month [m]
    for a given year [year]. *)
val days_in : year:int -> t -> int

(** [succ m] returns the following month. *)
val succ : t -> t

(** [pred m] returns the previous month. *)
val pred : t -> t

(** [equal a b] is equality between [a] and [b]. *)
val equal : t -> t -> bool

(** [compare a b] comparison between month, following OCaml convention. *)
val compare : t -> t -> int

(** {1 Infix operators} *)

module Infix : sig
  (** Common and useful infix operators. *)

  (** [m1 = m2] is [equal m1 m2]. *)
  val ( = ) : t -> t -> bool

  (** [m1 <> m2] is [not (equal m1 m2)]. *)
  val ( <> ) : t -> t -> bool

  (** [m1 > m2] returns [true] if [m1] is greater than [m2]. *)
  val ( > ) : t -> t -> bool

  (** [m1 >= m2] returns [true] if [m1] is greater or equal to [m2]. *)
  val ( >= ) : t -> t -> bool

  (** [m1 < m2] returns [true] if [m2] is greater than [m1]. *)
  val ( < ) : t -> t -> bool

  (** [m1 <= m2] returns [true] if [m2] is greater or equal to [m1]. *)
  val ( <= ) : t -> t -> bool
end
