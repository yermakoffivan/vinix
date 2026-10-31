// SPDX-License-Identifier: GPL-2.0-or-later
module main

const package_name = 'org.vinix.bootstrap'
const main_type = 'Lorg/vinix/bootstrap/Main;'
const spy_type = 'Lorg/vinix/bootstrap/FloatResources;'
const pass_marker = 'RESOURCES-FLOAT-PASS packaged-floats aliases strict-types virtual-lookup raw-bits unchanged-values failures'
const fail_marker = 'RESOURCES-FLOAT-FAIL'

fn method(signature string, locals int, body string) string {
	return '.method ${signature}\n.locals ${locals}\n${body}\n.end method\n'
}

fn resource_values() string {
	return '<resources>' +
		'<item name="float_positive" type="dimen" format="float">1.25</item>' +
		'<item name="float_negative" type="dimen" format="float">-2.5</item>' +
		'<item name="float_zero" type="dimen" format="float">0.0</item>' +
		'<item name="float_negative_zero" type="dimen" format="float">-0.0</item>' +
		'<item name="float_alias" type="dimen">@dimen/float_positive</item>' +
		'<item name="float_alias_chain" type="dimen">@dimen/float_alias</item>' +
		'<dimen name="wrong_dimension">2dp</dimen>' +
		'<fraction name="wrong_fraction">25%</fraction>' +
		'<integer name="wrong_integer">42</integer>' +
		'<bool name="wrong_boolean">true</bool>' +
		'<color name="wrong_color">#80102030</color>' +
		'<string name="wrong_string">1.25</string>' +
		'<item name="wrong_alias" type="dimen">@dimen/wrong_dimension</item>' +
		'</resources>'
}

fn resource_names() []string {
	return ['dimen/float_positive', 'dimen/float_negative', 'dimen/float_zero',
		'dimen/float_negative_zero', 'dimen/float_alias', 'dimen/float_alias_chain',
		'dimen/wrong_dimension', 'fraction/wrong_fraction', 'integer/wrong_integer',
		'bool/wrong_boolean', 'color/wrong_color', 'string/wrong_string', 'dimen/wrong_alias'].sorted()
}

// The signed APK dump must identify every exact ID/name and retain the real
// reference chain. Runtime getValue checks establish the resolved value types.
fn verify_resource_dump(resource_text string, ids map[string]string) {
	mut blocks := map[string]string{}
	mut current := ''
	for line in resource_text.split_into_lines() {
		text := line.trim_space()
		if text.starts_with('resource ') {
			parts := text.fields()
			assert parts.len == 3 && parts[2] in ids, 'known scalar resource dump entry required: ' + text
			current = parts[2]
			assert current !in blocks && parts[1] == ids[current], 'exact unique resource dump ID required'
			blocks[current] = ''
		} else if current != '' { blocks[current] += text + '\n' }
	}
	assert blocks.keys().sorted() == resource_names(), 'signed resource dump membership differs'
	for source, target in {'dimen/float_alias': 'dimen/float_positive',
		'dimen/float_alias_chain': 'dimen/float_alias', 'dimen/wrong_alias': 'dimen/wrong_dimension'} {
		assert blocks[source].contains(ids[target]) || blocks[source].contains('@' + target), 'signed alias target differs: ' + source
	}
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
return-void') + method('private static fail(Ljava/lang/String;)V', 1, '
new-instance v0, Ljava/lang/AssertionError;
invoke-direct {v0, p0}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V
throw v0')
}

