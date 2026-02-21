(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

let is_leap_year y =
  Int.equal 0 (y mod 4)
  && ((not (Int.equal 0 (y mod 100))) || Int.equal 0 (y mod 400))
;;
