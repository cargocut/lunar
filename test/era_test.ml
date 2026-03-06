(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "from_year" =
  -1 |> Era.from_year |> dump_era;
  [%expect {| bce |}]
;;

let%expect_test "from_year" =
  0 |> Era.from_year |> dump_era;
  [%expect {| bce |}]
;;

let%expect_test "from_year" =
  1 |> Era.from_year |> dump_era;
  [%expect {| ce |}]
;;

let%expect_test "from_year" =
  2026 |> Era.from_year |> dump_era;
  [%expect {| ce |}]
;;

let%expect_test "year" =
  2026 |> Era.year |> print_int;
  [%expect {| 2026 |}]
;;

let%expect_test "year" =
  1 |> Era.year |> print_int;
  [%expect {| 1 |}]
;;

let%expect_test "year" =
  0 |> Era.year |> print_int;
  [%expect {| 1 |}]
;;

let%expect_test "year" =
  -1 |> Era.year |> print_int;
  [%expect {| 2 |}]
;;

let%expect_test "year" =
  -44 |> Era.year |> print_int;
  [%expect {| 45 |}]
;;

let%expect_test "century" =
  2026 |> Era.century |> print_int;
  [%expect {| 21 |}]
;;

let%expect_test "century" =
  2000 |> Era.century |> print_int;
  [%expect {| 20 |}]
;;

let%expect_test "century" =
  1905 |> Era.century |> print_int;
  [%expect {| 20 |}]
;;

let%expect_test "century" =
  1 |> Era.century |> print_int;
  [%expect {| 1 |}]
;;

let%expect_test "century" =
  100 |> Era.century |> print_int;
  [%expect {| 1 |}]
;;

let%expect_test "century" =
  101 |> Era.century |> print_int;
  [%expect {| 2 |}]
;;

let%expect_test "century" =
  200 |> Era.century |> print_int;
  [%expect {| 2 |}]
;;

let%expect_test "year_of_century" =
  2026 |> Era.year_of_century |> print_int;
  [%expect {| 26 |}]
;;

let%expect_test "year_of_century" =
  2000 |> Era.year_of_century |> print_int;
  [%expect {| 100 |}]
;;

let%expect_test "year_of_century" =
  2001 |> Era.year_of_century |> print_int;
  [%expect {| 1 |}]
;;

let%expect_test "year_of_century" =
  1905 |> Era.year_of_century |> print_int;
  [%expect {| 5 |}]
;;
