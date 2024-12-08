use std::{fs, io::{self, Write}};
use mlua::{prelude::*, Value};

fn main() -> LuaResult<()> {
    // Lua environment
    let source = fs::read_to_string("test.luau").unwrap();
    let lua = Lua::new();
    let globals = lua.globals();
    lua.load(source).exec()?;

    loop {
        // User CLI input
        let mut input = String::new();
        print!("> ");
        io::stdout().flush().unwrap();
        io::stdin()
            .read_line(&mut input)
            .expect("Failed to read line");
        let input = input.trim();

        // Run the user input as Lua code
        if input.starts_with('!') {
            match lua.load(&input[1..]).eval::<Value>() {
                Ok(value) => {
                    println!("{:#?}", value);
                },
                Err(error) => {
                    println!("ERROR: {:?}", error);
                }
            }
        } else {
            lua.load(format!("loom.step(\"{}\")", input)).exec()?;
        }
    }

    Ok(())
}