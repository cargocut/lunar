(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t = Duration.t

(* MAYBE : *)

let utc = Duration.zero
let make ~hour:h ~min:m = Duration.(from_hours h + from_minutes m)
let equal = Duration.equal
let compare = Duration.compare
let to_duration x = x

let to_string x =
  let d = to_duration x in
  if Duration.equal d Duration.zero
  then "Z"
  else (
    let sign = if Duration.(zero > d) then "-" else "+" in
    let h, m, _ = Duration.hms d in
    sign ^ Util.lpad ~size:2 (Int.abs h) ^ ":" ^ Util.lpad ~size:2 (Int.abs m))
;;

module CE = struct
  type nonrec t = t

  let equal = equal
  let compare = compare
end

module Infix = struct
  include Util.Make_equal_infix (CE)
  include Util.Make_compare_infix (CE)
end

include Util.Make_compare_helpers (CE)
module Map = Stdlib.Map.Make (CE)
module Set = Stdlib.Set.Make (CE)
include Infix
