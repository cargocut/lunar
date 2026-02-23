(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** [Datetime] describes the main module of {b Lunar} (or at least, the
    lowest level) that allows both date and time triplets to be
    described.

    A datetime is said to be {i naive} because it does not support
    time zones.  It is the user's responsibility to add the missing
    offset using a {!type:Duration.t}. *)

(** {1 Types} *)

(** The type describing a datetime. *)
type t

(** Type listing errors that may occur when working with datetime. *)
type error =
  | Invalid_year of int
  | Invalid_month of Month.error
  | Invalid_day of
      { day_max : int
      ; day : int
      }
  | Invalid_hour of int
  | Invalid_min of int
  | Invalid_sec of int

(** And exception used for unsafe function. *)
exception Invalid_date of error

(** {1 Building datetime} *)

(** [make ?at ~year ~month ~day ()] create and validate a datetime. *)
val make
  :  ?at:int * int * int
  -> year:int
  -> month:Month.t
  -> day:int
  -> unit
  -> (t, error) result

(** [make' ?at ~year ~month ~day ()] create and validate a datetime, see
    {!val:make}. Take an integer rather than a {!val:Month.t}. *)
val make'
  :  ?at:int * int * int
  -> year:int
  -> month:int
  -> day:int
  -> unit
  -> (t, error) result

(** [make_exn ?at ~year ~month ~day ()] create and validate a datetime
    like {!val:make} but raise [Invalid_date] if the validation
    doesn't succeed. *)
val make_exn
  :  ?at:int * int * int
  -> year:int
  -> month:Month.t
  -> day:int
  -> unit
  -> t

(** [make_exn' ?at ~year ~month ~day ()] create and validate a datetime,
    like {!val:make'} but raise [Invalid_date] if the validation doesn't
    succeed. *)
val make_exn'
  :  ?at:int * int * int
  -> year:int
  -> month:int
  -> day:int
  -> unit
  -> t

(** [from_duration d] converts a duration to a datetime.
    [0] is the 1970-01-01 00:00:00. *)
val from_duration : Duration.t -> t

(** [epoch] is the datetime at 1970-01-01 00:00:00. *)
val epoch : t

(** {1 Accessors}

    Information and facts about calculated datetime. *)

(** [year dt] returns the year from a datetime. *)
val year : t -> int

(** [on_leap_year dt] returns [true] if [year dt] is a leap year, [false]
    otherwise.*)
val on_leap_year : t -> bool

(** [month dt] returns the month from a datetime. *)
val month : t -> Month.t

(** [day_of_month dt] returns the day of month from a datetime. *)
val day_of_month : t -> int

(** [day_of_week dt] returns the day of week from a datetime. *)
val day_of_week : t -> Weekday.t

(** [day_of_year dt] returns the day of year from a datetime. *)
val day_of_year : t -> int

(** [week_of_year dt] returns the pair [year] and [week number] for a
    given datetime [dt].

    The ISO 8601 standard is used where Monday is the first
    day of the week. The year is carried over if a day belongs
    to a week in the previous year.

    {b see:} {{:https://en.wikipedia.org/wiki/ISO_8601} ISO 8601}. *)
val week_of_year : t -> int * int

(** [hour dt] returns the hour from a datetime. *)
val hour : t -> int

(** [minute dt] returns the minute from a datetime. *)
val minute : t -> int

(** [second dt] returns the second from a datetime. *)
val second : t -> int

(** {1 Conversion} *)

(** [to_duration dt] returns a duration since {!val:epoch} for the given
    datetime [dt].*)
val to_duration : t -> Duration.t

(** [to_string dt] returns a string representation of the given [dt]. *)
val to_string : t -> string

(** {1 Operation on dates} *)

(** [add datetime duration] compute a new date adding [duration] to the
    given [datetime]. *)
val add : t -> Duration.t -> t

(** [sub datetime duration] compute a new date substracting [duration] to the
    given [datetime]. *)
val sub : t -> Duration.t -> t

(** {1 Infix Operators} *)

module Infix : sig
  (** Common and useful infix operators. *)

  (** [dt + dur] is {!val:add} *)
  val ( + ) : t -> Duration.t -> t

  (** [dt - dur] is {!val:sub} *)
  val ( - ) : t -> Duration.t -> t
end

include module type of Infix
