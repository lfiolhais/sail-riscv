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

// ******************* ace.prov *********************
union clause instruction = ACEPROV: (bits(12), regidx, lregidx)

// TODO Implement indirect CR access
mapping clause encdec = ACEPROV(imm, xs, kd)
  <-> imm @ encdec_reg(xs) @ 0b100 @ encdec_lreg(kd) @ 0b0001011
  when (currentlyEnabled(Ext_L))

mapping clause assembly = ACEPROV(imm, xs, kd)
  <-> "ace.prov" ^ spc() ^ lreg_name(kd) ^ sep()  ^ hex_bits_signed_12(imm) ^ "(" ^ reg_name(xs) ^ ")"

// ******************* ace.clear *********************
union clause instruction = ACECLEAR: (lregidx)

// TODO Implement indirect CR access
mapping clause encdec = ACECLEAR(kd)
  <-> 0b0000000 @ 0b00000 @ 0b00000 @ 0b100 @ encdec_lreg(kd) @ 0b1011011
  when (currentlyEnabled(Ext_L))

mapping clause assembly = ACECLEAR(kd)
  <-> "ace.clear" ^ spc() ^ lreg_name(kd)

// ******************* ace.reset *********************
union clause instruction = ACERESET: (unit)

mapping clause encdec = ACERESET()
  <-> 0b0000000 @ 0b00000 @ 0b00000 @ 0b101 @ 0b00000 @ 0b1011011
  when (currentlyEnabled(Ext_L))

mapping clause assembly = ACERESET()
  <-> "ace.reset"
