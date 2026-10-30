// SPDX-License-Identifier: GPL-2.0-or-later
module androidtools

import os

// Native bitmap sampling fills the actual transformed pixel clip. Inherited
// BitmapShader/Paint shader rendering is not used or advertised by this patch.
pub fn framework_bitmap_tiles_source(original string) !string {
	if original.split_into_lines().filter(it.starts_with('.class ')) != ['.class public Landroid/graphics/drawable/BitmapDrawable;']
		|| original.split_into_lines().filter(it.starts_with('.super ')) != ['.super Landroid/graphics/drawable/Drawable;'] {
		return error('canonical BitmapDrawable required')
	}
	for marker in ['vinixTile', 'vinixPaint', 'nativeDrawTiles', ' getTileModeX(', ' getTileModeY(',
		' setTileModeY(', ' setTileModeXY(', ' draw('] {
		if original.contains(marker) { return error('bitmap tiling API already present: ' + marker) }
	}
	for signature in ['getPaint()Landroid/graphics/Paint;', 'setTileModeX(Landroid/graphics/Shader$TileMode;)V'] {
		if original.split_into_lines().filter(it.starts_with('.method ') && it.ends_with(' ' + signature)).len != 1 {
			return error('unique retained BitmapDrawable method required: ' + signature)
		}
	}
	for signature, retained in {
		'getPaint()Landroid/graphics/Paint;': '.method public getPaint()Landroid/graphics/Paint;\n.registers 2\nnew-instance v0, Landroid/graphics/Paint;\ninvoke-direct {v0}, Landroid/graphics/Paint;-><init>()V\nreturn-object v0\n.end method'
		'setTileModeX(Landroid/graphics/Shader$TileMode;)V': '.method public setTileModeX(Landroid/graphics/Shader$TileMode;)V\n.registers 2\nreturn-void\n.end method'
	} {
		for block in original.split('.method ')[1..] {
			if !block.all_before('\n').ends_with(' ' + signature) { continue }
			end := block.index('.end method') or { return error('unterminated BitmapDrawable method') }
			canonical := ('.method ' + block[..end + '.end method'.len]).split_into_lines().map(it.trim_space()).filter(it != '').join('\n')
			if canonical != retained { return error('retained BitmapDrawable method body required: ' + signature) }
		}
	}
	if original.split_into_lines().filter(it.starts_with('.field ')) != ['.field private bitmap:Landroid/graphics/Bitmap;'] {
		return error('retained BitmapDrawable bitmap field required')
	}
	mut text := original + '\n.field private vinixTileX:Landroid/graphics/Shader$TileMode;\n.field private vinixTileY:Landroid/graphics/Shader$TileMode;\n.field private vinixPaint:Landroid/graphics/Paint;\n'
	text = framework_replace_method(text, 'getPaint()Landroid/graphics/Paint;', '.method public getPaint()Landroid/graphics/Paint;\n.locals 1\niget-object v0, p0, Landroid/graphics/drawable/BitmapDrawable;->vinixPaint:Landroid/graphics/Paint;\nif-nez v0, :ready\nnew-instance v0, Landroid/graphics/Paint;\ninvoke-direct {v0}, Landroid/graphics/Paint;-><init>()V\niput-object v0, p0, Landroid/graphics/drawable/BitmapDrawable;->vinixPaint:Landroid/graphics/Paint;\n:ready\nreturn-object v0\n.end method')!
	text = framework_replace_method(text, 'setTileModeX(Landroid/graphics/Shader$TileMode;)V', '.method public setTileModeX(Landroid/graphics/Shader$TileMode;)V\n.locals 1\niget-object v0, p0, Landroid/graphics/drawable/BitmapDrawable;->vinixTileY:Landroid/graphics/Shader$TileMode;\ninvoke-virtual {p0, p1, v0}, Landroid/graphics/drawable/BitmapDrawable;->setTileModeXY(Landroid/graphics/Shader$TileMode;Landroid/graphics/Shader$TileMode;)V\nreturn-void\n.end method')!
	text += '
.method public final setTileModeY(Landroid/graphics/Shader$TileMode;)V
.locals 1
iget-object v0, p0, Landroid/graphics/drawable/BitmapDrawable;->vinixTileX:Landroid/graphics/Shader$TileMode;
invoke-virtual {p0, v0, p1}, Landroid/graphics/drawable/BitmapDrawable;->setTileModeXY(Landroid/graphics/Shader$TileMode;Landroid/graphics/Shader$TileMode;)V
return-void
.end method

.method public setTileModeXY(Landroid/graphics/Shader$TileMode;Landroid/graphics/Shader$TileMode;)V
.locals 1
iget-object v0, p0, Landroid/graphics/drawable/BitmapDrawable;->vinixTileX:Landroid/graphics/Shader$TileMode;
if-ne v0, p1, :changed
iget-object v0, p0, Landroid/graphics/drawable/BitmapDrawable;->vinixTileY:Landroid/graphics/Shader$TileMode;
if-eq v0, p2, :done
:changed
iput-object p1, p0, Landroid/graphics/drawable/BitmapDrawable;->vinixTileX:Landroid/graphics/Shader$TileMode;
iput-object p2, p0, Landroid/graphics/drawable/BitmapDrawable;->vinixTileY:Landroid/graphics/Shader$TileMode;
invoke-virtual {p0}, Landroid/graphics/drawable/BitmapDrawable;->invalidateSelf()V
:done
return-void
.end method

.method public getTileModeX()Landroid/graphics/Shader$TileMode;
.locals 1
iget-object v0, p0, Landroid/graphics/drawable/BitmapDrawable;->vinixTileX:Landroid/graphics/Shader$TileMode;
return-object v0
.end method

.method public getTileModeY()Landroid/graphics/Shader$TileMode;
.locals 1
iget-object v0, p0, Landroid/graphics/drawable/BitmapDrawable;->vinixTileY:Landroid/graphics/Shader$TileMode;
return-object v0
.end method

# TileMode enum ordinals are CLAMP=0, MIRROR=1, REPEAT=2 in the input SDK.
# Convert explicitly to the native sampler ABI, preserving null as CLAMP.
.method private static vinixTileMode(Landroid/graphics/Shader$TileMode;)I
.locals 1
sget-object v0, Landroid/graphics/Shader$TileMode;->REPEAT:Landroid/graphics/Shader$TileMode;
if-ne p0, v0, :other
const/4 v0, 0x1
return v0
:other
sget-object v0, Landroid/graphics/Shader$TileMode;->MIRROR:Landroid/graphics/Shader$TileMode;
if-ne p0, v0, :clamp
const/4 v0, 0x2
return v0
:clamp
const/4 v0, 0x0
return v0
.end method

# Native arguments keep the Bitmap and Paint strongly reachable until drawing
# returns, including a Paint returned by an overriding getPaint() method.
.method private static native nativeDrawTiles(Landroid/atl/GskCanvas;Landroid/graphics/Bitmap;IIIILandroid/graphics/Paint;II)V
.end method

.method public draw(Landroid/graphics/Canvas;)V
.locals 10
iget-object v9, p0, Landroid/graphics/drawable/BitmapDrawable;->vinixTileX:Landroid/graphics/Shader$TileMode;
if-nez v9, :tiled
iget-object v9, p0, Landroid/graphics/drawable/BitmapDrawable;->vinixTileY:Landroid/graphics/Shader$TileMode;
if-nez v9, :tiled
invoke-super {p0, p1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V
return-void
:tiled
iget-object v1, p0, Landroid/graphics/drawable/BitmapDrawable;->bitmap:Landroid/graphics/Bitmap;
if-eqz v1, :done
invoke-virtual {p1}, Landroid/graphics/Canvas;->vinixNativeCanvas()Landroid/atl/GskCanvas;
move-result-object v0
invoke-virtual {p0}, Landroid/graphics/drawable/BitmapDrawable;->getBounds()Landroid/graphics/Rect;
move-result-object v9
iget v2, v9, Landroid/graphics/Rect;->left:I
iget v3, v9, Landroid/graphics/Rect;->top:I
iget v4, v9, Landroid/graphics/Rect;->right:I
iget v5, v9, Landroid/graphics/Rect;->bottom:I
invoke-virtual {p0}, Landroid/graphics/drawable/BitmapDrawable;->getPaint()Landroid/graphics/Paint;
move-result-object v6
iget-object v9, p0, Landroid/graphics/drawable/BitmapDrawable;->vinixTileX:Landroid/graphics/Shader$TileMode;
invoke-static {v9}, Landroid/graphics/drawable/BitmapDrawable;->vinixTileMode(Landroid/graphics/Shader$TileMode;)I
move-result v7
iget-object v9, p0, Landroid/graphics/drawable/BitmapDrawable;->vinixTileY:Landroid/graphics/Shader$TileMode;
invoke-static {v9}, Landroid/graphics/drawable/BitmapDrawable;->vinixTileMode(Landroid/graphics/Shader$TileMode;)I
move-result v8
invoke-static/range {v0 .. v8}, Landroid/graphics/drawable/BitmapDrawable;->nativeDrawTiles(Landroid/atl/GskCanvas;Landroid/graphics/Bitmap;IIIILandroid/graphics/Paint;II)V
:done
return-void
.end method
'
	return text
}

pub fn framework_bitmap_tiles(smali string) ! {
	path := smali + '/android/graphics/drawable/BitmapDrawable.smali'
	os.write_file(path, framework_bitmap_tiles_source(os.read_file(path)!)!)!
}
