extern crate elayr;

use std::io::{self, Read};
use elayr::{xml_doc, Node};

pub fn main() {
    let mut buffer = Vec::new();
    io::stdin().read_to_end(&mut buffer).unwrap();
    let doc = xml_doc(buffer.as_slice())
        .to_full_result()
        .expect("Failed to parse document");
    let svg = Node::from_xml_doc(doc).expect("XML doc is not valid SVG");
    println!("{}", svg);
}
