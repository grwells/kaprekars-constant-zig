pub fn main() !void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    const cli_title =
        \\ ____  __.                            __                /\        _________                         __                 __   
        \\|    |/ _|____  _____________   ____ |  | _______ ______)/ ______ \_   ___ \  ____   ____   _______/  |______    _____/  |_ 
        \\|      < \__  \ \____ \_  __ \_/ __ \|  |/ /\__  \\_  __ \/  ___/ /    \  \/ /  _ \ /    \ /  ___/\   __\__  \  /    \   __\
        \\|    |  \ / __ \|  |_> >  | \/\  ___/|    <  / __ \|  | \/\___ \  \     \___(  <_> )   |  \\___ \  |  |  / __ \|   |  \  |  
        \\|____|__ (____  /   __/|__|    \___  >__|_ \(____  /__|  /____  >  \______  /\____/|___|  /____  > |__| (____  /___|  /__|  
        \\        \/    \/|__|               \/     \/     \/           \/          \/            \/     \/            \/     \/      
    ;

    std.debug.print("{s}\n\t by Garrett Wells, Jan 2025\n", .{cli_title});

    //const int_a: i16 = try getFourDigitNum();
    //const int_b: i16 = try getFourDigitNum();

    const int_a: []u8 = try getFourDigitArr();
    const int_b: []u8 = try getFourDigitArr();

    _ = kaprekar(int_a, int_b);
}

/// Get a four digit number from standard input.
fn getFourDigitNum() !i16 {
    // undefined means "unknown value", could be anything
    // read only 5 characters -> xxxx\0
    std.debug.print("Enter a four digit number [1000, 9999]:", .{});
    var input: [5]u8 = undefined;
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    _ = stdin.readUntilDelimiter(&input, '\n') catch |err| {
        std.debug.print("[DESCRIPTION] please enter 4 digit number, [1000, 9999]\n", .{});
        return err;
    };

    // below is the same as -> x catch |err| return err;
    try stdout.print("The user entered: {s}\n", .{input});
    // convert to integer
    return try std.fmt.parseInt(i16, input[0..4], 0);
}

/// Get a four digit number from standard input.
fn getFourDigitArr() ![]u8 {
    // undefined means "unknown value", could be anything
    // read only 5 characters -> xxxx\0
    std.debug.print("Enter a four digit number [1000, 9999]:", .{});
    var input: [5]u8 = undefined;
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    _ = stdin.readUntilDelimiter(&input, '\n') catch |err| {
        std.debug.print("[DESCRIPTION] please enter 4 digit number, [1000, 9999]\n", .{});
        return err;
    };

    // below is the same as -> x catch |err| return err;
    try stdout.print("The user entered: {s}\n", .{input});

    // Convert to Integer
    // allocate array of four unsigned integers
    var output: []u8 = input[0..];

    // fill output
    for (input[0..4], 0..) |character, i| {
        // input character to digit, base 10
        output[i] = try std.fmt.charToDigit(character, 10);
    }

    return output;
}

/// A less elegant but effective way to convert a four character
/// string to a four digit number.
fn charArrayToInt(chars: *[5]u8) i16 {
    var val: i16 = 0;
    var count: i16 = chars.len - 2;
    for (chars) |char| {
        const elem: i16 = char - 48;
        val += elem * std.math.pow(i16, 10, count);
        std.debug.print("count={d}, elem={d}, val={d}\n", .{ count, elem, val });
        count -= 1;

        if (count < 0) break;
    }
    return val;
}

/// Sorts a slice of digits into ascending or descending order using the
/// bubble sort algorithm.
pub fn bubbleSort(digits: []u8, ascending: bool) []u8 {
    std.debug.print("BUBBLE SORT \n\t(start, ascending={any}) -> {any}", .{ ascending, digits });
    if (ascending) {
        std.debug.print("sort in ascending order", .{});
        var swapped: bool = true;
        while (swapped) {
            swapped = false;
            for (0..digits.len - 1) |i| {
                if (digits[i] > digits[i + 1]) {
                    // swap
                    const tmp = digits[i];
                    digits[i] = digits[i + 1];
                    digits[i + 1] = tmp;
                    // set flag
                    swapped = true;
                }
            }
        }
    } else {
        std.debug.print("sort in descending order", .{});
    }

    std.debug.print("\n\t(end) -> {any}", .{digits});
    return digits;
}

/// Takes two, four digit inputs and runs the algorithm
/// until Kaprekar's Constant is obtained.
pub fn kaprekar(a: []u8, b: []u8) bool {
    std.debug.print("Kaprekar's Constant\n\tvalues passed are: {d} & {d}\n", .{ a[0..4], b[0..4] });

    // sort a digits to descending
    const asc: []u8 = bubbleSort(a[0..4], true);
    // sort b digits to descending
    const desc: []u8 = bubbleSort(b[0..4], false);

    kaprekar_iter(asc, desc);

    return true;
}

fn kaprekar_iter(asc: []u8, desc: []u8) void {
    std.debug.print("starting state: {d}, {d}", .{ asc, desc });
}

const std = @import("std");

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("kaprekars_constant_lib");
