(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Helpers for using Lunar with the Unix module, including functions to
    calculate the offset of the current time zone (of the process
    running the program) and the time t. *)

(** [from_tm unix_tm] converts a Unix datetime ({!type:Unix.tm}) to a
    {!type:Lunar.Datetime.t}. *)
val from_tm : Unix.tm -> Lunar.Datetime.t

(** [utc time] returns the [UTC] zoned datetime corresponding to the given
    time. *)
val utc : float -> Lunar.Zoned_datetime.t

(** [local time] returns the local zoned datetime corresponding to the
    given time. *)
val local : float -> Lunar.Zoned_datetime.t

(** [tz time] compute the current tz-offset of the running process. *)
val tz : float -> Lunar.Timezone.t

(** [tz_now ()] returns the current timezone offset. *)
val tz_now : unit -> Lunar.Timezone.t

(** [utc_now ()] returns the current datetime zoned to [UTC]. *)
val utc_now : unit -> Lunar.Zoned_datetime.t

(** [local_now ()] returns the current datetime zoned to [tz time]. *)
val local_now : unit -> Lunar.Zoned_datetime.t
