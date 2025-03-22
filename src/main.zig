const std = @import("std");
const tkn = @import("tokenizer.zig");
const Tokenizer = tkn.Tokenizer;
const Token = tkn.Token;

const dirpath = "/home/mgetgen/repos/example_usfm/HPUX/";

// const Token = struct {
//     type: TokenType,
//     start: usize,
//     end: usize,
//
//     const TokenType = enum {
//         invalid,
//         eof,
//         plus,
//         minus,
//         number,
//         marker,
//         marker_invalid,
//         text,
//         /// IDENTIFICATION  Markers
//         m_id,
//         m_usfm,
//         m_ide,
//         m_sts,
//         m_rem,
//         m_h,
//         m_hN,
//         m_tocN,
//         m_tocaN,
//         /// INTRODUCTION Markers
//         m_imtN,
//         m_isN,
//         m_ip,
//         m_ipi,
//         m_im,
//         m_imi,
//         m_ipq,
//         m_imq,
//         m_ipr,
//         m_iqN,
//         m_ib,
//         m_iliN,
//         m_iot,
//         m_ioN,
//         m_ior,
//         m_ior_close,
//         m_iqt,
//         m_iqt_close,
//         m_iex,
//         m_imteN,
//         m_ie,
//         /// TITLE, HEADING, LABEL Markers
//         m_mtN,
//         m_mteN,
//         m_msN,
//         m_mr,
//         m_sN,
//         m_sr,
//         m_r,
//         /// also a cross-reference marker
//         m_rq,
//         m_rq_close,
//         m_d,
//         m_sp,
//         m_sdN,
//         /// CHAPTER, VERSE Markers
//         m_c,
//         m_ca,
//         m_ca_close,
//         m_cl,
//         m_cp,
//         m_cd,
//         m_v,
//         m_va,
//         m_va_close,
//         m_vp,
//         m_vp_close,
//         /// PARAGRAPH Markers
//         m_p,
//         m_m,
//         m_po,
//         m_pr,
//         m_cls,
//         m_pmo,
//         m_pm,
//         m_pmc,
//         m_pmr,
//         m_piN,
//         m_mi,
//         m_nb,
//         m_pc,
//         m_phN,
//         /// also a poetry marker
//         m_b,
//         /// POETRY Markers
//         m_qN,
//         m_qr,
//         m_qc,
//         m_qs,
//         m_qs_close,
//         m_qa,
//         m_qac,
//         m_qac_close,
//         m_qmN,
//         m_qd,
//         /// LIST Markers
//         m_lh,
//         m_liN,
//         m_lf,
//         m_limN,
//         m_litl,
//         m_litl_close,
//         m_lik,
//         m_lik_close,
//         m_livN,
//         m_livN_close,
//         /// TABLE Markers
//         m_tr,
//         m_thN,
//         m_thrN,
//         m_tcN,
//         m_tcrN,
//         /// FOOTNOTE Markers
//         m_f,
//         m_f_close,
//         m_fe,
//         m_fe_close,
//         m_fr,
//         m_fq,
//         m_fqa,
//         m_fk,
//         m_fl,
//         m_fw,
//         m_fp,
//         m_fv,
//         m_fv_close,
//         m_ft,
//         m_fdc,
//         m_fdc_close,
//         m_fm,
//         m_fm_close,
//         /// CROSS REFERENCE Markers
//         m_x,
//         m_x_close,
//         m_xo,
//         m_xk,
//         m_xq,
//         m_xt,
//         m_xta,
//         m_xop,
//         m_xop_close,
//         m_xot,
//         m_xot_close,
//         m_xnt,
//         m_xnt_close,
//         m_xdc,
//         m_xdc_close,
//         /// SPECIAL TEXT Markers
//         m_add,
//         m_add_close,
//         m_bk,
//         m_bk_close,
//         m_dc,
//         m_dc_close,
//         m_k,
//         m_k_close,
//         m_lit,
//         m_nd,
//         m_nd_close,
//         m_ord,
//         m_ord_close,
//         m_pn,
//         m_pn_close,
//         m_png,
//         m_png_close,
//         m_addpn,
//         m_addpn_close,
//         m_qt,
//         m_qt_close,
//         m_sig,
//         m_sig_close,
//         m_sls,
//         m_sls_close,
//         m_tl,
//         m_tl_close,
//         m_wj,
//         m_wj_close,
//         /// CHARACTER STYLING Markers
//         m_em,
//         m_em_close,
//         m_bd,
//         m_bd_close,
//         m_it,
//         m_it_close,
//         m_bdit,
//         m_bdit_close,
//         m_no,
//         m_no_close,
//         m_sc,
//         m_sc_close,
//         m_sup,
//         m_sup_close,
//         /// PAGE BREAK Marker
//         m_page_break,
//         /// SPECIAL FEATURE Markers
//         m_fig,
//         m_fig_close,
//         m_ndx,
//         m_ndx_close,
//         m_rb,
//         m_rb_close,
//         m_pro,
//         m_pro_close,
//         m_w,
//         m_w_close,
//         m_wg,
//         m_wg_close,
//         m_wh,
//         m_wh_close,
//         m_wa,
//         m_wa_close,
//         /// LINK Markers
//         m_jmp,
//         m_jmp_close,
//         /// MILESTONE Markers
//         m_qtN_s,
//         m_qtN_e,
//         m_ts_s,
//         m_ts_e,
//         m_close,
//         /// EXTENDED FOOTNOTE Markers
//         m_ef,
//         m_ef_close,
//         /// EXTENDED CROSS REFERENCE Markers
//         m_ex,
//         m_ex_close,
//         /// SIDEBAR Markers
//         m_esb,
//         m_esbe,
//         /// CONTENT CATEGORY Markers
//         m_cat,
//         m_cat_close,
//         /// PERIPHERAL Marker
//         m_periph,
//         /// LINE AND FORMATTING Characters
//         tilde,
//         line_break,
//     };
//     fn untokenize(allocator: std.mem.Allocator, m: TokenType, n: ?u8) !?[]const u8 {
//         return switch (m) {
//             .invalid => null,
//             .m_id => "\\id",
//             .m_usfm => "\\usfm",
//             .m_ide => "\\ide",
//             .m_sts => "\\sts",
//             .m_rem => "\\rem",
//             .m_hN => {
//                 if (n == null) "\\h" else try std.fmt.allocPrint(allocator, "\\h{d}", .{n.?});
//             },
//             .m_tocN => {
//                 if (n == null) "\\toc" else try std.fmt.allocPrint(allocator, "\\toc{d}", .{n.?});
//             },
//             .m_tocaN => {
//                 if (n == null) "\\toca" else try std.fmt.allocPrint(allocator, "\\toca{d}", .{n.?});
//             },
//             .m_imtN => {
//                 if (n == null) "\\imt" else try std.fmt.allocPrint(allocator, "\\imt{d}", .{n.?});
//             },
//             .m_isN => {
//                 if (n == null) "\\is" else try std.fmt.allocPrint(allocator, "\\is{d}", .{n.?});
//             },
//             .m_ip => "\\ip",
//             .m_ipi => "\\ipi",
//             .m_im => "\\im",
//             .m_imi => "\\imi",
//             .m_ipq => "\\ipq",
//             .m_imq => "\\imq",
//             .m_ipr => "\\ipr",
//             .m_iqN => {
//                 if (n == null) "\\iq" else try std.fmt.allocPrint(allocator, "\\iq{d}", .{n.?});
//             },
//             .m_ib => "\\ib",
//             .m_iliN => {
//                 if (n == null) "\\ili" else try std.fmt.allocPrint(allocator, "\\ili{d}", .{n.?});
//             },
//             .m_iot => "\\iot",
//             .m_ioN => {
//                 if (n == null) "\\io" else try std.fmt.allocPrint(allocator, "\\io{d}", .{n.?});
//             },
//             .m_ior => "\\ior",
//             .m_ior_close => "\\ior*",
//             .m_iqt => "\\iqt",
//             .m_iqt_close => "\\iqt*",
//             .m_iex => "\\iex",
//             .m_imteN => {
//                 if (n == null) "\\imte" else try std.fmt.allocPrint(allocator, "\\imte{d}", .{n.?});
//             },
//             .m_ie => "\\ie",
//             .m_mtN => {
//                 if (n == null) "\\mt" else try std.fmt.allocPrint(allocator, "\\mt{d}", .{n.?});
//             },
//             .m_mteN => {
//                 if (n == null) "\\mte" else try std.fmt.allocPrint(allocator, "\\mte{d}", .{n.?});
//             },
//             .m_msN => {
//                 if (n == null) "\\ms" else try std.fmt.allocPrint(allocator, "\\ms{d}", .{n.?});
//             },
//             .m_mr => "\\mr",
//             .m_sN => {
//                 if (n == null) "\\s" else try std.fmt.allocPrint(allocator, "\\s{d}", .{n.?});
//             },
//             .m_sr => "\\sr",
//             .m_r => "\\r",
//             .m_rq => "\\rq",
//             .m_rq_close => "\\rq*",
//             .m_d => "\\d",
//             .m_sp => "\\sp",
//             .m_sdN => {
//                 if (n == null) "\\sd" else try std.fmt.allocPrint(allocator, "\\sd{d}", .{n.?});
//             },
//             .m_c => "\\c",
//             .m_ca => "\\ca",
//             .m_ca_close => "\\ca*",
//             .m_cl => "\\cl",
//             .m_cp => "\\cp",
//             .m_cd => "\\cd",
//             .m_v => "\\v",
//             .m_va => "\\va",
//             .m_va_close => "\\va*",
//             .m_vp => "\\vp",
//             .m_vp_close => "\\vp*",
//             .m_p => "\\p",
//             .m_m => "\\m",
//             .m_po => "\\po",
//             .m_pr => "\\pr",
//             .m_cls => "\\cls",
//             .m_pmo => "\\pmo",
//             .m_pm => "\\pm",
//             .m_pmc => "\\pmc",
//             .m_pmr => "\\pmr",
//             .m_piN => {
//                 if (n == null) "\\pi" else try std.fmt.allocPrint(allocator, "\\pi{d}", .{n.?});
//             },
//             .m_mi => "\\mi",
//             .m_nb => "\\nb",
//             .m_pc => "\\pc",
//             .m_phN => {
//                 if (n == null) "\\ph" else try std.fmt.allocPrint(allocator, "\\ph{d}", .{n.?});
//             },
//             .m_b => "\\b",
//             .m_qN => {
//                 if (n == null) "\\q" else try std.fmt.allocPrint(allocator, "\\q{d}", .{n.?});
//             },
//             .m_qr => "\\qr",
//             .m_qc => "\\qc",
//             .m_qs => "\\qs",
//             .m_qs_close => "\\qs*",
//             .m_qa => "\\qa",
//             .m_qac => "\\qac",
//             .m_qac_close => "\\qac*",
//             .m_qmN => {
//                 if (n == null) "\\qm" else try std.fmt.allocPrint(allocator, "\\qm{d}", .{n.?});
//             },
//             .m_qd => "\\qd",
//             .m_lh => "\\lh",
//             .m_liN => {
//                 if (n == null) "\\li" else try std.fmt.allocPrint(allocator, "\\li{d}", .{n.?});
//             },
//             .m_lf => "\\lf",
//             .m_limN => {
//                 if (n == null) "\\lim" else try std.fmt.allocPrint(allocator, "\\lim{d}", .{n.?});
//             },
//             .m_litl => "\\litl",
//             .m_litl_close => "\\litl*",
//             .m_lik => "\\lik",
//             .m_lik_close => "\\lik*",
//             .m_livN => {
//                 if (n == null) "\\liv" else try std.fmt.allocPrint(allocator, "\\liv{d}", .{n.?});
//             },
//             .m_livN_close => {
//                 if (n == null) "\\liv*" else try std.fmt.allocPrint(allocator, "\\liv{d}*", .{n.?});
//             },
//             .m_tr => "\\tr",
//             .m_thN => {
//                 if (n == null) "\\th" else try std.fmt.allocPrint(allocator, "\\th{d}", .{n.?});
//             },
//             .m_thrN => {
//                 if (n == null) "\\thr" else try std.fmt.allocPrint(allocator, "\\thr{d}", .{n.?});
//             },
//             .m_tcN => {
//                 if (n == null) "\\tc" else try std.fmt.allocPrint(allocator, "\\tc{d}", .{n.?});
//             },
//             .m_tcrN => {
//                 if (n == null) "\\tcr" else try std.fmt.allocPrint(allocator, "\\tcr{d}", .{n.?});
//             },
//             .m_f => "\\f",
//             .m_f_close => "\\f*",
//             .m_fe => "\\fe",
//             .m_fe_close => "\\fe*",
//             .m_fr => "\\fr",
//             .m_fq => "\\fq",
//             .m_fqa => "\\fqa",
//             .m_fk => "\\fk",
//             .m_fl => "\\fl",
//             .m_fw => "\\fw",
//             .m_fp => "\\fp",
//             .m_fv => "\\fv",
//             .m_fv_close => "\\fv*",
//             .m_ft => "\\ft",
//             .m_fdc => "\\fdc",
//             .m_fdc_close => "\\fdc*",
//             .m_fm => "\\fm",
//             .m_fm_close => "\\fm*",
//             .m_x => "\\x",
//             .m_x_close => "\\x*",
//             .m_xo => "\\xo",
//             .m_xk => "\\xk",
//             .m_xq => "\\xq",
//             .m_xt => "\\xt",
//             .m_xta => "\\xta",
//             .m_xop => "\\xop",
//             .m_xop_close => "\\xop*",
//             .m_xot => "\\xot",
//             .m_xot_close => "\\xot*",
//             .m_xnt => "\\xnt",
//             .m_xnt_close => "\\xnt*",
//             .m_xdc => "\\xdc",
//             .m_xdc_close => "\\xdc*",
//             .m_add => "\\add",
//             .m_add_close => "\\add*",
//             .m_bk => "\\bk",
//             .m_bk_close => "\\bk*",
//             .m_dc => "\\dc",
//             .m_dc_close => "\\dc*",
//             .m_k => "\\k",
//             .m_k_close => "\\k*",
//             .m_lit => "\\lit",
//             .m_nd => "\\nd",
//             .m_nd_close => "\\nd*",
//             .m_ord => "\\ord",
//             .m_ord_close => "\\ord*",
//             .m_pn => "\\pn",
//             .m_pn_close => "\\pn*",
//             .m_png => "\\png",
//             .m_png_close => "\\png*",
//             .m_addpn => "\\addpn",
//             .m_addpn_close => "\\addpn*",
//             .m_qt => "\\qt",
//             .m_qt_close => "\\qt*",
//             .m_sig => "\\sig",
//             .m_sig_close => "\\sig*",
//             .m_sls => "\\sls",
//             .m_sls_close => "\\sls*",
//             .m_tl => "\\tl",
//             .m_tl_close => "\\tl*",
//             .m_wj => "\\wj",
//             .m_wj_close => "\\wj*",
//             .m_em => "\\em",
//             .m_em_close => "\\em*",
//             .m_bd => "\\bd",
//             .bm_d_close => "\\bd*",
//             .m_it => "\\it",
//             .m_it_close => "\\it*",
//             .m_bdit => "\\bdit",
//             .m_bdit_close => "\\bdit*",
//             .m_no => "\\no",
//             .m_no_close => "\\no*",
//             .m_sc => "\\sc",
//             .m_sc_close => "\\sc*",
//             .m_sup => "\\sup",
//             .m_sup_close => "\\sup*",
//             .m_page_break => "\\pb",
//             .m_fig => "\\fig",
//             .m_fig_close => "\\fig*",
//             .m_ndx => "\\ndx",
//             .m_ndx_close => "\\ndx*",
//             .m_rb => "\\rb",
//             .m_rb_close => "\\rb*",
//             .m_pro => "\\pro",
//             .m_pro_close => "\\pro*",
//             .m_w => "\\w",
//             .m_w_close => "\\w*",
//             .m_wg => "\\wg",
//             .m_wg_close => "\\wg*",
//             .m_wh => "\\wh",
//             .m_wh_close => "\\wh*",
//             .m_wa => "\\wa",
//             .m_wa_close => "\\wa*",
//             .m_jmp => "\\jmp",
//             .m_jmp_close => "\\jmp*",
//             .m_qtN_s => {
//                 if (n == null) "\\qt-s" else try std.fmt.allocPrint(allocator, "\\qt{d}-s", .{n.?});
//             },
//             .m_qtN_e => {
//                 if (n == null) "\\qt-e" else try std.fmt.allocPrint(allocator, "\\qt{d}-e", .{n.?});
//             },
//             .m_ts_s => "\\ts-s",
//             .m_ts_e => "\\ts-e",
//             .m_close => "\\*",
//             .m_ef => "\\ef",
//             .m_ef_close => "\\ef*",
//             .m_ex => "\\ex",
//             .m_ex_close => "\\ex*",
//             .m_esb => "\\esb",
//             .m_esbe => "\\esbe",
//             .m_cat => "\\cat",
//             .m_cat_close => "\\cat*",
//             .m_periph => "\\periph",
//             .tilde => "~",
//             .line_break => "//",
//         };
//     }
//     fn tokenize(allocator: std.mem.Allocator, input: []u8) ![]Token {
//         var tokens = std.ArrayList(Token).init(allocator);
//         var i: usize = 0;
//
//         // std.debug.print("Tokenizing...\n", .{});
//         sw: switch (input[i]) {
//             '\r', '\n', ' ', '\t' => {
//                 i += 1;
//                 if (i >= input.len) break :sw;
//                 continue :sw input[i];
//             },
//             '0'...'9' => {
//                 var token: Token = .{
//                     .type = .number,
//                     .start = i,
//                     .end = i,
//                 };
//                 nm: switch (input[i]) {
//                     '0'...'9' => {
//                         token.end = i;
//                         i += 1;
//                         if (i >= input.len) {
//                             try tokens.append(token);
//                             break :sw;
//                         }
//                         continue :nm input[i];
//                     },
//                     else => break :nm,
//                 }
//                 try tokens.append(token);
//                 i += 1;
//                 if (i >= input.len) break :sw;
//                 continue :sw input[i];
//             },
//             '\\' => {
//                 var token: Token = .{
//                     .type = .marker,
//                     .start = i,
//                     .end = i,
//                 };
//                 mrk: switch (input[i]) {
//                     '\\', '*', '0'...'9', 'a'...'z' => {
//                         token.end = i;
//                         i += 1;
//                         if (i >= input.len) {
//                             try tokens.append(token);
//                             break :sw;
//                         }
//                         continue :mrk input[i];
//                     },
//                     else => break :mrk,
//                 }
//                 try tokens.append(token);
//                 i += 1;
//                 if (i >= input.len) break :sw;
//                 continue :sw input[i];
//             },
//             '+' => {
//                 try tokens.append(.{ .type = .plus, .start = i, .end = i });
//                 i += 1;
//                 if (i >= input.len) break :sw;
//                 continue :sw input[i];
//             },
//             '-' => {
//                 try tokens.append(.{ .type = .minus, .start = i, .end = i });
//                 i += 1;
//                 if (i >= input.len) break :sw;
//                 continue :sw input[i];
//             },
//             '~' => {
//                 try tokens.append(.{ .type = .tilde, .start = i, .end = i });
//                 i += 1;
//                 if (i >= input.len) break :sw;
//                 continue :sw input[i];
//             },
//             else => {
//                 if (input[i] == '/' and i + 1 < input.len and input[i + 1] == '/') {
//                     try tokens.append(.{ .type = .line_break, .start = i, .end = i + 1 });
//                     i += 2;
//                 } else {
//                     if (tokens.items.len > 0 and tokens.items[tokens.items.len - 1].type == .invalid) {
//                         tokens.items[tokens.items.len - 1].end = i;
//                     } else {
//                         try tokens.append(.{ .type = .invalid, .start = i, .end = i });
//                     }
//                     i += 1;
//                 }
//                 if (i >= input.len) break :sw;
//                 continue :sw input[i];
//             },
//         }
//         return tokens.toOwnedSlice();
//     }
// };

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const start: i128 = std.time.nanoTimestamp();
    var dir = try std.fs.openDirAbsolute(dirpath, .{
        .access_sub_paths = false,
        .iterate = true,
    });
    defer dir.close();

    var totalBytes: usize = 0;
    var totalTokens: usize = 0;

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
        const bytes = metadata.size();
        totalBytes += bytes;

        const data = try file.readToEndAlloc(allocator, std.math.maxInt(u32));
        defer allocator.free(data);

        var tokenizer = Tokenizer.init(data);
        // var tokens = std.ArrayList(Token).init(allocator);
        // defer allocator.free(tokens);
        // // at least 1 token per byte
        // tokens.resize(bytes);

        var token: Token = undefined;
        while (token.tag != .eof) {
            token = tokenizer.next();
            tokenizer.dump(token);
            totalTokens += 1;
        }

        // const tokens = try Token.tokenize(allocator, data[0..]);
        // defer allocator.free(tokens);
        // totalTokens += tokens.len;
        // for (tokens) |token| {
        // if (token.type != .invalid) {
        // std.debug.print("Token: {s}\n", .{data[token.start .. token.end + 1]});
        // }
        // }
        break;
    }
    const end: i128 = std.time.nanoTimestamp();
    std.debug.print("tokenized {d} bytes into {d} tokens\n", .{ totalBytes, totalTokens });
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
    const bps = @as(f128, @floatFromInt(totalBytes)) * tempSecond;
    std.debug.print("Speed: {d:.0} Bytes per second\n", .{bps});
}
