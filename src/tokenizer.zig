const std = @import("std");
const StaticStringMap = std.static_string_map.StaticStringMap;

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
        eof,
        text,
        separator_pipe,
        separator_colon,
        caller_plus,
        caller_minus,
        caller_character,
        number,
        /// LINE AND FORMATTING Characters
        tilde,
        line_break,
        marker_backslash,
        marker_nested,
        marker_number,
        marker_start,
        marker_end,
        marker_close,
        marker_invalid,
        /// IDENTIFICATION  Markers
        marker_id,
        marker_usfm,
        marker_ide,
        marker_sts,
        marker_rem,
        marker_hN,
        marker_tocN,
        marker_tocaN,
        /// INTRODUCTION Markers
        marker_imtN,
        marker_isN,
        marker_ip,
        marker_ipi,
        marker_im,
        marker_imi,
        marker_ipq,
        marker_imq,
        marker_ipr,
        marker_iqN,
        marker_ib,
        marker_iliN,
        marker_iot,
        marker_ioN,
        marker_ior,
        marker_iqt,
        marker_iex,
        marker_imteN,
        marker_ie,
        /// TITLE, HEADING, LABEL Markers
        marker_mtN,
        marker_mteN,
        marker_msN,
        marker_mr,
        marker_sN,
        marker_sr, // TODO: parse section reference range.
        marker_r, // TODO: parse parallel passage references.
        /// also a cross-reference marker
        marker_rq, // TODO: Parse inline qutation references.
        marker_d,
        marker_sp,
        marker_sdN,
        /// CHAPTER, VERSE Markers
        marker_c,
        marker_ca,
        marker_cl,
        marker_cp,
        marker_cd,
        marker_v,
        marker_va,
        marker_vp,
        /// PARAGRAPH Markers
        marker_p,
        marker_m,
        marker_po,
        marker_pr,
        marker_cls,
        marker_pmo,
        marker_pm,
        marker_pmc,
        marker_pmr,
        marker_piN,
        marker_mi,
        marker_nb,
        marker_pc,
        marker_phN,
        /// also a poetry marker
        marker_b,
        /// POETRY Markers
        marker_qN,
        marker_qr,
        marker_qc,
        marker_qs,
        marker_qa,
        marker_qac,
        marker_qmN,
        marker_qd,
        /// LIST Markers
        marker_lh,
        marker_liN,
        marker_lf,
        marker_limN,
        marker_litl,
        marker_lik,
        marker_livN,
        /// TABLE Markers
        marker_tr,
        marker_thN,
        marker_thrN,
        marker_tcN,
        marker_tcrN,
        /// FOOTNOTE Markers
        marker_f,
        marker_fe,
        marker_fr,
        marker_fq,
        marker_fqa,
        marker_fk,
        marker_fl,
        marker_fw,
        marker_fp,
        marker_fv,
        marker_ft,
        marker_fdc,
        marker_fm,
        /// CROSS REFERENCE Markers
        marker_x,
        marker_xo, // TODO: Parse the origin reference.
        marker_xk,
        marker_xq,
        marker_xt, // TODO: Parse references.
        marker_xta,
        marker_xop,
        marker_xot,
        marker_xnt,
        marker_xdc,
        /// SPECIAL TEXT Markers
        marker_add,
        marker_bk,
        marker_dc,
        marker_k,
        marker_lit,
        marker_nd,
        marker_ord,
        marker_pn,
        marker_png,
        marker_addpn,
        marker_qt,
        marker_sig,
        marker_sls,
        marker_tl,
        marker_wj,
        /// CHARACTER STYLING Markers
        marker_em,
        marker_bd,
        marker_it,
        marker_bdit,
        marker_no,
        marker_sc,
        marker_sup,
        /// PAGE BREAK Marker
        marker_page_break,
        /// SPECIAL FEATURE Markers
        marker_fig,
        marker_ndx,
        marker_rb,
        marker_pro,
        marker_w,
        marker_wg,
        marker_wh,
        marker_wa,
        /// LINK Markers
        marker_jmp,
        /// MILESTONE Markers
        marker_qtN,
        marker_ts,
        /// EXTENDED FOOTNOTE Markers
        marker_ef,
        /// EXTENDED CROSS REFERENCE Markers
        marker_ex,
        /// SIDEBAR Markers
        marker_esb,
        marker_esbe,
        /// CONTENT CATEGORY Markers
        marker_cat,
        /// PERIPHERAL Marker
        marker_periph,
        /// EXTERNAL Marker
        marker_z,
        /// WORD-LEVEL Attributes
        attribute_lemma,
        attribute_strong,
        attribute_srcloc,
        attribute_gloss,
        attribute_link_href,
        attribute_alt,
        attribute_src,
        attribute_size,
        attribute_loc,
        attribute_copy,
        attribute_ref,
        attribute_user_defined,
        /// Book Identifiers
        book_GEN,
        book_EXO,
        book_LEV,
        book_NUM,
        book_DEU,
        book_JOS,
        book_JDG,
        book_RUT,
        book_1SA,
        book_2SA,
        book_1KI,
        book_2KI,
        book_1CH,
        book_2CH,
        book_EZR,
        book_NEH,
        book_EST,
        book_JOB,
        book_PSA,
        book_PRO,
        book_ECC,
        book_SNG,
        book_ISA,
        book_JER,
        book_LAM,
        book_EZK,
        book_DAN,
        book_HOS,
        book_JOL,
        book_AMO,
        book_OBA,
        book_JON,
        book_MIC,
        book_NAM,
        book_HAB,
        book_ZEP,
        book_HAG,
        book_ZEC,
        book_MAL,
        book_MAT,
        book_MRK,
        book_LUK,
        book_JHN,
        book_ACT,
        book_ROM,
        book_1CO,
        book_2CO,
        book_GAL,
        book_EPH,
        book_PHP,
        book_COL,
        book_1TH,
        book_2TH,
        book_1TI,
        book_2TI,
        book_TIT,
        book_PHM,
        book_HEB,
        book_JAS,
        book_1PE,
        book_2PE,
        book_1JN,
        book_2JN,
        book_3JN,
        book_JUD,
        book_REV,
        book_TOB,
        book_JDT,
        book_ESG,
        book_WIS,
        book_SIR,
        book_BAR,
        book_LJE,
        book_S3Y,
        book_SUS,
        book_BEL,
        book_1MA,
        book_2MA,
        book_3MA,
        book_4MA,
        book_1ES,
        book_2ES,
        book_MAN,
        book_PS2,
        book_EZA,
        book_5EZ,
        book_6EZ,
        book_DAG,
        book_PS3,
        book_2BA,
        book_LBA,
        book_JUB,
        book_ENO,
        book_1MQ,
        book_2MQ,
        book_3MQ,
        book_REP,
        book_4BA,
        book_LAO,
        book_FRT,
        book_BAK,
        book_OTH,
        book_INT,
        book_CNC,
        book_GLO,
        book_TDX,
        book_NDX,
        book_XXA,
        book_XXB,
        book_XXC,
        book_XXD,
        book_XXE,
        book_XXF,
        book_XXG,
        invalid_book_code,
    };

    pub const marker_identifiers = StaticStringMap(Tag).initComptime(.{
        .{ "id", .marker_id },
        .{ "usfm", .marker_usfm },
        .{ "ide", .marker_ide },
        .{ "sts", .marker_sts },
        .{ "rem", .marker_rem },
        .{ "h", .marker_hN },
        .{ "toc", .marker_tocN },
        .{ "toca", .marker_tocaN },
        .{ "imt", .marker_imtN },
        .{ "is", .marker_isN },
        .{ "ip", .marker_ip },
        .{ "ipi", .marker_ipi },
        .{ "im", .marker_im },
        .{ "imi", .marker_imi },
        .{ "ipq", .marker_ipq },
        .{ "imq", .marker_imq },
        .{ "ipr", .marker_ipr },
        .{ "iq", .marker_iqN },
        .{ "ib", .marker_ib },
        .{ "ili", .marker_iliN },
        .{ "iot", .marker_iot },
        .{ "io", .marker_ioN },
        .{ "ior", .marker_ior },
        .{ "iqt", .marker_iqt },
        .{ "iex", .marker_iex },
        .{ "imte", .marker_imteN },
        .{ "ie", .marker_ie },
        .{ "mt", .marker_mtN },
        .{ "mte", .marker_mteN },
        .{ "ms", .marker_msN },
        .{ "mr", .marker_mr },
        .{ "s", .marker_sN },
        .{ "sr", .marker_sr },
        .{ "r", .marker_r },
        .{ "rq", .marker_rq },
        .{ "d", .marker_d },
        .{ "sp", .marker_sp },
        .{ "sd", .marker_sdN },
        .{ "c", .marker_c },
        .{ "ca", .marker_ca },
        .{ "cl", .marker_cl },
        .{ "cp", .marker_cp },
        .{ "cd", .marker_cd },
        .{ "v", .marker_v },
        .{ "va", .marker_va },
        .{ "vp", .marker_vp },
        .{ "p", .marker_p },
        .{ "m", .marker_m },
        .{ "po", .marker_po },
        .{ "pr", .marker_pr },
        .{ "cls", .marker_cls },
        .{ "pmo", .marker_pmo },
        .{ "pm", .marker_pm },
        .{ "pmc", .marker_pmc },
        .{ "pmr", .marker_pmr },
        .{ "pi", .marker_piN },
        .{ "mi", .marker_mi },
        .{ "nb", .marker_nb },
        .{ "pc", .marker_pc },
        .{ "ph", .marker_phN },
        .{ "b", .marker_b },
        .{ "q", .marker_qN },
        .{ "qr", .marker_qr },
        .{ "qc", .marker_qc },
        .{ "qs", .marker_qs },
        .{ "qa", .marker_qa },
        .{ "qac", .marker_qac },
        .{ "qm", .marker_qmN },
        .{ "qd", .marker_qd },
        .{ "lh", .marker_lh },
        .{ "li", .marker_liN },
        .{ "lf", .marker_lf },
        .{ "lim", .marker_limN },
        .{ "litl", .marker_litl },
        .{ "lik", .marker_lik },
        .{ "liv", .marker_livN },
        .{ "tr", .marker_tr },
        .{ "th", .marker_thN },
        .{ "thr", .marker_thrN },
        .{ "tc", .marker_tcN },
        .{ "tcr", .marker_tcrN },
        .{ "f", .marker_f },
        .{ "fe", .marker_fe },
        .{ "fr", .marker_fr },
        .{ "fq", .marker_fq },
        .{ "fqa", .marker_fqa },
        .{ "fk", .marker_fk },
        .{ "fl", .marker_fl },
        .{ "fw", .marker_fw },
        .{ "fp", .marker_fp },
        .{ "fv", .marker_fv },
        .{ "ft", .marker_ft },
        .{ "fdc", .marker_fdc },
        .{ "fm", .marker_fm },
        .{ "x", .marker_x },
        .{ "xo", .marker_xo },
        .{ "xk", .marker_xk },
        .{ "xq", .marker_xq },
        .{ "xt", .marker_xt },
        .{ "xta", .marker_xta },
        .{ "xop", .marker_xop },
        .{ "xot", .marker_xot },
        .{ "xnt", .marker_xnt },
        .{ "xdc", .marker_xdc },
        .{ "add", .marker_add },
        .{ "bk", .marker_bk },
        .{ "dc", .marker_dc },
        .{ "k", .marker_k },
        .{ "lit", .marker_lit },
        .{ "nd", .marker_nd },
        .{ "ord", .marker_ord },
        .{ "pn", .marker_pn },
        .{ "png", .marker_png },
        .{ "addpn", .marker_addpn },
        .{ "qt", .marker_qt },
        .{ "sig", .marker_sig },
        .{ "sls", .marker_sls },
        .{ "tl", .marker_tl },
        .{ "wj", .marker_wj },
        .{ "em", .marker_em },
        .{ "bd", .marker_bd },
        .{ "it", .marker_it },
        .{ "bdit", .marker_bdit },
        .{ "no", .marker_no },
        .{ "sc", .marker_sc },
        .{ "sup", .marker_sup },
        .{ "pb", .marker_page_break },
        .{ "fig", .marker_fig },
        .{ "ndx", .marker_ndx },
        .{ "rb", .marker_rb },
        .{ "pro", .marker_pro },
        .{ "w", .marker_w },
        .{ "wg", .marker_wg },
        .{ "wh", .marker_wh },
        .{ "wa", .marker_wa },
        .{ "jmp", .marker_jmp },
        .{ "qt", .marker_qtN },
        .{ "ts", .marker_ts },
        .{ "ef", .marker_ef },
        .{ "ex", .marker_ex },
        .{ "esb", .marker_esb },
        .{ "esbe", .marker_esbe },
        .{ "cat", .marker_cat },
        .{ "periph", .marker_periph },
    });

    pub fn getMarkerIdentifier(bytes: []const u8) ?Tag {
        return marker_identifiers.get(bytes);
    }

    pub const book_codes = StaticStringMap(Tag).initComptime(.{
        .{ "GEN", .book_GEN },
        .{ "EXO", .book_EXO },
        .{ "LEV", .book_LEV },
        .{ "NUM", .book_NUM },
        .{ "DEU", .book_DEU },
        .{ "JOS", .book_JOS },
        .{ "JDG", .book_JDG },
        .{ "RUT", .book_RUT },
        .{ "1SA", .book_1SA },
        .{ "2SA", .book_2SA },
        .{ "1KI", .book_1KI },
        .{ "2KI", .book_2KI },
        .{ "1CH", .book_1CH },
        .{ "2CH", .book_2CH },
        .{ "EZR", .book_EZR },
        .{ "NEH", .book_NEH },
        .{ "EST", .book_EST },
        .{ "JOB", .book_JOB },
        .{ "PSA", .book_PSA },
        .{ "PRO", .book_PRO },
        .{ "ECC", .book_ECC },
        .{ "SNG", .book_SNG },
        .{ "ISA", .book_ISA },
        .{ "JER", .book_JER },
        .{ "LAM", .book_LAM },
        .{ "EZK", .book_EZK },
        .{ "DAN", .book_DAN },
        .{ "HOS", .book_HOS },
        .{ "JOL", .book_JOL },
        .{ "AMO", .book_AMO },
        .{ "OBA", .book_OBA },
        .{ "JON", .book_JON },
        .{ "MIC", .book_MIC },
        .{ "NAM", .book_NAM },
        .{ "HAB", .book_HAB },
        .{ "ZEP", .book_ZEP },
        .{ "HAG", .book_HAG },
        .{ "ZEC", .book_ZEC },
        .{ "MAL", .book_MAL },
        .{ "MAT", .book_MAT },
        .{ "MRK", .book_MRK },
        .{ "LUK", .book_LUK },
        .{ "JHN", .book_JHN },
        .{ "ACT", .book_ACT },
        .{ "ROM", .book_ROM },
        .{ "1CO", .book_1CO },
        .{ "2CO", .book_2CO },
        .{ "GAL", .book_GAL },
        .{ "EPH", .book_EPH },
        .{ "PHP", .book_PHP },
        .{ "COL", .book_COL },
        .{ "1TH", .book_1TH },
        .{ "2TH", .book_2TH },
        .{ "1TI", .book_1TI },
        .{ "2TI", .book_2TI },
        .{ "TIT", .book_TIT },
        .{ "PHM", .book_PHM },
        .{ "HEB", .book_HEB },
        .{ "JAS", .book_JAS },
        .{ "1PE", .book_1PE },
        .{ "2PE", .book_2PE },
        .{ "1JN", .book_1JN },
        .{ "2JN", .book_2JN },
        .{ "3JN", .book_3JN },
        .{ "JUD", .book_JUD },
        .{ "REV", .book_REV },
        .{ "TOB", .book_TOB },
        .{ "JDT", .book_JDT },
        .{ "ESG", .book_ESG },
        .{ "WIS", .book_WIS },
        .{ "SIR", .book_SIR },
        .{ "BAR", .book_BAR },
        .{ "LJE", .book_LJE },
        .{ "S3Y", .book_S3Y },
        .{ "SUS", .book_SUS },
        .{ "BEL", .book_BEL },
        .{ "1MA", .book_1MA },
        .{ "2MA", .book_2MA },
        .{ "3MA", .book_3MA },
        .{ "4MA", .book_4MA },
        .{ "1ES", .book_1ES },
        .{ "2ES", .book_2ES },
        .{ "MAN", .book_MAN },
        .{ "PS2", .book_PS2 },
        .{ "EZA", .book_EZA },
        .{ "5EZ", .book_5EZ },
        .{ "6EZ", .book_6EZ },
        .{ "DAG", .book_DAG },
        .{ "PS3", .book_PS3 },
        .{ "2BA", .book_2BA },
        .{ "LBA", .book_LBA },
        .{ "JUB", .book_JUB },
        .{ "ENO", .book_ENO },
        .{ "1MQ", .book_1MQ },
        .{ "2MQ", .book_2MQ },
        .{ "3MQ", .book_3MQ },
        .{ "REP", .book_REP },
        .{ "4BA", .book_4BA },
        .{ "LAO", .book_LAO },
        .{ "FRT", .book_FRT },
        .{ "BAK", .book_BAK },
        .{ "OTH", .book_OTH },
        .{ "INT", .book_INT },
        .{ "CNC", .book_CNC },
        .{ "GLO", .book_GLO },
        .{ "TDX", .book_TDX },
        .{ "NDX", .book_NDX },
        .{ "XXA", .book_XXA },
        .{ "XXB", .book_XXB },
        .{ "XXC", .book_XXC },
        .{ "XXD", .book_XXD },
        .{ "XXE", .book_XXE },
        .{ "XXF", .book_XXF },
        .{ "XXG", .book_XXG },
    });

    pub fn getBookCode(bytes: []const u8) ?Tag {
        return book_codes.get(bytes);
    }

    pub const word_level_attributes = StaticStringMap(Tag).initComptime(.{
        .{ "lemma", .attribute_lemma },
        .{ "strong", .attribute_strong },
        .{ "srcloc", .attribute_srcloc },
        .{ "gloss", .attribute_gloss },
        .{ "link-href", .attribute_link_href },
        .{ "alt", .attribute_alt },
        .{ "src", .attribute_src },
        .{ "size", .attribute_size },
        .{ "loc", .attribute_loc },
        .{ "copy", .attribute_copy },
        .{ "ref", .attribute_ref },
    });

    pub fn getAttribute(bytes: []const u8) ?Tag {
        return book_codes.get(bytes);
    }
};

