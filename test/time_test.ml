(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "make" =
  Time.make ~hour:12 ~min:23 ~sec:58 () |> dump_time_validation;
  [%expect {| ok: 12:23:58 |}]
;;

let%expect_test "make valid morning" =
  Time.make ~hour:6 ~min:30 ~sec:15 () |> dump_time_validation;
  [%expect {| ok: 06:30:15 |}]
;;

let%expect_test "make valid noon" =
  Time.make ~hour:12 ~min:0 ~sec:0 () |> dump_time_validation;
  [%expect {| ok: 12:00:00 |}]
;;

let%expect_test "make valid evening" =
  Time.make ~hour:21 ~min:45 ~sec:59 () |> dump_time_validation;
  [%expect {| ok: 21:45:59 |}]
;;

let%expect_test "make midnight" =
  Time.make ~hour:0 ~min:0 ~sec:0 () |> dump_time_validation;
  [%expect {| ok: 00:00:00 |}]
;;

let%expect_test "make last second of day" =
  Time.make ~hour:23 ~min:59 ~sec:59 () |> dump_time_validation;
  [%expect {| ok: 23:59:59 |}]
;;

let%expect_test "make invalid negative hour" =
  Time.make ~hour:(-1) ~min:0 ~sec:0 () |> dump_time_validation;
  [%expect {| error: invalid hour: -1 |}]
;;

let%expect_test "make invalid hour overflow" =
  Time.make ~hour:24 ~min:0 ~sec:0 () |> dump_time_validation;
  [%expect {| error: invalid hour: 24 |}]
;;

let%expect_test "make invalid negative minute" =
  Time.make ~hour:12 ~min:(-1) ~sec:0 () |> dump_time_validation;
  [%expect {| error: invalid min: -1 |}]
;;

let%expect_test "make invalid minute overflow" =
  Time.make ~hour:12 ~min:60 ~sec:0 () |> dump_time_validation;
  [%expect {| error: invalid min: 60 |}]
;;

let%expect_test "make invalid negative second" =
  Time.make ~hour:12 ~min:0 ~sec:(-1) () |> dump_time_validation;
  [%expect {| error: invalid sec: -1 |}]
;;

let%expect_test "make invalid second overflow" =
  Time.make ~hour:12 ~min:0 ~sec:60 () |> dump_time_validation;
  [%expect {| error: invalid sec: 60 |}]
;;

let%expect_test "from_duration zero" =
  let d = Duration.from_days 0 in
  Time.from_duration d |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "from_duration positive within day" =
  let d = Duration.(from_hours 5 + from_minutes 30 + from_seconds 15) in
  Time.from_duration d |> dump_time;
  [%expect {| 05:30:15 |}]
;;

let%expect_test "from_duration positive > 1 day" =
  let d = Duration.(from_days 1 + from_hours 3 + from_minutes 15) in
  Time.from_duration d |> dump_time;
  [%expect {| 03:15:00 |}]
;;

let%expect_test "from_duration exact multiple of day" =
  let d = Duration.(from_days 3) in
  Time.from_duration d |> dump_time;
  [%expect {| 00:00:00 |}]
;;

let%expect_test "from_duration negative within day" =
  let d = Duration.(from_hours (-2) - from_minutes 30) in
  Time.from_duration d |> dump_time;
  [%expect {| 21:30:00 |}]
;;

let%expect_test "from_duration negative > 1 day" =
  let d = Duration.(from_days (-2) + from_hours (-5)) in
  Time.from_duration d |> dump_time;
  [%expect {| 19:00:00 |}]
;;

let%expect_test "add within day" =
  let t = Time.make_exn ~hour:10 ~min:15 ~sec:30 () in
  Time.add Duration.(from_hours 2 + from_minutes 20) t |> dump_time;
  [%expect {| 12:35:30 |}]
;;

let%expect_test "add across midnight" =
  let t = Time.make_exn ~hour:22 ~min:45 ~sec:0 () in
  Time.add Duration.(from_hours 3 + from_minutes 30) t |> dump_time;
  [%expect {| 02:15:00 |}]
;;

let%expect_test "sub within day" =
  let t = Time.make_exn ~hour:10 ~min:15 ~sec:30 () in
  Time.sub Duration.(from_hours 2 + from_minutes 20) t |> dump_time;
  [%expect {| 07:55:30 |}]
;;

let%expect_test "sub before midnight" =
  let t = Time.make_exn ~hour:1 ~min:30 ~sec:0 () in
  Time.sub Duration.(from_hours 3 + from_minutes 45) t |> dump_time;
  [%expect {| 21:45:00 |}]
;;

let%expect_test "add then sub identity" =
  let t = Time.make_exn ~hour:5 ~min:0 ~sec:0 () in
  let t' =
    Time.add Duration.(from_hours 7 + from_minutes 30) t
    |> Time.sub Duration.(from_hours 7 + from_minutes 30)
  in
  t' |> dump_time;
  [%expect {| 05:00:00 |}]
;;

let%expect_test "sub then add identity" =
  let t = Time.make_exn ~hour:23 ~min:45 ~sec:0 () in
  let t' =
    Time.sub Duration.(from_hours 2 + from_minutes 50) t
    |> Time.add Duration.(from_hours 2 + from_minutes 50)
  in
  t' |> dump_time;
  [%expect {| 23:45:00 |}]
;;

let%expect_test "add large positive duration" =
  let t = Time.make_exn ~hour:10 ~min:0 ~sec:0 () in
  Time.add
    Duration.(from_days 3 + from_hours 5 + from_minutes 30 + from_seconds 15)
    t
  |> dump_time;
  [%expect {| 15:30:15 |}]
;;

let%expect_test "add very large positive duration" =
  let t = Time.make_exn ~hour:1 ~min:1 ~sec:1 () in
  Time.add
    Duration.(
      from_days 1234 + from_hours 23 + from_minutes 59 + from_seconds 59)
    t
  |> dump_time;
  [%expect {| 01:01:00 |}]
;;

let%expect_test "sub large negative duration" =
  let t = Time.make_exn ~hour:15 ~min:45 ~sec:30 () in
  Time.sub
    Duration.(from_days 2 + from_hours 16 + from_minutes 50 + from_seconds 45)
    t
  |> dump_time;
  [%expect {| 22:54:45 |}]
;;

let%expect_test "sub very large negative duration" =
  let t = Time.make_exn ~hour:0 ~min:0 ~sec:1 () in
  Time.sub
    Duration.(from_days 9876 + from_hours 5 + from_minutes 5 + from_seconds 2)
    t
  |> dump_time;
  [%expect {| 18:54:59 |}]
;;

let%expect_test "add negative duration (backwards wrap)" =
  let t = Time.make_exn ~hour:3 ~min:30 ~sec:0 () in
  Time.add Duration.(from_hours (-5) - from_minutes 45) t |> dump_time;
  [%expect {| 21:45:00 |}]
;;

let%expect_test "sub negative duration (forward wrap)" =
  let t = Time.make_exn ~hour:22 ~min:15 ~sec:0 () in
  Time.sub Duration.(from_hours (-4) - from_minutes 30) t |> dump_time;
  [%expect {| 02:45:00 |}]
;;

let%expect_test "add multiple full days" =
  let t = Time.make_exn ~hour:12 ~min:0 ~sec:0 () in
  Time.add Duration.(from_days 10) t |> dump_time;
  [%expect {| 12:00:00 |}]
;;

let%expect_test "sub multiple full days" =
  let t = Time.make_exn ~hour:7 ~min:30 ~sec:0 () in
  Time.sub Duration.(from_days 20) t |> dump_time;
  [%expect {| 07:30:00 |}]
;;

let%expect_test "add then sub large duration identity" =
  let t = Time.make_exn ~hour:5 ~min:15 ~sec:30 () in
  let dur =
    Duration.(
      from_days 1000 + from_hours 50 + from_minutes 120 + from_seconds 3661)
  in
  Time.add dur t |> Time.sub dur |> dump_time;
  [%expect {| 05:15:30 |}]
;;

let%expect_test "sub then add large duration identity" =
  let t = Time.make_exn ~hour:23 ~min:59 ~sec:59 () in
  let dur =
    Duration.(
      from_days 500 + from_hours 72 + from_minutes 180 + from_seconds 3662)
  in
  Time.sub dur t |> Time.add dur |> dump_time;
  [%expect {| 23:59:59 |}]
;;
