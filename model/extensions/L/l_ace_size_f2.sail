// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// Returns bytes
function clause execute ACESIZE_F2(xs, xd) = {
  let xs = X(xs);

  let format          = xs[0];
  let algo            = xs[11..1];
  let directionpolicy = xs[13 .. 12];
  let sc_protection   = xs[15 .. 14];
  let keytype         = xs[16 .. 16];
  let state_number    = xs[20 .. 17];
  let locality        = xs[28 .. 21];
  let uc_policy       = xs[31 .. 29];

  let is_crf_query =
      (format == bitzero)
      &
      (algo == zeros())
      &
      (directionpolicy == zeros())
      &
      (sc_protection == zeros())
      &
      (keytype == bitzero)
      &
      (state_number != zeros())
      &
      (locality == zeros())
      &
      (uc_policy == zeros());

  let is_algo_req =
      (format == bitzero)
      &
      (directionpolicy == zeros())
      &
      (state_number == zeros())
      &
      (locality == zeros())
      &
      (uc_policy == zeros());

  if is_crf_query & (state_number == 0b1111) then {
    // Total CRF Memory
    X(xd) = to_bits_truncate(32 * sizeof(llen) / 8);
  } else if is_crf_query & (state_number == 0b1110) then {
    // Remaining CRF Memory
    var total_crf_bytes : nat = 0;

    foreach (i from 0 to 31) {
        let lm = Lm(Lregno(i));
        if lm[_allocated] == bitzero then {
            total_crf_bytes = total_crf_bytes + (sizeof(llen) / 8);
        };
    };

    X(xd) = to_bits_truncate(total_crf_bytes);
  } else if not(is_crf_query) & is_algo_req then {
      // Check metadata validity
      // * SCProtection can be honored by hardware
      // * Key Type field must be Explicit
      let sc_protection = acescprotectionType_bits(sc_protection);
      let keytype      = acekeyType_bits(keytype);
      if
          (sc_protection != ACESC_NoProtection)
          |
          (keytype != ACEK_Explicit)
          |
          not(is_algorithm_supported(algo))
      then {
        X(xd) = zeros();
      } else {
        X(xd) = to_bits_truncate(algorithm_size(algo) / 8);
      };
  } else {
    X(xd) = zeros();
  };

  RETIRE_SUCCESS
}
