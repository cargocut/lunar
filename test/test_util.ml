(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

let dump_duration x = x |> Duration.to_int64 |> Int64.to_string |> print_endline
let dump_bool x = print_endline (if x then "true" else "false")
