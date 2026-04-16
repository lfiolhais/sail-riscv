// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause execute ACESIZE_F0(ks, xd) = {
  let lm = Lm(ks);

  print_log("ace.size f0 => lm[_allocated] = " ^ bits_str(lm[_allocated]) ^ "; lm[_root_id] = " ^ bits_str(lregidx_bits(ks)));
  print_log("ace.size f0 => lm[_n_siblings] = " ^ bits_str(lm[_n_siblings]));

  if
      (lm[_allocated] == bitzero)
      |
      ((lm[_allocated] == bitone) & (lm[_root_id] != lregidx_bits(ks)))
  then {
    X(xd) = zeros();
  } else {
    X(xd) = to_bits(unsigned(lm[_n_siblings]) * llen / 8 + llen / 8 + 8 + 16);
  };

  RETIRE_SUCCESS
}
