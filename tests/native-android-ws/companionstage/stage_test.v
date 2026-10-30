// SPDX-License-Identifier: GPL-2.0-or-later
module companionstage

import compress.szip
import crypto.sha256
import os

#include <unistd.h>

fn C.link(&char, &char) int

struct CompanionTestObject {
	dev u64
	inode u64
	uid u32
	gid u32
	mode u32
	nlink u64
	size u64
	kind os.FileType
}

struct CompanionTestRoot {
	dev u64
	inode u64
	uid u32
	gid u32
	mode u32
	kind os.FileType
}

fn companion_test_object(path string) !CompanionTestObject {
	st := os.lstat(path)!
	return CompanionTestObject{st.dev, st.inode, st.uid, st.gid,
		st.mode & 0o7777, st.nlink, st.size, st.get_filetype()}
}

fn companion_test_root_identity(path string) !CompanionTestRoot {
	st := os.lstat(path)!
	return CompanionTestRoot{st.dev, st.inode, st.uid, st.gid,
		st.mode & 0o7777, st.get_filetype()}
}

fn companion_test_digest(path string) !string {
	bytes := os.read_bytes(path)!
	defer { unsafe { bytes.free() } }
	return sha256.sum(bytes).hex()
}

fn companion_test_elf(tag u8) []u8 {
	mut elf := []u8{len: 64, init: tag}
	copy(mut elf, [u8(0x7f), `E`, `L`, `F`, 2, 1])
	elf[18], elf[19] = 183, 0
	return elf
}

fn companion_test_apk(path string, kind string) ! {
	if kind == 'not-zip' {
		os.write_file(path, 'not a ZIP archive')!
		return
	}
	one := companion_test_elf(17)
	two := companion_test_elf(29)
	defer { unsafe { one.free(); two.free() } }
	mut archive := szip.open(path, .no_compression, .write)!
	defer { archive.close() }
	if kind != 'empty-arm' {
		archive.open_entry('lib/arm64-v8a/libdemo-one.so')!
		if kind == 'bad-elf' {
			archive.write_entry('not an ELF library'.bytes())!
		} else if kind == 'wrong-machine' {
			mut wrong := one.clone()
			wrong[18] = 62
			archive.write_entry(wrong)!
			unsafe { wrong.free() }
		} else {
			archive.write_entry(one)!
		}
		archive.close_entry()
		if kind == 'duplicate' {
			archive.open_entry('lib/arm64-v8a/libdemo-one.so')!
			archive.write_entry(two)!
			archive.close_entry()
		} else if kind == 'traversal' {
			archive.open_entry('lib/arm64-v8a/../libescape.so')!
			archive.write_entry(two)!
			archive.close_entry()
		} else if kind == 'valid' {
			archive.open_entry('lib/arm64-v8a/libdemo+two.so')!
			archive.write_entry(two)!
			archive.close_entry()
		} else if kind == 'too-many' {
			for index in 0 .. 256 {
				archive.open_entry('lib/arm64-v8a/libextra' + index.str() + '.so')!
				archive.write_entry(two)!
				archive.close_entry()
			}
		}
	}
	// Other architectures and APK assets never become companion libraries.
	archive.open_entry('lib/x86_64/libforeign.so')!
	archive.write_entry('irrelevant foreign ABI payload'.bytes())!
	archive.close_entry()
	archive.open_entry('assets/private-asset')!
	archive.write_entry('not a native library'.bytes())!
	archive.close_entry()
}

fn companion_test_fixture(name string, kind string) !Config {
	parent := os.getenv('VINIX_COMPANION_STAGE_TEST_ROOT')
	assert parent != '' && os.is_abs_path(parent) && os.is_dir(parent)
	root := parent + '/' + name
	assert !os.exists(root) && !os.is_link(root)
	os.mkdir(root, mode: 0o700)!
	os.mkdir(root + '/apks', mode: 0o700)!
	os.mkdir(root + '/data', mode: 0o700)!
	// This belongs to the later unprivileged primary APK installer. Companion
	// extraction must neither reuse it as a root cache nor alter its contents.
	os.mkdir(root + '/data/native-libraries', mode: 0o700)!
	os.write_file(root + '/data/native-libraries/primary-sentinel', 'preserved primary native cache')!
	os.chmod(root + '/data/native-libraries/primary-sentinel', 0o400)!
	source := root + '/apks/gms.apk'
	companion_test_apk(source, kind)!
	os.chmod(source, 0o400)!
	return Config{
		source: source
		sha256: companion_test_digest(source)!
		data: root + '/data'
		scratch: root + '/scratch'
		source_owner: u32(os.getuid())
		source_group: u32(os.getgid())
		target_uid: u32(os.getuid())
		target_gid: u32(os.getgid())
	}
}

