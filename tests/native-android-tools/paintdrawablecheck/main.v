// SPDX-License-Identifier: GPL-2.0-or-later
module main

import androidtools
import crypto.sha256
import os

const target = 'android/graphics/drawable/PaintDrawable'
const signatures = ['<init>()V', '<init>(I)V', 'setCornerRadius(F)V', 'setCornerRadii([F)V',
	'inflateTag(Ljava/lang/String;Landroid/content/res/Resources;Lorg/xmlpull/v1/XmlPullParser;Landroid/util/AttributeSet;)Z']

struct Dependency {
	owner string
	header string
	parent string
	methods []string
	fields []string
}

fn dependencies() []Dependency {
	return [
		Dependency{owner: 'android/graphics/drawable/ShapeDrawable', header: 'public', parent: 'android/graphics/drawable/Drawable', methods: [
			'public constructor <init>()V', 'public getPaint()Landroid/graphics/Paint;',
			'public getShape()Landroid/graphics/drawable/shapes/Shape;',
			'public setShape(Landroid/graphics/drawable/shapes/Shape;)V',
			'protected inflateTag(Ljava/lang/String;Landroid/content/res/Resources;Lorg/xmlpull/v1/XmlPullParser;Landroid/util/AttributeSet;)Z']},
		Dependency{owner: 'android/graphics/drawable/shapes/RoundRectShape', header: 'public', parent: 'android/graphics/drawable/shapes/RectShape', methods: ['public constructor <init>([FLandroid/graphics/RectF;[F)V']},
		Dependency{owner: 'android/graphics/Paint', header: 'public', parent: 'java/lang/Object', methods: ['public setColor(I)V']},
		Dependency{owner: 'android/graphics/drawable/Drawable', header: 'public', parent: 'java/lang/Object', methods: ['public invalidateSelf()V']},
		Dependency{owner: 'android/content/res/Resources', header: 'public', parent: 'java/lang/Object', methods: ['public obtainAttributes(Landroid/util/AttributeSet;[I)Landroid/content/res/TypedArray;']},
		Dependency{owner: 'android/content/res/TypedArray', header: 'public', parent: 'java/lang/Object', methods: ['public getDimensionPixelSize(II)I', 'public recycle()V']},
		Dependency{owner: 'com/android/internal/R$styleable', header: 'public final', parent: 'java/lang/Object', fields: [
			'.field public static final DrawableCorners:[I', '.field public static final DrawableCorners_radius:I = 0x0',
			'.field public static final DrawableCorners_topLeftRadius:I = 0x1', '.field public static final DrawableCorners_topRightRadius:I = 0x2',
			'.field public static final DrawableCorners_bottomLeftRadius:I = 0x3', '.field public static final DrawableCorners_bottomRightRadius:I = 0x4']},
	]
}

fn methods(source string) map[string]string {
	mut result := map[string]string{}
	for block in source.split('.method ')[1..] {
		name := block.all_before('\n').all_after_last(' ')
		assert name !in result && block.contains('.end method'), 'unique complete method required'
		result[name] = '.method ' + block.all_before('.end method') + '.end method'
	}
	return result
}

fn norm(source string) string {
	return source.split_into_lines().map(it.trim_space()).filter(it != '' && !it.starts_with('#')).join('\n')
}

fn digest(path string) !string { return sha256.sum(os.read_bytes(path)!).hex() }

// Compare all semantic lines while normalizing only register spelling and
// branch labels. A label is identified by its target instruction ordinal.
fn canonical(source string, parameters int) string {
	lines := norm(source).split_into_lines()
	mut labels := map[string]string{}
	mut instruction := 0
	for line in lines {
		if line.starts_with(':') {
			assert line !in labels, 'duplicate generated label'
			labels[line] = ':instruction_' + instruction.str()
		} else if !line.starts_with('.') { instruction++ }
	}
	mut result := []string{}
	for line in lines {
		if line.starts_with(':') { continue }
		if line.starts_with('.locals ') {
			result << '.registers ' + (line.all_after(' ').int() + parameters).str()
			continue
		}
		mut parts := line.split(' ')
		for i, part in parts {
			if replacement := labels[part] { parts[i] = replacement }
			else { assert !part.starts_with(':'), 'undefined generated label' }
		}
		result << parts.join(' ')
	}
	return result.join('\n')
}

