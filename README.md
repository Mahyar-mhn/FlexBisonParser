# FlexBisonParser

This repository provides a simple implementation of a parser using Flex (Lex) and Bison (Yacc). The project demonstrates how to construct a lexer and parser to handle custom syntax or language grammar.

## Features

- **Lexical Analysis**: Tokenizes input using Flex.
- **Syntax Parsing**: Validates and processes syntax using Bison.
- **Extensible**: Easily modify the grammar and token rules to support custom languages.

## Prerequisites

Before running this project, ensure you have the following tools installed:

- [Flex](https://github.com/westes/flex)
- [Bison](https://www.gnu.org/software/bison/)
- GCC or another compatible C/C++ compiler

### Installation on Linux

```bash
sudo apt update
sudo apt install flex bison build-essential
```

### Installation on MacOS

```bash
brew install flex bison
```

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/Mahyar-mhn/FlexBisonParser.git
cd FlexBisonParser
```

### Build the Project

1. Generate the lexer and parser files:

   ```bash
   flex lexer.l
   bison -d parser.y
   ```

2. Compile the generated files with the C compiler:

   ```bash
   gcc -o parser lex.yy.c parser.tab.c -lfl
   ```

### Run the Parser

After building the project, you can test the parser with an input file:

```bash
./parser < input.txt
```

Replace `input.txt` with your test file containing the language or syntax you want to parse.

## File Structure

- `lexer.l`: Contains Flex rules for lexical analysis.
- `parser.y`: Defines the grammar and rules for Bison.
- `input.txt`: Example input file to test the parser.
- `Makefile` (optional): Automates the build process.

## Example Input

Here's an example input file that demonstrates the syntax the parser handles:

```
// Example of a custom syntax
var x = 10;
if (x > 5) {
    print("x is greater than 5");
}
```

## Customization

1. **Modify the Lexer**:
   Edit `lexer.l` to define new tokens or rules.

2. **Extend the Grammar**:
   Update `parser.y` to add or modify grammar rules.

3. **Regenerate Files**:
   After making changes, rerun the `flex` and `bison` commands to regenerate the required files.

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request if you'd like to improve this project.

## License

This project is licensed under the [MIT License](LICENSE).

## Author

- [Mahyar-mhn](https://github.com/Mahyar-mhn)

---

For any questions or feedback, please open an issue or contact the author through the repository.
