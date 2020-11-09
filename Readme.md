# andumz

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

For Android Data Forensic

The different data storage options available on Android:

- Internal file storage: Store app-private files on the device file system.
- External file storage: Store files on the shared external file system. This is usually for shared user files, such as photos.
- Shared preferences: Store private primitive data in key-value pairs.
- Databases: Store structured data in a private database.


My research https://enderspub.kubertu.com/android-security-research-crypto-wallet-local-storage-attack


# Usage

```
-ls                   : List installed package
-p <packagename>      : Check if sensitive data stored in internal & external data
-h                    : Help
```

1. Input your strings that you want to search for in creds.txt
2. `./andumz.sh -p <package name>`

Note: Place your strings in creds.txt line by line if you're looking for multiple strings

For example:

Place `password123` in creds.txt 

`./andumz.sh -p com.google.wallet`


# Do-na-te
Just in case you love it!

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=CFLQ8SMJTDQGJ&currency_code=EUR&source=url)
