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

let%expect_test "span overlap" =
  let a = mkr "2026-03-01" "2026-03-10"
  and b = mkr "2026-03-05" "2026-03-15" in
  a |> Date_range.span b |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-01..2026-03-15) |}]
;;

let%expect_test "span disjoint fills gap" =
  let a = mkr "2026-03-01" "2026-03-03"
  and b = mkr "2026-03-10" "2026-03-12" in
  a |> Date_range.span b |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-01..2026-03-12) |}]
;;

let%expect_test "span descending" =
  let a = mkr "2026-03-10" "2026-03-01"
  and b = mkr "2026-03-20" "2026-03-15" in
  a |> Date_range.span b |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-01..2026-03-20) |}]
;;

let%expect_test "shift +1 day" =
  let r = mkr "2026-03-01" "2026-03-10" in
  r
  |> Date_range.shift Date.succ
  |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-02..2026-03-11) |}]
;;

let%expect_test "shift descending" =
  let r = mkr "2026-03-10" "2026-03-01" in
  r
  |> Date_range.shift Date.succ
  |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-11..2026-03-02) |}]
;;

let%expect_test "shift id" =
  let r = mkr "2026-03-01" "2026-03-10" in
  r |> Date_range.shift Fun.id |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-01..2026-03-10) |}]
;;

let%expect_test "shift composition" =
  let r = mkr "2026-03-01" "2026-03-10" in
  let f = Date.succ in
  r
  |> Date_range.shift f
  |> Date_range.shift f
  |> dump_range Date.to_string (module Date_range);
  [%expect {| (2026-03-03..2026-03-12) |}]
;;

let%expect_test "intersection identical" =
  let a = mkr "2026-03-01" "2026-03-10" in
  a
  |> Date_range.intersection a
  |> dump_option (dump_range Date.to_string (module Date_range));
  [%expect {| (2026-03-01..2026-03-10) |}]
;;

let%expect_test "intersection partial" =
  let a = mkr "2026-03-01" "2026-03-10"
  and b = mkr "2026-03-05" "2026-03-15" in
  a
  |> Date_range.intersection b
  |> dump_option (dump_range Date.to_string (module Date_range));
  [%expect {| (2026-03-05..2026-03-10) |}]
;;

let%expect_test "intersection disjoint" =
  let a = mkr "2026-03-01" "2026-03-10"
  and b = mkr "2026-03-11" "2026-03-15" in
  a
  |> Date_range.intersection b
  |> dump_option (dump_range Date.to_string (module Date_range))
;;

let%expect_test "intersection touching" =
  let a = mkr "2026-03-01" "2026-03-10"
  and b = mkr "2026-03-10" "2026-03-15" in
  a
  |> Date_range.intersection b
  |> dump_option (dump_range Date.to_string (module Date_range));
  [%expect {| (2026-03-10..2026-03-10) |}]
;;

let%expect_test "intersection descending" =
  let a = mkr "2026-03-10" "2026-03-01"
  and b = mkr "2026-03-15" "2026-03-05" in
  a
  |> Date_range.intersection b
  |> dump_option (dump_range Date.to_string (module Date_range));
  [%expect {| (2026-03-05..2026-03-10) |}]
;;
