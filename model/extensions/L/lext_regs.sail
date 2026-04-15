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

// Metadata registers

register lrm0 : Lmetadata = Mk_Lmetadata(zeros())
register lrm1 : Lmetadata = Mk_Lmetadata(zeros())
register lrm2 : Lmetadata = Mk_Lmetadata(zeros())
register lrm3 : Lmetadata = Mk_Lmetadata(zeros())
register lrm4 : Lmetadata = Mk_Lmetadata(zeros())
register lrm5 : Lmetadata = Mk_Lmetadata(zeros())
register lrm6 : Lmetadata = Mk_Lmetadata(zeros())
register lrm7 : Lmetadata = Mk_Lmetadata(zeros())
register lrm8 : Lmetadata = Mk_Lmetadata(zeros())
register lrm9 : Lmetadata = Mk_Lmetadata(zeros())
register lrm10 : Lmetadata = Mk_Lmetadata(zeros())
register lrm11 : Lmetadata = Mk_Lmetadata(zeros())
register lrm12 : Lmetadata = Mk_Lmetadata(zeros())
register lrm13 : Lmetadata = Mk_Lmetadata(zeros())
register lrm14 : Lmetadata = Mk_Lmetadata(zeros())
register lrm15 : Lmetadata = Mk_Lmetadata(zeros())
register lrm16 : Lmetadata = Mk_Lmetadata(zeros())
register lrm17 : Lmetadata = Mk_Lmetadata(zeros())
register lrm18 : Lmetadata = Mk_Lmetadata(zeros())
register lrm19 : Lmetadata = Mk_Lmetadata(zeros())
register lrm20 : Lmetadata = Mk_Lmetadata(zeros())
register lrm21 : Lmetadata = Mk_Lmetadata(zeros())
register lrm22 : Lmetadata = Mk_Lmetadata(zeros())
register lrm23 : Lmetadata = Mk_Lmetadata(zeros())
register lrm24 : Lmetadata = Mk_Lmetadata(zeros())
register lrm25 : Lmetadata = Mk_Lmetadata(zeros())
register lrm26 : Lmetadata = Mk_Lmetadata(zeros())
register lrm27 : Lmetadata = Mk_Lmetadata(zeros())
register lrm28 : Lmetadata = Mk_Lmetadata(zeros())
register lrm29 : Lmetadata = Mk_Lmetadata(zeros())
register lrm30 : Lmetadata = Mk_Lmetadata(zeros())
register lrm31 : Lmetadata = Mk_Lmetadata(zeros())

function l_get_sibling (lrm : Lmetadata, Lregno(sibling_id) : lregno) -> lregidx = {
  match sibling_id {
    0  => Lregidx(lrm[_sibling_0]),
    1  => Lregidx(lrm[_sibling_1]),
    2  => Lregidx(lrm[_sibling_2]),
    3  => Lregidx(lrm[_sibling_3]),
    4  => Lregidx(lrm[_sibling_4]),
    5  => Lregidx(lrm[_sibling_5]),
    6  => Lregidx(lrm[_sibling_6]),
    7  => Lregidx(lrm[_sibling_7]),
    8  => Lregidx(lrm[_sibling_8]),
    9  => Lregidx(lrm[_sibling_9]),
    10 => Lregidx(lrm[_sibling_10]),
    11 => Lregidx(lrm[_sibling_11]),
    12 => Lregidx(lrm[_sibling_12]),
    13 => Lregidx(lrm[_sibling_13]),
    14 => Lregidx(lrm[_sibling_14]),
    15 => Lregidx(lrm[_sibling_15]),
    16 => Lregidx(lrm[_sibling_16]),
    17 => Lregidx(lrm[_sibling_17]),
    18 => Lregidx(lrm[_sibling_18]),
    19 => Lregidx(lrm[_sibling_19]),
    20 => Lregidx(lrm[_sibling_20]),
    21 => Lregidx(lrm[_sibling_21]),
    22 => Lregidx(lrm[_sibling_22]),
    23 => Lregidx(lrm[_sibling_23]),
    24 => Lregidx(lrm[_sibling_24]),
    25 => Lregidx(lrm[_sibling_25]),
    26 => Lregidx(lrm[_sibling_26]),
    27 => Lregidx(lrm[_sibling_27]),
    28 => Lregidx(lrm[_sibling_28]),
    29 => Lregidx(lrm[_sibling_29]),
    30 => Lregidx(lrm[_sibling_30]),
    31 => Lregidx(lrm[_sibling_31]),
  }
}

