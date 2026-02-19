// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause execute ACESIZE_F0(ks, xd) = {
  let lm = Lm(ks);

  if
      (lm[_allocated] == bitzero)
      |
      ((lm[_allocated] == bitone) & (lm[_root_id] != lregidx_bits(ks)))
  then {
    X(xd) = zeros();
  } else {
    X(xd) = to_bits(unsigned(lm[_n_siblings]) * llen / 8);
  };

  RETIRE_SUCCESS
}
