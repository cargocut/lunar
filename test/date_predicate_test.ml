(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "is_weekend" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:8 ()
  |> Date.is_weekend
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_weekend" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:7 ()
  |> Date.is_weekend
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_weekend" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:6 ()
  |> Date.is_weekend
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_weekday" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:6 ()
  |> Date.is_weekday
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_leap_year" =
  Date.make_exn ~year:2026 ~month:Month.Mar ~day:6 ()
  |> Date.is_leap_year
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_leap_year" =
  Date.make_exn ~year:2028 ~month:Month.Mar ~day:6 ()
  |> Date.is_leap_year
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_first_day_of_month" =
  Date.make_exn ~year:2028 ~month:Month.Mar ~day:6 ()
  |> Date.is_first_day_of_month
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_first_day_of_month" =
  Date.make_exn ~year:2028 ~month:Month.Mar ~day:1 ()
  |> Date.is_first_day_of_month
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_last_day_of_month" =
  Date.make_exn ~year:2028 ~month:Month.Feb ~day:28 ()
  |> Date.is_last_day_of_month
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_last_day_of_month" =
  Date.make_exn ~year:2028 ~month:Month.Feb ~day:29 ()
  |> Date.is_last_day_of_month
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_first_day_of_year" =
  Date.make_exn ~year:2028 ~month:Month.Feb ~day:29 ()
  |> Date.is_first_day_of_year
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_first_day_of_year" =
  Date.make_exn ~year:2028 ~month:Month.Jan ~day:1 ()
  |> Date.is_first_day_of_year
  |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_last_day_of_year" =
  Date.make_exn ~year:2028 ~month:Month.Jan ~day:1 ()
  |> Date.is_last_day_of_year
  |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_last_day_of_year" =
  Date.make_exn ~year:2028 ~month:Month.Dec ~day:31 ()
  |> Date.is_last_day_of_year
  |> dump_bool;
  [%expect {| true |}]
;;

let test_invariant y =
  let rec loop d =
    if Date.year d <> y
    then ()
    else (
      assert (Date.is_weekend d <> Date.is_weekday d);
      if Date.is_first_day_of_month d then assert (Date.day_of_month d = 1);
      if Date.is_last_day_of_month d
      then assert (Date.day_of_month (Date.succ d) = 1);
      if Date.is_first_day_of_year d
      then assert (Date.month d = Month.Jan && Date.day_of_month d = 1);
      if Date.is_last_day_of_year d
      then assert (Date.month d = Month.Dec && Date.day_of_month d = 31);
      loop (Date.succ d))
  in
  loop (Date.make_exn ~year:y ~month:Month.Jan ~day:1 ())
;;

let%expect_test "calendar sweep invariants (2028)" =
  for i = 0 to 2500 do
    test_invariant i
  done;
  print_endline "ok";
  [%expect {| ok |}]
;;
