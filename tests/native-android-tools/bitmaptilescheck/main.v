// SPDX-License-Identifier: GPL-2.0-or-later
// The SDK extension must change only its two retained stubs and add the tile ABI.
module main

import androidtools
import os

const target = 'android/graphics/drawable/BitmapDrawable'
const changed = ['getPaint()Landroid/graphics/Paint;', 'setTileModeX(Landroid/graphics/Shader$TileMode;)V']
const added = ['draw(Landroid/graphics/Canvas;)V',
	'getTileModeX()Landroid/graphics/Shader$TileMode;', 'getTileModeY()Landroid/graphics/Shader$TileMode;',
	'setTileModeY(Landroid/graphics/Shader$TileMode;)V',
	'setTileModeXY(Landroid/graphics/Shader$TileMode;Landroid/graphics/Shader$TileMode;)V',
	'vinixTileMode(Landroid/graphics/Shader$TileMode;)I', 'nativeDrawTiles(Landroid/atl/GskCanvas;Landroid/graphics/Bitmap;IIIILandroid/graphics/Paint;II)V']

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

fn parameter_words(header string) int {
	params := header.all_after('(').all_before(')').bytes()
	mut total := if header.split(' ').contains('static') { 0 } else { 1 }
	mut i := 0
	for i < params.len {
		mut array := false
		for params[i] == `[` { array = true; i++ }
		kind := params[i]
		if kind == `L` { for params[i] != `;` { i++ } }
		total += if !array && kind in [`J`, `D`] { 2 } else { 1 }
		i++
	}
	return total
}

fn canonical(source string) string {
	lines := norm(source).split_into_lines()
	mut labels := map[string]string{}
	for line in lines { if line.starts_with(':') { labels[line] = ':label_' + labels.len.str() } }
	mut result := []string{}
	for line in lines {
		if line.starts_with('.locals ') {
			result << '.registers ' + (line.all_after(' ').int() + parameter_words(lines[0])).str()
			continue
		}
		mut parts := line.split(' ')
		for i, part in parts { if replacement := labels[part] { parts[i] = replacement } }
		result << parts.join(' ')
	}
	return result.join('\n')
}

fn shape(old string, patched string) {
	before, after := methods(old), methods(patched)
	assert after.len == before.len + added.len
	for name, body in before {
		assert name in after, 'missing retained method: ' + name
		if name in changed { assert after[name] != body }
		else { assert after[name] == body, 'unrelated method changed: ' + name }
	}
	for name in added { assert name !in before && name in after }
	mut expected_fields := old.split_into_lines().filter(it.starts_with('.field '))
	expected_fields << ['.field private vinixTileX:Landroid/graphics/Shader$TileMode;',
		'.field private vinixTileY:Landroid/graphics/Shader$TileMode;', '.field private vinixPaint:Landroid/graphics/Paint;']
	assert patched.split_into_lines().filter(it.starts_with('.field ')).sorted() == expected_fields.sorted()
	assert after[added[3]].starts_with('.method public final ')
	assert after[added[4]].starts_with('.method public ')
	assert after[added[5]].starts_with('.method private static ')
	assert norm(after[added[6]]) == '.method private static native ' + added[6] + '\n.end method'
	assert after[added[0]].contains('invoke-super {p0, p1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V')
}

fn main() {
	assert os.args.len in [2, 3], 'WORK [--roundtrip]'
	work := os.args[1]
	old := os.read_file(work + '/baseline/' + target + '.smali')!
	patched := androidtools.framework_bitmap_tiles_source(old)!
	shape(old, patched)
	if os.args.len == 3 {
		assert os.args[2] == '--roundtrip'
		roundtrip := os.read_file(work + '/patched-roundtrip/' + target + '.smali')!
		actual := methods(roundtrip)
		for name, body in methods(patched) { assert canonical(actual[name]) == canonical(body), 'DEX changed instructions: ' + name }
		assert actual.len == methods(patched).len
		for name in ['android/graphics/Bitmap', 'android/graphics/BitmapShader', 'android/graphics/Canvas',
			'android/graphics/Paint', 'android/graphics/Shader$TileMode', 'android/graphics/drawable/Drawable'] {
			assert os.read_file(work + '/baseline-roundtrip/' + name + '.smali')! == os.read_file(work + '/patched-roundtrip/' + name + '.smali')!, 'neighbor changed: ' + name
		}
		return
	}
	path := work + '/proof/' + target + '.smali'
	getter := methods(old)[changed[0]]
	setter := methods(old)[changed[1]]
	mut invalids := [patched,
		old.replace('.class public Landroid/graphics/drawable/BitmapDrawable;', '.class private Landroid/graphics/drawable/BitmapDrawable;'),
		old.replace('.class public Landroid/graphics/drawable/BitmapDrawable;', '.class public Lwrong/BitmapDrawable;'),
		old.replace('.super Landroid/graphics/drawable/Drawable;', '.super Ljava/lang/Object;'),
		old.replace('.field private bitmap:', '.field public bitmap:'),
		old + '\n.field private extra:I\n', old + '\n.field private bitmap:Landroid/graphics/Bitmap;\n',
		old.replace(getter, ''), old + '\n' + getter, old.replace(getter, getter.replace('.end method', '')),
		old.replace(getter, getter.replace('.method public ', '.method public static ')),
		old.replace(getter, getter.replace('new-instance v0, Landroid/graphics/Paint;', 'const/4 v0, 0x0')),
		old.replace(getter, getter.replace('.registers 2', '.registers 3')),
		old.replace(setter, ''), old + '\n' + setter, old.replace(setter, setter.replace('.end method', '')),
		old.replace(setter, setter.replace('.method public ', '.method private ')),
		old.replace(setter, setter.replace('return-void', 'const/4 v0, 0x1\nreturn-void'))]
	for marker in ['vinixTile', 'vinixPaint', 'nativeDrawTiles', ' getTileModeX(', ' getTileModeY(',
		' setTileModeY(', ' setTileModeXY(', ' draw('] { invalids << old + '\n# ' + marker + '\n' }
	for invalid in invalids {
		assert invalid != old, 'negative mutation must actually change the input'
		os.write_file(path, invalid)!
		mut refused := false
		androidtools.framework_bitmap_tiles(work + '/proof') or { refused = true }
		assert refused && os.read_file(path)! == invalid, 'refusal must precede mutation'
	}
	os.write_file(path, old)!
	androidtools.framework_bitmap_tiles(work + '/proof')!
	assert os.read_file(path)! == patched
	println('BITMAP-TILES-SOURCE-PASS rejected=' + invalids.len.str() + ' retained-methods exact-native-ABI')
}
