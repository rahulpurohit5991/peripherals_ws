 /
//
// This package defines common multibit signal types, active high and active low values and
// the corresponding functions to test whether the values are set or not.




//4 Bit
parameter MuBi4Width = 4; // Bit width for 4-bit values
localparam [MuBi4Width-1:0] MuBi4True  = 4'b1010;  // Enabled (4-bit value)
localparam [MuBi4Width-1:0] MuBi4False = 4'b0101;  // Disabled (4-bit value)

// Test whether the value is invalid (not one of the valid enumerations)
function mubi4_test_invalid(input [MuBi4Width-1:0] val);
  begin
    mubi4_test_invalid = (val != MuBi4True) && (val != MuBi4False);
  end
endfunction

// Convert a 1-bit boolean to a mubi output (MuBi4True or MuBi4False)
function [MuBi4Width-1:0] mubi4_bool_to_mubi(input  val);
  begin
    mubi4_bool_to_mubi = val ? MuBi4True : MuBi4False;
  end
endfunction

// Test whether the multibit value equals the "True" condition (strict version)
function mubi4_test_true_strict(input [MuBi4Width-1:0] val);
  begin
    mubi4_test_true_strict = (val == MuBi4True);
  end
endfunction

// Test whether the multibit value equals the "False" condition (strict version)
function mubi4_test_false_strict(input [MuBi4Width-1:0] val);
  begin
    mubi4_test_false_strict = (val == MuBi4False);
  end
endfunction

// Test whether the value signals an "enabled" condition (loose version)
function mubi4_test_true_loose(input [MuBi4Width-1:0] val);
  begin
    mubi4_test_true_loose = (val != MuBi4False);
  end
endfunction

// Test whether the value signals a "disabled" condition (loose version)
function mubi4_test_false_loose(input [MuBi4Width-1:0] val);
  begin
    mubi4_test_false_loose = (val != MuBi4True);
  end
endfunction

// Perform a logical OR operation between two 4-bit values with an activation value
function [MuBi4Width-1:0] mubi4_or(input [MuBi4Width-1:0] a, input [MuBi4Width-1:0] b, input [MuBi4Width-1:0] act);
  begin
    mubi4_or = (act & (a | b)) | (~act & (a & b));
  end
endfunction

// Perform a logical AND operation between two 4-bit values with an activation value
function [MuBi4Width-1:0] mubi4_and(input [MuBi4Width-1:0] a, input [MuBi4Width-1:0] b, input [MuBi4Width-1:0] act);
  begin
    mubi4_and = (act & (a & b)) | (~act & (a | b));
  end
endfunction

// Perform a logical OR operation between two 4-bit values, treating "True" as logical 1
function [MuBi4Width-1:0] mubi4_or_hi(input [MuBi4Width-1:0] a, input [MuBi4Width-1:0] b);
  begin
    mubi4_or_hi = mubi4_or(a, b, MuBi4True);
  end
endfunction

// Perform a logical AND operation between two 4-bit values, treating "True" as logical 1
function [MuBi4Width-1:0] mubi4_and_hi(input [MuBi4Width-1:0] a, input [MuBi4Width-1:0] b);
  begin
    mubi4_and_hi = mubi4_and(a, b, MuBi4True);
  end
endfunction

// Perform a logical OR operation between two 4-bit values, treating "False" as logical 1
function [MuBi4Width-1:0] mubi4_or_lo(input [MuBi4Width-1:0] a, input [MuBi4Width-1:0] b);
  begin
    mubi4_or_lo = mubi4_or(a, b, MuBi4False);
  end
endfunction

// Perform a logical AND operation between two 4-bit values, treating "False" as logical 1
function [MuBi4Width-1:0] mubi4_and_lo(input [MuBi4Width-1:0] a, input [MuBi4Width-1:0] b);
  begin
    mubi4_and_lo = mubi4_and(a, b, MuBi4False);
  end
endfunction

parameter MuBi8Width = 8; // Bit width for 8-bit values
localparam [MuBi8Width-1:0] MuBi8True  = 8'b10101010;  // Enabled (8-bit value)
localparam [MuBi8Width-1:0] MuBi8False = 8'b01010101;  // Disabled (8-bit value)

