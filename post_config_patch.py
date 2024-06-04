import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--ninja', action='store', dest='ninja', default='C:/Program Files/Microsoft Visual Studio/2022/Enterprise/Common7/IDE/CommonExtensions/Microsoft/CMake/Ninja/ninja.exe')
parser.add_argument('--meson', action='store', dest='meson', default='C:/hostedtoolcache/windows/Python/3.8.1/x64/Scripts/meson.exe')

args = parser.parse_args()

file_path = os.path.abspath(os.path.dirname(__file__))

dav1d_dir = f"{file_path}\\build\\linphone-sdk\\external\\dav1d".replace("\\", "/")
output_dir = f"{file_path}\\build\\OUTPUT".replace("\\", "/")

script_beg = """#!/bin/sh

export PATH="$PATH"

"""

print("Writing EP_dav1d_install.sh")
ep_dav1d_install = open(f"{file_path}\\build\\linphone-sdk\\EP_dav1d_install.sh", "w")  
ep_dav1d_install.writelines([script_beg, f"\"{args.ninja}\" -C \"{dav1d_dir}\" install"])
ep_dav1d_install.close()

print("Writing EP_dav1d_build.sh")
ep_dav1d_build = open(f"{file_path}\\build\\linphone-sdk\\EP_dav1d_build.sh", "w")
ep_dav1d_build.writelines([script_beg, f"\"{args.ninja}\" -C \"{dav1d_dir}\""])
ep_dav1d_build.close()

print("Writing EP_dav1d_configure.sh")
ep_dav1d_config = open(f"{file_path}\\build\\linphone-sdk\\EP_dav1d_configure.sh", "w")
ep_dav1d_config.writelines([script_beg, 
                            f"cd \"{dav1d_dir}\" \n\n",
                            f"\"{args.meson}\" setup ../../../..//linphone-sdk/external/dav1d --buildtype release --prefix \"{output_dir}\" --libdir \"lib\" -Denable_tools=false -Denable_tests=false --default-library=static"])
ep_dav1d_config.close()