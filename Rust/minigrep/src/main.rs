// minigrep example as on the rust programming language book

use std::env;
use std::process;
use minigrep::Config;
use minigrep::run as run;

fn main() {
    let args: Vec<String> = env::args().collect();
    let config = Config::new(&args).unwrap_or_else(|err| {
        println!("Problem parsing arguments: {}", err);
        process::exit(1);
    });
    println!("searching for \"{}\" in \"{}\".", &config.query, &config.path);
    if let Err(e) = run(config) {
        println!("Application error: {}", e);

        process::exit(1);
    }
}

