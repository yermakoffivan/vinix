// SPDX-License-Identifier: GPL-2.0-or-later
module main

const package_name = 'org.vinix.bootstrap'
const main_type = 'Lorg/vinix/bootstrap/Main;'
const pass_marker = 'INTENT-EXTRAS-PASS merge precedence copies no-op nulls shallow controlled-intent'
const fail_marker = 'INTENT-EXTRAS-FAIL'

fn method(signature string, locals int, body string) string {
	return '.method ${signature}\n.locals ${locals}\n${body}\n.end method\n'
}

fn new_object(register string, class string) string {
	return 'new-instance ${register}, ${class}\ninvoke-direct {${register}}, ${class}-><init>()V\n'
}

fn no_extras(register string) string {
	return 'invoke-static {}, ${main_type}->noExtras()Landroid/content/Intent;\nmove-result-object ${register}\n'
}

fn put_text(register string, key string, value string, bundle bool) string {
	owner := if bundle { 'Landroid/os/Bundle;' } else { 'Landroid/content/Intent;' }
	method_name := if bundle { 'putString' } else { 'putExtra' }
	result := if bundle { 'V' } else { 'Landroid/content/Intent;' }
	return 'const-string v6, "${key}"\nconst-string v7, "${value}"\n' +
		'invoke-virtual {${register}, v6, v7}, ${owner}->${method_name}(Ljava/lang/String;Ljava/lang/String;)${result}\n'
}

fn expect_text(register string, key string, value string, bundle bool) string {
	method_name := if bundle { 'bundleText(Landroid/os/Bundle;' } else { 'intentText(Landroid/content/Intent;' }
	return 'const-string v6, "${key}"\nconst-string v7, "${value}"\n' +
		'invoke-static {${register}, v6, v7}, ${main_type}->${method_name}Ljava/lang/String;Ljava/lang/String;)V\n'
}

