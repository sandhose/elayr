use std::str;
use std::str::FromStr;
use nom::{is_alphanumeric, is_alphabetic};

named!(yes_no<bool>,
       alt!(value!(true, tag!("yes")) | 
            value!(false, tag!("no"))));

named!(sd_decl<bool>,
       ws!(preceded!(tag!("standalone="),
                     alt!(delimited!(tag!("\""), yes_no, tag!("\"")) |
                          delimited!(tag!("'"), yes_no, tag!("'"))))));

fn is_enc_name(chr: u8) -> bool {
    is_alphanumeric(chr) || chr == '-' as u8 || chr == '_' as u8 || chr == '.' as u8
}

named!(enc_name<String>,
    map_res!(
        map_res!(
            preceded!(
                peek!(take_while1_s!(is_alphabetic)),
                take_while1_s!(is_enc_name)
             ), 
            str::from_utf8
         ), 
        FromStr::from_str
    )
);

named!(enc_decl<String>,
       ws!(preceded!(tag!("encoding="),
                     alt!(delimited!(tag!("\""), enc_name, tag!("\"")) |
                          delimited!(tag!("'"), enc_name, tag!("'"))))));

fn is_version_num(chr: u8) -> bool {
    is_alphanumeric(chr) || chr == '-' as u8 || chr == '_' as u8 || chr == ':' as u8 ||
    chr == '.' as u8
}

named!(version_num<String>, 
       map_res!(map_res!(take_while1_s!(is_version_num),
                         str::from_utf8),
                FromStr::from_str));

named!(version_decl<String>,
       ws!(preceded!(tag!("version="),
                     alt!(delimited!(tag!("\""), version_num, tag!("\"")) |
                          delimited!(tag!("'"), version_num, tag!("'"))))));

#[derive(Debug, PartialEq)]
pub struct XMLDecl {
    version: String,
    encoding: String,
    standalone: bool,
}

named!(pub xml_decl<XMLDecl>, 
       delimited!(
           tag!("<?xml"),
           do_parse!(
               version: preceded!(tag!(" "), version_decl) >>
               encoding: alt!(preceded!(tag!(" "), enc_decl) | 
                              value!(String::from("UTF-8"))) >>
               standalone: alt!(preceded!(tag!(" "), sd_decl) | 
                                value!(false)) >>
               (XMLDecl { version: version, encoding: encoding, standalone: standalone })
           ),
           tag!("?>"))
       );

#[cfg(test)]
mod tests {
    use nom::IResult;
    use parser::*;

    #[test]
    fn parse_version() {
        assert_eq!(version_decl(b"version='123'"),
                   IResult::Done(&b""[..], String::from("123")));
    }

    #[test]
    fn parse_encoding() {
        assert_eq!(enc_decl(b"encoding='UTF-8'"),
                   IResult::Done(&b""[..], String::from("UTF-8")));
    }

    #[test]
    fn parse_standalone() {
        assert_eq!(sd_decl(b"standalone='yes'"),
                   IResult::Done(&b""[..], true));
        assert_eq!(sd_decl(b"standalone=\"no\""),
                   IResult::Done(&b""[..], false));
    }

    #[test]
    fn parse_xml_decl() {
        assert_eq!(xml_decl(b"<?xml version='1.0' ?>"),
                   IResult::Done(&b""[..], XMLDecl {
                        version: String::from("1.0"),
                        encoding: String::from("UTF-8"),
                        standalone: false
                   }));
    }
}
