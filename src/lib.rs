#[macro_use]
extern crate nom;
extern crate utf8_ranges;

mod parser;
mod svg;

pub use parser::xml_doc;
pub use svg::Node;
