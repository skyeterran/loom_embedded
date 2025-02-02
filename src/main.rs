use std::{env, fs, io::{self, Write}, iter::empty};
use mlua::{prelude::*, Value};

fn main() -> LuaResult<()> {
    let args: Vec<String> = env::args().collect();
    let Some(source_file) = args.get(1) else {
        return Err(LuaError::runtime(format!("No source file specified")));
    };

    // Lua environment
    let source = fs::read_to_string(source_file).unwrap();
    let lua = Lua::new();
    let globals = lua.globals();
    lua.load(source).exec()?;
    lua.load("loom.run(start)").exec()?;

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
            if input.is_empty() {
                match lua.load("loom.step()").eval::<Value>() {
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
    }

    Ok(())
}