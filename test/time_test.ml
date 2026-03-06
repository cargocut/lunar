(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "make" =
  Time.make ~hour:12 ~min:23 ~sec:58 () |> dump_time_validation;
  [%expect {| ok: 12:23:58 |}]
;;

(* Standard valid times *)
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

(* Edge boundaries *)
let%expect_test "make midnight" =
  Time.make ~hour:0 ~min:0 ~sec:0 () |> dump_time_validation;
  [%expect {| ok: 00:00:00 |}]
;;

let%expect_test "make last second of day" =
  Time.make ~hour:23 ~min:59 ~sec:59 () |> dump_time_validation;
  [%expect {| ok: 23:59:59 |}]
;;

(* Invalid hours *)
let%expect_test "make invalid negative hour" =
  Time.make ~hour:(-1) ~min:0 ~sec:0 () |> dump_time_validation;
  [%expect {| error: invalid hour: -1 |}]
;;

let%expect_test "make invalid hour overflow" =
  Time.make ~hour:24 ~min:0 ~sec:0 () |> dump_time_validation;
  [%expect {| error: invalid hour: 24 |}]
;;

(* Invalid minutes *)
let%expect_test "make invalid negative minute" =
  Time.make ~hour:12 ~min:(-1) ~sec:0 () |> dump_time_validation;
  [%expect {| error: invalid min: -1 |}]
;;

let%expect_test "make invalid minute overflow" =
  Time.make ~hour:12 ~min:60 ~sec:0 () |> dump_time_validation;
  [%expect {| error: invalid min: 60 |}]
;;

(* Invalid seconds *)
let%expect_test "make invalid negative second" =
  Time.make ~hour:12 ~min:0 ~sec:(-1) () |> dump_time_validation;
  [%expect {| error: invalid sec: -1 |}]
;;

let%expect_test "make invalid second overflow" =
  Time.make ~hour:12 ~min:0 ~sec:60 () |> dump_time_validation;
  [%expect {| error: invalid sec: 60 |}]
;;
