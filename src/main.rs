use std::io::{self, Write};

fn main() {
    let mut input = String::new();
    print!("> ");
    io::stdout().flush().unwrap();

    io::stdin()
        .read_line(&mut input)
        .expect("Failed to read line");

    let trimmed_input = input.trim();

    println!("You said: {}", trimmed_input);
}