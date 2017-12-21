#[macro_use]
extern crate nom;
extern crate utf8_ranges;

mod parser;
mod svg;

use std::ffi::CStr;
use std::os::raw::c_char;

pub use parser::xml_doc;
pub use svg::Node;

#[no_mangle]
pub fn pretty_print(ptr: *const c_char) {
    let input = unsafe { CStr::from_ptr(ptr) };

    let doc = xml_doc(input.to_bytes())
        .to_full_result()
        .expect("Failed to parse document");

    let svg = Node::from_xml_doc(doc).expect("XML doc is not valid SVG");
    println!("{}", svg);
}
