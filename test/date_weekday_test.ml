(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "weekday" =
  let date = Date.epoch in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| thursday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:2026 ~month:Feb ~day:23 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| monday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:1969 ~month:Dec ~day:31 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| wednesday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:1970 ~month:Jan ~day:4 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| sunday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:2000 ~month:Feb ~day:29 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| tuesday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:1900 ~month:Feb ~day:28 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| wednesday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:1900 ~month:Mar ~day:1 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| thursday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:2024 ~month:Feb ~day:29 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| thursday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:1600 ~month:Jan ~day:1 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| saturday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:2000 ~month:Jan ~day:1 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| saturday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:2400 ~month:Jan ~day:1 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| saturday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:1582 ~month:Oct ~day:15 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| friday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:0 ~month:Jan ~day:1 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| saturday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:2023 ~month:Dec ~day:31 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| sunday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:2024 ~month:Jan ~day:1 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| monday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:1969 ~month:Jul ~day:20 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| sunday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:2001 ~month:Sep ~day:11 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| tuesday |}]
;;

let%expect_test "weekday" =
  let date = Date.make_exn ~year:2020 ~month:Mar ~day:11 () in
  date |> Date.day_of_week |> dump_weekday;
  [%expect {| wednesday |}]
;;

let%expect_test "iso_week" =
  Date.epoch |> dump_date_iso_week_of_year;
  [%expect {| 1970 W1, thu/4 |}]
;;

let%expect_test "iso_week" =
  Date.make_exn ~year:2000 ~month:Jan ~day:1 () |> dump_date_iso_week_of_year;
  [%expect {| 1999 W52, sat/6 |}]
;;

let%expect_test "iso_week" =
  Date.make_exn ~year:2015 ~month:Dec ~day:31 () |> dump_date_iso_week_of_year;
  [%expect {| 2015 W53, thu/4 |}]
;;

let%expect_test "iso_week" =
  Date.make_exn ~year:2021 ~month:Jan ~day:1 () |> dump_date_iso_week_of_year;
  [%expect {| 2020 W53, fri/5 |}]
;;

let%expect_test "iso_week" =
  Date.make_exn ~year:2026 ~month:Feb ~day:23 () |> dump_date_iso_week_of_year;
  [%expect {| 2026 W9, mon/1 |}]
;;
