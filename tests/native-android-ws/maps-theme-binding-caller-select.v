// Conservative DEX invoke selector; filtered baksmali proves actual callers.
// Only the admitted Maps DEX members are accepted. Results stay outside Git.
module main

import crypto.sha256
import os

const dex_names = ['classes.dex', 'classes2.dex', 'classes3.dex', 'classes4.dex', 'classes5.dex',
	'classes6.dex', 'classes7.dex', 'classes8.dex', 'classes9.dex', 'classes10.dex']
const dex_pins = ['4429362673fedd46e16859cecb91d120a145625492f386a2dcec381c259dcf0c',
	'3754f7430a6083bdac5202b97965d55e16f1c31b44bdaf023472bdc61ee1efed',
	'ff22b298e6a0730667aeb06dc52fc874e4eb4c6cf0e1f412f9578b603619c232',
	'8bf29e92d95837e8a9236d34cec21fb91c71317dc76a736f819564d5f1bef54a',
	'b5ace2973eddc892ac5e7b02188747db160704f0503edc114c6b8700037e27a3',
	'41825b5d199f79671b25c7efe6ce4b5830ff271c7c9b0f6edf0b0eeba6aa337b',
	'eaba43a436987ede90d2e81aa77975d56129ae97b585105b7fef2126ce730c05',
	'4a4a8adc81245a94c43dcaa9332c7d325487bb178dfe6462c142e03548d49039',
	'bf9c3ece457b8443230dfdd313157bdd157d5aaf83fd7c364a83b8ce01341282',
	'e54d9637080c4bf1342205b57d7917e27c5d25e66209a7168db0631262f0537a']

fn selected_descriptor(descriptor string) bool {
	return descriptor in [
		'Lbrsj;->g(Landroid/content/Context;Lbrqg;Lbtrj;)V',
		'Lbrsj;-><init>(Landroid/content/Context;)V',
		'Lbqpt;-><init>()V',
		'Las;->og(II)V',
		'Ley;->og(II)V',
		'Lbqpt;->og(II)V',
	]
}

fn u16_at(data []u8, at int) int {
	assert at >= 0 && at <= data.len - 2
	return int(data[at]) | int(data[at + 1]) << 8
}

fn u32_at(data []u8, at int) int {
	assert at >= 0 && at <= data.len - 4
	value := u32(data[at]) | u32(data[at + 1]) << 8 | u32(data[at + 2]) << 16 |
		u32(data[at + 3]) << 24
	assert value <= 0x7fffffff
	return int(value)
}

fn uleb(data []u8, mut at &int) int {
	mut value := u32(0)
	for shift in [0, 7, 14, 21, 28] {
		assert *at >= 0 && *at < data.len
		byte := data[*at]
		unsafe { *at += 1 }
		assert shift < 28 || byte < 8
		value |= u32(byte & 127) << u32(shift)
		if byte & 128 == 0 {
			return int(value)
		}
	}
	panic('invalid DEX ULEB')
}

fn dex_string(data []u8, index int) string {
	assert index >= 0 && index < u32_at(data, 56)
	mut at := u32_at(data, u32_at(data, 60) + index * 4)
	uleb(data, mut &at)
	start := at
	for at < data.len && data[at] != 0 {
		at++
	}
	assert at < data.len
	return data[start..at].bytestr()
}

fn dex_type(data []u8, index int) string {
	assert index >= 0 && index < u32_at(data, 64)
	return dex_string(data, u32_at(data, u32_at(data, 68) + index * 4))
}

fn method_descriptor(data []u8, index int) string {
	assert index >= 0 && index < u32_at(data, 88)
	at := u32_at(data, 92) + index * 8
	owner := dex_type(data, u16_at(data, at))
	name := dex_string(data, u32_at(data, at + 4))
	proto := u16_at(data, at + 2)
	assert proto < u32_at(data, 72)
	proto_at := u32_at(data, 76) + proto * 12
	parameters := u32_at(data, proto_at + 8)
	mut descriptor := owner + '->' + name + '('
	if parameters != 0 {
		count := u32_at(data, parameters)
		assert count <= 256
		for parameter in 0 .. count {
			descriptor += dex_type(data, u16_at(data, parameters + 4 + parameter * 2))
		}
	}
	return descriptor + ')' + dex_type(data, u32_at(data, proto_at + 4))
}

// Every real standard invoke has this shape. Scanning all code units can also
// select operand false positives, so a candidate is never reported as a caller.
fn candidate_targets(code []u8, targets map[int]string) []int {
	assert code.len % 2 == 0
	mut found := []int{}
	if code.len < 4 {
		return found
	}
	for at := 0; at <= code.len - 4; at += 2 {
		opcode := code[at]
		if (opcode >= 0x6e && opcode <= 0x72) || (opcode >= 0x74 && opcode <= 0x78) {
			index := u16_at(code, at + 2)
			if index in targets && index !in found {
				found << index
			}
		}
	}
	return found
}

