(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util
module Date_range = Range.Make (Date)

let%expect_test "first elt" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  Date_range.first_elt range |> dump_date;
  [%expect {| 2026-03-01 |}]
;;

let%expect_test "last elt" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  Date_range.last_elt range |> dump_date;
  [%expect {| 2026-03-10 |}]
;;

let%expect_test "max elt" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  Date_range.max_elt range |> dump_date;
  [%expect {| 2026-03-10 |}]
;;

let%expect_test "min elt" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  Date_range.min_elt range |> dump_date;
  [%expect {| 2026-03-01 |}]
;;

let%expect_test "max elt" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first:last ~last:first in
  Date_range.max_elt range |> dump_date;
  [%expect {| 2026-03-10 |}]
;;

let%expect_test "min elt" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  Date_range.min_elt range |> dump_date;
  [%expect {| 2026-03-01 |}]
;;

let%expect_test "is_ascending" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  Date_range.is_ascending range |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_ascending" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first:last ~last:first in
  Date_range.is_ascending range |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_descending" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  Date_range.is_descending range |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_descending" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first:last ~last:first in
  Date_range.is_descending range |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "singleton range" =
  let d = Date.from_string_exn "2026-03-05" in
  let range = Date_range.make ~first:d ~last:d in
  Date_range.first_elt range |> dump_date;
  Date_range.last_elt range |> dump_date;
  Date_range.min_elt range |> dump_date;
  Date_range.max_elt range |> dump_date;
  Date_range.is_ascending range |> dump_bool;
  Date_range.is_descending range |> dump_bool;
  [%expect
    {|
    2026-03-05
    2026-03-05
    2026-03-05
    2026-03-05
    false
    false
    |}]
;;

let%expect_test "ascending/descending are mutually exclusive" =
  let d1 = Date.from_string_exn "2026-03-01"
  and d2 = Date.from_string_exn "2026-03-10" in
  let r = Date_range.make ~first:d1 ~last:d2 in
  Date_range.is_ascending r |> dump_bool;
  Date_range.is_descending r |> dump_bool;
  [%expect
    {|
    true
    false
  |}]
;;

let%expect_test "first/last vs min/max" =
  let d1 = Date.from_string_exn "2026-03-01"
  and d2 = Date.from_string_exn "2026-03-10" in
  let r = Date_range.make ~first:d2 ~last:d1 in
  Date_range.first_elt r |> dump_date;
  Date_range.last_elt r |> dump_date;
  Date_range.min_elt r |> dump_date;
  Date_range.max_elt r |> dump_date;
  [%expect
    {|
    2026-03-10
    2026-03-01
    2026-03-01
    2026-03-10
  |}]
;;

let%expect_test "large range" =
  let first = Date.from_string_exn "2000-01-01"
  and last = Date.from_string_exn "2030-12-31" in
  let range = Date_range.make ~first ~last in
  Date_range.min_elt range |> dump_date;
  Date_range.max_elt range |> dump_date;
  [%expect
    {|
    2000-01-01
    2030-12-31
  |}]
;;

let%expect_test "cross month/year" =
  let first = Date.from_string_exn "2025-12-30"
  and last = Date.from_string_exn "2026-01-02" in
  let range = Date_range.make ~first ~last in
  Date_range.min_elt range |> dump_date;
  Date_range.max_elt range |> dump_date;
  [%expect
    {|
    2025-12-30
    2026-01-02
  |}]
;;

let%expect_test "rev" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.rev |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-10..2026-03-01) |}]
;;

let%expect_test "sort" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.sort |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-01..2026-03-10) |}]
;;

let%expect_test "sort" =
  let last = Date.from_string_exn "2026-03-01"
  and first = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.sort |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-01..2026-03-10) |}]
;;

let%expect_test "rev ∘ rev = id" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  range
  |> Date_range.rev
  |> Date_range.rev
  |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-01..2026-03-10) |}]
;;

let%expect_test "rev descending -> ascending" =
  let first = Date.from_string_exn "2026-03-10"
  and last = Date.from_string_exn "2026-03-01" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.rev |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-01..2026-03-10) |}]
;;

let%expect_test "rev singleton" =
  let d = Date.from_string_exn "2026-03-05" in
  let range = Date_range.make ~first:d ~last:d in
  range |> Date_range.rev |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-05..2026-03-05) |}]
;;

let%expect_test "sort ∘ sort = sort" =
  let first = Date.from_string_exn "2026-03-10"
  and last = Date.from_string_exn "2026-03-01" in
  let range = Date_range.make ~first ~last in
  range
  |> Date_range.sort
  |> Date_range.sort
  |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-01..2026-03-10) |}]
;;

let%expect_test "sort ∘ sort = sort" =
  let first = Date.from_string_exn "2026-03-10"
  and last = Date.from_string_exn "2026-03-01" in
  let range = Date_range.make ~first ~last in
  range
  |> Date_range.sort
  |> Date_range.sort
  |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-01..2026-03-10) |}]
;;

let%expect_test "sort ∘ rev = sort" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  range
  |> Date_range.rev
  |> Date_range.sort
  |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-01..2026-03-10) |}]
;;

let%expect_test "rev ∘ sort = descending" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  range
  |> Date_range.sort
  |> Date_range.rev
  |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-10..2026-03-01) |}]
;;

let%expect_test "sort canonicalizes both inputs equally" =
  let d1 = Date.from_string_exn "2026-03-01"
  and d2 = Date.from_string_exn "2026-03-10" in
  let r1 = Date_range.make ~first:d1 ~last:d2 in
  let r2 = Date_range.make ~first:d2 ~last:d1 in
  Date_range.sort r1 |> dump_range Date.to_string (module Date_range);
  Date_range.sort r2 |> dump_range Date.to_string (module Date_range);
  [%expect
    {|
    (2026-03-01..2026-03-10)
    (2026-03-01..2026-03-10)
  |}]
;;

let%expect_test "rev ∘ sort ∘ rev = sort" =
  let first = Date.from_string_exn "2026-03-10"
  and last = Date.from_string_exn "2026-03-01" in
  let range = Date_range.make ~first ~last in
  range
  |> Date_range.rev
  |> Date_range.sort
  |> Date_range.rev
  |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-10..2026-03-01) |}]
;;

let%expect_test "rev large range" =
  let first = Date.from_string_exn "2000-01-01"
  and last = Date.from_string_exn "2030-12-31" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.rev |> dump_range Date.to_string (module Date_range);
  [%expect {| (2030-12-31..2000-01-01) |}]
;;

let%expect_test "sort cross-year reversed" =
  let first = Date.from_string_exn "2026-01-02"
  and last = Date.from_string_exn "2025-12-30" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.sort |> dump_range Date.to_string (module Date_range);
  [%expect {| (2025-12-30..2026-01-02) |}]
;;
