use std::collections::HashMap;
use std::io;
use std::str::FromStr;

type DeviceId = (char, char, char);
type Count = i64;
type Connections = HashMap<DeviceId, Vec<DeviceId>>;
type Cache = HashMap<DeviceId, Count>;

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

fn count_paths(
    from: DeviceId,
    to: DeviceId,
    connections: &Connections,
    cache: &mut Cache,
) -> Count {
    if from == to {
        return 1;
    }

    return match connections.get(&from) {
        Some(outputs) => outputs
            .iter()
            .map(|output| count_paths_cached(*output, to, connections, cache))
            .sum(),
        None => 0,
    };
}

fn compute_and_insert(
    from: DeviceId,
    to: DeviceId,
    connections: &Connections,
    cache: &mut Cache,
) -> Count {
    let computed = count_paths(from, to, connections, cache);
    cache.insert(from, computed);
    return computed;
}

fn count_paths_cached(
    from: DeviceId,
    to: DeviceId,
    connections: &Connections,
    cache: &mut Cache,
) -> Count {
    return match cache.get(&from) {
        Some(already_computed) => *already_computed,
        None => compute_and_insert(from, to, connections, cache),
    };
}

fn main() {
    let connections = parse_input();
    let svr = ('s', 'v', 'r');
    let dac = ('d', 'a', 'c');
    let fft = ('f', 'f', 't');
    let out = ('o', 'u', 't');
    let dac_fft = count_paths(svr, dac, &connections, &mut Cache::new())
        * count_paths(dac, fft, &connections, &mut Cache::new())
        * count_paths(fft, out, &connections, &mut Cache::new());
    let fft_dac = count_paths(svr, fft, &connections, &mut Cache::new())
        * count_paths(fft, dac, &connections, &mut Cache::new())
        * count_paths(dac, out, &connections, &mut Cache::new());
    println!("{:?}", dac_fft + fft_dac);
}
