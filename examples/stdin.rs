extern crate elayr;

use std::io::{self, Read};
use elayr::xml_doc;

pub fn main() {
    let mut buffer = Vec::new();
    io::stdin().read_to_end(&mut buffer).unwrap();
    let doc = xml_doc(buffer.as_slice());
    println!("{:?}", doc);
}
