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

// ******************* ace.size *********************
union clause instruction = ACESIZE_F0: (lregidx, regidx)

// TODO Implement indirect CR access
mapping clause encdec = ACESIZE_F0(ks, xd)
  <-> 0b00 @ 0b00 @ 0b0 @ 0b0 @ 0b1 @ 0b00000 @ encdec_lreg(ks) @ 0b000 @ encdec_reg(xd) @ 0b1011011
  when (currentlyEnabled(Ext_L))

mapping clause assembly = ACESIZE_F0(ks, xd)
  <-> "ace.size" ^ spc() ^ reg_name(xd) ^ sep()  ^ lreg_name(ks)

union clause instruction = ACESIZE_F1: (regidx, regidx)

mapping clause encdec = ACESIZE_F1(xs, xd)
  <-> 0b00 @ 0b01 @ 0b0 @ 0b0 @ 0b1 @ 0b00000 @ encdec_reg(xs) @ 0b000 @ encdec_reg(xd) @ 0b1011011
  when (currentlyEnabled(Ext_L))

mapping clause assembly = ACESIZE_F1(xs, xd)
  <-> "ace.size" ^ spc() ^ reg_name(xd) ^ sep()  ^ reg_name(xs)

union clause instruction = ACESIZE_F2: (regidx, regidx)

mapping clause encdec = ACESIZE_F2(xs, xd)
  <-> 0b00 @ 0b10 @ 0b0 @ 0b0 @ 0b1 @ 0b00000 @ encdec_reg(xs) @ 0b000 @ encdec_reg(xd) @ 0b1011011
  when (currentlyEnabled(Ext_L))

mapping clause assembly = ACESIZE_F2(xs, xd)
  <-> "ace.size.internal" ^ spc() ^ reg_name(xd) ^ sep()  ^ reg_name(xs)

// ******************* ace.import *********************
union clause instruction = ACEIMPORT: (bits(12), regidx, lregidx)

// TODO Implement indirect CR access
mapping clause encdec = ACEIMPORT(imm, xs, kd)
  <-> imm @ encdec_reg(xs) @ 0b000 @ encdec_lreg(kd) @ 0b0001011
  when (currentlyEnabled(Ext_L))

mapping clause assembly = ACEIMPORT(imm, xs, kd)
  <-> "ace.import" ^ spc() ^ lreg_name(kd) ^ sep()  ^ hex_bits_signed_12(imm) ^ "(" ^ reg_name(xs) ^ ")"

// ******************* ace.export *********************
union clause instruction = ACEEXPORT: (bits(12), regidx, lregidx)

// TODO Implement indirect CR access
mapping clause encdec = ACEEXPORT(imm, xd, ks)
  <-> imm[11..5] @ encdec_lreg(ks) @ encdec_reg(xd) @ 0b000 @ imm[4..0] @ 0b0100111
  when (currentlyEnabled(Ext_L))

mapping clause assembly = ACEEXPORT(imm, xd, ks)
  <-> "ace.export" ^ spc() ^ lreg_name(ks) ^ sep()  ^ hex_bits_signed_12(imm) ^ "(" ^ reg_name(xd) ^ ")"

// ******************* ace.exec *********************
union clause instruction = ACEEXEC_FA: (vregidx, lregidx, vregidx)

// TODO Implement indirect CR access
mapping clause encdec = ACEEXEC_FA(vd, kn, vs)
  <-> 0b00 @ 0b00 @ 0b0 @ 0b0 @ 0b0 @ encdec_vreg(vs) @ encdec_lreg(kn) @ 0b000 @ encdec_vreg(vd) @ 0b1011011
  when currentlyEnabled(Ext_L) & get_sew() == 32 & not(zvk_valid_reg_overlap(vs, vd, get_lmul_pow()))

mapping clause assembly = ACEEXEC_FA(vd, kn, vs)
  <-> "ace.exec.a" ^ spc() ^ vreg_name(vd) ^ sep()  ^ lreg_name(kn) ^ sep() ^ vreg_name(vs)

union clause instruction = ACEEXEC_FB: (lregidx, vregidx)

// TODO Implement indirect CR access
mapping clause encdec = ACEEXEC_FB(kn, vs)
  <-> 0b00 @ 0b01 @ 0b0 @ 0b0 @ 0b0 @ encdec_vreg(vs) @ encdec_lreg(kn) @ 0b000 @ 0b00000 @ 0b1011011
  when currentlyEnabled(Ext_L) & get_sew() == 32

mapping clause assembly = ACEEXEC_FB(kn, vs)
  <-> "ace.exec.b" ^ spc() ^ lreg_name(kn) ^ sep() ^ vreg_name(vs)

union clause instruction = ACEEXEC_FC: (vregidx, lregidx)

// TODO Implement indirect CR access
mapping clause encdec = ACEEXEC_FC(vd, kn)
  <-> 0b00 @ 0b10 @ 0b0 @ 0b0 @ 0b0 @ 0b00000 @ encdec_lreg(kn) @ 0b000 @ encdec_vreg(vd) @ 0b1011011
  when currentlyEnabled(Ext_L) & get_sew() == 32

mapping clause assembly = ACEEXEC_FC(vd, kn)
  <-> "ace.exec.c" ^ spc() ^ vreg_name(vd) ^ sep() ^ lreg_name(kn)

union clause instruction = ACEEXEC_FD: (lregidx)

// TODO Implement indirect CR access
mapping clause encdec = ACEEXEC_FD(kn)
  <-> 0b00 @ 0b11 @ 0b0 @ 0b0 @ 0b0 @ 0b00000 @ encdec_lreg(kn) @ 0b000 @ 0b00000 @ 0b1011011
  when (currentlyEnabled(Ext_L))

mapping clause assembly = ACEEXEC_FD(kn)
  <-> "ace.exec.d" ^ spc() ^ lreg_name(kn)