fn companion_assert_primary_cache(config Config) ! {
	assert os.ls(config.data + '/native-libraries')! == ['primary-sentinel']
	assert os.read_file(config.data + '/native-libraries/primary-sentinel')! == 'preserved primary native cache'
	st := os.lstat(config.data + '/native-libraries')!
	assert st.uid == config.target_uid && st.gid == config.target_gid
	assert st.mode & 0o7777 == 0o700
}

fn companion_assert_no_publication(config Config) ! {
	for suffix in ['/_installed_apks_', '/com.google.android.gms_', '/.com.google.android.gms_.pending'] {
		assert !os.exists(config.data + suffix) && !os.is_link(config.data + suffix)
	}
	assert !os.exists(config.scratch) && !os.is_link(config.scratch)
	companion_assert_primary_cache(config)!
}

fn test_companion_exact_publication_preserves_source_and_primary_data() ! {
	config := companion_test_fixture('exact-publication', 'valid')!
	source := companion_test_object(config.source)!
	data := companion_test_root_identity(config.data)!
	cache := companion_test_object(config.data + '/native-libraries/primary-sentinel')!
	result := stage(config)!
	assert result.package_name == 'com.google.android.gms'
	assert result.source_sha256 == config.sha256 && result.apk_sha256 == config.sha256
	assert result.target_uid == config.target_uid && result.target_gid == config.target_gid
	assert result.dir_mode == 0o700 && result.apk_mode == 0o400 && result.lib_mode == 0o500
	assert companion_test_object(config.source)! == source
	assert companion_test_digest(config.source)! == config.sha256
	assert source.nlink == 1
	assert companion_test_root_identity(config.data)! == data
	assert companion_test_object(config.data + '/native-libraries/primary-sentinel')! == cache
	assert !os.exists(config.scratch) && !os.is_link(config.scratch)
	mut entries := os.ls(config.data)!
	entries.sort()
	assert entries == ['_installed_apks_', 'com.google.android.gms_', 'native-libraries']
	for path in [config.data + '/_installed_apks_', config.data + '/com.google.android.gms_',
		config.data + '/com.google.android.gms_/lib'] {
		st := companion_test_object(path)!
		assert st.kind == .directory && st.uid == config.target_uid && st.gid == config.target_gid
		assert st.mode == 0o700
	}
	apk := config.data + '/_installed_apks_/com.google.android.gms.apk'
	published := companion_test_object(apk)!
	assert published.kind == .regular && published.nlink == 1 && published.mode == 0o400
	assert published.uid == config.target_uid && published.gid == config.target_gid
	assert published.dev != source.dev || published.inode != source.inode
	assert companion_test_digest(apk)! == config.sha256
	assert os.ls(config.data + '/_installed_apks_')! == ['com.google.android.gms.apk']
	mut libraries := os.ls(config.data + '/com.google.android.gms_/lib')!
	libraries.sort()
	assert libraries == ['libdemo+two.so', 'libdemo-one.so']
	assert result.native_libraries.len == 2
	for name, tag in {'libdemo-one.so': u8(17), 'libdemo+two.so': u8(29)} {
		library := config.data + '/com.google.android.gms_/lib/' + name
		st := companion_test_object(library)!
		assert st.kind == .regular && st.nlink == 1 && st.mode == 0o500
		assert st.uid == config.target_uid && st.gid == config.target_gid
		expected := companion_test_elf(tag)
		actual := os.read_bytes(library)!
		assert actual == expected
		assert result.native_libraries[name]! == sha256.sum(expected).hex()
		unsafe { expected.free(); actual.free() }
	}
	companion_assert_primary_cache(config)!
}

