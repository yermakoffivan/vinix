// Conservative DEX invoke candidate selector; exact baksmali proves callers.
module main
import crypto.sha256
import os

fn u16_at(d []u8, at int) int {
 assert at >= 0 && at <= d.len - 2
 return int(d[at]) | int(d[at+1]) << 8
}
fn u32_at(d []u8, at int) int {
 assert at >= 0 && at <= d.len - 4
 v := u32(d[at]) | u32(d[at+1]) << 8 | u32(d[at+2]) << 16 | u32(d[at+3]) << 24
 assert v <= 0x7fffffff
 return int(v)
}
fn uleb(d []u8, mut at &int) int {
 mut value := u32(0)
 for shift in [0, 7, 14, 21, 28] {
  assert *at >= 0 && *at < d.len
  b := d[*at]
  unsafe { *at += 1 }
  assert shift < 28 || b < 8
  value |= u32(b & 127) << u32(shift)
  if b & 128 == 0 { return int(value) }
 }
 panic('invalid uleb')
}
fn dex_string(d []u8, i int) string {
 assert i >= 0 && i < u32_at(d,56)
 mut at := u32_at(d,u32_at(d,60)+i*4)
 uleb(d,mut &at)
 start := at
 for at < d.len && d[at] != 0 { at++ }
 assert at < d.len
 return d[start..at].bytestr()
}
fn dex_type(d []u8, i int) string {
 assert i >= 0 && i < u32_at(d,64)
 return dex_string(d,u32_at(d,u32_at(d,68)+i*4))
}
fn scan(path string) ! {
 d := os.read_bytes(path)!
 assert d.len >= 112 && d[..4] == 'dex\n'.bytes()
 assert u32_at(d,32) == d.len && u32_at(d,36) == 112 && u32_at(d,40) == 0x12345678
 println('DEX ' + path + ' SHA256 ' + sha256.sum(d).hex())
 mut ids := map[int]bool{}
 for i in 0 .. u32_at(d,88) {
  at := u32_at(d,92)+i*8
  if dex_type(d,u16_at(d,at)) != 'Landroid/text/Layout;' || dex_string(d,u32_at(d,at+4)) != 'getAlignment' { continue }
  proto := u16_at(d,at+2)
  assert proto < u32_at(d,72)
  p := u32_at(d,76)+proto*12
  if dex_type(d,u32_at(d,p+4)) != 'Landroid/text/Layout$Alignment;' { continue }
  parameters := u32_at(d,p+8)
  if parameters != 0 && u32_at(d,parameters) != 0 { continue }
  ids[i] = true
  println('TARGET-METHOD ' + i.str())
 }
 mut selected := []string{}
 for index in 0 .. u32_at(d,96) {
  class_at := u32_at(d,100)+index*32
  mut at := u32_at(d,class_at+24)
  if at == 0 { continue }
  fields_static, fields_instance := uleb(d,mut &at), uleb(d,mut &at)
  direct, virtual := uleb(d,mut &at), uleb(d,mut &at)
  for _ in 0 .. fields_static + fields_instance { uleb(d,mut &at); uleb(d,mut &at) }
  mut hit := false
  for count in [direct,virtual] {
   mut method_id := 0
   for _ in 0 .. count {
    method_id += uleb(d,mut &at)
    uleb(d,mut &at)
    code := uleb(d,mut &at)
    if code == 0 { continue }
    units := u32_at(d,code+12)
    start := code+16
    assert units >= 0 && units <= (d.len-start)/2
    mut method_hit := false
    for i in 0 .. units - 1 {
     op := d[start+i*2]
     if ((op >= 0x6e && op <= 0x72) || (op >= 0x74 && op <= 0x78)) && u16_at(d,start+(i+1)*2) in ids {
      method_hit = true
     }
    }
    if method_hit {
     hit = true
     assert method_id < u32_at(d,88)
     method_at := u32_at(d,92)+method_id*8
     println('CANDIDATE-METHOD ' + dex_type(d,u32_at(d,class_at)) + '->' + dex_string(d,u32_at(d,method_at+4)))
    }
   }
  }
  if hit { selected << dex_type(d,u32_at(d,class_at)) }
 }
 assert selected.len <= 32, 'bounded exact-reference candidate set required'
 println('CLASSES ' + selected.join(','))
}
fn main() {
 assert os.args.len in [2,11], 'one or ten pinned DEX paths required'
 for path in os.args[1..] { scan(os.real_path(path))! }
}

