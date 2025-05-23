const std = @import("std");
const Tokenizer = @import("Tokenizer.zig");
const Token = Tokenizer.Token;
const Parser = @import("Parser.zig");
const testByIterations = @import("token_perf_test.zig").testByIterations;
const fmtIntSizeBin = std.fmt.fmtIntSizeBin;

const dirpath = "/home/mgetgen/repos/example_usfm/HPUX/";

pub fn main() !void {
    try run_std_test();
    // try testByIterations();
}

fn run_std_test() !void {
    var dbg = std.heap.DebugAllocator(.{}){};
    defer _ = dbg.deinit();
    _ = dbg.detectLeaks();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer _ = arena.deinit();

    // const allocator = dbg.allocator();
    const allocator = arena.allocator();

    var dir = try std.fs.openDirAbsolute(dirpath, .{
        .access_sub_paths = false,
        .iterate = true,
    });
    defer dir.close();

    var file_bytes = std.ArrayList([:0]const u8).init(allocator);
    defer file_bytes.deinit();

    var total_size: usize = 0;
    var total_tokens: usize = 0;

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
        defer allocator.free(bytes);

        total_tokens += try Parser.parse(allocator, bytes);
    }

    // var tokens = std.ArrayList(Token).init(allocator);
    // defer tokens.deinit();
    // defer allocator.free(data);
    // var tokenizer = Tokenizer.init(data);

    // var prev_end: usize = 0;
    // var eof = false;
    // var check_next: u8 = 0;
    // while (!eof) {
    //     const token = tokenizer.next();
    //     try tokens.append(token);
    //     eof = token.tag == .eof;
    //     const space_between = data[prev_end..token.loc.start];
    //     var ok: bool = true;
    //     for (space_between) |byte| {
    //         if ((byte != ' ') and (byte != '\t') and (byte != '\r') and (byte != '\n')) {
    //             ok = false;
    //             break;
    //         }
    //     }
    //     if (!ok) {
    //         std.debug.print("not tokenized: {x}\n", .{space_between});
    //     }
    //     prev_end = token.loc.end;
    // switch (token.tag) {
    //     .invalid, .tilde, .marker_invalid => tokenizer.dump(&token),
    //
    //     // .marker_w, .marker_rb, .marker_fig => {
    //     .marker_w => {
    //         check_next = 4;
    //     },
    //     // .book_GEN, .book_EXO, .book_LEV, .book_NUM, .book_DEU, .book_JOS, .book_JDG, .book_RUT, .book_1SA, .book_2SA, .book_1KI, .book_2KI, .book_1CH, .book_2CH, .book_EZR, .book_NEH, .book_EST, .book_JOB, .book_PSA, .book_PRO, .book_ECC, .book_SNG, .book_ISA, .book_JER, .book_LAM, .book_EZK, .book_DAN, .book_HOS, .book_JOL, .book_AMO, .book_OBA, .book_JON, .book_MIC, .book_NAM, .book_HAB, .book_ZEP, .book_HAG, .book_ZEC, .book_MAL, .book_MAT, .book_MRK, .book_LUK, .book_JHN, .book_ACT, .book_ROM, .book_1CO, .book_2CO, .book_GAL, .book_EPH, .book_PHP, .book_COL, .book_1TH, .book_2TH, .book_1TI, .book_2TI, .book_TIT, .book_PHM, .book_HEB, .book_JAS, .book_1PE, .book_2PE, .book_1JN, .book_2JN, .book_3JN, .book_JUD, .book_REV, .book_TOB, .book_JDT, .book_ESG, .book_WIS, .book_SIR, .book_BAR, .book_LJE, .book_S3Y, .book_SUS, .book_BEL, .book_1MA, .book_2MA, .book_3MA, .book_4MA, .book_1ES, .book_2ES, .book_MAN, .book_PS2, .book_EZA, .book_5EZ, .book_6EZ, .book_DAG, .book_PS3, .book_2BA, .book_LBA, .book_JUB, .book_ENO, .book_1MQ, .book_2MQ, .book_3MQ, .book_REP, .book_4BA, .book_LAO, .book_FRT, .book_BAK, .book_OTH, .book_INT, .book_CNC, .book_GLO, .book_TDX, .book_NDX, .book_XXA, .book_XXB, .book_XXC, .book_XXD, .book_XXE, .book_XXF, .book_XXG, .invalid_book_code => tokenizer.dump(&token),
    //     else => {},
    //     // else => tokenizer.dump(&token),
    // }
    // if (check_next > 0) {
    //     switch (token.tag) {
    //         .text => {
    //             tokenizer.dump(&token);
    //         },
    //         .marker_close => check_next = 0,
    //         else => {},
    //     }
    //     if (check_next > 0) {
    //         check_next -= 1;
    //     }
    // }
    // }
    // print_all_debug(tokenizer, tokens.items);
    // total_tokens += tokens.items.len;
    const end = timer.read();
    const noop_bps = calc_bps(noop_start, noop_end, total_size);
    const bps = calc_bps(start, end, total_size);

    std.debug.print("tokenized {:.2} into {d} tokens\n", .{ fmtIntSizeBin(total_size), total_tokens });
    std.debug.print("noop speed: {:.2}/s\n", .{fmtIntSizeBin(noop_bps)});
    std.debug.print("parsing speed: {:.2}/s\n", .{fmtIntSizeBin(bps)});
}

fn calc_bps(start: u64, end: u64, total_size: usize) u64 {
    const elapsed_s = @as(f64, @floatFromInt(end - start)) / std.time.ns_per_s;
    const bytes_per_sec_float = @as(f64, @floatFromInt(total_size)) / elapsed_s;
    return @as(u64, @intFromFloat(@floor(bytes_per_sec_float)));
}
