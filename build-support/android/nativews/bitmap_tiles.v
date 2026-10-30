// SPDX-License-Identifier: GPL-2.0-or-later
@[translated]
module atlframework

fn C.fmod(f64, f64) f64

// Tile coordinates have the Canvas origin, independent of Drawable bounds.
// Map a pixel centre to an integer texel before wrapping, including negatives.
// Wire modes deliberately differ from the retained TileMode enum's ordinals:
// 0 = CLAMP (also a null axis), 1 = REPEAT, 2 = MIRROR.
fn ws_bitmap_tile_index(coordinate f32, dimension i32, mode i32) i32 {
	if dimension <= 1 || coordinate != coordinate { return 0 }
	if mode == 0 {
		if coordinate < 0 { return 0 }
		if coordinate >= f32(dimension) { return dimension - 1 }
		return i32(C.floorf(coordinate))
	}
	period := if mode == 2 { f64(dimension) * 2 } else { f64(dimension) }
	mut wrapped := C.fmod(f64(C.floorf(coordinate)), period)
	if wrapped != wrapped { return 0 }
	if wrapped < 0 { wrapped += period }
	// Reflect before the integer conversion: even dimension=INT_MAX cannot
	// overflow a doubled integer period or an intermediate texel index.
	return i32(if mode == 2 && wrapped >= f64(dimension) { period - 1 - wrapped } else { wrapped })
}

// Sample the tiled bitmap once per visible destination pixel. Unlike issuing
// one Canvas call per tile, work is bounded by the real transformed pixel clip,
// even for a one-pixel source and enormous mostly offscreen Drawable bounds.
fn ws_draw_bitmap_tiled(pointer i64, left i32, top i32, right i32, bottom i32, paint_pointer i64, mode_x i32, mode_y i32) {
	unsafe {
		if pointer == 0 || right <= left || bottom <= top
			|| mode_x < 0 || mode_x > 2 || mode_y < 0 || mode_y > 2 { return }
		bitmap := &WsBitmap(pointer)
		if bitmap.width <= 0 || bitmap.height <= 0 { return }
		draw := ws_draw_state()
		l, t, r, b := ws_affine_bounds(draw.transform, f32(left), f32(top), f32(right), f32(bottom))
		if r <= l || b <= t { return }
		mut pixels := bitmap.rgba
		copying := draw.bitmap == pointer
		if copying {
			length := usize(bitmap.row_bytes) * usize(bitmap.height)
			pixels = &u8(C.malloc(length))
			if pixels == nil { return }
			C.memcpy(pixels, bitmap.rgba, length)
		}
		defer { if copying { C.free(pixels) } }
		channels := if bitmap.alpha_only { 1 } else { 4 }
		xfer_mode := if paint_pointer == 0 { i32(3) } else { (&WsPaint(paint_pointer)).xfer_mode }
		for row := t; row < b; row++ {
			for column := l; column < r; column++ {
				px, py, valid := ws_affine_inverse(draw.transform, f32(column) + 0.5, f32(row) + 0.5)
				if !valid || px != px || py != py || px < f32(left) || px >= f32(right)
					|| py < f32(top) || py >= f32(bottom) { continue }
				source_x := ws_bitmap_tile_index(px, bitmap.width, mode_x)
				source_y := ws_bitmap_tile_index(py, bitmap.height, mode_y)
				offset := source_y * bitmap.row_bytes + source_x * channels
				mut color := if bitmap.alpha_only { u32(pixels[offset]) << 24 }
					else { (u32(pixels[offset + 3]) << 24) | (u32(pixels[offset]) << 16) | (u32(pixels[offset + 1]) << 8) | u32(pixels[offset + 2]) }
				if paint_pointer != 0 {
					paint := &WsPaint(paint_pointer)
					if bitmap.alpha_only { color |= paint.color & 0xffffff }
					if paint.filter_mode == 5 {
						color = (((color >> 24) * (paint.filter_color >> 24) / 255) << 24) | (paint.filter_color & 0xffffff)
					}
					color = (((color >> 24) * (paint.color >> 24) / 255) << 24) | (color & 0xffffff)
				}
				if xfer_mode == 6 { ws_bitmap_dst_in(column, row, color >> 24) }
				else { ws_blend(column, row, color, 255) }
			}
		}
	}
}
