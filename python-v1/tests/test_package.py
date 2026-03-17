from @ign-var:PACKAGE_NAME@ import greet


def test_greet_returns_expected_message() -> None:
    assert greet("uv") == "Hello, uv!"
