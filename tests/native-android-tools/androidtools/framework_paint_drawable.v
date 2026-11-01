// SPDX-License-Identifier: GPL-2.0-or-later
module androidtools

import os

// PaintDrawable supplies shape selection; the retained ShapeDrawable owns paint,
// bounds, alpha, shader, callback and Canvas rendering behavior.
pub fn framework_paint_drawable_classes() map[string]string {
	return {'android/graphics/drawable/PaintDrawable': '.class public Landroid/graphics/drawable/PaintDrawable;
.super Landroid/graphics/drawable/ShapeDrawable;

.method public constructor <init>()V
.locals 0
invoke-direct {p0}, Landroid/graphics/drawable/ShapeDrawable;-><init>()V
return-void
.end method

.method public constructor <init>(I)V
.locals 1
invoke-direct {p0}, Landroid/graphics/drawable/ShapeDrawable;-><init>()V
invoke-virtual {p0}, Landroid/graphics/drawable/ShapeDrawable;->getPaint()Landroid/graphics/Paint;
move-result-object v0
invoke-virtual {v0, p1}, Landroid/graphics/Paint;->setColor(I)V
return-void
.end method

.method public setCornerRadius(F)V
.locals 3
const/4 v0, 0x0
const/4 v1, 0x0
cmpl-float v1, p1, v1
if-lez v1, :apply
const/16 v1, 0x8
new-array v0, v1, [F
const/4 v2, 0x0
:fill
if-ge v2, v1, :apply
aput p1, v0, v2
add-int/lit8 v2, v2, 0x1
goto :fill
:apply
invoke-virtual {p0, v0}, Landroid/graphics/drawable/PaintDrawable;->setCornerRadii([F)V
return-void
.end method

.method public setCornerRadii([F)V
.locals 2
if-nez p1, :rounded
invoke-virtual {p0}, Landroid/graphics/drawable/ShapeDrawable;->getShape()Landroid/graphics/drawable/shapes/Shape;
move-result-object v0
if-eqz v0, :invalidate
const/4 v0, 0x0
invoke-virtual {p0, v0}, Landroid/graphics/drawable/ShapeDrawable;->setShape(Landroid/graphics/drawable/shapes/Shape;)V
goto :invalidate
:rounded
new-instance v0, Landroid/graphics/drawable/shapes/RoundRectShape;
const/4 v1, 0x0
invoke-direct {v0, p1, v1, v1}, Landroid/graphics/drawable/shapes/RoundRectShape;-><init>([FLandroid/graphics/RectF;[F)V
invoke-virtual {p0, v0}, Landroid/graphics/drawable/ShapeDrawable;->setShape(Landroid/graphics/drawable/shapes/Shape;)V
:invalidate
invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->invalidateSelf()V
return-void
.end method

.method protected inflateTag(Ljava/lang/String;Landroid/content/res/Resources;Lorg/xmlpull/v1/XmlPullParser;Landroid/util/AttributeSet;)Z
.locals 8
const-string v0, "corners"
invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
move-result v0
if-eqz v0, :fallback
sget-object v0, Lcom/android/internal/R$styleable;->DrawableCorners:[I
invoke-virtual {p2, p4, v0}, Landroid/content/res/Resources;->obtainAttributes(Landroid/util/AttributeSet;[I)Landroid/content/res/TypedArray;
move-result-object v0
const/4 v1, 0x0
invoke-virtual {v0, v1, v1}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I
move-result v1
int-to-float v6, v1
invoke-virtual {p0, v6}, Landroid/graphics/drawable/PaintDrawable;->setCornerRadius(F)V
const/4 v6, 0x1
invoke-virtual {v0, v6, v1}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I
move-result v2
const/4 v6, 0x2
invoke-virtual {v0, v6, v1}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I
move-result v3
const/4 v6, 0x3
invoke-virtual {v0, v6, v1}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I
move-result v4
const/4 v6, 0x4
invoke-virtual {v0, v6, v1}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I
move-result v5
if-ne v2, v1, :per_corner
if-ne v3, v1, :per_corner
if-ne v4, v1, :per_corner
if-eq v5, v1, :corners_done
:per_corner
const/16 v6, 0x8
new-array v7, v6, [F
int-to-float v2, v2
int-to-float v3, v3
int-to-float v4, v4
int-to-float v5, v5
const/4 v6, 0x0
aput v2, v7, v6
const/4 v6, 0x1
aput v2, v7, v6
const/4 v6, 0x2
aput v3, v7, v6
const/4 v6, 0x3
aput v3, v7, v6
const/4 v6, 0x4
aput v4, v7, v6
const/4 v6, 0x5
aput v4, v7, v6
const/4 v6, 0x6
aput v5, v7, v6
const/4 v6, 0x7
aput v5, v7, v6
invoke-virtual {p0, v7}, Landroid/graphics/drawable/PaintDrawable;->setCornerRadii([F)V
:corners_done
invoke-virtual {v0}, Landroid/content/res/TypedArray;->recycle()V
const/4 v0, 0x1
return v0
:fallback
invoke-super {p0, p1, p2, p3, p4}, Landroid/graphics/drawable/ShapeDrawable;->inflateTag(Ljava/lang/String;Landroid/content/res/Resources;Lorg/xmlpull/v1/XmlPullParser;Landroid/util/AttributeSet;)Z
move-result v0
return v0
.end method
'}
}

pub fn framework_paint_drawable_dependencies() map[string][]string {
	return {
		'android/graphics/drawable/ShapeDrawable': ['.class public Landroid/graphics/drawable/ShapeDrawable;', '.super Landroid/graphics/drawable/Drawable;',
			'public constructor <init>()V', 'public getPaint()Landroid/graphics/Paint;', 'public getShape()Landroid/graphics/drawable/shapes/Shape;',
			'public setShape(Landroid/graphics/drawable/shapes/Shape;)V', 'protected inflateTag(Ljava/lang/String;Landroid/content/res/Resources;Lorg/xmlpull/v1/XmlPullParser;Landroid/util/AttributeSet;)Z']
		'android/graphics/drawable/shapes/RoundRectShape': ['.class public Landroid/graphics/drawable/shapes/RoundRectShape;', '.super Landroid/graphics/drawable/shapes/RectShape;',
			'public constructor <init>([FLandroid/graphics/RectF;[F)V']
		'android/graphics/Paint': ['.class public Landroid/graphics/Paint;', '.super Ljava/lang/Object;', 'public setColor(I)V']
		'android/graphics/drawable/Drawable': ['.class public Landroid/graphics/drawable/Drawable;', '.super Ljava/lang/Object;', 'public invalidateSelf()V']
		'android/content/res/Resources': ['.class public Landroid/content/res/Resources;', '.super Ljava/lang/Object;', 'public obtainAttributes(Landroid/util/AttributeSet;[I)Landroid/content/res/TypedArray;']
		'android/content/res/TypedArray': ['.class public Landroid/content/res/TypedArray;', '.super Ljava/lang/Object;', 'public getDimensionPixelSize(II)I', 'public recycle()V']
		'com/android/internal/R$styleable': ['.class public final Lcom/android/internal/R$styleable;', '.super Ljava/lang/Object;']
	}
}

pub fn framework_paint_drawable(smali string) ! {
	classes := framework_paint_drawable_classes()
	for name, _ in classes {
		path := smali + '/' + name + '.smali'
		if os.exists(path) || os.is_link(path) { return error('PaintDrawable API type already exists') }
	}
	for name, requirements in framework_paint_drawable_dependencies() {
		path := smali + '/' + name + '.smali'
		if os.is_link(path) || os.lstat(path)!.get_filetype() != .regular { return error('plain PaintDrawable dependency required: ' + name) }
		source := os.read_file(path)!
		lines := source.split_into_lines()
		if lines.filter(it.starts_with('.class ')) != [requirements[0]] || lines.filter(it.starts_with('.super ')) != [requirements[1]] {
			return error('canonical PaintDrawable dependency required: ' + name)
		}
		mut methods := map[string]string{}
		for block in source.split('.method ')[1..] {
			header := block.all_before('\n')
			signature := header.all_after_last(' ')
			if signature in methods || !block.contains('.end method') { return error('unique complete PaintDrawable dependency methods required') }
			methods[signature] = header
		}
		if methods.len != source.count('.end method') { return error('PaintDrawable dependency method schema differs') }
		for expected in requirements[2..] {
			if methods[expected.all_after_last(' ')] or { '' } != expected { return error('retained PaintDrawable dependency method required: ' + expected) }
		}
		if name == 'com/android/internal/R$styleable' {
			for field in ['DrawableCorners:[I', 'DrawableCorners_radius:I = 0x0', 'DrawableCorners_topLeftRadius:I = 0x1',
				'DrawableCorners_topRightRadius:I = 0x2', 'DrawableCorners_bottomLeftRadius:I = 0x3', 'DrawableCorners_bottomRightRadius:I = 0x4'] {
				expected := '.field public static final ' + field
				member := field.all_before(' = ')
				if lines.filter(it.starts_with('.field ') && it.all_before(' = ').all_after_last(' ') == member) != [expected] {
					return error('retained PaintDrawable corner styleable required: ' + field)
				}
			}
		}
	}
	for name, source in classes {
		path := smali + '/' + name + '.smali'
		os.mkdir_all(os.dir(path))!
		os.write_file(path, source)!
	}
}