// Test whether the value is invalid (not one of the valid enumerations)
function mubi8_test_invalid(input [MuBi8Width-1:0] val);
  begin
    mubi8_test_invalid = (val != MuBi8True) && (val != MuBi8False);
  end
endfunction

// Convert a 1-bit boolean to a MuBi output (MuBi8True or MuBi8False)
function [MuBi8Width-1:0] mubi8_bool_to_mubi(input  val);
  begin
    mubi8_bool_to_mubi = val ? MuBi8True : MuBi8False;
  end
endfunction

// Test whether the multi-bit value equals the "True" condition (strict version)
function mubi8_test_true_strict(input [MuBi8Width-1:0] val);
  begin
    mubi8_test_true_strict = (val == MuBi8True);
  end
endfunction

// Test whether the multi-bit value equals the "False" condition (strict version)
function mubi8_test_false_strict(input [MuBi8Width-1:0] val);
  begin
    mubi8_test_false_strict = (val == MuBi8False);
  end
endfunction

// Test whether the value signals an "enabled" condition (loose version)
function mubi8_test_true_loose(input [MuBi8Width-1:0] val);
  begin
    mubi8_test_true_loose = (val != MuBi8False);
  end
endfunction

// Test whether the value signals a "disabled" condition (loose version)
function mubi8_test_false_loose(input [MuBi8Width-1:0] val);
  begin
    mubi8_test_false_loose = (val != MuBi8True);
  end
endfunction

// Perform a logical OR operation between two 8-bit values with an activation value
function [MuBi8Width-1:0] mubi8_or(input [MuBi8Width-1:0] a, input [MuBi8Width-1:0] b, input [MuBi8Width-1:0] act);
  begin
    mubi8_or = (act & (a | b)) | (~act & (a & b));
  end
endfunction

// Perform a logical AND operation between two 8-bit values with an activation value
function [MuBi8Width-1:0] mubi8_and(input [MuBi8Width-1:0] a, input [MuBi8Width-1:0] b, input [MuBi8Width-1:0] act);
  begin
    mubi8_and = (act & (a & b)) | (~act & (a | b));
  end
endfunction

// Perform a logical OR operation between two 8-bit values, treating "True" as logical 1
function [MuBi8Width-1:0] mubi8_or_hi(input [MuBi8Width-1:0] a, input [MuBi8Width-1:0] b);
  begin
    mubi8_or_hi = mubi8_or(a, b, MuBi8True);
  end
endfunction

// Perform a logical AND operation between two 8-bit values, treating "True" as logical 1
function [MuBi8Width-1:0] mubi8_and_hi(input [MuBi8Width-1:0] a, input [MuBi8Width-1:0] b);
  begin
    mubi8_and_hi = mubi8_and(a, b, MuBi8True);
  end
endfunction

// Perform a logical OR operation between two 8-bit values, treating "False" as logical 1
function [MuBi8Width-1:0] mubi8_or_lo(input [MuBi8Width-1:0] a, input [MuBi8Width-1:0] b);
  begin
    mubi8_or_lo = mubi8_or(a, b, MuBi8False);
  end
endfunction

// Perform a logical AND operation between two 8-bit values, treating "False" as logical 1
function [MuBi8Width-1:0] mubi8_and_lo(input [MuBi8Width-1:0] a, input [MuBi8Width-1:0] b);
  begin
    mubi8_and_lo = mubi8_and(a, b, MuBi8False);
  end
endfunction



parameter MuBi12Width = 12; // Bit width for 12-bit values
localparam [MuBi12Width-1:0] MuBi12True  = 12'b101010101010;  // Enabled (12-bit value)
localparam [MuBi12Width-1:0] MuBi12False = 12'b010101010101;  // Disabled (12-bit value)

// Test whether the value is invalid (not one of the valid enumerations)
function mubi12_test_invalid(input [MuBi12Width-1:0] val);
  begin
    mubi12_test_invalid = (val != MuBi12True) && (val != MuBi12False);
  end
endfunction

// Convert a 1-bit boolean to a MuBi output (MuBi12True or MuBi12False)
function [MuBi12Width-1:0] mubi12_bool_to_mubi(input val);
  begin
    mubi12_bool_to_mubi = val ? MuBi12True : MuBi12False;
  end
endfunction

// Test whether the multi-bit value equals the "True" condition (strict version)
function mubi12_test_true_strict(input [MuBi12Width-1:0] val);
  begin
    mubi12_test_true_strict = (val == MuBi12True);
  end