function rmL (Lregno(r) : lregno) -> Lmetadata = {
  match r {
    0  => lrm0,
    1  => lrm1,
    2  => lrm2,
    3  => lrm3,
    4  => lrm4,
    5  => lrm5,
    6  => lrm6,
    7  => lrm7,
    8  => lrm8,
    9  => lrm9,
    10 => lrm10,
    11 => lrm11,
    12 => lrm12,
    13 => lrm13,
    14 => lrm14,
    15 => lrm15,
    16 => lrm16,
    17 => lrm17,
    18 => lrm18,
    19 => lrm19,
    20 => lrm20,
    21 => lrm21,
    22 => lrm22,
    23 => lrm23,
    24 => lrm24,
    25 => lrm25,
    26 => lrm26,
    27 => lrm27,
    28 => lrm28,
    29 => lrm29,
    30 => lrm30,
    31 => lrm31,
  }
}

val lmreg_write_callback = pure {cpp: "lmreg_write_callback"} : (lregidx, bits(235)) -> unit
function lmreg_write_callback(_) = ()

function wmL (Lregno(r) : lregno, m : Lmetadata) -> unit = {
  match r {
    0  => lrm0  = m,
    1  => lrm1  = m,
    2  => lrm2  = m,
    3  => lrm3  = m,
    4  => lrm4  = m,
    5  => lrm5  = m,
    6  => lrm6  = m,
    7  => lrm7  = m,
    8  => lrm8  = m,
    9  => lrm9  = m,
    10 => lrm10 = m,
    11 => lrm11 = m,
    12 => lrm12 = m,
    13 => lrm13 = m,
    14 => lrm14 = m,
    15 => lrm15 = m,
    16 => lrm16 = m,
    17 => lrm17 = m,
    18 => lrm18 = m,
    19 => lrm19 = m,
    20 => lrm20 = m,
    21 => lrm21 = m,
    22 => lrm22 = m,
    23 => lrm23 = m,
    24 => lrm24 = m,
    25 => lrm25 = m,
    26 => lrm26 = m,
    27 => lrm27 = m,
    28 => lrm28 = m,
    29 => lrm29 = m,
    30 => lrm30 = m,
    31 => lrm31 = m,
  };

  lmreg_write_callback(lregno_to_lregidx(Lregno(r)), m.bits);
}

function rmL_bits(i: lregidx) -> Lmetadata = rmL(lregidx_to_lregno(i))

function wmL_bits(i: lregidx, data: Lmetadata) -> unit = {
  wmL(lregidx_to_lregno(i)) = data
}

overload Lm =  {rmL_bits, wmL_bits, rmL, wmL}

function l_dealloc_siblings(r : lregno) -> unit = {
    let lrm = rmL(r);
    let n_siblings = unsigned(lrm[_n_siblings]);

    dirty_l_context();

    foreach (i from 0 to (n_siblings - 1)) {
        let lrm_sibling_id = l_get_sibling(lrm, Lregno(i));
        let lrm_sibling = [ Mk_Lmetadata(zeros()) with
            _allocated   = bitzero,
            _n_siblings  = to_bits(5, 0),
        ];
        wmL_bits(lrm_sibling_id, lrm_sibling);
    }
}

function l_dealloc_siblings_bits(i: lregidx) -> unit = l_dealloc_siblings(lregidx_to_lregno(i))

function lrm_dealloc(kd: lregidx) -> Lmetadata = {
  // Zero internal `_allocated` flag
  Lm(kd) = [Lm(kd) with _allocated = bitzero];
  // Read the metadata register but now the register is no longer allocated
  let lrm = Lm(kd);

  // Check if `lrm` is already allocated and has siblings. If it is, invalidate
  // all other siblings.
  if lrm[_allocated] == bitone & unsigned(lrm[_n_siblings]) != 0 then {
      l_dealloc_siblings_bits(kd);
  };

  assert(lrm[_allocated] == bitzero);
  assert(unsigned(lrm[_n_siblings]) == 0);

  dirty_l_context();

  lrm
}

function l_set_data(lrm: Lmetadata, data: xlenbits, upper: bool) -> Lmetadata = {
    var out = lrm;

    if xlen == 64 then {
        out[ExpirationDate] = data[63 .. 46];
        out[AdditionalData] = data[45 .. 32];
    } else if xlen == 32 & upper then {
        out[ExpirationDate] = data[31 .. 14];
        out[AdditionalData] = data[13 ..  0];
    };

    if xlen== 64 | (xlen== 32 & not(upper)) then {
        out[Usage_Policy]     = data[31 .. 29];
        out[Locality]         = data[28 .. 21];
        out[State_Number]     = data[20 .. 17];
        out[KeyType]          = data[16 .. 16];
        out[SC_Protection]    = data[15 .. 14];
        out[AlgorithmPolicy]  = data[13 .. 12];
        out[Algorithm]        = data[11 .. 1];
        out[Format]           = data[0];
    };

    return out;
}

