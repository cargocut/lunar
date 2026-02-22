(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

let dump_duration x = x |> Duration.to_int64 |> Int64.to_string |> print_endline
let dump_bool x = print_endline (if x then "true" else "false")

let dump_result f_r f_e = function
  | Ok x -> "ok: " ^ f_r x |> print_endline
  | Error err -> "error: " ^ f_e err |> print_endline
;;

let dump_month m = m |> Month.to_string |> print_endline

let dump_month_validation =
  dump_result Month.to_string (function
    | Month.Invalid_month_number i -> "invalid month number: " ^ string_of_int i
    | Month.Invalid_month_string s -> "invalid month string: " ^ s)
;;
