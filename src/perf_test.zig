const std = @import("std");
const tkn = @import("tokenizer.zig");
const Tokenizer = tkn.Tokenizer;
const Token = tkn.Token;
const fmtIntSizeBin = std.fmt.fmtIntSizeBin;

const source = @embedFile("usfm/HPUX.usfm");
var fixed_buffer_mem: [10 * 1024 * 1024]u8 = undefined;

fn tokenizeAll(allocator: std.mem.Allocator, input: [:0]const u8) !std.ArrayList(Token).Slice {
    var tokenizer = Tokenizer.init(input);

    var tokens = std.ArrayList(Token).init(allocator);
    var eof = false;
    while (!eof) {
        const token: Token = tokenizer.next();
        eof = token.tag == .eof;
        try tokens.append(token);
    }
    return tokens.toOwnedSlice();
}

fn testOnce() !usize {
    var fixed_buffer_alloc = std.heap.FixedBufferAllocator.init(fixed_buffer_mem[0..]);
    const allocator = fixed_buffer_alloc.allocator();
    _ = try tokenizeAll(allocator, source);
    return fixed_buffer_alloc.end_index;
}

pub fn testByIterations() !void {
    std.debug.print("file size: {:.2}\n", .{fmtIntSizeBin(source.len)});
    const iteration_list = [_]u16{ 1, 10, 100 };
    for (iteration_list) |iterations| {
        var i: usize = 0;
        var timer = try std.time.Timer.start();
        const start = timer.lap();
        var memory_used: usize = 0;
        while (i < iterations) : (i += 1) {
            memory_used += try testOnce();
        }
        const end = timer.read();
        memory_used /= iterations;
        const elapsed_s = @as(f64, @floatFromInt(end - start)) / std.time.ns_per_s;
        const bytes_per_sec_float = @as(f64, @floatFromInt(source.len * iterations)) / elapsed_s;
        const bytes_per_sec = @as(u64, @intFromFloat(@floor(bytes_per_sec_float)));

        std.debug.print("iterations: {d}\n", .{iterations});
        std.debug.print("parsing speed: {:.2}/s\n", .{fmtIntSizeBin(bytes_per_sec)});
        std.debug.print("memory used: {:.2}\n", .{fmtIntSizeBin(memory_used)});
    }
}
