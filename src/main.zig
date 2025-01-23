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

    const int_a: i16 = try getFourDigitNum(); 
    const int_b: i16 = try getFourDigitNum(); 

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

/// A less elegant but effective way to convert a four character 
/// string to a four digit number.
fn char_array_to_int(chars: *[5]u8) i16 {
    var val: i16 = 0;
    var count: i16 = chars.len - 2;
    for (chars) |char| {
        const elem: i16 = char - 48;        
        val += elem * std.math.pow(i16, 10, count);
        std.debug.print("count={d}, elem={d}, val={d}\n", .{count,elem,val});
        count -= 1;

        if(count < 0) break;
    }
    return val;
}

/// Takes two, four digit inputs and runs the algorithm 
/// until Kaprekar's Constant is obtained.
pub fn kaprekar(a: i16, b: i16) i16 {
    std.debug.print("Values passed are: {d} & {d}\n", .{a, b});
    
    // sort a digits to descending
    const asc: [4]u8 = .{0,0,0,0};
    // sort b digits to descending
    const desc: [4]u8 = .{0,0,0,0};

    kaprekar_iter(asc, desc);

    return 0;
}

fn kaprekar_iter(asc: [4]u8, desc: [4]u8) void {
    std.debug.print("starting state: {d}, {d}", .{asc, desc});
}

const std = @import("std");

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("kaprekars_constant_lib");
