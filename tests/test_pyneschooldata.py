"""
Tests for pyneschooldata Python wrapper.

Minimal smoke tests - the actual data logic is tested by R testthat.
These just verify the Python wrapper imports and exposes expected functions.
"""

import pytest


def test_import_package():
    """Package imports successfully."""
    import pyneschooldata
    assert pyneschooldata is not None


def test_has_fetch_enr():
    """fetch_enr function is available."""
    import pyneschooldata
    assert hasattr(pyneschooldata, 'fetch_enr')
    assert callable(pyneschooldata.fetch_enr)


def test_has_get_available_years():
    """get_available_years function is available."""
    import pyneschooldata
    assert hasattr(pyneschooldata, 'get_available_years')
    assert callable(pyneschooldata.get_available_years)


def test_has_version():
    """Package has a version string."""
    import pyneschooldata
    assert hasattr(pyneschooldata, '__version__')
    assert isinstance(pyneschooldata.__version__, str)
