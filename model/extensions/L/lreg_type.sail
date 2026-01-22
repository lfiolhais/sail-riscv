// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// Definitions for context registers (L extension)

type llenbits = bits(llen)

bitfield Lmetadata : bits(235) = {
    // Private Metadata (non-architectural)
    //
    // In order to support some kind of dynamic register allocation and
    // contexts larger than `llen`, we define the concept of a sibling. A
    // sibling is a context register that stores part of a full context.
    // Siblings used by a context don't have to be contiguous IDs. In a sibling
    // group, there is a root context ID which must be used as the
    // destination/source register in a HAC instruction. Using a non-root
    // context in an instruction results in an `aceerror`. We can have up to
    // 32 siblings.
    _sibling_31 : 234 .. 230,
    _sibling_30 : 229 .. 225,
    _sibling_29 : 224 .. 220,
    _sibling_28 : 219 .. 215,
    _sibling_27 : 214 .. 210,
    _sibling_26 : 209 .. 205,
    _sibling_25 : 204 .. 200,
    _sibling_24 : 199 .. 195,
    _sibling_23 : 194 .. 190,
    _sibling_22 : 189 .. 185,
    _sibling_21 : 184 .. 180,
    _sibling_20 : 179 .. 175,
    _sibling_19 : 174 .. 170,
    _sibling_18 : 169 .. 165,
    _sibling_17 : 164 .. 160,
    _sibling_16 : 159 .. 155,
    _sibling_15 : 154 .. 150,
    _sibling_14 : 149 .. 145,
    _sibling_13 : 144 .. 140,
    _sibling_12 : 139 .. 135,
    _sibling_11 : 134 .. 130,
    _sibling_10 : 129 .. 125,
    _sibling_9  : 124 .. 120,
    _sibling_8  : 119 .. 115,
    _sibling_7  : 114 .. 110,
    _sibling_6  : 109 .. 105,
    _sibling_5  : 104 .. 100,
    _sibling_4  : 99 .. 95,
    _sibling_3  : 94 .. 90,
    _sibling_2  : 89 .. 85,
    _sibling_1  : 84 .. 80,
    _sibling_0  : 79 .. 75,
    _n_siblings : 74 .. 70,
    _root_id    : 69 .. 65,
    _allocated  : 64,

    // Public Metadata (Architectural)
    UC_Policy_4     : 61 .. 48,
    UC_Policy_3     : 47 .. 32,
    UC_Policy_2     : 31 .. 30,
    UC_Policy_1     : 29 .. 26,

    State_Number    : 25 .. 22,
    Key_Type        : 21 .. 20,
    Direction_Policy: 19 .. 18,
    SC_Protection   : 17 .. 16,
    Algorithm       : 14 .. 6,
    Locality        : 4 .. 1,
    Format          : 0
}

union AceErrorType = {
    E_Ok             : unit,
    E_Authentication : unit,
    E_Privilege      : unit,
    E_Invalid        : unit,
    E_Unimplemented  : unit,
    E_Memory         : unit,
    E_Unconfigured   : unit
}

mapping aceerrorType_bits : AceErrorType <-> bits(8) = {
  E_Ok()             <-> 0b00000000, // 0
  E_Authentication() <-> 0b00000001, // 1
  E_Privilege()      <-> 0b00000010, // 2
  E_Invalid()        <-> 0b00000011, // 3
  E_Unimplemented()  <-> 0b00000100, // 4
  E_Memory()         <-> 0b00000101, // 5
  E_Unconfigured()   <-> 0b00000110, // 6
}

enum AceMetadataFormatType = {
    ACEM_Std,
    ACEM_Invalid
}

mapping acemetadataformatType_bits : AceMetadataFormatType <-> bits(1) = {
  ACEM_Std     <-> 0b0, // 0
  ACEM_Invalid <-> 0b1, // 1
}

enum AceKeyType = {
    ACEK_Explicit,
    ACEK_System,
    ACEK_Internal,
    ACEK_Invalid
}

mapping acekeyType_bits : AceKeyType <-> bits(2) = {
  ACEK_Explicit <-> 0b00, // 0
  ACEK_System   <-> 0b01, // 1
  ACEK_Internal <-> 0b10, // 2
  ACEK_Invalid  <-> 0b11, // 3
}

enum AceAlgorithmType = {
    ACEA_Invalid,
    ACEA_AES128,
    ACEA_AES192,
    ACEA_AES256,
    ACEA_SM4,
    ACEA_SHA2,
    ACEA_SHA3,
    ACEA_SM3,
    ACEA_HMAC,
    ACEA_ASCON
}

mapping acealgorithmType_bits : AceAlgorithmType <-> bits(4) = {
  ACEA_Invalid <-> 0b0000, // 0
  ACEA_AES128  <-> 0b0001, // 1
  ACEA_AES192  <-> 0b0010, // 2
  ACEA_AES256  <-> 0b0011, // 3
  ACEA_SM4     <-> 0b0100, // 4
  ACEA_SHA2    <-> 0b0101, // 5
  ACEA_SHA3    <-> 0b0110, // 6
  ACEA_SM3     <-> 0b0111, // 7
  ACEA_HMAC    <-> 0b1000, // 8
  ACEA_ASCON   <-> 0b1001, // 9
}

enum AceAlgorithmModeType = {
    // Ciphers
    ACEAM_C_Ctr,
    ACEAM_C_Xctr,
    ACEAM_C_GCM,
    ACEAM_C_GCM_SIV,
    ACEAM_C_XEX,
    ACEAM_C_XTS,
    ACEAM_C_OCB,
    ACEAM_C_CMAC,
    // Hashes
    ACEAM_H_224,
    ACEAM_H_256,
    ACEAM_H_384,
    ACEAM_H_512,
    ACEAM_H_SHAKE128,
    ACEAM_H_SHAKE256,
    //
    ACEAM_HC_None
}

mapping acealgorithmModeType_bits : AceAlgorithmModeType <-> bits(4) = {
    // Ciphers
    ACEAM_C_Ctr       <-> 0b0000,
    ACEAM_C_Xctr      <-> 0b0001,
    ACEAM_C_GCM       <-> 0b0010,
    ACEAM_C_GCM_SIV   <-> 0b0011,
    ACEAM_C_XEX       <-> 0b0100,
    ACEAM_C_XTS       <-> 0b0101,
    ACEAM_C_OCB       <-> 0b0110,
    ACEAM_C_CMAC      <-> 0b0111,
    // Hashes
    ACEAM_H_224       <-> 0b1000,
    ACEAM_H_256       <-> 0b1001,
    ACEAM_H_384       <-> 0b1010,
    ACEAM_H_512       <-> 0b1011,
    ACEAM_H_SHAKE128  <-> 0b1100,
    ACEAM_H_SHAKE256  <-> 0b1101,
    ACEAM_HC_None     <-> 0b1111
}
