#[derive(Debug)]
pub enum Token {
    Symbol(String),
    StringLit(String),
    LParen,
    RParen,
    LBracket,
    RBracket,
    LBrace,
    RBrace,
    Period,
    Comma,
}

enum ParseMode {
    Normal,
    String,
}

// TODO: Multiline comment support
fn remove_comments(source: String) -> String {
    let mut result = String::new();
    let mut last_char: Option<char> = None;
    let mut in_comment = false;
    for c in source.chars() {

        if in_comment {
            if c == '\n' {
                in_comment = false;
            }
        } else {
            if last_char == Some('-') && c == '-' {
                in_comment = true;
                result.pop();
            } else {
                result.push(c);
            }
        }

        last_char = Some(c);
    }
    result
}

pub fn tokenize(source: String) -> Vec<Token> {
    let mut mode = ParseMode::Normal;
    let mut tokens: Vec<Token> = Vec::new();
    let mut current_token = String::new();

    // TODO: Single-quoted strings
    for c in remove_comments(source).chars() {
        match mode {
            ParseMode::Normal => {
                let mut new_token: Option<Token> = None;
                let mut symbol_complete = true;
                match c {
                    '(' => { new_token = Some(Token::LParen); },
                    ')' => { new_token = Some(Token::RParen); },
                    '[' => { new_token = Some(Token::LBracket); },
                    ']' => { new_token = Some(Token::RBracket); },
                    '{' => { new_token = Some(Token::LBrace); },
                    '}' => { new_token = Some(Token::RBrace); },
                    '.' => { new_token = Some(Token::Period); },
                    ',' => { new_token = Some(Token::Comma); },
                    '\"' => { mode = ParseMode::String; },
                    _ => {
                        if !c.is_whitespace() {
                            symbol_complete = false;
                            current_token.push(c);
                        }
                    }
                }
                if symbol_complete && !current_token.is_empty() {
                    tokens.push(Token::Symbol(current_token.clone()));
                    current_token = String::new();
                }
                if let Some(t) = new_token {
                    tokens.push(t);
                }
            },
            ParseMode::String => {
                // TODO: Match single/double-quotes properly
                match c {
                    '\"' => {
                        tokens.push(Token::StringLit(current_token.clone()));
                        current_token = String::new();
                        mode = ParseMode::Normal;
                    },
                    _ => {
                        current_token.push(c);
                    }
                }
            }
        }
    }
    if !current_token.is_empty() {
        match mode {
            ParseMode::Normal => {
                tokens.push(Token::Symbol(current_token.clone()));
            },
            ParseMode::String => {
                tokens.push(Token::StringLit(current_token.clone()));
            }
        }
    }
    tokens
}