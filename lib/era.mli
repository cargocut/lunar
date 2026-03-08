(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Era identifies the historical period relative to year numbering. In
    the Gregorian/ISO calendar there are two eras: [BCE] and [CE]. *)

(** {1 Types} *)

(** The type describing an era. *)
type t =
  | BCE (** Before Common Era *)
  | CE (** Common Era *)

(** {1 Computing Era} *)

(** [from_year y] compute the era for the given year [y]. *)
val from_year : int -> t

(** {1 Relativizing from era} *)

(** [year y] relativize the given year [y] from the associated era. It
    counts years within the era *)
val year : int -> int

(** [century year] returns the century inside the associated era. *)
val century : int -> int

(** [year_of_century year] returns the year position within the century
    inside the associated era. *)
val year_of_century : int -> int

(** {1 Conversion} *)

(** [to_string era] returns a string representation of the given [era]. *)
val to_string : t -> string

(** [to_int era] converts an era into a string [1] for [CE] and 0 for
    [BCE]. *)
val to_int : t -> int

(** {1 Comparison} *)

(** Equality between eras. *)
val equal : t -> t -> bool

(** [compare a b] comparison between eras, following OCaml convention. *)
val compare : t -> t -> int

include Sigs.COMPARABLE_HELPERS with type t := t (** @inline *)

(** {1 Infix operators} *)

module Infix : sig
  (** Common and useful infix operators. *)

  include Sigs.EQUATABLE_INFIX with type t := t (** @inline *)

  include Sigs.COMPARABLE_INFIX with type t := t (** @inline *)
end

include module type of Infix
