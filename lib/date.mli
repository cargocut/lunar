(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Represents a date (year, month, day). *)

(** {1 Types} *)

(** The type describing a Date. *)
type t

(** Type listing errors that may occur when working with date. *)
type error =
  | Invalid_year of int
  | Invalid_month of Month.error
  | Invalid_day of
      { day_max : int
      ; day : int
      }

(** And exception used for unsafe function. *)
exception Invalid_date of error

(** {1 Building date} *)

(** [make ~year ~month ~day ()] create and validate a date. *)
val make : year:int -> month:Month.t -> day:int -> unit -> (t, error) result

(** [make' ?at ~year ~month ~day ()] create and validate a datetime, see
    {!val:make}. Take an integer rather than a {!val:Month.t}. *)
val make' : year:int -> month:int -> day:int -> unit -> (t, error) result

(** [make_exn ?at ~year ~month ~day ()] create and validate a date
    like {!val:make} but raise [Invalid_date] if the validation
    doesn't succeed. *)
val make_exn : year:int -> month:Month.t -> day:int -> unit -> t

(** [make_exn' ~year ~month ~day ()] create and validate a date,
    like {!val:make'} but raise [Invalid_date] if the validation doesn't
    succeed. *)
val make_exn' : year:int -> month:int -> day:int -> unit -> t

(** [from_duration d] converts a duration to a date.
    [0] is the 1970-01-01. *)
val from_duration : Duration.t -> t

(** [epoch] is the date at 1970-01-01. *)
val epoch : t

(** {1 Accessors}

    Information and facts about Date. *)

(** [year dt] returns the year from a date. *)
val year : t -> int

(** [on_leap_year dt] returns [true] if [year dt] is a leap year, [false]
    otherwise.*)
val on_leap_year : t -> bool

(** [month dt] returns the month from a date. *)
val month : t -> Month.t

(** [day_of_month dt] returns the day of month from a date. *)
val day_of_month : t -> int

(** [day_of_week dt] returns the day of week from a date. *)
val day_of_week : t -> Weekday.t

(** [day_of_year dt] returns the day of year from a date. *)
val day_of_year : t -> int

(** [week_of_year dt] returns the pair [year] and [week number] for a
    given datetime [dt].

    The ISO 8601 standard is used where Monday is the first
    day of the week. The year is carried over if a day belongs
    to a week in the previous year.

    {b see:} {{:https://en.wikipedia.org/wiki/ISO_8601} ISO 8601}. *)
val week_of_year : t -> int * int

(** {1 Conversion} *)

(** [to_duration dt] returns a duration since {!val:epoch} for the given
    datetime [dt].*)
val to_duration : t -> Duration.t

(** [to_string dt] returns a string representation of the given [dt]. *)
val to_string : t -> string

(** {1 Operation on dates} *)

(** [add date duration] compute a new date adding [duration] to the given
    [date]. {b warning}: Since the duration does not always correspond
    to a full day, the results are truncated. *)
val add : t -> Duration.t -> t

(** [sub datetime duration] compute a new date substracting [duration] to
    the given [datetime]. {b warning}: Since the duration does not
    always correspond to a full day, the results are truncated. *)
val sub : t -> Duration.t -> t

(** [diff dt1 dt2] returns the difference (in {!type:Duration.t}) between
    [d1] and [d2]. *)
val diff : t -> t -> Duration.t

(** {2 On duration}

    Arithmetic operations, such as {!val:add} and {!val:sub}, rely on
    conversions to {!type:Duration.t}, which means, for example, that in the
    expression: [Infix.(date + d1 + d2 + d3)], [date] is
    converted to duration, added, converted back to date, added
    again, and so on.

    For simply adding a single value, this is fine, but when you want
    to build more complex operations, this back-and-forth is a bit
    tedious. {!val:as_duration} allows you to avoid these trips back
    and forth. *)

(** [as_duration f d] Converts the given date [d] to a duration,
    applies the function [f] to this duration, and returns the result
    as a date. Useful for performing multiple operations on a
    single date. *)
val as_duration : (Duration.t -> Duration.t) -> t -> t

(** {1 Comparison} *)

(* Equality between dates. *)
val equal : t -> t -> bool

(** [compare a b] comparison between dates, following OCaml convention. *)
val compare : t -> t -> int

(** {1 Infix Operators} *)

module Infix : sig
  (** Common and useful infix operators. *)

  (** [d + dur] is {!val:add} *)
  val ( + ) : t -> Duration.t -> t

  (** [d - dur] is {!val:sub} *)
  val ( - ) : t -> Duration.t -> t

  (** [d1 = d2] is [equal d1 d2]. *)
  val ( = ) : t -> t -> bool

  (** [d1 <> d2] is [not (equal d1 d2)]. *)
  val ( <> ) : t -> t -> bool

  (** [d1 > d2] returns [true] if [d1] is greater than [d2]. *)
  val ( > ) : t -> t -> bool

  (** [d1 >= d2] returns [true] if [d1] is greater or equal to [d2]. *)
  val ( >= ) : t -> t -> bool

  (** [d1 < d2] returns [true] if [d2] is greater than [d1]. *)
  val ( < ) : t -> t -> bool

  (** [d1 <= d2] returns [true] if [d2] is greater or equal to [d1]. *)
  val ( <= ) : t -> t -> bool
end

include module type of Infix
