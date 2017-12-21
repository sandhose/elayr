use parser::{Content, Element, XMLDoc};
use std::fmt;

#[derive(Debug)]
pub struct Root(Vec<Node>);

impl fmt::Display for Root {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        writeln!(f, "Root")?;
        for child in &self.0 {
            child.pretty_print(f, 1)?;
        }
        Ok(())
    }
}

#[derive(Debug)]
pub enum Node {
    Path(String),
    Group(Vec<Node>),
}

impl Node {
    pub fn from_xml_doc(doc: XMLDoc) -> Option<Root> {
        if doc.root.name != String::from("svg") {
            return None;
        }

        Some(Root(Node::list_from_children(doc.root.children)))
    }

    fn list_from_children(children: Vec<Content>) -> Vec<Self> {
        children
            .into_iter()
            .filter_map(|n| match n {
                Content::Element(e) => Some(e),
                _ => None,
            })
            .filter_map(Node::from_xml_node)
            .collect()
    }

    fn from_xml_node(node: Element) -> Option<Self> {
        match node.name.as_str() {
            "g" => Some(Node::Group(Node::list_from_children(node.children))),
            "path" => {
                let attr = node.attributes
                    .into_iter()
                    .find(|a| a.name.as_str() == "d")
                    .map(|a| a.value)
                    .unwrap_or(String::new());
                Some(Node::Path(attr))
            }
            _ => None,
        }
    }

    pub fn pretty_print(&self, f: &mut fmt::Formatter, depth: usize) -> fmt::Result {
        write!(f, "{0:1$}", "", depth * 2)?;
        match self {
            &Node::Path(ref path) => writeln!(f, "Path   {}…", &path[..40])?,
            &Node::Group(ref children) => {
                writeln!(f, "Group")?;
                for child in children {
                    child.pretty_print(f, depth + 1)?
                }
            }
        }

        Ok(())
    }
}
