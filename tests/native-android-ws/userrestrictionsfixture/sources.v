// SPDX-License-Identifier: GPL-2.0-or-later
module main

const package_name = 'org.vinix.bootstrap'
const main_type = 'Lorg/vinix/bootstrap/Main;'
const backend_type = 'Lorg/vinix/bootstrap/RuleManager;'
const pass_marker = 'USER-RESTRICTIONS-PASS fresh-snapshots bundle-truth virtual-backend mutation-isolation exceptions context-controls'
const fail_marker = 'USER-RESTRICTIONS-FAIL'

fn method(signature string, locals int, body string) string {
	return '.method ${signature}\n.locals ${locals}\n${body}\n.end method\n'
}

fn assertion(signature string, branch string) string {
	return method('private static ' + signature, 1, branch + '
new-instance v0, Ljava/lang/AssertionError;
invoke-direct {v0, p2}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V
throw v0
:done
return-void')
}

fn checks_source() string {
	return assertion('equal(IILjava/lang/String;)V', 'if-eq p0, p1, :done') +
		assertion('same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V', 'if-eq p0, p1, :done') +
		assertion('different(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V', 'if-ne p0, p1, :done')
}

fn backend_source() string {
	return '.class public final ${backend_type}\n.super Landroid/os/UserManager;\n' + '
.field public values:Landroid/os/Bundle;
.field public calls:I
.field public failure:Ljava/lang/IllegalStateException;
' + method('public constructor <init>()V', 0, 'invoke-direct {p0}, Landroid/os/UserManager;-><init>()V\nreturn-void') +
		method('public getUserRestrictions()Landroid/os/Bundle;', 1, '
iget v0, p0, ${backend_type}->calls:I
add-int/lit8 v0, v0, 1
iput v0, p0, ${backend_type}->calls:I
iget-object v0, p0, ${backend_type}->failure:Ljava/lang/IllegalStateException;
if-eqz v0, :values
throw v0
:values
iget-object v0, p0, ${backend_type}->values:Landroid/os/Bundle;
return-object v0')
}

fn base_source() string {
	mut body := '
invoke-virtual {p0}, Landroid/os/UserManager;->getUserRestrictions()Landroid/os/Bundle;
move-result-object v0
invoke-virtual {p0}, Landroid/os/UserManager;->getUserRestrictions()Landroid/os/Bundle;
move-result-object v1
const-string v2, "each base query must return an independent snapshot"
invoke-static {v0, v1, v2}, ${main_type}->different(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
invoke-virtual {v0}, Landroid/os/Bundle;->isEmpty()Z
move-result v2
const/4 v3, 1
const-string v4, "unmanaged base snapshot must be empty"
invoke-static {v2, v3, v4}, ${main_type}->equal(IILjava/lang/String;)V
invoke-virtual {v1}, Landroid/os/Bundle;->isEmpty()Z
move-result v2
invoke-static {v2, v3, v4}, ${main_type}->equal(IILjava/lang/String;)V
const-string v2, "no_modify_accounts"
invoke-virtual {v0, v2, v3}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V
invoke-virtual {v0, v2}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;)Z
move-result v4
const-string v5, "returned snapshot remains an ordinary mutable Bundle"
invoke-static {v4, v3, v5}, ${main_type}->equal(IILjava/lang/String;)V
invoke-virtual {v1}, Landroid/os/Bundle;->isEmpty()Z
move-result v4
const-string v5, "mutation must not affect another snapshot"
invoke-static {v4, v3, v5}, ${main_type}->equal(IILjava/lang/String;)V
invoke-virtual {p0}, Landroid/os/UserManager;->getUserRestrictions()Landroid/os/Bundle;
move-result-object v1
invoke-virtual {v1}, Landroid/os/Bundle;->isEmpty()Z
move-result v4
const-string v5, "snapshot mutation must not write user policy"
invoke-static {v4, v3, v5}, ${main_type}->equal(IILjava/lang/String;)V
'
	for key in ['no_modify_accounts', 'no_config_wifi', 'fixture_unknown_key', ''] {
		body += 'const-string v2, "${key}"\n' +
			'invoke-virtual {p0, v2}, Landroid/os/UserManager;->hasUserRestriction(Ljava/lang/String;)Z\nmove-result v4\n' +
			'const/4 v3, 0\nconst-string v5, "unmanaged base restriction query must match empty Bundle"\n' +
			'invoke-static {v4, v3, v5}, ${main_type}->equal(IILjava/lang/String;)V\n'
	}
	body += '
const/4 v2, 0
invoke-virtual {p0, v2}, Landroid/os/UserManager;->hasUserRestriction(Ljava/lang/String;)Z
move-result v4
const/4 v3, 0
const-string v5, "base null key must match empty Bundle"
invoke-static {v4, v3, v5}, ${main_type}->equal(IILjava/lang/String;)V
invoke-virtual {p0}, Landroid/os/UserManager;->getSeedAccountOptions()Landroid/os/PersistableBundle;
move-result-object v2
const/4 v3, 0
const-string v5, "seed options remain absent"
invoke-static {v2, v3, v5}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
const-string v2, "org.vinix.bootstrap"
invoke-virtual {p0, v2}, Landroid/os/UserManager;->getApplicationRestrictions(Ljava/lang/String;)Landroid/os/Bundle;
move-result-object v2
invoke-virtual {v2}, Landroid/os/Bundle;->isEmpty()Z
move-result v2
const/4 v3, 1
const-string v5, "old application restriction query remains empty"
invoke-static {v2, v3, v5}, ${main_type}->equal(IILjava/lang/String;)V
invoke-virtual {p0}, Landroid/os/UserManager;->isUserUnlocked()Z
move-result v2
invoke-static {v2, v3, v5}, ${main_type}->equal(IILjava/lang/String;)V
invoke-static {}, Landroid/os/UserManager;->supportsMultipleUsers()Z
move-result v2
const/4 v3, 0
const-string v5, "retained single-user model"
invoke-static {v2, v3, v5}, ${main_type}->equal(IILjava/lang/String;)V
return-void'
	return method('private static base(Landroid/os/UserManager;)V', 6, body)
}

fn probe_source() string {
	return method('private static probe(${backend_type}Ljava/lang/String;)V', 5, '
iget-object v0, p0, ${backend_type}->values:Landroid/os/Bundle;
invoke-virtual {v0, p1}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;)Z
move-result v0
iget v1, p0, ${backend_type}->calls:I
add-int/lit8 v1, v1, 1
invoke-virtual {p0, p1}, Landroid/os/UserManager;->hasUserRestriction(Ljava/lang/String;)Z
move-result v2
const-string v3, "boolean query must preserve the backend Bundle truth"
invoke-static {v2, v0, v3}, ${main_type}->equal(IILjava/lang/String;)V
iget v2, p0, ${backend_type}->calls:I
const-string v3, "each boolean query must dispatch the virtual backend once"
invoke-static {v2, v1, v3}, ${main_type}->equal(IILjava/lang/String;)V
return-void')
}

fn backend_tests() string {
	mut body := '
new-instance v0, ${backend_type}
invoke-direct {v0}, ${backend_type}-><init>()V
new-instance v1, Landroid/os/Bundle;
invoke-direct {v1}, Landroid/os/Bundle;-><init>()V
iput-object v1, v0, ${backend_type}->values:Landroid/os/Bundle;
const-string v2, "no_modify_accounts"
const/4 v3, 1
invoke-virtual {v1, v2, v3}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V
const-string v2, "no_config_wifi"
const/4 v3, 0
invoke-virtual {v1, v2, v3}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V
'
	for key in ['no_modify_accounts', 'no_config_wifi', 'fixture_unknown_key', ''] {
		body += 'const-string v2, "${key}"\ninvoke-static {v0, v2}, ${main_type}->probe(${backend_type}Ljava/lang/String;)V\n'
	}
	body += '
const/4 v2, 0
invoke-static {v0, v2}, ${main_type}->probe(${backend_type}Ljava/lang/String;)V
const-string v2, "no_modify_accounts"
const/4 v3, 0
invoke-virtual {v1, v2, v3}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V
invoke-static {v0, v2}, ${main_type}->probe(${backend_type}Ljava/lang/String;)V
const/4 v3, 1
invoke-virtual {v1, v2, v3}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V
invoke-static {v0, v2}, ${main_type}->probe(${backend_type}Ljava/lang/String;)V
new-instance v1, Landroid/os/Bundle;
invoke-direct {v1}, Landroid/os/Bundle;-><init>()V
iput-object v1, v0, ${backend_type}->values:Landroid/os/Bundle;
invoke-static {v0, v2}, ${main_type}->probe(${backend_type}Ljava/lang/String;)V
const-string v2, "no_config_wifi"
invoke-virtual {v1, v2, v3}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V
invoke-static {v0, v2}, ${main_type}->probe(${backend_type}Ljava/lang/String;)V
new-instance v4, Ljava/lang/IllegalStateException;
const-string v3, "expected backend failure"
invoke-direct {v4, v3}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V
iput-object v4, v0, ${backend_type}->failure:Ljava/lang/IllegalStateException;
iget v5, v0, ${backend_type}->calls:I
add-int/lit8 v5, v5, 1
:failure_start
invoke-virtual {v0, v2}, Landroid/os/UserManager;->hasUserRestriction(Ljava/lang/String;)Z
:failure_end
const/4 v3, 0
const/4 v6, 1
const-string v7, "backend exception must propagate"
invoke-static {v3, v6, v7}, ${main_type}->equal(IILjava/lang/String;)V
goto :after_failure
.catch Ljava/lang/IllegalStateException; {:failure_start .. :failure_end} :expected_failure
:expected_failure
move-exception v3
const-string v7, "backend exception identity must remain exact"
invoke-static {v3, v4, v7}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
:after_failure
iget v3, v0, ${backend_type}->calls:I
const-string v7, "throwing getter must be called once"
invoke-static {v3, v5, v7}, ${main_type}->equal(IILjava/lang/String;)V
const/4 v3, 0
iput-object v3, v0, ${backend_type}->failure:Ljava/lang/IllegalStateException;
invoke-static {v0, v2}, ${main_type}->probe(${backend_type}Ljava/lang/String;)V
iput-object v3, v0, ${backend_type}->values:Landroid/os/Bundle;
iget v5, v0, ${backend_type}->calls:I
add-int/lit8 v5, v5, 1
:null_start
invoke-virtual {v0, v2}, Landroid/os/UserManager;->hasUserRestriction(Ljava/lang/String;)Z
:null_end
const/4 v3, 0
const/4 v6, 1
const-string v7, "null backend must preserve Bundle dereference failure"
invoke-static {v3, v6, v7}, ${main_type}->equal(IILjava/lang/String;)V
goto :after_null
.catch Ljava/lang/NullPointerException; {:null_start .. :null_end} :expected_null
:expected_null
move-exception v3
:after_null
iget v3, v0, ${backend_type}->calls:I
const-string v7, "null-returning getter must be called once"
invoke-static {v3, v5, v7}, ${main_type}->equal(IILjava/lang/String;)V
return-void'
	return method('private static backend()V', 8, body)
}

fn context_source() string {
	return method('private static context(Landroid/content/Context;)V', 2, '
const-string v0, "user"
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
move-result-object v0
check-cast v0, Landroid/os/UserManager;
invoke-static {v0}, ${main_type}->base(Landroid/os/UserManager;)V
const-class v0, Landroid/os/UserManager;
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;
move-result-object v0
check-cast v0, Landroid/os/UserManager;
invoke-static {v0}, ${main_type}->base(Landroid/os/UserManager;)V
return-void')
}

fn main_source() string {
	return '.class public final ${main_type}\n.super Landroid/app/Activity;\n' +
		method('public constructor <init>()V', 0, 'invoke-direct {p0}, Landroid/app/Activity;-><init>()V\nreturn-void') +
		checks_source() + base_source() + probe_source() + backend_tests() + context_source() +
		method('public onCreate(Landroid/os/Bundle;)V', 3, '
invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
:test_start
new-instance v0, Landroid/os/UserManager;
invoke-direct {v0}, Landroid/os/UserManager;-><init>()V
invoke-static {v0}, ${main_type}->base(Landroid/os/UserManager;)V
invoke-static {p0}, ${main_type}->context(Landroid/content/Context;)V
invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
move-result-object v0
invoke-static {v0}, ${main_type}->context(Landroid/content/Context;)V
invoke-static {}, ${main_type}->backend()V
:test_end
sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
const-string v1, "${pass_marker}"
invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V
new-instance v0, Landroid/widget/TextView;
invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
const-string v1, "User restriction query contracts passed"
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
		'org/vinix/bootstrap/RuleManager.smali': backend_source()
	}
}
