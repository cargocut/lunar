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
