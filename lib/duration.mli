(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Describes a duration in seconds (Lunar is essentially a Calendar
    library, so greater precision does not seem particularly
    useful). This is the most primitive type in the library, and the
    API exposes minimal set of arithmetic operations.*)

(** {1 Type}

    A duration is an abstract representation of {!type:Int64.t}. *)

(** A type describing a duration. *)
type t

(** {1 Creating durations} *)

(** [zero] is zero second. *)
val zero : t

(** [one] is one second. *)
val one : t

(** [from_int64 i] converts int64 to duration (without applying
    multiplication, so expressed in seconds).*)
val from_int64 : int64 -> t

(** [from_seconds i] converts the given int [i] into a duration. *)
val from_seconds : int -> t

(** [from_minutes i] converts the given int [i] into a duration.
    [from_minutes 1 = from_seconds 60] *)
val from_minutes : int -> t

(** [from_hours i] converts the given int [i] into a duration.
    [from_hours 1 = from_seconds 3600] *)
val from_hours : int -> t

(** [from_days i] converts the given int [i] into a duration.
    [from_days 1 = from_seconds 86400] *)
val from_days : int -> t

(** [from_datetime ~year ~month ~day ~hour ~min ~sec] builds a duration
    based on a date. Duration is the number of seconds that have
    elapsed since January 1, 1970, at 00:00:00.

    {b Warning}: The function is generally lax, performing no checks
    on input arguments, and is mainly used internally.*)
val from_datetime
  :  year:int
  -> month:int
  -> day:int
  -> hour:int
  -> min:int
  -> sec:int
  -> t

(** {1 Conversion} *)

(** [to_datetime d] returns an approximation of the date calculated based
    on the number of seconds elapsed since January 1, 1970, at
    00:00:00.
    The return value is in the form of the following tuple:
    [year * month * day_of_month * hour * minute * second]. *)
val to_datetime : t -> int * int * int * int * int * int

(** [to_int64 d] returns the int64 representation of a duration.*)
val to_int64 : t -> int64

(** [wdhms duration] returns the number of weeks, days, hours, minutes, and
    seconds that describe the duration.*)
val wdhms : t -> int * int * int * int * int

(** [dhms duration] returns the number of days, hours, minutes, and
    seconds that describe the duration.*)
val dhms : t -> int * int * int * int

(** [hms duration] returns the number of hours, minutes, and
    seconds that describe the duration.*)
val hms : t -> int * int * int

(** [to_days duration] get a day approx for a duration. *)
val to_days : t -> int

(** [weekday d] returns the {!type:Weekday.t} for the given duration since
    epoch.*)
val weekday : t -> Weekday.t

(** {1 Comparison} *)

(** [compare a b] comparison between duration, following OCaml convention. *)
val compare : t -> t -> int

(** [equal a b] equality between duration. *)
val equal : t -> t -> bool

include Sigs.COMPARABLE_HELPERS with type t := t (** @inline *)

(** {1 Arithmetic operation} *)

(**  [abs d] returns the absolute value of [d]. *)
val abs : t -> t

(** [add a b] is the addition of [a] and [b]. *)
val add : t -> t -> t

(** [sub a b] is the substraction of [a] and [b]. *)
val sub : t -> t -> t

(** [mul d i] multiplies a duration by an integer. *)
val mul : t -> int -> t

(** [neg x] is [-x]. *)
val neg : t -> t

(** [succ d] adds 1 second to [d]. *)
val succ : t -> t

(** [pred d] remove 1 second to [d]. *)
val pred : t -> t

(** {1 Infix Operators} *)

module Infix : sig
  (** Common and useful infix operators. *)

  (** [d1 + d2] is [add d1 d2], see {!val:add}. *)
  val ( + ) : t -> t -> t

  (** [d1 - d2] is [sub d1 d2], see {!val:sub}. *)
  val ( - ) : t -> t -> t

  (** [d * i] is [mul d i], see {!val:mul}. *)
  val ( * ) : t -> int -> t

  include Sigs.EQUATABLE_INFIX with type t := t (** @inline *)

  include Sigs.COMPARABLE_INFIX with type t := t (** @inline *)
end

include module type of Infix
