// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause execute ACEEXPORT(imm, xd, ks) = {
  var offset : xlenbits = sign_extend(imm);
  // Metadata is 64 bits
  let n_stores_metadata = 8 / xlen_bytes;

  // Check if we are allocated and we are the root of the allocation
  let lrm = Lm(ks);
  if lrm[_allocated] == bitzero | lrm[_root_id] != lregidx_bits(ks) then {
      set_aceerror(aceerrorType_bits(ACEE_Unconfigured));
      return RETIRE_SUCCESS;
  };

  // Store metadata
  let metadata = lrm.bits[63 .. 0];
  foreach (i from 0 to (n_stores_metadata - 1)) {
      set_acestart(to_bits_unsafe(16, i * xlen_bytes));

      assert(xlen * i <= 64 - xlen);
      assert(xlen * (i + 1) - 1 < 64);
      let data_to_store = metadata[xlen * (i + 1) - 1 .. xlen * i];
      match vmem_write(xd, offset, xlen_bytes, data_to_store, Store(Data), false, false, false) {
        Ok(true)  => (),
        Ok(false) => internal_error(__FILE__, __LINE__, "store got false from vmem_write"),
        Err(e)    => return e,
      }
  };
  offset = offset + 8;

  // SIV is 128 bits
  let n_stores_siv = (siv_len / 8) / xlen_bytes;
  // TODO: Get proper SIV
  let siv: bits(siv) = 0xdeadbeefabad1deadeadbeefabad1dea;
  foreach (i from 0 to (n_stores_siv - 1)) {
      set_acestart(to_bits_unsafe(16, i * xlen_bytes + unsigned(offset)));

      assert(xlen * i <= siv_len - xlen);
      assert(xlen * (i + 1) - 1 < siv_len);
      let data_to_store = siv[xlen * (i + 1) - 1 .. xlen * i];
      let new_offset = offset + i * xlen_bytes;
      match vmem_write(xd, new_offset, xlen_bytes, data_to_store, Store(Data), false, false, false) {
        Ok(true)  => (),
        Ok(false) => internal_error(__FILE__, __LINE__, "store got false from vmem_write"),
        Err(e)    => return e,
      }
  };
  offset = offset + (siv_len / 8);

  // Write Encrypted Serialized Content
  let algo_size = algorithm_size(lrm[Algorithm]);
  let algorithm_size_bytes = algo_size / 8;

  // SCC size is provided by algorithm, direction policy, and key type.
  let n_lrs_to_be_stored = algorithm_size_bytes / llen_bytes;
  let n_stores = llen_bytes / xlen_bytes;

  foreach (i from 0 to (n_lrs_to_be_stored - 1)) {
      let l_id: lregidx = Lregidx(lregidx_bits(ks) + to_bits_unsafe(5, i));
      let k = L(l_id);

      foreach (j from 0 to (n_stores - 1)) {
          set_acestart(to_bits_unsafe(16, i * llen_bytes + j * xlen_bytes + unsigned(offset)));
          let new_offset = offset + i * llen_bytes + j * xlen_bytes;

          assert(j * xlen < llen - xlen);
          assert((j + 1) * xlen - 1 < llen);
          let data = k[(j + 1) * xlen - 1 .. j * xlen];

          match vmem_write(xd, new_offset, xlen_bytes, data, Store(Data), false, false, false) {
            Ok(true)  => (),
            Ok(false) => internal_error(__FILE__, __LINE__, "store got false from vmem_write"),
            Err(e)    => return e,
          }
      };
  };

  set_acestart(zeros());
  set_aceerror(aceerrorType_bits(ACEE_NoError));

  RETIRE_SUCCESS
}
