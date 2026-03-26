(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(* A collection of short scenarios involving meeting scheduling between
   different individuals located in different time zones. *)

type p =
  { name : string
  ; tz : Timezone.t
  }

let cest = Timezone.make ~hour:2 ~min:0
let est = Timezone.make ~hour:(-5) ~min:0
let make tz name = { tz; name }
let alice = make cest "Alice"
let bob = make est "Bob"
let in_lunch_break t = Time.(t >= pm 0 && t <= pm 2)
let in_work_hours t = Time.(t >= am 8 && t <= pm 6)

let can_invite dt =
  if Datetime.is_weekend dt
  then Error `on_weekend
  else if Datetime.on_time in_lunch_break dt
  then Error `during_lunchbreak
  else if not (Datetime.on_time in_work_hours dt)
  then Error `not_work_hours
  else Ok ()
;;

let schedule ~organizer ~at invited =
  let zdt = Zoned_datetime.from_local_datetime ~tz:organizer.tz at in
  let organizer_datetime = Zoned_datetime.to_datetime ~tz:organizer.tz zdt in
  let invited_datetime = Zoned_datetime.to_datetime ~tz:invited.tz zdt in
  match can_invite invited_datetime with
  | Ok () ->
    organizer.name
    ^ " can invite, at "
    ^ Datetime.to_string organizer_datetime
    ^ ", "
    ^ invited.name
    ^ ", at "
    ^ Datetime.to_string invited_datetime
  | Error `on_weekend ->
    organizer.name
    ^ " can't invite, at "
    ^ Datetime.to_string organizer_datetime
    ^ ", "
    ^ invited.name
    ^ ", at "
    ^ Datetime.to_string invited_datetime
    ^ "\n(because "
    ^ Weekday.to_string (Datetime.weekday invited_datetime)
    ^ " occurs during the weekend)"
  | Error `during_lunchbreak ->
    organizer.name
    ^ " can't invite, at "
    ^ Datetime.to_string organizer_datetime
    ^ ", "
    ^ invited.name
    ^ ", at "
    ^ Datetime.to_string invited_datetime
    ^ "\n(because it is during the lunchbreak)"
  | Error `not_work_hours ->
    organizer.name
    ^ " can't invite, at "
    ^ Datetime.to_string organizer_datetime
    ^ ", "
    ^ invited.name
    ^ ", at "
    ^ Datetime.to_string invited_datetime
    ^ "\n(because it is not during work hours)"
;;

let%expect_test "can schedule something" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-26T15:00:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {| Alice can invite, at 2026-03-26T15:00:00, Bob, at 2026-03-26T08:00:00 |}]
;;

let%expect_test "can schedule something" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-26T17:00:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {| Alice can invite, at 2026-03-26T17:00:00, Bob, at 2026-03-26T10:00:00 |}]
;;

let%expect_test "can't schedule something (lunch break !)" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-26T19:00:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Alice can't invite, at 2026-03-26T19:00:00, Bob, at 2026-03-26T12:00:00
    (because it is during the lunchbreak)
    |}]
;;

let%expect_test "can't schedule something (Not during work hours !)" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-26T09:00:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Alice can't invite, at 2026-03-26T09:00:00, Bob, at 2026-03-26T02:00:00
    (because it is not during work hours)
    |}]
;;

let%expect_test "can't schedule something (Weekend !)" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-23T02:00:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Alice can't invite, at 2026-03-23T02:00:00, Bob, at 2026-03-22T19:00:00
    (because sunday occurs during the weekend)
    |}]
;;

let%expect_test "edge: exactly start of work hours (Bob 08:00)" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-26T15:00:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {| Alice can invite, at 2026-03-26T15:00:00, Bob, at 2026-03-26T08:00:00 |}]
;;

let%expect_test "edge: exactly end of work hours (Bob 18:00)" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-27T01:00:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {| Alice can invite, at 2026-03-27T01:00:00, Bob, at 2026-03-26T18:00:00 |}]
;;

let%expect_test "edge: just after work hours (Bob 18:01)" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-27T01:01:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Alice can't invite, at 2026-03-27T01:01:00, Bob, at 2026-03-26T18:01:00
    (because it is not during work hours)
  |}]
;;

let%expect_test "edge: just before lunch (Bob 11:59)" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-26T18:59:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {| Alice can invite, at 2026-03-26T18:59:00, Bob, at 2026-03-26T11:59:00 |}]
;;

let%expect_test "edge: start of lunch (Bob 12:00)" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-26T19:00:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Alice can't invite, at 2026-03-26T19:00:00, Bob, at 2026-03-26T12:00:00
    (because it is during the lunchbreak)
  |}]
;;

let%expect_test "edge: end of lunch (Bob 14:00)" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-26T21:00:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Alice can't invite, at 2026-03-26T21:00:00, Bob, at 2026-03-26T14:00:00
    (because it is during the lunchbreak)
  |}]
;;

let%expect_test "edge: just after lunch (Bob 14:01)" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-26T21:01:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {| Alice can invite, at 2026-03-26T21:01:00, Bob, at 2026-03-26T14:01:00 |}]
;;