fn scan(path string, pin string) ! {
	data := os.read_bytes(path)!
	actual := sha256.sum(data).hex()
	assert actual == pin, 'pinned DEX mismatch: ' + path
	assert data.len >= 112 && data[..4] == 'dex\n'.bytes()
	assert u32_at(data, 32) == data.len && u32_at(data, 36) == 112
	assert u32_at(data, 40) == 0x12345678
	println('DEX ' + path + ' SHA256 ' + actual)
	mut targets := map[int]string{}
	for index in 0 .. u32_at(data, 88) {
		descriptor := method_descriptor(data, index)
		if selected_descriptor(descriptor) {
			targets[index] = descriptor
			println('TARGET-METHOD ' + index.str() + ' ' + descriptor)
		}
	}
	mut selected := []string{}
	for index in 0 .. u32_at(data, 96) {
		class_at := u32_at(data, 100) + index * 32
		mut at := u32_at(data, class_at + 24)
		if at == 0 {
			continue
		}
		static_fields, instance_fields := uleb(data, mut &at), uleb(data, mut &at)
		direct_methods, virtual_methods := uleb(data, mut &at), uleb(data, mut &at)
		for _ in 0 .. static_fields + instance_fields {
			uleb(data, mut &at)
			uleb(data, mut &at)
		}
		mut matches := false
		for method_count in [direct_methods, virtual_methods] {
			mut method_id := 0
			for _ in 0 .. method_count {
				method_id += uleb(data, mut &at)
				uleb(data, mut &at)
				code := uleb(data, mut &at)
				if code == 0 {
					continue
				}
				units := u32_at(data, code + 12)
				start := code + 16
				assert units <= (data.len - start) / 2
				for target in candidate_targets(data[start..start + units * 2], targets) {
					matches = true
					println('CANDIDATE-METHOD ' + method_descriptor(data, method_id) + ' TARGET ' + targets[target])
				}
			}
		}
		if matches {
			selected << dex_type(data, u32_at(data, class_at))
			assert selected.len <= 64, 'bounded selected-class disassembly'
		}
	}
	println('CLASSES ' + selected.join(','))
}

fn self_test() {
	assert selected_descriptor('Lbrsj;->g(Landroid/content/Context;Lbrqg;Lbtrj;)V')
	assert selected_descriptor('Lbrsj;-><init>(Landroid/content/Context;)V')
	assert selected_descriptor('Lbqpt;-><init>()V')
	assert selected_descriptor('Las;->og(II)V')
	assert selected_descriptor('Ley;->og(II)V')
	assert selected_descriptor('Lbqpt;->og(II)V')
	for descriptor in [
		'Lbrsj;->g(Landroid/content/Context;)V',
		'Lbrsj;->g(Landroid/content/Context;Lbrqg;Lbtrj;)I',
		'Lbrsj;-><init>(Laspx;Lawzl;)V',
		'Lbrsi;-><init>(Landroid/content/Context;)V',
		'Las;->og(I)V',
		'Las;->og(II)I',
		'Lbqpx;->og(II)V',
	] {
		assert !selected_descriptor(descriptor)
	}
	targets := {
		0x1234: 'first'
		0x4321: 'second'
	}
	assert candidate_targets([]u8{}, targets).len == 0
	assert candidate_targets([u8(0x6e), 0], targets).len == 0
	assert candidate_targets([u8(0x6e), 0x10, 0x34, 0x12, 0, 0], targets) == [0x1234]
	assert candidate_targets([u8(0x76), 1, 0x21, 0x43, 0, 0], targets) == [0x4321]
	assert candidate_targets([u8(0x6d), 0, 0x34, 0x12, 0, 0], targets).len == 0
	assert candidate_targets([u8(0x6e), 0, 0x35, 0x12, 0, 0], targets).len == 0
	assert candidate_targets([u8(0x6e), 0, 0x34, 0x12, 0x6e, 0, 0x34, 0x12], targets) == [0x1234]
	assert u16_at([u8(0x34), 0x12], 0) == 0x1234
	assert u32_at([u8(0x78), 0x56, 0x34, 0x12], 0) == 0x12345678
	mut position := 0
	assert uleb([u8(0xe5), 0x8e, 0x26], mut &position) == 624485
	assert position == 3
	println('PASS exact theme-binding selectors and conservative invoke controls')
}

fn main() {
	if os.args.len == 2 && os.args[1] == '--self-test' {
		self_test()
		return
	}
	assert os.args.len == 2, 'usage: selector PINNED_DEX_DIRECTORY | --self-test'
	root := os.real_path(os.args[1])
	for index, name in dex_names {
		scan(os.join_path(root, name), dex_pins[index])!
	}
}