pub const Tokenizer = struct {
    buffer: [:0]const u8,
    index: usize,
    state: State,

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
        invalid_found,
        marker_first,
        marker_characters,
        marker_check,
        marker_num,
        marker_last,
        marker_s_or_e,
        invalid_marker_found,
        look_for_book_code,
        book_code_found,
        book_code_check,
        look_for_caller,
        look_for_number,
        number_found,
        forwardslash_found,
        search_until_not_text,
    };

    pub fn next(self: *Tokenizer) Token {
        var result: Token = .{
            .tag = .stub,
            .loc = .{
                .start = self.index,
                .end = undefined,
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
                ' ', '\t', '\r', '\n' => {
                    self.index += 1;
                    result.loc.start = self.index;
                    continue :state .start;
                },
                '\\' => {
                    result.tag = .marker_backslash;
                    self.index += 1;
                    self.state = .marker_first;
                    break :state;
                },
                '~' => {
                    result.tag = .tilde;
                    self.index += 1;
                    break :state;
                },
                '/' => continue :state .forwardslash_found,
                '|' => {
                    result.tag = .separator_pipe;
                    self.index += 1;
                    break :state;
                },
                ':' => {
                    result.tag = .separator_colon;
                    self.index += 1;
                    break :state;
                },
                else => {
                    result.tag = .text;
                    self.index += 1;
                    continue :state .search_until_not_text;
                },
            },
            .marker_first => {
                self.state = .start;
                switch (self.buffer[self.index]) {
                    // no marker starts with 'g' or 'y'
                    'a'...'f', 'h'...'x' => {
                        self.index += 1;
                        continue :state .marker_characters;
                    },
                    // z is only found in the extra 'z' marker
                    'z' => {
                        result.tag = .marker_z;
                        self.index += 1;
                        continue :state .marker_characters;
                    },
                    '+' => {
                        result.tag = .marker_nested;
                        self.index += 1;
                        self.state = .marker_characters;
                        break :state;
                    },
                    '*' => {
                        result.tag = .marker_close;
                        self.index += 1;
                        break :state;
                    },
                    else => {
                        self.index += 1;
                        continue :state .invalid_marker_found;
                    },
                }
            },
            .marker_characters => {
                self.state = .start;
                switch (self.buffer[self.index]) {
                    'a'...'z' => {
                        self.index += 1;
                        continue :state .marker_characters;
                    },
                    else => {
                        continue :state .marker_check;
                    },
                }
            },
            .marker_check => {
                if (result.tag != .marker_z) {
                    result.tag = Token.getMarkerIdentifier(self.buffer[result.loc.start..self.index]) orelse .marker_invalid;
                }
                switch (result.tag) {
                    .marker_id => self.state = .look_for_book_code,
                    .marker_sts,
                    .marker_c,
                    .marker_ca,
                    .marker_v,
                    .marker_va,
                    => {
                        self.state = .look_for_number;
                    },
                    .marker_f, .marker_x => {
                        self.state = .look_for_caller;
                    },
                    else => self.state = .marker_last,
                }
                break :state;
            },
            .marker_last => {
                self.state = .start;
                // HERE BE NUMBERS, *, -s or -e, whitespace, or other.
                switch (self.buffer[self.index]) {
                    '*' => {
                        self.index += 1;
                        result.tag = .marker_close;
                        break :state;
                    },
                    '0'...'9' => {
                        self.index += 1;
                        result.tag = .marker_number;
                        continue :state .marker_num;
                    },
                    '-' => {
                        self.index += 1;
                        continue :state .marker_s_or_e;
                    },
                    else => {
                        continue :state .start;
                    },
                }
            },
            .marker_num => {
                num: switch (self.buffer[self.index]) {
                    '0'...'9' => {
                        self.index += 1;
                        continue :num self.buffer[self.index];
                    },
                    else => {
                        self.state = .marker_last;
                        break :state;
                    },
                }
            },
            .marker_s_or_e => {
                switch (self.buffer[self.index]) {
                    's' => {
                        result.tag = .marker_start;
                        self.index += 1;
                        break :state;
                    },
                    'e' => {
                        result.tag = .marker_end;
                        self.index += 1;
                        break :state;
                    },
                    else => {
                        self.index += 1;
                        continue :state .invalid_found;
                    },
                }
            },
            .invalid_marker_found => {
                result.tag = .marker_invalid;
                // self.index += 1;
                // std.debug.print("Unknown marker found: {s} @ {d}\n", .{ self.buffer[result.loc.start..self.index], result.loc.start });
                break :state;
            },
            .look_for_book_code => {
                self.state = .start;
                switch (self.buffer[self.index]) {
                    ' ', '\t', '\r', '\n' => {
                        self.index += 1;
                        result.loc.start = self.index;
                        continue :state .look_for_book_code;
                    },
                    'A'...'Z', '1'...'6' => {
                        self.index += 1;
                        continue :state .book_code_found;
                    },
                    else => break :state,
                }
            },
            .look_for_caller => {
                self.state = .start;
                switch (self.buffer[self.index]) {
                    ' ', '\t', '\r', '\n' => {
                        self.index += 1;
                        result.loc.start = self.index;
                        continue :state .look_for_caller;
                    },
                    '*' => {
                        self.state = .marker_last;
                        break :state;
                    },
                    '+' => {
                        result.tag = .caller_plus;
                    },
                    '-' => {
                        result.tag = .caller_minus;
                    },
                    'a'...'z' => {
                        result.tag = .caller_character;
                    },
                    else => {
                        // std.debug.print("Unknown caller found: {s} @ {d}\n", .{ self.buffer[result.loc.start..self.index], result.loc.start });
                        break :state;
                    },
                }
                self.index += 1;
                break :state;
            },
            .look_for_number => {
                self.state = .start;
                switch (self.buffer[self.index]) {
                    ' ', '\t', '\r', '\n' => {
                        self.index += 1;
                        result.loc.start = self.index;
                        continue :state .look_for_number;
                    },
                    '*' => {
                        self.state = .marker_last;
                        break :state;
                    },
                    '0'...'9' => {
                        result.tag = .number;
                        self.index += 1;
                        continue :state .number_found;
                    },
                    else => break :state,
                }
            },
            .book_code_found => {
                switch (self.buffer[self.index]) {
                    'A'...'Z', '1'...'6' => {
                        self.index += 1;
                        continue :state .book_code_found;
                    },
                    else => continue :state .book_code_check,
                }
            },
            .number_found => {
                switch (self.buffer[self.index]) {
                    '0'...'9' => {
                        result.tag = .number;
                        self.index += 1;
                        continue :state .number_found;
                    },
                    else => break :state,
                }
            },
            .book_code_check => {
                result.tag = Token.getBookCode(self.buffer[result.loc.start..self.index]) orelse .invalid_book_code;
                break :state;
            },
            .forwardslash_found => {
                self.index += 1;
                switch (self.buffer[self.index]) {
                    '/' => {
                        result.tag = .line_break;
                        self.index += 1;
                        break :state;
                    },
                    else => {
                        self.index -= 1;
                        continue :state .invalid_found;
                    },
                }
            },
            .search_until_not_text => {
                // TODO: redo this so that the / marker is handled correctly
                switch (self.buffer[self.index]) {
                    0, '\\', '~', '/', '\r', '\n', '|', ':' => {
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

fn mockToken(tag: Token.Tag, start: usize, end: usize) Token {
    return .{
        .tag = tag,
        .loc = .{
            .start = start,
            .end = end,
        },
    };
}

test "expect eof from empty" {
    const string: [:0]const u8 = "";
    const expect = mockToken(.eof, 0, 0);

    var tzr: Tokenizer = Tokenizer.init(string);
    const token: Token = tzr.next();

    try std.testing.expectEqual(expect, token);
}

test "skips whitespace" {
    const string: [:0]const u8 = " \t\r\n";
    const expect = mockToken(.eof, 4, 4);

    var tzr: Tokenizer = Tokenizer.init(string);
    const token: Token = tzr.next();

    try std.testing.expectEqual(expect, token);
}

test "expect tilde" {
    const string: [:0]const u8 = "~";
    const expect = mockToken(.tilde, 0, 1);

    var tzr: Tokenizer = Tokenizer.init(string);
    const token: Token = tzr.next();

    try std.testing.expectEqual(expect, token);
}

test "expect line break" {
    const string: [:0]const u8 = "//";
    const expect = mockToken(.line_break, 0, 2);

    var tzr: Tokenizer = Tokenizer.init(string);
    const token: Token = tzr.next();

    try std.testing.expectEqual(expect, token);
}

test "expect invalid marker" {
    const string: [:0]const u8 = "\\beef";
    const expect = mockToken(.marker_invalid, 0, 5);

    var tzr: Tokenizer = Tokenizer.init(string);
    const token: Token = tzr.next();

    try std.testing.expectEqual(expect, token);
}

test "expect invalid marker with y" {
    const string: [:0]const u8 = "\\yak";
    const expect = mockToken(.marker_invalid, 0, 2);

    var tzr: Tokenizer = Tokenizer.init(string);
    const token: Token = tzr.next();

    try std.testing.expectEqual(expect, token);
}

test "expect \\id marker" {
    const string: [:0]const u8 = "\\id";
    const expect = mockToken(.marker_id, 0, 3);

    var tzr: Tokenizer = Tokenizer.init(string);
    const token: Token = tzr.next();

    try std.testing.expectEqual(expect, token);
}

test "expect \\id marker followed by a valid book code" {
    const string: [:0]const u8 = "\\id GEN";
    const expectId = mockToken(.marker_id, 0, 3);
    const expectBook = mockToken(.book_GEN, 4, 7);

    var tzr: Tokenizer = Tokenizer.init(string);

    var token: Token = tzr.next();
    try std.testing.expectEqual(expectId, token);

    token = tzr.next();
    try std.testing.expectEqual(expectBook, token);
}

test "expect \\id marker followed by an invalid book code" {
    const string: [:0]const u8 = "\\id BAD";
    const expectId = mockToken(.marker_id, 0, 3);
    const expectBook = mockToken(.invalid_book_code, 4, 7);

    var tzr: Tokenizer = Tokenizer.init(string);

    var token: Token = tzr.next();
    try std.testing.expectEqual(expectId, token);

    token = tzr.next();
    try std.testing.expectEqual(expectBook, token);
}

test "expect \\h without a number after" {
    const string: [:0]const u8 = "\\h";
    const expect = mockToken(.marker_hN, 0, 2);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\h with a number after" {
    const string: [:0]const u8 = "\\h1";
    const expect = mockToken(.marker_hN, 0, 3);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\h with a long number after" {
    const string: [:0]const u8 = "\\h11111111";
    const expect = mockToken(.marker_hN, 0, 10);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\liv without a number" {
    const string: [:0]const u8 = "\\liv";
    const expect = mockToken(.marker_livN_open, 0, 4);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\liv* without a number" {
    const string: [:0]const u8 = "\\liv*";
    const expect = mockToken(.marker_livN_close, 0, 5);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\livN" {
    const string: [:0]const u8 = "\\liv5";
    const expect = mockToken(.marker_livN_open, 0, 5);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\livN*" {
    const string: [:0]const u8 = "\\liv5*";
    const expect = mockToken(.marker_livN_close, 0, 6);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\ts without -s or -e" {
    const string: [:0]const u8 = "\\ts";
    const expect = mockToken(.marker_ts, 0, 3);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\ts with -s" {
    const string: [:0]const u8 = "\\ts-s";
    const expect = mockToken(.marker_ts_s, 0, 5);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\ts with -e" {
    const string: [:0]const u8 = "\\ts-e";
    const expect = mockToken(.marker_ts_e, 0, 5);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\qt without -s or -e or number" {
    const string: [:0]const u8 = "\\qt";
    const expect = mockToken(.marker_qtN, 0, 3);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\qt without -s or -e but with a number" {
    const string: [:0]const u8 = "\\qt1";
    const expect = mockToken(.marker_qtN, 0, 4);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\qt with -s and a number" {
    const string: [:0]const u8 = "\\qt1-s";
    const expect = mockToken(.marker_qtN_s, 0, 6);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\qt with -e but and a number" {
    const string: [:0]const u8 = "\\qt1-e";
    const expect = mockToken(.marker_qtN_e, 0, 6);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\wj*" {
    const string: [:0]const u8 = "\\wj*";
    const expect = mockToken(.marker_wj_close, 0, 4);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect + caller after \\f" {
    const string: [:0]const u8 = "\\f +";
    const expectF = mockToken(.marker_f_open, 0, 2);
    const expectCaller = mockToken(.caller_plus, 3, 4);

    var tzr: Tokenizer = Tokenizer.init(string);

    var token: Token = tzr.next();
    try std.testing.expectEqual(expectF, token);

    token = tzr.next();
    try std.testing.expectEqual(expectCaller, token);
}

test "expect - caller after \\f" {
    const string: [:0]const u8 = "\\f -";
    const expectF = mockToken(.marker_f_open, 0, 2);
    const expectCaller = mockToken(.caller_minus, 3, 4);

    var tzr: Tokenizer = Tokenizer.init(string);

    var token: Token = tzr.next();
    try std.testing.expectEqual(expectF, token);

    token = tzr.next();
    try std.testing.expectEqual(expectCaller, token);
}

test "expect character caller after \\f" {
    const string: [:0]const u8 = "\\f b";
    const expectF = mockToken(.marker_f_open, 0, 2);
    const expectCaller = mockToken(.caller_character, 3, 4);

    var tzr: Tokenizer = Tokenizer.init(string);

    var token: Token = tzr.next();
    try std.testing.expectEqual(expectF, token);

    token = tzr.next();
    try std.testing.expectEqual(expectCaller, token);
}

test "expect number after \\c" {
    const string: [:0]const u8 = "\\c 1";
    const expectC = mockToken(.marker_c, 0, 2);
    const expectNumber = mockToken(.number, 3, 4);

    var tzr: Tokenizer = Tokenizer.init(string);

    var token: Token = tzr.next();
    try std.testing.expectEqual(expectC, token);

    token = tzr.next();
    try std.testing.expectEqual(expectNumber, token);
}

test "expect text" {
    const string: [:0]const u8 = "In the beginning...";
    const expect = mockToken(.text, 0, 19);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}
