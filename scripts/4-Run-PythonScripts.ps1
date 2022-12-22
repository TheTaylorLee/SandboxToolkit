# Build Malwoverview
Set-Location $env:userprofile\desktop\github\malwoverview
.\setup.py build
.\setup.py install

# Install pywhat
. "C:\Python311\Scripts\pip3.exe" install pywhat