endfunction

// Test whether the multi-bit value equals the "False" condition (strict version)
function mubi12_test_false_strict(input [MuBi12Width-1:0] val);
  begin
    mubi12_test_false_strict = (val == MuBi12False);
  end
endfunction

// Test whether the value signals an "enabled" condition (loose version)
function mubi12_test_true_loose(input [MuBi12Width-1:0] val);
  begin
    mubi12_test_true_loose = (val != MuBi12False);
  end
endfunction

// Test whether the value signals a "disabled" condition (loose version)
function mubi12_test_false_loose(input [MuBi12Width-1:0] val);
  begin
    mubi12_test_false_loose = (val != MuBi12True);
  end
endfunction

// Perform a logical OR operation between two 12-bit values with an activation value
function [MuBi12Width-1:0] mubi12_or(input [MuBi12Width-1:0] a, input [MuBi12Width-1:0] b, input [MuBi12Width-1:0] act);
  begin
    mubi12_or = (act & (a | b)) | (~act & (a & b));
  end
endfunction

// Perform a logical AND operation between two 12-bit values with an activation value
function [MuBi12Width-1:0] mubi12_and(input [MuBi12Width-1:0] a, input [MuBi12Width-1:0] b, input [MuBi12Width-1:0] act);
  begin
    mubi12_and = (act & (a & b)) | (~act & (a | b));
  end
endfunction

// Perform a logical OR operation between two 12-bit values, treating "True" as logical 1
function [MuBi12Width-1:0] mubi12_or_hi(input [MuBi12Width-1:0] a, input [MuBi12Width-1:0] b);
  begin
    mubi12_or_hi = mubi12_or(a, b, MuBi12True);
  end
endfunction

// Perform a logical AND operation between two 12-bit values, treating "True" as logical 1
function [MuBi12Width-1:0] mubi12_and_hi(input [MuBi12Width-1:0] a, input [MuBi12Width-1:0] b);
  begin
    mubi12_and_hi = mubi12_and(a, b, MuBi12True);
  end
endfunction

// Perform a logical OR operation between two 12-bit values, treating "False" as logical 1
function [MuBi12Width-1:0] mubi12_or_lo(input [MuBi12Width-1:0] a, input [MuBi12Width-1:0] b);
  begin
    mubi12_or_lo = mubi12_or(a, b, MuBi12False);
  end
endfunction

// Perform a logical AND operation between two 12-bit values, treating "False" as logical 1
function [MuBi12Width-1:0] mubi12_and_lo(input [MuBi12Width-1:0] a, input [MuBi12Width-1:0] b);
  begin
    mubi12_and_lo = mubi12_and(a, b, MuBi12False);
  end
endfunction


parameter MuBi16Width = 16; // Bit width for 16-bit values
localparam [MuBi16Width-1:0] MuBi16True  = 16'b1010101010101010;  // Enabled (16-bit value)
localparam [MuBi16Width-1:0] MuBi16False = 16'b0101010101010101;  // Disabled (16-bit value)

// Test whether the value is invalid (not one of the valid enumerations)
function mubi16_test_invalid(input [MuBi16Width-1:0] val);
  begin
    mubi16_test_invalid = (val != MuBi16True) && (val != MuBi16False);
  end
endfunction

// Convert a 1-bit boolean to a MuBi output (MuBi16True or MuBi16False)
function [MuBi16Width-1:0] mubi16_bool_to_mubi(input  val);
  begin
    mubi16_bool_to_mubi = val ? MuBi16True : MuBi16False;
  end
endfunction

// Test whether the multi-bit value equals the "True" condition (strict version)
function mubi16_test_true_strict(input [MuBi16Width-1:0] val);
  begin
    mubi16_test_true_strict = (val == MuBi16True);
  end
endfunction

// Test whether the multi-bit value equals the "False" condition (strict version)
function mubi16_test_false_strict(input [MuBi16Width-1:0] val);
  begin
    mubi16_test_false_strict = (val == MuBi16False);
  end
endfunction

// Test whether the value signals an "enabled" condition (loose version)
function mubi16_test_true_loose(input [MuBi16Width-1:0] val);
  begin
    mubi16_test_true_loose = (val != MuBi16False);
  end
endfunction

