// SPDX-License-Identifier: GPL-2.0-or-later
module androidtools

import os

pub fn framework_resources_float_source(original string) !string {
	if original.split_into_lines().filter(it.starts_with('.class ')) != ['.class public Landroid/content/res/Resources;']
		|| original.split_into_lines().filter(it.starts_with('.super ')) != ['.super Ljava/lang/Object;'] {
		return error('canonical Resources class required')
	}
	lookup := 'getValue(ILandroid/util/TypedValue;Z)V'
	mut methods := map[string]bool{}
	for block in original.split('.method ')[1..] {
		header := block.all_before('\n')
		name := header.all_after_last(' ')
		if name in methods || !block.contains('.end method') {
			return error('unique complete Resources methods required')
		}
		methods[name] = true
		if name == 'getFloat(I)F' { return error('Resources float getter already present') }
		if name == lookup && header != 'public ' + lookup {
			return error('retained public virtual resource value lookup required')
		}
	}
	if lookup !in methods || original.count('.end method') != methods.len {
		return error('retained Resources lookup method schema required')
	}
	// Reuse the existing typed lookup, including resource-reference resolution
	// and lookup exceptions. A local value avoids touching shared value caches.
	return original + '
.method public getFloat(I)F
.locals 4
new-instance v0, Landroid/util/TypedValue;
invoke-direct {v0}, Landroid/util/TypedValue;-><init>()V
const/4 v1, 0x1
invoke-virtual {p0, p1, v0, v1}, Landroid/content/res/Resources;->getValue(ILandroid/util/TypedValue;Z)V
iget v1, v0, Landroid/util/TypedValue;->type:I
const/4 v2, 0x4
if-ne v1, v2, :not_float
invoke-virtual {v0}, Landroid/util/TypedValue;->getFloat()F
move-result v0
return v0
:not_float
new-instance v2, Landroid/content/res/Resources$NotFoundException;
new-instance v3, Ljava/lang/StringBuilder;
invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
const-string v0, "Resource ID #0x"
invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
invoke-static {p1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;
move-result-object v0
invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
const-string v0, " type #0x"
invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
invoke-static {v1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;
move-result-object v0
invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
const-string v0, " is not valid"
invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
move-result-object v0
invoke-direct {v2, v0}, Landroid/content/res/Resources$NotFoundException;-><init>(Ljava/lang/String;)V
throw v2
.end method
'
}

pub fn framework_resources_float(smali string) ! {
	path := smali + '/android/content/res/Resources.smali'
	os.write_file(path, framework_resources_float_source(os.read_file(path)!)!)!
}
