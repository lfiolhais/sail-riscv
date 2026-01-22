// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause currentlyEnabled(Ext_Zleaes128p) = hartSupports(Ext_Zleaes128p)
function clause currentlyEnabled(Ext_L) = hartSupports(Ext_L) & (misa[L] == 0b1) & (mstatus[ACES] != 0b00) & currentlyEnabled(Ext_Zicsr) & currentlyEnabled(Ext_Zleaes128p)
