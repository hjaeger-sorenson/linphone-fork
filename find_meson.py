import os

for dirpath, dnames, fnames in os.walk("C:\\"):
    for f in fnames:
        if(f == "meson.exe"):
            print(os.path.join(dirpath, f))
            break