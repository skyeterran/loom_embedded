use std::{env, fs, io::{self, Write}, iter::empty};
use loom_editor::parse::*;

fn main() {
    let args: Vec<String> = env::args().collect();
    let Some(source_file) = args.get(1) else { todo!() };
    let source = fs::read_to_string(source_file).unwrap();

    let tokens = tokenize(source);
    println!("{:?}", tokens);
}