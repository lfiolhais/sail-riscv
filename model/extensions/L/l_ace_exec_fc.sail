// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause execute ACEEXEC_FC(vd, kn) = {
  let lrm = Lm(kn);
  let l = L(kn);

  let SEW      = get_sew();
  let LMUL_pow = get_lmul_pow();
  let num_elem = get_num_elem(LMUL_pow, SEW);

  if not(zvk_check_encdec(128, 4)) then return Illegal_Instruction();

  if not(valid_reg_group(vd, LMUL_pow)) then return Illegal_Instruction();

  assert(SEW == 32);

  let vd_val = read_vreg(num_elem, SEW, LMUL_pow, vd);

  let eg_len   = (unsigned(vl) / 4);
  let eg_start = (unsigned(vstart) / 4);

  if lrm[_allocated] == bitzero | lrm[_root_id] != lregidx_bits(kn) then {
      set_aceerror(aceerrorType_bits(ACEE_Unconfigured));
      return RETIRE_SUCCESS;
  };

  // TODO: Actually implement the instruction
  // 3) Apply algorithm
  // 4) Write result to output

  set_vstart(zeros());
  set_aceerror(aceerrorType_bits(ACEE_NoError));

  RETIRE_SUCCESS
}
