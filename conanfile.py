import os
import shutil
from conans import ConanFile, AutoToolsBuildEnvironment, tools


VERSION = "3.16.1"
DIR_NAME = "base-" + VERSION
# Binaries to include in package
BINS = ("caget", "cainfo", "camonitor", "caput")


class EpicsbaseConan(ConanFile):
    name = "epics-base"
    version = VERSION
    license = "BSD 2-Clause"
    url = "https://github.com/ess-dmsc/conan-epics-base"
    description = "EPICS Base"
    exports = "files/*"
    settings = "os", "compiler"
    generators = "cmake"

    def source(self):
        tools.download(
            "https://www.aps.anl.gov/epics/download/base/{}.tar.gz".format(DIR_NAME),
            "{}.tar.gz".format(DIR_NAME)
        )
        tools.check_sha256(
            "{}.tar.gz".format(DIR_NAME),
            "fc01ff8505871b9fa7693a4d5585667587105f34ec5e16a207d07b704d1dc5ed"
        )
        tools.unzip("{}.tar.gz".format(DIR_NAME))
        os.unlink("{}.tar.gz".format(DIR_NAME))

    def build(self):
        if tools.os_info.is_linux:
            self._add_linux_config(DIR_NAME)
        elif tools.os_info.is_macos:
            self._add_darwin_config(DIR_NAME)

        with tools.chdir(DIR_NAME):
            env_build = AutoToolsBuildEnvironment(self)
            env_build.make()

    def _add_linux_config(self, path_to_src):
        shutil.copyfile(
            os.path.join(self.conanfile_directory, "files", "CONFIG_SITE.local.linux"),
            os.path.join(DIR_NAME, "configure", "CONFIG_SITE.local")
        )
        tools.replace_in_file(
            os.path.join(DIR_NAME, "configure", "os", "CONFIG_SITE.Common.linux-x86_64"),
            "COMMANDLINE_LIBRARY = READLINE",
            "COMMANDLINE_LIBRARY = EPICS"
        )

    def _add_darwin_config(self, path_to_src):
        shutil.copyfile(
            os.path.join(self.conanfile_directory, "files", "CONFIG_SITE.local.darwin"),
            os.path.join(DIR_NAME, "configure", "CONFIG_SITE.local")
        )
        os.remove(os.path.join(DIR_NAME, "configure", "os", "CONFIG_SITE.darwinCommon.darwinCommon"))
        shutil.copyfile(
            os.path.join(self.conanfile_directory, "files", "CONFIG_SITE.darwinCommon.darwinCommon"),
            os.path.join(DIR_NAME, "configure", "os", "CONFIG_SITE.darwinCommon.darwinCommon")
        )

    def package(self):
        if tools.os_info.is_linux:
            arch = "linux-x86_64"
        elif tools.os_info.is_macos:
            arch = "darwin-x86"

        include_dir = os.path.join(DIR_NAME, "include")
        bin_dir = os.path.join(DIR_NAME, "bin", arch)
        lib_dir = os.path.join(DIR_NAME, "lib", arch)

        for b in BINS:
            self.copy(b, dst="bin", src=bin_dir)
        self.copy("*", dst="include", src=include_dir, excludes="valgrind/*", keep_path=False)
        self.copy("*", dst="lib", src=lib_dir)
        self.copy("pkgconfig/*", dst="lib", src=os.path.join(DIR_NAME, "lib"))

    def package_info(self):
        self.cpp_info.libs = [
            "Com",
            "ca",
            "cas",
            "dbCore",
            "dbRecStd",
            "gdd"
        ]
