(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

val dump_duration : Duration.t -> unit
val dump_bool : bool -> unit
val dump_result : ('a -> string) -> ('b -> string) -> ('a, 'b) result -> unit
val dump_month : Month.t -> unit
val dump_month_validation : (Month.t, Month.error) result -> unit
