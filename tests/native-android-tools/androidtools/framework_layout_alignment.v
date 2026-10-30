// SPDX-License-Identifier: GPL-2.0-or-later
module androidtools

import os

// Layout already retains the exact constructor alignment and additive spacing.
// Expose them without normalizing nulls/float bits or changing the retained
// builder, legacy spacing getter, paragraph metrics or native rendering paths.
pub fn framework_layout_alignment_source(original string) !string {
	if original.split_into_lines().filter(it.starts_with('.class ')) != ['.class public Landroid/text/Layout;']
		|| original.split_into_lines().filter(it.starts_with('.super ')) != ['.super Ljava/lang/Object;'] {
		return error('canonical Layout class required')
	}
	if original.contains('getAlignment(') || original.contains('getSpacingAdd(') { return error('Layout alignment or spacing getter already present') }
	if original.split_into_lines().filter(it.starts_with('.field ') && it.all_after_last(' ') == 'align:Landroid/text/Layout$Alignment;') != ['.field private align:Landroid/text/Layout$Alignment;'] {
		return error('unique retained private alignment field required')
	}
	if original.split_into_lines().filter(it.starts_with('.field ') && it.all_after_last(' ') == 'spacing_add:F') != ['.field private spacing_add:F'] {
		return error('unique retained private spacing-add field required')
	}
	mut constructor := 0
	mut paragraph := 0
	mut spacing := 0
	for block in original.split('.method ')[1..] {
		header := block.all_before('\n')
		name := header.all_after_last(' ')
		if name !in ['<init>(Ljava/lang/CharSequence;Landroid/text/TextPaint;ILandroid/text/Layout$Alignment;FF)V', 'getParagraphAlignment(I)Landroid/text/Layout$Alignment;', 'getSpacing_add()F'] { continue }
		end := block.index('.end method') or { return error('unterminated retained Layout method') }
		lines := block[..end].split_into_lines().map(it.all_before('#').trim_space()).filter(it != '')
		if name.starts_with('<init>(') {
			constructor++
			if header != 'protected constructor ' + name
				|| lines.filter(it == 'iput-object p4, p0, Landroid/text/Layout;->align:Landroid/text/Layout$Alignment;').len != 1
				|| lines.filter(it == 'iput p6, p0, Landroid/text/Layout;->spacing_add:F').len != 1 {
				return error('retained Layout constructor alignment and spacing storage required')
			}
		} else if name.starts_with('getParagraphAlignment(') {
			paragraph++
			if lines.join('\n') != 'public getParagraphAlignment(I)Landroid/text/Layout$Alignment;\n.registers 3\niget-object v0, p0, Landroid/text/Layout;->align:Landroid/text/Layout$Alignment;\nreturn-object v0' {
				return error('retained paragraph alignment getter required')
			}
		} else {
			spacing++
			if lines.join('\n') != 'public getSpacing_add()F\n.registers 2\niget v0, p0, Landroid/text/Layout;->spacing_add:F\nreturn v0' {
				return error('retained legacy spacing-add getter required')
			}
		}
	}
	if constructor != 1 || paragraph != 1 || spacing != 1 { return error('unique retained Layout alignment/spacing methods required') }
	return original + '\n.method public final getAlignment()Landroid/text/Layout$Alignment;\n.locals 1\niget-object v0, p0, Landroid/text/Layout;->align:Landroid/text/Layout$Alignment;\nreturn-object v0\n.end method\n' +
		'\n.method public final getSpacingAdd()F\n.locals 1\niget v0, p0, Landroid/text/Layout;->spacing_add:F\nreturn v0\n.end method\n'
}

pub fn framework_layout_alignment(smali string) ! {
	path := smali + '/android/text/Layout.smali'
	os.write_file(path, framework_layout_alignment_source(os.read_file(path)!)!)!
}
