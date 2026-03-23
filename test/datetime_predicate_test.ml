(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "is_am" =
  "2026-03-19 11:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_am
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_am" =
  "2026-03-19 14:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_am
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_am - lower bound" =
  "2026-03-19 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_am
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_am - upper bound" =
  "2026-03-19 11:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_am
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_am - just after" =
  "2026-03-19 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_am
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_pm - lower bound" =
  "2026-03-19 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_pm
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_pm - upper bound" =
  "2026-03-19 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_pm
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_pm - just before" =
  "2026-03-19 11:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_pm
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_noon exact" =
  "2026-03-19 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_noon
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_noon - just before" =
  "2026-03-19 11:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_noon
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_midnight exact" =
  "2026-03-19 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_midnight
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_midnight - just after" =
  "2026-03-19 00:00:01"
  |> Datetime.from_string_exn
  |> Datetime.is_midnight
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_morning lower bound" =
  "2026-03-19 05:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_morning
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_morning upper bound" =
  "2026-03-19 11:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_morning
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_morning before" =
  "2026-03-19 04:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_morning
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_afternoon lower bound" =
  "2026-03-19 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_afternoon
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_afternoon upper bound" =
  "2026-03-19 16:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_afternoon
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_afternoon after" =
  "2026-03-19 17:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_afternoon
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_evening lower bound" =
  "2026-03-19 17:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_evening
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_evening upper bound" =
  "2026-03-19 20:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_evening
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_evening before" =
  "2026-03-19 16:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_evening
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_night late evening" =
  "2026-03-19 21:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_night
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_night before midnight" =
  "2026-03-19 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_night
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_night after midnight" =
  "2026-03-19 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_night
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_night upper bound" =
  "2026-03-19 04:59:59"
  |> Datetime.from_string_exn
  |> Datetime.is_night
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_night just after" =
  "2026-03-19 05:00:00"
  |> Datetime.from_string_exn
  |> Datetime.is_night
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "am/pm partition" =
  let dt = Datetime.from_string_exn "2026-03-19 10:00:00" in
  dump_bool (Datetime.is_am dt && not (Datetime.is_pm dt));
  [%expect {| true |}]
;;

let%expect_test "no overlap morning/afternoon" =
  let dt = Datetime.from_string_exn "2026-03-19 12:00:00" in
  dump_bool (Datetime.is_morning dt && Datetime.is_afternoon dt);
  [%expect {| false |}]
;;

let%expect_test "night overlaps midnight correctly" =
  let dt = Datetime.from_string_exn "2026-03-19 02:00:00" in
  dump_bool (Datetime.is_night dt);
  [%expect {| true |}]
;;
