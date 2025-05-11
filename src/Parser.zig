const std = @import("std");
const Tokenizer = @import("Tokenizer.zig");
const Token = Tokenizer.Token;

const Parser = @This();

pub fn parse(allocator: std.mem.Allocator, input: [:0]const u8) !usize {
    var tokens = std.ArrayList(Token).init(allocator);
    defer tokens.deinit();

    var tokenizer = Tokenizer.init(input);

    var eof = false;
    while (!eof) {
        const token = tokenizer.next();
        try tokens.append(token);
        eof = token.tag == .eof;
    }

    return tokens.items.len;
}