fn float_source() string {
	return method('private static bits(Landroid/content/res/Resources;IILjava/lang/String;)V', 1, '
invoke-virtual {p0, p1}, Landroid/content/res/Resources;->getFloat(I)F
move-result v0
invoke-static {v0}, Ljava/lang/Float;->floatToRawIntBits(F)I
move-result v0
invoke-static {v0, p2, p3}, ${main_type}->equal(IILjava/lang/String;)V
return-void') + method('private static missing(Landroid/content/res/Resources;I)V', 1, '
:lookup_start
invoke-virtual {p0, p1}, Landroid/content/res/Resources;->getFloat(I)F
move-result v0
:lookup_end
const-string v0, "missing resource must throw NotFoundException"
invoke-static {v0}, ${main_type}->fail(Ljava/lang/String;)V
return-void
.catch Landroid/content/res/Resources$NotFoundException; {:lookup_start .. :lookup_end} :expected
:expected
move-exception v0
return-void') + method('private static wrong(Landroid/content/res/Resources;II)V', 3, '
:lookup_start
invoke-virtual {p0, p1}, Landroid/content/res/Resources;->getFloat(I)F
move-result v0
:lookup_end
const-string v0, "non-float resource must throw NotFoundException"
invoke-static {v0}, ${main_type}->fail(Ljava/lang/String;)V
return-void
.catch Landroid/content/res/Resources$NotFoundException; {:lookup_start .. :lookup_end} :expected
:expected
move-exception v0
invoke-virtual {v0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;
move-result-object v0
new-instance v1, Ljava/lang/StringBuilder;
invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V
const-string v2, "Resource ID #0x"
invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
invoke-static {p1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;
move-result-object v2
invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
const-string v2, " type #0x"
invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
invoke-static {p2}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;
move-result-object v2
invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
const-string v2, " is not valid"
invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
move-result-object v1
invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
move-result v0
const/4 v1, 1
const-string v2, "wrong-type message must retain original ID and resolved type"
invoke-static {v0, v1, v2}, ${main_type}->equal(IILjava/lang/String;)V
return-void')
}

fn spy_source() string {
	mut result := '.class public final ${spy_type}\n.super Landroid/content/res/Resources;\n'
	for field in ['modeType:I', 'modeData:I', 'calls:I', 'lastId:I', 'lastResolve:Z',
		'lastValue:Landroid/util/TypedValue;', 'failure:Ljava/lang/RuntimeException;'] {
		result += '.field public ' + field + '\n'
	}
	result += method('public constructor <init>(Landroid/content/res/Resources;)V', 3, '
invoke-virtual {p1}, Landroid/content/res/Resources;->getAssets()Landroid/content/res/AssetManager;
move-result-object v0
invoke-virtual {p1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
move-result-object v1
invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;
move-result-object v2
invoke-direct {p0, v0, v1, v2}, Landroid/content/res/Resources;-><init>(Landroid/content/res/AssetManager;Landroid/util/DisplayMetrics;Landroid/content/res/Configuration;)V
return-void') + method('public getValue(ILandroid/util/TypedValue;Z)V', 1, '
iget v0, p0, ${spy_type}->calls:I
add-int/lit8 v0, v0, 1
iput v0, p0, ${spy_type}->calls:I
iput p1, p0, ${spy_type}->lastId:I
iput-boolean p3, p0, ${spy_type}->lastResolve:Z
iput-object p2, p0, ${spy_type}->lastValue:Landroid/util/TypedValue;
iget-object v0, p0, ${spy_type}->failure:Ljava/lang/RuntimeException;
if-eqz v0, :fill
throw v0
:fill
iget v0, p0, ${spy_type}->modeType:I
iput v0, p2, Landroid/util/TypedValue;->type:I
iget v0, p0, ${spy_type}->modeData:I
iput v0, p2, Landroid/util/TypedValue;->data:I
const/16 v0, 0x1234
iput v0, p2, Landroid/util/TypedValue;->assetCookie:I
const v0, 0x7f0d0456
iput v0, p2, Landroid/util/TypedValue;->resourceId:I
const/16 v0, 0x141
iput v0, p2, Landroid/util/TypedValue;->density:I
const/16 v0, 0x2468
iput v0, p2, Landroid/util/TypedValue;->changingConfigurations:I
const-string v0, "typedvalue-sentinel"
iput-object v0, p2, Landroid/util/TypedValue;->string:Ljava/lang/CharSequence;
return-void')
	return result
}

fn state_source() string {
	mut body := ''
	for field, expected in {'calls:I': '1', 'lastId:I': '0x7f123456', 'lastResolve:Z': '1'} {
		op := if field.ends_with(':Z') { 'iget-boolean' } else { 'iget' }
		body += '${op} v0, p0, ${spy_type}->${field}\nconst v1, ${expected}\nconst-string v2, "virtual lookup must run once with original ID and resolveRefs true"\ninvoke-static {v0, v1, v2}, ${main_type}->equal(IILjava/lang/String;)V\n'
	}
	body += 'iget-object v3, p0, ${spy_type}->lastValue:Landroid/util/TypedValue;\nif-nez v3, :has_value\nconst-string v0, "lookup must receive a non-null TypedValue"\ninvoke-static {v0}, ${main_type}->fail(Ljava/lang/String;)V\n:has_value\n'
	for field, expected in {'type:I': 'p1', 'data:I': 'p2'} {
		body += 'iget v0, v3, Landroid/util/TypedValue;->${field}\nconst-string v2, "getFloat must retain supplied TypedValue type and bits"\ninvoke-static {v0, ${expected}, v2}, ${main_type}->equal(IILjava/lang/String;)V\n'
	}
	for field, expected in {'assetCookie:I': '0x1234', 'resourceId:I': '0x7f0d0456', 'density:I': '0x141', 'changingConfigurations:I': '0x2468'} {
		body += 'iget v0, v3, Landroid/util/TypedValue;->${field}\nconst v1, ${expected}\nconst-string v2, "getFloat must retain supplied TypedValue metadata"\ninvoke-static {v0, v1, v2}, ${main_type}->equal(IILjava/lang/String;)V\n'
	}
	body += 'iget-object v0, v3, Landroid/util/TypedValue;->string:Ljava/lang/CharSequence;\nconst-string v1, "typedvalue-sentinel"\nconst-string v2, "getFloat must retain supplied TypedValue string identity"\ninvoke-static {v0, v1, v2}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V\nreturn-void'
	return method('private static state(${spy_type}II)V', 4, body)
}

fn probe_source() string {
	return method('private static probe(${spy_type}II)V', 3, '
const/4 v0, 0
iput v0, p0, ${spy_type}->calls:I
iput-object v0, p0, ${spy_type}->failure:Ljava/lang/RuntimeException;
iput p1, p0, ${spy_type}->modeType:I
iput p2, p0, ${spy_type}->modeData:I
const v0, 0x7f123456
const/4 v1, 4
if-ne p1, v1, :wrong_type
const-string v2, "TYPE_FLOAT must preserve raw float bits"
invoke-static {p0, v0, p2, v2}, ${main_type}->bits(Landroid/content/res/Resources;IILjava/lang/String;)V
goto :checked
:wrong_type
invoke-static {p0, v0, p1}, ${main_type}->wrong(Landroid/content/res/Resources;II)V
:checked
invoke-static {p0, p1, p2}, ${main_type}->state(${spy_type}II)V
return-void') + method('private static failure(${spy_type}Ljava/lang/RuntimeException;)V', 3, '
const/4 v0, 0
iput v0, p0, ${spy_type}->calls:I
iput-object p1, p0, ${spy_type}->failure:Ljava/lang/RuntimeException;
const v0, 0x7f123456
:lookup_start
invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getFloat(I)F
move-result v0
:lookup_end
const-string v0, "lookup exception must propagate"
invoke-static {v0}, ${main_type}->fail(Ljava/lang/String;)V
return-void
.catch Ljava/lang/RuntimeException; {:lookup_start .. :lookup_end} :expected
:expected
move-exception v0
const-string v2, "lookup exception object must retain exact identity"
invoke-static {v0, p1, v2}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
iget v0, p0, ${spy_type}->calls:I
const/4 v1, 1
const-string v2, "failed lookup must run once"
invoke-static {v0, v1, v2}, ${main_type}->equal(IILjava/lang/String;)V
iget v0, p0, ${spy_type}->lastId:I
const v1, 0x7f123456
const-string v2, "failed lookup must retain ID"
invoke-static {v0, v1, v2}, ${main_type}->equal(IILjava/lang/String;)V
iget-boolean v0, p0, ${spy_type}->lastResolve:Z
const/4 v1, 1
const-string v2, "failed lookup must resolve references"
invoke-static {v0, v1, v2}, ${main_type}->equal(IILjava/lang/String;)V
const/4 v0, 0
iput-object v0, p0, ${spy_type}->failure:Ljava/lang/RuntimeException;
return-void')
}

fn packaged_source(ids map[string]string) string {
	mut body := ''
	for name, bits in {'dimen/float_positive': '0x3fa00000', 'dimen/float_negative': '0xc0200000',
		'dimen/float_zero': '0', 'dimen/float_negative_zero': '0x80000000',
		'dimen/float_alias': '0x3fa00000', 'dimen/float_alias_chain': '0x3fa00000'} {
		body += 'const v0, ${ids[name]}\nconst v1, ${bits}\nconst-string v2, "packaged float/alias must preserve raw bits: ${name}"\ninvoke-static {p0, v0, v1, v2}, ${main_type}->bits(Landroid/content/res/Resources;IILjava/lang/String;)V\n'
		body += 'new-instance v3, Landroid/util/TypedValue;\ninvoke-direct {v3}, Landroid/util/TypedValue;-><init>()V\nconst/4 v2, 1\ninvoke-virtual {p0, v0, v3, v2}, Landroid/content/res/Resources;->getValue(ILandroid/util/TypedValue;Z)V\niget v0, v3, Landroid/util/TypedValue;->data:I\nconst-string v2, "packaged final resource must retain expected float data"\ninvoke-static {v0, v1, v2}, ${main_type}->equal(IILjava/lang/String;)V\niget v0, v3, Landroid/util/TypedValue;->type:I\nconst/4 v2, 4\nconst-string v3, "packaged final resource must be TYPE_FLOAT"\ninvoke-static {v0, v2, v3}, ${main_type}->equal(IILjava/lang/String;)V\n'
	}
	for name, kind in {'dimen/wrong_dimension': 5, 'dimen/wrong_alias': 5, 'fraction/wrong_fraction': 6,
		'integer/wrong_integer': 16, 'bool/wrong_boolean': 18, 'color/wrong_color': 28, 'string/wrong_string': 3} {
		body += 'const v0, ${ids[name]}\nconst/16 v1, ${kind}\ninvoke-static {p0, v0, v1}, ${main_type}->wrong(Landroid/content/res/Resources;II)V\n'
	}
	body += 'const/4 v0, 0\ninvoke-static {p0, v0}, ${main_type}->missing(Landroid/content/res/Resources;I)V\nconst v0, 0x7ffffffe\ninvoke-static {p0, v0}, ${main_type}->missing(Landroid/content/res/Resources;I)V\nreturn-void'
	return method('private static packaged(Landroid/content/res/Resources;)V', 4, body)
}

fn tests_source() string {
	mut body := 'new-instance v0, ${spy_type}\ninvoke-direct {v0, p0}, ${spy_type}-><init>(Landroid/content/res/Resources;)V\nconst/4 v1, 4\n'
	for bits in ['0', '0x80000000', '0x3fa00000', '0xc0200000', '1', '0x7f7fffff',
		'0x7f800000', '0xff800000', '0x7fc12345', '0xffc54321'] {
		body += 'const v2, ${bits}\ninvoke-static {v0, v1, v2}, ${main_type}->probe(${spy_type}II)V\n'
	}
	for kind in [0, 1, 2, 3, 5, 6, 16, 17, 18, 28, 29, 30, 31, -1, 255] {
		body += 'const/16 v1, ${kind}\nconst v2, 0x3fa00000\ninvoke-static {v0, v1, v2}, ${main_type}->probe(${spy_type}II)V\n'
	}
	for exception in ['Ljava/lang/RuntimeException;', 'Landroid/content/res/Resources$NotFoundException;'] {
		body += 'new-instance v1, ${exception}\nconst-string v2, "fixture lookup sentinel"\ninvoke-direct {v1, v2}, ${exception}-><init>(Ljava/lang/String;)V\ninvoke-static {v0, v1}, ${main_type}->failure(${spy_type}Ljava/lang/RuntimeException;)V\n'
	}
	body += 'const/4 v1, 4\nconst v2, 0x3fa00000\ninvoke-static {v0, v1, v2}, ${main_type}->probe(${spy_type}II)V\nreturn-void'
	return method('private static tests(Landroid/content/res/Resources;)V', 3, body)
}

fn main_source(ids map[string]string) string {
	return '.class public final ${main_type}\n.super Landroid/app/Activity;\n' +
		method('public constructor <init>()V', 0, 'invoke-direct {p0}, Landroid/app/Activity;-><init>()V\nreturn-void') +
		checks_source() + float_source() + state_source() + probe_source() + packaged_source(ids) + tests_source() +
		method('public onCreate(Landroid/os/Bundle;)V', 3, '
invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
:test_start
invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
move-result-object v0
invoke-static {v0}, ${main_type}->packaged(Landroid/content/res/Resources;)V
invoke-static {v0}, ${main_type}->tests(Landroid/content/res/Resources;)V
:test_end
sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
const-string v1, "${pass_marker}"
invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V
new-instance v0, Landroid/widget/TextView;
invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
const-string v1, "Resources float contracts passed"
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

fn fixture_sources(ids map[string]string) map[string]string {
	return {'org/vinix/bootstrap/Main.smali': main_source(ids), 'org/vinix/bootstrap/FloatResources.smali': spy_source()}
}
