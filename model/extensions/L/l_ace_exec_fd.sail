// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause execute ACEEXEC_FD(kn) = {
  let lrm = Lm(kn);
  let l = L(kn);

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
