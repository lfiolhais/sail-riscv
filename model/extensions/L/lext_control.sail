// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause currentlyEnabled(Ext_Zleaes128p) = hartSupports(Ext_Zleaes128p)
function clause currentlyEnabled(Ext_L) = hartSupports(Ext_L) & (misa[L] == 0b1) & (mstatus[ACES] != 0b00) & currentlyEnabled(Ext_Zicsr) & currentlyEnabled(Ext_Zleaes128p)

function is_algorithm_supported(algo: bits(11)) -> bool = {
    let algo_type = acealgorithmType_bits(algo[3..0]);
    let algo_cipher_mode = acealgorithmCipherModeType_bits(algo[8..4]);
    let algo_hash_mode = acealgorithmHashModeType_bits(algo[8..4]);
    print_log("Algo Type " ^ bits_str(algo[3..0]) ^ "; Algo Mode " ^ bits_str(algo[8..4]));

    match algo_type {
        ACEA_AES128 => match algo_cipher_mode {
            ACEAM_C_ECB => return true,
            _           => return false,
        },
        ACEA_AES192 => match algo_cipher_mode {
            ACEAM_C_ECB => return true,
            _           => return false,
        },
        _           => return false,
    };
}

// Return size of algorithm in bits
function algorithm_size(algo: bits(11)) -> nat = {
    let algo_type = acealgorithmType_bits(algo[3..0]);
    let algo_cipher_mode = acealgorithmCipherModeType_bits(algo[8..4]);
    let algo_hash_mode = acealgorithmHashModeType_bits(algo[8..4]);

    match algo_type {
        ACEA_AES128 => match algo_cipher_mode {
            ACEAM_C_ECB => return 128,
            _           => return 0,
        },
        ACEA_AES192 => match algo_cipher_mode {
            ACEAM_C_ECB => return 192,
            _           => return 0,
        },
        _           => return 0,
    };
}
