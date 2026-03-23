(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "UTC" =
  let open Timezone in
  make ~hour:0 ~min:0 |> dump_tz;
  [%expect {| Z |}]
;;

let%expect_test "French Winter, Germany (CET)" =
  let open Timezone in
  make ~hour:1 ~min:0 |> dump_tz;
  [%expect {| +01:00 |}]
;;

let%expect_test "French Summer (CEST)" =
  let open Timezone in
  make ~hour:2 ~min:0 |> dump_tz;
  [%expect {| +02:00 |}]
;;

let%expect_test "Bolivia" =
  let open Timezone in
  make ~hour:(-4) ~min:0 |> dump_tz;
  [%expect {| -04:00 |}]
;;

let%expect_test "India" =
  let open Timezone in
  make ~hour:5 ~min:30 |> dump_tz;
  [%expect {| +05:30 |}]
;;

let%expect_test "Nepal" =
  let open Timezone in
  make ~hour:5 ~min:45 |> dump_tz;
  [%expect {| +05:45 |}]
;;

let%expect_test "Newfoundland" =
  let open Timezone in
  make ~hour:(-3) ~min:30 |> dump_tz;
  [%expect {| -03:30 |}]
;;
