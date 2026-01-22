// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ***************************************************************
// HAC register file
// HAC CSR and accessors
// ***************************************************************

newtype lregidx = Lregidx : bits(5)
newtype lregno = Lregno : range(0, 31)

function lregidx_to_lregno (Lregidx(b) : lregidx) -> lregno = Lregno(unsigned(b))
function lregno_to_lregidx (Lregno(b) : lregno) -> lregidx = Lregidx(to_bits(5, b))

function lregidx_bits (Lregidx(b) : lregidx) -> bits(5) = b

mapping encdec_lreg : lregidx <-> bits(5) = { Lregidx(r) <-> r }

val lreg_write_callback = pure {cpp: "lreg_write_callback"} : (lregidx, llenbits) -> unit
function lreg_write_callback(_) = ()

// context registers
register lr0 : llenbits
register lr1 : llenbits
register lr2 : llenbits
register lr3 : llenbits
register lr4 : llenbits
register lr5 : llenbits
register lr6 : llenbits
register lr7 : llenbits
register lr8 : llenbits
register lr9 : llenbits
register lr10 : llenbits
register lr11 : llenbits
register lr12 : llenbits
register lr13 : llenbits
register lr14 : llenbits
register lr15 : llenbits
register lr16 : llenbits
register lr17 : llenbits
register lr18 : llenbits
register lr19 : llenbits
register lr20 : llenbits
register lr21 : llenbits
register lr22 : llenbits
register lr23 : llenbits
register lr24 : llenbits
register lr25 : llenbits
register lr26 : llenbits
register lr27 : llenbits
register lr28 : llenbits
register lr29 : llenbits
register lr30 : llenbits
register lr31 : llenbits

mapping lreg_name_raw : bits(5) <-> string = {
    0b00000 <-> "l0",
    0b00001 <-> "l1",
    0b00010 <-> "l2",
    0b00011 <-> "l3",
    0b00100 <-> "l4",
    0b00101 <-> "l5",
    0b00110 <-> "l6",
    0b00111 <-> "l7",
    0b01000 <-> "l8",
    0b01001 <-> "l9",
    0b01010 <-> "l10",
    0b01011 <-> "l11",
    0b01100 <-> "l12",
    0b01101 <-> "l13",
    0b01110 <-> "l14",
    0b01111 <-> "l15",
    0b10000 <-> "l16",
    0b10001 <-> "l17",
    0b10010 <-> "l18",
    0b10011 <-> "l19",
    0b10100 <-> "l20",
    0b10101 <-> "l21",
    0b10110 <-> "l22",
    0b10111 <-> "l23",
    0b11000 <-> "l24",
    0b11001 <-> "l25",
    0b11010 <-> "l26",
    0b11011 <-> "l27",
    0b11100 <-> "l28",
    0b11101 <-> "l29",
    0b11110 <-> "l30",
    0b11111 <-> "l31"
}

mapping lreg_name : lregidx <-> string = { Lregidx(i) <-> lreg_name_raw(i) }

function rL (Lregno(r) : lregno) -> llenbits = {
  match r {
    0  => lr0,
    1  => lr1,
    2  => lr2,
    3  => lr3,
    4  => lr4,
    5  => lr5,
    6  => lr6,
    7  => lr7,
    8  => lr8,
    9  => lr9,
    10 => lr10,
    11 => lr11,
    12 => lr12,
    13 => lr13,
    14 => lr14,
    15 => lr15,
    16 => lr16,
    17 => lr17,
    18 => lr18,
    19 => lr19,
    20 => lr20,
    21 => lr21,
    22 => lr22,
    23 => lr23,
    24 => lr24,
    25 => lr25,
    26 => lr26,
    27 => lr27,
    28 => lr28,
    29 => lr29,
    30 => lr30,
    31 => lr31,
  }
}

function dirty_l_context() -> unit = {
  assert(hartSupports(Ext_L));
  mstatus[ACES] = extStatus_to_bits(Dirty);
  mstatus[SD] = 0b1;
  long_csr_write_callback("mstatus", "mstatush", mstatus.bits);
}

function wL (Lregno(r) : lregno, l : llenbits) -> unit = {
  match r {
    0  => lr0  = l,
    1  => lr1  = l,
    2  => lr2  = l,
    3  => lr3  = l,
    4  => lr4  = l,
    5  => lr5  = l,
    6  => lr6  = l,
    7  => lr7  = l,
    8  => lr8  = l,
    9  => lr9  = l,
    10 => lr10 = l,
    11 => lr11 = l,
    12 => lr12 = l,
    13 => lr13 = l,
    14 => lr14 = l,
    15 => lr15 = l,
    16 => lr16 = l,
    17 => lr17 = l,
    18 => lr18 = l,
    19 => lr19 = l,
    20 => lr20 = l,
    21 => lr21 = l,
    22 => lr22 = l,
    23 => lr23 = l,
    24 => lr24 = l,
    25 => lr25 = l,
    26 => lr26 = l,
    27 => lr27 = l,
    28 => lr28 = l,
    29 => lr29 = l,
    30 => lr30 = l,
    31 => lr31 = l,
  };

  dirty_l_context();

  lreg_write_callback(lregno_to_lregidx(Lregno(r)), l);
}

function rL_bits(i: lregidx) -> llenbits = rL(lregidx_to_lregno(i))

function wL_bits(i: lregidx, data: llenbits) -> unit = {
  wL(lregidx_to_lregno(i)) = data
}

overload L =  {rL_bits, wL_bits, rL, wL}

