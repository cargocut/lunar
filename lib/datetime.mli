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

(** {1 Building datetime} *)

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