let%expect_test "crossing to previous day (Bob 00:30)" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-26T07:30:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Alice can't invite, at 2026-03-26T07:30:00, Bob, at 2026-03-26T00:30:00
    (because it is not during work hours)
  |}]
;;

let%expect_test "crossing to previous day (Bob previous date)" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-26T06:00:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Alice can't invite, at 2026-03-26T06:00:00, Bob, at 2026-03-25T23:00:00
    (because it is not during work hours)
  |}]
;;

let%expect_test "weekend triggered by Bob timezone (Sunday)" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-30T02:00:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Alice can't invite, at 2026-03-30T02:00:00, Bob, at 2026-03-29T19:00:00
    (because sunday occurs during the weekend)
  |}]
;;

let%expect_test "lunch break has priority over work hours" =
  let organizer = alice
  and at = Datetime.from_string_exn "2026-03-26T21:00:00"
  and invited = bob in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Alice can't invite, at 2026-03-26T21:00:00, Bob, at 2026-03-26T14:00:00
    (because it is during the lunchbreak)
  |}]
;;

let%expect_test "bob can invite alice (morning overlap)" =
  let organizer = bob
  and at = Datetime.from_string_exn "2026-03-26T09:00:00"
  and invited = alice in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {| Bob can invite, at 2026-03-26T09:00:00, Alice, at 2026-03-26T16:00:00 |}]
;;

let%expect_test "bob can invite alice (afternoon overlap)" =
  let organizer = bob
  and at = Datetime.from_string_exn "2026-03-26T11:00:00"
  and invited = alice in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {| Bob can invite, at 2026-03-26T11:00:00, Alice, at 2026-03-26T18:00:00 |}]
;;

let%expect_test "bob cannot invite (too early for alice)" =
  let organizer = bob
  and at = Datetime.from_string_exn "2026-03-26T00:00:00"
  and invited = alice in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Bob can't invite, at 2026-03-26T00:00:00, Alice, at 2026-03-26T07:00:00
    (because it is not during work hours)
  |}]
;;

let%expect_test "bob cannot invite (too late for alice)" =
  let organizer = bob
  and at = Datetime.from_string_exn "2026-03-26T12:01:00" (* Alice = 19:01 *)
  and invited = alice in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Bob can't invite, at 2026-03-26T12:01:00, Alice, at 2026-03-26T19:01:00
    (because it is not during work hours)
  |}]
;;

let%expect_test "bob cannot invite (alice lunch start)" =
  let organizer = bob
  and at = Datetime.from_string_exn "2026-03-26T05:00:00"
  and invited = alice in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Bob can't invite, at 2026-03-26T05:00:00, Alice, at 2026-03-26T12:00:00
    (because it is during the lunchbreak)
  |}]
;;

let%expect_test "bob cannot invite (alice lunch end inclusive)" =
  let organizer = bob
  and at = Datetime.from_string_exn "2026-03-26T07:00:00"
  and invited = alice in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Bob can't invite, at 2026-03-26T07:00:00, Alice, at 2026-03-26T14:00:00
    (because it is during the lunchbreak)
  |}]
;;

let%expect_test "bob can invite (after lunch)" =
  let organizer = bob
  and at = Datetime.from_string_exn "2026-03-26T07:01:00"
  and invited = alice in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {| Bob can invite, at 2026-03-26T07:01:00, Alice, at 2026-03-26T14:01:00 |}]
;;

let%expect_test "edge: alice start of work (08:00)" =
  let organizer = bob
  and at = Datetime.from_string_exn "2026-03-26T01:00:00"
  and invited = alice in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {| Bob can invite, at 2026-03-26T01:00:00, Alice, at 2026-03-26T08:00:00 |}]
;;

let%expect_test "edge: alice end of work (18:00)" =
  let organizer = bob
  and at = Datetime.from_string_exn "2026-03-26T11:00:00"
  and invited = alice in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {| Bob can invite, at 2026-03-26T11:00:00, Alice, at 2026-03-26T18:00:00 |}]
;;

let%expect_test "edge: alice just after work (18:01)" =
  let organizer = bob
  and at = Datetime.from_string_exn "2026-03-26T11:01:00"
  and invited = alice in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Bob can't invite, at 2026-03-26T11:01:00, Alice, at 2026-03-26T18:01:00
    (because it is not during work hours)
  |}]
;;

let%expect_test "weekend triggered on alice side (sunday)" =
  let organizer = bob
  and at = Datetime.from_string_exn "2026-03-29T10:00:00"
  and invited = alice in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Bob can't invite, at 2026-03-29T10:00:00, Alice, at 2026-03-29T17:00:00
    (because sunday occurs during the weekend)
  |}]
;;

let%expect_test "cross-day causes weekend on alice side" =
  let organizer = bob
  and at = Datetime.from_string_exn "2026-03-28T23:30:00"
  and invited = alice in
  schedule ~organizer ~at invited |> print_endline;
  [%expect
    {|
    Bob can't invite, at 2026-03-28T23:30:00, Alice, at 2026-03-29T06:30:00
    (because sunday occurs during the weekend)
  |}]
;;
