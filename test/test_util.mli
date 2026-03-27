(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

val dump_duration : Duration.t -> unit
val dump_bool : bool -> unit
val dump_result : ('a -> string) -> ('b -> string) -> ('a, 'b) result -> unit
val dump_tz : Timezone.t -> unit
val dump_month : Month.t -> unit
val dump_month_validation : (Month.t, Month.error) result -> unit
val dump_weekday : Weekday.t -> unit
val dump_weekday_validation : (Weekday.t, Weekday.error) result -> unit
val dump_date : Date.t -> unit
val dump_time : Time.t -> unit
val dump_datetime : Datetime.t -> unit
val dump_zoned_datetime : Zoned_datetime.t -> unit
val dump_zoned_local : Zoned_datetime.t -> unit
val dump_date_validation : (Date.t, Date.error) result -> unit
val dump_time_validation : (Time.t, Time.error) result -> unit
val dump_datetime_validation : (Datetime.t, Datetime.error) result -> unit
val dump_date_iso_week_of_year : Date.t -> unit
val dump_datetime_iso_week_of_year : Datetime.t -> unit
val dump_dhms : Duration.t -> unit
val dump_wdhms : Duration.t -> unit
val dump_hms : Duration.t -> unit
val dump_era : Era.t -> unit
val dump_date_error : Date.error -> unit

val dump_range
  :  ('a -> string)
  -> (module Sigs.RANGE with type elt = 'a and type t = 'b)
  -> 'b
  -> unit
