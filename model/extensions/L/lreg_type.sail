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
    ExpirationDate : 63 .. 46,
    ExtraContent   : 45 .. 32,

    UC_Policy      : 31 .. 29,
    Locality       : 28 .. 21,
    State_Number   : 20 .. 17,
    KeyType        : 16 .. 16,
    SC_Protection  : 15 .. 14,
    DirectionPolicy: 13 .. 12,
    Algorithm      : 11 .. 1,
    Format         : 0
}

enum AceErrorType = {
    ACEE_NoError,
    ACEE_ImportAuthentication,
    ACEE_Unconfigured,
    ACEE_InvalidCR,
    ACEE_ExpiredCR,
    ACEE_Memory,
    ACEE_Unimplemented,
    ACEE_InvalidValue,
    ACEE_Privilege,
    ACEE_Authentication
}

mapping aceerrorType_bits : AceErrorType <-> bits(8) = {
  ACEE_NoError              <-> 0b00000000, // 0
  ACEE_ImportAuthentication <-> 0b00000001, // 1
  ACEE_Unconfigured         <-> 0b00000010, // 2
  ACEE_InvalidCR            <-> 0b00000011, // 3
  ACEE_ExpiredCR            <-> 0b00000100, // 4
  ACEE_Memory               <-> 0b00000101, // 5
  ACEE_Unimplemented        <-> 0b00000110, // 6
  ACEE_InvalidValue         <-> 0b00000111, // 7
  ACEE_Privilege            <-> 0b00001000, // 8
  ACEE_Authentication       <-> 0b00001001, // 9
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
    ACEK_System
}

mapping acekeyType_bits : AceKeyType <-> bits(1) = {
  ACEK_Explicit <-> 0b0, // 0
  ACEK_System   <-> 0b1  // 1
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

enum AceSCProtectionType = {
    ACESC_NoProtection,
    ACESC_DIELThreshold,
    ACESC_DIELThresholdFault,
    ACESC_Custom
}

mapping acescprotectionType_bits : AceSCProtectionType <-> bits(2) = {
  ACESC_NoProtection       <-> 0b00, // 0
  ACESC_DIELThreshold      <-> 0b01, // 1
  ACESC_DIELThresholdFault <-> 0b10, // 2
  ACESC_Custom             <-> 0b11  // 3
}

enum AceStateNumberType = {
    ACESN_Initial,
    ACESN_Operate,
    ACESN_HashAbsorb,
    ACESN_HashLastBlock,
    ACESN_HashFinalize,
    ACESN_HashVerify,
    ACESN_HashOutput,
    ACESN_Encrypt,
    ACESN_Decrypt,
    ACESN_EncryptLastBlock,
    ACESN_DecryptLastBlock,
    ACESN_EncryptTagFinalize,
    ACESN_DecryptTagFinalize,
    ACESN_SetAuxValue,
    ACESN_Invalid,
    ACESN_Completed
}

mapping acestatenumberType_bits : AceStateNumberType <-> bits(4) = {
  ACESN_Initial            <-> 0b0000, // 0
  ACESN_Operate            <-> 0b0001, // 1
  ACESN_HashAbsorb         <-> 0b0001, // 1
  ACESN_HashLastBlock      <-> 0b0010, // 2
  ACESN_HashFinalize       <-> 0b0011, // 3
  ACESN_HashVerify         <-> 0b0100, // 4
  ACESN_HashOutput         <-> 0b0101, // 5
  ACESN_Encrypt            <-> 0b0110, // 6
  ACESN_Decrypt            <-> 0b0111, // 7
  ACESN_EncryptLastBlock   <-> 0b1000, // 8
  ACESN_DecryptLastBlock   <-> 0b1001, // 9
  ACESN_EncryptTagFinalize <-> 0b1010, // 10
  ACESN_DecryptTagFinalize <-> 0b1011, // 11
  ACESN_SetAuxValue        <-> 0b1100, // 12
  ACESN_Invalid            <-> 0b1110, // 14
  ACESN_Completed          <-> 0b1111  // 15
}
