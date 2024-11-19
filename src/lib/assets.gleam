import decode/zero
import gleam/dict
import gleam/io
import gleam/json
import simplifile

pub fn read_vite_manifest() {
  let filepath = "./dist/.vite/manifest.json"
  let assert Ok(content) = simplifile.read(from: filepath)
  decode_manifest(content)
  |> io.debug()
}

pub fn decode_manifest(str: String) {
  let entry_decoder = {
    use file <- zero.field("file", zero.string)
    use name <- zero.field("name", zero.string)
    use src <- zero.field("src", zero.string)
    use is_entry <- zero.field("isEntry", zero.bool)
    zero.success(ViteManifestEntry(file:, name:, src:, is_entry:))
  }

  let manifest_decoder = zero.run(_, zero.dict(zero.string, entry_decoder))
  json.decode(from: str, using: manifest_decoder)
}

pub type ViteManifest =
  dict.Dict(String, ViteManifestEntry)

pub type ViteManifestEntry {
  ViteManifestEntry(file: String, name: String, src: String, is_entry: Bool)
}
