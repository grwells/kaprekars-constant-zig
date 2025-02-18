const std = @import("std");

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("kaprekars_constant_lib");

test "bubble sort ascending" {
    var array = [_]u8{ 9, 2, 3, 7, 8, 1, 6, 5, 4 };
    const slice = array[0..array.len];
    const output = bubbleSort(slice, true);
    std.debug.print("\n\t{any} vs. {any}", .{ slice, output });
    try std.testing.expect(std.mem.eql(u8, slice, output));
}

test "bubble sort descending" {
    var array = [_]u8{ 9, 2, 3, 7, 8, 1, 6, 5, 4 };
    const slice = array[0..array.len];
    const output = bubbleSort(slice, false);
    std.debug.print("\n\t{any} vs. {any}", .{ slice, output });
    try std.testing.expect(std.mem.eql(u8, slice, output));
}

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
    std.debug.print("\n\tlist -> {any}", .{int_a});
    std.debug.print("\n\tlist -> {any}", .{int_b});

    _ = kaprekar(int_a, int_b);
}

/// Get a four digit number from standard input.
fn getFourDigitArr() ![]u8 {
    // undefined means "unknown value", could be anything
    // read only 5 characters -> xxxx\0
    std.debug.print("\nEnter a four digit number [1000, 9999]:", .{});
    // allocate array
    var input: [5]u8 = undefined;
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    _ = stdin.readUntilDelimiter(&input, '\n') catch |err| {
        std.debug.print("\n[DESCRIPTION] please enter 4 digit number, [1000, 9999]\n", .{});
        return err;
    };

    // below is the same as -> x catch |err| return err;
    try stdout.print("\nThe user entered: {s}\n", .{input});

    std.debug.print("\n\tinput = {any}", .{input});
    for (0..input.len - 1) |index| {
        // input character to digit, base 10
        input[index] = try std.fmt.charToDigit(input[index], 10);
    }
    std.debug.print("\n\toutput = {any}", .{input});
    return input[0 .. input.len - 1];
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

/// Swaps two elements of a slice using generic types.
pub fn swap(comptime T: type, list: *[]T, index_a: usize, index_b: usize) []T {
    std.debug.print("\n\tSWAP", .{});
    std.debug.print("\n\t\tlist -> {any}", .{list});
    const tmp_a = list[index_a];
    const tmp_b = list[index_b];
    list[index_a] = tmp_b;
    list[index_b] = tmp_a;
    std.debug.print("\n\t\tlist -> {any}", .{list});
    return list;
}

/// Sorts a slice of digits into ascending or descending order using the
/// bubble sort algorithm.
pub fn bubbleSort(digits: []u8, ascending: bool) void {
    std.debug.print("BUBBLE SORT \n\t(start, ascending={any}) -> {any}", .{ ascending, digits });
    // copy input
    if (ascending) {
        std.debug.print("\n\tsort in ascending order", .{});
        var swapped: bool = true;
        while (swapped) {
            swapped = false;
            for (0..digits.len - 1) |index| {
                std.debug.print("\n\t({d}) comparing - {any} vs. {any}", .{ index, digits[index], digits[index + 1] });
                if (digits[index] > digits[index + 1]) {
                    std.debug.print("\n\t\tlarger, swapping", .{});
                    std.mem.swap(u8, &(digits[index]), &(digits[index + 1]));
                    // set flag
                    swapped = true;
                }
                std.debug.print("\n\t\tlist -> {any}", .{digits});
            }
            break;
        }
    } else {
        std.debug.print("\n\tsort in descending order", .{});
        var swapped: bool = true;
        while (swapped) {
            swapped = false;
            for (0..digits.len - 1) |index| {
                std.debug.print("\n\t({d}) comparing - {any} vs. {any}", .{ index, digits[index], digits[index + 1] });
                if (digits[index] < digits[index + 1]) {
                    std.debug.print("\n\t\tsmaller, swapping", .{});
                    // swap
                    std.mem.swap(u8, &digits[index], &digits[index + 1]);
                    // set flag
                    swapped = true;
                }
                std.debug.print("\n\t\tlist -> {any}", .{digits});
            }
            break;
        }
    }

    std.debug.print("\n\t(end) -> {any}\n", .{digits});
}

/// Takes two, four digit inputs and runs the algorithm
/// until Kaprekar's Constant is obtained.
pub fn kaprekar(a: []u8, b: []u8) bool {
    std.debug.print("\nKaprekar's Constant\n\tvalues passed are: {any} & {any}\n", .{ a, b });

    // sort a digits to descending
    //const asc: []u8 = bubbleSort(a[0..4], true);
    bubbleSort(a[0..a.len], true);
    // sort b digits to descending
    //const desc: []u8 = bubbleSort(b[0..4], false);
    bubbleSort(b[0..b.len], false);

    kaprekar_iter(a, b);

    return true;
}

fn kaprekar_iter(asc: []u8, desc: []u8) void {
    std.debug.print("starting state: {d}, {d}", .{ asc, desc });
}

/// Get a four digit number from standard input.
/// DEPRACTED!!
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