// Test whether the value signals a "disabled" condition (loose version)
function mubi16_test_false_loose(input [MuBi16Width-1:0] val);
  begin
    mubi16_test_false_loose = (val != MuBi16True);
  end
endfunction

// Perform a logical OR operation between two 16-bit values with an activation value
function [MuBi16Width-1:0] mubi16_or(input [MuBi16Width-1:0] a, input [MuBi16Width-1:0] b, input [MuBi16Width-1:0] act);
  begin
    mubi16_or = (act & (a | b)) | (~act & (a & b));
  end
endfunction

// Perform a logical AND operation between two 16-bit values with an activation value
function [MuBi16Width-1:0] mubi16_and(input [MuBi16Width-1:0] a, input [MuBi16Width-1:0] b, input [MuBi16Width-1:0] act);
  begin
    mubi16_and = (act & (a & b)) | (~act & (a | b));
  end
endfunction

// Perform a logical OR operation between two 16-bit values, treating "True" as logical 1
function [MuBi16Width-1:0] mubi16_or_hi(input [MuBi16Width-1:0] a, input [MuBi16Width-1:0] b);
  begin
    mubi16_or_hi = mubi16_or(a, b, MuBi16True);
  end
endfunction

// Perform a logical AND operation between two 16-bit values, treating "True" as logical 1
function [MuBi16Width-1:0] mubi16_and_hi(input [MuBi16Width-1:0] a, input [MuBi16Width-1:0] b);
  begin
    mubi16_and_hi = mubi16_and(a, b, MuBi16True);
  end
endfunction

// Perform a logical OR operation between two 16-bit values, treating "False" as logical 1
function [MuBi16Width-1:0] mubi16_or_lo(input [MuBi16Width-1:0] a, input [MuBi16Width-1:0] b);
  begin
    mubi16_or_lo = mubi16_or(a, b, MuBi16False);
  end
endfunction

// Perform a logical AND operation between two 16-bit values, treating "False" as logical 1
function [MuBi16Width-1:0] mubi16_and_lo(input [MuBi16Width-1:0] a, input [MuBi16Width-1:0] b);
  begin
    mubi16_and_lo = mubi16_and(a, b, MuBi16False);
  end
endfunction


parameter MuBi20Width = 20; // Bit width for 20-bit values
localparam [MuBi20Width-1:0] MuBi20True  = 20'b10101010101010101010;  // Enabled (20-bit value)
localparam [MuBi20Width-1:0] MuBi20False = 20'b01010101010101010101;  // Disabled (20-bit value)

// Test whether the value is invalid (not one of the valid enumerations)
function mubi20_test_invalid(input [MuBi20Width-1:0] val);
  begin
    mubi20_test_invalid = (val != MuBi20True) && (val != MuBi20False);
  end
endfunction

// Convert a 1-bit boolean to a MuBi output (MuBi20True or MuBi20False)
function [MuBi20Width-1:0] mubi20_bool_to_mubi(input  val);
  begin
    mubi20_bool_to_mubi = val ? MuBi20True : MuBi20False;
  end
endfunction

// Test whether the multi-bit value equals the "True" condition (strict version)
function mubi20_test_true_strict(input [MuBi20Width-1:0] val);
  begin
    mubi20_test_true_strict = (val == MuBi20True);
  end
endfunction

// Test whether the multi-bit value equals the "False" condition (strict version)
function mubi20_test_false_strict(input [MuBi20Width-1:0] val);
  begin
    mubi20_test_false_strict = (val == MuBi20False);
  end
endfunction

// Test whether the value signals an "enabled" condition (loose version)
function mubi20_test_true_loose(input [MuBi20Width-1:0] val);
  begin
    mubi20_test_true_loose = (val != MuBi20False);
  end
endfunction

// Test whether the value signals a "disabled" condition (loose version)
function mubi20_test_false_loose(input [MuBi20Width-1:0] val);
  begin
    mubi20_test_false_loose = (val != MuBi20True);
  end
endfunction

// Perform a logical OR operation between two 20-bit values with an activation value
function [MuBi20Width-1:0] mubi20_or(input [MuBi20Width-1:0] a, input [MuBi20Width-1:0] b, input [MuBi20Width-1:0] act);
  begin
    mubi20_or = (act & (a | b)) | (~act & (a & b));
  end
endfunction

