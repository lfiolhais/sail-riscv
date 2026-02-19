// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause execute ACECLEAR(kd) = {
  // TODO: Specification mentions that `ace.clear` can't make `status.ACES`
  // Dirty. However, `lrm_dealloc` implicitly does that.
  // Opened https://github.com/riscv/riscv-high-assurance-cryptography/issues/76
  // to inquire about the issue.
  let _ = lrm_dealloc(kd);

  set_aceerror(aceerrorType_bits(ACEE_NoError));

  RETIRE_SUCCESS
}
