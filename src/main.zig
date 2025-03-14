const std = @import("std");
const BubbleSort = @import("bubblesort.zig");
/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("kaprekars_constant_lib");

/// A pair of four digit numbers which will be used to calculate
/// Kaprekar's Constant.
const FourDigitPair = struct {
    a: []u8,
    b: []u8,

    /// Allocate memory for struct and members on heap.
    /// Return pointer to struct.
    fn init(allocator: std.mem.Allocator) !*FourDigitPair {

        // allocate memory for struct
        const struct_ptr = try allocator.create(FourDigitPair);
        // destroy in case of error
        errdefer allocator.destroy(struct_ptr);

        // allocate arrays, leave empty
        struct_ptr.a = try allocator.alloc(u8, 4);
        struct_ptr.b = try allocator.alloc(u8, 4);

        return struct_ptr;
    }

    /// De-allocate memory to clean up
    fn deinit(self: *FourDigitPair, allocator: std.mem.Allocator) !void {
        allocator.free(self.a);
        allocator.free(self.b);

        allocator.free(self);
    }
};

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
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    // allocate memory for number buffers
    const kpair = try FourDigitPair.init(arena.allocator());
    _ = &kpair;

    //std.mem.copyForwards(u8, kpair.a, try getFourDigitArr());
    //std.mem.copyForwards(u8, kpair.b, try getFourDigitArr());

    //std.debug.print("\n\tlist -> {any}", .{kpair.a});
    //std.debug.print("\n\tlist -> {any}", .{kpair.b});

    const initial_val = std.Random.intRangeAtMost(std.crypto.random, u16, 1000, 9999);
    std.debug.print("\tseed = {d}\n", .{initial_val});

    _ = kaprekar(initial_val);
}

/// Calculate Kaprekar's Constant... the simple and
/// easy way, i.e., the right way.
/// Takes a single integer, sorts into ascending and descending
/// order, subtracts, then repeats until a  result of 6174 - K's Constant.
fn kaprekar(n: u16) void {
    var res: u64 = n;
    const kc = 6174;
    while (res != kc) {
        // 1) sort asc & desc
        // a) make buffer/array of digits
        var buffer = [_]u8{ 0, 0, 0, 0 };
        _ = intToArray(res, &buffer);
        // b) sort buffer to desc
        _ = BubbleSort.bubbleSort(&buffer, false);
        // c) buffer to int
        const alpha = arrayToInt(&buffer);
        // d) beta = alpha but reversed (ascending)
        const beta = reverseInt(@truncate(alpha));

        // 2) subtract
        res = alpha - beta;
        std.debug.print("\n\t{d}(alpha) - {d}(beta) = {d}", .{ alpha, beta, res });
        // 3) repeat!
    }

    std.debug.print("\n\nKaprekar's Constant Solved -> res = {d} = kc = {d}\n\n", .{ res, kc });
}

/// Reverse an integer following the algorigthm from
/// https://www.geeksforgeeks.org/write-a-program-to-reverse-digits-of-a-number/
fn reverseInt(n: u16) u16 {
    var reverse: u16 = 0;
    var ns = n;
    while (ns > 0) {
        reverse = reverse * 10 + ns % 10;
        ns = ns / 10;
    }

    //std.debug.print("\n\treversed: {d}", .{reverse});
    return reverse;
}

/// Convert a four digit integer into a four
/// digit array, unsorted.
fn intToArray(n: u64, buffer: []u8) []u8 {
    var tmp = n;
    for (0..4) |index| {
        buffer[3 - index] = @truncate(tmp % 10);
        tmp = tmp / 10;
    }
    return buffer;
}

/// Convert an array of digits to an integer, assuming
/// unsigned.
fn arrayToInt(arr: []u8) u64 {
    var val: u64 = 0;
    const arrlen: u64 = arr.len - 1;

    for (0..arr.len) |index| {
        val += arr[index] * std.math.pow(u64, 10, arrlen - index);
    }

    return val;
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

// Tests

test "array to int expect 1003" {
    var arr = [_]u8{ 1, 0, 0, 3 };
    const val = arrayToInt(&arr);
    try std.testing.expect(val == 1003);
}

test "reverse int 1234" {
    const t = 1234;
    try std.testing.expect(reverseInt(t) == 4321);
}
