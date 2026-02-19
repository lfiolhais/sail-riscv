// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause execute ACESIZE_F1(xs, xd) = {
  let xs = X(xs);
  let algo = xs[11..1];

  if not(is_algorithm_supported(algo)) then {
    X(xd) = zeros();
  } else {
    let algo_size_bits = algorithm_size(algo);
    X(xd) = to_bits_truncate(algo_size_bits / 8);
  };

  RETIRE_SUCCESS
}
