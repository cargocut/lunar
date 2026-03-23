(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Describes the offset of a time zone, used to describe {i time-zone}
    datetime values. *)

(** {1 Type} *)

(**The type representing a time zone offset. *)
type t

(** {1 Building Timezone offsets}

    Since defining time zones (and their historical data) is a complex process,
    creating a time zone does not trigger any specific validation checks. *)

(** [make ~hour ~min] describes the offset [HH:MM]. *)
val make : hour:int -> min:int -> t

(** A presaved UTC Timezone. *)
val utc : t

(** {1 Conversion} *)

(** [to_duration tz] returns the offset for the given [tz]. *)
val to_duration : t -> Duration.t

(** [to_string tz] returns a string representation of the given [d]. *)
val to_string : t -> string

(** {1 Comparison} *)

(** Equality between dates. *)
val equal : t -> t -> bool

(** [compare a b] comparison between dates, following OCaml convention. *)
val compare : t -> t -> int

include Sigs.COMPARABLE_HELPERS with type t := t (** @inline *)

(** {1 Infix Operators} *)

module Infix : sig
  (** Common and useful infix operators. *)

  include Sigs.EQUATABLE_INFIX with type t := t (** @inline *)

  include Sigs.COMPARABLE_INFIX with type t := t (** @inline *)
end

include module type of Infix
