// SPDX-License-Identifier: GPL-2.0-or-later
module main

const package_name = 'org.vinix.bootstrap'
const main_type = 'Lorg/vinix/bootstrap/Main;'
const drawable_type = 'Landroid/graphics/drawable/PaintDrawable;'
const paint_color = '0xffc02010'
const pass_marker = 'PAINT-DRAWABLE-PASS constructors corners invalidation arrays pixels inflation canvas-state'
const fail_marker = 'PAINT-DRAWABLE-FAIL'

fn method(signature string, locals int, body string) string {
	return '.method ${signature}\n.locals ${locals}\n${body}\n.end method\n'
}

fn failure(message string) string {
	return ':bad\nnew-instance v0, Ljava/lang/AssertionError;\nconst-string v1, "${message}"\n' +
		'invoke-direct {v0, v1}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V\nthrow v0'
}

fn resource_xmls() map[string]string {
	prefix := '<shape xmlns:android="http://schemas.android.com/apk/res/android">'
	return {
		'paint_uniform': prefix + '<corners android:radius="4px"/></shape>'
		'paint_asymmetric': prefix + '<corners android:radius="4px" android:topLeftRadius="0px" android:bottomLeftRadius="0px"/></shape>'
		'paint_reset': prefix + '<corners android:radius="4px"/><corners android:radius="0px"/></shape>'
		'paint_padding': prefix + '<padding android:left="1px" android:top="2px" android:right="3px" android:bottom="4px"/></shape>'
	}
}

fn resource_names() []string { return resource_xmls().keys().map('xml/' + it).sorted() }

fn verify_resource_dump(value string, ids map[string]string) {
	for name in resource_names() { assert value.contains(ids[name] + ' ' + name), 'signed XML resource ID missing: ' + name }
}

fn verify_xml_dump(name string, value string) {
	assert value.contains('E: shape')
	if name == 'paint_padding' {
		assert value.count('E: padding') == 1 && !value.contains('E: corners')
		for attr in ['left', 'top', 'right', 'bottom'] { assert value.contains('android:' + attr + '('), 'signed padding attribute missing' }
	} else {
		assert value.count('E: corners') == if name == 'paint_reset' { 2 } else { 1 }
		assert value.contains('android:radius('), 'signed corner radius missing'
		if name == 'paint_asymmetric' {
			assert value.contains('android:topLeftRadius(') && value.contains('android:bottomLeftRadius(')
		}
	}
}

