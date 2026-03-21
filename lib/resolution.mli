(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Describes a resolution that allows, among other things, dates to be
    truncated. Since negative resolutions produce strange results,
    they are always converted to their absolute values. *)

(** {1 Types} *)

(** The type describing a resolution. *)
type t = private
  | Day
  | Week of Weekday.t
  | Month
  | Quarter
  | Year
  | Duration of Duration.t

(** {1 Resolutions} *)

(** {2 Time resolution}

    Time resolution is generally difficult for humans to predict, so it
    is recommended to use this type of measurement for time-related data. *)

(** Resolve as a second. *)
val second : t

(** Resolve as a fixed number of seconds. *)
val seconds : int -> t

(** Resolve as a minute. *)
val minute : t

(** Resolve as a fixed number of minutes. *)
val minutes : int -> t

(** Resolve as an hour. *)
val hour : t

(** Resolve as a fixed number of hours. *)
val hours : int -> t

(** Resolve using a duration. *)
val duration : Duration.t -> t

(** {2 Date resolution} *)

(** Resolve as a day. *)
val day : t

(** Resolve as a week (using {!val:Weekday.Mon} as a week start). *)
val week : t

(** Allows you to set the first day of the week. *)
val week_with_start : Weekday.t -> t

(** Resolve as a month. *)
val month : t

(** Resolve a quarter. *)
val quarter : t

(** Resolve as a year. *)
val year : t
