package trebuchet

import "core:os"
import "core:fmt"
import "core:bytes"


main:: proc() {
    filename := "./day1/trebuchet.txt"
    input, success := os.read_entire_file_from_filename(filename)
    defer delete(input)
    if !success {
        fmt.printf("Can't load %s", filename)
        os.exit(1)
    }
    lines := bytes.split_after(input, []u8{'\n'})
    defer delete(lines)
    sum : int

    for line in lines {
        first_digit := -1
        last_digit := -1
        for char in line {
            c := char - 48
            if c < 10 && c >= 0 {
                if first_digit == -1 {
                    first_digit = int(c)
                }
                last_digit = int(c)
            }
        }
        sum += first_digit * 10 + last_digit
    }
    fmt.println(sum)
}
