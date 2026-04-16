// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause execute ACESIZE_F1(xs, xd) = {
  let xs = X(xs);

  var lrm = Mk_Lmetadata(zeros());
  lrm[Usage_Policy]     = xs[31 .. 29];
  lrm[Locality]         = xs[28 .. 21];
  lrm[State_Number]     = xs[20 .. 17];
  lrm[KeyType]          = xs[16 .. 16];
  lrm[SC_Protection]    = xs[15 .. 14];
  lrm[AlgorithmPolicy]  = xs[13 .. 12];
  lrm[Algorithm]        = xs[11 .. 1];
  lrm[Format]           = xs[0];

  if has_metadata_error(lrm, false) then {
    X(xd) = zeros();
  } else {
    let algo_size_bits = algorithm_size(lrm[Algorithm]);
    X(xd) = to_bits_truncate(algo_size_bits / 8) + 8 + 16;
  };

  RETIRE_SUCCESS
}
