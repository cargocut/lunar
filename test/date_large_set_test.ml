(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

let%expect_test
    "We're convinced that the calculation of the days of the week is correct :)"
  =
  let d1 = Date.from_string_exn "0000-01-01" in
  let wd = Date.day_of_week d1 in
  let d2 = Date.from_string_exn "2026-03-22" in
  let rec aux n date =
    if Date.is_later ~than:d2 date
    then
      Format.asprintf
        "Success: for %s  [comp:%s]"
        (Date.to_string date)
        (Weekday.to_short_string @@ Date.day_of_week date)
      |> print_endline
    else (
      let w = Date.day_of_week date in
      if Weekday.equal w n
      then aux (Weekday.succ n) (Date.succ date)
      else
        Format.asprintf
          "Failure:\n    for %s [exp:%s | comp:%s]"
          (Date.to_string date)
          (Weekday.to_short_string n)
          (Weekday.to_short_string w)
        |> print_endline)
  in
  aux wd d1;
  [%expect {| Success: for 2026-03-23  [comp:mon] |}]
;;
