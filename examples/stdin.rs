extern crate elayr;

use std::io::{self, Read};
use elayr::{xml_doc, Node};

pub fn main() {
    let mut buffer = Vec::new();
    io::stdin().read_to_end(&mut buffer).unwrap();
    let doc = xml_doc(buffer.as_slice());
    let svg = Node::from_xml_doc(doc.unwrap().1);
    println!("{:?}", svg);
}
