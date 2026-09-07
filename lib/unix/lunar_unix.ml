(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

let from_tm ({ tm_sec; tm_min; tm_hour; tm_mday; tm_mon; tm_year; _ } : Unix.tm)
  =
  let at =
    ( tm_hour
    , tm_min
    , (* NOTE: Seconds can be [60] because of leap seconds. so we let's the
         user dealing with that using operation Duration. *)
      Int.min tm_sec 59 )
  and year = tm_year + 1900
  and month = tm_mon + 1
  and day = tm_mday in
  (* NOTE: Should never fail. *)
  Lunar.Datetime.make_exn' ~at ~year ~month ~day ()
;;

let utc time = time |> Unix.gmtime |> from_tm |> Lunar.Zoned_datetime.from_utc

let tz_local time =
  let utc = time |> Unix.gmtime |> from_tm in
  let local = time |> Unix.localtime |> from_tm in
  Lunar.Timezone.compute_from ~utc ~local, local
;;

let local time =
  let tz, dt = tz_local time in
  Lunar.Zoned_datetime.from_local_datetime ~tz dt
;;

let tz time = fst (tz_local time)

let tz_now () =
  let time = Unix.time () in
  tz time
;;

let utc_now () =
  let time = Unix.time () in
  utc time
;;

let local_now () =
  let time = Unix.time () in
  local time
;;
