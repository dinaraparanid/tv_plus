# tv_plus

[![Unit Tests](https://github.com/dinaraparanid/tv_plus/actions/workflows/unit_test.yml/badge.svg)](https://github.com/dinaraparanid/tv_plus/actions/workflows/unit_test.yml) [![SonarQube](https://github.com/dinaraparanid/tv_plus/actions/workflows/sonar_qube.yml/badge.svg)](https://github.com/dinaraparanid/tv_plus/actions/workflows/sonar_qube.yml)

## Developer
[Paranid5](https://github.com/dinaraparanid)

## Smart TV toolkit

This package contains several auxiliary components
for processing input events using the remote control.
It also includes examples of the implementation
of widgets from the design systems
Material (Android TV), Cupertino (Apple TV), Sandstone (LG webOS), and OneUI (Samsung Tizen).

The library is experimental and demonstrates the capabilities
of Flutter for developing smart TV applications.
You can find all the features of this library and usage scenarios
in the [demo application](https://github.com/dinaraparanid/twin-peaks-tv),
which are close to real-world scenarios.

You may also find live demo examples of implemented components [here](/example/assets/video).

### Key features
- Remote control key event processing (up, down, right, left, select, back)
- Support for focus tree hierarchies
- Processing focus states
- Automatic focus capture
- Automatic alignment during scrolling
- Support for Sliver components
