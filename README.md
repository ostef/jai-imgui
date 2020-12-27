# Dear ImGui for Jai
[Dear ImGui](https://github.com/ocornut/imgui) wrapper for the [Jai](https://youtu.be/TH9VCN6UkyQ) programming language.

## Disclaimer
**The Jai programming language is still in closed beta as of December 27 2020.**

An **ImGui** module is provided with the Jai compiler at the moment but it uses version 1.58 and is incomplete.

The library currently uses a **dll**, which is not necessarily the best choice so we'll eventually change it to link statically if possible. 

## Supported platforms
Currently, only Windows is supported.

## Dependencies
This library is currently dependant on my [linear algebra module](https://github.com/ostef/jai-modules) for `Vec2` and `Vec4` as well as the `Basic` an `Math` modules provided with the Jai compiler.

## Naming
We try to make using the library in Jai as close as possible as using it in C++:
* Jai supports function overloading as well as default parameters, so we use both when **Dear ImGui** does.
* Until better namespacing gets added to the language, we prefix `ImGui::` functions with `ImGui_` and member functions with their enclosing struct name (for example `ImGuiIO_AddInputCharactersUTF8`). This is done so that we can have struct definitions in `module.jai`, which is platform independant, and bindings in `windows.jai`.
* Jai does not have references, so procedures that expect a `const &` parameter are wrapped by a by-value parameter version so that using the API in Jai feels close to using it in C++. Non-const references in C++ translate to pointers in Jai and remain unchanged.

## Documentation
Comments are kept so that the Jai wrapper suffices to get documentation about the API.

## Version
This library uses version [1.79](https://github.com/ocornut/imgui/releases/tag/v1.79) (the latest as of December 27 2020) of **Dear ImGui**. Docking might be added in the future.

Only things in `imgui.h` have been ported, and obsolete procedures are not included and disabled in the `imconfig.h` file.

## Examples
The examples are still being written and will be available here in an examples directory.

## License
We use the same license as **Dear ImGui** which is the **MIT License**.