// Perform a logical AND operation between two 20-bit values with an activation value
function [MuBi20Width-1:0] mubi20_and(input [MuBi20Width-1:0] a, input [MuBi20Width-1:0] b, input [MuBi20Width-1:0] act);
  begin
    mubi20_and = (act & (a & b)) | (~act & (a | b));
  end
endfunction

// Perform a logical OR operation between two 20-bit values, treating "True" as logical 1
function [MuBi20Width-1:0] mubi20_or_hi(input [MuBi20Width-1:0] a, input [MuBi20Width-1:0] b);
  begin
    mubi20_or_hi = mubi20_or(a, b, MuBi20True);
  end
endfunction

// Perform a logical AND operation between two 20-bit values, treating "True" as logical 1
function [MuBi20Width-1:0] mubi20_and_hi(input [MuBi20Width-1:0] a, input [MuBi20Width-1:0] b);
  begin
    mubi20_and_hi = mubi20_and(a, b, MuBi20True);
  end
endfunction

// Perform a logical OR operation between two 20-bit values, treating "False" as logical 1
function [MuBi20Width-1:0] mubi20_or_lo(input [MuBi20Width-1:0] a, input [MuBi20Width-1:0] b);
  begin
    mubi20_or_lo = mubi20_or(a, b, MuBi20False);
  end
endfunction

// Perform a logical AND operation between two 20-bit values, treating "False" as logical 1
function [MuBi20Width-1:0] mubi20_and_lo(input [MuBi20Width-1:0] a, input [MuBi20Width-1:0] b);
  begin
    mubi20_and_lo = mubi20_and(a, b, MuBi20False);
  end
endfunction


parameter MuBi24Width = 24; // Bit width for 24-bit values
localparam [MuBi24Width-1:0] MuBi24True  = 24'b101010101010101010101010;  // Enabled (24-bit value)
localparam [MuBi24Width-1:0] MuBi24False = 24'b010101010101010101010101;  // Disabled (24-bit value)

// Test whether the value is invalid (not one of the valid enumerations)
function mubi24_test_invalid(input [MuBi24Width-1:0] val);
  begin
    mubi24_test_invalid = (val != MuBi24True) && (val != MuBi24False);
  end
endfunction

// Convert a 1-bit boolean to a MuBi output (MuBi24True or MuBi24False)
function [MuBi24Width-1:0] mubi24_bool_to_mubi(input val);
  begin
    mubi24_bool_to_mubi = val ? MuBi24True : MuBi24False;
  end
endfunction

// Test whether the multi-bit value equals the "True" condition (strict version)
function mubi24_test_true_strict(input [MuBi24Width-1:0] val);
  begin
    mubi24_test_true_strict = (val == MuBi24True);
  end
endfunction

// Test whether the multi-bit value equals the "False" condition (strict version)
function mubi24_test_false_strict(input [MuBi24Width-1:0] val);
  begin
    mubi24_test_false_strict = (val == MuBi24False);
  end
endfunction

// Test whether the value signals an "enabled" condition (loose version)
function mubi24_test_true_loose(input [MuBi24Width-1:0] val);
  begin
    mubi24_test_true_loose = (val != MuBi24False);
  end
endfunction

// Test whether the value signals a "disabled" condition (loose version)
function mubi24_test_false_loose(input [MuBi24Width-1:0] val);
  begin
    mubi24_test_false_loose = (val != MuBi24True);
  end
endfunction

// Perform a logical OR operation between two 24-bit values with an activation value
function [MuBi24Width-1:0] mubi24_or(input [MuBi24Width-1:0] a, input [MuBi24Width-1:0] b, input [MuBi24Width-1:0] act);
  begin
    mubi24_or = (act & (a | b)) | (~act & (a & b));
  end
endfunction

// Perform a logical AND operation between two 24-bit values with an activation value
function [MuBi24Width-1:0] mubi24_and(input [MuBi24Width-1:0] a, input [MuBi24Width-1:0] b, input [MuBi24Width-1:0] act);
  begin
    mubi24_and = (act & (a & b)) | (~act & (a | b));
  end
endfunction

// Perform a logical OR operation between two 24-bit values, treating "True" as logical 1
function [MuBi24Width-1:0] mubi24_or_hi(input [MuBi24Width-1:0] a, input [MuBi24Width-1:0] b);
  begin
    mubi24_or_hi = mubi24_or(a, b, MuBi24True);
  end
