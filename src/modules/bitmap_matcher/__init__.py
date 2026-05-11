import importlib.util

from pathlib import Path
import sys

# Define path to the binary
_so_path = Path(__file__).parent / "bitmap_matcher_py39_x86_64.so"

# Load the module
spec = importlib.util.spec_from_file_location("bitmap_matcher", _so_path)
if spec is None or spec.loader is None:
    raise ImportError(f"Could not load bitmap_matcher from {_so_path}")

_bm = importlib.util.module_from_spec(spec)
spec.loader.exec_module(_bm)

# Expose attributes to the package level
__all__ = [name for name in dir(_bm) if not name.startswith('_')]
for name in __all__:
    globals()[name] = getattr(_bm, name)