fn test_companion_bad_native_archives_leave_no_partial_publication() ! {
	for kind in ['bad-elf', 'wrong-machine', 'empty-arm', 'duplicate', 'traversal', 'not-zip', 'too-many'] {
		config := companion_test_fixture('invalid-archive-' + kind, kind)!
		source := companion_test_object(config.source)!
		data := companion_test_root_identity(config.data)!
		mut rejected := false
		stage(config) or { rejected = true }
		assert rejected, kind
		assert companion_test_object(config.source)! == source
		assert companion_test_digest(config.source)! == config.sha256
		assert companion_test_root_identity(config.data)! == data
		companion_assert_no_publication(config)!
		assert !os.exists(os.dir(config.data) + '/libescape.so')
	}
}

fn companion_expect_rejected(config Config) ! {
	mut rejected := false
	stage(config) or { rejected = true }
	assert rejected
}

fn test_companion_source_identity_and_target_ownership_preflights() ! {
	for kind in ['wrong-pin', 'source-owner', 'source-group', 'source-writable',
		'source-hardlink', 'source-symlink', 'source-directory', 'source-empty',
		'source-parent-mode', 'source-parent-symlink', 'target-owner', 'target-group',
		'target-mode', 'target-symlink'] {
		config := companion_test_fixture('preflight-' + kind, 'valid')!
		root := os.dir(config.data)
		mut selected := config
		mut watched := ''
		match kind {
			'wrong-pin' { selected = Config{...config, sha256: '0'.repeat(64)} }
			'source-owner' { selected = Config{...config, source_owner: config.source_owner + 1} }
			'source-group' { selected = Config{...config, source_group: config.source_group + 1} }
			'source-writable' { os.chmod(config.source, 0o600)! }
			'source-hardlink' {
				watched = root + '/source-hardlink.apk'
				assert unsafe { C.link(&char(config.source.str), &char(watched.str)) } == 0
				assert os.lstat(config.source)!.nlink == 2
			}
			'source-symlink' {
				watched = root + '/source-symlink.apk'
				os.symlink(config.source, watched)!
				selected = Config{...config, source: watched}
			}
			'source-directory' {
				watched = root + '/not-an-apk'
				os.mkdir(watched, mode: 0o700)!
				selected = Config{...config, source: watched}
			}
			'source-empty' {
				os.chmod(config.source, 0o600)!
				os.truncate(config.source, 0)!
				os.chmod(config.source, 0o400)!
				selected = Config{...config, sha256: companion_test_digest(config.source)!}
			}
			'source-parent-mode' {
				watched = os.dir(config.source)
				os.chmod(watched, 0o777)!
			}
			'source-parent-symlink' {
				watched = root + '/linked-apks'
				os.symlink(os.dir(config.source), watched)!
				selected = Config{...config, source: watched + '/gms.apk'}
			}
			'target-owner' { selected = Config{...config, target_uid: config.target_uid + 1} }
			'target-group' { selected = Config{...config, target_gid: config.target_gid + 1} }
			'target-mode' { os.chmod(config.data, 0o755)! }
			else {
				watched = root + '/linked-data'
				os.symlink(config.data, watched)!
				selected = Config{...config, data: watched}
			}
		}
		source := companion_test_object(config.source)!
		data := companion_test_root_identity(config.data)!
		original_hash := companion_test_digest(config.source)!
		before := if watched != '' { companion_test_object(watched)! } else { CompanionTestObject{} }
		companion_expect_rejected(selected)!
		assert companion_test_object(config.source)! == source
		assert companion_test_digest(config.source)! == original_hash
		assert companion_test_root_identity(config.data)! == data
		if watched != '' { assert companion_test_object(watched)! == before }
		companion_assert_no_publication(config)!
	}
}

