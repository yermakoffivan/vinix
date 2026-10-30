// SPDX-License-Identifier: GPL-2.0-or-later
module main

const package_name = 'org.vinix.bootstrap'
const main_type = 'Lorg/vinix/bootstrap/Main;'
const direct_type = 'Lorg/vinix/bootstrap/DirectLayout;'
const alignment_type = 'Landroid/text/Layout$Alignment;'
const pass_marker = 'LAYOUT-ALIGNMENT-PASS enums nullable constructors identity spacing-bits builder-retained'
const fail_marker = 'LAYOUT-ALIGNMENT-FAIL'

fn method(signature string, locals int, body string) string {
	return '.method ${signature}\n.locals ${locals}\n${body}\n.end method\n'
}

fn checks_source() string {
	return method('private static equal(IILjava/lang/String;)V', 1, '
if-eq p0, p1, :done
new-instance v0, Ljava/lang/AssertionError;
invoke-direct {v0, p2}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V
throw v0
:done
return-void') + method('private static same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V', 1, '
if-eq p0, p1, :done
new-instance v0, Ljava/lang/AssertionError;
invoke-direct {v0, p2}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V
throw v0
:done
return-void')
}

fn verify_source() string {
	mut body := '
invoke-virtual {p0}, Landroid/text/Layout;->getText()Ljava/lang/CharSequence;
move-result-object v0
const-string v1, "alignment fixture"
const-string v2, "retained text identity"
invoke-static {v0, v1, v2}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
invoke-virtual {p0}, Landroid/text/Layout;->getPaint()Landroid/text/TextPaint;
move-result-object v0
const-string v1, "retained paint identity"
invoke-static {v0, p2, v1}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
invoke-virtual {p0}, Landroid/text/Layout;->getWidth()I
move-result v2
const/16 v0, 173
const-string v1, "retained width"
invoke-static {v2, v0, v1}, ${main_type}->equal(IILjava/lang/String;)V
invoke-virtual {p0}, Landroid/text/Layout;->getHeight()I
move-result v3
invoke-virtual {p0}, Landroid/text/Layout;->getLineCount()I
move-result v4
const/4 v0, 0
invoke-virtual {p0, v0}, Landroid/text/Layout;->getLineBaseline(I)I
move-result v5
invoke-virtual {p2}, Landroid/graphics/Paint;->getColor()I
move-result v6
invoke-virtual {p2}, Landroid/graphics/Paint;->getTextSize()F
move-result v7
invoke-static {v7}, Ljava/lang/Float;->floatToRawIntBits(F)I
move-result v7
invoke-virtual {p0}, Landroid/text/Layout;->getSpacingMultiplier()F
move-result v8
invoke-static {v8}, Ljava/lang/Float;->floatToRawIntBits(F)I
move-result v8
const-string v1, "retained spacing multiplier"
invoke-static {v8, p4, v1}, ${main_type}->equal(IILjava/lang/String;)V
invoke-virtual {p0}, Landroid/text/Layout;->getSpacing_add()F
move-result v9
invoke-static {v9}, Ljava/lang/Float;->floatToRawIntBits(F)I
move-result v9
const-string v1, "retained legacy spacing accessor raw bits"
invoke-static {v9, p3, v1}, ${main_type}->equal(IILjava/lang/String;)V
'
	for _ in 0 .. 3 {
		body += '
invoke-virtual {p0}, Landroid/text/Layout;->getAlignment()${alignment_type}
move-result-object v0
const-string v1, "alignment getter must return exact nullable enum"
invoke-static {v0, p1, v1}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
const/4 v0, 0
invoke-virtual {p0, v0}, Landroid/text/Layout;->getParagraphAlignment(I)${alignment_type}
move-result-object v0
invoke-static {v0, p1, v1}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
invoke-virtual {p0}, Landroid/text/Layout;->getSpacingAdd()F
move-result v0
invoke-static {v0}, Ljava/lang/Float;->floatToRawIntBits(F)I
move-result v0
const-string v1, "spacing getter must return exact stored raw bits"
invoke-static {v0, p3, v1}, ${main_type}->equal(IILjava/lang/String;)V
'
	}
	for getter, result in {'getWidth()I': 2, 'getHeight()I': 3, 'getLineCount()I': 4} {
		body += 'invoke-virtual {p0}, Landroid/text/Layout;->${getter}\nmove-result v0\n' +
			'const-string v1, "getter must preserve native metrics"\n' +
			'invoke-static {v0, v${result}, v1}, ${main_type}->equal(IILjava/lang/String;)V\n'
	}
	body += '
const/4 v0, 0
invoke-virtual {p0, v0}, Landroid/text/Layout;->getLineBaseline(I)I
move-result v0
const-string v1, "getter must preserve native baseline"
invoke-static {v0, v5, v1}, ${main_type}->equal(IILjava/lang/String;)V
invoke-virtual {p2}, Landroid/graphics/Paint;->getColor()I
move-result v0
const-string v1, "getter must preserve paint color"
invoke-static {v0, v6, v1}, ${main_type}->equal(IILjava/lang/String;)V
'
	for entry in [
		['getTextSize()F', 'Landroid/graphics/Paint;', 'p2', '7'],
		['getSpacingMultiplier()F', 'Landroid/text/Layout;', 'p0', '8'],
		['getSpacing_add()F', 'Landroid/text/Layout;', 'p0', '9'],
	] {
		getter, owner, receiver, result := entry[0], entry[1], entry[2], entry[3]
		body += 'invoke-virtual {${receiver}}, ${owner}->${getter}\nmove-result v0\n' +
			'invoke-static {v0}, Ljava/lang/Float;->floatToRawIntBits(F)I\nmove-result v0\n' +
			'const-string v1, "getter must preserve retained float bits"\n' +
			'invoke-static {v0, v${result}, v1}, ${main_type}->equal(IILjava/lang/String;)V\n'
	}
	body += '
invoke-virtual {p0}, Landroid/text/Layout;->getText()Ljava/lang/CharSequence;
move-result-object v0
const-string v1, "alignment fixture"
const-string v2, "getter must preserve text identity"
invoke-static {v0, v1, v2}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
invoke-virtual {p0}, Landroid/text/Layout;->getPaint()Landroid/text/TextPaint;
move-result-object v0
const-string v1, "getter must preserve paint identity"
invoke-static {v0, p2, v1}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
return-void'
	return method('private static verify(Landroid/text/Layout;${alignment_type}Landroid/text/TextPaint;II)V', 10, body)
}

struct Factory {
	owner string
	signature string
	args []string
}

fn factory_source() string {
	factories := [
		Factory{'Landroid/text/StaticLayout;', 'Ljava/lang/CharSequence;Landroid/text/TextPaint;I${alignment_type}FFZ', ['text', 'paint', 'width', 'align', 'mult', 'add', 'pad']},
		Factory{'Landroid/text/StaticLayout;', 'Ljava/lang/CharSequence;IILandroid/text/TextPaint;I${alignment_type}FFZ', ['text', 'start', 'end', 'paint', 'width', 'align', 'mult', 'add', 'pad']},
		Factory{'Landroid/text/StaticLayout;', 'Ljava/lang/CharSequence;IILandroid/text/TextPaint;I${alignment_type}FFZLandroid/text/TextUtils$TruncateAt;I', ['text', 'start', 'end', 'paint', 'width', 'align', 'mult', 'add', 'pad', 'null', 'width']},
		Factory{'Landroid/text/StaticLayout;', 'Ljava/lang/CharSequence;IILandroid/text/TextPaint;I${alignment_type}Landroid/text/TextDirectionHeuristic;FFZLandroid/text/TextUtils$TruncateAt;II', ['text', 'start', 'end', 'paint', 'width', 'align', 'null', 'mult', 'add', 'pad', 'null', 'width', 'max']},
		Factory{'Landroid/text/BoringLayout;', 'Ljava/lang/CharSequence;Landroid/text/TextPaint;I${alignment_type}FFLandroid/text/BoringLayout$Metrics;Z', ['text', 'paint', 'width', 'align', 'mult', 'add', 'metrics', 'pad']},
		Factory{direct_type, 'Ljava/lang/CharSequence;Landroid/text/TextPaint;I${alignment_type}FF', ['text', 'paint', 'width', 'align', 'mult', 'add']},
	]
	mut body := ''
	for index, factory in factories {
		if index + 1 < factories.len { body += 'const/4 v0, ${index}\nif-ne p0, v0, :factory_${index + 1}\n' }
		body += 'new-instance v0, ${factory.owner}\n'
		for offset, kind in factory.args {
			register := 'v' + (offset + 1).str()
			body += match kind {
				'text' { 'const-string ${register}, "alignment fixture"\n' }
				'paint' { 'move-object/from16 ${register}, p2\n' }
				'align' { 'move-object/from16 ${register}, p1\n' }
				'width' { 'const/16 ${register}, 173\n' }
				'mult' { 'const ${register}, 0x3fa00000\n' }
				'add' { 'invoke-static/range {p3 .. p3}, Ljava/lang/Float;->intBitsToFloat(I)F\nmove-result ${register}\n' }
				'start', 'null' { 'const/4 ${register}, 0\n' }
				'end' { 'const/16 ${register}, 17\n' }
				'pad' { 'const/4 ${register}, 1\n' }
				'max' { 'const/16 ${register}, 10\n' }
				'metrics' { 'new-instance ${register}, Landroid/text/BoringLayout$Metrics;\ninvoke-direct {${register}}, Landroid/text/BoringLayout$Metrics;-><init>()V\n' }
				else { panic('unexpected constructor argument') }
			}
		}
		body += 'invoke-direct/range {v0 .. v${factory.args.len}}, ${factory.owner}-><init>(${factory.signature})V\nreturn-object v0\n'
		if index + 1 < factories.len { body += ':factory_${index + 1}\n' }
	}
	return method('private static make(I${alignment_type}Landroid/text/TextPaint;I)Landroid/text/Layout;', 14, body)
}

fn one_source() string {
	return method('private static one(${alignment_type}I)V', 6, '
new-instance v0, Landroid/text/TextPaint;
invoke-direct {v0}, Landroid/text/TextPaint;-><init>()V
const v1, 0xff123456
invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setColor(I)V
const/high16 v1, 0x41880000
invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setTextSize(F)V
const/4 v2, 0
:factory
invoke-static {v2, p0, v0, p1}, ${main_type}->make(I${alignment_type}Landroid/text/TextPaint;I)Landroid/text/Layout;
move-result-object v3
const v5, 0x3fa00000
invoke-static {v3, p0, v0, p1, v5}, ${main_type}->verify(Landroid/text/Layout;${alignment_type}Landroid/text/TextPaint;II)V
add-int/lit8 v2, v2, 1
const/4 v4, 6
if-lt v2, v4, :factory
return-void')
}

fn builder_source() string {
	return method('private static builder()V', 10, '
new-instance v0, Landroid/text/TextPaint;
invoke-direct {v0}, Landroid/text/TextPaint;-><init>()V
const-string v1, "alignment fixture"
const/4 v2, 0
const/16 v3, 17
move-object v4, v0
const/16 v5, 173
invoke-static/range {v1 .. v5}, Landroid/text/StaticLayout$Builder;->obtain(Ljava/lang/CharSequence;IILandroid/text/TextPaint;I)Landroid/text/StaticLayout$Builder;
move-result-object v6
invoke-virtual {v6}, Landroid/text/StaticLayout$Builder;->build()Landroid/text/StaticLayout;
move-result-object v7
const/4 v2, 0
const/4 v3, 0
invoke-static {v7, v2, v0, v3, v3}, ${main_type}->verify(Landroid/text/Layout;${alignment_type}Landroid/text/TextPaint;II)V
invoke-static {}, ${alignment_type}->values()[${alignment_type}
move-result-object v8
const/4 v9, 0
:alignment
array-length v1, v8
if-ge v9, v1, :null_alignment
aget-object v2, v8, v9
invoke-virtual {v6, v2}, Landroid/text/StaticLayout$Builder;->setAlignment(${alignment_type})Landroid/text/StaticLayout$Builder;
move-result-object v2
const-string v1, "retained Builder setter identity"
invoke-static {v2, v6, v1}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
invoke-virtual {v6}, Landroid/text/StaticLayout$Builder;->build()Landroid/text/StaticLayout;
move-result-object v2
const-string v1, "retained Builder layout identity"
invoke-static {v2, v7, v1}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
const/4 v2, 0
const/4 v3, 0
invoke-static {v7, v2, v0, v3, v3}, ${main_type}->verify(Landroid/text/Layout;${alignment_type}Landroid/text/TextPaint;II)V
add-int/lit8 v9, v9, 1
goto :alignment
:null_alignment
const/4 v2, 0
invoke-virtual {v6, v2}, Landroid/text/StaticLayout$Builder;->setAlignment(${alignment_type})Landroid/text/StaticLayout$Builder;
move-result-object v2
const-string v1, "retained nullable Builder setter identity"
invoke-static {v2, v6, v1}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
const/4 v2, 0
const/4 v3, 0
invoke-static {v7, v2, v0, v3, v3}, ${main_type}->verify(Landroid/text/Layout;${alignment_type}Landroid/text/TextPaint;II)V
return-void')
}

fn tests_source() string {
	mut body := '
invoke-static {}, ${alignment_type}->values()[${alignment_type}
move-result-object v0
array-length v1, v0
const/4 v2, 5
const-string v3, "retained five Alignment enums"
invoke-static {v1, v2, v3}, ${main_type}->equal(IILjava/lang/String;)V
const/4 v1, 0
:alignment
array-length v2, v0
if-ge v1, v2, :nullable
aget-object v2, v0, v1
const v3, 0x40600000
invoke-static {v2, v3}, ${main_type}->one(${alignment_type}I)V
add-int/lit8 v1, v1, 1
goto :alignment
:nullable
const/4 v2, 0
const v3, 0x40600000
invoke-static {v2, v3}, ${main_type}->one(${alignment_type}I)V
sget-object v2, ${alignment_type}->ALIGN_NORMAL:${alignment_type}
'
	for bits in ['0x00000000', '0x80000000', '0xc0600000', '0x7fc01234', '0x7f800000', '0xff800000', '0x00000001', '0x7f7fffff'] {
		body += 'const v3, ${bits}\ninvoke-static {v2, v3}, ${main_type}->one(${alignment_type}I)V\n'
	}
	body += 'invoke-static {}, ${main_type}->builder()V\nreturn-void'
	return method('private static test()V', 4, body)
}

fn main_source() string {
	return '.class public final ${main_type}\n.super Landroid/app/Activity;\n' +
		method('public constructor <init>()V', 0, 'invoke-direct {p0}, Landroid/app/Activity;-><init>()V\nreturn-void') +
		checks_source() + verify_source() + factory_source() + one_source() + builder_source() + tests_source() +
		method('public onCreate(Landroid/os/Bundle;)V', 3, '
invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
:test_start
invoke-static {}, ${main_type}->test()V
:test_end
sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
const-string v1, "${pass_marker}"
invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V
new-instance v0, Landroid/widget/TextView;
invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
const-string v1, "Layout stored alignment and spacing passed"
invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
invoke-virtual {p0, v0}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V
return-void
.catchall {:test_start .. :test_end} :failed
:failed
move-exception v2
sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
const-string v1, "${fail_marker}"
invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V
throw v2')
}

fn fixture_sources() map[string]string {
	return {
		'org/vinix/bootstrap/Main.smali': main_source()
		'org/vinix/bootstrap/DirectLayout.smali': '.class public final ${direct_type}\n.super Landroid/text/Layout;\n' +
			method('public constructor <init>(Ljava/lang/CharSequence;Landroid/text/TextPaint;I${alignment_type}FF)V', 0,
				'invoke-direct/range {p0 .. p6}, Landroid/text/Layout;-><init>(Ljava/lang/CharSequence;Landroid/text/TextPaint;I${alignment_type}FF)V\nreturn-void')
	}
}
