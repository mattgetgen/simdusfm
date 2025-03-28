const std = @import("std");
const tkn = @import("tokenizer.zig");
const Tokenizer = tkn.Tokenizer;
const Token = tkn.Token;

const dirpath = "/home/mgetgen/repos/example_usfm/HPUX/";

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var dir = try std.fs.openDirAbsolute(dirpath, .{
        .access_sub_paths = false,
        .iterate = true,
    });
    defer dir.close();
    std.debug.print("Tag size: {d}\n", .{@sizeOf(Token.Tag)});
    std.debug.print("Token size: {d}\n", .{@sizeOf(Token)});

    // var file_sizes = std.ArrayList(usize).init(allocator);
    // defer file_sizes.deinit();
    var file_bytes = std.ArrayList([:0]u8).init(allocator);
    // defer allocator.free(file_bytes);
    defer file_bytes.deinit();

    var totalSize: usize = 0;

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
        // file_sizes.append(size);
        totalSize += size;

        const data: [:0]u8 = try file.readToEndAllocOptions(allocator, std.math.maxInt(u32), size, @alignOf(u8), 0);
        try file_bytes.append(data);

        // var tokenizer = Tokenizer.init(data);

        // var tokens = std.ArrayList(Token).init(allocator);
        // defer allocator.free(tokens);
        // at least 1 token per byte
        // tokens.resize(bytes);

        // var eof = false;
        // while (!eof) {
        //     const token = tokenizer.next();
        //     try tokens.append(token);
        //     eof = token.tag == .eof;
        //     tokenizer.dump(&token);
        // }

        // const tokens = try Token.tokenize(allocator, data[0..]);
        // defer allocator.free(tokens);
        // totalTokens += tokens.len;
        // for (tokens) |token| {
        // if (token.type != .invalid) {
        // std.debug.print("Token: {s}\n", .{data[token.start .. token.end + 1]});
        // }
        // }
        // break;
    }
    var tokens = std.ArrayList(Token).init(allocator);
    defer tokens.deinit();

    const start: i128 = std.time.nanoTimestamp();

    // for (file_sizes, file_bytes) |size, data| {
    for (file_bytes.items) |data| {
        var tokenizer = Tokenizer.init(data);

        // tokens.resize(size);

        var eof = false;
        while (!eof) {
            const token = tokenizer.next();
            try tokens.append(token);
            eof = token.tag == .eof;
            // tokenizer.dump(&token);
        }
        allocator.free(data);
    }

    const end: i128 = std.time.nanoTimestamp();

    std.debug.print("tokenized {d} bytes into {d} tokens\n", .{ totalSize, tokens.items.len });
    const elapsedNano = end - start;
    const elapsedMicro: f128 = @as(f128, @floatFromInt(elapsedNano)) / 1_000;
    const elapsedMilli: f128 = @as(f128, @floatFromInt(elapsedNano)) / 1_000_000;
    const elapsedSec: f128 = @as(f128, @floatFromInt(elapsedNano)) / 1_000_000_000;
    std.debug.print("  - in {d} ns\n", .{elapsedNano});
    std.debug.print("  - in {d:.3} us\n", .{elapsedMicro});
    std.debug.print("  - in {d:.3} ms\n", .{elapsedMilli});
    std.debug.print("  - in {d:.3} s\n", .{elapsedSec});

    // bytes/second
    // 1 byte        x bytes
    // ---------  x  --------
    // .1 second     1 second
    const tempSecond = 1 / elapsedSec;
    const bps = @as(f128, @floatFromInt(totalSize)) * tempSecond;
    std.debug.print("Speed: {d:.0} Bytes per second\n", .{bps});
}
