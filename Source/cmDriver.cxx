/* Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
   file Copyright.txt or https://cmake.org/licensing for details.  */

#include "cmConfigure.h"

#include <cstddef>
#include <cstring>
#include <iostream>
#include <vector>

#include <cm/filesystem>
#include <cm/string_view>

namespace fs = cm::filesystem;

#define CMAKE_DRIVER_TOOL(name, entry)                                        \
  extern "C" int entry##_main(int ac, char const* const* argv);
#include "cmDriverTools.def"

static int call_tool(const std::string& tool_name, int argc,
                     char const* const* argv)
{
  if (tool_name == "cmake-driver") {
    std::cout << "Usage: cmake-driver --mode=<tool-name> [tool options]\n"
              << "Available tools:\n";
#define CMAKE_DRIVER_TOOL(name, entry) std::cout << "  " << name << "\n";
#include "cmDriverTools.def"
    return 0;
  }

#define CMAKE_DRIVER_TOOL(name, entry)                                        \
  if (tool_name == name)                                                      \
    return entry##_main(argc, argv);
#include "cmDriverTools.def"

  std::cerr << "Failed to determine tool type!\n";
  return 1;
}

int main(int ac, char* av[])
{
  auto tool_name = fs::path(av[0]).stem();
  std::vector<char*> argv;
  int arg_start = 1;
  argv.push_back(av[0]);
  if (tool_name == "cmake-driver" && ac > 1) {
    constexpr cm::string_view mode_opt = "--mode=";
    cm::string_view argv1 = av[1];
    // TODO: Use starts_with.
    if (argv1.size() > mode_opt.size() &&
        argv1.substr(0, mode_opt.size()) == mode_opt) {
      argv1.remove_prefix(mode_opt.size());
      tool_name = argv1;
      arg_start = 2;
    }
  }
  for (int i = arg_start; i != ac; ++i)
    argv.push_back(av[i]);

  int result = call_tool(tool_name, argv.size(), argv.data());
  return result;
}
