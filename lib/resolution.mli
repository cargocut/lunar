(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Describes a resolution that allows, among other things, dates to be
    truncated. Since negative resolutions produce strange results,
    they are always converted to their absolute values. *)

(** {1 Types} *)

(** Resolution for date. *)
type for_date =
  [ `day
  | `week of Weekday.t
  | `month
  | `quarter
  | `year
  ]

(** Resolution for time. *)
type for_time = [ `duration of Duration.t ]

(** The type describing a resolution. *)
type t =
  [ for_date
  | for_time
  ]

(** {1 Resolutions} *)

(** {2 Time resolution}

    Time resolution is generally difficult for humans to predict for date,
    So we assume that any duration results in a value of less than one
    day, without changing the dates. *)

(** Resolve as a second. *)
val second : [> for_time ]

(** Resolve as a fixed number of seconds. *)
val seconds : int -> [> for_time ]

(** Resolve as a minute. *)
val minute : [> for_time ]

(** Resolve as a fixed number of minutes. *)
val minutes : int -> [> for_time ]

(** Resolve as an hour. *)
val hour : [> for_time ]

(** Resolve as a fixed number of hours. *)
val hours : int -> [> for_time ]

(** Resolve using a duration. *)
val duration : Duration.t -> [> for_time ]

(** {2 Date resolution} *)

(** Resolve as a day. *)
val day : [> for_date ]

(** Resolve as a week (using monday as a week start). *)
val week : [> for_date ]

(** Allows you to set the first day of the week. *)
val week_with_start : Weekday.t -> [> for_date ]

(** Resolve as a month. *)
val month : [> for_date ]

(** Resolve a quarter. *)
val quarter : [> for_date ]

(** Resolve as a year. *)
val year : [> for_date ]
