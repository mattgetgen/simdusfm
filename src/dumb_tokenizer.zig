const std = @import("std");
// const StaticStringMap = std.static_string_map.StaticStringMap;

pub const Token = struct {
    tag: Tag,
    loc: Loc,

    pub const Loc = struct {
        start: usize,
        end: usize,
    };

    pub const Tag = enum {
        stub,
        invalid,
        newline,
        eof,
        forwardslash,
        backslash,
        pipe,
        colon,
        semicolon,
        tilde,
        asterisk, // TODO: figure out what this character is actually called
        plus,
        minus,
        equal,
        number,
        text,
    };
};

pub const Tokenizer = struct {
    buffer: [:0]const u8,
    index: usize,

    /// For debugging purposes.
    pub fn dump(self: *Tokenizer, token: *const Token) void {
        std.debug.print("k: {s}\tv:\"{s}\"\n", .{ @tagName(token.tag), self.buffer[token.loc.start..token.loc.end] });
    }

    pub fn init(buffer: [:0]const u8) Tokenizer {
        return .{
            .buffer = buffer,
            .index = 0,
        };
    }

    const State = enum {
        start,
        ensure_carriage_return,
        search_until_not_number,
        search_until_not_text,
        invalid_found,
    };

    pub fn next(self: *Tokenizer) Token {
        var result: Token = .{
            .tag = .stub,
            .loc = .{
                .start = self.index,
                .end = undefined,
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
                    break :state;
                },
                // single-character tokens
                '/' => {
                    result.tag = .forwardslash;
                    self.index += 1;
                    break :state;
                },
                '\\' => {
                    result.tag = .backslash;
                    self.index += 1;
                    break :state;
                },
                '|' => {
                    result.tag = .pipe;
                    self.index += 1;
                    break :state;
                },
                ':' => {
                    result.tag = .colon;
                    self.index += 1;
                    break :state;
                },
                ';' => {
                    result.tag = .semicolon;
                    self.index += 1;
                    break :state;
                },
                '~' => {
                    result.tag = .tilde;
                    self.index += 1;
                    break :state;
                },
                '*' => {
                    result.tag = .asterisk;
                    self.index += 1;
                    break :state;
                },
                '+' => {
                    result.tag = .plus;
                    self.index += 1;
                    break :state;
                },
                '-' => {
                    result.tag = .minus;
                    self.index += 1;
                    break :state;
                },
                '=' => {
                    result.tag = .equal;
                    self.index += 1;
                    break :state;
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
                    break :state;
                },
                else => continue :state .invalid_found,
            },
            .search_until_not_number => switch (self.buffer[self.index]) {
                '0'...'9' => {
                    self.index += 1;
                    continue :state .search_until_not_number;
                },
                else => break :state,
            },
            .search_until_not_text => {
                switch (self.buffer[self.index]) {
                    0, ' ', '\t', '\r', '\n', '/', '\\', '|', ':', ';', '~', '*', '+', '-', '=', '0'...'9' => {
                        break :state;
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
                break :state;
            },
        }
        result.loc.end = self.index;
        return result;
    }
};
