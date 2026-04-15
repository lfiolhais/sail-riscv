// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

type llen_exp : Int = config extensions.L.llen_exp
constraint 7 <= llen_exp <= 9

let llen_exp = sizeof(llen_exp)

type llen : Int = 2 ^ llen_exp
type siv : Int = 128

let llen = sizeof(llen)
let llen_bytes = sizeof(llen) / 8
let siv_len = sizeof(siv)
