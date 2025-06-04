const std = @import("std");
const FirstTokenizer = @import("FirstTokenizer.zig");
const FirstToken = FirstTokenizer.Token;
const DumbTokenizer = @import("DumbTokenizer.zig");
const DumbToken = DumbTokenizer.Token;
const Tokenizer = @import("Tokenizer.zig");
const Token = Tokenizer.Token;
const print = std.debug.print;
const fmtIntSizeBin = std.fmt.fmtIntSizeBin;

const source = @embedFile("usfm/HPUX.usfm");
var fixed_buffer_mem: [40 * 1024 * 1024]u8 = undefined;

const TestResult = struct {
    memory_usage: usize,
    token_count: usize,
    iterations: u16,
    type: TokenizerType,

    const TokenizerType = enum {
        First,
        Dumb,
        Final,
    };
};

fn testOnce1() !TestResult {
    var result: TestResult = undefined;
    var fixed_buffer_alloc = std.heap.FixedBufferAllocator.init(fixed_buffer_mem[0..]);
    const allocator = fixed_buffer_alloc.allocator();

    var tokenizer = FirstTokenizer.init(source);
    const tokens = try tokenizer.tokenize(allocator);

    result.token_count = tokens.items.len;
    result.memory_usage = fixed_buffer_alloc.end_index;
    return result;
}

fn testOnce2() !TestResult {
    var result: TestResult = undefined;
    var fixed_buffer_alloc = std.heap.FixedBufferAllocator.init(fixed_buffer_mem[0..]);
    const allocator = fixed_buffer_alloc.allocator();

    var tokenizer = DumbTokenizer.init(source);
    const tokens = try tokenizer.tokenize(allocator);

    result.token_count = tokens.items.len;
    result.memory_usage = fixed_buffer_alloc.end_index;
    return result;
}

fn testOnce3() !TestResult {
    var result: TestResult = undefined;
    var fixed_buffer_alloc = std.heap.FixedBufferAllocator.init(fixed_buffer_mem[0..]);
    const allocator = fixed_buffer_alloc.allocator();

    var tokenizer = Tokenizer.init(source);
    const tokens = try tokenizer.tokenize(allocator);

    result.token_count = tokens.tokens.items.len;
    result.memory_usage = fixed_buffer_alloc.end_index;
    return result;
}

pub fn testByIterations() !void {
    print("file size: {:.2}\n", .{fmtIntSizeBin(source.len)});
    print_result_title();
    const iteration_list = [_]u16{ 1, 10, 100 };

    var test_result: TestResult = .{
        .memory_usage = 0,
        .token_count = 0,
        .iterations = 0,
        .type = .First,
    };
    for (iteration_list) |iterations| {
        test_result.iterations = iterations;
        var i: usize = 0;
        var timer = try std.time.Timer.start();
        const start = timer.lap();
        while (i < iterations) : (i += 1) {
            const result = try testOnce1();
            test_result.memory_usage += result.memory_usage;
            test_result.token_count += result.token_count;
        }
        const end = timer.read();

        print_result(test_result, start, end);
        test_result.memory_usage = 0;
        test_result.token_count = 0;
    }

    test_result = .{
        .memory_usage = 0,
        .token_count = 0,
        .iterations = 0,
        .type = .Dumb,
    };
    for (iteration_list) |iterations| {
        test_result.iterations = iterations;
        var i: usize = 0;
        var timer = try std.time.Timer.start();
        const start = timer.lap();
        while (i < iterations) : (i += 1) {
            const result = try testOnce2();
            test_result.memory_usage += result.memory_usage;
            test_result.token_count += result.token_count;
        }
        const end = timer.read();

        print_result(test_result, start, end);
        test_result.memory_usage = 0;
        test_result.token_count = 0;
    }

    test_result = .{
        .memory_usage = 0,
        .token_count = 0,
        .iterations = 0,
        .type = .Final,
    };
    for (iteration_list) |iterations| {
        test_result.iterations = iterations;
        var i: usize = 0;
        var timer = try std.time.Timer.start();
        const start = timer.lap();
        while (i < iterations) : (i += 1) {
            const result = try testOnce3();
            test_result.memory_usage += result.memory_usage;
            test_result.token_count += result.token_count;
        }
        const end = timer.read();

        print_result(test_result, start, end);
        test_result.memory_usage = 0;
        test_result.token_count = 0;
    }
}

fn print_result_title() void {
    print("Tokenizer\tIterations\tMemory Usage\tToken Count\tTokenization Speed\n", .{});
}

fn print_result(tr: TestResult, start: u64, end: u64) void {
    const tokens_per_iteration = tr.token_count / tr.iterations;
    const memory_per_iteration = tr.memory_usage / tr.iterations;
    const elapsed_s = @as(f64, @floatFromInt(end - start)) / std.time.ns_per_s;
    const bytes_per_sec_float = @as(f64, @floatFromInt(source.len * tr.iterations)) / elapsed_s;
    const bytes_per_sec = @as(u64, @intFromFloat(@floor(bytes_per_sec_float)));

    print("{s}\t\t{d}\t\t{:.2}\t{d}\t\t{:.2}/s\n", .{ @tagName(tr.type), tr.iterations, fmtIntSizeBin(memory_per_iteration), tokens_per_iteration, fmtIntSizeBin(bytes_per_sec) });
}