endfunction

// Perform a logical AND operation between two 24-bit values, treating "True" as logical 1
function [MuBi24Width-1:0] mubi24_and_hi(input [MuBi24Width-1:0] a, input [MuBi24Width-1:0] b);
  begin
    mubi24_and_hi = mubi24_and(a, b, MuBi24True);
  end
endfunction

// Perform a logical OR operation between two 24-bit values, treating "False" as logical 1
function [MuBi24Width-1:0] mubi24_or_lo(input [MuBi24Width-1:0] a, input [MuBi24Width-1:0] b);
  begin
    mubi24_or_lo = mubi24_or(a, b, MuBi24False);
  end
endfunction

// Perform a logical AND operation between two 24-bit values, treating "False" as logical 1
function [MuBi24Width-1:0] mubi24_and_lo(input [MuBi24Width-1:0] a, input [MuBi24Width-1:0] b);
  begin
    mubi24_and_lo = mubi24_and(a, b, MuBi24False);
  end
endfunction

parameter MuBi28Width = 28; // Bit width for 28-bit values
localparam [MuBi28Width-1:0] MuBi28True  = 28'b1010101010101010101010101010;  // Enabled (28-bit value)
localparam [MuBi28Width-1:0] MuBi28False = 28'b0101010101010101010101010101;  // Disabled (28-bit value)

// Test whether the value is invalid (not one of the valid enumerations)
function mubi28_test_invalid(input [MuBi28Width-1:0] val);
  begin
    mubi28_test_invalid = (val != MuBi28True) && (val != MuBi28False);
  end
endfunction

// Convert a 1-bit boolean to a MuBi output (MuBi28True or MuBi28False)
function [MuBi28Width-1:0] mubi28_bool_to_mubi(input  val);
  begin
    mubi28_bool_to_mubi = val ? MuBi28True : MuBi28False;
  end
endfunction

// Test whether the multi-bit value equals the "True" condition (strict version)
function mubi28_test_true_strict(input [MuBi28Width-1:0] val);
  begin
    mubi28_test_true_strict = (val == MuBi28True);
  end
endfunction

// Test whether the multi-bit value equals the "False" condition (strict version)
function mubi28_test_false_strict(input [MuBi28Width-1:0] val);
  begin
    mubi28_test_false_strict = (val == MuBi28False);
  end
endfunction

// Test whether the value signals an "enabled" condition (loose version)
function mubi28_test_true_loose(input [MuBi28Width-1:0] val);
  begin
    mubi28_test_true_loose = (val != MuBi28False);
  end
endfunction

// Test whether the value signals a "disabled" condition (loose version)
function mubi28_test_false_loose(input [MuBi28Width-1:0] val);
  begin
    mubi28_test_false_loose = (val != MuBi28True);
  end
endfunction

// Perform a logical OR operation between two 28-bit values with an activation value
function [MuBi28Width-1:0] mubi28_or(input [MuBi28Width-1:0] a, input [MuBi28Width-1:0] b, input [MuBi28Width-1:0] act);
  begin
    mubi28_or = (act & (a | b)) | (~act & (a & b));
  end
endfunction

// Perform a logical AND operation between two 28-bit values with an activation value
function [MuBi28Width-1:0] mubi28_and(input [MuBi28Width-1:0] a, input [MuBi28Width-1:0] b, input [MuBi28Width-1:0] act);
  begin
    mubi28_and = (act & (a & b)) | (~act & (a | b));
  end
endfunction

// Perform a logical OR operation between two 28-bit values, treating "True" as logical 1
function [MuBi28Width-1:0] mubi28_or_hi(input [MuBi28Width-1:0] a, input [MuBi28Width-1:0] b);
  begin
    mubi28_or_hi = mubi28_or(a, b, MuBi28True);
  end
endfunction

// Perform a logical AND operation between two 28-bit values, treating "True" as logical 1
function [MuBi28Width-1:0] mubi28_and_hi(input [MuBi28Width-1:0] a, input [MuBi28Width-1:0] b);
  begin
    mubi28_and_hi = mubi28_and(a, b, MuBi28True);
  end
endfunction

