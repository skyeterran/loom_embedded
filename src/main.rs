use std::{env, fs, io::{self, Write}};
use mlua::{prelude::*, Value};
use bevy::prelude::*;

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

    App::new()
        .add_plugins((
            DefaultPlugins.set(WindowPlugin {
                primary_window: Some(Window {
                    resolution: (1280.0, 720.0).into(),
                    title: format!("Loom Demo"),
                    ..default()
                }),
                ..default()
            }),
        ))
        .add_systems(Startup, setup)
        .run();

    /*
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
                lua.load("loom.step()").exec()?;
            } else {
                lua.load(format!("loom.step(\"{}\")", input)).exec()?;
            }
        }
    }
    */

    Ok(())
}

#[derive(Component)]
struct Caption;

fn setup(
    mut commands: Commands,
    asset_server: Res<AssetServer>
) {
    commands.spawn(Camera2d);
    commands.spawn((
        Text::new("Text goes here"),
        TextLayout::new_with_justify(JustifyText::Center),
        Node {
            position_type: PositionType::Relative,
            align_self: AlignSelf::Center,
            justify_self: JustifySelf::Center,
            ..default()
        },
        Caption,
    ));
}