fn verify_added(raw string, assembled string) {
	for source in [raw, assembled] {
		assert source.split_into_lines().filter(it.starts_with('.class ')) == ['.class public L' + target + ';']
		assert source.split_into_lines().filter(it.starts_with('.super ')) == ['.super Landroid/graphics/drawable/ShapeDrawable;']
		assert source.split_into_lines().filter(it.starts_with('.field ')).len == 0
		actual := methods(source)
		assert actual.keys().sorted() == signatures.sorted(), 'exact five PaintDrawable methods required'
		mut metadata := source
		for signature, body in actual {
			header := if signature.starts_with('<init>') { '.method public constructor ' }
				else if signature.starts_with('inflateTag(') { '.method protected ' } else { '.method public ' }
			assert body.all_before('\n') == header + signature, 'wrong added method access/ABI'
			metadata = metadata.replace(body, '')
		}
		assert norm(metadata) == '.class public L' + target + ';\n.super Landroid/graphics/drawable/ShapeDrawable;', 'unreviewed class metadata'
	}
	before, after := methods(raw), methods(assembled)
	for name, body in before {
		parameters := if name == '<init>()V' { 1 } else if name.starts_with('inflateTag(') { 5 } else { 2 }
		assert canonical(body, parameters) == canonical(after[name], parameters), 'DEX changed PaintDrawable instructions: ' + name
	}
}

fn canonical_controls() {
	source := '.method public probe(I)V\n.locals 1\n:start\nconst/4 v0, 0x0\nif-eqz p1, :done\nreturn-void\n:done\nreturn-void\n.end method'
	roundtrip := source.replace('.locals 1', '.registers 3').replace(':start', ':cond_0').replace(':done', ':cond_5')
	assert canonical(source, 2) == canonical(roundtrip, 2), 'register/label spelling must be equivalent'
	for changed in [source.replace('if-eqz p1, :done', 'if-eqz p1, :start'),
		source.replace('if-eqz p1, :done', 'if-nez p1, :done'),
		source.replace('const/4 v0, 0x0', 'const/4 v0, 0x1')] {
		assert canonical(source, 2) != canonical(changed, 2), 'oracle must retain targets, operations and values'
	}
}

fn refuse(root string, class_path string) {
	mut refused := false
	androidtools.framework_paint_drawable(root) or { refused = true }
	assert refused && !os.exists(class_path) && !os.is_link(class_path), 'refusal must precede class creation'
}

