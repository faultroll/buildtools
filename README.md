
## 目标
- 传入host/target等参数自动生成toolchain

## 例子
- https://gitee.com/openharmony/third_party_gn
- https://github.com/timniederhausen/gn-build

## 几个问题
- libc版本过低（复制新的库与动态库解析器，使用高版本的动态库解析器执行程序）: https://blog.csdn.net/Longyu_wlz/article/details/108023117
- complete_static_lib（static库包含所有deps）: https://codereview.chromium.org/565283002/diff/60001/tools/gn/variables.cc
- -Wl,--whole-archive 和 -Wl,–start-group 等要把库包含进去的 ldflags
- 动态库链接静态库
- gn deps不能共享include_dirs，这个不是gn的问题，而是工程管理的问题，如果以子目录为单元，其他目录头文件应该是../xxx.h，如果以父目录为单元，应该是xxx/xxx.h，无论如何都不会是xxx.h

## TODOs
- 根据不同host和target定toolchain中command的cc/cxx/stamp/copy/...，当然用户也可以在此基础上传入需要的参数