fn assertion_source() string {
	mut text := ''
	for name, branch in {'same': 'if-eq', 'different': 'if-ne'} {
		text += method('private static ${name}(Ljava/lang/Object;Ljava/lang/Object;)V', 2, '
${branch} p0, p1, :done
new-instance v0, Ljava/lang/AssertionError;
const-string v1, "Unexpected object identity: ${name}"
invoke-direct {v0, v1}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V
throw v0
:done
return-void')
	}
	text += method('private static equal(II)V', 2, '
if-eq p0, p1, :done
new-instance v0, Ljava/lang/AssertionError;
const-string v1, "Unexpected integer or membership value"
invoke-direct {v0, v1}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V
throw v0
:done
return-void')
	for name in ['intentText', 'bundleText'] {
		owner := if name == 'intentText' { 'Landroid/content/Intent;' } else { 'Landroid/os/Bundle;' }
		getter := if name == 'intentText' { 'getStringExtra' } else { 'getString' }
		text += method('private static ${name}(${owner}Ljava/lang/String;Ljava/lang/String;)V', 2, '
invoke-virtual {p0, p1}, ${owner}->${getter}(Ljava/lang/String;)Ljava/lang/String;
move-result-object v0
invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
move-result v0
const/4 v1, 1
invoke-static {v0, v1}, ${main_type}->equal(II)V
return-void')
	}
	// The retained framework constructor eagerly allocates an empty Bundle.
	// Set up the absent-extras state explicitly so these tests exercise the
	// putExtras branches independently of constructor behavior.
	return text + method('private static noExtras()Landroid/content/Intent;', 3, '
new-instance v0, Landroid/content/Intent;
invoke-direct {v0}, Landroid/content/Intent;-><init>()V
const/4 v1, 0
invoke-virtual {v0, v1}, Landroid/content/Intent;->replaceExtras(Landroid/os/Bundle;)Landroid/content/Intent;
invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;
move-result-object v2
invoke-static {v2, v1}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
return-object v0') + method('private static errorIntent()Landroid/content/Intent;', 3, '
new-instance v0, Landroid/content/Intent;
invoke-direct {v0}, Landroid/content/Intent;-><init>()V
const-string v1, "ErrorTitle"
const-string v2, "Account setup unavailable"
invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
const-string v1, "ErrorDescription"
const-string v2, "Try again after checking your connection"
invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
const-string v1, "duplicate"
const-string v2, "old"
invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
return-object v0') + method('private static errorText(Landroid/content/Intent;)V', 2, '
const-string v0, "ErrorTitle"
const-string v1, "Account setup unavailable"
invoke-static {p0, v0, v1}, ${main_type}->intentText(Landroid/content/Intent;Ljava/lang/String;Ljava/lang/String;)V
const-string v0, "ErrorDescription"
const-string v1, "Try again after checking your connection"
invoke-static {p0, v0, v1}, ${main_type}->intentText(Landroid/content/Intent;Ljava/lang/String;Ljava/lang/String;)V
return-void')
}

fn bundle_merge_source() string {
	mut body := 'invoke-static {}, ${main_type}->errorIntent()Landroid/content/Intent;\nmove-result-object v0\n'
	body += new_object('v1', 'Landroid/os/Bundle;') + new_object('v2', 'Landroid/os/Bundle;')
	body += put_text('v1', 'metadata', 'setup-flow', true) + put_text('v1', 'duplicate', 'incoming', true)
	body += put_text('v2', 'nested-value', 'one', true)
	body += '
const-string v6, "null-value"
const/4 v7, 0
invoke-virtual {v1, v6, v7}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V
const-string v6, "nested"
invoke-virtual {v1, v6, v2}, Landroid/os/Bundle;->putBundle(Ljava/lang/String;Landroid/os/Bundle;)V
invoke-virtual {v0, v1}, Landroid/content/Intent;->putExtras(Landroid/os/Bundle;)Landroid/content/Intent;
move-result-object v3
invoke-static {v3, v0}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-static {v0}, ${main_type}->errorText(Landroid/content/Intent;)V
'
	body += expect_text('v0', 'duplicate', 'incoming', false) + expect_text('v0', 'metadata', 'setup-flow', false)
	body += expect_text('v1', 'metadata', 'setup-flow', true) + expect_text('v1', 'duplicate', 'incoming', true)
	body += '
invoke-virtual {v1}, Landroid/os/Bundle;->size()I
move-result v4
const/4 v5, 4
invoke-static {v4, v5}, ${main_type}->equal(II)V
const-string v6, "ErrorTitle"
invoke-virtual {v1, v6}, Landroid/os/Bundle;->containsKey(Ljava/lang/String;)Z
move-result v4
const/4 v5, 0
invoke-static {v4, v5}, ${main_type}->equal(II)V
const-string v6, "null-value"
invoke-virtual {v0, v6}, Landroid/content/Intent;->hasExtra(Ljava/lang/String;)Z
move-result v4
const/4 v5, 1
invoke-static {v4, v5}, ${main_type}->equal(II)V
invoke-virtual {v0, v6}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;
move-result-object v3
const/4 v4, 0
invoke-static {v3, v4}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;
move-result-object v3
invoke-static {v3, v1}, ${main_type}->different(Ljava/lang/Object;Ljava/lang/Object;)V
const-string v6, "nested"
invoke-virtual {v0, v6}, Landroid/content/Intent;->getBundleExtra(Ljava/lang/String;)Landroid/os/Bundle;
move-result-object v3
invoke-static {v3, v2}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
'
	body += put_text('v2', 'nested-value', 'two', true) + expect_text('v3', 'nested-value', 'two', true)
	body += put_text('v1', 'metadata', 'source changed', true) + put_text('v1', 'source-only', 'source', true)
	body += 'const-string v6, "duplicate"\ninvoke-virtual {v1, v6}, Landroid/os/Bundle;->remove(Ljava/lang/String;)V\n'
	body += expect_text('v0', 'metadata', 'setup-flow', false) + expect_text('v0', 'duplicate', 'incoming', false)
	body += put_text('v0', 'destination-only', 'destination', false)
	body += '
const-string v6, "destination-only"
invoke-virtual {v1, v6}, Landroid/os/Bundle;->containsKey(Ljava/lang/String;)Z
move-result v4
const/4 v5, 0
invoke-static {v4, v5}, ${main_type}->equal(II)V
const-string v6, "source-only"
invoke-virtual {v0, v6}, Landroid/content/Intent;->hasExtra(Ljava/lang/String;)Z
move-result v4
invoke-static {v4, v5}, ${main_type}->equal(II)V
return-void'
	return method('private static bundleMerge()V', 8, body)
}

fn bundle_initial_source() string {
	mut body := no_extras('v0') + new_object('v1', 'Landroid/os/Bundle;')
	body += put_text('v1', 'initial', 'before', true)
	body += '
invoke-virtual {v0, v1}, Landroid/content/Intent;->putExtras(Landroid/os/Bundle;)Landroid/content/Intent;
move-result-object v2
invoke-static {v2, v0}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;
move-result-object v2
invoke-static {v2, v1}, ${main_type}->different(Ljava/lang/Object;Ljava/lang/Object;)V
'
	body += put_text('v1', 'initial', 'source changed', true) + expect_text('v0', 'initial', 'before', false)
	body += put_text('v0', 'initial', 'destination changed', false) + expect_text('v1', 'initial', 'source changed', true)
	body += new_object('v1', 'Landroid/os/Bundle;')
	body += 'invoke-virtual {v0, v1}, Landroid/content/Intent;->putExtras(Landroid/os/Bundle;)Landroid/content/Intent;\n'
	body += expect_text('v0', 'initial', 'destination changed', false)
	body += no_extras('v0')
	body += '
invoke-virtual {v0, v1}, Landroid/content/Intent;->putExtras(Landroid/os/Bundle;)Landroid/content/Intent;
move-result-object v2
invoke-static {v2, v0}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;
move-result-object v2
const/4 v3, 0
invoke-static {v2, v3}, ${main_type}->different(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-static {v2, v1}, ${main_type}->different(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v2}, Landroid/os/Bundle;->size()I
move-result v2
invoke-static {v2, v3}, ${main_type}->equal(II)V
return-void'
	return method('private static bundleInitial()V', 8, body)
}

fn intent_merge_source() string {
	mut body := ''
	for populated in [true, false] {
		body += if populated { 'invoke-static {}, ${main_type}->errorIntent()Landroid/content/Intent;\nmove-result-object v0\n' } else { no_extras('v0') }
		body += new_object('v1', 'Landroid/content/Intent;')
		body += put_text('v1', 'metadata', 'source intent', false) + put_text('v1', 'duplicate', 'intent incoming', false)
		body += '
invoke-virtual {v0, v1}, Landroid/content/Intent;->putExtras(Landroid/content/Intent;)Landroid/content/Intent;
move-result-object v2
invoke-static {v2, v0}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;
move-result-object v2
invoke-virtual {v1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;
move-result-object v3
invoke-static {v2, v3}, ${main_type}->different(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v3}, Landroid/os/Bundle;->size()I
move-result v4
const/4 v5, 2
invoke-static {v4, v5}, ${main_type}->equal(II)V
'
		if populated { body += 'invoke-static {v0}, ${main_type}->errorText(Landroid/content/Intent;)V\n' }
		body += expect_text('v0', 'duplicate', 'intent incoming', false) + expect_text('v0', 'metadata', 'source intent', false)
		body += expect_text('v1', 'duplicate', 'intent incoming', false) + expect_text('v1', 'metadata', 'source intent', false)
		body += put_text('v1', 'metadata', 'source changed', false) + put_text('v1', 'source-only', 'source', false)
		body += expect_text('v0', 'metadata', 'source intent', false)
		body += put_text('v0', 'duplicate', 'destination changed', false) + expect_text('v1', 'duplicate', 'intent incoming', false)
		body += '
const-string v6, "source-only"
invoke-virtual {v0, v6}, Landroid/content/Intent;->hasExtra(Ljava/lang/String;)Z
move-result v4
const/4 v5, 0
invoke-static {v4, v5}, ${main_type}->equal(II)V
'
	}
	return method('private static intentMerge()V', 8, body + 'return-void')
}

fn empty_intent_source() string {
	mut body := no_extras('v1')
	for populated in [true, false] {
		body += if populated { 'invoke-static {}, ${main_type}->errorIntent()Landroid/content/Intent;\nmove-result-object v0\n' } else { no_extras('v0') }
		body += '
invoke-virtual {v0, v1}, Landroid/content/Intent;->putExtras(Landroid/content/Intent;)Landroid/content/Intent;
move-result-object v2
invoke-static {v2, v0}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
'
		if populated { body += 'invoke-static {v0}, ${main_type}->errorText(Landroid/content/Intent;)V\n' }
		else {
			body += 'invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;\nmove-result-object v2\nconst/4 v3, 0\n' +
				'invoke-static {v2, v3}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V\n'
		}
	}
	body += new_object('v3', 'Landroid/os/Bundle;')
	body += '
invoke-virtual {v1, v3}, Landroid/content/Intent;->putExtras(Landroid/os/Bundle;)Landroid/content/Intent;
invoke-virtual {v1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;
move-result-object v3
invoke-virtual {v0, v1}, Landroid/content/Intent;->putExtras(Landroid/content/Intent;)Landroid/content/Intent;
move-result-object v2
invoke-static {v2, v0}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;
move-result-object v2
const/4 v4, 0
invoke-static {v2, v4}, ${main_type}->different(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-static {v2, v3}, ${main_type}->different(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v2}, Landroid/os/Bundle;->size()I
move-result v2
invoke-static {v2, v4}, ${main_type}->equal(II)V
return-void'
	return method('private static emptyIntent()V', 8, body)
}

fn null_source() string {
	mut text := ''
	for name, owner in {'nullBundle': 'Landroid/os/Bundle;', 'nullIntent': 'Landroid/content/Intent;'} {
		text += method('private static ${name}(Landroid/content/Intent;)V', 2, '
const/4 v0, 0
:try_start
invoke-virtual {p0, v0}, Landroid/content/Intent;->putExtras(${owner})Landroid/content/Intent;
:try_end
new-instance v0, Ljava/lang/AssertionError;
const-string v1, "${name} must throw NullPointerException"
invoke-direct {v0, v1}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V
throw v0
.catch Ljava/lang/NullPointerException; {:try_start .. :try_end} :expected
:expected
move-exception v0
return-void')
	}
	mut body := no_extras('v0')
	body += '
invoke-static {v0}, ${main_type}->nullIntent(Landroid/content/Intent;)V
invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;
move-result-object v1
const/4 v2, 0
invoke-static {v1, v2}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-static {v0}, ${main_type}->nullBundle(Landroid/content/Intent;)V
invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;
move-result-object v1
invoke-static {v1, v2}, ${main_type}->different(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v1}, Landroid/os/Bundle;->size()I
move-result v1
invoke-static {v1, v2}, ${main_type}->equal(II)V
invoke-static {}, ${main_type}->errorIntent()Landroid/content/Intent;
move-result-object v0
invoke-static {v0}, ${main_type}->nullBundle(Landroid/content/Intent;)V
invoke-static {v0}, ${main_type}->errorText(Landroid/content/Intent;)V
invoke-static {v0}, ${main_type}->nullIntent(Landroid/content/Intent;)V
invoke-static {v0}, ${main_type}->errorText(Landroid/content/Intent;)V
invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;
move-result-object v1
invoke-virtual {v1}, Landroid/os/Bundle;->size()I
move-result v1
const/4 v2, 3
invoke-static {v1, v2}, ${main_type}->equal(II)V
return-void'
	return text + method('private static nulls()V', 3, body)
}

fn controlled_source() string {
	mut body := new_object('v1', 'Landroid/os/Bundle;') + put_text('v1', 'metadata', 'controlled-flow', true)
	// This control reproduces replacement's title/body loss using the retained
	// replaceExtras API. The otherwise identical putExtras path must retain them.
	body += '
invoke-static {}, ${main_type}->errorIntent()Landroid/content/Intent;
move-result-object v0
invoke-virtual {v0, v1}, Landroid/content/Intent;->replaceExtras(Landroid/os/Bundle;)Landroid/content/Intent;
move-result-object v2
invoke-static {v2, v0}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
const-string v6, "ErrorTitle"
invoke-virtual {v0, v6}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;
move-result-object v2
const/4 v3, 0
invoke-static {v2, v3}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
const-string v6, "ErrorDescription"
invoke-virtual {v0, v6}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;
move-result-object v2
invoke-static {v2, v3}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-static {}, ${main_type}->errorIntent()Landroid/content/Intent;
move-result-object v0
invoke-virtual {v0, v1}, Landroid/content/Intent;->putExtras(Landroid/os/Bundle;)Landroid/content/Intent;
invoke-static {v0}, ${main_type}->errorText(Landroid/content/Intent;)V
new-instance v2, Landroid/content/Intent;
invoke-direct {v2, v0}, Landroid/content/Intent;-><init>(Landroid/content/Intent;)V
'
	body += put_text('v0', 'ErrorTitle', 'original changed after copy', false)
	body += 'invoke-static {v2}, ${main_type}->errorText(Landroid/content/Intent;)V\n'
	body += new_object('v3', 'Landroid/content/Intent;')
	body += '
const-string v6, "android.intent.extra.INTENT"
invoke-virtual {v3, v6, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;
'
	body += put_text('v3', 'title-key', 'ErrorTitle', false) + put_text('v3', 'body-key', 'ErrorDescription', false)
	body += 'invoke-virtual {v3, v1}, Landroid/content/Intent;->putExtras(Landroid/os/Bundle;)Landroid/content/Intent;\n'
	body += new_object('v4', 'Landroid/content/Intent;')
	body += '
const-string v6, "controlled"
invoke-virtual {v4, v6, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;
new-instance v5, Landroid/content/Intent;
invoke-direct {v5, v4}, Landroid/content/Intent;-><init>(Landroid/content/Intent;)V
invoke-virtual {v5, v6}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;
move-result-object v4
check-cast v4, Landroid/content/Intent;
invoke-static {v4, v3}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
const-string v6, "android.intent.extra.INTENT"
invoke-virtual {v4, v6}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;
move-result-object v5
check-cast v5, Landroid/content/Intent;
invoke-static {v5, v2}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
const-string v6, "title-key"
invoke-virtual {v4, v6}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;
move-result-object v6
const-string v7, "Account setup unavailable"
invoke-static {v5, v6, v7}, ${main_type}->intentText(Landroid/content/Intent;Ljava/lang/String;Ljava/lang/String;)V
const-string v6, "body-key"
invoke-virtual {v4, v6}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;
move-result-object v6
const-string v7, "Try again after checking your connection"
invoke-static {v5, v6, v7}, ${main_type}->intentText(Landroid/content/Intent;Ljava/lang/String;Ljava/lang/String;)V
'
	body += expect_text('v5', 'metadata', 'controlled-flow', false) + expect_text('v1', 'metadata', 'controlled-flow', true)
	body += 'return-void'
	return method('private static controlled()V', 8, body)
}

fn fixture_sources() map[string]string {
	mut text := '.class public final ${main_type}\n.super Landroid/app/Activity;\n'
	text += method('public constructor <init>()V', 0, 'invoke-direct {p0}, Landroid/app/Activity;-><init>()V\nreturn-void')
	text += assertion_source() + bundle_merge_source() + bundle_initial_source() + intent_merge_source() + empty_intent_source() + null_source() + controlled_source()
	text += method('public onCreate(Landroid/os/Bundle;)V', 3, '
invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
:test_start
invoke-static {}, ${main_type}->controlled()V
invoke-static {}, ${main_type}->bundleMerge()V
invoke-static {}, ${main_type}->bundleInitial()V
invoke-static {}, ${main_type}->intentMerge()V
invoke-static {}, ${main_type}->emptyIntent()V
invoke-static {}, ${main_type}->nulls()V
:test_end
sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
const-string v1, "${pass_marker}"
invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V
new-instance v0, Landroid/widget/TextView;
invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
const-string v1, "Intent extras merge and nested error data passed"
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
	return {'org/vinix/bootstrap/Main.smali': text}
}
