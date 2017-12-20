#[macro_use]
extern crate nom;
extern crate utf8_ranges;

mod parser;

pub use parser::xml_doc;
