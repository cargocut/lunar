(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** {b Lunar} is a minimal date and time library, based primarily on a
    {{:https://en.wikipedia.org/wiki/Proleptic_Gregorian_calendar}
    proleptic Gregorian calendar}, that focuses on simple
    operations. Its development is {b needs-driven}, meaning that the
    library is open to contributions that add use cases not initially
    considered. *)

(** In particular, the library allows you to work with {!module:Time}
    objects (a specific hour of the day), {!module:Date} objects (a
    specific day of the year), {!module:Datetime} objects (a
    combination of a Time and a Date), and {!module:Zoned_datetime}
    objects (a Datetime associated with a {!module:Timezone}). *)

(** The code (and the algorithms used) is designed to be as simple as
    possible and easy to extend ({b without any particular concern for
    performance}... sorry). *)

(** {1 Components}

    Describes the low-level components used as utilities for describing
    dates. *)

module Era = Era
module Month = Month
module Weekday = Weekday

(** {1 Absolute elements}

    All objects that are not associated with a time zone. *)

module Time = Time
module Date = Date
module Datetime = Datetime

(** {1 Relative elements}

    Objects associated with a time zone. *)

module Timezone = Timezone
module Zoned_datetime = Zoned_datetime

(** {1 Resolution and Duration}

    The resolution allows you to truncate dates (and more).
    And durations are a low-level representation of a number of seconds. *)

module Resolution = Resolution
module Duration = Duration

(** {1 Ranges}

    Provides a generic way to describe orderable and iterable ranges. *)

module Range = Range

(** {1 Reusable signatures} *)

module Sigs = Sigs
