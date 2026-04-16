// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause execute ACERESET() = {
  foreach (i from 0 to 31) {
      lrm_dealloc(lregno_to_lregidx(Lregno(i)));
  };

  set_aceerror(aceerrorType_bits(ACEE_NoError));

  RETIRE_SUCCESS
}
