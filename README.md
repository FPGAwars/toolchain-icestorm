# Toolchain-icestorm

## Introduction

Static binaries of the **Icestorm** tools (yosys, arachne, icetools and icotools). Packaged for [Apio](https://github.com/FPGAwars/apio) and [Platformio](http://platformio.org/).

## Usage

Run the script `build.sh` selecting the architectures. E.g.

```
bash build.sh "linux_x86_64 linux_armv7l"
```

Target architectures:
* linux_x86_64
* linux_i686
* linux_armv7l
* linux_aarch64
* windows
* darwin

Final packages will be generated in **\_packages/build_ARCH/** directory.

# Documentation

[The project documentation is located in the wiki](https://github.com/FPGAwars/toolchain-icestorm/wiki)

# Authors

* [Jesús Arroyo Torrens](https://github.com/Jesus89)
* [Juan González (Obijuan)](https://github.com/Obijuan)

## License

Licensed under a GPL v2 and [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/)
