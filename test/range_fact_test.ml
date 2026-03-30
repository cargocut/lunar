(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util
module Date_range = Range.Make (Date)

let mkr a b =
  let first = Date.from_string_exn a
  and last = Date.from_string_exn b in
  Date_range.make ~first ~last
;;

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
    true
    true
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

let%expect_test "contains" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10"
  and subject = Date.from_string_exn "2026-03-05" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.contains subject |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "contains out of bounds" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10"
  and subject = Date.from_string_exn "2026-03-11" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.contains subject |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "contains out of bounds" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10"
  and subject = Date.from_string_exn "2026-02-28" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.contains subject |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "contains lower bound" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.contains first |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "contains upper bound" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.contains last |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "contains descending range" =
  let first = Date.from_string_exn "2026-03-10"
  and last = Date.from_string_exn "2026-03-01"
  and subject = Date.from_string_exn "2026-03-05" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.contains subject |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "contains descending out of bounds" =
  let first = Date.from_string_exn "2026-03-10"
  and last = Date.from_string_exn "2026-03-01"
  and subject = Date.from_string_exn "2026-03-11" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.contains subject |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "contains singleton hit" =
  let d = Date.from_string_exn "2026-03-05" in
  let range = Date_range.make ~first:d ~last:d in
  range |> Date_range.contains d |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "contains singleton miss" =
  let d = Date.from_string_exn "2026-03-05"
  and other = Date.from_string_exn "2026-03-06" in
  let range = Date_range.make ~first:d ~last:d in
  range |> Date_range.contains other |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "contains just below lower bound" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10"
  and subject = Date.from_string_exn "2026-02-28" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.contains subject |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "contains just above upper bound" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10"
  and subject = Date.from_string_exn "2026-03-11" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.contains subject |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "contains invariant under rev" =
  let first = Date.from_string_exn "2026-03-01"
  and last = Date.from_string_exn "2026-03-10"
  and subject = Date.from_string_exn "2026-03-05" in
  let range = Date_range.make ~first ~last in
  let r1 = Date_range.contains subject range in
  let r2 = Date_range.(range |> rev |> contains subject) in
  dump_bool r1;
  dump_bool r2;
  [%expect
    {|
    true
    true
  |}]
;;

let%expect_test "contains invariant under sort" =
  let first = Date.from_string_exn "2026-03-10"
  and last = Date.from_string_exn "2026-03-01"
  and subject = Date.from_string_exn "2026-03-05" in
  let range = Date_range.make ~first ~last in
  let r1 = Date_range.contains subject range in
  let r2 = Date_range.(range |> sort |> contains subject) in
  dump_bool r1;
  dump_bool r2;
  [%expect
    {|
    true
    true
  |}]
;;

let%expect_test "contains across year boundary" =
  let first = Date.from_string_exn "2025-12-30"
  and last = Date.from_string_exn "2026-01-02"
  and subject = Date.from_string_exn "2026-01-01" in
  let range = Date_range.make ~first ~last in
  range |> Date_range.contains subject |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "overlaps self" =
  let a = mkr "2026-03-01" "2026-03-10" in
  a |> Date_range.overlaps a |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "overlaps self reversed" =
  let a = mkr "2026-03-01" "2026-03-10" in
  a |> Date_range.(overlaps @@ rev a) |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "overlaps partial" =
  let a = mkr "2026-03-01" "2026-03-10"
  and b = mkr "2026-03-05" "2026-03-15" in
  a |> Date_range.overlaps b |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "overlaps disjoint after" =
  let a = mkr "2026-03-01" "2026-03-10"
  and b = mkr "2026-03-11" "2026-03-15" in
  a |> Date_range.overlaps b |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "overlaps disjoint before" =
  let a = mkr "2026-03-05" "2026-03-15"
  and b = mkr "2026-03-01" "2026-03-04" in
  a |> Date_range.overlaps b |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "overlaps touching end" =
  let a = mkr "2026-03-01" "2026-03-10"
  and b = mkr "2026-03-10" "2026-03-15" in
  a |> Date_range.overlaps b |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "overlaps touching start" =
  let a = mkr "2026-03-10" "2026-03-15"
  and b = mkr "2026-03-01" "2026-03-10" in
  a |> Date_range.overlaps b |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "overlaps singleton inside" =
  let a = mkr "2026-03-01" "2026-03-10"
  and b = mkr "2026-03-05" "2026-03-05" in
  a |> Date_range.overlaps b |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "overlaps singleton equals start" =
  let a = mkr "2026-03-01" "2026-03-10"
  and b = mkr "2026-03-01" "2026-03-01" in
  a |> Date_range.overlaps b |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "overlaps singleton equals end" =
  let a = mkr "2026-03-01" "2026-03-10"
  and b = mkr "2026-03-10" "2026-03-10" in
  a |> Date_range.overlaps b |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "overlaps singleton before" =
  let a = mkr "2026-03-01" "2026-03-10"
  and b = mkr "2026-02-28" "2026-02-28" in
  a |> Date_range.overlaps b |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "overlaps singleton after" =
  let a = mkr "2026-03-01" "2026-03-10"
  and b = mkr "2026-03-11" "2026-03-11" in
  a |> Date_range.overlaps b |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "overlaps descending" =
  let a = mkr "2026-03-10" "2026-03-01"
  and b = mkr "2026-03-05" "2026-03-15" in
  a |> Date_range.overlaps b |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "overlaps descending disjoint" =
  let a = mkr "2026-03-10" "2026-03-01"
  and b = mkr "2026-03-11" "2026-03-20" in
  a |> Date_range.overlaps b |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "includes equal" =
  let a = mkr "2026-03-01" "2026-03-10" in
  Date_range.includes a a |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "includes strict" =
  let parent = mkr "2026-03-01" "2026-03-10"
  and child = mkr "2026-03-03" "2026-03-05" in
  Date_range.includes parent child |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "includes touching lower" =
  let parent = mkr "2026-03-01" "2026-03-10"
  and child = mkr "2026-03-01" "2026-03-05" in
  Date_range.includes parent child |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "includes touching upper" =
  let parent = mkr "2026-03-01" "2026-03-10"
  and child = mkr "2026-03-05" "2026-03-10" in
  Date_range.includes parent child |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "includes touching upper" =
  let parent = mkr "2026-03-01" "2026-03-10"
  and child = mkr "2026-03-05" "2026-03-10" in
  Date_range.includes parent child |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "includes outside left" =
  let parent = mkr "2026-03-01" "2026-03-10"
  and child = mkr "2026-02-28" "2026-03-05" in
  Date_range.includes parent child |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "includes outside right" =
  let parent = mkr "2026-03-01" "2026-03-10"
  and child = mkr "2026-03-05" "2026-03-11" in
  Date_range.includes parent child |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "includes reversed parent" =
  let parent = mkr "2026-03-10" "2026-03-01"
  and child = mkr "2026-03-03" "2026-03-05" in
  Date_range.includes parent child |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "includes reversed child" =
  let parent = mkr "2026-03-01" "2026-03-10"
  and child = mkr "2026-03-05" "2026-03-03" in
  Date_range.includes parent child |> dump_bool;
  [%expect {| true |}]
;;
