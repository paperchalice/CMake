/* Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
   file Copyright.txt or https://cmake.org/licensing for details.  */

#include "cmConfigure.h" // IWYU pragma: keep

#include <iostream>
#include <string>
#include <unordered_set>

#include <cm/filesystem>

extern "C" {
#define CMAKE_TOOL(NAME, ENTRY) int ENTRY##_main(int argc, char*[] argv);
#include "cmDriverTools.def"
int preferGuiMacOS(void);
}

namespace {
std::unordered_set<std::string> knowTools = {
#define CMAKE_TOOL(NAME, ENTRY) #NAME,
#include "cmDriverTools.def"
};

void print_help()
{
  std::cerr << "Usage: cmake-driver <tool name> [tool options]\n";
}

int call_tools(const std::string& name, int argc, char* argv[])
{
#define CMAKE_TOOL(NAME, ENTRY)                                               \
  if (name == NAME)                                                           \
    return ENTRY##_main(argc, argv);
#include "cmDriverTools.def"

  std::cerr << "Unknown tool name: " << name << '\n';
  return 1;
}

bool preferGui()
{
#ifdef BUILD_QtDialog
#  ifdef __APPLE__
  return preferGuiMacOS();
#  else
  return false;
#  endif
#endif
}
}

int main(int argc, char* argv[])
{
  const std::string stem = cm::filesystem::path(argv[0]).stem().string();
  if (knowTools.count(stem))
    return call_tools(stem, argc, argv);

#ifdef BUILD_QtDialog
  if (preferGui())
    return cmake_gui_main(argc, argv);
#endif
  // Invoke the driver.
  if (argc > 1) {
    if (std::strcmp("--help", argv[1]) == 0) {
      std::cerr << "Usage: cmake-driver <tool> [options]\n";
      return 0;
    }
    return call_tools(argv[1], argc - 1, argv + 1);
  }
  return 0;
}
