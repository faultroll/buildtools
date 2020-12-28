
## purpose

Buildtools is designed to manage toolchains and configs(flags/files/...), this is a learning-buildtools project. the master branch is the source code we use and the buildtool configs of files. and other branches are the buildtools we use.

## buildtools

- makerule(make)

    raw makefiles, simple but ugly, no win support

- cmake(modern cmake)

    old gentalman, stable one

- meson
    
    autoconf next-generation, a bundle of python scripts

- gn

    generate ninja, the 'google' one

## target

```
autoconf's build == host
autoconf's host == target
```

- toolchain
    
    user can just set the target platform/arch/toolchain and file configs to compile or cross-compile, while host platform/arch is autodetect, and the default(or built-in) configs(exclude files) are auto select

- config
    
    user can change configs easily, for one source code multi target