// HAC CSRs
register aceerror : xlenbits
register acestart : xlenbits

mapping clause csr_name_map = 0x800  <-> "aceerror"
mapping clause csr_name_map = 0x801  <-> "acestart"

function clause is_CSR_accessible(0x800, _, _) = currentlyEnabled(Ext_L) // aceerror
function clause is_CSR_accessible(0x801, _, _) = currentlyEnabled(Ext_L) // acestart

function clause read_CSR(0x800) = aceerror
function clause read_CSR(0x801) = acestart

// Note: The spec recommends trapping if acestart is out of bounds but the
// current implementation does not yet do that.

function set_acestart(value : bits(16)) -> unit = {
  dirty_l_context();
  acestart = zero_extend(value[(llen_exp - 1) .. 0]);
  csr_write_callback("acestart", acestart);
}

function set_aceerror(value : bits(8)) -> unit = {
  dirty_l_context();
  aceerror = zero_extend(value);
  csr_write_callback("aceerror", aceerror);
}

function clause write_CSR(0x800, value) = { set_aceerror(value[7 .. 0]); Ok(aceerror) }
function clause write_CSR(0x801, value) = { set_acestart(value[15 .. 0]); Ok(acestart) }

// Validates the metadata in register with index `kd` and sets `ace_error` accordingly.
// Returns true if there is an error.
function has_metadata_error(kd: lregidx) -> bool = {
  // Read register again so that we are inspecting the new metadata
  let lrm = Lm(kd);

  // Check metadata validity: Check format
  let format = acemetadataformatType_bits(lrm[Format]);
  if format != ACEM_Std then {
     set_aceerror(aceerrorType_bits(ACEE_InvalidValue));
     return true;
  };

  // Check metadata validity: Key Type field must be Explicit
  let key_type = acekeyType_bits(lrm[KeyType]);
  if key_type != ACEK_Explicit then {
     print_log("Key type isn't explicit");
     set_aceerror(aceerrorType_bits(ACEE_InvalidValue));
     return true;
  };

  // Check metadata validity: "State_Number" field must be `ace_state_initial`.
  let state_number = acestatenumberType_bits(lrm[State_Number]);
  if state_number != ACESN_Initial then {
     print_log("State Number isn't initial");
     set_aceerror(aceerrorType_bits(ACEE_InvalidValue));
     return true;
  };

  // Check metadata validity: algorithm is supported
  if not(is_algorithm_supported(lrm[Algorithm])) then {
     print_log("Failed algo check");
     set_aceerror(aceerrorType_bits(ACEE_Unimplemented));
     return true;
  };

  // Check metadata validity: SCProtection can be honored by hardware
  let sc_protection = acescprotectionType_bits(lrm[SC_Protection]);
  if sc_protection != ACESC_NoProtection then {
     print_log("Failed SCProtection check");
     set_aceerror(aceerrorType_bits(ACEE_InvalidValue));
     return true;
  };

  // TODO Implement Locality checks

  // Check metadata validity: "Usage Control Policies" field:
  let uc_policy = lrm[Usage_Policy];
  let error : bool = match cur_privilege {
     User              => not(bit_to_bool(uc_policy[0])),
     Supervisor        => not(currentlyEnabled(Ext_S)) | not(bit_to_bool(uc_policy[1])),
     Machine           => false,
     VirtualUser       => internal_error(__FILE__, __LINE__, "Hypervisor extension not supported"),
     VirtualSupervisor => internal_error(__FILE__, __LINE__, "Hypervisor extension not supported"),
  };
  if error then {
     print_log("Failed Privilege Level check");
     set_aceerror(aceerrorType_bits(ACEE_Privilege));
     return true;
  };

  // TODO Implement AdditionalData checks

  // TODO Implement ExpirationDate checks

  return false;
}


function set_lr_slice(kd: lregidx, data: xlenbits, n_load: nat) -> unit = {
  static_assert(llen % xlen == 0);

  let index = n_load * xlen;

  assert(index < llen);
  assert(index + xlen - 1 < llen - xlen);

  L(kd) = [L(kd) with (index + xlen - 1) .. index = data];
}
