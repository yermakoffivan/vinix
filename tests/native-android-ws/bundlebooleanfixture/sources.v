// SPDX-License-Identifier: GPL-2.0-or-later
module main

const package_name = 'org.vinix.bootstrap'
const main_type = 'Lorg/vinix/bootstrap/Main;'
const pass_marker = 'BUNDLE-BOOLEAN-PASS null-keys defaults stored-values nonmutating ordinary-keys legacy-control cross-profile-absent'
const fail_marker = 'BUNDLE-BOOLEAN-FAIL'

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

// p2 is the expected false-default/one-argument value; p3 is the expected
// true-default value. Each call also verifies that reads retain map contents.
fn probe_source() string {
	return method('private static probe(Landroid/os/Bundle;Ljava/lang/String;ZZLjava/lang/String;)V', 5, '
invoke-virtual {p0}, Landroid/os/Bundle;->size()I
move-result v2
invoke-virtual {p0, p1}, Landroid/os/Bundle;->containsKey(Ljava/lang/String;)Z
move-result v3
invoke-virtual {p0, p1}, Landroid/os/Bundle;->get(Ljava/lang/String;)Ljava/lang/Object;
move-result-object v4
invoke-virtual {p0, p1}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;)Z
move-result v0
invoke-static {v0, p2, p4}, ${main_type}->equal(IILjava/lang/String;)V
const/4 v1, 0
invoke-virtual {p0, p1, v1}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z
move-result v0
invoke-static {v0, p2, p4}, ${main_type}->equal(IILjava/lang/String;)V
const/4 v1, 1
invoke-virtual {p0, p1, v1}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z
move-result v0
invoke-static {v0, p3, p4}, ${main_type}->equal(IILjava/lang/String;)V
invoke-virtual {p0}, Landroid/os/Bundle;->size()I
move-result v0
invoke-static {v0, v2, p4}, ${main_type}->equal(IILjava/lang/String;)V
invoke-virtual {p0, p1}, Landroid/os/Bundle;->containsKey(Ljava/lang/String;)Z
move-result v0
invoke-static {v0, v3, p4}, ${main_type}->equal(IILjava/lang/String;)V
invoke-virtual {p0, p1}, Landroid/os/Bundle;->get(Ljava/lang/String;)Ljava/lang/Object;
move-result-object v0
invoke-static {v0, v4, p4}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
return-void')
}

fn probe(label string, zero int, one int) string {
	return 'const/4 v2, ${zero}\nconst/4 v3, ${one}\nconst-string v4, "${label}"\n' +
		'invoke-static {v0, v1, v2, v3, v4}, ${main_type}->probe(Landroid/os/Bundle;Ljava/lang/String;ZZLjava/lang/String;)V\n'
}

fn tests_source() string {
	mut body := 'new-instance v0, Landroid/os/Bundle;\ninvoke-direct {v0}, Landroid/os/Bundle;-><init>()V\nconst/4 v1, 0\n'
	body += probe('missing null key must honor both defaults', 0, 1)
	body += 'const/4 v2, 1\ninvoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V\n'
	body += probe('stored null-key true must override either default', 1, 1)
	body += 'const/4 v2, 0\ninvoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V\n'
	body += probe('stored null-key false must override either default', 0, 0)
	body += 'const/4 v2, 0\ninvoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V\n'
	body += probe('stored null object must honor both defaults', 0, 1)
	body += 'invoke-virtual {v0, v1}, Landroid/os/Bundle;->remove(Ljava/lang/String;)V\n'
	body += probe('removed null key must recover both defaults', 0, 1)
	body += 'invoke-virtual {v0}, Landroid/os/Bundle;->size()I\nmove-result v2\nconst/4 v3, 0\nconst-string v4, "null-key test must leave no hidden entry"\ninvoke-static {v2, v3, v4}, ${main_type}->equal(IILjava/lang/String;)V\n'
	for key in ['ordinary-key', ''] {
		body += 'const-string v1, "${key}"\n'
		body += probe('missing ordinary key must honor defaults', 0, 1)
		body += 'const/4 v2, 1\ninvoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V\n'
		body += probe('stored ordinary true remains true', 1, 1)
		body += 'const/4 v2, 0\ninvoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V\n'
		body += probe('stored ordinary false remains false', 0, 0)
		body += 'invoke-virtual {v0, v1}, Landroid/os/Bundle;->remove(Ljava/lang/String;)V\n'
		body += probe('removed ordinary key must honor defaults', 0, 1)
	}
	body += 'const-string v1, "com.facebook.sdk.AutoLogAppEventsEnabled"\n'
	body += probe('preserve legacy special-key missing behavior', 0, 0)
	body += 'const/4 v2, 1\ninvoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V\n'
	body += probe('preserve legacy special-key true override', 0, 0)
	body += 'const/4 v2, 0\ninvoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V\n'
	body += probe('preserve legacy special-key false behavior', 0, 0)
	body += 'const-string v2, "wrong type"\ninvoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V\n'
	body += probe('preserve legacy special-key before wrong-type handling', 0, 0)
	body += 'invoke-virtual {v0, v1}, Landroid/os/Bundle;->remove(Ljava/lang/String;)V\n'
	body += probe('preserve legacy special-key removal behavior', 0, 0)
	body += 'const/4 v1, 0\nconst/4 v2, 1\ninvoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V\n'
	body += probe('null key remains independent after non-null and legacy tests', 1, 1)
	body += 'return-void'
	assert body.count('->probe(Landroid/os/Bundle;Ljava/lang/String;ZZLjava/lang/String;)V') == 19
	return method('private static tests()V', 5, body)
}

fn cross_profiles_source() string {
	return method('private static crossProfiles(Landroid/content/Context;)V', 4, '
const-class v0, Landroid/content/pm/CrossProfileApps;
const-string v1, "android.content.pm.CrossProfileApps"
invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
move-result-object v1
const-string v2, "cross-profile class lookup must resolve the SDK class identity"
invoke-static {v0, v1, v2}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;
move-result-object v1
check-cast v1, Landroid/content/pm/CrossProfileApps;
const/4 v2, 0
const-string v3, "unsupported cross-profile service must remain a typed null"
invoke-static {v1, v2, v3}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
return-void')
}

fn main_source() string {
	return '.class public final ${main_type}\n.super Landroid/app/Activity;\n' +
		method('public constructor <init>()V', 0, 'invoke-direct {p0}, Landroid/app/Activity;-><init>()V\nreturn-void') +
		checks_source() + probe_source() + tests_source() + cross_profiles_source() + method('public onCreate(Landroid/os/Bundle;)V', 3, '
invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
:test_start
invoke-static {}, ${main_type}->tests()V
invoke-static {p0}, ${main_type}->crossProfiles(Landroid/content/Context;)V
invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
move-result-object v0
invoke-static {v0}, ${main_type}->crossProfiles(Landroid/content/Context;)V
:test_end
sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
const-string v1, "${pass_marker}"
invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V
new-instance v0, Landroid/widget/TextView;
invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
const-string v1, "Bundle boolean null-key contracts passed"
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
	return {'org/vinix/bootstrap/Main.smali': main_source()}
}
