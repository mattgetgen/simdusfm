const std = @import("std");
const Tokenizer = @import("Tokenizer.zig");
const Token = Tokenizer.Token;

const Parser = @This();

pub fn parse(allocator: std.mem.Allocator, input: [:0]const u8) !usize {
    var tokenizer = Tokenizer.init(input);

    var token_result = try tokenizer.tokenize(allocator);
    defer token_result.deinit();

    for (token_result.tokens.items) |token| {
        const row_col = token_result.get_row_col(token.loc.start);

        std.debug.print("r,c: {d},{d}\t", .{ row_col.row, row_col.col });
        tokenizer.dump(&token);
    }

    return token_result.tokens.items.len;
}
