const std = @import("std");

/// Sorts a slice of digits into ascending or descending order using the
/// bubble sort algorithm.
pub fn bubbleSort(digits: []u8, ascending: bool) void {
    //std.debug.print("\nBUBBLE SORT \n\t(start, ascending={any}) -> {any}", .{ ascending, digits });
    // copy input
    if (ascending) {
        //std.debug.print("\n\tsort in ascending order", .{});
        var swapped: bool = true;
        while (swapped) {
            swapped = false;
            for (0..digits.len - 1) |index| {
                //std.debug.print("\n\t({d}) comparing - {any} vs. {any}", .{ index, digits[index], digits[index + 1] });
                if (digits[index] > digits[index + 1]) {
                    //std.debug.print("\n\t\tlarger, swapping", .{});
                    std.mem.swap(u8, &(digits[index]), &(digits[index + 1]));
                    // set flag
                    swapped = true;
                }
                //std.debug.print("\n\t\tlist -> {any}", .{digits});
            }
            //break;
        }
    } else {
        //std.debug.print("\n\tsort in descending order", .{});
        var swapped: bool = true;
        while (swapped) {
            swapped = false;
            for (0..digits.len - 1) |index| {
                //std.debug.print("\n\t({d}) comparing - {any} vs. {any}", .{ index, digits[index], digits[index + 1] });
                if (digits[index] < digits[index + 1]) {
                    //std.debug.print("\n\t\tsmaller, swapping", .{});
                    // swap
                    std.mem.swap(u8, &digits[index], &digits[index + 1]);
                    // set flag
                    swapped = true;
                }
                //std.debug.print("\n\t\tlist -> {any}", .{digits});
            }
            //break;
        }
    }

    //std.debug.print("\n\t(end) -> {any}\n", .{digits});
}

// Tests

test "bubble sort ascending" {
    var array = [_]u8{ 9, 2, 3, 7, 8, 1, 6, 5, 4 };
    const slice = array[0..array.len];
    bubbleSort(slice, true);
    //std.debug.print("\n\t{any} vs. {any}", .{slice});
    try std.testing.expectEqualSlices(u8, slice, &.{ 1, 2, 3, 4, 5, 6, 7, 8, 9 });
}

test "bubble sort descending" {
    var array = [_]u8{ 9, 2, 3, 7, 8, 1, 6, 5, 4 };
    const slice = array[0..array.len];
    bubbleSort(slice, false);
    //std.debug.print("\n\t{any} vs. {any}", .{ slice, output });
    try std.testing.expectEqualSlices(u8, slice, &.{ 9, 8, 7, 6, 5, 4, 3, 2, 1 });
}
