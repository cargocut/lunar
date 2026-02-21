(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Representation of the months of the year, using an enumeration. *)

(** {1 Type} *)

(** Type describing a month of the year. *)
type t =
  | Jan
  | Feb
  | Mar
  | Apr
  | May
  | Jun
  | Jul
  | Aug
  | Sep
  | Oct
  | Nov
  | Dec

(** Type listing errors that may occur when working with months.*)
type error = Invalid_month_number of int

(** {1 Operation and facts} *)

(** [from_int i] converts an integer (1-based) to months. *)
val from_int : int -> (t, error) result

(** [to_int m] returns the numeric representation of a month (1-based).*)
val to_int : t -> int

(** [days_in ~year m] Returns the number of days in month [m]
    for a given year [year]. *)
val days_in : year:int -> t -> int

(** [succ m] returns the following month. *)
val succ : t -> t

(** [pred m] returns the previous month. *)
val pred : t -> t