// Perform a logical OR operation between two 28-bit values, treating "False" as logical 1
function [MuBi28Width-1:0] mubi28_or_lo(input [MuBi28Width-1:0] a, input [MuBi28Width-1:0] b);
  begin
    mubi28_or_lo = mubi28_or(a, b, MuBi28False);
  end
endfunction

// Perform a logical AND operation between two 28-bit values, treating "False" as logical 1
function [MuBi28Width-1:0] mubi28_and_lo(input [MuBi28Width-1:0] a, input [MuBi28Width-1:0] b);
  begin
    mubi28_and_lo = mubi28_and(a, b, MuBi28False);
  end
endfunction


parameter MuBi32Width = 32; // Bit width for 32-bit values
localparam [MuBi32Width-1:0] MuBi32True  = 32'b10101010101010101010101010101010;  // Enabled (32-bit value)
localparam [MuBi32Width-1:0] MuBi32False = 32'b01010101010101010101010101010101;  // Disabled (32-bit value)

// Test whether the value is invalid (not one of the valid enumerations)
function mubi32_test_invalid(input [MuBi32Width-1:0] val);
  begin
    mubi32_test_invalid = (val != MuBi32True) && (val != MuBi32False);
  end
endfunction

// Convert a 1-bit boolean to a MuBi output (MuBi32True or MuBi32False)
function [MuBi32Width-1:0] mubi32_bool_to_mubi(input val);
  begin
    mubi32_bool_to_mubi = val ? MuBi32True : MuBi32False;
  end
endfunction

// Test whether the multi-bit value equals the "True" condition (strict version)
function mubi32_test_true_strict(input [MuBi32Width-1:0] val);
  begin
    mubi32_test_true_strict = (val == MuBi32True);
  end
endfunction

// Test whether the multi-bit value equals the "False" condition (strict version)
function mubi32_test_false_strict(input [MuBi32Width-1:0] val);
  begin
    mubi32_test_false_strict = (val == MuBi32False);
  end
endfunction

// Test whether the value signals an "enabled" condition (loose version)
function mubi32_test_true_loose(input [MuBi32Width-1:0] val);
  begin
    mubi32_test_true_loose = (val != MuBi32False);
  end
endfunction

// Test whether the value signals a "disabled" condition (loose version)
function mubi32_test_false_loose(input [MuBi32Width-1:0] val);
  begin
    mubi32_test_false_loose = (val != MuBi32True);
  end
endfunction

// Perform a logical OR operation between two 32-bit values with an activation value
function [MuBi32Width-1:0] mubi32_or(input [MuBi32Width-1:0] a, input [MuBi32Width-1:0] b, input [MuBi32Width-1:0] act);
  begin
    mubi32_or = (act & (a | b)) | (~act & (a & b));
  end
endfunction

// Perform a logical AND operation between two 32-bit values with an activation value
function [MuBi32Width-1:0] mubi32_and(input [MuBi32Width-1:0] a, input [MuBi32Width-1:0] b, input [MuBi32Width-1:0] act);
  begin
    mubi32_and = (act & (a & b)) | (~act & (a | b));
  end
endfunction

// Perform a logical OR operation between two 32-bit values, treating "True" as logical 1
function [MuBi32Width-1:0] mubi32_or_hi(input [MuBi32Width-1:0] a, input [MuBi32Width-1:0] b);
  begin
    mubi32_or_hi = mubi32_or(a, b, MuBi32True);
  end
endfunction

// Perform a logical AND operation between two 32-bit values, treating "True" as logical 1
function [MuBi32Width-1:0] mubi32_and_hi(input [MuBi32Width-1:0] a, input [MuBi32Width-1:0] b);
  begin
    mubi32_and_hi = mubi32_and(a, b, MuBi32True);
  end
endfunction

// Perform a logical OR operation between two 32-bit values, treating "False" as logical 1
function [MuBi32Width-1:0] mubi32_or_lo(input [MuBi32Width-1:0] a, input [MuBi32Width-1:0] b);
  begin
    mubi32_or_lo = mubi32_or(a, b, MuBi32False);
  end
endfunction

// Perform a logical AND operation between two 32-bit values, treating "False" as logical 1
function [MuBi32Width-1:0] mubi32_and_lo(input [MuBi32Width-1:0] a, input [MuBi32Width-1:0] b);
  begin
    mubi32_and_lo = mubi32_and(a, b, MuBi32False);
  end
endfunction








//endmodule
