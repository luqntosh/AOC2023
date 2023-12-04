package trebuchet

import "core:bytes"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:mem"

main :: proc() {
	filename := "./day1/trebuchet.txt"
	input, success := os.read_entire_file_from_filename(filename)
	defer delete(input)
	if !success {
		fmt.printf("Can't load %s", filename)
		os.exit(1)
	}
	lines := bytes.split(input, []byte{'\n'})

	sum: int

	for line in lines {
		l_digit := -1
		r_digit := -1
		l_index: int
		r_index: int
		for {
			r_index = l_index + 5 < len(line) ? l_index + 5 : len(line)
			l, r := get_digits(line[l_index:r_index])
			if l != -1 {
				l_digit = l
				break
			}
			l_index += 1
            
		}
		l_index = len(line) - 6 > 0 ? len(line) - 6: 0
		r_index = len(line)
		for {
			l, r := get_digits(line[l_index:r_index])
			if r != -1 {
				r_digit = r
                break
			}
			l_index = l_index - 1 > 0 ? l_index - 1 : 0
            r_index -= 1
		}
		fmt.printf("%s %d\n", string(line), l_digit * 10 + r_digit)
        sum += l_digit * 10 + r_digit

	}
    fmt.println(sum)
}

replace_digits :: proc(input: []u8) -> (res: string, err: mem.Allocator_Error) {
	s := string(input)
	defer free_all(context.temp_allocator)
	digits := map[string]string {
		"one"   = "1",
		"two"   = "2",
		"three" = "3",
		"four"  = "4",
		"five"  = "5",
		"six"   = "6",
		"seven" = "7",
		"eight" = "8",
		"nine"  = "9",
	}
	for k, v in digits {
		s, _ = strings.replace_all(s, k, v, context.temp_allocator)
	}
	output, e := strings.clone(s)
    if e != nil {
        return "", err
    }
	return output, nil
}

get_digits :: proc(input: []u8) -> (l, r: int) {
	l = -1
	r = -1
	replaced, err := replace_digits(input)
    defer delete(replaced)
    if err != nil {
        fmt.println(err)
        os.exit(2)
    }
	for char in replaced {
		c := char - 48
		if c < 10 && c >= 0 {
			if l == -1 {
				l = int(c)
			}
			r = int(c)
		}
	}
	return l, r
}
