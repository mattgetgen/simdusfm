const std = @import("std");

const DumbTokenizer = @This();

buffer: [:0]const u8,
index: usize,

pub const Token = struct {
    tag: Tag,
    loc: Loc,

    pub const Loc = struct {
        start: usize,
        end: usize,
    };

    pub const Tag = enum {
        eof,
        invalid,
        newline,
        forwardslash,
        backslash,
        pipe,
        colon,
        semicolon,
        tilde,
        asterisk,
        plus,
        minus,
        equal,
        double_quote,
        number,
        text,
    };
};

pub const TokenResult = std.ArrayList(Token);

/// For debugging purposes.
pub fn dump(self: *DumbTokenizer, token: *const Token) void {
    std.debug.print("k: {s}\tv:\"{s}\"\n", .{ @tagName(token.tag), self.buffer[token.loc.start..token.loc.end] });
}

pub fn init(buffer: [:0]const u8) DumbTokenizer {
    return .{
        .buffer = buffer,
        .index = 0,
    };
}

pub fn tokenize(self: *DumbTokenizer, allocator: std.mem.Allocator) !TokenResult {
    var result = TokenResult.init(allocator);

    var eof = false;
    while (!eof) {
        const token = self.next();
        try result.append(token);
        eof = token.tag == .eof;
    }
    return result;
}

const State = enum {
    start,
    ensure_carriage_return,
    search_until_not_number,
    search_until_not_text,
    invalid_found,
    end,
};

fn next(self: *DumbTokenizer) Token {
    var result: Token = .{
        .tag = .invalid,
        .loc = .{
            .start = self.index,
            .end = self.index,
        },
    };
    state: switch (State.start) {
        .start => switch (self.buffer[self.index]) {
            0 => {
                if (self.index == self.buffer.len) {
                    result.tag = .eof;
                    break :state;
                } else {
                    continue :state .invalid_found;
                }
            },
            ' ', '\t' => {
                self.index += 1;
                result.loc.start = self.index;
                continue :state .start;
            },
            '\r' => {
                result.tag = .newline;
                self.index += 1;
                continue :state .ensure_carriage_return;
            },
            '\n' => {
                result.tag = .newline;
                self.index += 1;
                continue :state .end;
            },
            // single-character tokens
            '/' => {
                result.tag = .forwardslash;
                self.index += 1;
                continue :state .end;
            },
            '\\' => {
                result.tag = .backslash;
                self.index += 1;
                continue :state .end;
            },
            '|' => {
                result.tag = .pipe;
                self.index += 1;
                continue :state .end;
            },
            ':' => {
                result.tag = .colon;
                self.index += 1;
                continue :state .end;
            },
            ';' => {
                result.tag = .semicolon;
                self.index += 1;
                continue :state .end;
            },
            '~' => {
                result.tag = .tilde;
                self.index += 1;
                continue :state .end;
            },
            '*' => {
                result.tag = .asterisk;
                self.index += 1;
                continue :state .end;
            },
            '+' => {
                result.tag = .plus;
                self.index += 1;
                continue :state .end;
            },
            '-' => {
                result.tag = .minus;
                self.index += 1;
                continue :state .end;
            },
            '=' => {
                result.tag = .equal;
                self.index += 1;
                continue :state .end;
            },
            '"' => {
                result.tag = .double_quote;
                self.index += 1;
                continue :state .end;
            },
            '0'...'9' => {
                result.tag = .number;
                self.index += 1;
                continue :state .search_until_not_number;
            },
            else => {
                result.tag = .text;
                self.index += 1;
                continue :state .search_until_not_text;
            },
        },
        .ensure_carriage_return => switch (self.buffer[self.index]) {
            '\n' => {
                self.index += 1;
                continue :state .end;
            },
            else => continue :state .invalid_found,
        },
        .search_until_not_number => switch (self.buffer[self.index]) {
            '0'...'9' => {
                self.index += 1;
                continue :state .search_until_not_number;
            },
            else => continue :state .end,
        },
        .search_until_not_text => {
            switch (self.buffer[self.index]) {
                0, '\r', '\n', '/', '\\', '|', ':', ';', '~', '*', '+', '-', '=', '"', '0'...'9' => {
                    continue :state .end;
                },
                else => {
                    self.index += 1;
                    continue :state .search_until_not_text;
                },
            }
        },
        .invalid_found => {
            result.tag = .invalid;
            self.index += 1;
            continue :state .end;
        },
        .end => {
            result.loc.end = self.index;
            break :state;
        },
    }
    return result;
}
