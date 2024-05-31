from argparse import ArgumentParser, Namespace
from pathlib import Path
from shutil import copy

import regex
from toolz.functoolz import compose_left, curry, pipe

MAKE_MUSIC_RE = regex.compile(r"(?s)(?<=make-music)\s*(?='[A-Z]\w+)")
CONDENSE_LINES_RE = regex.compile(r"(?s)(?<='[a-z\-]+)\s+(?=('\w+)|#|\d|('?\())")

transform_contents = compose_left(curry(MAKE_MUSIC_RE.sub, ' '),
                                  curry(CONDENSE_LINES_RE.sub, ' '))

def setup_command_line() -> Namespace:
    parser = ArgumentParser()
    parser.add_argument('scheme_file', type=Path)
    return parser.parse_args()

def main():
    command_line_args: Namespace = setup_command_line()
    scheme_file: Path = command_line_args.scheme_file
    backup_file = scheme_file.with_suffix(f'{scheme_file.suffix}.backup')   
    copy(scheme_file, backup_file)
    transformed_contents = pipe(scheme_file.read_text(), transform_contents)
    scheme_file.write_text(transformed_contents)

if __name__ == '__main__':
    main()

