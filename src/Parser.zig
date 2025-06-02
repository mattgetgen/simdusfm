const std = @import("std");
const Tokenizer = @import("Tokenizer.zig");
const Token = Tokenizer.Token;

const Parser = @This();

pub fn parse(allocator: std.mem.Allocator, input: [:0]const u8) !usize {
    var tokenizer = Tokenizer.init(input);

    var tokens = try tokenizer.tokenize(allocator);
    defer tokens.deinit();

    return tokens.items.len;
}
