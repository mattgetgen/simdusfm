const std = @import("std");
const tkn1 = @import("tokenizer.zig");
const tkn2 = @import("dumb_tokenizer.zig");
const tkn3 = @import("ideal_tokenizer.zig");
const fmtIntSizeBin = std.fmt.fmtIntSizeBin;

const source = @embedFile("usfm/HPUX.usfm");
var fixed_buffer_mem: [20 * 1024 * 1024]u8 = undefined;

const TestResult = struct {
    memory_usage: usize,
    token_count: usize,
};

fn testOnce1() !TestResult {
    var result: TestResult = undefined;
    var fixed_buffer_alloc = std.heap.FixedBufferAllocator.init(fixed_buffer_mem[0..]);
    const allocator = fixed_buffer_alloc.allocator();

    var tokenizer = tkn1.Tokenizer.init(source);
    var tokens = std.ArrayList(tkn1.Token).init(allocator);
    var eof = false;
    while (!eof) {
        const token: tkn1.Token = tokenizer.next();
        eof = token.tag == .eof;
        try tokens.append(token);
    }

    result.token_count = tokens.items.len;
    result.memory_usage = fixed_buffer_alloc.end_index;
    return result;
}

fn testOnce2() !TestResult {
    var result: TestResult = undefined;
    var fixed_buffer_alloc = std.heap.FixedBufferAllocator.init(fixed_buffer_mem[0..]);
    const allocator = fixed_buffer_alloc.allocator();

    var tokenizer = tkn2.Tokenizer.init(source);
    var tokens = std.ArrayList(tkn2.Token).init(allocator);
    var eof = false;
    while (!eof) {
        const token: tkn2.Token = tokenizer.next();
        eof = token.tag == .eof;
        try tokens.append(token);
    }

    result.token_count = tokens.items.len;
    result.memory_usage = fixed_buffer_alloc.end_index;
    return result;
}

fn testOnce3() !TestResult {
    var result: TestResult = undefined;
    var fixed_buffer_alloc = std.heap.FixedBufferAllocator.init(fixed_buffer_mem[0..]);
    const allocator = fixed_buffer_alloc.allocator();

    var tokenizer = tkn3.Tokenizer.init(source);
    var tokens = std.ArrayList(tkn3.Token).init(allocator);
    var eof = false;
    while (!eof) {
        const token: tkn3.Token = tokenizer.next();
        eof = token.tag == .eof;
        try tokens.append(token);
    }

    result.token_count = tokens.items.len;
    result.memory_usage = fixed_buffer_alloc.end_index;
    return result;
}

pub fn testByIterations() !void {
    std.debug.print("file size: {:.2}\n", .{fmtIntSizeBin(source.len)});
    const iteration_list = [_]u16{ 1, 10, 100 };

    std.debug.print("\n## Tokenizer 1 ##\n", .{});
    for (iteration_list) |iterations| {
        var i: usize = 0;
        var timer = try std.time.Timer.start();
        const start = timer.lap();
        var tokens_created: usize = 0;
        var memory_used: usize = 0;
        while (i < iterations) : (i += 1) {
            const result = try testOnce1();
            tokens_created += result.token_count;
            memory_used += result.memory_usage;
        }
        const end = timer.read();

        print_result(iterations, start, end, memory_used, tokens_created);
    }

    std.debug.print("\n## Tokenizer 2 ##\n", .{});
    for (iteration_list) |iterations| {
        var i: usize = 0;
        var timer = try std.time.Timer.start();
        const start = timer.lap();
        var tokens_created: usize = 0;
        var memory_used: usize = 0;
        while (i < iterations) : (i += 1) {
            const result = try testOnce2();
            tokens_created += result.token_count;
            memory_used += result.memory_usage;
        }
        const end = timer.read();

        print_result(iterations, start, end, memory_used, tokens_created);
    }

    std.debug.print("\n## Tokenizer 2 ##\n", .{});
    for (iteration_list) |iterations| {
        var i: usize = 0;
        var timer = try std.time.Timer.start();
        const start = timer.lap();
        var tokens_created: usize = 0;
        var memory_used: usize = 0;
        while (i < iterations) : (i += 1) {
            const result = try testOnce3();
            tokens_created += result.token_count;
            memory_used += result.memory_usage;
        }
        const end = timer.read();

        print_result(iterations, start, end, memory_used, tokens_created);
    }
}

fn print_result(iterations: u16, start: u64, end: u64, memory_used: usize, tokens_created: usize) void {
    const tokens_per_iteration = tokens_created / iterations;
    const memory_per_iteration = memory_used / iterations;
    const elapsed_s = @as(f64, @floatFromInt(end - start)) / std.time.ns_per_s;
    const bytes_per_sec_float = @as(f64, @floatFromInt(source.len * iterations)) / elapsed_s;
    const bytes_per_sec = @as(u64, @intFromFloat(@floor(bytes_per_sec_float)));

    std.debug.print("{d} iterations\n", .{iterations});
    std.debug.print("tokenization speed: {:.2}/s\n", .{fmtIntSizeBin(bytes_per_sec)});
    std.debug.print("memory used: {:.2}\n", .{fmtIntSizeBin(memory_per_iteration)});
    std.debug.print("# tokens created: {d}\n", .{tokens_per_iteration});
    std.debug.print("\n", .{});
}
