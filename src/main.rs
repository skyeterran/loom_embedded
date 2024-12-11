use std::{env, fs, io::{self, Write}, sync::{Arc, Mutex}};
use mlua::{prelude::*, UserData, FromLua, UserDataMethods, Function, Value, Vector};
use serde::{Deserialize, Serialize};
use raylib::prelude::*;

#[derive(
    Serialize,
    Deserialize,
    Clone,
    Debug,
    FromLua,
)]
struct Line {
    text: String,
    options: Option<Vec<String>>,
}

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

    let (mut rl, thread) = raylib::init()
        .size(640, 480)
        .title("Hello, World")
        .build();

    let mut line = String::new();
    let mut options: Option<Vec<String>> = None;

    while !rl.window_should_close() {
        let mut d = rl.begin_drawing(&thread);
         
        d.clear_background(Color::WHITE);
        if d.is_key_pressed(KeyboardKey::KEY_SPACE) {
            let x: Line = lua.from_value(lua.load("loom.step(\"yes\")").eval()?)?;
            line = x.text;
            options = x.options;
        }
        let height = 20;
        d.draw_text(&line, 12, 12, height, Color::BLACK);
        if let Some(ref options) = options {
            for (i, text) in options.iter().enumerate() {
                let text = format!("--> {}", text);
                let width = d.measure_text(&text, height);
                let y = (24 * i as i32) + 32;
                if i == 0 {
                    d.draw_rectangle(12, y, width, height, Color::GRAY);
                }
                d.draw_text(&text, 12, y, height, Color::BLACK);
            }
        }
    }

    Ok(())
}