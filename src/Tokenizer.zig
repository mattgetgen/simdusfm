const std = @import("std");

const Tokenizer = @This();

buffer: [:0]const u8,
index: usize,
state: State,

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
        backslash,
        forwardslash,
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
        comment, // TODO: in the future, don't tokenize comments.
        /// MARKERS
        marker_invalid,
        marker_text,
        marker_z_text,
    };
};

/// For debugging purposes.
pub fn dump(self: *Tokenizer, token: *const Token) void {
    std.debug.print("k: {s}\tv:\"{s}\"\n", .{ @tagName(token.tag), self.buffer[token.loc.start..token.loc.end] });
}

pub fn init(buffer: [:0]const u8) Tokenizer {
    return .{
        .buffer = buffer,
        .index = 0,
        .state = .start,
    };
}

const State = enum {
    start,
    ensure_carriage_return,
    search_until_not_number,
    search_until_not_text,
    marker_first,
    marker_capture_text,
    marker_last,
    tokenize_until_whitespace,
    skip_until_newline,
    invalid_found,
};

pub fn next(self: *Tokenizer) Token {
    var result: Token = .{
        .tag = .invalid,
        .loc = .{
            .start = self.index,
            .end = self.index,
        },
    };
    state: switch (self.state) {
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
            // single character tokens
            '/' => {
                result.tag = .forwardslash;
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
            '"' => {
                result.tag = .double_quote;
                self.index += 1;
                break :state;
            },
            '\\' => {
                self.index += 1;
                result.tag = .backslash;
                self.state = .marker_first;
                break :state;
            },
            '0'...'9' => {
                result.tag = .number;
                self.index += 1;
                continue :state .search_until_not_text;
            },
            '#' => {
                result.tag = .comment;
                self.index += 1;
                continue :state .skip_until_newline;
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
        .search_until_not_text => switch (self.buffer[self.index]) {
            0, '\r', '\n', '/', '\\', '|', ':', ';', '~', '*', '+', '-', '=', '"', '0'...'9' => {
                break :state;
            },
            else => {
                self.index += 1;
                continue :state .search_until_not_text;
            },
        },
        .marker_first => {
            self.state = .start;
            switch (self.buffer[self.index]) {
                'a'...'y', 'A'...'Z' => {
                    result.tag = .marker_text;
                    self.index += 1;
                    continue :state .marker_capture_text;
                },
                // Any token that starts with 'z' is a user-generated token type
                // that can't be parsed here.
                'z' => {
                    result.tag = .marker_z_text;
                    self.index += 1;
                    continue :state .tokenize_until_whitespace;
                },
                '+' => {
                    result.tag = .plus;
                    self.index += 1;
                    self.state = .marker_first;
                    break :state;
                },
                '*' => {
                    result.tag = .asterisk;
                    self.index += 1;
                    break :state;
                },
                else => {
                    self.index += 1;
                    result.tag = .marker_invalid;
                    continue :state .tokenize_until_whitespace;
                },
            }
        },
        .marker_capture_text => switch (self.buffer[self.index]) {
            'a'...'z', 'A'...'Z', '0'...'9', '-' => {
                self.index += 1;
                continue :state .marker_capture_text;
            },
            else => {
                self.state = .marker_last;
                break :state;
            },
        },
        .marker_last => {
            self.state = .start;
            switch (self.buffer[self.index]) {
                '*' => {
                    result.tag = .asterisk;
                    self.index += 1;
                    break :state;
                },
                else => continue :state .start,
            }
        },
        .tokenize_until_whitespace => switch (self.buffer[self.index]) {
            ' ', '\t', '\r', '\n' => break :state,
            else => {
                self.index += 1;
                continue :state .tokenize_until_whitespace;
            },
        },
        .skip_until_newline => switch (self.buffer[self.index]) {
            // TODO: switch out these two after ensuring comments are correct.
            // '\r', '\n' => continue :state .start,
            '\r', '\n' => break :state,
            else => {
                self.index += 1;
                continue :state .skip_until_newline;
            },
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
