use std::collections::HashMap;
use std::io;
use std::str::FromStr;

type DeviceId = (char, char, char);
type Connections = HashMap<DeviceId, Vec<DeviceId>>;

fn parse_device_id(source: &str) -> Result<DeviceId, std::char::ParseCharError> {
    return Ok((
        char::from_str(&source[0..1])?,
        char::from_str(&source[1..2])?,
        char::from_str(&source[2..3])?,
    ));
}

fn parse_input() -> Connections {
    let mut output: Connections = HashMap::new();
    let mut input = String::new();
    loop {
        match io::stdin().read_line(&mut input) {
            Ok(n) => {
                if n == 0 {
                    return output;
                }
                let own_device_id = parse_device_id(&input[0..3]).unwrap();
                let mut index = 5;
                let mut other: Vec<DeviceId> = Vec::new();
                while index + 3 < n {
                    other.push(parse_device_id(&input[index..index + 3]).unwrap());
                    index += 4;
                }
                output.insert(own_device_id, other);
                input.clear();
            }
            Err(error) => {
                println!("Error: {error}");
                return output;
            }
        }
    }
}

fn count_paths(from: DeviceId, connections: &Connections) -> i32 {
    if from == ('o', 'u', 't') {
        return 1;
    }

    return match connections.get(&from) {
        Some(outputs) => outputs
            .iter()
            .map(|output| count_paths(*output, connections))
            .sum(),
        None => 0,
    };
}

fn main() {
    let connections = parse_input();
    println!("{:?}", count_paths(('y', 'o', 'u'), &connections));
}
