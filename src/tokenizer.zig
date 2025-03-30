const std = @import("std");

pub const Token = struct {
    tag: Tag,
    loc: Loc,

    pub const Loc = struct {
        start: usize,
        end: usize,
    };

    pub const Tag = enum {
        invalid,
        eof,
        text,
        caller_plus,
        caller_minus,
        caller_character,
        number,
        /// LINE AND FORMATTING Characters
        tilde,
        line_break,
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
        marker_ior_open,
        marker_ior_close,
        marker_iqt_open,
        marker_iqt_close,
        marker_iex,
        marker_imteN,
        marker_ie,
        /// TITLE, HEADING, LABEL Markers
        marker_mtN,
        marker_mteN,
        marker_msN,
        marker_mr,
        marker_sN,
        marker_sr,
        marker_r,
        /// also a cross-reference marker
        marker_rq_open,
        marker_rq_close,
        marker_d,
        marker_sp,
        marker_sdN,
        /// CHAPTER, VERSE Markers
        marker_c,
        marker_ca_open,
        marker_ca_close,
        marker_cl,
        marker_cp,
        marker_cd,
        marker_v,
        marker_va_open,
        marker_va_close,
        marker_vp_open,
        marker_vp_close,
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
        marker_qs_open,
        marker_qs_close,
        marker_qa,
        marker_qac_open,
        marker_qac_close,
        marker_qmN,
        marker_qd,
        /// LIST Markers
        marker_lh,
        marker_liN,
        marker_lf,
        marker_limN,
        marker_litl_open,
        marker_litl_close,
        marker_lik_open,
        marker_lik_close,
        marker_livN_open,
        marker_livN_close,
        /// TABLE Markers
        marker_tr,
        marker_thN,
        marker_thrN,
        marker_tcN,
        marker_tcrN,
        /// FOOTNOTE Markers
        marker_f_open,
        marker_f_close,
        marker_fe_open,
        marker_fe_close,
        marker_fr,
        marker_fq,
        marker_fqa,
        marker_fk,
        marker_fl,
        marker_fw,
        marker_fp,
        marker_fv_open,
        marker_fv_close,
        marker_ft,
        marker_fdc_open,
        marker_fdc_close,
        marker_fm_open,
        marker_fm_close,
        /// CROSS REFERENCE Markers
        marker_x_open,
        marker_x_close,
        marker_xo,
        marker_xk,
        marker_xq,
        marker_xt,
        marker_xta,
        marker_xop_open,
        marker_xop_close,
        marker_xot_open,
        marker_xot_close,
        marker_xnt_open,
        marker_xnt_close,
        marker_xdc_open,
        marker_xdc_close,
        /// SPECIAL TEXT Markers
        marker_add_open,
        marker_add_close,
        marker_bk_open,
        marker_bk_close,
        marker_dc_open,
        marker_dc_close,
        marker_k_open,
        marker_k_close,
        marker_lit,
        marker_nd_open,
        marker_nd_close,
        marker_ord_open,
        marker_ord_close,
        marker_pn_open,
        marker_pn_close,
        marker_png_open,
        marker_png_close,
        marker_addpn_open,
        marker_addpn_close,
        marker_qt_open,
        marker_qt_close,
        marker_sig_open,
        marker_sig_close,
        marker_sls_open,
        marker_sls_close,
        marker_tl_open,
        marker_tl_close,
        marker_wj_open,
        marker_wj_close,
        /// CHARACTER STYLING Markers
        marker_em_open,
        marker_em_close,
        marker_bd_open,
        marker_bd_close,
        marker_it_open,
        marker_it_close,
        marker_bdit_open,
        marker_bdit_close,
        marker_no_open,
        marker_no_close,
        marker_sc_open,
        marker_sc_close,
        marker_sup_open,
        marker_sup_close,
        /// PAGE BREAK Marker
        marker_page_break,
        /// SPECIAL FEATURE Markers
        marker_fig_open,
        marker_fig_close,
        marker_ndx_open,
        marker_ndx_close,
        marker_rb_open,
        marker_rb_close,
        marker_pro_open,
        marker_pro_close,
        marker_w_open,
        marker_w_close,
        marker_wg_open,
        marker_wg_close,
        marker_wh_open,
        marker_wh_close,
        marker_wa_open,
        marker_wa_close,
        /// LINK Markers
        marker_jmp_open,
        marker_jmp_close,
        /// MILESTONE Markers
        marker_qtN,
        marker_qtN_s,
        marker_qtN_e,
        marker_ts,
        marker_ts_s,
        marker_ts_e,
        marker_milestone_close,
        /// EXTENDED FOOTNOTE Markers
        marker_ef_open,
        marker_ef_close,
        /// EXTENDED CROSS REFERENCE Markers
        marker_ex_open,
        marker_ex_close,
        /// SIDEBAR Markers
        marker_esb,
        marker_esbe,
        /// CONTENT CATEGORY Markers
        marker_cat_open,
        marker_cat_close,
        /// PERIPHERAL Marker
        marker_periph,
        /// EXTERNAL Marker
        marker_z,
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

    pub const marker_identifiers = std.static_string_map.StaticStringMap(Tag).initComptime(.{
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
        .{ "ior", .marker_ior_open },
        .{ "iqt", .marker_iqt_open },
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
        .{ "rq", .marker_rq_open },
        .{ "d", .marker_d },
        .{ "sp", .marker_sp },
        .{ "sd", .marker_sdN },
        .{ "c", .marker_c },
        .{ "ca", .marker_ca_open },
        .{ "cl", .marker_cl },
        .{ "cp", .marker_cp },
        .{ "cd", .marker_cd },
        .{ "v", .marker_v },
        .{ "va", .marker_va_open },
        .{ "vp", .marker_vp_open },
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
        .{ "qs", .marker_qs_open },
        .{ "qa", .marker_qa },
        .{ "qac", .marker_qac_open },
        .{ "qm", .marker_qmN },
        .{ "qd", .marker_qd },
        .{ "lh", .marker_lh },
        .{ "li", .marker_liN },
        .{ "lf", .marker_lf },
        .{ "lim", .marker_limN },
        .{ "litl", .marker_litl_open },
        .{ "lik", .marker_lik_open },
        .{ "liv", .marker_livN_open },
        .{ "tr", .marker_tr },
        .{ "th", .marker_thN },
        .{ "thr", .marker_thrN },
        .{ "tc", .marker_tcN },
        .{ "tcr", .marker_tcrN },
        .{ "f", .marker_f_open },
        .{ "fe", .marker_fe_open },
        .{ "fr", .marker_fr },
        .{ "fq", .marker_fq },
        .{ "fqa", .marker_fqa },
        .{ "fk", .marker_fk },
        .{ "fl", .marker_fl },
        .{ "fw", .marker_fw },
        .{ "fp", .marker_fp },
        .{ "fv", .marker_fv_open },
        .{ "ft", .marker_ft },
        .{ "fdc", .marker_fdc_open },
        .{ "fm", .marker_fm_open },
        .{ "x", .marker_x_open },
        .{ "xo", .marker_xo },
        .{ "xk", .marker_xk },
        .{ "xq", .marker_xq },
        .{ "xt", .marker_xt },
        .{ "xta", .marker_xta },
        .{ "xop", .marker_xop_open },
        .{ "xot", .marker_xot_open },
        .{ "xnt", .marker_xnt_open },
        .{ "xdc", .marker_xdc_open },
        .{ "add", .marker_add_open },
        .{ "bk", .marker_bk_open },
        .{ "dc", .marker_dc_open },
        .{ "k", .marker_k_open },
        .{ "lit", .marker_lit },
        .{ "nd", .marker_nd_open },
        .{ "ord", .marker_ord_open },
        .{ "pn", .marker_pn_open },
        .{ "png", .marker_png_open },
        .{ "addpn", .marker_addpn_open },
        .{ "qt", .marker_qt_open },
        .{ "sig", .marker_sig_open },
        .{ "sls", .marker_sls_open },
        .{ "tl", .marker_tl_open },
        .{ "wj", .marker_wj_open },
        .{ "em", .marker_em_open },
        .{ "bd", .marker_bd_open },
        .{ "it", .marker_it_open },
        .{ "bdit", .marker_bdit_open },
        .{ "no", .marker_no_open },
        .{ "sc", .marker_sc_open },
        .{ "sup", .marker_sup_open },
        .{ "page_break", .marker_page_break },
        .{ "fig", .marker_fig_open },
        .{ "ndx", .marker_ndx_open },
        .{ "rb", .marker_rb_open },
        .{ "pro", .marker_pro_open },
        .{ "w", .marker_w_open },
        .{ "wg", .marker_wg_open },
        .{ "wh", .marker_wh_open },
        .{ "wa", .marker_wa_open },
        .{ "jmp", .marker_jmp_open },
        .{ "qt", .marker_qtN },
        .{ "ts", .marker_ts },
        .{ "*", .marker_milestone_close },
        .{ "ef", .marker_ef_open },
        .{ "ex", .marker_ex_open },
        .{ "esb", .marker_esb },
        .{ "esbe", .marker_esbe },
        .{ "cat", .marker_cat_open },
        .{ "periph", .marker_periph },
    });

    pub fn getMarkerIdentifier(bytes: []const u8) ?Tag {
        return marker_identifiers.get(bytes);
    }

    pub const book_codes = std.static_string_map.StaticStringMap(Tag).initComptime(.{
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
        marker_start,
        marker_characters,
        marker_check,
        marker_end,
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
            .tag = undefined,
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
                    result.loc.start = self.index;
                    self.index += 1;
                    continue :state .marker_start;
                },
                '~' => {
                    result.tag = .tilde;
                    result.loc.start = self.index;
                    self.index += 1;
                    break :state;
                },
                '/' => continue :state .forwardslash_found,
                else => {
                    self.index += 1;
                    result.tag = .text;
                    continue :state .search_until_not_text;
                },
            },
            .marker_start => {
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
                    '*' => {
                        result.tag = .marker_milestone_close;
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
                if (result.tag == .marker_z) break :state;
                result.tag = Token.getMarkerIdentifier(self.buffer[result.loc.start + 1 .. self.index]) orelse .marker_invalid;
                continue :state .marker_end;
            },
            .marker_end => {
                // HERE BE NUMBERS, *, -s or -e, whitespace, or other.
                switch (result.tag) {
                    .marker_invalid => continue :state .invalid_marker_found,
                    .marker_id => {
                        self.state = .look_for_book_code;
                        break :state;
                    },
                    .marker_hN, .marker_tocN, .marker_tocaN, .marker_imtN, .marker_isN, .marker_iqN, .marker_iliN, .marker_ioN, .marker_imteN, .marker_mtN, .marker_mteN, .marker_msN, .marker_sN, .marker_sdN, .marker_piN, .marker_phN, .marker_qN, .marker_qmN, .marker_liN, .marker_limN, .marker_thN, .marker_thrN, .marker_tcN, .marker_tcrN => {
                        num: switch (self.buffer[self.index]) {
                            '0'...'9' => {
                                self.index += 1;
                                continue :num self.buffer[self.index];
                            },
                            else => break :state,
                        }
                    },
                    .marker_livN_open => {
                        num: switch (self.buffer[self.index]) {
                            '0'...'9' => {
                                self.index += 1;
                                continue :num self.buffer[self.index];
                            },
                            '*' => {
                                result.tag = .marker_livN_close;
                                self.index += 1;
                                break :state;
                            },
                            else => break :state,
                        }
                    },
                    .marker_ts => {
                        switch (self.buffer[self.index]) {
                            '-' => {
                                self.index += 1;
                                continue :state .marker_s_or_e;
                            },
                            else => break :state,
                        }
                    },
                    .marker_qtN => {
                        // TODO: redo this branch
                        num: switch (self.buffer[self.index]) {
                            '0'...'9' => {
                                self.index += 1;
                                continue :num self.buffer[self.index];
                            },
                            '-' => {
                                self.index += 1;
                                continue :state .marker_s_or_e;
                            },
                            else => break :state,
                        }
                    },
                    .marker_ior_open, .marker_iqt_open, .marker_rq_open, .marker_vp_open, .marker_qs_open, .marker_qac_open, .marker_litl_open, .marker_lik_open, .marker_fdc_open, .marker_fm_open, .marker_xop_open, .marker_xot_open, .marker_xnt_open, .marker_xdc_open, .marker_add_open, .marker_bk_open, .marker_dc_open, .marker_k_open, .marker_nd_open, .marker_ord_open, .marker_pn_open, .marker_png_open, .marker_addpn_open, .marker_qt_open, .marker_sig_open, .marker_sls_open, .marker_tl_open, .marker_wj_open, .marker_em_open, .marker_bd_open, .marker_it_open, .marker_bdit_open, .marker_no_open, .marker_sc_open, .marker_sup_open, .marker_fig_open, .marker_ndx_open, .marker_rb_open, .marker_pro_open, .marker_w_open, .marker_wg_open, .marker_wh_open, .marker_wa_open, .marker_jmp_open, .marker_ef_open, .marker_ex_open, .marker_cat_open => {
                        switch (self.buffer[self.index]) {
                            '*' => {
                                const int = @intFromEnum(result.tag) + 1;
                                result.tag = @enumFromInt(int);
                                self.index += 1;
                                break :state;
                            },
                            else => break :state,
                        }
                    },
                    .marker_f_open, .marker_fe_open, .marker_x_open => {
                        switch (self.buffer[self.index]) {
                            '*' => {
                                const int = @intFromEnum(result.tag) + 1;
                                result.tag = @enumFromInt(int);
                                self.index += 1;
                                break :state;
                            },
                            else => {
                                self.state = .look_for_caller;
                                break :state;
                            },
                        }
                    },
                    .marker_ca_open, .marker_va_open, .marker_fv_open => {
                        switch (self.buffer[self.index]) {
                            '*' => {
                                const int = @intFromEnum(result.tag) + 1;
                                result.tag = @enumFromInt(int);
                                self.index += 1;
                                break :state;
                            },
                            else => {
                                self.state = .look_for_number;
                                break :state;
                            },
                        }
                    },
                    .marker_c, .marker_v => {
                        self.state = .look_for_number;
                        break :state;
                    },
                    else => break :state,
                }
            },
            .marker_s_or_e => {
                switch (self.buffer[self.index]) {
                    's' => {
                        const int = @intFromEnum(result.tag) + 1;
                        result.tag = @enumFromInt(int);
                        self.index += 1;
                        break :state;
                    },
                    'e' => {
                        const int = @intFromEnum(result.tag) + 2;
                        result.tag = @enumFromInt(int);
                        self.index += 1;
                        break :state;
                    },
                    else => {
                        self.index += 1;
                        continue :state .invalid_marker_found;
                    },
                }
            },
            .invalid_marker_found => {
                result.tag = .marker_invalid;
                // self.index += 1;
                std.debug.print("Unknown marker found: {s} @ {d}\n", .{ self.buffer[result.loc.start..self.index], result.loc.start });
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
                        std.debug.print("Unknown caller found: {s} @ {d}\n", .{ self.buffer[result.loc.start..self.index], result.loc.start });
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
                    0, '\\', '~', '/', '\r', '\n' => {
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

fn testingToken(tag: Token.Tag, start: usize, end: usize) Token {
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
    const expect = testingToken(.eof, 0, 0);

    var tzr: Tokenizer = Tokenizer.init(string);
    const token: Token = tzr.next();

    try std.testing.expectEqual(expect, token);
}

test "skips whitespace" {
    const string: [:0]const u8 = " \t\r\n";
    const expect = testingToken(.eof, 4, 4);

    var tzr: Tokenizer = Tokenizer.init(string);
    const token: Token = tzr.next();

    try std.testing.expectEqual(expect, token);
}

test "expect tilde" {
    const string: [:0]const u8 = "~";
    const expect = testingToken(.tilde, 0, 1);

    var tzr: Tokenizer = Tokenizer.init(string);
    const token: Token = tzr.next();

    try std.testing.expectEqual(expect, token);
}

test "expect line break" {
    const string: [:0]const u8 = "//";
    const expect = testingToken(.line_break, 0, 2);

    var tzr: Tokenizer = Tokenizer.init(string);
    const token: Token = tzr.next();

    try std.testing.expectEqual(expect, token);
}

test "expect invalid marker" {
    const string: [:0]const u8 = "\\beef";
    const expect = testingToken(.marker_invalid, 0, 5);

    var tzr: Tokenizer = Tokenizer.init(string);
    const token: Token = tzr.next();

    try std.testing.expectEqual(expect, token);
}

test "expect invalid marker with y" {
    const string: [:0]const u8 = "\\yak";
    const expect = testingToken(.marker_invalid, 0, 2);

    var tzr: Tokenizer = Tokenizer.init(string);
    const token: Token = tzr.next();

    try std.testing.expectEqual(expect, token);
}

test "expect \\id marker" {
    const string: [:0]const u8 = "\\id";
    const expect = testingToken(.marker_id, 0, 3);

    var tzr: Tokenizer = Tokenizer.init(string);
    const token: Token = tzr.next();

    try std.testing.expectEqual(expect, token);
}

test "expect \\id marker followed by a valid book code" {
    const string: [:0]const u8 = "\\id GEN";
    const expectId = testingToken(.marker_id, 0, 3);
    const expectBook = testingToken(.book_GEN, 4, 7);

    var tzr: Tokenizer = Tokenizer.init(string);

    var token: Token = tzr.next();
    try std.testing.expectEqual(expectId, token);

    token = tzr.next();
    try std.testing.expectEqual(expectBook, token);
}

test "expect \\id marker followed by an invalid book code" {
    const string: [:0]const u8 = "\\id BAD";
    const expectId = testingToken(.marker_id, 0, 3);
    const expectBook = testingToken(.invalid_book_code, 4, 7);

    var tzr: Tokenizer = Tokenizer.init(string);

    var token: Token = tzr.next();
    try std.testing.expectEqual(expectId, token);

    token = tzr.next();
    try std.testing.expectEqual(expectBook, token);
}

test "expect \\h without a number after" {
    const string: [:0]const u8 = "\\h";
    const expect = testingToken(.marker_hN, 0, 2);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\h with a number after" {
    const string: [:0]const u8 = "\\h1";
    const expect = testingToken(.marker_hN, 0, 3);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\h with a long number after" {
    const string: [:0]const u8 = "\\h11111111";
    const expect = testingToken(.marker_hN, 0, 10);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\liv without a number" {
    const string: [:0]const u8 = "\\liv";
    const expect = testingToken(.marker_livN_open, 0, 4);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\liv* without a number" {
    const string: [:0]const u8 = "\\liv*";
    const expect = testingToken(.marker_livN_close, 0, 5);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\livN" {
    const string: [:0]const u8 = "\\liv5";
    const expect = testingToken(.marker_livN_open, 0, 5);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\livN*" {
    const string: [:0]const u8 = "\\liv5*";
    const expect = testingToken(.marker_livN_close, 0, 6);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\ts without -s or -e" {
    const string: [:0]const u8 = "\\ts";
    const expect = testingToken(.marker_ts, 0, 3);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\ts with -s" {
    const string: [:0]const u8 = "\\ts-s";
    const expect = testingToken(.marker_ts_s, 0, 5);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\ts with -e" {
    const string: [:0]const u8 = "\\ts-e";
    const expect = testingToken(.marker_ts_e, 0, 5);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\qt without -s or -e or number" {
    const string: [:0]const u8 = "\\qt";
    const expect = testingToken(.marker_qtN, 0, 3);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\qt without -s or -e but with a number" {
    const string: [:0]const u8 = "\\qt1";
    const expect = testingToken(.marker_qtN, 0, 4);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\qt with -s and a number" {
    const string: [:0]const u8 = "\\qt1-s";
    const expect = testingToken(.marker_qtN_s, 0, 6);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\qt with -e but and a number" {
    const string: [:0]const u8 = "\\qt1-e";
    const expect = testingToken(.marker_qtN_e, 0, 6);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect \\wj*" {
    const string: [:0]const u8 = "\\wj*";
    const expect = testingToken(.marker_wj_close, 0, 4);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}

test "expect + caller after \\f" {
    const string: [:0]const u8 = "\\f +";
    const expectF = testingToken(.marker_f_open, 0, 2);
    const expectCaller = testingToken(.caller_plus, 3, 4);

    var tzr: Tokenizer = Tokenizer.init(string);

    var token: Token = tzr.next();
    try std.testing.expectEqual(expectF, token);

    token = tzr.next();
    try std.testing.expectEqual(expectCaller, token);
}

test "expect - caller after \\f" {
    const string: [:0]const u8 = "\\f -";
    const expectF = testingToken(.marker_f_open, 0, 2);
    const expectCaller = testingToken(.caller_minus, 3, 4);

    var tzr: Tokenizer = Tokenizer.init(string);

    var token: Token = tzr.next();
    try std.testing.expectEqual(expectF, token);

    token = tzr.next();
    try std.testing.expectEqual(expectCaller, token);
}

test "expect character caller after \\f" {
    const string: [:0]const u8 = "\\f b";
    const expectF = testingToken(.marker_f_open, 0, 2);
    const expectCaller = testingToken(.caller_character, 3, 4);

    var tzr: Tokenizer = Tokenizer.init(string);

    var token: Token = tzr.next();
    try std.testing.expectEqual(expectF, token);

    token = tzr.next();
    try std.testing.expectEqual(expectCaller, token);
}

test "expect number after \\c" {
    const string: [:0]const u8 = "\\c 1";
    const expectC = testingToken(.marker_c, 0, 2);
    const expectNumber = testingToken(.number, 3, 4);

    var tzr: Tokenizer = Tokenizer.init(string);

    var token: Token = tzr.next();
    try std.testing.expectEqual(expectC, token);

    token = tzr.next();
    try std.testing.expectEqual(expectNumber, token);
}

test "expect text" {
    const string: [:0]const u8 = "In the beginning...";
    const expect = testingToken(.text, 0, 19);

    var tzr: Tokenizer = Tokenizer.init(string);

    const token: Token = tzr.next();
    try std.testing.expectEqual(expect, token);
}
