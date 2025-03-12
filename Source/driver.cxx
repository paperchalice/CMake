#include "cmConfigure.h" // IWYU pragma: keep

#include <initializer_list>
#include <iostream>
#include <string>
#include <unordered_map>
#include <cm/filesystem>

#ifdef __APPLE__
#  include <unistd.h>
#endif

#ifdef _WIN32
#  include <Windows.h>
#endif

#define CMAKE_TOOL(NAME, ENTRY) extern "C" int ENTRY(int, char const* const*);
#include "cmake-tools.def"

#ifdef CMake_HAS_GUI
static bool isLaunchedFromDesktop()
{
#  ifdef __APPLE__
  return getppid() == 1;
#  endif
#  ifdef _WIN32
  bool attachResult = AttachConsole(ATTACH_PARENT_PROCESS);
  if(attachResult) {
    freopen("CONOUT$", "w", stdout);
    freopen("CONOUT$", "w", stderr);
  }
  return !attachResult;
#  endif
  return false;
}
#endif

static std::unordered_map<std::string, int (*)(int, char const* const*)>
  knownTools = {
#define CMAKE_TOOL(NAME, ENTRY) { NAME, &ENTRY },
#include "cmake-tools.def"
  };

static void printAvailableTools()
{
  std::cerr << "Available tools:\n";
#define CMAKE_TOOL(NAME, ENTRY) std::cerr << "  " << NAME << '\n';
#include "cmake-tools.def"
}

int main(int argc, char const* const* argv)
{
#ifdef CMake_HAS_GUI
  if (isLaunchedFromDesktop()) {
    return cmake_gui_main(argc, argv);
  }
#endif

  auto toolName = cm::filesystem::path(argv[0]).stem();
  int (*entry)(int, char const* const*) = knownTools[toolName.string()];
  if (entry)
    return entry(argc, argv);

  if (argc < 2) {
    std::cerr << "Usage: cmake-driver <tool> [args]\n";
    printAvailableTools();
    return 1;
  }
  entry = knownTools[argv[1]];
  if (entry)
    return entry(argc - 1, argv + 1);

  std::cerr << "Unrecognized tool: '" << argv[1] << "'\n";
  printAvailableTools();
  return 1;
}
