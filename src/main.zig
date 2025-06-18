const std = @import("std");
const Tokenizer = @import("Tokenizer.zig");
const Token = Tokenizer.Token;
const Parser = @import("Parser.zig");
const testByIterations = @import("token_perf_test.zig").testByIterations;
const fmtIntSizeBin = std.fmt.fmtIntSizeBin;

const dirpath = "/home/mgetgen/repos/example_usfm/HPUX/";

pub fn main() !void {
    var dbg = std.heap.DebugAllocator(.{}){};
    defer _ = dbg.deinit();
    _ = dbg.detectLeaks();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer _ = arena.deinit();

    const dbg_alloc = dbg.allocator();
    const arena_alloc = arena.allocator();
    try run_std_test(dbg_alloc);
    try run_std_test(arena_alloc);

    // try testByIterations();
}

fn run_std_test(allocator: std.mem.Allocator) !void {
    var dir = try std.fs.openDirAbsolute(dirpath, .{
        .access_sub_paths = false,
        .iterate = true,
    });
    defer dir.close();

    var file_bytes = std.ArrayList([:0]const u8).init(allocator);
    defer file_bytes.deinit();

    var total_size: usize = 0;
    var total_tokens: usize = 0;
    var total_lines: usize = 0;
    var total_tokens_fast: usize = 0;

    var it = dir.iterate();
    while (try it.next()) |entry| {
        if (entry.kind != .file) {
            continue;
        }
        const paths = [_][]const u8{ dirpath, entry.name };
        const path = try std.fs.path.join(allocator, &paths);
        defer allocator.free(path);

        const file = try std.fs.openFileAbsolute(path, .{});
        defer file.close();

        const metadata = try file.metadata();
        const size = metadata.size();
        total_size += size;

        const data: [:0]const u8 = try file.readToEndAllocOptions(allocator, std.math.maxInt(u32), size, @alignOf(u8), 0);
        try file_bytes.append(data);
        // break;
    }

    // for (file_bytes.items) |data| {
    //     _ = try Parser.parse(allocator, data);
    // }
    var timer = try std.time.Timer.start();

    const noop_start = timer.lap();
    for (file_bytes.items) |data| {
        var p: usize = 0;
        for (data) |_| {
            p += 1;
        }
        std.debug.assert(p == data.len);
    }
    const noop_end = timer.lap();

    const start = timer.lap();
    for (file_bytes.items) |bytes| {
        var tokenizer = Tokenizer.init(bytes);

        var token_result = try tokenizer.tokenize(allocator);
        defer token_result.deinit();

        total_tokens += token_result.tokens.items.len;
        total_lines += token_result.lines.items.len;
    }
    const end = timer.lap();

    const fast_start = timer.lap();
    for (file_bytes.items) |bytes| {
        var tokenizer = Tokenizer.init(bytes);

        var token_result = try tokenizer.tokenizeFast(allocator);
        defer token_result.deinit();

        total_tokens_fast += token_result.tokens.items.len;
    }
    const fast_end = timer.read();

    const noop_bps = calc_bps(noop_start, noop_end, total_size);
    const bps = calc_bps(start, end, total_size);
    const fast_bps = calc_bps(fast_start, fast_end, total_size);

    std.debug.print("tokenized {:.2} into {d} tokens\n", .{ fmtIntSizeBin(total_size), total_tokens });
    std.debug.print("bytes/token: {d}\n", .{total_size / total_tokens});
    std.debug.print("bytes/lines: {d}\n", .{total_size / total_lines});
    std.debug.print("noop speed: {:.2}/s\n", .{fmtIntSizeBin(noop_bps)});
    std.debug.print("parsing speed: {:.2}/s\n", .{fmtIntSizeBin(bps)});
    std.debug.print("faster parsing speed: {:.2}/s\n\n", .{fmtIntSizeBin(fast_bps)});
    for (file_bytes.items) |bytes| {
        defer allocator.free(bytes);
    }
}

fn calc_bps(start: u64, end: u64, total_size: usize) u64 {
    const elapsed_s = @as(f64, @floatFromInt(end - start)) / std.time.ns_per_s;
    const bytes_per_sec_float = @as(f64, @floatFromInt(total_size)) / elapsed_s;
    return @as(u64, @intFromFloat(@floor(bytes_per_sec_float)));
}