fn assertions_source() string {
	return method('private static expectInt(II)V', 2, '
if-ne p0, p1, :bad
return-void
' + failure('Integer or ARGB state differs')) +
	method('private static expectShape(${drawable_type}Z)V', 2, '
invoke-virtual {p0}, ${drawable_type}->getShape()Landroid/graphics/drawable/shapes/Shape;
move-result-object v0
if-nez p1, :rounded
if-nez v0, :bad
return-void
:rounded
instance-of v1, v0, Landroid/graphics/drawable/shapes/RoundRectShape;
if-eqz v1, :bad
return-void
' + failure('Corner setter must select the retained RoundRectShape or null rectangle path')) +
	method('private static expectPaint(${drawable_type}Landroid/graphics/Paint;II)V', 2, '
invoke-virtual {p0}, ${drawable_type}->getPaint()Landroid/graphics/Paint;
move-result-object v0
if-ne v0, p1, :bad
invoke-virtual {v0}, Landroid/graphics/Paint;->getColor()I
move-result v1
if-ne v1, p2, :bad
invoke-virtual {v0}, Landroid/graphics/Paint;->getAlpha()I
move-result v1
if-ne v1, p3, :bad
return-void
' + failure('PaintDrawable must retain its mutable inherited Paint, color and alpha')) +
	method('public invalidateDrawable(Landroid/graphics/drawable/Drawable;)V', 1, '
iget v0, p0, ${main_type}->invalidations:I
add-int/lit8 v0, v0, 1
iput v0, p0, ${main_type}->invalidations:I
return-void') +
	method('public scheduleDrawable(Landroid/graphics/drawable/Drawable;Ljava/lang/Runnable;J)V', 0, 'return-void') +
	method('public unscheduleDrawable(Landroid/graphics/drawable/Drawable;Ljava/lang/Runnable;)V', 0, 'return-void') +
	method('private resetInvalidations()V', 1, '
const/4 v0, 0
iput v0, p0, ${main_type}->invalidations:I
return-void') +
	method('private expectInvalidations(I)V', 2, '
iget v0, p0, ${main_type}->invalidations:I
if-ne v0, p1, :bad
return-void
' + failure('Corner invalidations must retain exact AOSP setter and inherited setShape callbacks')) +
	method('private static radius(${drawable_type}F${main_type}IZ)V', 2, '
invoke-direct {p2}, ${main_type}->resetInvalidations()V
invoke-virtual {p0, p1}, ${drawable_type}->setCornerRadius(F)V
invoke-direct {p2, p3}, ${main_type}->expectInvalidations(I)V
invoke-static {p0, p4}, ${main_type}->expectShape(${drawable_type}Z)V
return-void') +
	method('private static nullRadii(${drawable_type}${main_type}I)V', 1, '
invoke-direct {p1}, ${main_type}->resetInvalidations()V
const/4 v0, 0
invoke-virtual {p0, v0}, ${drawable_type}->setCornerRadii([F)V
invoke-direct {p1, p2}, ${main_type}->expectInvalidations(I)V
const/4 v0, 0
invoke-static {p0, v0}, ${main_type}->expectShape(${drawable_type}Z)V
return-void')
}

fn state_source() string {
	mut body := '
new-instance v0, ${drawable_type}
invoke-direct {v0}, ${drawable_type}-><init>()V
instance-of v2, v0, Landroid/graphics/drawable/ShapeDrawable;
if-eqz v2, :bad
invoke-virtual {v0}, ${drawable_type}->getPaint()Landroid/graphics/Paint;
move-result-object v1
const v2, 0xff000000
const/16 v3, 255
invoke-static {v0, v1, v2, v3}, ${main_type}->expectPaint(${drawable_type}Landroid/graphics/Paint;II)V
const/4 v2, 0
invoke-static {v0, v2}, ${main_type}->expectShape(${drawable_type}Z)V
new-instance v0, ${drawable_type}
const v2, ${paint_color}
invoke-direct {v0, v2}, ${drawable_type}-><init>(I)V
invoke-virtual {v0}, ${drawable_type}->getPaint()Landroid/graphics/Paint;
move-result-object v1
invoke-static {v0, v1, v2, v3}, ${main_type}->expectPaint(${drawable_type}Landroid/graphics/Paint;II)V
const/4 v2, 2
const/16 v3, 14
invoke-virtual {v0, v2, v2, v3, v3}, ${drawable_type}->setBounds(IIII)V
invoke-virtual {v0, p0}, ${drawable_type}->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V
const/4 v2, 1
invoke-static {v0, p0, v2}, ${main_type}->nullRadii(${drawable_type}${main_type}I)V
'
	for i, bits in ['0x40800000', '0x40800000', '0x0', '0x80000000', '0x40800000', '0xc0000000', '0x40800000', '0x7fc01234'] {
		callbacks := if i == 3 { 1 } else { 2 }
		rounded := if i in [0, 1, 4, 6] { 1 } else { 0 }
		if i == 1 { body += 'invoke-virtual {v0}, ${drawable_type}->getShape()Landroid/graphics/drawable/shapes/Shape;\nmove-result-object v6\n' }
		body += 'const v2, ${bits}\nconst/4 v3, ${callbacks}\nconst/4 v4, ${rounded}\n' +
			'invoke-static {v0, v2, p0, v3, v4}, ${main_type}->radius(${drawable_type}F${main_type}IZ)V\n'
		if i == 1 { body += 'invoke-virtual {v0}, ${drawable_type}->getShape()Landroid/graphics/drawable/shapes/Shape;\nmove-result-object v3\nif-eq v3, v6, :bad\n' }
	}
	body += '
const/16 v2, 9
new-array v5, v2, [F
invoke-direct {p0}, ${main_type}->resetInvalidations()V
invoke-virtual {v0, v5}, ${drawable_type}->setCornerRadii([F)V
const/4 v2, 2
invoke-direct {p0, v2}, ${main_type}->expectInvalidations(I)V
const/4 v2, 1
invoke-static {v0, v2}, ${main_type}->expectShape(${drawable_type}Z)V
invoke-virtual {v0}, ${drawable_type}->getShape()Landroid/graphics/drawable/shapes/Shape;
move-result-object v6
invoke-direct {p0}, ${main_type}->resetInvalidations()V
invoke-virtual {v0, v5}, ${drawable_type}->setCornerRadii([F)V
const/4 v2, 2
invoke-direct {p0, v2}, ${main_type}->expectInvalidations(I)V
invoke-virtual {v0}, ${drawable_type}->getShape()Landroid/graphics/drawable/shapes/Shape;
move-result-object v3
if-eq v3, v6, :bad
const/4 v2, 0
invoke-static {v0, v2, p0}, ${main_type}->rejectShort(${drawable_type}I${main_type})V
const/4 v2, 7
invoke-static {v0, v2, p0}, ${main_type}->rejectShort(${drawable_type}I${main_type})V
const/4 v2, 2
invoke-static {v0, p0, v2}, ${main_type}->nullRadii(${drawable_type}${main_type}I)V
const v2, ${paint_color}
const/16 v3, 255
invoke-static {v0, v1, v2, v3}, ${main_type}->expectPaint(${drawable_type}Landroid/graphics/Paint;II)V
return-void
' + failure('PaintDrawable constructors and corner setters differ')
	return method('private state()V', 7, body) +
	method('private static rejectShort(${drawable_type}I${main_type})V', 7, '
invoke-virtual {p0}, ${drawable_type}->getShape()Landroid/graphics/drawable/shapes/Shape;
move-result-object v3
invoke-virtual {p0}, ${drawable_type}->getPaint()Landroid/graphics/Paint;
move-result-object v4
invoke-virtual {v4}, Landroid/graphics/Paint;->getColor()I
move-result v5
invoke-virtual {v4}, Landroid/graphics/Paint;->getAlpha()I
move-result v6
invoke-direct {p2}, ${main_type}->resetInvalidations()V
new-array v2, p1, [F
:short_start
invoke-virtual {p0, v2}, ${drawable_type}->setCornerRadii([F)V
:short_end
goto :bad
.catch Ljava/lang/ArrayIndexOutOfBoundsException; {:short_start .. :short_end} :short_failed
:short_failed
move-exception v0
invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;
move-result-object v0
const-class v1, Ljava/lang/ArrayIndexOutOfBoundsException;
if-ne v0, v1, :bad
invoke-virtual {p0}, ${drawable_type}->getShape()Landroid/graphics/drawable/shapes/Shape;
move-result-object v0
if-ne v0, v3, :bad
const/4 v0, 0
invoke-direct {p2, v0}, ${main_type}->expectInvalidations(I)V
invoke-static {p0, v4, v5, v6}, ${main_type}->expectPaint(${drawable_type}Landroid/graphics/Paint;II)V
return-void
' + failure('Short radii must propagate the inherited exact exception without state or callbacks'))
}

fn canvas_source() string {
	return method('private static pixels(Landroid/graphics/Bitmap;)[I', 8, '
const/16 v0, 256
new-array v1, v0, [I
move-object v0, p0
const/4 v2, 0
const/16 v3, 16
const/4 v4, 0
const/4 v5, 0
const/16 v6, 16
const/16 v7, 16
invoke-virtual/range {v0 .. v7}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V
return-object v1') +
	method('private static canvasState(Landroid/graphics/Canvas;Landroid/graphics/Matrix;I)V', 7, '
invoke-virtual {p0}, Landroid/graphics/Canvas;->getSaveCount()I
move-result v0
if-ne v0, p2, :bad
const/16 v0, 9
new-array v1, v0, [F
new-array v2, v0, [F
invoke-virtual {p1, v1}, Landroid/graphics/Matrix;->getValues([F)V
invoke-virtual {p0}, Landroid/graphics/Canvas;->getMatrix()Landroid/graphics/Matrix;
move-result-object v0
invoke-virtual {v0, v2}, Landroid/graphics/Matrix;->getValues([F)V
const/4 v3, 0
:entry
aget v4, v1, v3
aget v5, v2, v3
cmpl-float v6, v4, v5
if-nez v6, :bad
add-int/lit8 v3, v3, 1
const/16 v0, 9
if-lt v3, v0, :entry
return-void
' + failure('Inherited drawing must preserve Canvas matrix and save stack')) +
	method('private static render(${drawable_type}I)Landroid/graphics/Bitmap;', 12, '
const/16 v0, 16
sget-object v1, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;
invoke-static {v0, v0, v1}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;
move-result-object v9
new-instance v0, Landroid/graphics/Canvas;
invoke-direct {v0, v9}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V
and-int/lit8 v1, p1, 2
if-eqz v1, :no_clip
const/high16 v1, 0x40800000
const/high16 v2, 0x41400000
invoke-virtual {v0, v1, v1, v2, v2}, Landroid/graphics/Canvas;->clipRect(FFFF)Z
:no_clip
and-int/lit8 v1, p1, 1
if-eqz v1, :no_positive_shift
const/high16 v1, 0x3f800000
invoke-virtual {v0, v1, v1}, Landroid/graphics/Canvas;->translate(FF)V
:no_positive_shift
and-int/lit8 v1, p1, 8
if-eqz v1, :no_negative_shift
const/high16 v1, 0xc0400000
invoke-virtual {v0, v1, v1}, Landroid/graphics/Canvas;->translate(FF)V
:no_negative_shift
invoke-virtual {v0}, Landroid/graphics/Canvas;->getMatrix()Landroid/graphics/Matrix;
move-result-object v8
invoke-virtual {v0}, Landroid/graphics/Canvas;->getSaveCount()I
move-result v10
invoke-virtual {p0}, ${drawable_type}->getPaint()Landroid/graphics/Paint;
move-result-object v11
invoke-virtual {v11}, Landroid/graphics/Paint;->getAlpha()I
move-result v7
const/4 v1, 2
const/16 v2, 14
and-int/lit8 v3, p1, 4
if-eqz v3, :nonempty
move v2, v1
:nonempty
const/16 v3, 14
invoke-virtual {p0, v1, v1, v2, v3}, ${drawable_type}->setBounds(IIII)V
invoke-virtual {p0, v0}, ${drawable_type}->draw(Landroid/graphics/Canvas;)V
invoke-static {v0, v8, v10}, ${main_type}->canvasState(Landroid/graphics/Canvas;Landroid/graphics/Matrix;I)V
invoke-virtual {p0}, ${drawable_type}->getPaint()Landroid/graphics/Paint;
move-result-object v1
if-ne v1, v11, :bad
invoke-virtual {v1}, Landroid/graphics/Paint;->getAlpha()I
move-result v1
if-ne v1, v7, :bad
return-object v9
' + failure('Draw must restore the retained Paint alpha'))
}

fn pixel_assertions_source() string {
	mut rounded := '
invoke-static {p0}, ${main_type}->pixels(Landroid/graphics/Bitmap;)[I
move-result-object v0
const/4 v1, 0
aget v2, v0, v1
if-nez v2, :bad
'
	for i, point in [[2, 2], [13, 2], [13, 13], [2, 13]] {
		rounded += 'const/16 v1, ${point[0]}\nadd-int/2addr v1, p3\nconst/16 v2, ${point[1]}\nadd-int/2addr v2, p3\nshl-int/lit8 v2, v2, 4\nadd-int/2addr v1, v2\n' +
			'aget v3, v0, v1\nmove v4, p1\nand-int/lit8 v5, p2, ${1 << i}\nif-eqz v5, :corner_${i}\nconst/4 v4, 0\n:corner_${i}\nif-ne v3, v4, :bad\n'
	}
	for point in [[8, 8], [8, 2]] {
		rounded += 'const/16 v1, ${point[0]}\nadd-int/2addr v1, p3\nconst/16 v2, ${point[1]}\nadd-int/2addr v2, p3\nshl-int/lit8 v2, v2, 4\nadd-int/2addr v1, v2\naget v3, v0, v1\nif-ne v3, p1, :bad\n'
	}
	rounded += 'return-void\n' + failure('Rounded/nonuniform corner interior and exterior pixels differ')
	return method('private static rounded(Landroid/graphics/Bitmap;III)V', 6, rounded) +
	method('private static rectangle(Landroid/graphics/Bitmap;II)V', 8, '
invoke-static {p0}, ${main_type}->pixels(Landroid/graphics/Bitmap;)[I
move-result-object v7
const/4 v0, 0
:cell
and-int/lit8 v1, v0, 15
shr-int/lit8 v2, v0, 4
const/4 v3, 0
and-int/lit8 v4, p2, 4
if-nez v4, :expected
const/4 v4, 2
const/16 v5, 14
and-int/lit8 v6, p2, 1
if-eqz v6, :no_positive
add-int/lit8 v4, v4, 1
add-int/lit8 v5, v5, 1
:no_positive
and-int/lit8 v6, p2, 8
if-eqz v6, :no_negative
add-int/lit8 v4, v4, -3
add-int/lit8 v5, v5, -3
:no_negative
if-lt v1, v4, :expected
if-lt v2, v4, :expected
if-ge v1, v5, :expected
if-ge v2, v5, :expected
and-int/lit8 v6, p2, 2
if-eqz v6, :inside
const/4 v4, 4
const/16 v5, 12
if-lt v1, v4, :expected
if-lt v2, v4, :expected
if-ge v1, v5, :expected
if-ge v2, v5, :expected
:inside
move v3, p1
:expected
aget v4, v7, v0
if-ne v4, v3, :bad
add-int/lit16 v0, v0, 1
const/16 v4, 256
if-lt v0, v4, :cell
return-void
' + failure('Complete rectangular pixel grid differs in bounds, color, alpha, clip or translation'))
}

fn pixel_cases_source() string {
	mut body := '
new-instance v0, ${drawable_type}
const v4, ${paint_color}
invoke-direct {v0, v4}, ${drawable_type}-><init>(I)V
invoke-virtual {v0}, ${drawable_type}->getPaint()Landroid/graphics/Paint;
move-result-object v1
'
	for flags in [0, 3, 8, 10, 4] {
		body += 'const/16 v2, ${flags}\ninvoke-static {v0, v2}, ${main_type}->render(${drawable_type}I)Landroid/graphics/Bitmap;\nmove-result-object v3\n' +
			'invoke-static {v3, v4, v2}, ${main_type}->rectangle(Landroid/graphics/Bitmap;II)V\n'
	}
	body += '
const/16 v2, 128
invoke-virtual {v0, v2}, ${drawable_type}->setAlpha(I)V
invoke-virtual {v0}, ${drawable_type}->getAlpha()I
move-result v3
invoke-static {v2, v3}, ${main_type}->expectInt(II)V
const/4 v2, 0
invoke-static {v0, v2}, ${main_type}->render(${drawable_type}I)Landroid/graphics/Bitmap;
move-result-object v3
const v4, 0x80c02010
invoke-static {v3, v4, v2}, ${main_type}->rectangle(Landroid/graphics/Bitmap;II)V
const/16 v2, 255
invoke-virtual {v0, v2}, ${drawable_type}->setAlpha(I)V
const v4, 0xff1020c0
invoke-virtual {v1, v4}, Landroid/graphics/Paint;->setColor(I)V
const/4 v2, 0
invoke-static {v0, v2}, ${main_type}->render(${drawable_type}I)Landroid/graphics/Bitmap;
move-result-object v3
invoke-static {v3, v4, v2}, ${main_type}->rectangle(Landroid/graphics/Bitmap;II)V
const/high16 v2, 0x40800000
invoke-virtual {v0, v2}, ${drawable_type}->setCornerRadius(F)V
'
	for shift in [0, 1] {
		body += 'const/4 v2, ${shift}\ninvoke-static {v0, v2}, ${main_type}->render(${drawable_type}I)Landroid/graphics/Bitmap;\nmove-result-object v3\n' +
			'const/16 v2, 15\nconst/4 v5, ${shift}\ninvoke-static {v3, v4, v2, v5}, ${main_type}->rounded(Landroid/graphics/Bitmap;III)V\n'
	}
	body += '
const/16 v2, 8
new-array v5, v2, [F
fill-array-data v5, :radii
invoke-virtual {v0, v5}, ${drawable_type}->setCornerRadii([F)V
const/4 v2, 0
invoke-static {v0, v2}, ${main_type}->render(${drawable_type}I)Landroid/graphics/Bitmap;
move-result-object v3
const/4 v2, 5
const/4 v4, 0
const v1, 0xff1020c0
invoke-static {v3, v1, v2, v4}, ${main_type}->rounded(Landroid/graphics/Bitmap;III)V
const/4 v1, 0
const/4 v2, 0
:clear_radii
aput v1, v5, v2
add-int/lit8 v2, v2, 1
const/16 v3, 8
if-lt v2, v3, :clear_radii
const/4 v1, 2
const/16 v2, 15
const/16 v3, 14
invoke-virtual {v0, v1, v1, v2, v3}, ${drawable_type}->setBounds(IIII)V
const/4 v2, 0
invoke-static {v0, v2}, ${main_type}->render(${drawable_type}I)Landroid/graphics/Bitmap;
move-result-object v3
const v4, 0xff1020c0
invoke-static {v3, v4, v2}, ${main_type}->rectangle(Landroid/graphics/Bitmap;II)V
const/high16 v2, 0x40800000
invoke-virtual {v0, v2}, ${drawable_type}->setCornerRadius(F)V
const/4 v2, 0
invoke-virtual {v0, v2}, ${drawable_type}->setCornerRadius(F)V
invoke-static {v0, v2}, ${main_type}->expectShape(${drawable_type}Z)V
invoke-static {v0, v2}, ${main_type}->render(${drawable_type}I)Landroid/graphics/Bitmap;
move-result-object v3
invoke-static {v3, v4, v2}, ${main_type}->rectangle(Landroid/graphics/Bitmap;II)V
return-void
:radii
.array-data 4
0x40800000
0x40800000
0x0
0x0
0x40800000
0x40800000
0x0
0x0
.end array-data'
	return method('private static pixelCases()V', 6, body)
}

fn inflation_source(ids map[string]string) string {
	mut cases := ''
	for name in ['paint_uniform', 'paint_asymmetric', 'paint_reset', 'paint_padding'] {
		cases += 'const v1, ${ids['xml/' + name]}\ninvoke-static {p0, v1}, ${main_type}->inflate(Landroid/content/res/Resources;I)${drawable_type}\nmove-result-object v0\n'
		if name in ['paint_uniform', 'paint_asymmetric'] {
			mask := if name == 'paint_uniform' { 15 } else { 10 }
			cases += 'const/4 v1, 1\ninvoke-static {v0, v1}, ${main_type}->expectShape(${drawable_type}Z)V\nconst/4 v1, 0\n' +
				'invoke-static {v0, v1}, ${main_type}->render(${drawable_type}I)Landroid/graphics/Bitmap;\nmove-result-object v2\nconst v3, ${paint_color}\nconst/16 v1, ${mask}\nconst/4 v0, 0\n' +
				'invoke-static {v2, v3, v1, v0}, ${main_type}->rounded(Landroid/graphics/Bitmap;III)V\n'
		} else {
			cases += 'const/4 v1, 0\ninvoke-static {v0, v1}, ${main_type}->expectShape(${drawable_type}Z)V\n'
			if name == 'paint_padding' {
				cases += 'new-instance v1, Landroid/graphics/Rect;\ninvoke-direct {v1}, Landroid/graphics/Rect;-><init>()V\n' +
					'invoke-virtual {v0, v1}, ${drawable_type}->getPadding(Landroid/graphics/Rect;)Z\nmove-result v2\nconst/4 v3, 1\ninvoke-static {v2, v3}, ${main_type}->expectInt(II)V\n'
				for i, field in ['left', 'top', 'right', 'bottom'] {
					cases += 'iget v2, v1, Landroid/graphics/Rect;->${field}:I\nconst/4 v3, ${i + 1}\ninvoke-static {v2, v3}, ${main_type}->expectInt(II)V\n'
				}
			}
			cases += 'const/4 v1, 0\ninvoke-static {v0, v1}, ${main_type}->render(${drawable_type}I)Landroid/graphics/Bitmap;\nmove-result-object v2\nconst v3, ${paint_color}\n' +
				'invoke-static {v2, v3, v1}, ${main_type}->rectangle(Landroid/graphics/Bitmap;II)V\n'
		}
	}
	return method('private static inflate(Landroid/content/res/Resources;I)${drawable_type}', 4, '
invoke-virtual {p0, p1}, Landroid/content/res/Resources;->getXml(I)Landroid/content/res/XmlResourceParser;
move-result-object v0
:next_tag
invoke-interface {v0}, Lorg/xmlpull/v1/XmlPullParser;->next()I
move-result v1
const/4 v2, 1
if-eq v1, v2, :missing_tag
const/4 v2, 2
if-ne v1, v2, :next_tag
invoke-static {v0}, Landroid/util/Xml;->asAttributeSet(Lorg/xmlpull/v1/XmlPullParser;)Landroid/util/AttributeSet;
move-result-object v1
new-instance v2, ${drawable_type}
const v3, ${paint_color}
invoke-direct {v2, v3}, ${drawable_type}-><init>(I)V
const/4 v3, 0
:inflate_start
invoke-virtual {v2, p0, v0, v1, v3}, ${drawable_type}->inflate(Landroid/content/res/Resources;Lorg/xmlpull/v1/XmlPullParser;Landroid/util/AttributeSet;Landroid/content/res/Resources$Theme;)V
:inflate_end
invoke-interface {v0}, Landroid/content/res/XmlResourceParser;->close()V
return-object v2
.catchall {:inflate_start .. :inflate_end} :inflate_failed
:inflate_failed
move-exception v3
invoke-interface {v0}, Landroid/content/res/XmlResourceParser;->close()V
throw v3
:missing_tag
invoke-interface {v0}, Landroid/content/res/XmlResourceParser;->close()V
' + failure('Packaged XML must reach a start tag before END_DOCUMENT')) + method('private static inflation(Landroid/content/res/Resources;)V', 4, cases + 'return-void')
}

fn fixture_sources(ids map[string]string) map[string]string {
	mut text := '.class public final ${main_type}\n.super Landroid/app/Activity;\n.implements Landroid/graphics/drawable/Drawable$Callback;\n.field private invalidations:I\n'
	text += method('public constructor <init>()V', 0, 'invoke-direct {p0}, Landroid/app/Activity;-><init>()V\nreturn-void')
	text += assertions_source() + state_source() + canvas_source() + pixel_assertions_source() + pixel_cases_source() + inflation_source(ids)
	text += method('public onCreate(Landroid/os/Bundle;)V', 3, '
invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
:test_start
invoke-direct {p0}, ${main_type}->state()V
invoke-static {}, ${main_type}->pixelCases()V
invoke-virtual {p0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;
move-result-object v0
invoke-static {v0}, ${main_type}->inflation(Landroid/content/res/Resources;)V
:test_end
sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
const-string v1, "${pass_marker}"
invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V
new-instance v0, Landroid/widget/TextView;
invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
const-string v1, "Paint drawable state and pixels passed"
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
