(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

let%expect_test "age: before birthday in current year" =
  let birthday = Date.make_exn ~year:1989 ~month:Month.Nov ~day:3 () in
  let current = Date.make_exn ~year:2026 ~month:Month.Mar ~day:8 () in
  Date.age ~birthday current |> print_int;
  [%expect {| 36 |}]
;;

let%expect_test "age: day before birthday" =
  let birthday = Date.make_exn ~year:1989 ~month:Month.Nov ~day:3 () in
  let current = Date.make_exn ~year:2026 ~month:Month.Nov ~day:2 () in
  Date.age ~birthday current |> print_int;
  [%expect {| 36 |}]
;;

let%expect_test "age: on birthday" =
  let birthday = Date.make_exn ~year:1989 ~month:Month.Nov ~day:3 () in
  let current = Date.make_exn ~year:2026 ~month:Month.Nov ~day:3 () in
  Date.age ~birthday current |> print_int;
  [%expect {| 37 |}]
;;

let%expect_test "age: after birthday" =
  let birthday = Date.make_exn ~year:1989 ~month:Month.Nov ~day:3 () in
  let current = Date.make_exn ~year:2026 ~month:Month.Dec ~day:3 () in
  Date.age ~birthday current |> print_int;
  [%expect {| 37 |}]
;;

let%expect_test "age: negative, one year before birthday" =
  let birthday = Date.make_exn ~year:1989 ~month:Month.Nov ~day:3 () in
  let current = Date.make_exn ~year:1988 ~month:Month.Nov ~day:3 () in
  Date.age ~birthday current |> print_int;
  [%expect {| -1 |}]
;;

let%expect_test "age: negative, day before birthday in same year" =
  let birthday = Date.make_exn ~year:1989 ~month:Month.Nov ~day:3 () in
  let current = Date.make_exn ~year:1989 ~month:Month.Nov ~day:2 () in
  Date.age ~birthday current |> print_int;
  [%expect {| 0 |}]
;;

let%expect_test "age: negative, multiple years before birthday" =
  let birthday = Date.make_exn ~year:1989 ~month:Month.Nov ~day:3 () in
  let current = Date.make_exn ~year:1985 ~month:Month.Jul ~day:15 () in
  Date.age ~birthday current |> print_int;
  [%expect {| -4 |}]
;;

let%expect_test "age: zero, birthday equals current" =
  let birthday = Date.make_exn ~year:1989 ~month:Month.Nov ~day:3 () in
  let current = Date.make_exn ~year:1989 ~month:Month.Nov ~day:3 () in
  Date.age ~birthday current |> print_int;
  [%expect {| 0 |}]
;;

let%expect_test "age: one year after birthday" =
  let birthday = Date.make_exn ~year:1989 ~month:Month.Nov ~day:3 () in
  let current = Date.make_exn ~year:1990 ~month:Month.Nov ~day:4 () in
  Date.age ~birthday current |> print_int;
  [%expect {| 1 |}]
;;

let%expect_test "age: leap-year birthday, day before in non-leap year" =
  let birthday = Date.make_exn ~year:2000 ~month:Month.Feb ~day:29 () in
  let current = Date.make_exn ~year:2001 ~month:Month.Feb ~day:28 () in
  Date.age ~birthday current |> print_int;
  [%expect {| 0 |}]
;;

let%expect_test "age: leap-year birthday, day after in non-leap year" =
  let birthday = Date.make_exn ~year:2000 ~month:Month.Feb ~day:29 () in
  let current = Date.make_exn ~year:2001 ~month:Month.Mar ~day:1 () in
  Date.age ~birthday current |> print_int;
  [%expect {| 1 |}]
;;

let%expect_test "age: symmetry check" =
  let birthday = Date.make_exn ~year:1989 ~month:Month.Nov ~day:3 () in
  let current = Date.make_exn ~year:2026 ~month:Month.Mar ~day:8 () in
  print_int (Date.age ~birthday current);
  print_newline ();
  print_int (Date.age ~birthday:current birthday);
  [%expect
    {|
    36
    -36
    |}]
;;
