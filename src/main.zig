const std = @import("std");
const tkn = @import("tokenizer.zig");
const Tokenizer = tkn.Tokenizer;
const Token = tkn.Token;
const fmtIntSizeBin = std.fmt.fmtIntSizeBin;

// const dirpath = "/home/mgetgen/repos/example_usfm/HPUX/";
const source = @embedFile("usfm/HPUX.usfm");
var fixed_buffer_mem: [10 * 1024 * 1024]u8 = undefined;

pub fn main() !void {
    try testByIterations();
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // defer _ = gpa.deinit();
    //
    // const allocator = gpa.allocator();
    //
    // var dir = try std.fs.openDirAbsolute(dirpath, .{
    //     .access_sub_paths = false,
    //     .iterate = true,
    // });
    // defer dir.close();
    // std.debug.print("Tag size: {d}\n", .{@sizeOf(Token.Tag)});
    // std.debug.print("Token size: {d}\n", .{@sizeOf(Token)});
    //
    // var file_bytes = std.ArrayList([:0]u8).init(allocator);
    // defer file_bytes.deinit();
    //
    // var totalSize: usize = 0;
    //
    // var it = dir.iterate();
    // while (try it.next()) |entry| {
    //     if (entry.kind != .file) {
    //         continue;
    //     }
    //     const paths = [_][]const u8{ dirpath, entry.name };
    //     const path = try std.fs.path.join(allocator, &paths);
    //     defer allocator.free(path);
    //
    //     const file = try std.fs.openFileAbsolute(path, .{});
    //     defer file.close();
    //
    //     const metadata = try file.metadata();
    //     const size = metadata.size();
    //     totalSize += size;
    //
    //     const data: [:0]const u8 = try file.readToEndAllocOptions(allocator, std.math.maxInt(u32), size, @alignOf(u8), 0);
    //     try file_bytes.append(data);
    // }
    // var tokens = std.ArrayList(Token).init(allocator);
    // defer tokens.deinit();
    //
    // const start: i128 = std.time.nanoTimestamp();
    //
    // for (file_bytes.items) |data| {
    //     var tokenizer = Tokenizer.init(data);
    //
    //     // tokens.resize(size);
    //
    //     var eof = false;
    //     while (!eof) {
    //         const token = tokenizer.next();
    //         try tokens.append(token);
    //         eof = token.tag == .eof;
    //         switch (token.tag) {
    //             .invalid, .tilde, .marker_invalid => tokenizer.dump(&token),
    //             .book_GEN, .book_EXO, .book_LEV, .book_NUM, .book_DEU, .book_JOS, .book_JDG, .book_RUT, .book_1SA, .book_2SA, .book_1KI, .book_2KI, .book_1CH, .book_2CH, .book_EZR, .book_NEH, .book_EST, .book_JOB, .book_PSA, .book_PRO, .book_ECC, .book_SNG, .book_ISA, .book_JER, .book_LAM, .book_EZK, .book_DAN, .book_HOS, .book_JOL, .book_AMO, .book_OBA, .book_JON, .book_MIC, .book_NAM, .book_HAB, .book_ZEP, .book_HAG, .book_ZEC, .book_MAL, .book_MAT, .book_MRK, .book_LUK, .book_JHN, .book_ACT, .book_ROM, .book_1CO, .book_2CO, .book_GAL, .book_EPH, .book_PHP, .book_COL, .book_1TH, .book_2TH, .book_1TI, .book_2TI, .book_TIT, .book_PHM, .book_HEB, .book_JAS, .book_1PE, .book_2PE, .book_1JN, .book_2JN, .book_3JN, .book_JUD, .book_REV, .book_TOB, .book_JDT, .book_ESG, .book_WIS, .book_SIR, .book_BAR, .book_LJE, .book_S3Y, .book_SUS, .book_BEL, .book_1MA, .book_2MA, .book_3MA, .book_4MA, .book_1ES, .book_2ES, .book_MAN, .book_PS2, .book_EZA, .book_5EZ, .book_6EZ, .book_DAG, .book_PS3, .book_2BA, .book_LBA, .book_JUB, .book_ENO, .book_1MQ, .book_2MQ, .book_3MQ, .book_REP, .book_4BA, .book_LAO, .book_FRT, .book_BAK, .book_OTH, .book_INT, .book_CNC, .book_GLO, .book_TDX, .book_NDX, .book_XXA, .book_XXB, .book_XXC, .book_XXD, .book_XXE, .book_XXF, .book_XXG, .invalid_book_code => tokenizer.dump(&token),
    //             // else => {},
    //             else => tokenizer.dump(&token),
    //         }
    //     }
    //     allocator.free(data);
    // }
    //
    // const end: i128 = std.time.nanoTimestamp();
    //
    // std.debug.print("tokenized {d} bytes into {d} tokens\n", .{ totalSize, tokens.items.len });
    // const elapsedNano = end - start;
    // const elapsedMicro: f128 = @as(f128, @floatFromInt(elapsedNano)) / 1_000;
    // const elapsedMilli: f128 = @as(f128, @floatFromInt(elapsedNano)) / 1_000_000;
    // const elapsedSec: f128 = @as(f128, @floatFromInt(elapsedNano)) / 1_000_000_000;
    // std.debug.print("  - in {d} ns\n", .{elapsedNano});
    // std.debug.print("  - in {d:.3} us\n", .{elapsedMicro});
    // std.debug.print("  - in {d:.3} ms\n", .{elapsedMilli});
    // std.debug.print("  - in {d:.3} s\n", .{elapsedSec});
    //
    // // bytes/second
    // // 1 byte        x bytes
    // // ---------  x  --------
    // // .1 second     1 second
    // const tempSecond = 1 / elapsedSec;
    // const bps = @as(f128, @floatFromInt(totalSize)) * tempSecond;
    // std.debug.print("Speed: {d:.0} Bytes per second\n", .{bps});
}

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

fn testByIterations() !void {
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
