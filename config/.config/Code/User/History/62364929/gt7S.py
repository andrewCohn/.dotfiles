import sys

def print_unicode_range(start, end):
    for i in range(start, end + 1):
        try:
            sys.stdout.write(chr(i))
        except UnicodeEncodeError:
            sys.stdout.write("??")
        sys.stdout.flush()

start = 0x0000  # Start of Unicode range
end = 0xFFFF    # End of Unicode range

print_unicode_range(start, end)
