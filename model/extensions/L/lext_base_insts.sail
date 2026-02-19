// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements the base ACE extension `Zlace`
// ******************************************************************************

// ******************* ace.init *********************
union clause instruction = ACEINIT: (bits(12), regidx, lregidx)

mapping clause encdec = ACEINIT(imm, xs, kd)
  <-> imm @ encdec_reg(xs) @ 0b100 @ encdec_lreg(kd) @ 0b0101011
  when (currentlyEnabled(Ext_L))

mapping clause assembly = ACEINIT(imm, xs, kd)
  <-> "ace.init" ^ spc() ^ lreg_name(kd) ^ sep()  ^ hex_bits_signed_12(imm) ^ "(" ^ reg_name(xs) ^ ")"
