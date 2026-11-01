// SPDX-License-Identifier: GPL-2.0-or-later
// Exercise the emitted host C command and the native helpers it links.
module main

import os

fn main() {
	result := os.exec(['/usr/bin/true'])
	assert result.exit_code == 0 && result.output == '', 'native execute helper'
	println('NATIVE-HOST-SPLIT-PROBE-PASS emitted-C native-helpers clean-exit')
}
