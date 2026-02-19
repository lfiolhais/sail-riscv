// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause execute ACEINIT(imm, xs, kd) = {
  let offset : xlenbits = sign_extend(imm);
  // Metadata is 64 bits
  let n_loads = 8 / xlen_bytes;

  // Deallocate Metadata Register and perform necessary cleanup/initialization
  let lrm = lrm_dealloc(kd);

  // Load metadata and set it in the loaded LRM
  foreach (i from 0 to (n_loads - 1)) {
      set_acestart(to_bits_unsafe(16, i * xlen_bytes));

      match vmem_read(xs, offset, xlen_bytes, Load(Data), false, false, false) {
        Ok(data) => Lm(kd) = l_set_data(lrm, data, i > 0),
        Err(e) => return e,
      }
  };

  // Reset `acestart` because there is nothing to restart
  set_acestart(zeros());

  let has_error = has_metadata_error(kd);
  if has_error then {
      return RETIRE_SUCCESS
  };

  // Check if register file has enough memory
  let algo_size = algorithm_size(lrm[Algorithm]);
  if algo_size > llen then {
    // TODO Implement dynamic register allocation
    set_aceerror(aceerrorType_bits(ACEE_Memory));
    return RETIRE_SUCCESS;
  };

  set_aceerror(aceerrorType_bits(ACEE_NoError));
  Lm(kd) = [lrm with _allocated = bitone, _root_id = lregidx_bits(kd)];

  RETIRE_SUCCESS
}
