use std::{fs, io::{self, Write}};
use mlua::{prelude::*, UserData, FromLua, UserDataMethods, Function, Value, Vector};

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
        match lua.load(input).eval::<Value>() {
            Ok(value) => {
                println!("{:#?}", value);
            },
            Err(error) => {
                println!("ERROR: {:?}", error);
            }
        }
    }

    Ok(())
}