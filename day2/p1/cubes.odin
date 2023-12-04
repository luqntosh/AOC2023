package cubes

import "core:os"
import "core:fmt"
import "core:bytes"
import "core:unicode"
import "core:strconv"

MAX_RED :: 12
MAX_GREEN :: 13
MAX_BLUE :: 14


main :: proc() {
    filename :: "./day2/input2.txt"
    data, successs := os.read_entire_file_from_filename(filename)
    defer delete(data)
    if !successs {
        fmt.printf("File %s do not exist\n", filename)
        os.exit(1)
    }
    lines := bytes.split(data, []byte{'\n'})

    sum: int
    for line in lines {
        sep := bytes.index(line, {':'})
        id := get_id(line[:sep])
        valid := valid(line[sep+2:])
        fmt.printf("Line %d: %v\n", id, valid)
        if valid do sum += id
    }
    fmt.printf("Sum: %d\n", sum)
    
}

get_id :: proc(data: []byte) -> int {
    start: int
    #reverse for char, index in data {
        if !unicode.is_digit(rune(char)) {
            break
        }
        start = index
        
    }
    id, ok := strconv.parse_int(string(data[start:]))
    if !ok {
        fmt.eprintf("Cannot parse '%s'\n", string(data[start:]))
        os.exit(1)
    }
    return id
}

valid :: proc(data: []byte) -> bool {
    defer free_all(context.temp_allocator)
    sets := bytes.split(data, {';', ' '}, context.temp_allocator)
    for set in sets {
        subset := bytes.split(set[:], {',', ' '}, context.temp_allocator)
        for cubes in subset {
            index := bytes.index(cubes, {' '})
            amnt, ok := strconv.parse_int(string(cubes[:index]))
            if !ok {
                fmt.eprintf("Cannot parse '%s'\n", string(cubes[:index]))
                os.exit(1)
            }
            color := string(cubes[index+1:])
            switch color {
                case "red":
                    if amnt > MAX_RED {
                        return false
                    }
                case "blue":
                    if amnt > MAX_BLUE {
                        return false
                    }
                case "green":
                    if amnt > MAX_GREEN {
                        return false
                    }
            }
        }
      
    }
    return true
}