fn main() {
	assert os.args.len in [2, 3], 'WORK [--roundtrip]'
	canonical_controls()
	work := os.args[1]
	added := androidtools.framework_paint_drawable_classes()
	assert added.keys() == [target], 'only PaintDrawable may be added'
	generated := added[target]
	verify_added(generated, generated)
	if os.args.len == 3 {
		assert os.args[2] == '--roundtrip'
		baseline_files := os.walk_ext(work + '/baseline-roundtrip', '.smali').sorted()
		patched_files := os.walk_ext(work + '/patched-roundtrip', '.smali').sorted()
		assert baseline_files.len == 2107 && patched_files.len == 2108
		for path in baseline_files {
			name := path.all_after(work + '/baseline-roundtrip/')
			other := work + '/patched-roundtrip/' + name
			assert os.is_file(other) && digest(path)! == digest(other)!, 'DEX changed retained neighbor: ' + name
		}
		verify_added(generated, os.read_file(work + '/patched-roundtrip/' + target + '.smali')!)
		println('PAINT-DRAWABLE-ROUNDTRIP-PASS classes=2108 one-added-class exact-instructions all-2107-neighbors-unchanged')
		return
	}
	root := work + '/proof'
	class_path := root + '/' + target + '.smali'
	mut neighbors := map[string]string{}
	for path in os.walk_ext(root, '.smali') { neighbors[path] = digest(path)! }
	assert neighbors.len == 2107 && !os.exists(class_path) && !os.is_link(class_path)
	mut cases := 0
	for dependency in dependencies() {
		path := root + '/' + dependency.owner + '.smali'
		old := os.read_file(path)!
		class_line := '.class ' + dependency.header + ' L' + dependency.owner + ';'
		super_line := '.super L' + dependency.parent + ';'
		assert old.split_into_lines().filter(it.starts_with('.class ')) == [class_line]
		assert old.split_into_lines().filter(it.starts_with('.super ')) == [super_line]
		mut invalids := [old.replace(class_line, class_line.replace('public', 'private')),
			old.replace(class_line, class_line.replace('L' + dependency.owner + ';', 'Lwrong/Dependency;')),
			old + '\n' + class_line + '\n', old.replace(super_line, '.super Lwrong/Parent;'),
			old + '\n' + super_line + '\n']
		for header in dependency.methods {
			name := header.all_after_last(' ')
			body := methods(old)[name]
			assert body.all_before('\n') == '.method ' + header
			invalids << [old.replace(body, ''), old + '\n' + body,
				old.replace(body, body.replace('.method ' + header, '.method private ' + name)),
				old.replace(body, body.replace('.method ' + header, '.method public static ' + name)),
				old.replace(body, body.replace('.end method', ''))]
		}
		for field in dependency.fields {
			assert old.split_into_lines().filter(it == field).len == 1
			invalids << [old.replace(field, ''), old + '\n' + field + '\n', old.replace(field, field.replace('public static final', 'private static final'))]
			if field.contains(' = ') { invalids << old.replace(field, field.all_before(' = ') + ' = 0x7') }
		}
		for invalid in invalids {
			assert invalid != old, 'negative mutation did not match dependency'
			os.write_file(path, invalid)!
			refuse(root, class_path)
			assert os.read_file(path)! == invalid, 'rejected dependency was changed'
			cases++
		}
		os.rm(path)!
		refuse(root, class_path)
		assert !os.exists(path) && !os.is_link(path)
		cases++
		os.mkdir(path)!
		os.write_file(path + '/sentinel', 'owned directory control')!
		refuse(root, class_path)
		assert os.read_file(path + '/sentinel')! == 'owned directory control'
		os.rm(path + '/sentinel')!
		os.rmdir(path)!
		cases++
		os.symlink('absent-dependency-target', path)!
		refuse(root, class_path)
		assert os.is_link(path) && os.readlink(path)! == 'absent-dependency-target'
		os.rm(path)!
		os.write_file(path, old)!
		cases++
	}
	os.mkdir_all(os.dir(class_path))!
	sentinel := 'owned collision control\x00\xff'
	os.write_file(class_path, sentinel)!
	mut file_refused := false
	androidtools.framework_paint_drawable(root) or { file_refused = true }
	assert file_refused && os.read_file(class_path)! == sentinel
	os.rm(class_path)!
	os.mkdir(class_path)!
	os.write_file(class_path + '/sentinel', sentinel)!
	mut directory_refused := false
	androidtools.framework_paint_drawable(root) or { directory_refused = true }
	assert directory_refused && os.read_file(class_path + '/sentinel')! == sentinel
	os.rm(class_path + '/sentinel')!
	os.rmdir(class_path)!
	os.symlink('absent-paint-target', class_path)!
	mut link_refused := false
	androidtools.framework_paint_drawable(root) or { link_refused = true }
	assert link_refused && os.is_link(class_path) && os.readlink(class_path)! == 'absent-paint-target'
	os.rm(class_path)!
	androidtools.framework_paint_drawable(root)!
	assert os.read_file(class_path)! == generated
	for path, pin in neighbors { assert digest(path)! == pin, 'provider changed neighbor: ' + path }
	assert os.walk_ext(root, '.smali').len == 2108
	println('PAINT-DRAWABLE-SOURCE-PASS rejected=' + (cases + 3).str() + ' one-added-class guarded-dependencies all-2107-neighbors')
}
