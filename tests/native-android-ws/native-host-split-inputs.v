// SPDX-License-Identifier: GPL-2.0-or-later
// Retain the actual imported V sources and neighboring native inputs before a
// standalone bootstrap compile; check both originals and copies afterwards.
module main

import crypto.sha256
import json2
import os

fn digest(path string) !string { return sha256.sum(os.read_bytes(path)!).hex() }

fn main() {
	if os.args.len == 3 && os.args[1] == '--check' {
		root := os.args[2]
		pins := json2.decode[map[string]string](os.read_file(root + '/inputs.json')!)!
		assert pins.len > 100, 'complete imported source set required'
		for path, pin in pins {
			assert digest(path)! == pin && digest(root + '/files/' + path.trim_left('/'))! == pin,
				'bootstrap input changed: ' + path
		}
		println('NATIVE-HOST-SPLIT-INPUTS-CHECK-PASS entries=' + pins.len.str())
		return
	}
	assert os.args.len == 4, 'IMPORTED_LISTING PINNED_V FRESH_OUTPUT | --check OUTPUT'
	listing, compiler, root := os.args[1], os.args[2], os.args[3]
	assert os.is_abs_path(root) && !os.exists(root) && !os.is_link(root)
	mut selected := map[string]bool{}
	for path in os.read_file(listing)!.split_into_lines().filter(it.starts_with('/') && it.ends_with('.v')) {
		selected[path] = true
		for name in os.ls(os.dir(path))! {
			if name.ends_with('.c') || name.ends_with('.h') { selected[os.dir(path) + '/' + name] = true }
		}
		mut directory := os.dir(path)
		for directory != '/' {
			if os.is_file(directory + '/v.mod') { selected[directory + '/v.mod'] = true }
			directory = os.dir(directory)
		}
	}
	assert selected.len > 100, 'complete imported source listing required'
	for path in [listing, compiler, os.real_path(os.executable()), os.abs_path(@FILE)] { selected[path] = true }
	mut pins := map[string]string{}
	for path, _ in selected {
		assert os.real_path(path) == path && os.lstat(path)!.get_filetype() == .regular,
			'canonical regular bootstrap input required: ' + path
		pins[path] = digest(path)!
	}
	os.mkdir_all(root + '/files')!
	for path, pin in pins {
		copy := root + '/files/' + path.trim_left('/')
		os.mkdir_all(os.dir(copy))!
		os.cp(path, copy)!
		assert digest(path)! == pin && digest(copy)! == pin, 'bootstrap copy differs'
	}
	os.write_file(root + '/inputs.json', json2.encode(pins, prettify: true) + '\n')!
	println('NATIVE-HOST-SPLIT-INPUTS-PASS entries=' + pins.len.str())
}
