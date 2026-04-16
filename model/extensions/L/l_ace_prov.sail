// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause execute ACEPROV(imm, xs, kd) = {
  var offset : xlenbits = sign_extend(imm);
  // Metadata is 64 bits
  let n_loads = 8 / xlen_bytes;

  // Deallocate Metadata Register and perform necessary cleanup/initialization
  lrm_dealloc(kd);

  // Load metadata and set it in the loaded LRM
  foreach (i from 0 to (n_loads - 1)) {
      set_acestart(to_bits_unsafe(16, i * xlen_bytes));
      let new_offset = offset + i * xlen_bytes;

      match vmem_read(xs, new_offset, xlen_bytes, Load(Data), false, false, false) {
        Ok(data) => Lm(kd) = l_set_data(Lm(kd), data, i > 0),
        Err(e) => return e,
      }
  };
  offset = offset + 8;

  // Reset `acestart` because there is nothing to restart
  set_acestart(zeros());

  if has_metadata_error(kd) then {
      return RETIRE_SUCCESS
  };

  // Check if register file has enough memory
  let algo_size = algorithm_size(Lm(kd)[Algorithm]);
  assert(algo_size > 0);
  print_int("Algo Size = ", algo_size);
  if algo_size > llen then {
    // TODO Implement dynamic register allocation
    set_aceerror(aceerrorType_bits(ACEE_Memory));
    return RETIRE_SUCCESS;
  };

  set_aceerror(aceerrorType_bits(ACEE_NoError));
  Lm(kd) = [Lm(kd) with _allocated = bitone, _root_id = lregidx_bits(kd)];

  let algorithm_size_bytes = algo_size / 8;

  // SCC size is provided by algorithm, direction policy, and key type.
  let n_lrs_to_be_loaded = algorithm_size_bytes / llen_bytes;
  let n_loads = llen_bytes / xlen_bytes;

  foreach (i from 0 to (n_lrs_to_be_loaded - 1)) {
      // Load data and set it in the loaded LR
      foreach (j from 0 to (n_loads - 1)) {
          set_acestart(to_bits_unsafe(16, i * llen_bytes + j * xlen_bytes + unsigned(offset)));
          let new_offset = offset + i * llen_bytes + j * xlen_bytes;

          match vmem_read(xs, new_offset, xlen_bytes, Load(Data), false, false, false) {
            Ok(data) => set_lr_slice(kd, data, j),
            Err(e) => return e,
          }
      };
  };

  set_acestart(zeros());
  set_aceerror(aceerrorType_bits(ACEE_NoError));

  RETIRE_SUCCESS
}