fn test_companion_rejects_unsafe_paths_and_cache_inside_primary_data() ! {
	for kind in ['source-noncanonical', 'source-relative', 'source-control',
		'data-noncanonical', 'scratch-relative', 'scratch-parent', 'cache-inside-data',
		'scratch-parent-symlink'] {
		config := companion_test_fixture('unsafe-' + kind, 'valid')!
		root := os.dir(config.data)
		mut selected := config
		match kind {
			'source-noncanonical' { selected = Config{...config, source: os.dir(config.source) + '//gms.apk'} }
			'source-relative' { selected = Config{...config, source: 'gms.apk'} }
			'source-control' { selected = Config{...config, source: config.source + '\x00unexpected'} }
			'data-noncanonical' { selected = Config{...config, data: config.data + '/.'} }
			'scratch-relative' { selected = Config{...config, scratch: 'scratch'} }
			'scratch-parent' { selected = Config{...config, scratch: root + '/../scratch'} }
			'cache-inside-data' { selected = Config{...config, scratch: config.data + '/root-cache'} }
			else {
				os.mkdir(root + '/real-work', mode: 0o700)!
				os.symlink(root + '/real-work', root + '/linked-work')!
				selected = Config{...config, scratch: root + '/linked-work/cache'}
			}
		}
		source := companion_test_object(config.source)!
		data := companion_test_root_identity(config.data)!
		companion_expect_rejected(selected)!
		assert companion_test_object(config.source)! == source
		assert companion_test_digest(config.source)! == config.sha256
		assert companion_test_root_identity(config.data)! == data
		companion_assert_no_publication(config)!
		assert !os.exists(config.data + '/root-cache')
		if kind == 'scratch-parent-symlink' {
			assert os.is_link(root + '/linked-work')
			assert os.ls(root + '/real-work')!.len == 0
		}
	}
}

fn test_companion_existing_targets_are_preserved_without_partial_work() ! {
	for kind in ['catalog-directory', 'catalog-file', 'package-directory',
		'package-symlink', 'pending-directory', 'scratch-directory'] {
		config := companion_test_fixture('occupied-' + kind, 'valid')!
		root := os.dir(config.data)
		mut occupied := ''
		mut sentinel := ''
		match kind {
			'catalog-directory' {
				occupied = config.data + '/_installed_apks_'
				os.mkdir(occupied, mode: 0o700)!
				sentinel = occupied + '/.com.google.android.gms.apk.pending'
				os.write_file(sentinel, 'existing APK temporary must survive')!
			}
			'catalog-file' {
				occupied = config.data + '/_installed_apks_'
				os.write_file(occupied, 'catalog is already a regular file')!
				sentinel = occupied
			}
			'package-directory' {
				occupied = config.data + '/com.google.android.gms_'
				os.mkdir(occupied, mode: 0o700)!
				sentinel = occupied + '/existing-package'
				os.write_file(sentinel, 'existing package must survive')!
			}
			'package-symlink' {
				occupied = config.data + '/com.google.android.gms_'
				os.mkdir(root + '/existing-package-target', mode: 0o700)!
				sentinel = root + '/existing-package-target/keep'
				os.write_file(sentinel, 'existing symlink target must survive')!
				os.symlink(root + '/existing-package-target', occupied)!
			}
			'pending-directory' {
				occupied = config.data + '/.com.google.android.gms_.pending'
				os.mkdir(occupied, mode: 0o700)!
				sentinel = occupied + '/existing-work'
				os.write_file(sentinel, 'existing pending work must survive')!
			}
			else {
				occupied = config.scratch
				os.mkdir(occupied, mode: 0o700)!
				sentinel = occupied + '/existing-cache'
				os.write_file(sentinel, 'existing scratch cache must survive')!
			}
		}
		before := companion_test_object(occupied)!
		sentinel_before := companion_test_object(sentinel)!
		content := os.read_file(sentinel)!
		source := companion_test_object(config.source)!
		data := companion_test_root_identity(config.data)!
		companion_expect_rejected(config)!
		assert companion_test_object(occupied)! == before
		assert companion_test_object(sentinel)! == sentinel_before
		assert os.read_file(sentinel)! == content
		assert companion_test_object(config.source)! == source
		assert companion_test_digest(config.source)! == config.sha256
		assert companion_test_root_identity(config.data)! == data
		companion_assert_primary_cache(config)!
		for suffix in ['/_installed_apks_', '/com.google.android.gms_', '/.com.google.android.gms_.pending'] {
			path := config.data + suffix
			if path != occupied { assert !os.exists(path) && !os.is_link(path) }
		}
		if kind != 'scratch-directory' { assert !os.exists(config.scratch) && !os.is_link(config.scratch) }
	}
}
