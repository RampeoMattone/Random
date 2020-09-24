// minigrep example as on the rust programming language book

use std::env;
use std::process;
use minigrep::Config;
use minigrep::run as run;

fn main() {
    let config = Config::new(env::args()).unwrap_or_else(|err| {
        eprintln!("Problem parsing arguments: {}", err);
        process::exit(1);
    });
    println!("searching for \"{}\" in \"{}\".", &config.query, &config.path);
    if let Err(e) = run(config) {
        eprintln!("Application error: {}", e);

        process::exit(1);
    }
}

